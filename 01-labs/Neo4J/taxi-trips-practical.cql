// ---
// Counting
// ---

// 1. zones;
MATCH (z:zone) RETURN COUNT(z)

// 2. boroughs;
MATCH (b:borough) RETURN COUNT(b)

// 3. relationships between zones;
MATCH (z1:zone)-[r:CONNECTS]->(z2:zone) RETURN COUNT(r)

// 4. relationships between zones and boroughs
MATCH (z:zone)-[r:IN]->(b:borough) RETURN COUNT(r)

// 5. zones within the Manhattan borough
MATCH (z:zone)-[r:IN]->(b:borough) WHERE b.name = 'Manhattan' RETURN COUNT(r)

// ---
// Matching
// ---

// 1. all unique zone names;
MATCH (z:zone) RETURN DISTINCT(z.name) as zone
      
// 2. all unique borough names;
MATCH (b:borough) RETURN DISTINCT(b.name) as borough

// 3. all zone pairs with their trips
MATCH (z1:zone)-[r]->(z2:zone)
RETURN z1.name as origin, z2.name as destination, r.trips as trips
      
// 4. all zone pairs with at least 5000 daily trips
MATCH (z1:zone)-[r]->(z2:zone)
WHERE r.trips > 5000
RETURN z1.name as origin, z2.name as destination, r.trips as trips

// 5. the top 5 most popular trips (names of origin and destination zone);
MATCH (z1:zone)-[r]->(z2:zone) 
RETURN z1.name as origin, z2.name as destination, r.trips as trips
ORDER BY r.trips DESC
LIMIT 5

// 6. the top 5 most popular trips within Brooklyn (names of origin and destination zone);
MATCH (z1:zone)-[r]->(z2:zone),
      (z1)-->(b:borough {name: 'Brooklyn'}),
      (z2)-->(b:borough {name: 'Brooklyn'})
RETURN z1.name as origin, z2.name as destination, r.trips as trips
ORDER BY r.trips DESC
LIMIT 5

MATCH (b1:borough)<--(z1:zone)-[r]->(z2:zone)-->(b2:borough)
WHERE b1.name = 'Brooklyn' AND b2.name = 'Brooklyn'      
RETURN z1.name as origin, z2.name as destination, r.trips as trips
ORDER BY r.trips DESC
LIMIT 5

// 7. the total number of trips per origin borough
MATCH (b1:borough)<--(z1:zone)-[r]->(z2:zone)
WITH b1.name as borough, r.trips as trips
RETURN borough, sum(trips) as total_trips
ORDER BY total_trips DESC
