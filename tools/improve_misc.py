#!/usr/bin/env python3
"""
Miscellaneous asset improvements - soil, mortar, etc.
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

def create_farm_soil():
    """Create improved farm plot soil"""
    img = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img.load()
    
    # Soil colors from style guide
    SOIL_LIGHT = (0xC4, 0xA4, 0x84)
    SOIL_BASE = (0xA0, 0x84, 0x6C)
    SOIL_DARK = (0x7C, 0x64, 0x50)
    
    # Tilled soil pattern (horizontal lines with texture)
    for y in range(32):
        for x in range(32):
            # Create rows pattern
            row = y // 4
            if row % 2 == 0:
                pixels[x, y] = SOIL_BASE + (0xFF,)
            else:
                pixels[x, y] = SOIL_DARK + (0xFF,)
    
    # Add some random texture variation
    import random
    random.seed(42)  # Consistent pattern
    for _ in range(50):
        x = random.randint(1, 30)
        y = random.randint(1, 30)
        pixels[x, y] = SOIL_LIGHT + (0xFF,)
    
    return img

def create_crafting_mortar():
    """Create crafting mortar sprite"""
    img = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img.load()
    
    # Stone colors
    STONE_LIGHT = (0xA8, 0xA8, 0xA8)
    STONE_BASE = (0x88, 0x88, 0x88)
    STONE_DARK = (0x60, 0x60, 0x60)
    
    # Wood pestle
    WOOD = (0xA0, 0x84, 0x6C)
    
    # Mortar bowl (stone)
    bowl = [
        (6, 18), (7, 18), (8, 18), (9, 18), (10, 18), (11, 18), (12, 18), (13, 18), (14, 18), (15, 18), (16, 18), (17, 18), (18, 18), (19, 18), (20, 18), (21, 18), (22, 18), (23, 18), (24, 18), (25, 18),
        (5, 17), (6, 17), (7, 17), (8, 17), (9, 17), (10, 17), (11, 17), (12, 17), (13, 17), (14, 17), (15, 17), (16, 17), (17, 17), (18, 17), (19, 17), (20, 17), (21, 17), (22, 17), (23, 17), (24, 17), (25, 17), (26, 17),
        (4, 16), (5, 16), (6, 16), (7, 16), (8, 16), (9, 16), (10, 16), (11, 16), (12, 16), (13, 16), (14, 16), (15, 16), (16, 16), (17, 16), (18, 16), (19, 16), (20, 16), (21, 16), (22, 16), (23, 16), (24, 16), (25, 16), (26, 16), (27, 16),
        (4, 15), (5, 15), (6, 15), (7, 15), (8, 15), (9, 15), (10, 15), (11, 15), (12, 15), (13, 15), (14, 15), (15, 15), (16, 15), (17, 15), (18, 15), (19, 15), (20, 15), (21, 15), (22, 15), (23, 15), (24, 15), (25, 15), (26, 15), (27, 15),
        (4, 14), (5, 14), (6, 14), (7, 14), (8, 14), (9, 14), (10, 14), (11, 14), (12, 14), (13, 14), (14, 14), (15, 14), (16, 14), (17, 14), (18, 14), (19, 14), (20, 14), (21, 14), (22, 14), (23, 14), (24, 14), (25, 14), (26, 14), (27, 14),
        (5, 13), (6, 13), (7, 13), (8, 13), (9, 13), (10, 13), (11, 13), (12, 13), (13, 13), (14, 13), (15, 13), (16, 13), (17, 13), (18, 13), (19, 13), (20, 13), (21, 13), (22, 13), (23, 13), (24, 13), (25, 13), (26, 13),
        (6, 12), (7, 12), (8, 12), (9, 12), (10, 12), (11, 12), (12, 12), (13, 12), (14, 12), (15, 12), (16, 12), (17, 12), (18, 12), (19, 12), (20, 12), (21, 12), (22, 12), (23, 12), (24, 12), (25, 12),
        (7, 11), (8, 11), (9, 11), (10, 11), (11, 11), (12, 11), (13, 11), (14, 11), (15, 11), (16, 11), (17, 11), (18, 11), (19, 11), (20, 11), (21, 11), (22, 11), (23, 11), (24, 11),
        (8, 10), (9, 10), (10, 10), (11, 10), (12, 10), (13, 10), (14, 10), (15, 10), (16, 10), (17, 10), (18, 10), (19, 10), (20, 10), (21, 10), (22, 10),
        (9, 9), (10, 9), (11, 9), (12, 9), (13, 9), (14, 9), (15, 9), (16, 9), (17, 9), (18, 9), (19, 9), (20, 9), (21, 9),
    ]
    
    for x, y in bowl:
        if y <= 11:
            pixels[x, y] = STONE_LIGHT + (0xFF,)
        elif y >= 16:
            pixels[x, y] = STONE_DARK + (0xFF,)
        else:
            pixels[x, y] = STONE_BASE + (0xFF,)
    
    # Pestle handle (diagonal wood)
    pestle = [(20, 4), (21, 4), (22, 4), (23, 4),
              (19, 5), (20, 5), (21, 5), (22, 5),
              (18, 6), (19, 6), (20, 6), (21, 6),
              (17, 7), (18, 7), (19, 7), (20, 7),
              (16, 8), (17, 8), (18, 8), (19, 8),
              (16, 9), (17, 9), (18, 9),
              (15, 10), (16, 10), (17, 10)]
    
    for x, y in pestle:
        pixels[x, y] = WOOD + (0xFF,)
    
    return add_outline(img)

def main():
    output_dir = "assets/sprites/placeholders"
    
    print("Generating improved misc assets...")
    
    soil = create_farm_soil()
    soil.save(os.path.join(output_dir, "farm_plot_soil.png"))
    print("  Saved: farm_plot_soil.png")
    
    mortar = create_crafting_mortar()
    mortar.save(os.path.join(output_dir, "crafting_mortar.png"))
    print("  Saved: crafting_mortar.png")
    
    print("\nDone! Misc assets improved.")

if __name__ == "__main__":
    main()
