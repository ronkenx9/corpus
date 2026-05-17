import type { Address, Hex } from "viem";

export type EntityMetadata = {
  legalName: string;
  jurisdiction: string;
  /** Wyoming Secretary of State filing ID. Empty string = protocol-only formation. */
  filingId: string;
  /** keccak256 of the Articles of Organization PDF (pinned off-chain). */
  articlesHash: Hex;
  /** keccak256 of the Operating Agreement PDF. */
  operatingAgreementHash: Hex;
  /** block.timestamp written at formation. Pass 0 — the contract does not enforce it. */
  formedAt: bigint;
};

export type SpendingPolicy = {
  /** USDC (6 decimals) per UTC day. 0 = no cap. */
  dailyCapUsdc: bigint;
  /** When true, payments only succeed to addresses on the on-chain allowlist. */
  allowlistOnly: boolean;
};

export type FormParams = {
  metadata: EntityMetadata;
  policy: SpendingPolicy;
  principal: Address;
  mediator: Address;
  /** Off-chain metadata for the ERC-8004 identity (ipfs:// or https://). */
  identityMetadataURI: string;
};

export type FormResult = {
  manager: Address;
  identityTokenId: bigint;
  txHash: Hex;
};
