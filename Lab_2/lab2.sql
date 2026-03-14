DROP TABLE IF EXISTS Match CASCADE;
DROP TABLE IF EXISTS Player CASCADE;
DROP TABLE IF EXISTS Team CASCADE;

CREATE TABLE Team (
    TeamID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE,
    CoachName VARCHAR(100) NOT NULL
);

CREATE TABLE Player (
    PlayerID SERIAL PRIMARY KEY,
    TeamID INTEGER NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Position VARCHAR(50) NOT NULL,
    CONSTRAINT fk_team FOREIGN KEY (TeamID) REFERENCES Team(TeamID)
);

CREATE TABLE Match (
    MatchID SERIAL PRIMARY KEY,
    HomeTeamID INTEGER NOT NULL,
    AwayTeamID INTEGER NOT NULL,
    MatchDate DATE NOT NULL,
    Score VARCHAR(5) NOT NULL CHECK (Score IN ('3-0', '3-1', '3-2', '0-3', '1-3', '2-3')),
    CONSTRAINT fk_home_team FOREIGN KEY (HomeTeamID) REFERENCES Team(TeamID),
    CONSTRAINT fk_away_team FOREIGN KEY (AwayTeamID) REFERENCES Team(TeamID),
    CONSTRAINT chk_different_teams CHECK (HomeTeamID != AwayTeamID)
);

INSERT INTO Team (Name, CoachName) VALUES
('Spikers', 'Ivan Petrenko'),
('Blockers', 'Serhiy Koval'),
('Aces', 'Oleksandr Boyko'),
('Diggers', 'Mykola Shevchenko');

INSERT INTO Player (TeamID, FirstName, LastName, Position) VALUES
(1, 'Andriy', 'Melnyk', 'Setter'),
(1, 'Bohdan', 'Tkachenko', 'Outside Hitter'),
(2, 'Denys', 'Kravchenko', 'Middle Blocker'),
(3, 'Taras', 'Savchenko', 'Libero'),
(4, 'Vasyl', 'Lysenko', 'Opposite');

INSERT INTO Match (HomeTeamID, AwayTeamID, MatchDate, Score) VALUES
(1, 2, '2026-03-01', '3-1'),
(3, 4, '2026-03-02', '0-3'),
(1, 3, '2026-03-05', '3-2'),
(2, 4, '2026-03-08', '1-3');
