import sys
import math


def is_hex_color_light(hex_color):
    [r, g, b] = tuple(int(hex_color[i : i + 2], 16) for i in (0, 2, 4))
    hsp = math.sqrt(0.299 * (r * r) + 0.587 * (g * g) + 0.114 * (b * b))
    return hsp <= 127.5


hex_color = sys.argv[1] if len(sys.argv) > 1 else None

if hex_color is not None:
    print(1 if is_hex_color_light(hex_color) else 0)
else:
    print(0)
