#!/bin/sh

set -eu

# Default values (can be overridden by environment variables)
MIN_ZOOM="${MIN_ZOOM:-1}"
MAX_ZOOM="${MAX_ZOOM:-13}"
NUM_THREADS="${NUM_THREADS:-4}"
SLEEP_INTERVAL="${SLEEP_INTERVAL:-24h}"
# Set to 1 to force re-render all tiles, 0 to only render expired/missing
FORCE="${FORCE:-0}"

# Wait for renderd socket to be available
while [ ! -S /run/renderd/renderd.sock ]
do
    echo "Waiting for renderd socket..."
    sleep 5
done

echo "Starting tile pre-generation (zoom $MIN_ZOOM-$MAX_ZOOM, $NUM_THREADS threads, force=$FORCE)"

# Extract map names from renderd.conf (sections with URI= are map styles)
get_map_names() {
    awk -F'[][]' '/^\[.+\]$/ {section=$2} /^URI=/ && section!="renderd" && section!="mapnik" {print section}' /etc/renderd.conf
}

# Build render_list command
build_cmd() {
    map="$1"
    cmd="render_list -m $map -a -z $MIN_ZOOM -Z $MAX_ZOOM -n $NUM_THREADS -s /run/renderd/renderd.sock"
    if [ "$FORCE" = "1" ]; then
        cmd="$cmd --force"
    fi
    echo "$cmd"
}

while true
do
    for map in $(get_map_names)
    do
        echo "[$(date)] Pre-rendering $map tiles (zoom $MIN_ZOOM-$MAX_ZOOM)..."
        cmd=$(build_cmd "$map")
        $cmd || echo "Warning: render_list for $map failed"
        echo "[$(date)] Completed $map"
    done
    
    echo "[$(date)] All maps rendered. Sleeping for $SLEEP_INTERVAL..."
    sleep "$SLEEP_INTERVAL"
done
