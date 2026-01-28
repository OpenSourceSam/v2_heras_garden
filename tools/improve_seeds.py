#!/usr/bin/env python3
"""
Seed and small item improvement - better visibility and styling
"""
from PIL import Image
import os

OUTLINE = (0x40, 0x40, 0x40, 0xFF)
TRANSPARENT = (0, 0, 0, 0)

def add_outline(img):
    """Add 1px #404040 outline"""
    width, height = img.size
    pixels = img.load()
    
    opaque = set()
    for y in range(height):
        for x in range(width):
            if pixels[x, y][3] > 0:
                opaque.add((x, y))
    
    outline_pixels = set()
    for x, y in opaque:
        for dx in [-1, 0, 1]:
            for dy in [-1, 0, 1]:
                if dx == 0 and dy == 0:
                    continue
                nx, ny = x + dx, y + dy
                if 0 <= nx < width and 0 <= ny < height:
                    if (nx, ny) not in opaque:
                        outline_pixels.add((nx, ny))
    
    for x, y in outline_pixels:
        pixels[x, y] = OUTLINE
    
    return img

def create_seed_packet(base_color, highlight_color, seed_name):
    """Create a seed packet (upscaled to 32x32 for visibility)"""
    img = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img.load()
    
    # Packet shape
    packet = [
        # Main body
        (8, 10), (9, 10), (10, 10), (11, 10), (12, 10), (13, 10), (14, 10), (15, 10), (16, 10), (17, 10), (18, 10), (19, 10), (20, 10), (21, 10), (22, 10), (23, 10),
        (8, 11), (9, 11), (10, 11), (11, 11), (12, 11), (13, 11), (14, 11), (15, 11), (16, 11), (17, 11), (18, 11), (19, 11), (20, 11), (21, 11), (22, 11), (23, 11),
        (8, 12), (9, 12), (10, 12), (11, 12), (12, 12), (13, 12), (14, 12), (15, 12), (16, 12), (17, 12), (18, 12), (19, 12), (20, 12), (21, 12), (22, 12), (23, 12),
        (8, 13), (9, 13), (10, 13), (11, 13), (12, 13), (13, 13), (14, 13), (15, 13), (16, 13), (17, 13), (18, 13), (19, 13), (20, 13), (21, 13), (22, 13), (23, 13),
        (8, 14), (9, 14), (10, 14), (11, 14), (12, 14), (13, 14), (14, 14), (15, 14), (16, 14), (17, 14), (18, 14), (19, 14), (20, 14), (21, 14), (22, 14), (23, 14),
        (8, 15), (9, 15), (10, 15), (11, 15), (12, 15), (13, 15), (14, 15), (15, 15), (16, 15), (17, 15), (18, 15), (19, 15), (20, 15), (21, 15), (22, 15), (23, 15),
        (8, 16), (9, 16), (10, 16), (11, 16), (12, 16), (13, 16), (14, 16), (15, 16), (16, 16), (17, 16), (18, 16), (19, 16), (20, 16), (21, 16), (22, 16), (23, 16),
        (8, 17), (9, 17), (10, 17), (11, 17), (12, 17), (13, 17), (14, 17), (15, 17), (16, 17), (17, 17), (18, 17), (19, 17), (20, 17), (21, 17), (22, 17), (23, 17),
        (8, 18), (9, 18), (10, 18), (11, 18), (12, 18), (13, 18), (14, 18), (15, 18), (16, 18), (17, 18), (18, 18), (19, 18), (20, 18), (21, 18), (22, 18), (23, 18),
        (8, 19), (9, 19), (10, 19), (11, 19), (12, 19), (13, 19), (14, 19), (15, 19), (16, 19), (17, 19), (18, 19), (19, 19), (20, 19), (21, 19), (22, 19), (23, 19),
        (8, 20), (9, 20), (10, 20), (11, 20), (12, 20), (13, 20), (14, 20), (15, 20), (16, 20), (17, 20), (18, 20), (19, 20), (20, 20), (21, 20), (22, 20), (23, 20),
        (8, 21), (9, 21), (10, 21), (11, 21), (12, 21), (13, 21), (14, 21), (15, 21), (16, 21), (17, 21), (18, 21), (19, 21), (20, 21), (21, 21), (22, 21), (23, 21),
        # Top folded part
        (9, 9), (10, 9), (11, 9), (12, 9), (13, 9), (14, 9), (15, 9), (16, 9), (17, 9), (18, 9), (19, 9), (20, 9), (21, 9), (22, 9),
        (10, 8), (11, 8), (12, 8), (13, 8), (14, 8), (15, 8), (16, 8), (17, 8), (18, 8), (19, 8), (20, 8), (21, 8),
    ]
    
    SHADOW_COLOR = tuple(c - 0x20 for c in base_color)
    
    for x, y in packet:
        if y <= 9:  # Top folded part - highlight
            pixels[x, y] = highlight_color + (0xFF,)
        elif y >= 20:  # Bottom - shadow
            pixels[x, y] = SHADOW_COLOR + (0xFF,)
        else:
            pixels[x, y] = base_color + (0xFF,)
    
    # Seed symbol in center
    symbol_color = (0x40, 0x40, 0x40)  # Dark gray
    if "wheat" in seed_name:
        symbol = [(15, 14), (16, 14), (15, 15), (16, 15)]  # Simple square
    elif "moly" in seed_name:
        symbol = [(15, 14), (16, 14), (15, 15), (16, 15)]  # Simple square
    else:  # nightshade
        symbol = [(15, 14), (16, 14), (15, 15), (16, 15)]  # Simple square
    
    for x, y in symbol:
        pixels[x, y] = symbol_color + (0xFF,)
    
    return add_outline(img)

