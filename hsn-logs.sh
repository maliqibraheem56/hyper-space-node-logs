#!/bin/bash

LOG_FILE="/var/log/hsn-logs.log"
CHECK_INTERVAL=10  # dalam detik
LAST_POINTS=""

echo "hyper-space monitor berjalan..."
echo "Log file: $LOG_FILE"
echo ""

while true; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    OUTPUT=$(aios-cli hive points 2>&1)

    # Ambil data
    POINTS=$(echo "$OUTPUT" | grep "Points" | awk '{print $2}')
    MULTIPLIER=$(echo "$OUTPUT" | grep "Multiplier" | awk '{print $2}')
    TIER=$(echo "$OUTPUT" | grep "Tier" | awk '{print $2}')
    UPTIME=$(echo "$OUTPUT" | grep "Uptime" | awk '{print $2}')
    ALLOCATION=$(echo "$OUTPUT" | grep "Allocation" | awk '{print $2}')

    # Tampilkan jika Points berubah
    if [[ "$POINTS" != "$LAST_POINTS" ]]; then
        LOG_LINE="[$TIMESTAMP] Points: $POINTS | Boost: $MULTIPLIER | Tier: $TIER | Uptime: $UPTIME | A>
        echo "$LOG_LINE"
        echo "$LOG_LINE" >> "$LOG_FILE"
        LAST_POINTS="$POINTS"
    fi

    sleep "$CHECK_INTERVAL"
done
