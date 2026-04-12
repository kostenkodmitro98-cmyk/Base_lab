-- 1. INSERT
INSERT INTO Coach (FirstName, LastName, ExperienceYears) VALUES
('Ivan', 'Petrenko', 10),
('Serhiy', 'Koval', 5),
('Oleksandr', 'Boyko', 8),
('Mykola', 'Shevchenko', 15),
('Dmytro', 'Kovalenko', 3);

INSERT INTO Team (Name, CoachID, FoundedYear) VALUES
('Spikers', 1, 2010),
('Blockers', 2, 2015),
('Aces', 3, 2012),
('Diggers', 4, 2008),
('Smashers', 5, 2020);

INSERT INTO Venue (Name, City, Capacity) VALUES
('Kyiv Arena', 'Kyiv', 5000),
('Lviv Palace', 'Lviv', 3000),
('Odesa Sport Hall', 'Odesa', 2500);

INSERT INTO Player (TeamID, FirstName, LastName, Position, JerseyNumber) VALUES
(1, 'Andriy', 'Melnyk', 'Setter', 10),
(1, 'Bohdan', 'Tkachenko', 'Outside Hitter', 7),
(1, 'Serhiy', 'Rudenko', 'Libero', 1),
(2, 'Denys', 'Kravchenko', 'Middle Blocker', 15),
(2, 'Maksym', 'Lysenko', 'Opposite', 9),
(3, 'Taras', 'Savchenko', 'Libero', 22),
(4, 'Vasyl', 'Dovzhenko', 'Opposite', 13),
(5, 'Oleh', 'Zinchuk', 'Setter', 5);

INSERT INTO Match (HomeTeamID, AwayTeamID, VenueID, MatchDate) VALUES
(1, 2, 1, '2026-04-15'),
(3, 4, 2, '2026-04-16'),
(1, 5, 1, '2026-04-18'),
(2, 3, 3, '2026-04-20');

INSERT INTO MatchSet (MatchID, SetNumber, HomeScore, AwayScore) VALUES
(1, 1, 25, 20),
(1, 2, 25, 22),
(1, 3, 25, 18),
(2, 1, 15, 25),
(2, 2, 20, 25),
(2, 3, 22, 25);

INSERT INTO PlayerMatchStat (PlayerID, MatchID, PointsScored, Blocks, Aces) VALUES
(1, 1, 5, 1, 2),
(2, 1, 15, 3, 0),
(4, 1, 8, 5, 1);

-- 2. UPDATE
UPDATE Venue 
SET Capacity = 5500 
WHERE Name = 'Kyiv Arena';

UPDATE PlayerMatchStat 
SET PointsScored = 16 
WHERE PlayerID = 2 AND MatchID = 1;

-- 3. DELETE
DELETE FROM Match 
WHERE HomeTeamID = 2 AND AwayTeamID = 3 AND MatchDate = '2026-04-20';

DELETE FROM Player 
WHERE FirstName = 'Oleh' AND LastName = 'Zinchuk';

-- 4. SELECT
SELECT FirstName, LastName, JerseyNumber 
FROM Player 
WHERE Position = 'Setter';

SELECT t.Name AS TeamName, c.FirstName, c.LastName AS CoachName 
FROM Team t 
JOIN Coach c ON t.CoachID = c.CoachID;

SELECT SetNumber, HomeScore, AwayScore 
FROM MatchSet 
WHERE MatchID = 1 
ORDER BY SetNumber;

SELECT * FROM Coach;
SELECT * FROM Team;
SELECT * FROM Venue;
SELECT * FROM Player;
SELECT * FROM Match;
SELECT * FROM MatchSet;
SELECT * FROM PlayerMatchStat;