def create_woven_cloth():
    """Create woven cloth item"""
    img = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img.load()
    
    # Purple/gold cloth
    PURPLE = (0xB8, 0x90, 0xD8)
    PURPLE_DARK = (0x90, 0x68, 0xB0)
    GOLD = (0xD4, 0xA0, 0x40)
    
    # Cloth roll
    cloth = [
        (8, 12), (9, 12), (10, 12), (11, 12), (12, 12), (13, 12), (14, 12), (15, 12), (16, 12), (17, 12), (18, 12), (19, 12), (20, 12), (21, 12), (22, 12), (23, 12),
        (8, 13), (9, 13), (10, 13), (11, 13), (12, 13), (13, 13), (14, 13), (15, 13), (16, 13), (17, 13), (18, 13), (19, 13), (20, 13), (21, 13), (22, 13), (23, 13),
        (8, 14), (9, 14), (10, 14), (11, 14), (12, 14), (13, 14), (14, 14), (15, 14), (16, 14), (17, 14), (18, 14), (19, 14), (20, 14), (21, 14), (22, 14), (23, 14),
        (8, 15), (9, 15), (10, 15), (11, 15), (12, 15), (13, 15), (14, 15), (15, 15), (16, 15), (17, 15), (18, 15), (19, 15), (20, 15), (21, 15), (22, 15), (23, 15),
        (8, 16), (9, 16), (10, 16), (11, 16), (12, 16), (13, 16), (14, 16), (15, 16), (16, 16), (17, 16), (18, 16), (19, 16), (20, 16), (21, 16), (22, 16), (23, 16),
        (8, 17), (9, 17), (10, 17), (11, 17), (12, 17), (13, 17), (14, 17), (15, 17), (16, 17), (17, 17), (18, 17), (19, 17), (20, 17), (21, 17), (22, 17), (23, 17),
        (8, 18), (9, 18), (10, 18), (11, 18), (12, 18), (13, 18), (14, 18), (15, 18), (16, 18), (17, 18), (18, 18), (19, 18), (20, 18), (21, 18), (22, 18), (23, 18),
        (8, 19), (9, 19), (10, 19), (11, 19), (12, 19), (13, 19), (14, 19), (15, 19), (16, 19), (17, 19), (18, 19), (19, 19), (20, 19), (21, 19), (22, 19), (23, 19),
        # Rolled edge
        (9, 20), (10, 20), (11, 20), (12, 20), (13, 20), (14, 20), (15, 20), (16, 20), (17, 20), (18, 20), (19, 20), (20, 20), (21, 20), (22, 20),
    ]
    
    for x, y in cloth:
        if y == 12:  # Top highlight
            pixels[x, y] = PURPLE + (0xFF,)
        elif y >= 20:  # Bottom shadow
            pixels[x, y] = PURPLE_DARK + (0xFF,)
        elif x >= 12 and x <= 19:  # Gold pattern in center
            pixels[x, y] = GOLD + (0xFF,)
        else:
            pixels[x, y] = PURPLE + (0xFF,)
    
    return add_outline(img)

