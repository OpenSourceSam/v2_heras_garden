#!/usr/bin/env python3
"""
Crop growth stage sprites - seedling to mature with proper styling
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

def create_wheat_stages():
    """Create wheat growth stages 1-4"""
    WHEAT_COLOR = (0xD4, 0xA0, 0x40)
    WHEAT_GREEN = (0x88, 0xCC, 0x50)
    
    stages = []
    
    # Stage 1: Just sprouted (small green sprout)
    img1 = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img1.load()
    sprout = [(15, 28), (16, 28), (15, 27), (16, 27), (15, 26), (16, 26),
              (14, 25), (15, 25), (16, 25), (17, 25)]
    for x, y in sprout:
        pixels[x, y] = WHEAT_GREEN + (0xFF,)
    stages.append((img1, "wheat_stage_1.png"))
    
    # Stage 2: Small plant
    img2 = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img2.load()
    plant = [(15, 28), (16, 28), (15, 27), (16, 27), (15, 26), (16, 26),
             (14, 25), (15, 25), (16, 25), (17, 25),
             (14, 24), (15, 24), (16, 24), (17, 24),
             (13, 23), (14, 23), (15, 23), (16, 23), (17, 23), (18, 23)]
    for x, y in plant:
        pixels[x, y] = WHEAT_GREEN + (0xFF,)
    stages.append((img2, "wheat_stage_2.png"))
    
    # Stage 3: Growing, some gold showing
    img3 = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img3.load()
    # Stalks
    for y in range(18, 29):
        pixels[14, y] = WHEAT_GREEN + (0xFF,)
        pixels[17, y] = WHEAT_GREEN + (0xFF,)
    # Grain heads starting
    heads = [(13, 16), (14, 16), (15, 16), (16, 17), (17, 16), (18, 16),
             (13, 17), (14, 17), (15, 17), (16, 16), (17, 17), (18, 17),
             (13, 15), (14, 15), (15, 15), (16, 15), (17, 15), (18, 15)]
    for x, y in heads:
        pixels[x, y] = WHEAT_COLOR + (0xFF,)
    stages.append((img3, "wheat_stage_3.png"))
    
    # Stage 4: Almost mature
    img4 = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img4.load()
    # Stalks
    for y in range(12, 29):
        pixels[14, y] = WHEAT_GREEN + (0xFF,)
        pixels[17, y] = WHEAT_GREEN + (0xFF,)
    # Full grain heads
    heads = [(13, 10), (14, 10), (15, 10), (16, 11), (17, 10), (18, 10),
             (12, 11), (13, 11), (14, 11), (15, 11), (16, 10), (17, 11), (18, 11), (19, 11),
             (12, 12), (13, 12), (14, 12), (15, 12), (16, 12), (17, 12), (18, 12), (19, 12),
             (13, 13), (14, 13), (15, 13), (16, 13), (17, 13), (18, 13),
             (13, 14), (14, 14), (15, 14), (16, 14), (17, 14), (18, 14),
             (14, 9), (15, 9), (16, 9), (17, 9)]
    for x, y in heads:
        pixels[x, y] = WHEAT_COLOR + (0xFF,)
    stages.append((img4, "wheat_stage_4.png"))
    
    return stages

def create_moly_stages():
    """Create moly growth stages 1-4"""
    STEM_COLOR = (0x64, 0xA8, 0x38)
    FLOWER_COLOR = (0xB8, 0x90, 0xD8)
    
    stages = []
    
    # Stage 1: Sprout
    img1 = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img1.load()
    sprout = [(15, 28), (16, 28), (15, 27), (16, 27),
              (14, 26), (15, 26), (16, 26), (17, 26)]
    for x, y in sprout:
        pixels[x, y] = STEM_COLOR + (0xFF,)
    stages.append((img1, "moly_stage_1.png"))
    
    # Stage 2: Small plant with leaves
    img2 = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img2.load()
    plant = [(15, 28), (16, 28), (15, 27), (16, 27), (15, 26), (16, 26),
             (14, 25), (15, 25), (16, 25), (17, 25),
             (13, 24), (14, 24), (15, 24), (16, 24), (17, 24), (18, 24),
             (13, 23), (14, 23), (15, 23), (16, 23), (17, 23), (18, 23)]
    for x, y in plant:
        pixels[x, y] = STEM_COLOR + (0xFF,)
    stages.append((img2, "moly_stage_2.png"))
    
    # Stage 3: Growing with small flower
    img3 = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img3.load()
    # Stem
    for y in range(20, 29):
        pixels[15, y] = STEM_COLOR + (0xFF,)
        pixels[16, y] = STEM_COLOR + (0xFF,)
    # Leaves
    leaves = [(13, 24), (14, 24), (17, 24), (18, 24),
              (13, 23), (14, 23), (17, 23), (18, 23),
              (14, 22), (17, 22)]
    for x, y in leaves:
        pixels[x, y] = STEM_COLOR + (0xFF,)
    # Small flower
    flower = [(15, 19), (16, 19), (15, 20), (16, 20)]
    for x, y in flower:
        pixels[x, y] = FLOWER_COLOR + (0xFF,)
    stages.append((img3, "moly_stage_3.png"))
    
    # Stage 4: Almost mature
    img4 = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img4.load()
    # Stem
    for y in range(15, 29):
        pixels[15, y] = STEM_COLOR + (0xFF,)
        pixels[16, y] = STEM_COLOR + (0xFF,)
    # Leaves
    leaves = [(13, 22), (14, 22), (17, 22), (18, 22),
              (12, 21), (13, 21), (14, 21), (17, 21), (18, 21), (19, 21),
              (13, 20), (14, 20), (17, 20), (18, 20)]
    for x, y in leaves:
        pixels[x, y] = STEM_COLOR + (0xFF,)
    # Larger flower
    flower = [(15, 14), (16, 14), (14, 15), (15, 15), (16, 15), (17, 15),
              (14, 16), (15, 16), (16, 16), (17, 16), (15, 17), (16, 17)]
    for x, y in flower:
        pixels[x, y] = FLOWER_COLOR + (0xFF,)
    stages.append((img4, "moly_stage_4.png"))
    
    return stages

def create_nightshade_stages():
    """Create nightshade growth stages 1-4"""
    STEM_COLOR = (0x58, 0x78, 0x28)
    LEAF_COLOR = (0x38, 0x50, 0x18)
    BERRY_COLOR = (0x90, 0x48, 0xB0)
    
    stages = []
    
    # Stage 1: Dark sprout
    img1 = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img1.load()
    sprout = [(15, 28), (16, 28), (15, 27), (16, 27),
              (14, 26), (15, 26), (16, 26), (17, 26)]
    for x, y in sprout:
        pixels[x, y] = STEM_COLOR + (0xFF,)
    stages.append((img1, "nightshade_stage_1.png"))
    
    # Stage 2: Small with dark leaves
    img2 = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img2.load()
    plant = [(15, 28), (16, 28), (15, 27), (16, 27), (15, 26), (16, 26),
             (14, 25), (15, 25), (16, 25), (17, 25)]
    for x, y in plant:
        pixels[x, y] = STEM_COLOR + (0xFF,)
    leaves = [(13, 24), (14, 24), (17, 24), (18, 24)]
    for x, y in leaves:
        pixels[x, y] = LEAF_COLOR + (0xFF,)
    stages.append((img2, "nightshade_stage_2.png"))
    
    # Stage 3: Growing with small berries
    img3 = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img3.load()
    # Stem
    for y in range(20, 29):
        pixels[15, y] = STEM_COLOR + (0xFF,)
        pixels[16, y] = STEM_COLOR + (0xFF,)
    # Dark leaves
    leaves = [(13, 23), (14, 23), (17, 23), (18, 23),
              (12, 22), (13, 22), (14, 22), (17, 22), (18, 22), (19, 22)]
    for x, y in leaves:
        pixels[x, y] = LEAF_COLOR + (0xFF,)
    # Small berries
    berries = [(15, 20), (16, 20)]
    for x, y in berries:
        pixels[x, y] = BERRY_COLOR + (0xFF,)
    stages.append((img3, "nightshade_stage_3.png"))
    
    # Stage 4: Almost mature with more berries
    img4 = Image.new('RGBA', (32, 32), TRANSPARENT)
    pixels = img4.load()
    # Stem
    for y in range(16, 29):
        pixels[15, y] = STEM_COLOR + (0xFF,)
        pixels[16, y] = STEM_COLOR + (0xFF,)
    # Dark leaves
    leaves = [(13, 21), (14, 21), (17, 21), (18, 21),
              (12, 20), (13, 20), (14, 20), (17, 20), (18, 20), (19, 20),
              (13, 19), (14, 19), (17, 19), (18, 19)]
    for x, y in leaves:
        pixels[x, y] = LEAF_COLOR + (0xFF,)
    # More berries
    berries = [(14, 16), (15, 16), (16, 16), (17, 16),
               (14, 17), (15, 17), (16, 17), (17, 17),
               (15, 15), (16, 15)]
    for x, y in berries:
        pixels[x, y] = BERRY_COLOR + (0xFF,)
    stages.append((img4, "nightshade_stage_4.png"))
    
    return stages

def main():
    output_dir = "assets/sprites/placeholders"
    
    print("Generating crop growth stages...")
    
    # Wheat stages
    for img, filename in create_wheat_stages():
        img = add_outline(img)
        img.save(os.path.join(output_dir, filename))
        print(f"  Saved: {filename}")
    
    # Moly stages
    for img, filename in create_moly_stages():
        img = add_outline(img)
        img.save(os.path.join(output_dir, filename))
        print(f"  Saved: {filename}")
    
    # Nightshade stages
    for img, filename in create_nightshade_stages():
        img = add_outline(img)
        img.save(os.path.join(output_dir, filename))
        print(f"  Saved: {filename}")
    
    print("\nDone! All growth stages improved with outlines.")

if __name__ == "__main__":
    main()
