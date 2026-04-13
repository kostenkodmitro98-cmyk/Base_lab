-- 1. Базова агрегація
SELECT 
    SUM(PointsScored) AS TotalPoints, 
    SUM(Blocks) AS TotalBlocks, 
    SUM(Aces) AS TotalAces 
FROM PlayerMatchStat;

-- 2. GROUP BY
SELECT 
    Position, 
    COUNT(PlayerID) AS TotalPlayers 
FROM Player 
GROUP BY Position;

-- 3. Багатотаблична агрегація
SELECT 
    p.FirstName, 
    p.LastName, 
    SUM(pms.PointsScored) AS TotalPoints 
FROM Player p
JOIN PlayerMatchStat pms ON p.PlayerID = pms.PlayerID
GROUP BY p.FirstName, p.LastName;

-- 4. Фільтрування HAVING
SELECT 
    MatchID, 
    COUNT(SetID) AS SetsPlayed 
FROM MatchSet 
GROUP BY MatchID 
HAVING COUNT(SetID) > 2;

-- 5. LEFT JOIN
SELECT 
    v.Name AS VenueName, 
    COUNT(m.MatchID) AS MatchesPlayed 
FROM Venue v 
LEFT JOIN Match m ON v.VenueID = m.VenueID 
GROUP BY v.Name;

-- 6. RIGHT JOIN
SELECT 
    t.Name AS TeamName, 
    c.FirstName, 
    c.LastName AS CoachLastName
FROM Team t 
RIGHT JOIN Coach c ON t.CoachID = c.CoachID;

-- 7. CROSS JOIN
SELECT 
    t.Name AS TeamName, 
    v.Name AS VenueName 
FROM Team t 
CROSS JOIN Venue v;

-- 8. Підзапит у WHERE
SELECT 
    p.LastName, 
    pms.PointsScored 
FROM Player p 
JOIN PlayerMatchStat pms ON p.PlayerID = pms.PlayerID 
WHERE pms.PointsScored > (SELECT AVG(PointsScored) FROM PlayerMatchStat);

-- 9. Підзапит у SELECT
SELECT 
    Name AS TeamName, 
    (SELECT COUNT(*) FROM Player WHERE TeamID = t.TeamID) AS PlayerCount 
FROM Team t;

-- 10. Підзапит у HAVING
SELECT 
    p.TeamID, 
    AVG(pms.PointsScored) AS AvgTeamPoints 
FROM Player p 
JOIN PlayerMatchStat pms ON p.PlayerID = pms.PlayerID 
GROUP BY p.TeamID 
HAVING AVG(pms.PointsScored) > (SELECT AVG(PointsScored) FROM PlayerMatchStat);
