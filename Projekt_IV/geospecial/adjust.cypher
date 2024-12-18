MATCH (r:Restaurant)-[:HAS_CONTACT]->(c:Contact)
WHERE c.latitude IS NOT NULL AND c.longitude IS NOT NULL
SET c.location = point({latitude: c.latitude, longitude: c.longitude})
