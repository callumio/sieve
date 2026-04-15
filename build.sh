#!/bin/sh

mkdir -p dist
{
  printf "! Title: Sieve\n! Expires: 1 days\n! Updated: %s\n!\n" "$(date -u)"

  for f in src/*.txt; do
    [ -f "$f" ] || continue
    printf "! --- %s ---\n" "$f"
    cat "$f"
  done

  if [ -f lists.txt ]; then
    while IFS= read -r line; do
      case "$line" in
      "#"* | "") continue ;;
      esac
      url="${line%% #*}"
      license="${line##* # }"
      [ "$license" = "$url" ] && license="unspecified"
      printf "! --- %s (license: %s) ---\n" "$url" "$license"
      curl -fsSL "$url" | grep -v '^!'
    done <lists.txt
  fi
} >dist/filter.txt
