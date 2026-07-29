#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')

GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; RESET='\033[0m'
ORANGE='\033[38;5;172m'; BLUE='\033[38;5;111m'; PALE='\033[38;5;229m'

# Caveman badge
BADGE=""
FLAG="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.caveman-active"
if [ -f "$FLAG" ] && [ ! -L "$FLAG" ]; then
    MODE=$(head -c 64 "$FLAG" 2>/dev/null | tr -d '\n\r' | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9-')
    case "$MODE" in
        off|lite|full|ultra|wenyan-lite|wenyan|wenyan-full|wenyan-ultra|commit|review|compress)
            if [ -z "$MODE" ] || [ "$MODE" = "full" ]; then
                BADGE="${ORANGE}[CAVEMAN]${RESET} "
            else
                SUFFIX=$(printf '%s' "$MODE" | tr '[:lower:]' '[:upper:]')
                BADGE="${ORANGE}[CAVEMAN:${SUFFIX}]${RESET} "
            fi
            ;;
    esac
fi

# Context progress bar
if [ "$PCT" -ge 90 ]; then BAR_COLOR="$RED"
elif [ "$PCT" -ge 70 ]; then BAR_COLOR="$YELLOW"
else BAR_COLOR="$GREEN"; fi

FILLED=$((PCT / 10)); EMPTY=$((10 - FILLED))
BAR=""
[ "$FILLED" -gt 0 ] && printf -v FILL "%${FILLED}s" && BAR="${FILL// /█}"
[ "$EMPTY" -gt 0 ] && printf -v PAD "%${EMPTY}s" && BAR="${BAR}${PAD// /░}"

# Cost
COST_FMT=$(printf '$%.2f' "$COST")

printf '%b' "${BADGE}${BLUE}${MODEL}${RESET} ${BAR_COLOR}${BAR}${RESET} ${PCT}% ${PALE}${COST_FMT}${RESET}\n"
