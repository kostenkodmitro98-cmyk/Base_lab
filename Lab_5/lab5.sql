-- Очищення бази перед створенням нової схеми
DROP TABLE IF EXISTS PlayerMatchStat CASCADE;
DROP TABLE IF EXISTS PlayerPhones CASCADE;
DROP TABLE IF EXISTS Player CASCADE;
DROP TABLE IF EXISTS Team CASCADE;
DROP TABLE IF EXISTS Coach CASCADE;

-- 1. Таблиця тренерів (3NF)
CREATE TABLE Coach (
    CoachID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL
);

-- 2. Таблиця команд (3NF - усуває транзитивні залежності)
CREATE TABLE Team (
    TeamID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE,
    CoachID INTEGER REFERENCES Coach(CoachID) ON DELETE SET NULL
);

-- 3. Таблиця гравців (3NF)
CREATE TABLE Player (
    PlayerID SERIAL PRIMARY KEY,
    TeamID INTEGER NOT NULL REFERENCES Team(TeamID) ON DELETE CASCADE,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Position VARCHAR(50) NOT NULL
);

-- 4. Таблиця контактів (1NF - усунення неатомарних списків)
CREATE TABLE PlayerPhones (
    PhoneID SERIAL PRIMARY KEY,
    PlayerID INTEGER NOT NULL REFERENCES Player(PlayerID) ON DELETE CASCADE,
    PhoneNumber VARCHAR(20) NOT NULL
);

-- 5. Таблиця статистики (2NF/3NF - усунення часткових залежностей)
CREATE TABLE PlayerMatchStat (
    StatID SERIAL PRIMARY KEY,
    PlayerID INTEGER NOT NULL REFERENCES Player(PlayerID) ON DELETE CASCADE,
    MatchID INTEGER NOT NULL,
    PointsScored INTEGER DEFAULT 0 CHECK (PointsScored >= 0),
    UNIQUE (PlayerID, MatchID)
);
