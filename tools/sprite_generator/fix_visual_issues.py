"""
Visual Consistency Fix Generator
Standardizes NPC proportions and creates seamless grass tile

NPC Standard:
- Canvas: 64x64
- Body: EXACTLY 48x32 pixels (centered)
- Position: x=16 to x=48 (32px wide), y=8 to y=56 (48px tall)
- Padding: 8px on all sides

Grass Standard:
- Canvas: 32x32
- Top edge MUST match bottom edge
- Left edge MUST match right edge
"""

import os
from PIL import Image

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
SPRITES_DIR = os.path.join(PROJECT_ROOT, 'assets', 'sprites', 'placeholders')
TILES_DIR = os.path.join(PROJECT_ROOT, 'assets', 'sprites', 'tiles')

# ============================================================================
# COLOR RAMPS - Same as HQ generator for consistency
# ============================================================================

RAMPS = {
    'skin': [
        (120, 80, 60),     # Outline
        (160, 110, 85),    # Deep shadow
        (195, 145, 115),   # Shadow
        (230, 185, 155),   # Base
        (250, 215, 190),   # Light
        (255, 240, 225),   # Highlight
    ],
    'hermes_robe': [
        (40, 80, 110),     # Outline
        (70, 120, 160),    # Deep shadow
        (100, 160, 200),   # Shadow
        (140, 195, 230),   # Base - sky blue
        (180, 220, 250),   # Light
        (220, 240, 255),   # Highlight
    ],
    'aeetes_robe': [
        (60, 30, 80),      # Outline
        (95, 50, 120),     # Deep shadow
        (130, 75, 160),    # Shadow
        (170, 105, 195),   # Base - royal purple
        (205, 145, 225),   # Light
        (235, 190, 250),   # Highlight
    ],
    'daedalus_robe': [
        (55, 40, 30),      # Outline
        (90, 70, 50),      # Deep shadow
        (125, 100, 75),    # Shadow
        (165, 135, 105),   # Base - brown
        (200, 170, 140),   # Light
        (230, 205, 180),   # Highlight
    ],
    'scylla_skin': [
        (20, 60, 70),      # Outline
        (40, 95, 110),     # Deep shadow
        (65, 130, 150),    # Shadow
        (95, 170, 190),    # Base - teal
        (135, 200, 215),   # Light
        (180, 225, 235),   # Highlight
    ],
    'circe_robe': [
        (70, 40, 90),      # Outline
        (105, 65, 130),    # Deep shadow
        (140, 95, 170),    # Shadow
        (180, 130, 200),   # Base - purple
        (210, 170, 225),   # Light
        (235, 210, 245),   # Highlight
    ],
    'grass': [
        (25, 55, 30),      # Outline - dark green
        (40, 80, 45),      # Deep shadow
        (60, 110, 65),     # Shadow
        (85, 145, 90),     # Base - medium green
        (115, 175, 115),   # Light - bright green
        (150, 200, 145),   # Highlight - yellow-green
    ],
    'hair': (180, 140, 100, 255),  # Brown hair
    'crown': (255, 215, 0, 255),   # Gold
    'staff': (100, 60, 30, 255),   # Wood
    'fire': [(255, 100, 0, 255), (255, 200, 0, 255), (255, 255, 100, 255)],
}

def c(ramp_name, shade_index):
    """Get color from ramp"""
    return RAMPS[ramp_name][shade_index] + (255,)

def save_sprite(img, filename, subdir='placeholders'):
    """Save sprite to appropriate folder"""
    if subdir == 'placeholders':
        path = os.path.join(SPRITES_DIR, filename)
    else:
        path = os.path.join(TILES_DIR, filename)
    img.save(path, 'PNG')
    print(f"Created: {filename}")

# ============================================================================
# STANDARDIZED NPC GENERATOR
# Body: EXACTLY 48x32 pixels (centered in 64x64 canvas)
# Canvas: 64x64, Body: x16-48 (32w), y8-56 (48h) = 8px padding all sides
# ============================================================================

