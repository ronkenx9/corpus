// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {CorpusManager} from "./CorpusManager.sol";
import {ICorpusManager} from "./interfaces/ICorpusManager.sol";
import {IIdentityRegistry} from "./interfaces/IIdentityRegistry.sol";

/// @title CorpusFactory
/// @notice The single entrypoint other apps integrate with. One call deploys a CorpusManager,
///         mints an ERC-8004 identity that points at the manager's metadata, and emits the
///         on-chain Formation event that becomes the entity's machine-readable birth record.
/// @dev    The factory itself owns the minted identity NFT (it called `register` on the
///         IdentityRegistry). For the demo this is fine — the identity exists, is queryable,
///         and is bound by event log to the manager. In a future version the factory should
///         transfer the NFT to the manager so the entity literally holds its own identity.
contract CorpusFactory {
    IERC20 public immutable usdc;
    IIdentityRegistry public immutable identityRegistry;

    /// @notice ERC-721 safe-transfer hook — the ERC-8004 IdentityRegistry safe-mints the
    ///         identity NFT to this contract during `register()`. Returning the magic value
    ///         tells the registry it's safe to mint.
    function onERC721Received(address, address, uint256, bytes calldata)
        external
        pure
        returns (bytes4)
    {
        return this.onERC721Received.selector;
    }

    event CorpusFormed(
        address indexed manager,
        address indexed principal,
        uint256 indexed identityTokenId,
        string legalName,
        string jurisdiction,
        string filingId,
        bytes32 articlesHash,
        bytes32 operatingAgreementHash
    );

    constructor(IERC20 usdc_, IIdentityRegistry identityRegistry_) {
        usdc = usdc_;
        identityRegistry = identityRegistry_;
    }

    /// @notice Form a CORPUS entity in one transaction.
    /// @param md  Entity metadata. `filingId` may be empty for protocol-only formation
    ///            (entity exists on-chain; legal filing is the integrator's responsibility).
    /// @param sp  Initial spending policy.
    /// @param principal_  EOA / smart account that controls the LLC's commercial actions.
    /// @param mediator_   Address authorized to resolve disputes under the Operating Agreement.
    /// @param identityMetadataURI  URI (ipfs:// or https://) describing the agent — passed to
    ///                              the ERC-8004 IdentityRegistry as the agent's metadata.
    function form(
        ICorpusManager.EntityMetadata calldata md,
        ICorpusManager.SpendingPolicy calldata sp,
        address principal_,
        address mediator_,
        string calldata identityMetadataURI
    ) external returns (address manager, uint256 identityTokenId) {
        identityTokenId = identityRegistry.register(identityMetadataURI);

        CorpusManager m = new CorpusManager(usdc);
        m.initialize(md, sp, principal_, mediator_, identityTokenId);
        manager = address(m);

        emit CorpusFormed(
            manager,
            principal_,
            identityTokenId,
            md.legalName,
            md.jurisdiction,
            md.filingId,
            md.articlesHash,
            md.operatingAgreementHash
        );
    }
}
