#!/bin/bash
# Claude peak/off-peak indicator for SwiftBar
# Refreshes every 1 minute (filename convention)

PT_HOUR=$(TZ="America/Los_Angeles" date +%-H)
PT_DOW=$(TZ="America/Los_Angeles" date +%u)  # 1=Mon, 7=Sun

# Convert peak hours (5AM-11AM PT) to Chilean time (America/Santiago handles DST automatically)
PEAK_START=$(TZ="America/Los_Angeles" date -j -f "%H" "05" +%s 2>/dev/null)
PEAK_END=$(TZ="America/Los_Angeles" date -j -f "%H" "11" +%s 2>/dev/null)
CL_START=$(TZ="America/Santiago" date -j -f "%s" "$PEAK_START" "+%-I%p" 2>/dev/null | sed 's/AM/am/;s/PM/pm/')
CL_END=$(TZ="America/Santiago" date -j -f "%s" "$PEAK_END" "+%-I%p" 2>/dev/null | sed 's/AM/am/;s/PM/pm/')
CL_OFFSET=$(TZ="America/Santiago" date +%z)
case "$CL_OFFSET" in
  -0300) CL_TZ="CLST" ;;  # Chilean Summer Time (Nov–Mar, UTC-3)
  -0400) CL_TZ="CLT"  ;;  # Chilean Standard Time (Apr–Oct, UTC-4)
  *)     CL_TZ="CL($CL_OFFSET)" ;;
esac

GREEN_IMG="iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAaUlEQVR4nGPwuZnCQAnGJcEJxMFAXAXFwVAxogwAafgCxP/R8BeoHF4DFmHRiI4X4TKgigjNMFyFbgAnDmfjwl9gYQIzIJgEzTAcjGwAKc5H8QbVDKDYCxQHIsXRSJWERJWkTJXMRBIGAAKBDVexJeizAAAAAElFTkSuQmCC"
ORANGE_IMG="iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAaUlEQVR4nGP4P5WBgRKMS4ITiIOBuAqKg6FiRBkA0vAFiP+j4S9QObwGLMKiER0vwmVAFRGaYbgK3QBOHM7Ghb/AwgRmQDAJmmE4GNkAUpyP4g2qGUCxFygORIqjkSoJiSpJmSqZiSQMAHhaGFcuUDrQAAAAAElFTkSuQmCC"

if [[ $PT_DOW -le 5 && $PT_HOUR -ge 5 && $PT_HOUR -lt 11 ]]; then
  STATUS="Peak Hours"
  IMG=$ORANGE_IMG
  DETAIL="Session limits drain faster"
else
  STATUS="Off-Peak"
  IMG=$GREEN_IMG
  DETAIL="Good time for intensive tasks"
fi

echo "| image=$IMG"
echo "---"
echo "$STATUS | color=white"
echo "$DETAIL | color=gray size=12"
echo "---"
echo "Peak: Mon-Fri ${CL_START}-${CL_END} ${CL_TZ} (5am-11am PT) | color=gray size=11"
echo "---"
echo "Refresh | refresh=true"
