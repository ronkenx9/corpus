# PING — Brand Identity

**Status:** v0.1 (source of truth for visual, voice, copy)
**Companion:** [ping-prd.md](./ping-prd.md) (product requirements)

---

## 1 · Positioning

| | |
|---|---|
| **Name** | PING |
| **Tagline** | The wallet you text. |
| **Category** | Conversational finance for Arc. |
| **Pitch line** | Arc made micro-transactions economical. PING makes them human. |
| **User-facing line** | Send, swap, and save with a message. |

### The thesis
PING wins because three things meet for the first time:
1. **Arc** makes micro-transactions economical (sub-cent fees, sub-second finality)
2. **Circle Programmable Wallets** remove the onboarding friction
3. **Messaging apps** make small money movements feel natural

Without any one of the three, conversational finance doesn't work. Together they unlock an interface category that didn't exist before.

### What NOT to call it
Not a "dashboard." Not a "DeFi app." Don't even lead with "wallet."

Call it: **conversational finance for Arc**, or **a text-native wallet agent**.

---

## 2 · Brand Personality

PING should feel:
- fast
- helpful
- casual
- trustworthy
- clean
- social
- smart but not nerdy
- human-first

It should NOT feel like:
- a DeFi terminal
- a crypto bro app
- a corporate banking product
- a generic AI assistant

The reference vibes are: **WhatsApp simplicity + Cash App speed + Arc intelligence.**

---

## 3 · Voice

See [ping-prd.md §17](./ping-prd.md) for the full voice spec with forbidden patterns and allowed patterns. The canonical example:

```
User: Send Ahmed $15
PING:  I found Ahmed. Sending 15 USDC on Arc. Confirm?
User: Yes
PING:  Done. Ahmed received 15 USDC.
       Fee: $0.01   Time: 0.7s
```

Voice rules in one line: **short, clear, calm, not overly friendly. No long explanations unless asked.**

---

## 4 · Visual Identity

### Core metaphor
**Message bubbles as financial rails.** The chat surface is the product. Every visual element ties back to:
- chat bubbles
- instant movement
- micro-payments
- confirmation ticks
- light trails

### Logo

**The PING Bubble:** A rounded chat bubble with a subtle diagonal lightning/arc cut inside it.

- Minimal vector style
- Works as a WhatsApp contact avatar at any size
- One dot or pulse mark optional

**Avoid:** dollar signs, coins, robot heads, AI sparkles, blockchain cubes, complicated wallet icons, speech bubbles with currency symbols inside.

### Logo variants

| Variant | Use |
|---|---|
| Wordmark + bubble mark | Primary lockup |
| Bubble mark only | App icon, contact avatar, favicon |
| White bubble on green/black gradient | WhatsApp / iMessage contact |
| "Paid with PING" badge | Transaction receipts, partner sites |

### Color system

| Role | Name | Hex | Usage |
|---|---|---|---|
| Primary background | Chat Black | `#050607` | App backdrop, hero |
| Primary action | Signal Green | `#20E070` | CTAs, send action, primary buttons |
| Settlement | Arc Blue | `#4D8CFF` | Arc network confirmations, settlement trails |
| Text light | Soft White | `#F5F7FA` | Body copy on dark |
| UI surface | Message Grey | `#1A1F24` | Chat bubbles, panels, cards |
| Success | Success Mint | `#7CFFB2` | Completed payments, positive deltas |
| Warning | Warning Amber | `#FFC857` | Confirmation prompts, risk states |

**Color rules:**
- **Green** = conversation / action
- **Blue** = Arc settlement
- **Mint** = success
- **Amber** = confirmation needed

Never mix green and blue in the same component — they signal different things.

### Typography

- **Sans:** Geist Sans (primary)
- **Mono:** Geist Mono (addresses, amounts, tx hashes)
- **Fallback options:** Inter, Satoshi, General Sans

Geist wins because it's clean enough for fintech, modern enough for agent UX, and readable inside dense chat UI at small sizes.

---

## 5 · Mascot / Contact Identity

No mascot. The product is a contact in your phone, not a character.

The "character" is the conversation itself. The contact avatar is the bubble mark. When the agent is processing, a small animated pulse ring expands around the bubble.

### Contact card

```
PING
Financial agent
[bubble avatar]
```

That's the entire visual identity in someone's address book. It should feel like a person you saved, not an app you downloaded.

---

## 6 · Voice Examples (Full Set)

### Onboarding
```
User: Hi
PING:  Welcome to PING. I can help you send, swap, and save
       USDC on Arc. I'll create your wallet now.

       ✓ Your Arc wallet is ready. No seed phrase needed.

       Try: "send $2 to Tunde" or "show my balance."
```

### Send (canonical)
```
User: send Tunde $5 for coffee
PING:  Sending 5 USDC to Tunde on Arc.
       Fee: $0.01   Arrival: under 1 sec.
       Confirm?
User: yes
PING:  Done.
```

### Send (insufficient balance)
```
User: send sarah $200
PING:  You only have $43.20 — that send needs $200.
       Fund your wallet first.
```

### Yield (FLOAT)
```
User: park my idle money
PING:  Parking 38 USDC in USYC at ~4.2% APY.
       Withdraw anytime. Confirm?
User: yes
PING:  Done. I'll ping you when it grows.

[24h later]
PING:  +$0.06 overnight. Total: 38.06 USDC in FLOAT.
```

### LLC (CORPUS)
```
User: form llc "Coffee Trader LLC"
PING:  Forming Coffee Trader LLC on Arc.
       This deploys your LLC contract + mints your identity NFT.
       Cost: ~$0.11 in gas. Confirm?
User: yes
PING:  ✓ LLC formed.
       Manager: 0x8712…5c87
       Identity NFT #15840 delivered to your wallet.
```

