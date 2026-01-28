#!/usr/bin/env python3
"""
Minigame asset improvements - moon, stars, player marker
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

def create_moon():
    """Create improved moon for moon tears minigame"""
    img = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img.load()
    
    # Moon colors
    MOON_LIGHT = (0xF0, 0xF0, 0xD0)
    MOON_BASE = (0xE0, 0xE0, 0xC0)
    MOON_DARK = (0xC0, 0xC0, 0xA0)
    
    # Crescent moon shape
    moon_pixels = [
        (10, 4), (11, 4), (12, 4), (13, 4), (14, 4),
        (8, 5), (9, 5), (10, 5), (11, 5), (12, 5), (13, 5), (14, 5), (15, 5), (16, 5),
        (7, 6), (8, 6), (9, 6), (10, 6), (11, 6), (12, 6), (13, 6), (14, 6), (15, 6), (16, 6), (17, 6),
        (6, 7), (7, 7), (8, 7), (9, 7), (10, 7), (11, 7), (12, 7), (13, 7), (14, 7), (15, 7), (16, 7), (17, 7), (18, 7),
        (6, 8), (7, 8), (8, 8), (9, 8), (10, 8), (11, 8), (12, 8), (13, 8), (14, 8), (15, 8), (16, 8), (17, 8), (18, 8),
        (6, 9), (7, 9), (8, 9), (9, 9), (10, 9), (11, 9), (12, 9), (13, 9), (14, 9), (15, 9), (16, 9), (17, 9), (18, 9),
        (6, 10), (7, 10), (8, 10), (9, 10), (10, 10), (11, 10), (12, 10), (13, 10), (14, 10), (15, 10), (16, 10), (17, 10), (18, 10),
        (6, 11), (7, 11), (8, 11), (9, 11), (10, 11), (11, 11), (12, 11), (13, 11), (14, 11), (15, 11), (16, 11), (17, 11), (18, 11),
        (7, 12), (8, 12), (9, 12), (10, 12), (11, 12), (12, 12), (13, 12), (14, 12), (15, 12), (16, 12), (17, 12),
        (8, 13), (9, 13), (10, 13), (11, 13), (12, 13), (13, 13), (14, 13), (15, 13), (16, 13),
        (10, 14), (11, 14), (12, 14), (13, 14), (14, 14),
    ]
    
    # Cut out crescent shape (don't draw these pixels)
    cutout = [(12, 6), (13, 6), (14, 6), (15, 6),
              (13, 7), (14, 7), (15, 7), (16, 7),
              (14, 8), (15, 8), (16, 8), (17, 8),
              (15, 9), (16, 9), (17, 9),
              (15, 10), (16, 10), (17, 10),
              (14, 11), (15, 11), (16, 11)]
    
    cutout_set = set(cutout)
    
    for x, y in moon_pixels:
        if (x, y) not in cutout_set:
            if x <= 8:  # Left edge highlight
                pixels[x, y] = MOON_LIGHT + (0xFF,)
            elif x >= 15:  # Right edge shadow
                pixels[x, y] = MOON_DARK + (0xFF,)
            else:
                pixels[x, y] = MOON_BASE + (0xFF,)
    
    return add_outline(img)

def create_player_marker():
    """Create player marker for moon tears minigame"""
    img = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img.load()
    
    # Basket/bowl colors
    BASKET = (0xA0, 0x84, 0x6C)
    BASKET_DARK = (0x7C, 0x64, 0x50)
    
    # Simple basket shape
    basket = [
        (10, 16), (11, 16), (12, 16), (13, 16), (14, 16), (15, 16), (16, 16), (17, 16), (18, 16), (19, 16), (20, 16), (21, 16),
        (8, 17), (9, 17), (10, 17), (11, 17), (12, 17), (13, 17), (14, 17), (15, 17), (16, 17), (17, 17), (18, 17), (19, 17), (20, 17), (21, 17), (22, 17), (23, 17),
        (7, 18), (8, 18), (9, 18), (10, 18), (11, 18), (12, 18), (13, 18), (14, 18), (15, 18), (16, 18), (17, 18), (18, 18), (19, 18), (20, 18), (21, 18), (22, 18), (23, 18), (24, 18),
        (6, 19), (7, 19), (8, 19), (9, 19), (10, 19), (11, 19), (12, 19), (13, 19), (14, 19), (15, 19), (16, 19), (17, 19), (18, 19), (19, 19), (20, 19), (21, 19), (22, 19), (23, 19), (24, 19), (25, 19),
        (6, 20), (7, 20), (8, 20), (9, 20), (10, 20), (11, 20), (12, 20), (13, 20), (14, 20), (15, 20), (16, 20), (17, 20), (18, 20), (19, 20), (20, 20), (21, 20), (22, 20), (23, 20), (24, 20), (25, 20),
        (7, 21), (8, 21), (9, 21), (10, 21), (11, 21), (12, 21), (13, 21), (14, 21), (15, 21), (16, 21), (17, 21), (18, 21), (19, 21), (20, 21), (21, 21), (22, 21), (23, 21), (24, 21),
        (8, 22), (9, 22), (10, 22), (11, 22), (12, 22), (13, 22), (14, 22), (15, 22), (16, 22), (17, 22), (18, 22), (19, 22), (20, 22), (21, 22), (22, 22), (23, 22),
        (10, 23), (11, 23), (12, 23), (13, 23), (14, 23), (15, 23), (16, 23), (17, 23), (18, 23), (19, 23), (20, 23), (21, 23),
    ]
    
    for x, y in basket:
        if y >= 21:  # Bottom shadow
            pixels[x, y] = BASKET_DARK + (0xFF,)
        else:
            pixels[x, y] = BASKET + (0xFF,)
    
    return add_outline(img)

def create_stars():
    """Create stars background tile"""
    img = Image.new('RGBA', (64, 64), (0x10, 0x10, 0x20, 0xFF))  # Dark blue background
    pixels = img.load()
    
    # Star colors
    STAR = (0xFF, 0xFF, 0xE0)
    STAR_DIM = (0xC0, 0xC0, 0xA0)
    
    import random
    random.seed(42)
    
    # Place random stars
    for _ in range(20):
        x = random.randint(2, 61)
        y = random.randint(2, 61)
        # Small star (1-2 pixels)
        pixels[x, y] = STAR + (0xFF,)
        if random.random() > 0.5:
            pixels[x+1, y] = STAR_DIM + (0xFF,)
        if random.random() > 0.5:
            pixels[x, y+1] = STAR_DIM + (0xFF,)
    
    return img

def main():
    output_dir = "assets/sprites/placeholders"
    
    print("Generating improved minigame assets...")
    
    moon = create_moon()
    moon.save(os.path.join(output_dir, "moon_tears_moon.png"))
    print("  Saved: moon_tears_moon.png")
    
    marker = create_player_marker()
    marker.save(os.path.join(output_dir, "moon_tears_player_marker.png"))
    print("  Saved: moon_tears_player_marker.png")
    
    stars = create_stars()
    stars.save(os.path.join(output_dir, "moon_tears_stars.png"))
    print("  Saved: moon_tears_stars.png")
    
    print("\nDone! Minigame assets improved.")

if __name__ == "__main__":
    main()
