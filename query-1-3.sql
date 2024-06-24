WITH station_distances AS (
    SELECT 
        s1.StationKey AS station_id,
        s1.Name AS station_name,
        MIN(ST_Distance(s1_loc.Location, s2_loc.Location)) AS min_distance
    FROM Stations s1
    JOIN Coordinates s1_loc ON s1.CoordinateKey = s1_loc.CoordinateKey
    -- Evitamos calcular la distancia a uno mismo 
    JOIN Stations s2 ON s1.StationKey != s2.StationKey
    JOIN Coordinates s2_loc ON s2.CoordinateKey = s2_loc.CoordinateKey
    GROUP BY s1.StationKey, s1.Name
    -- Agregamos esta validación porque existen estaciones diferentes 
    -- una al lado de la otra, entonces pedimos distancias no triviales
    HAVING MIN(ST_Distance(s1_loc.Location, s2_loc.Location)) > 0
),
neighbourhood_distances AS (
    SELECT 
        n.Name AS neighbourhood_name,
        AVG(sd.min_distance) AS avg_min_distance
    FROM station_distances sd
    JOIN Stations s ON sd.station_id = s.StationKey
    JOIN Coordinates c ON s.CoordinateKey = c.CoordinateKey
    JOIN Neighbourhood n ON c.NeighbourhoodKey = n.NeighbourhoodKey
    GROUP BY n.Name
)
SELECT
    neighbourhood_name,
    avg_min_distance,
    RANK() OVER (ORDER BY avg_min_distance) AS ranking
FROM neighbourhood_distances
ORDER BY ranking;
