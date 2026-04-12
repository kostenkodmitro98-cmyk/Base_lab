# Звіт з лабораторної роботи №3
**Тема:** Маніпулювання даними SQL (OLTP)
**Дисципліна:** Бази даних
**Виконав:** студент групи ІО-43 Костенко Дмитро

---

## 1. Короткий звіт про схему бази даних

Для цієї лабораторної роботи було проведено рефакторинг та значне ускладнення схеми бази даних "Волейбольний турнір" порівняно з Лабораторною роботою №2.

### 1.1. Обґрунтування ускладнення схеми
Порівняно з попередньою роботою, структуру було вдосконалено за такими напрямками:
* **Нормалізація сутності «Тренер»**: Виділено окрему таблицю `Coach` замість текстового поля в таблиці команд. Це дозволяє зберігати історію та професійні атрибути (досвід) незалежно від команди.
* **Деталізація результатів (1:M)**: Створено таблицю `MatchSet`. Тепер замість загального рахунку зберігається детальна інформація про кожну партію.
* **Впровадження зв’язку M:M**: Додано таблицю `PlayerMatchStat`. Вона реалізує зв’язок «багато-до-багатьох» між гравцями та матчами, дозволяючи фіксувати індивідуальні досягнення (очки, блоки) у кожній грі.
* **Цілісність даних**: Додано каскадні видалення (`CASCADE`) та обмеження `CHECK` для валідації значень.

### 1.2. Перелік таблиць та ключів
1.  **Coach**: PK `CoachID`. (Персональні дані тренерів).
2.  **Venue**: PK `VenueID`. (Спортивні майданчики).
3.  **Team**: PK `TeamID`, FK `CoachID`. (Волейбольні клуби).
4.  **Player**: PK `PlayerID`, FK `TeamID`. (Склад команд).
5.  **Match**: PK `MatchID`, FK `HomeTeamID`, `AwayTeamID`, `VenueID`. (Календар ігор).
6.  **MatchSet**: PK `SetID`, FK `MatchID`. (Результати по сетах).
7.  **PlayerMatchStat**: PK `StatID`, FK `PlayerID`, `MatchID`. (Індивідуальна статистика).

---

## 2. SQL-скрипт 

