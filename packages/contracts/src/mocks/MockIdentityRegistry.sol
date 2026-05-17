// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IIdentityRegistry} from "../interfaces/IIdentityRegistry.sol";

/// @notice Local-test stand-in for the Arc ERC-8004 IdentityRegistry. Returns a monotonically
///         increasing tokenId on register() and emits the canonical Transfer event so tests can
///         assert against the same log shape the real registry produces.
contract MockIdentityRegistry is IIdentityRegistry {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    uint256 public nextTokenId = 1;
    mapping(uint256 => address) internal _owners;
    mapping(uint256 => string) internal _uris;

    function register(string calldata metadataURI) external override returns (uint256 tokenId) {
        tokenId = nextTokenId++;
        _owners[tokenId] = msg.sender;
        _uris[tokenId] = metadataURI;
        emit Transfer(address(0), msg.sender, tokenId);
    }

    function tokenURI(uint256 tokenId) external view override returns (string memory) {
        return _uris[tokenId];
    }

    function ownerOf(uint256 tokenId) external view override returns (address) {
        return _owners[tokenId];
    }
}
