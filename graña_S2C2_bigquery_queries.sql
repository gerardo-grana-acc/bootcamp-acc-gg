


# 1- Contar el número de temporadas únicas en las que cada jugador ha jugado
SELECT
  PLAYER_NAME,
  COUNT(DISTINCT SEASON) AS TEMPORADAS_DISTINCT
FROM 
  `mindhub-402613.Prueba.players`
GROUP BY
  PLAYER_NAME
ORDER BY
  TEMPORADAS_DISTINCT DESC;


# 2- Calcular el promedio de puntos anotados por los equipos en casa y fuera de casa

WITH 
  home AS (
  SELECT
    HOME_TEAM_ID AS TEAM_ID,
    ROUND(AVG(PTS_home),2) PTS_HOME_AVG,
  FROM 
    `mindhub-402613.Prueba.games_clean_G3`
  GROUP BY
    TEAM_ID
),

visitor AS (
  SELECT
    VISITOR_TEAM_ID AS TEAM_ID,
    ROUND(AVG(PTS_away),2) AS PTS_VISITOR_AVG
  FROM 
    `mindhub-402613.Prueba.games_clean_G3`
  GROUP BY
    TEAM_ID
)

SELECT
  t.NICKNAME,
  h.PTS_HOME_AVG,
  v.PTS_VISITOR_AVG
FROM
  home AS h
JOIN
  visitor AS v
  ON h.TEAM_ID = v.TEAM_ID
JOIN
  `mindhub-402613.Prueba.teams` AS t
  ON h.TEAM_ID = t.TEAM_ID
;

# 3- Encontrar los jugadores que tienen un promedio de más de 10 puntos por partido
WITH team_pts_year AS (
  SELECT
    HOME_TEAM_ID AS TEAM_ID,
    SEASON,
    PTS_home AS PTS,
    GAME_ID,
    'home' AS LOCAL
  FROM 
    `mindhub-402613.Prueba.games_clean_G3`

  UNION ALL

  SELECT
    VISITOR_TEAM_ID AS TEAM_ID,
    SEASON,
    PTS_away AS PTS,
    GAME_ID,
    'visitor' AS LOCAL
  FROM 
    `mindhub-402613.Prueba.games_clean_G3`
),

player_pts AS (
  SELECT
    a.PLAYER_ID,
    a.TEAM_ID,
    a.SEASON,
    b.PTS,
    b.GAME_ID,
    b.LOCAL
  FROM
    `mindhub-402613.Prueba.players` AS a
  JOIN
    team_pts_year AS b
    ON 
      a.TEAM_ID = b.TEAM_ID AND
      a.SEASON = b.SEASON
)

SELECT
  a.PLAYER_ID,
  b.PLAYER_NAME,
  ROUND(AVG(PTS),2) AS PTS_AVG
FROM
  player_pts AS a
JOIN
  `mindhub-402613.Prueba.players` AS b
  ON 
    a.PLAYER_ID = b.PLAYER_ID
GROUP BY
  PLAYER_ID,
  PLAYER_NAME
HAVING
  PTS_AVG > 100 # AUMENTAMOS DE 10 A 100 PORQUE NO EXISTEN JUGADORES CON ESE PUNTAJE
ORDER BY
  PTS_AVG DESC
;
# 4- Ordenar los equipos por su porcentaje de victorias en la conferencia Oeste


# 5- Identificar el jugador que ha jugado en más temporadas consecutivas

WITH 
unique_player_season AS (
  SELECT DISTINCT
    PLAYER_ID,
    SEASON
  FROM
    `mindhub-402613.Prueba.players`
  ),

season_difference AS (
  SELECT
    PLAYER_ID,
    SEASON,
    SEASON - LAG(SEASON, 1) OVER (PARTITION BY PLAYER_ID ORDER BY SEASON) SEASON_DIFF
  FROM
    unique_player_season
),

continuidad AS (
  SELECT
    PLAYER_ID,
    SUM(SEASON_DIFF) AS TEMPORADAS_CONTINUAS
  FROM
    season_difference
  WHERE
    SEASON_DIFF = 1
  GROUP BY
    PLAYER_ID
)

SELECT
  a.PLAYER_ID,
  b.PLAYER_NAME,
  a.TEMPORADAS_CONTINUAS AS TOP1
FROM
  continuidad a

JOIN
  (SELECT DISTINCT PLAYER_ID, PLAYER_NAME FROM `mindhub-402613.Prueba.players`) b
  ON a.PLAYER_ID = b.PLAYER_ID

