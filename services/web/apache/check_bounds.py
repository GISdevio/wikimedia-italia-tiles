#!/opt/venv/bin/python
"""Apache RewriteMap script to check if a tile is within geographic bounds.

Reads "z/x/y" lines from stdin, writes "OK" or "BLOCK" to stdout.
Used by mod_rewrite to reject tile requests outside Europe.
"""

import sys

import morecantile

MIN_LON = -55.9618
MIN_LAT = 24.2840472
MAX_LON = 61.0975692
MAX_LAT = 72.2993719

tms = morecantile.tms.get("WebMercatorQuad")

for line in sys.stdin:
    line = line.strip()
    try:
        z, x, y = map(int, line.split("/"))
        bbox = tms.bounds(morecantile.Tile(x, y, z))
        if bbox.right < MIN_LON or bbox.left > MAX_LON or bbox.top < MIN_LAT or bbox.bottom > MAX_LAT:
            print("BLOCK", flush=True)
        else:
            print("OK", flush=True)
    except (ValueError, ZeroDivisionError):
        print("OK", flush=True)
