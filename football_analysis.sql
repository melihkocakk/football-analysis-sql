
USE football_league;

-- teams
CREATE TABLE teams (
    team_id INT PRIMARY KEY AUTO_INCREMENT,
    team_name VARCHAR(50),
    city VARCHAR(50),
    founded_year INT
);

-- players
CREATE TABLE players (
    player_id INT PRIMARY KEY AUTO_INCREMENT,
    player_name VARCHAR(100),
    team_id INT,
    position VARCHAR(30),
    age INT,
    nationality VARCHAR(50),
    FOREIGN KEY (team_id) REFERENCES teams(team_id)
);

-- matches
CREATE TABLE matches (
    match_id INT PRIMARY KEY AUTO_INCREMENT,
    home_team_id INT,
    away_team_id INT,
    match_date DATE,
    home_score INT,
    away_score INT,
    season VARCHAR(10),
    FOREIGN KEY (home_team_id) REFERENCES teams(team_id),
    FOREIGN KEY (away_team_id) REFERENCES teams(team_id)
);

-- goals
CREATE TABLE goals (
    goal_id INT PRIMARY KEY AUTO_INCREMENT,
    match_id INT,
    player_id INT,
    minute INT,
    is_own_goal BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (match_id) REFERENCES matches(match_id),
    FOREIGN KEY (player_id) REFERENCES players(player_id)
);

-- teams
INSERT INTO teams (team_name, city, founded_year) VALUES
('Galatasaray', 'İstanbul', 1905),
('Fenerbahçe', 'İstanbul', 1907),
('Beşiktaş', 'İstanbul', 1903),
('Trabzonspor', 'Trabzon', 1967),
('Başakşehir', 'İstanbul', 1990);

-- players
INSERT INTO players (player_name, team_id, position, age, nationality) VALUES
('Icardi', 1, 'Forward', 31, 'Arjantin'),
('Mertens', 1, 'Midfielder', 37, 'Belçika'),
('Dzeko', 2, 'Forward', 38, 'Bosna'),
('İrfan Can', 2, 'Midfielder', 29, 'Türkiye'),
('Rafa Silva', 2, 'Forward', 31, 'Portekiz'),
('Immobile', 3, 'Forward', 34, 'İtalya'),
('Gedson', 3, 'Midfielder', 25, 'Portekiz'),
('Cornelius', 4, 'Forward', 31, 'Danimarka'),
('Bakasetas', 4, 'Midfielder', 29, 'Yunanistan'),
('Deniz Türüç', 5, 'Midfielder', 30, 'Türkiye');

-- matches
INSERT INTO matches (home_team_id, away_team_id, match_date, home_score, away_score, season) VALUES
(1, 2, '2024-09-15', 2, 1, '2024-25'),
(3, 4, '2024-09-16', 1, 1, '2024-25'),
(2, 3, '2024-10-05', 3, 2, '2024-25'),
(4, 5, '2024-10-06', 2, 0, '2024-25'),
(1, 3, '2024-10-20', 1, 2, '2024-25'),
(2, 4, '2024-11-03', 1, 1, '2024-25'),
(5, 1, '2024-11-10', 0, 3, '2024-25'),
(3, 5, '2024-11-24', 4, 1, '2024-25'),
(4, 1, '2024-12-01', 1, 2, '2024-25'),
(5, 2, '2024-12-08', 2, 3, '2024-25');

-- goals
INSERT INTO goals (match_id, player_id, minute, is_own_goal) VALUES
(1, 1, 23, FALSE),  -- Icardi
(1, 2, 67, FALSE),  -- Mertens
(1, 3, 88, FALSE),  -- Dzeko
(2, 6, 45, FALSE),  -- Immobile
(2, 8, 72, FALSE),  -- Cornelius
(3, 3, 10, FALSE),  -- Dzeko
(3, 4, 55, FALSE),  -- İrfan Can
(3, 5, 78, FALSE),  -- Rafa Silva
(3, 6, 30, FALSE),  -- Immobile
(3, 7, 61, FALSE),  -- Gedson
(4, 8, 15, FALSE),  -- Cornelius
(4, 9, 80, FALSE),  -- Bakasetas
(5, 6, 44, FALSE),  -- Immobile
(5, 7, 90, FALSE),  -- Gedson
(5, 1, 55, FALSE),  -- Icardi
(6, 3, 33, FALSE),  -- Dzeko
(6, 8, 70, FALSE),  -- Cornelius
(7, 1, 12, FALSE),  -- Icardi
(7, 2, 48, FALSE),  -- Mertens
(7, 1, 75, FALSE),  -- Icardi
(8, 6, 20, FALSE),  -- Immobile
(8, 6, 50, FALSE),  -- Immobile
(8, 7, 65, FALSE),  -- Gedson
(8, 7, 85, FALSE),  -- Gedson
(8, 10, 40, FALSE), -- Deniz Türüç
(9, 1, 38, FALSE),  -- Icardi
(9, 2, 77, FALSE),  -- Mertens
(9, 8, 60, FALSE),  -- Cornelius
(10, 3, 25, FALSE), -- Dzeko
(10, 4, 55, FALSE), -- İrfan Can
(10, 5, 80, FALSE), -- Rafa Silva
(10, 10, 35, FALSE); -- Deniz Türüç