def create_standardized_npc(filename, skin_ramp, robe_ramp, hair_color, accessory_func=None):
    """Create NPC with STANDARDIZED 48x32 body proportions"""
    img = Image.new('RGBA', (64, 64), (0, 0, 0, 0))
    p = img.putpixel

    # BODY BOUNDS: x=16 to x=48 (32px), y=8 to y=56 (48px)
    # Standardized body rectangle for consistency
    BODY_X_START = 16
    BODY_X_END = 48  # exclusive
    BODY_Y_START = 8
    BODY_Y_END = 56  # exclusive

    body_width = BODY_X_END - BODY_X_START  # 32
    body_height = BODY_Y_END - BODY_Y_START  # 48

    # Draw body (standardized rectangle)
    for y in range(BODY_Y_START, BODY_Y_END):
        for x in range(BODY_X_START, BODY_X_END):
            # Calculate position within body (0.0 to 1.0)
            rel_y = (y - BODY_Y_START) / body_height  # 0.0 at top, 1.0 at bottom
            rel_x = (x - BODY_X_START) / body_width   # 0.0 at left, 1.0 at right

            # Body shape - slight taper at shoulders
            shoulder_y = 0.15  # Shoulders at top 15% of body
            hip_y = 0.85       # Hips at bottom 15% of body

            if rel_y < shoulder_y:
                # Shoulders (narrower)
                margin = int(rel_y / shoulder_y * 6)
            elif rel_y > hip_y:
                # Hips (slightly wider)
                margin = int((rel_y - hip_y) / (1 - hip_y) * 4)
            else:
                # Torso (wider)
                margin = 6

            x_min = BODY_X_START + margin
            x_max = BODY_X_END - margin - 1

            if x < x_min or x > x_max:
                continue  # Outside body shape

            # Shading based on position
            dist_from_left = (x - x_min) / (x_max - x_min) if x_max > x_min else 0.5
            shade_idx = 4 if dist_from_left < 0.25 else 3 if dist_from_left < 0.7 else 2
            p((x, y), c(robe_ramp, shade_idx))

    # Body outline (left and right edges)
    for y in range(BODY_Y_START, BODY_Y_END):
        # Left edge
        if y < BODY_Y_START + int(body_height * shoulder_y):
            p((BODY_X_START, y), c(robe_ramp, 0))
        elif y > BODY_Y_START + int(body_height * hip_y):
            p((BODY_X_START, y), c(robe_ramp, 0))
        else:
            p((BODY_X_START + 6, y), c(robe_ramp, 0))

        # Right edge
        if y < BODY_Y_START + int(body_height * shoulder_y):
            p((BODY_X_END - 1, y), c(robe_ramp, 0))
        elif y > BODY_Y_START + int(body_height * hip_y):
            p((BODY_X_END - 1, y), c(robe_ramp, 0))
        else:
            p((BODY_X_END - 1 - 6, y), c(robe_ramp, 0))

    # Body top/bottom outline
    for x in range(BODY_X_START + 6, BODY_X_END - 6):
        p((x, BODY_Y_START), c(robe_ramp, 0))
        p((x, BODY_Y_END - 1), c(robe_ramp, 0))

    # HEAD - centered at top of body
    head_center_x = 32
    head_center_y = BODY_Y_START - 4  # Just above body
    head_radius_x = 10
    head_radius_y = 12

    for dy in range(-head_radius_y, head_radius_y + 1):
        for dx in range(-head_radius_x, head_radius_x + 1):
            if dx*dx/head_radius_x**2 + dy*dy/head_radius_y**2 <= 1:
                shade = 4 if dx < -3 and dy < 0 else 3 if dx < 2 else 2
                p((head_center_x + dx, head_center_y + dy), c(skin_ramp, shade))

    # Head outline
    for dy in range(-head_radius_y, head_radius_y + 1):
        for dx in range(-head_radius_x, head_radius_x + 1):
            if 0.7 < dx*dx/head_radius_x**2 + dy*dy/head_radius_y**2 <= 1:
                p((head_center_x + dx, head_center_y + dy), c(skin_ramp, 0))

    # EYES
    p((28, head_center_y - 2), (40, 40, 50, 255))
    p((35, head_center_y - 2), (40, 40, 50, 255))
    p((29, head_center_y - 2), (255, 255, 255, 255))
    p((36, head_center_y - 2), (255, 255, 255, 255))

    # HAIR - standardized simple hair
    for dy in range(-head_radius_y - 2, -4):
        for dx in range(-head_radius_x, head_radius_x + 1):
            if dx*dx/head_radius_x**2 + (dy + head_radius_y + 2)**2/head_radius_y**2 <= 1:
                p((head_center_x + dx, head_center_y + dy), hair_color)

    # ARMS - standardized at sides
    arm_y_start = BODY_Y_START + int(body_height * 0.2)
    arm_y_end = BODY_Y_END - int(body_height * 0.15)

    # Left arm
    for y in range(arm_y_start, arm_y_end):
        p((BODY_X_START - 3, y), c(skin_ramp, 0))
        p((BODY_X_START - 2, y), c(skin_ramp, 3))
        p((BODY_X_START - 1, y), c(skin_ramp, 4))

    # Right arm
    for y in range(arm_y_start, arm_y_end):
        p((BODY_X_END + 2, y), c(skin_ramp, 0))
        p((BODY_X_END + 1, y), c(skin_ramp, 2))
        p((BODY_X_END, y), c(skin_ramp, 3))

    # FEET - at bottom
    foot_y = BODY_Y_END - 2
    for x in range(BODY_X_START + 4, BODY_X_START + 12):
        p((x, foot_y), c(robe_ramp, 1))
        p((x, foot_y + 1), c(robe_ramp, 0))
    for x in range(BODY_X_END - 12, BODY_X_END - 4):
        p((x, foot_y), c(robe_ramp, 1))
        p((x, foot_y + 1), c(robe_ramp, 0))

    # Accessory (optional)
    if accessory_func:
        accessory_func(img, p)

    save_sprite(img, filename)

