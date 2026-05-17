// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {CorpusFactory} from "../src/CorpusFactory.sol";
import {CorpusManager} from "../src/CorpusManager.sol";
import {ICorpusManager} from "../src/interfaces/ICorpusManager.sol";
import {MockUSDC} from "../src/mocks/MockUSDC.sol";
import {MockIdentityRegistry} from "../src/mocks/MockIdentityRegistry.sol";

contract CorpusFactoryTest is Test {
    CorpusFactory factory;
    MockUSDC usdc;
    MockIdentityRegistry registry;

    address principal = makeAddr("principal");
    address mediator = makeAddr("mediator");
    address counterparty = makeAddr("counterparty");

    function setUp() public {
        usdc = new MockUSDC();
        registry = new MockIdentityRegistry();
        factory = new CorpusFactory(usdc, registry);
    }

    function _baseMetadata() internal pure returns (ICorpusManager.EntityMetadata memory) {
        return ICorpusManager.EntityMetadata({
            legalName: "Loom Trading DAO LLC",
            jurisdiction: "WY",
            filingId: "",
            articlesHash: keccak256("articles.pdf"),
            operatingAgreementHash: keccak256("oa.pdf"),
            formedAt: 0
        });
    }

    function _basePolicy() internal pure returns (ICorpusManager.SpendingPolicy memory) {
        return ICorpusManager.SpendingPolicy({dailyCapUsdc: 1_000_000_000, allowlistOnly: false});
    }

    function test_form_deploysManagerAndMintsIdentity() public {
        (address manager, uint256 tokenId) =
            factory.form(_baseMetadata(), _basePolicy(), principal, mediator, "ipfs://agent-meta");

        assertTrue(manager != address(0));
        assertEq(tokenId, 1);
        assertEq(registry.ownerOf(tokenId), address(factory));

        CorpusManager m = CorpusManager(manager);
        assertEq(m.principal(), principal);
        assertEq(m.mediator(), mediator);
        assertEq(m.identityTokenId(), tokenId);
        assertEq(m.metadata().legalName, "Loom Trading DAO LLC");
    }

    function test_pay_succeedsWithinDailyCap() public {
        (address manager,) =
            factory.form(_baseMetadata(), _basePolicy(), principal, mediator, "ipfs://x");
        CorpusManager m = CorpusManager(manager);

        usdc.mint(manager, 500_000_000);

        vm.prank(principal);
        m.pay(counterparty, 100_000_000, keccak256("invoice-1"));

        assertEq(usdc.balanceOf(counterparty), 100_000_000);
        assertEq(m.todaySpent(), 100_000_000);
    }

    function test_pay_revertsOverDailyCap() public {
        (address manager,) = factory.form(
            _baseMetadata(),
            ICorpusManager.SpendingPolicy({dailyCapUsdc: 50_000_000, allowlistOnly: false}),
            principal,
            mediator,
            "ipfs://x"
        );
        CorpusManager m = CorpusManager(manager);
        usdc.mint(manager, 200_000_000);

        vm.prank(principal);
        vm.expectRevert(CorpusManager.DailyCapExceeded.selector);
        m.pay(counterparty, 60_000_000, keccak256("over"));
    }

    function test_pay_revertsWhenAllowlistOnlyAndNotAllowed() public {
        (address manager,) = factory.form(
            _baseMetadata(),
            ICorpusManager.SpendingPolicy({dailyCapUsdc: 0, allowlistOnly: true}),
            principal,
            mediator,
            "ipfs://x"
        );
        CorpusManager m = CorpusManager(manager);
        usdc.mint(manager, 100_000_000);

        vm.prank(principal);
        vm.expectRevert(CorpusManager.CounterpartyNotAllowed.selector);
        m.pay(counterparty, 1_000_000, keccak256("nope"));
    }

    function test_pay_succeedsAfterAllowlisting() public {
        (address manager,) = factory.form(
            _baseMetadata(),
            ICorpusManager.SpendingPolicy({dailyCapUsdc: 0, allowlistOnly: true}),
            principal,
            mediator,
            "ipfs://x"
        );
        CorpusManager m = CorpusManager(manager);
        usdc.mint(manager, 100_000_000);

        vm.startPrank(principal);
        m.setAllowlist(counterparty, true);
        m.pay(counterparty, 5_000_000, keccak256("ok"));
        vm.stopPrank();

        assertEq(usdc.balanceOf(counterparty), 5_000_000);
    }

    function test_pay_onlyPrincipal() public {
        (address manager,) =
            factory.form(_baseMetadata(), _basePolicy(), principal, mediator, "ipfs://x");
        CorpusManager m = CorpusManager(manager);
        usdc.mint(manager, 100_000_000);

        vm.prank(counterparty);
        vm.expectRevert(CorpusManager.NotPrincipal.selector);
        m.pay(counterparty, 1, bytes32(0));
    }

    function test_dispute_resolveAwardsCounterparty() public {
        (address manager,) =
            factory.form(_baseMetadata(), _basePolicy(), principal, mediator, "ipfs://x");
        CorpusManager m = CorpusManager(manager);
        usdc.mint(manager, 200_000_000);

        vm.prank(counterparty);
        uint256 disputeId = m.openDispute(counterparty, "non-delivery");
        assertEq(disputeId, 1);

        vm.prank(mediator);
        m.resolveDispute(disputeId, 80_000_000, keccak256("evidence.json"));

        assertEq(usdc.balanceOf(counterparty), 80_000_000);
        assertEq(usdc.balanceOf(manager), 120_000_000);
    }

    function test_dispute_onlyMediatorCanResolve() public {
        (address manager,) =
            factory.form(_baseMetadata(), _basePolicy(), principal, mediator, "ipfs://x");
        CorpusManager m = CorpusManager(manager);
        usdc.mint(manager, 100_000_000);

        vm.prank(counterparty);
        uint256 disputeId = m.openDispute(counterparty, "x");

        vm.prank(principal);
        vm.expectRevert(CorpusManager.NotMediator.selector);
        m.resolveDispute(disputeId, 1, bytes32(0));
    }

    function test_dispute_awardCannotExceedAmountAtIssue() public {
        (address manager,) =
            factory.form(_baseMetadata(), _basePolicy(), principal, mediator, "ipfs://x");
        CorpusManager m = CorpusManager(manager);
        usdc.mint(manager, 10_000_000);

        vm.prank(counterparty);
        uint256 disputeId = m.openDispute(counterparty, "x");

        vm.prank(mediator);
        vm.expectRevert(CorpusManager.AwardExceedsClaim.selector);
        m.resolveDispute(disputeId, 11_000_000, bytes32(0));
    }

    function test_rotatePrincipal() public {
        (address manager,) =
            factory.form(_baseMetadata(), _basePolicy(), principal, mediator, "ipfs://x");
        CorpusManager m = CorpusManager(manager);
        address next = makeAddr("next-principal");

        vm.prank(principal);
        m.rotatePrincipal(next);
        assertEq(m.principal(), next);
    }
}