SELECT * FROM teams;
SELECT * FROM players;
SELECT COUNT(*) AS total_matches FROM matches;
SELECT COUNT(*) AS total_goals FROM goals;

-- MOST SCORED PLAYERS
SELECT player_name, COUNT(*) AS total_goals
FROM goals
JOIN players ON goals.player_id = players.player_id
GROUP BY player_name
ORDER BY total_goals DESC;

-- total points count in home and away matches

SELECT home_team_id AS team_id,
    CASE 
        WHEN home_score > away_score THEN 3
        WHEN home_score = away_score THEN 1
        ELSE 0
    END AS points
FROM matches

UNION ALL

SELECT away_team_id AS team_id,
    CASE 
        WHEN away_score > home_score THEN 3
        WHEN away_score = home_score THEN 1
        ELSE 0
    END AS points
FROM matches;



-- total point table with cte

WITH all_points AS (
   SELECT home_team_id AS team_id,
    CASE 
        WHEN home_score > away_score THEN 3
        WHEN home_score = away_score THEN 1
        ELSE 0
    END AS points
FROM matches

UNION ALL

SELECT away_team_id AS team_id,
    CASE 
        WHEN away_score > home_score THEN 3
        WHEN away_score = home_score THEN 1
        ELSE 0
    END AS points
FROM matches
)
SELECT t.team_name, 
       SUM(p.points) AS total_points,
       COUNT(*) AS total_matches
FROM all_points p
JOIN teams t ON p.team_id = t.team_id
GROUP BY t.team_name
ORDER BY total_points DESC;


WITH player_goals AS (
    SELECT 
        p.player_name,
        p.team_id,
        COUNT(*) AS total_goals
    FROM goals g
    JOIN players p ON g.player_id = p.player_id
    GROUP BY p.player_name, p.team_id
)
SELECT 
    t.team_name,
    pg.player_name,
    pg.total_goals,
    RANK() OVER (PARTITION BY pg.team_id ORDER BY pg.total_goals DESC) AS rank_in_team
FROM player_goals pg
JOIN teams t ON pg.team_id = t.team_id
ORDER BY t.team_name, rank_in_team;

-- most concended goals 

SELECT 
    t.team_name,
    COUNT(*) AS goals_conceded
FROM goals g
JOIN matches m ON g.match_id = m.match_id
JOIN players p ON g.player_id = p.player_id
JOIN teams t ON t.team_id = 
    CASE 
        WHEN p.team_id = m.home_team_id THEN m.away_team_id
        ELSE m.home_team_id
    END
GROUP BY t.team_name
ORDER BY goals_conceded DESC;


-- goal times
SELECT 
    CASE 
        WHEN minute BETWEEN 1 AND 30 THEN 'Early (1-30)'
        WHEN minute BETWEEN 31 AND 60 THEN 'Middle (31-60)'
        WHEN minute BETWEEN 61 AND 90 THEN 'Late (61-90)'
    END AS period,
    COUNT(*) AS goal_count
FROM goals
GROUP BY period
ORDER BY goal_count DESC;



-- most scored matches

SELECT 
    t1.team_name AS home_team,
    t2.team_name AS away_team,
    home_score,
    away_score,
    home_score + away_score AS total_goals
FROM matches m
JOIN teams t1 ON m.home_team_id = t1.team_id
JOIN teams t2 ON m.away_team_id = t2.team_id
ORDER BY total_goals DESC;


-- players who did not scored 

SELECT 
    p.player_name,
    COUNT(g.goal_id) AS total_goals
FROM players p
LEFT JOIN goals g ON p.player_id = g.player_id
GROUP BY p.player_name
HAVING COUNT(g.goal_id) = 0;