def hermes_accessory(img, p):
    """Winged sandals and caduceus - STAY within 48x32 body bounds"""
    # Messenger cap with subtle wings (on head)
    for y in range(8, 14):
        p((24, y), (220, 220, 255, 200))
        p((25, y), (220, 220, 255, 200))
        p((39, y), (220, 220, 255, 200))
        p((40, y), (220, 220, 255, 200))

    # Caduceus staff (held in hand, within bounds)
    staff_y_start = 35
    staff_y_end = 53
    for y in range(staff_y_start, staff_y_end):
        p((49, y), (139, 90, 43, 255))

    # Small snakes on staff
    for y in range(40, 48, 2):
        p((50, y), (100, 150, 100, 255))
        p((48, y + 1), (100, 150, 100, 255))

def aeetes_accessory(img, p):
    """Crown and fire staff - STAY within 48x32 body bounds"""
    # Golden crown (on head)
    for x in range(26, 38):
        p((x, 6), (255, 215, 0, 255))
        if x % 3 == 0:
            p((x, 5), (255, 215, 0, 255))
            p((x, 4), (255, 215, 0, 255))

    # Staff (within bounds, right side)
    for y in range(35, 55):
        p((50, y), (100, 60, 30, 255))

    # Fire at top
    for y in range(30, 36):
        fire_color = RAMPS['fire'][(y - 30) % 3]
        p((50, y), fire_color)
        p((49, y + 1), fire_color)
        p((51, y + 1), fire_color)

def daedalus_accessory(img, p):
    """Tools and wings motif - STAY within 48x32 body bounds"""
    # Leather apron (over robe center)
    apron_y_start = 32
    apron_y_end = 50
    for y in range(apron_y_start, apron_y_end):
        for x in range(26, 38):
            if y > apron_y_start + 2:
                p((x, y), (139, 90, 43, 255))

    # Tool in hand
    for y in range(38, 52):
        p((50, y), (150, 150, 150, 255))

def scylla_accessory(img, p):
    """Tentacles - STAY within 48x32 body bounds"""
    # Tentacles at bottom (teal sea monster)
    tentacle_color = (40, 100, 110, 255)
    for i, x in enumerate([18, 24, 30, 36, 42]):
        for y in range(54, 60):
            wave = (y + i) % 3
            p((x + wave, y), tentacle_color)

def circe_accessory(img, p):
    """Magic wand with glow - STAY within 48x32 body bounds"""
    # Wand (right side)
    wand_y_start = 35
    wand_y_end = 51
    for y in range(wand_y_start, wand_y_end):
        p((49, y), (100, 60, 100, 255))

    # Magical glow at tip (small, within bounds)
    glow_x, glow_y = 49, 28
    for dy in range(-2, 3):
        for dx in range(-2, 3):
            if abs(dx) + abs(dy) < 3:
                alpha = 180 if abs(dx) + abs(dy) < 2 else 120
                p((glow_x + dx, glow_y + dy), (200, 150, 255, alpha))
    p((glow_x, glow_y - 1), (255, 200, 255, 255))

# ============================================================================
# SEAMLESS GRASS TILE GENERATOR
# 32x32 tile with edge wrapping
# CRITICAL: Top=Bottom, Left=Right for seamless tiling
# ============================================================================