def create_pharmaka_flower():
    """Create pharmaka flower item"""
    img = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img.load()
    
    # Pink/purple magical flower
    PINK = (0xD8, 0x90, 0xC8)
    PINK_DARK = (0xB0, 0x68, 0xA0)
    STEM = (0x64, 0xA8, 0x38)
    
    # Flower
    flower = [
        (13, 10), (14, 10), (15, 10), (16, 10), (17, 10), (18, 10),
        (12, 11), (13, 11), (14, 11), (15, 11), (16, 11), (17, 11), (18, 11), (19, 11),
        (11, 12), (12, 12), (13, 12), (14, 12), (15, 12), (16, 12), (17, 12), (18, 12), (19, 12), (20, 12),
        (11, 13), (12, 13), (13, 13), (14, 13), (15, 13), (16, 13), (17, 13), (18, 13), (19, 13), (20, 13),
        (12, 14), (13, 14), (14, 14), (15, 14), (16, 14), (17, 14), (18, 14), (19, 14),
        (13, 15), (14, 15), (15, 15), (16, 15), (17, 15), (18, 15),
    ]
    
    stem = [(15, 16), (16, 16), (15, 17), (16, 17), (15, 18), (16, 18), (15, 19), (16, 19),
            (15, 20), (16, 20), (15, 21), (16, 21), (15, 22), (16, 22), (15, 23), (16, 23),
            (14, 24), (15, 24), (16, 24), (17, 24), (14, 25), (15, 25), (16, 25), (17, 25)]
    
    leaves = [(13, 20), (14, 20), (17, 20), (18, 20), (13, 21), (14, 21), (17, 21), (18, 21)]
    
    for x, y in flower:
        if y <= 11:
            pixels[x, y] = PINK + (0xFF,)
        else:
            pixels[x, y] = PINK_DARK + (0xFF,)
    
    for x, y in stem:
        pixels[x, y] = STEM + (0xFF,)
    
    for x, y in leaves:
        pixels[x, y] = STEM + (0xFF,)
    
    return add_outline(img)

def main():
    output_dir = "assets/sprites/placeholders"
    
    print("Generating improved seeds and items...")
    
    # Wheat seed packet (gold/brown)
    wheat_seed = create_seed_packet(
        (0xC4, 0xA0, 0x40),  # Brown
        (0xE8, 0xC4, 0x60),  # Lighter
        "wheat"
    )
    wheat_seed.save(os.path.join(output_dir, "wheat_seed.png"))
    print("  Saved: wheat_seed.png")
    
    # Moly seed packet (purple)
    moly_seed = create_seed_packet(
        (0x90, 0x68, 0xB0),  # Purple
        (0xB8, 0x90, 0xD8),  # Lighter
        "moly"
    )
    moly_seed.save(os.path.join(output_dir, "moly_seed.png"))
    print("  Saved: moly_seed.png")
    
    # Nightshade seed packet (dark purple)
    night_seed = create_seed_packet(
        (0x60, 0x30, 0x78),  # Dark purple
        (0x80, 0x50, 0x98),  # Lighter
        "nightshade"
    )
    night_seed.save(os.path.join(output_dir, "nightshade_seed.png"))
    print("  Saved: nightshade_seed.png")
    
    # Woven cloth
    cloth = create_woven_cloth()
    cloth.save(os.path.join(output_dir, "woven_cloth.png"))
    print("  Saved: woven_cloth.png")
    
    # Pharmaka flower
    flower = create_pharmaka_flower()
    flower.save(os.path.join(output_dir, "pharmaka_flower.png"))
    print("  Saved: pharmaka_flower.png")
    
    print("\nDone! Seeds and items improved.")

if __name__ == "__main__":
    main()
