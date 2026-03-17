#!/bin/bash
# Claude peak/off-peak indicator for SwiftBar
# Refreshes every 1 minute (filename convention)

ET_HOUR=$(TZ="America/New_York" date +%-H)
ET_DOW=$(TZ="America/New_York" date +%u)  # 1=Mon, 7=Sun

# Convert peak hours (8AM-2PM ET) to local timezone
LOCAL_TZ=$(date +%Z)
# If %Z returns a raw offset (e.g. "-03"), use city name from IANA zone
if [[ "$LOCAL_TZ" =~ ^[+-][0-9]+$ ]]; then
  LOCAL_TZ=$(readlink /etc/localtime 2>/dev/null | sed 's|.*/zoneinfo/||; s|.*/||')
  LOCAL_TZ="${LOCAL_TZ:-UTC}"
fi
PEAK_START=$(TZ="America/New_York" date -j -f "%H" "08" +%s 2>/dev/null)
PEAK_END=$(TZ="America/New_York" date -j -f "%H" "14" +%s 2>/dev/null)
LOCAL_START=$(date -j -f "%s" "$PEAK_START" "+%-I%p" 2>/dev/null | sed 's/AM/am/;s/PM/pm/')
LOCAL_END=$(date -j -f "%s" "$PEAK_END" "+%-I%p" 2>/dev/null | sed 's/AM/am/;s/PM/pm/')

GREEN_IMG="iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAaUlEQVR4nGPwuZnCQAnGJcEJxMFAXAXFwVAxogwAafgCxP/R8BeoHF4DFmHRiI4X4TKgigjNMFyFbgAnDmfjwl9gYQIzIJgEzTAcjGwAKc5H8QbVDKDYCxQHIsXRSJWERJWkTJXMRBIGAAKBDVexJeizAAAAAElFTkSuQmCC"
ORANGE_IMG="iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAaUlEQVR4nGP4P5WBgRKMS4ITiIOBuAqKg6FiRBkA0vAFiP+j4S9QObwGLMKiER0vwmVAFRGaYbgK3QBOHM7Ghb/AwgRmQDAJmmE4GNkAUpyP4g2qGUCxFygORIqjkSoJiSpJmSqZiSQMAHhaGFcuUDrQAAAAAElFTkSuQmCC"

if [[ $ET_DOW -le 5 && $ET_HOUR -ge 8 && $ET_HOUR -lt 14 ]]; then
  STATUS="Peak Hours"
  IMG=$ORANGE_IMG
  DETAIL="Standard usage limits"
else
  STATUS="Off-Peak"
  IMG=$GREEN_IMG
  DETAIL="2x usage bonus active"
fi

echo "| image=$IMG"
echo "---"
echo "$STATUS | color=white"
echo "$DETAIL | color=gray size=12"
echo "---"
echo "Peak: Mon-Fri ${LOCAL_START}-${LOCAL_END} ${LOCAL_TZ} | color=gray size=11"
echo "Promo: Mar 13-28, 2026 | color=gray size=11"
echo "---"
echo "Refresh | refresh=true"
