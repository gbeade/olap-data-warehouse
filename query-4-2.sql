-- Creamos una vista materializada con la consulta recursiva 
CREATE MATERIALIZED VIEW RecursivePathsView AS
WITH RECURSIVE TripCounts AS (
    SELECT 
        StartStation,
        EndStation,
        COUNT(*) AS trip_count
    FROM 
        BicycleTrips
    WHERE 
        StartStation != EndStation
    GROUP BY 
        StartStation, EndStation
),
RecursivePaths AS (
    -- Nivel inicial: caminos de una sola transición
    SELECT 
        StartStation,
        EndStation,
        trip_count,
        ARRAY[StartStation, EndStation] AS path,
        1 AS path_length
    FROM 
        TripCounts
    UNION ALL
    -- Recursivo: extendemos los caminos
    SELECT 
        rp.StartStation,
        tc.EndStation,
        LEAST(rp.trip_count, tc.trip_count) AS trip_count,
        rp.path || tc.EndStation,
        rp.path_length + 1 AS path_length
    FROM 
        RecursivePaths rp
    JOIN 
        TripCounts tc ON rp.EndStation = tc.StartStation
    WHERE 
        array_position(rp.path, tc.EndStation) IS NULL -- Asegurarse de que no se formen ciclos
)
SELECT 
    StartStation,
    EndStation,
    trip_count,
    path,
    path_length
FROM 
    RecursivePaths;

-- Ahora podemos correr consultas como la siguiente, de manera más rápida 
-- Trayecto hamiltoniano de cuatro estaciones con máximo posible flujo de bicicletas
SELECT 
    path[1] AS Station1,
    path[2] AS Station2,
    path[3] AS Station3,
    path[4] AS Station4,
    trip_count
FROM 
    RecursivePathsView
WHERE 
    path_length = 3 
ORDER BY 
    trip_count DESC
LIMIT 1;

