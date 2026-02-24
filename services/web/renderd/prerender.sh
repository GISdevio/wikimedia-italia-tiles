#!/bin/sh

set -eu

# Default values (can be overridden by environment variables)
MIN_ZOOM="${MIN_ZOOM:-1}"
MAX_ZOOM="${MAX_ZOOM:-13}"
NUM_THREADS="${NUM_THREADS:-4}"
SLEEP_INTERVAL="${SLEEP_INTERVAL:-24h}"

# Per-map bounding boxes in lon/lat (WGS84)
# Format: BOUNDS_<MAPNAME>="min_lon min_lat max_lon max_lat"
# If not set, renders all tiles for that map
BOUNDS_hiking="${BOUNDS_hiking:--55.961800 24.2840472 61.0975692 72.2993719}"
BOUNDS_carto="${BOUNDS_carto:--55.961800 24.2840472 61.0975692 72.2993719}"

# Wait for renderd socket to be available
while [ ! -S /run/renderd/renderd.sock ]
do
    echo "Waiting for renderd socket..."
    sleep 5
done

echo "Starting tile pre-generation (zoom $MIN_ZOOM-$MAX_ZOOM, $NUM_THREADS threads)"

# Extract map names from renderd.conf (sections with URI= are map styles)
get_map_names() {
    awk -F'[][]' '/^\[.+\]$/ {section=$2} /^URI=/ && section!="renderd" && section!="mapnik" {print section}' /etc/renderd.conf
}

generate_tiles() {
    map="$1"
    z_min="$2"
    z_max="$3"

    # Look up per-map bounds: BOUNDS_<mapname>
    bounds=$(eval echo "\${BOUNDS_${map}:-}")

    if [ -n "$bounds" ]; then
        # Parse "min_lon min_lat max_lon max_lat"
        min_lon=$(echo "$bounds" | awk '{print $1}')
        min_lat=$(echo "$bounds" | awk '{print $2}')
        max_lon=$(echo "$bounds" | awk '{print $3}')
        max_lat=$(echo "$bounds" | awk '{print $4}')
        echo "Rendering $map (zooms $z_min-$z_max, bounds: $min_lon,$min_lat,$max_lon,$max_lat)..."
        render_list -m "$map" -a --force -z "$z_min" -Z "$z_max" \
            -w "$min_lon" -g "$min_lat" -W "$max_lon" -G "$max_lat" \
            -n "$NUM_THREADS" -s /run/renderd/renderd.sock \
            || echo "Warning: render_list for $map failed"
    else
        echo "Rendering $map (zooms $z_min-$z_max, all tiles)..."
        render_list -m "$map" -a --force -z "$z_min" -Z "$z_max" \
            -n "$NUM_THREADS" -s /run/renderd/renderd.sock \
            || echo "Warning: render_list for $map failed"
    fi
}

while true
do
    for map in $(get_map_names)
    do
        echo "[$(date)] Starting $map generation..."
        generate_tiles "$map" "$MIN_ZOOM" "$MAX_ZOOM"
        echo "[$(date)] Finished $map"
    done

    echo "[$(date)] All tasks completed. Sleeping for $SLEEP_INTERVAL..."
    sleep "$SLEEP_INTERVAL"
done
