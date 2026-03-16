#!/usr/bin/env python3
"""Generate 16x16 circle PNG icons as base64 for SwiftBar plugin."""

import base64
import struct
import zlib
import math


def create_png(color_rgb):
    """Create a 16x16 PNG with a filled circle of the given RGB color."""
    width, height = 16, 16
    center_x, center_y = 7.5, 7.5
    radius = 6.5

    # Build raw pixel data (RGBA) with filter byte per row
    raw_data = bytearray()
    for y in range(height):
        raw_data.append(0)  # filter: None
        for x in range(width):
            dist = math.sqrt((x - center_x) ** 2 + (y - center_y) ** 2)
            if dist <= radius - 0.5:
                alpha = 255
            elif dist <= radius + 0.5:
                # Anti-alias edge
                alpha = int(255 * (radius + 0.5 - dist))
            else:
                alpha = 0
            raw_data.extend([color_rgb[0], color_rgb[1], color_rgb[2], alpha])

    def make_chunk(chunk_type, data):
        chunk = chunk_type + data
        crc = struct.pack(">I", zlib.crc32(chunk) & 0xFFFFFFFF)
        return struct.pack(">I", len(data)) + chunk + crc

    png = b"\x89PNG\r\n\x1a\n"
    # IHDR
    ihdr_data = struct.pack(">IIBBBBB", width, height, 8, 6, 0, 0, 0)
    png += make_chunk(b"IHDR", ihdr_data)
    # IDAT
    compressed = zlib.compress(bytes(raw_data))
    png += make_chunk(b"IDAT", compressed)
    # IEND
    png += make_chunk(b"IEND", b"")

    return base64.b64encode(png).decode("ascii")


green_b64 = create_png((76, 217, 100))    # Apple green
orange_b64 = create_png((255, 149, 0))    # Apple orange

print(f"GREEN_IMG=\"{green_b64}\"")
print()
print(f"ORANGE_IMG=\"{orange_b64}\"")
