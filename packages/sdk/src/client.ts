import {
  type Address,
  type Hex,
  type PublicClient,
  type WalletClient,
  decodeEventLog,
  parseAbiItem,
  parseEventLogs,
  keccak256,
  toHex,
} from "viem";
import { corpusFactoryAbi, corpusManagerAbi, erc20Abi } from "./abis.js";
import { ARC_TESTNET_ADDRESSES } from "./chains.js";
import type { FormParams, FormResult } from "./types.js";

export type CorpusClientConfig = {
  publicClient: PublicClient;
  walletClient: WalletClient;
  factory: Address;
  /** Defaults to Arc Testnet's canonical USDC. */
  usdc?: Address;
};

/**
 * Thin TypeScript wrapper around the CORPUS contracts. Holds a viem public + wallet client
 * pair and the deployed Factory address. Designed to be embedded inside any agent runtime
 * (server, edge function, or browser).
 */
export class CorpusClient {
  readonly publicClient: PublicClient;
  readonly walletClient: WalletClient;
  readonly factory: Address;
  readonly usdc: Address;

  constructor(cfg: CorpusClientConfig) {
    this.publicClient = cfg.publicClient;
    this.walletClient = cfg.walletClient;
    this.factory = cfg.factory;
    this.usdc = cfg.usdc ?? (ARC_TESTNET_ADDRESSES.usdc as Address);
  }

  /** Form a new CORPUS entity. Returns the manager address + minted identity token ID. */
  async form(params: FormParams): Promise<FormResult> {
    const account = this.walletClient.account;
    if (!account) throw new Error("walletClient.account is required");

    const txHash = await this.walletClient.writeContract({
      account,
      chain: this.walletClient.chain,
      address: this.factory,
      abi: corpusFactoryAbi,
      functionName: "form",
      gas: 600_000n,
      args: [
        {
          legalName: params.metadata.legalName,
          jurisdiction: params.metadata.jurisdiction,
          filingId: params.metadata.filingId,
          articlesHash: params.metadata.articlesHash,
          operatingAgreementHash: params.metadata.operatingAgreementHash,
          formedAt: params.metadata.formedAt,
        },
        {
          dailyCapUsdc: params.policy.dailyCapUsdc,
          allowlistOnly: params.policy.allowlistOnly,
        },
        params.principal,
        params.mediator,
        params.identityMetadataURI,
      ],
    });

    const receipt = await this.publicClient.waitForTransactionReceipt({ hash: txHash });
    const logs = parseEventLogs({
      abi: corpusFactoryAbi,
      eventName: "CorpusFormed",
      logs: receipt.logs,
    });
    if (logs.length === 0) throw new Error("CorpusFormed event not found in receipt");
    const ev = logs[0].args as {
      manager: Address;
      identityTokenId: bigint;
    };
    return { manager: ev.manager, identityTokenId: ev.identityTokenId, txHash };
  }

  /** Execute a USDC payment from the entity's treasury under its spending policy. */
  async pay(manager: Address, counterparty: Address, amount: bigint, memo: string): Promise<Hex> {
    const account = this.walletClient.account;
    if (!account) throw new Error("walletClient.account is required");
    const memoHash = keccak256(toHex(memo));
    return this.walletClient.writeContract({
      account,
      chain: this.walletClient.chain,
      address: manager,
      abi: corpusManagerAbi,
      functionName: "pay",
      args: [counterparty, amount, memoHash],
    });
  }

  /** Read the USDC treasury balance of a manager. */
  async treasuryBalance(manager: Address): Promise<bigint> {
    return this.publicClient.readContract({
      address: manager,
      abi: corpusManagerAbi,
      functionName: "treasuryBalance",
    }) as Promise<bigint>;
  }

  /** Convenience: read the USDC ERC-20 balance of any address. */
  async usdcBalanceOf(addr: Address): Promise<bigint> {
    return this.publicClient.readContract({
      address: this.usdc,
      abi: erc20Abi,
      functionName: "balanceOf",
      args: [addr],
    }) as Promise<bigint>;
  }

  /** Open a dispute against the entity (called by counterparty or principal). */
  async openDispute(manager: Address, counterparty: Address, reason: string): Promise<bigint> {
    const account = this.walletClient.account;
    if (!account) throw new Error("walletClient.account is required");
    const txHash = await this.walletClient.writeContract({
      account,
      chain: this.walletClient.chain,
      address: manager,
      abi: corpusManagerAbi,
      functionName: "openDispute",
      args: [counterparty, reason],
    });
    const receipt = await this.publicClient.waitForTransactionReceipt({ hash: txHash });
    const log = receipt.logs.find((l) => l.address.toLowerCase() === manager.toLowerCase());
    if (!log) throw new Error("openDispute log not found");
    const decoded = decodeEventLog({
      abi: [parseAbiItem("event DisputeOpened(uint256 indexed disputeId, address indexed counterparty, string reason)")],
      data: log.data,
      topics: log.topics,
    });
    return (decoded.args as { disputeId: bigint }).disputeId;
  }
}
