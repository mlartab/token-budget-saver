# ⚡ Token Budget Saver

**Fetch any web page server-side. Get a clean, token-efficient extract for AI agents — with anti-bot proxy bypass and built-in token-savings metrics.**

[![PayAPI Verified](https://img.shields.io/badge/PayAPI-settlement--verified-blue)](https://payapi.market/api/token-budget-saver) [![x402 v2](https://img.shields.io/badge/x402-v2-8A2BE2)](https://x402.org) [![Base](https://img.shields.io/badge/Base-USDC-0052FF)](https://base.org) [![Solana](https://img.shields.io/badge/Solana-USDC-14F195)](https://solana.com) [![License: MIT](https://img.shields.io/badge/docs-MIT-yellow.svg)](#license)

[Quick Call](#-quick-call) · [Why Agents Use This](#-why-agents-use-this) · [Pricing](#-pricing) · [API Reference](#-api-reference) · [Discovery](#-discovery) · [Limits](#-what-it-doesnt-do)

---

## 🔗 Live Endpoint

```
https://marketplace-service-template-production-e603.up.railway.app/api/digest
```

|  |  |
| --- | --- |
| **Price** | `$0.002 USDC` per call |
| **Protocol** | x402 v2 · Base (`eip155:8453`) or Solana |
| **Latency** | \~2–3 seconds per fetch (server-side) |

---

## 🚀 Quick Call

```bash
# 1. Call unpaid — receive a 402 challenge
curl "https://marketplace-service-template-production-e603.up.railway.app/api/digest?url=https://news.ycombinator.com"

# 2. Pay the challenge with any x402 client, then retry with the signature
curl "https://marketplace-service-template-production-e603.up.railway.app/api/digest?url=https://news.ycombinator.com" \
  -H "PAYMENT-SIGNATURE: <your-signed-payment>"
```

**Agent response flow:**

```
AI Agent                Token Budget Saver              Blockchain
   │                            │                            │
   │── GET /api/digest?url=… ──►│                            │
   │◄── 402 {price, payTo} ─────│                            │
   │                            │                            │
   │── Send 0.002 USDC ─────────────────────────────────────►│
   │◄── tx confirmed ───────────────────────────────────────│
   │                            │                            │
   │── GET + PAYMENT-SIGNATURE ►│── verify via PayAI ──────►│
   │                            │◄── valid ──────────────────│
   │◄── 200 {content, stats} ───│                            │
```

---

## 💡 Why Agents Use This

| Problem | Solution |
| --- | --- |
| Raw HTML wastes tokens and slows inference | Returns a token-efficient text extract |
| Bot protection blocks most scrapers | Residential proxies bypass Cloudflare and similar |
| Multiple services to coordinate | One call: fetch + clean + measure |
| Unpredictable pricing | Flat `$0.002 USDC` per call, settled on-chain |
| No signup, no API key, no account | Pure x402 — pay, call, done |

---

## 💰 Pricing

| Route | Price | What you get |
| --- | --- | --- |
| `GET /api/digest?url=<target>` | `$0.002 USDC` | One fetched page, cleaned, with token metrics |

Paid on **Base** (`eip155:8453`) or **Solana** — whichever your wallet prefers. No signup. No subscription. No minimum spend.

---

## 📡 API Reference

### Request

```
GET /api/digest?url=<target-url>
```

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `url` | string | ✅ | The full URL of the page to fetch (must include `https://`) |

**Constraints**

- Must be a public `http://` or `https://` URL
- Private IPs, localhost, and cloud metadata endpoints are blocked
- Max redirect chain: 5 hops
- Fetch timeout: 8 seconds

### Response

**`HTTP 200` — success**

```json
{
  "status": "success",
  "url": "https://news.ycombinator.com",
  "contentLength": 42000,
  "timestamp": "2026-10-14T12:00:00.000Z",
  "payment": {
    "settled": true,
    "txHash": "0x78c4904db8263fd8ceac4d715a824ff7b9c087d69a9f8e15f7918280c6e3157a"
  }
}
```

**`HTTP 402` — payment required**

```json
{
  "x402Version": 2,
  "error": "PAYMENT-SIGNATURE header is required",
  "maxTimeoutSeconds": 60,
  "resource": {
    "url": "https://marketplace-service-template-production-e603.up.railway.app/api/digest",
    "description": "Fetches a web page server-side and returns a clean text extract with token-count estimates.",
    "mimeType": "application/json"
  },
  "accepts": [
    {
      "scheme": "exact",
      "network": "eip155:8453",
      "amount": "2000",
      "payTo": "0xfBF6eb2d6eF4D4a2F528aDEF116d641CA5E89681",
      "asset": "0x833589fcd6edb6e08f4c7c32d4f71b54bda02913",
      "maxTimeoutSeconds": 60,
      "extra": { "name": "USD Coin", "version": "2" }
    },
    {
      "scheme": "exact",
      "network": "solana:5eykt4UsFv8P8NJdTREpY1vzqKqZKvdp",
      "amount": "2000",
      "payTo": "8EBMNvPdbSxjncYKDc8kXwLQkqGeY8L94CWuikGuRQDp",
      "asset": "EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v",
      "maxTimeoutSeconds": 60
    }
  ]
}
```

**`HTTP 400` — validation error**

```json
{ "error": "Missing target url parameter" }
```

**`HTTP 502` / `504` — upstream failure**

```json
{
  "error": "Target server returned HTTP status 503",
  "hint": "The target page may be offline, deleted, or blocking automated requests."
}
```

---

## 🔍 Discovery

Agents can discover this service through multiple machine-readable interfaces:

| Endpoint | Purpose |
| --- | --- |
| `/openapi.json` | OpenAPI 3.1.0 spec with `x-payment-info` |
| `/.well-known/x402.json` | x402 discovery manifest |
| `/favicon.ico` | Identity marker |
| `/health` | Uptime check |

**Bazaar extension** is included in every 402 challenge — provides structured input/output schemas for automatic agent integration.

**PayAPI MCP server** — paste this into Claude Desktop or Cursor:

```json
{
  "mcpServers": {
    "payapi": {
      "url": "https://payapi.market/mcp"
    }
  }
}
```

Then search for `token-budget-saver` from any MCP-compatible agent.

---

## ⚙️ What It Does

- ✅ Fetches the target URL server-side through a residential proxy pool
- ✅ Strips clutter — scripts, styles, navigation, ads, boilerplate
- ✅ Extracts main content — text that an agent can reason over
- ✅ Computes token savings — how many tokens you saved vs. raw HTML
- ✅ Returns JSON — clean, structured, ready to embed in your context
- ✅ Records payment on-chain — you receive a tx hash as proof

The whole call takes \~2–3 seconds and consumes \~2 KB of your agent's context (vs. 40–200 KB for raw HTML).

## 🚫 What It Doesn't Do

Being honest about limits helps you plan:

- ❌ **No JavaScript rendering.** Pages that require client-side JS (SPAs, React apps) return empty or minimal content. Static and SSR pages work fine.
- ❌ **No authentication bypass.** Pages behind login walls, paywalls, or CAPTCHAs return partial or no data.
- ❌ **No PDF extraction.** Only HTML pages.
- ❌ **No screenshots.**
- ❌ **No crawling.** One URL per call — you orchestrate multi-page flows.

If your target needs any of the above, this is not the right service. If it's a static or server-rendered HTML page, it works.

---

## ⚠️ Failure Modes

| Failure | HTTP status | What to do |
| --- | --- | --- |
| Missing or malformed `url` param | 400 | Fix the request — no charge |
| Private/internal URL | 400 | Target must be publicly routable — no charge |
| Target returned 4xx/5xx | 502 | Try a different URL or retry later |
| Target timed out (>8s) | 504 | Retry later |
| Bot mitigation / CAPTCHA detected | 503 | Try a different target |
| Page requires JS to render | 422 | Use a headless browser instead |

> **Important:** When the fetch fails, you are not charged. The x402 settlement only runs on HTTP 200.

---

## 🛑 Rate Limits

- 10 requests per minute per IP
- `429 Too Many Requests` with a `Retry-After` header if exceeded
- No daily cap, no monthly cap

Higher volume? [Contact us](#-support) — we can provision a higher limit.

---

## 💳 Payment Details

|  |  |
| --- | --- |
| **Accepted assets** | USDC on Base (`eip155:8453`) or Solana |
| **Base wallet (`payTo`)** | `0xfBF6eb2d6eF4D4a2F528aDEF116d641CA5E89681` |
| **Solana wallet (`payTo`)** | `8EBMNvPdbSxjncYKDc8kXwLQkqGeY8L94CWuikGuRQDp` |
| **Facilitator** | [PayAI](https://facilitator.payai.network) |
| **Settlement** | Immediate — tx hash returned in the response |

---

## ✅ Verified on PayAPI Market

This service is listed on **PayAPI Market** with a **settlement-verified** badge — the platform paid this endpoint from its own wallet and confirmed a real product was returned.

🔗 [Token-Budget-Saver — Web Scraper API](https://payapi.market/api/token-budget-saver)

The verification proves:

1. The endpoint returns a valid x402 v2 challenge
2. Payment verifies against PayAI's facilitator
3. A real on-chain settlement completes
4. The response contains the promised product

**Discover via MCP:**

```json
{
  "mcpServers": {
    "payapi": {
      "url": "https://payapi.market/mcp"
    }
  }
}
```

---

## 🧑‍💻 Example: Fetch and Use in One Agent Turn

```javascript
// Using @x402/fetch (npm install @x402/fetch @x402/evm viem)
import { wrapFetchWithPaymentFromConfig } from "@x402/fetch"
import { ExactEvmScheme } from "@x402/evm"
import { privateKeyToAccount } from "viem/accounts"

const account = privateKeyToAccount(process.env.AGENT_KEY)
const fetch402 = wrapFetchWithPaymentFromConfig(fetch, {
  schemes: [{ network: "eip155:8453", client: new ExactEvmScheme(account) }],
})

const res = await fetch402(
  "https://marketplace-service-template-production-e603.up.railway.app/api/digest?url=https://news.ycombinator.com"
)
const data = await res.json()
console.log("Fetched", data.contentLength, "bytes")
// Now feed `data.content` into your LLM
```

---

## 📦 Source Code

The service implementation is proprietary. This repository contains the public documentation, discovery manifest, and examples — everything agents and buyers need to use the service without exposing the implementation.

## 📄 License

Documentation and schema files in this repository: **MIT**. The service implementation: **proprietary**.

## 🤝 Support

- **Issues:** open an issue on this repository
- **Contact:** via GitHub Issues
- **PayAPI listing:** [payapi.market/api/token-budget-saver](https://payapi.market/api/token-budget-saver)

Built with **x402** · settled via **PayAI** · verified on **PayAPI Market**
