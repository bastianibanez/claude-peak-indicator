#!/bin/bash
# Test script: briefly switches the indicator to purple, then restores it.
# This verifies the icon swaps without shifting position in the menu bar.

PLUGIN="$HOME/code/claude-peak-indicator/plugins/claude-peak.1m.sh"
BACKUP=$(mktemp)

# Generate purple 16x16 circle PNG (base64)
PURPLE_IMG=$(python3 -c "
import base64, struct, zlib, math
def create_png(rgb):
    w, h = 16, 16
    cx, cy, r = 7.5, 7.5, 6.5
    raw = bytearray()
    for y in range(h):
        raw.append(0)
        for x in range(w):
            d = math.sqrt((x-cx)**2 + (y-cy)**2)
            a = 255 if d <= r-0.5 else int(255*(r+0.5-d)) if d <= r+0.5 else 0
            raw.extend([rgb[0], rgb[1], rgb[2], a])
    def chunk(t, data):
        c = t + data
        return struct.pack('>I', len(data)) + c + struct.pack('>I', zlib.crc32(c) & 0xFFFFFFFF)
    png = b'\x89PNG\r\n\x1a\n'
    png += chunk(b'IHDR', struct.pack('>IIBBBBB', w, h, 8, 6, 0, 0, 0))
    png += chunk(b'IDAT', zlib.compress(bytes(raw)))
    png += chunk(b'IEND', b'')
    return base64.b64encode(png).decode()
print(create_png((149, 97, 226)))
")

# Save current plugin
cp "$PLUGIN" "$BACKUP"

# Write purple test version
cat > "$PLUGIN" << SCRIPT
#!/bin/bash
echo "| image=$PURPLE_IMG"
echo "---"
echo "TEST MODE | color=#9561E2"
echo "Returning to normal in 2s... | color=gray size=12"
SCRIPT
chmod +x "$PLUGIN"

# Tell SwiftBar to refresh
open -g "swiftbar://refreshplugin?name=claude-peak"

echo "→ Purple indicator active (2 seconds)..."
sleep 2

# Restore original
cp "$BACKUP" "$PLUGIN"
chmod +x "$PLUGIN"
rm "$BACKUP"

# Refresh back to normal
open -g "swiftbar://refreshplugin?name=claude-peak"

echo "→ Restored to normal."
