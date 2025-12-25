-- Update hiking_ways with relation information from hiking_relation_members
-- This replaces the memory-intensive Lua logic to avoid segmentation faults during osm2pgsql imports.

WITH way_relation_info AS (
    SELECT
        way_id,
        string_agg(COALESCE(rel_ref, ''), ';') as rel_refs,
        string_agg(COALESCE(rel_network, ''), ';') as rel_networks,
        array_agg(osm_id order by osm_id) as rel_ids
    FROM
        hiking_relation_members
    GROUP BY
        way_id
)
UPDATE
    hiking_ways w
SET
    rel_refs = wri.rel_refs,
    rel_networks = wri.rel_networks,
    rel_ids = wri.rel_ids
FROM
    way_relation_info wri
WHERE
    w.osm_id = wri.way_id;

-- Analyze table after update to ensure indices are efficient
ANALYZE hiking_ways;