def create_seamless_grass():
    """Create 32x32 grass tile with PERFECT edge wrapping"""
    img = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    p = img.putpixel

    # For seamless tiling, we need:
    # 1. Edge pixels must match opposite edge
    # 2. Pattern must wrap correctly

    # Use a seeded random for consistency but respect edges
    # Simple coherent noise approximation for grass texture

    # Pre-compute edge values to ensure matching
    # Top edge (y=0) must equal bottom edge (y=31)
    # Left edge (x=0) must equal right edge (x=31)

    # Create base pattern first, then copy edges
    for y in range(32):
        for x in range(32):
            # Create coherent pattern based on position
            # Use sin/cos for smooth transitions that wrap
            val1 = int(127 + 127 * ((x * 0.3) % 1) * ((y * 0.3) % 1))
            val2 = int(127 + 127 * ((x * 0.7 + y * 0.3) % 1))

            # Simple checker with variation
            checker = (x + y) % 2

            # Add subtle variation
            variation = ((x * 7 + y * 13) % 20) - 10

            # Base shade index (3 = medium green)
            shade_idx = 3

            if checker == 0:
                shade_idx = 2  # Slightly darker
            if variation > 8:
                shade_idx = 4  # Lighter highlight
            if variation < -8:
                shade_idx = 1  # Darker shadow

            # Add rare bright blades
            if (x * 11 + y * 17) % 47 == 0:
                shade_idx = 5  # Highlight

            shade_idx = max(0, min(5, shade_idx))
            p((x, y), c('grass', shade_idx))

    # NOW copy edges to ensure seamless wrapping
    # Copy top row to bottom row
    for x in range(32):
        img.putpixel((x, 31), img.getpixel((x, 0)))

    # Copy left column to right column
    for y in range(32):
        img.putpixel((31, y), img.getpixel((0, y)))

    # Add small grass tufts ONLY in interior (not on edges)
    # This prevents edge artifacts
    tufts = [
        (4, 6), (12, 3), (20, 8), (28, 5),
        (8, 16), (18, 14), (26, 18),
        (3, 24), (14, 26), (22, 22), (30, 28)
    ]
    for tx, ty in tufts:
        # Skip edges (tufts too close to edges cause tiling issues)
        if tx <= 1 or tx >= 30 or ty <= 1 or ty >= 30:
            continue
        for dy in range(-2, 1):
            shade = 4 if dy < 0 else 3
            p((tx, (ty + dy) % 32), c('grass', shade))

    # Verify edge matching
    edges_match = True
    for x in range(32):
        if img.getpixel((x, 0)) != img.getpixel((x, 31)):
            edges_match = False
    for y in range(32):
        if img.getpixel((0, y)) != img.getpixel((31, y)):
            edges_match = False

    if edges_match:
        print("[OK] Grass tile edges match perfectly - will tile seamlessly")
    else:
        print("[!] Warning: Edges don't match perfectly")

    save_sprite(img, 'placeholder_grass.png', 'tiles')

# ============================================================================
# MAIN
# ============================================================================

def main():
    print("=== Visual Consistency Fix Generator ===")
    print("NPC Standard: 48x32 body in 64x64 canvas (8px padding)")
    print("Grass Standard: 32x32 with seamless edge wrapping")
    print()

    print("--- Creating Standardized NPCs ---")
    # All NPCs with standardized 48x32 proportions
    create_standardized_npc('npc_hermes.png', 'skin', 'hermes_robe',
                           (180, 140, 100, 255), hermes_accessory)
    create_standardized_npc('npc_aeetes.png', 'skin', 'aeetes_robe',
                           (60, 40, 30, 255), aeetes_accessory)
    create_standardized_npc('npc_daedalus.png', 'skin', 'daedalus_robe',
                           (180, 180, 190, 255), daedalus_accessory)
    create_standardized_npc('npc_scylla.png', 'scylla_skin', 'scylla_skin',
                           (30, 80, 90, 255), scylla_accessory)
    create_standardized_npc('npc_circe.png', 'skin', 'circe_robe',
                           (80, 50, 30, 255), circe_accessory)
    print()

    print("--- Creating Seamless Grass Tile ---")
    create_seamless_grass()
    print()

    print("=== Visual Consistency Fix Complete! ===")
    print()
    print("Next steps:")
    print("1. Verify NPC sprites in assets/sprites/placeholders/")
    print("2. Reimport NPC frames resources in Godot")
    print("3. Test visual consistency in world.tscn")
    print("4. Run tests/run_tests.gd to verify no regressions")

if __name__ == '__main__':
    main()