### Out of scope
```
User: short ETH 50x
PING:  Not yet. I do wallet stuff, yield (FLOAT), and LLC ops (CORPUS).
       Type "help" for what's wired up.
```

### Async (inbound payment)
```
PING:  💰 You received $20 USDC from Sarah.
       Balance: $63.20
       Reply "park" to put it in yield.
```

---

## 7 · Confirmation Card Pattern

For richer surfaces (eventually iMessage Apps, share extensions), the confirmation can render as a card:

```
┌──────────────────────────────┐
│  Send 15 USDC to Ahmed       │
│                              │
│  From:    Your Arc wallet    │
│  To:      Ahmed              │
│  Network: Arc                │
│  Fee:     $0.01              │
│  Arrival: under 1 sec        │
│                              │
│  [Send]    [Cancel]          │
└──────────────────────────────┘
```

Card layout:
- Chat Black background
- Message Grey card surface
- Signal Green primary action ([Send])
- Soft White text
- Arc Blue accent on the "Network: Arc" row

---

## 8 · Landing Page Direction

### Hero
- **Headline:** The wallet you text.
- **Subheadline:** PING lets you send, swap, and save on Arc through simple messages.
- **Primary CTA:** Start on iMessage
- **Secondary CTA:** Watch demo
- **Visual:** Phone mockup showing a conversation. Next to it, the transaction rail:
  ```
  Message → Intent → Circle Wallet → Arc Settlement → Receipt
  ```

### Section 2 — The wedge
- **Headline:** Micro-transactions do not belong in dashboards.
- **Visual:** Side-by-side comparison
  - Dashboard flow: Open app → connect wallet → select token → paste address → approve → wait
  - PING flow: Text "send Ahmed $2" → confirm → done

### Section 3 — Use cases
- **Headline:** Built for the way people already move money socially.
- Split bills · pay friends · swap small amounts · save idle funds · pay freelancers · recurring sends · group payments

### Section 4 — Stack
- **Headline:** Powered by Arc and Circle.
- Logos and one-liners: Circle Programmable Wallets · USDC · Arc settlement · USYC yield · Natural language agent

### Section 5 — Memory
- **Headline:** Your financial context, remembered.
- Examples: "the usual to Tunde" · "save 20%" · "park my extra USDC" · "split like last time"

### Final CTA
- **Headline:** Text your wallet.
- **Button:** Open PING

---

## 9 · Pitch Deck Sequence

| # | Slide | Visual |
|---|---|---|
| 1 | **PING — The wallet you text.** | Black screen, glowing bubble mark |
| 2 | Arc made micro-transactions economical. | Stats: $0.01 fees, sub-second finality |
| 3 | But micro-transactions don't work in dashboards. | Annoying dashboard flow for $2 |
| 4 | They work in conversations. | User texting "send Ada $2" |
| 5 | Solution: PING — A conversational financial agent for Arc. | Logo lockup |
| 6 | How it works | `Text → Intent → Wallet → Arc → Receipt` |
| 7 | Circle is load-bearing | Programmable Wallets · USDC · USYC · Arc settlement |
| 8 | Agent intelligence | NL understanding · contact memory · intent → tx · routing · confirmation |
| 9 | Demo | Live flow on phone |
| 10 | Traction story | No app download. No wallet setup. Just text this number. |
| 11 | Why now | Arc enables small-value finance. PING gives it the only interface that feels natural. |
| 12 | Final line | The future of money does not start in an app. It starts in a message. |

---

## 10 · Generative Prompts

For when you need to brief a designer or generate visuals.

### Logo
> Minimal premium logo for a conversational finance agent called PING. A simple rounded chat bubble symbol with a subtle diagonal lightning/arc cut inside it, representing instant money movement through messages. Clean vector style, black background, white symbol with Signal Green (#20E070) accent. No dollar signs, no coins, no robot, no blockchain cube, no AI sparkles. The logo should work as a WhatsApp contact avatar and a fintech app icon at small sizes.

### Landing page
> Premium dark landing page for PING, the wallet you text. Black cinematic background (#050607), glowing green (#20E070) and blue (#4D8CFF) message bubbles, large headline "The wallet you text." Phone mockup on the right showing an iMessage-style conversation where the user sends USDC by text. Minimal fintech UI, Geist typography, social money movement, Arc settlement visual rail beneath the phone. Modern consumer fintech aesthetic. No clutter. No crypto-dashboard look.

### Chat UI mockup
> Mobile chat interface for PING, a conversational finance agent on Arc. Dark mode iMessage-inspired layout. User texts "send Tunde $5 for coffee." Agent replies with a clean transaction confirmation card showing amount, recipient, network "Arc", fee $0.01, arrival under 1 sec, Send and Cancel buttons. Premium fintech style, Signal Green accents, Arc Blue settlement line, Geist typography. Simple and human.

### Pitch slide
> Minimal premium pitch deck slide for PING. Black background, glowing green chat bubble connected by a thin Arc Blue line to a settlement icon. Headline: "Micro-transactions do not belong in dashboards." Side-by-side visual: a complex DeFi dashboard flow on the left, a single text message flow on the right. Clean Geist typography. Consumer-fintech presentation, judge-friendly.

---

## 11 · One-Liners (steal these)

- **The wallet you text.**
- **Text money. Move instantly.**
- **Money moves when you text.**
- **Arc finance, inside your chat.**
- **Send, swap, and save by text.**
- **Just ping money.**
- **Arc made micro-transactions economical. PING makes them human.**
- **The future of money doesn't start in an app. It starts in a message.**

---

**End of brand identity.**

> Anything not specified here defers to whatever feels most like a competent friend who happens to know about money. When in doubt: cut the word.