```sql
-- 1. СТВОРЕННЯ ТАБЛИЦЬ
CREATE TABLE Coach (
    CoachID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    ExperienceYears INTEGER CHECK (ExperienceYears >= 0)
);

CREATE TABLE Venue (
    VenueID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL,
    Capacity INTEGER CHECK (Capacity > 0)
);

CREATE TABLE Team (
    TeamID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE,
    CoachID INTEGER REFERENCES Coach(CoachID) ON DELETE SET NULL
);

CREATE TABLE Player (
    PlayerID SERIAL PRIMARY KEY,
    TeamID INTEGER NOT NULL REFERENCES Team(TeamID) ON DELETE CASCADE,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Position VARCHAR(50) NOT NULL,
    JerseyNumber INTEGER CHECK (JerseyNumber BETWEEN 1 AND 99)
);

CREATE TABLE Match (
    MatchID SERIAL PRIMARY KEY,
    HomeTeamID INTEGER NOT NULL REFERENCES Team(TeamID),
    AwayTeamID INTEGER NOT NULL REFERENCES Team(TeamID),
    VenueID INTEGER REFERENCES Venue(VenueID),
    MatchDate DATE NOT NULL,
    CONSTRAINT chk_different_teams CHECK (HomeTeamID != AwayTeamID)
);

CREATE TABLE MatchSet (
    SetID SERIAL PRIMARY KEY,
    MatchID INTEGER NOT NULL REFERENCES Match(MatchID) ON DELETE CASCADE,
    SetNumber INTEGER CHECK (SetNumber BETWEEN 1 AND 5),
    HomeScore INTEGER CHECK (HomeScore >= 0),
    AwayScore INTEGER CHECK (AwayScore >= 0),
    UNIQUE (MatchID, SetNumber)
);

CREATE TABLE PlayerMatchStat (
    StatID SERIAL PRIMARY KEY,
    PlayerID INTEGER NOT NULL REFERENCES Player(PlayerID) ON DELETE CASCADE,
    MatchID INTEGER NOT NULL REFERENCES Match(MatchID) ON DELETE CASCADE,
    PointsScored INTEGER DEFAULT 0,
    Blocks INTEGER DEFAULT 0,
    Aces INTEGER DEFAULT 0,
    UNIQUE (PlayerID, MatchID)
);

-- 2. НАПОВНЕННЯ ДАНИМИ
INSERT INTO Coach (FirstName, LastName, ExperienceYears) VALUES 
('Ivan', 'Petrenko', 10), ('Serhiy', 'Koval', 5), ('Oleksandr', 'Boyko', 8), 
('Mykola', 'Shevchenko', 15), ('Dmytro', 'Sydorenko', 3);

INSERT INTO Team (Name, CoachID) VALUES 
('Spikers', 1), ('Blockers', 2), ('Aces', 3), ('Diggers', 4), ('Smashers', 5);

INSERT INTO Venue (Name, City, Capacity) VALUES 
('Kyiv Arena', 'Kyiv', 5000), ('Lviv Palace', 'Lviv', 3000), ('Odesa Sport Hall', 'Odesa', 2500);

INSERT INTO Player (TeamID, FirstName, LastName, Position, JerseyNumber) VALUES 
(1, 'Andriy', 'Melnyk', 'Setter', 10), (1, 'Bohdan', 'Tkachenko', 'Hitter', 7), (1, 'Ivan', 'Ivanov', 'Libero', 1),
(2, 'Denys', 'Kravchenko', 'Blocker', 15), (2, 'Maksym', 'Lysenko', 'Opposite', 9);

INSERT INTO Match (HomeTeamID, AwayTeamID, VenueID, MatchDate) VALUES 
(1, 2, 1, '2026-04-15'), (3, 4, 2, '2026-04-16'), (1, 5, 1, '2026-04-18'), (2, 3, 3, '2026-04-20');

INSERT INTO MatchSet (MatchID, SetNumber, HomeScore, AwayScore) VALUES 
(1, 1, 25, 20), (1, 2, 25, 22), (1, 3, 25, 18), (2, 1, 15, 25), (2, 2, 20, 25);

INSERT INTO PlayerMatchStat (PlayerID, MatchID, PointsScored, Blocks, Aces) VALUES 
(1, 1, 5, 1, 2), (2, 1, 15, 3, 0), (4, 1, 8, 5, 1);

-- 3.ОПЕРАЦІЇ (UPDATE & DELETE)
-- Оновлення місткості арени (OLTP запит)
UPDATE Venue SET Capacity = 5500 WHERE Name = 'Kyiv Arena';

-- Видалення скасованого матчу
DELETE FROM Match WHERE MatchID = 4;

-- 4. ВИБІРКА ДАНИХ (SELECT/WHERE/JOIN)
-- Пошук усіх зв'язуючих гравців
SELECT FirstName, LastName, JerseyNumber FROM Player WHERE Position = 'Setter';

-- Вивід команд разом з іменами їхніх тренерів
SELECT t.Name AS TeamName, c.LastName AS Coach FROM Team t JOIN Coach c ON t.CoachID = c.CoachID;
```

---

## 3. Докази заповнення таблиць

Нижче наведено витяги з бази даних, що підтверджують успішне виконання операцій та наповнення кожної таблиці (3-5 рядків).

### Таблиця: Coach
| CoachID | FirstName | LastName | ExperienceYears |
| :--- | :--- | :--- | :--- |
| 1 | Ivan | Petrenko | 10 |
| 2 | Serhiy | Koval | 5 |
| 3 | Oleksandr | Boyko | 8 |
| 4 | Mykola | Shevchenko | 15 |
| 5 | Dmytro | Sydorenko | 3 |

### Таблиця: Team
| TeamID | Name | CoachID |
| :--- | :--- | :--- |
| 1 | Spikers | 1 |
| 2 | Blockers | 2 |
| 3 | Aces | 3 |
| 4 | Diggers | 4 |
| 5 | Smashers | 5 |

### Таблиця: Player
| PlayerID | TeamID | FirstName | LastName | Position | JerseyNumber |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 1 | Andriy | Melnyk | Setter | 10 |
| 2 | 1 | Bohdan | Tkachenko | Hitter | 7 |
| 3 | 1 | Ivan | Ivanov | Libero | 1 |
| 4 | 2 | Denys | Kravchenko | Blocker | 15 |
| 5 | 2 | Maksym | Lysenko | Opposite | 9 |

---
**Висновок:** В ході роботи була реалізована транзакційна модель даних для волейбольного турніру. Всі операції (SELECT, INSERT, UPDATE, DELETE) виконуються коректно, з дотриманням цілісності даних та обмежень предметної області.
