#!/usr/bin/env bash
# Example: fetch a page and print the token metrics.
# Requires an x402-capable client. Replace $AGENT_KEY with your wallet key.

ENDPOINT="https://marketplace-service-template-production-e603.up.railway.app/api/digest"
TARGET="https://news.ycombinator.com"

# Unpaid request — shows the 402 challenge
curl -s "${ENDPOINT}?url=${TARGET}" | jq .

# Paid request — retry with PAYMENT-SIGNATURE (use your x402 client to generate this)
# curl -s "${ENDPOINT}?url=${TARGET}" \
#   -H "PAYMENT-SIGNATURE: <signature>" | jq .
