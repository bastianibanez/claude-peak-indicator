#!/bin/bash
# Claude peak/off-peak indicator for SwiftBar
# Refreshes every 1 minute (filename convention)

ET_HOUR=$(TZ="America/New_York" date +%-H)
ET_DOW=$(TZ="America/New_York" date +%u)  # 1=Mon, 7=Sun

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
echo "Peak: Mon-Fri 8AM-2PM ET | color=gray size=11"
echo "Promo: Mar 13-28, 2026 | color=gray size=11"
echo "---"
echo "Refresh | refresh=true"
