// 5 najbliżych restauracji
MATCH (r:Restaurant)-[:HAS_CONTACT]->(c:Contact)
WHERE c.location IS NOT NULL
RETURN r.name, point.distance(c.location, point({latitude: 37.7724, longitudeL -122.39256})) AS distance
ORDER BY distance ASC
LIMIT 5;

// średnia ocen restauracji w promieniu 1500m
MATCH (r:Restaurant)-[:HAS_CONTACT]->(c:Contact)
WHERE c.location IS NOT NULL AND point.distance(c.location, point({latitude: 37.7724, longitudeL -122.39256})) < 1500
RETURN avg(r.rating) AS average_rating