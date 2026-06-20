#!/data/data/com.termux/files/usr/bin/bash

while read keyword
do
  echo "🔥 Generating: $keyword"
  ./ai-news.sh "$keyword"
done < keywords.txt

