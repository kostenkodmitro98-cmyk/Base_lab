-- Очищуємо все перед створенням, щоб не було помилок
DROP TABLE IF EXISTS PlayerMatchStat CASCADE;
DROP TABLE IF EXISTS PlayerPhones CASCADE;
DROP TABLE IF EXISTS Player CASCADE;
DROP TABLE IF EXISTS Team CASCADE;
DROP TABLE IF EXISTS Coach CASCADE;

-- 1. Створюємо таблицю тренерів. Вона незалежна.
CREATE TABLE Coach (
    CoachID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL
);

-- 2. Таблиця команд. Тут є зв'язок з тренером.
CREATE TABLE Team (
    TeamID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE,
    CoachID INTEGER REFERENCES Coach(CoachID) ON DELETE SET NULL
);

-- 3. Таблиця гравців. Кожен гравець прив'язаний до команди через TeamID.
CREATE TABLE Player (
    PlayerID SERIAL PRIMARY KEY,
    TeamID INTEGER NOT NULL REFERENCES Team(TeamID) ON DELETE CASCADE,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Position VARCHAR(50) NOT NULL
);

-- 4. Окрема таблиця для телефонів (це вимога 1NF).
CREATE TABLE PlayerPhones (
    PhoneID SERIAL PRIMARY KEY,
    PlayerID INTEGER NOT NULL REFERENCES Player(PlayerID) ON DELETE CASCADE,
    PhoneNumber VARCHAR(20) NOT NULL
);

-- 5. Статистика матчів. Тут тільки посилання на гравців та бали (це 3NF).
CREATE TABLE PlayerMatchStat (
    StatID SERIAL PRIMARY KEY,
    PlayerID INTEGER NOT NULL REFERENCES Player(PlayerID) ON DELETE CASCADE,
    MatchID INTEGER NOT NULL, -- ID матчу з таблиці Match
    PointsScored INTEGER DEFAULT 0 CHECK (PointsScored >= 0),
    UNIQUE (PlayerID, MatchID)
);