WHERE
  TEMPORADAS_CONTINUAS = (SELECT MAX(TEMPORADAS_CONTINUAS) FROM continuidad)
;

# 6- Calcular el porcentaje de juegos ganados en casa para cada equipo
WITH victorias AS (
  SELECT
    HOME_TEAM_ID,
    COUNT(HOME_TEAM_ID) VICTORIAS
  FROM
    `mindhub-402613.Prueba.games_clean_G3`
  WHERE
    HOME_TEAM_WINS = 1
  GROUP BY
    HOME_TEAM_ID
),

total AS (
  SELECT
    HOME_TEAM_ID,
    COUNT(HOME_TEAM_ID) TOTAL
  FROM
    `mindhub-402613.Prueba.games_clean_G3`
  GROUP BY
    HOME_TEAM_ID
)

SELECT
  a.HOME_TEAM_ID,
  c.NICKNAME,
  ROUND(((VICTORIAS / TOTAL)*100), 2) AS PERC_VICTORIAS
FROM
  victorias a
JOIN
  total b
  ON a.HOME_TEAM_ID = b.HOME_TEAM_ID
JOIN
  `mindhub-402613.Prueba.teams` c
  ON a.HOME_TEAM_ID = c.TEAM_ID

ORDER BY
  PERC_VICTORIAS DESC
;

# 7- Encontrar los jugadores que han tenido un aumento significativo en el promedio de puntos por partido




# 8- Calcular la diferencia en el porcentaje de victorias entre temporadas para cada equipo


WITH 
-- total de partidos ganados por equipo por año
victorias_year AS (
  SELECT
    HOME_TEAM_ID AS TEAM_ID,
    SEASON,
    SUM(HOME_TEAM_WINS) AS VICTORIAS
    
  FROM 
    `mindhub-402613.Prueba.games_clean_G3`
  WHERE
    HOME_TEAM_WINS = 1
  GROUP BY
    TEAM_ID,
    SEASON

UNION ALL

  SELECT
    VISITOR_TEAM_ID AS TEAM_ID,
    SEASON,
    SUM(1) AS VICTORIAS
      
  FROM 
    `mindhub-402613.Prueba.games_clean_G3`
  WHERE
    HOME_TEAM_WINS = 0
  GROUP BY
    TEAM_ID,
    SEASON
),

-- suma las victorias como home y visitor para cada equipo para cada año
total_victorias_year AS (
  SELECT
    TEAM_ID,
    SEASON,
    SUM(VICTORIAS)
  FROM
    victorias_year
  GROUP BY
    TEAM_ID,
    SEASON
),

-- total de partidos por equipo por año
total_year_home_visitor AS ( 
  SELECT
    HOME_TEAM_ID AS TEAM_ID,
    SEASON,
    COUNT(HOME_TEAM_ID) AS TOTAL
  FROM
    `mindhub-402613.Prueba.games_clean_G3`
  GROUP BY
    TEAM_ID,
    SEASON
  
  UNION ALL
  
  SELECT
    VISITOR_TEAM_ID AS TEAM_ID,
    SEASON,
    COUNT(VISITOR_TEAM_ID) AS TOTAL
  FROM
    `mindhub-402613.Prueba.games_clean_G3`
  GROUP BY
    TEAM_ID,
    SEASON
),

total_year AS (
  SELECT
    TEAM_ID,
    SEASON,
    SUM(TOTAL) AS TOTAL
  FROM
    total_year_home_visitor
  GROUP BY
    TEAM_ID,
    SEASON
),

-- porcentaje de victorias por equipo por año
perc_victorias_year AS (
  SELECT
    a.TEAM_ID,
    a.SEASON,
    a.VICTORIAS / b.TOTAL AS PERC_VICTORIAS
  FROM
    victorias_year a
  LEFT JOIN
    total_year b
    ON 
      a.TEAM_ID = b.TEAM_ID 
      AND a.SEASON = b.SEASON
)
  SELECT
    a.TEAM_ID,
    b.NICKNAME,
    a.SEASON,
    ROUND((a.PERC_VICTORIAS - LAG(a.PERC_VICTORIAS, 1) OVER (PARTITION BY NICKNAME ORDER BY SEASON)),2) AS PERC_DIFF
  FROM
    perc_victorias_year a
  JOIN
    `mindhub-402613.Prueba.teams` b
    ON a.TEAM_ID = b.TEAM_ID
