#!/data/data/com.termux/files/usr/bin/bash

source .env

KEYWORD="$1"

if [ -z "$KEYWORD" ]; then
  echo "❌ Please give keyword"
  exit 1
fi

echo "Generating news for: $KEYWORD"

RESPONSE=$(curl -s https://openrouter.ai/api/v1/chat/completions \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"openai/gpt-oss-120b:free\",
    \"messages\": [
      {
        \"role\": \"user\",
        \"content\": \"Write a SEO optimized breaking news article. Include Title, Meta Description, H2 headings, short paragraphs. Topic: $KEYWORD\"
      }
    ]
  }")

CONTENT=$(echo "$RESPONSE" | grep -o '"content":"[^"]*"' | cut -d':' -f2- | tr -d '"')

SLUG=$(echo "$KEYWORD" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')

FILE="content/news/$SLUG.md"

cat > $FILE <<EOF
---
title: "$KEYWORD"
date: $(date +%Y-%m-%d)
draft: false
tags: ["news", "trending"]
description: "$KEYWORD latest update"
---

$CONTENT
EOF

echo "✅ Post created: $FILE"
