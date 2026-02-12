#!/usr/bin/env bash

query="$1"

# If no input, exit
[ -z "$query" ] && exit 0

browser="xdg-open"

case "$query" in
    g\ *)
        search="${query#g }"
        $browser "https://www.google.com/search?q=$(printf '%s' "$search" | sed 's/ /+/g')"
        ;;
    yt\ *)
        search="${query#yt }"
        $browser "https://www.youtube.com/results?search_query=$(printf '%s' "$search" | sed 's/ /+/g')"
        ;;
    git\ *)
        search="${query#git }"
        $browser "https://github.com/search?q=$(printf '%s' "$search" | sed 's/ /+/g')"
        ;;
    *)
        $browser "https://www.google.com/search?q=$(printf '%s' "$query" | sed 's/ /+/g')"
        ;;
esac
