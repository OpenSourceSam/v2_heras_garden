#!/usr/bin/env python3
"""
ASCII converter for visual testing.
Converts PNG → high-resolution ASCII text (160x90).
"""

import sys
from PIL import Image

# Character mapping: light → dark (increased for better detail)
ASCII_CHARS = " .:-=+*#%@"
WIDTH = 160
HEIGHT = 90

def convert_png_to_ascii(png_path: str, output_path: str) -> None:
    """Convert PNG to ASCII text file."""
    # Load and resize
    img = Image.open(png_path)
    img = img.resize((WIDTH, HEIGHT), Image.Resampling.LANCZOS)
    img = img.convert('L')  # Grayscale

    # Convert pixels to ASCII
    pixels = img.getdata()
    ascii_lines = []

    for i in range(HEIGHT):
        line = ""
        for j in range(WIDTH):
            pixel_value = pixels[i * WIDTH + j]
            char_index = int((pixel_value / 255) * (len(ASCII_CHARS) - 1))
            line += ASCII_CHARS[char_index]
        ascii_lines.append(line)

    # Write to file
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(ascii_lines))

    print(f"[ASCII] Converted {png_path} -> {output_path}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: ascii_converter.py <png_path> <output_path>")
        sys.exit(1)

    convert_png_to_ascii(sys.argv[1], sys.argv[2])
