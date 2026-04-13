# Звіт з лабораторної роботи №4
**Тема:** Аналітичні SQL-запити (OLAP)
**Виконав:** студент групи ІО-43 Костенко Дмитро

**Опис схеми бази даних (Документація)**
Усі запити виконуються до схеми "Волейбольний турнір". Основні таблиці та ключі:
* `Team` (PK `TeamID`) та `Coach` (PK `CoachID`).
* `Player` (PK `PlayerID`, FK `TeamID`).
* `Match` (PK `MatchID`, FK `HomeTeamID`, FK `AwayTeamID`, FK `VenueID`).
* `PlayerMatchStat` (PK `StatID`, FK `PlayerID`, FK `MatchID`) — реалізує зв'язок багато-до-багатьох для статистики.

## 1. Агрегація та групування

**Запит 1 (SUM)**
```sql
SELECT SUM(PointsScored) AS TotalPoints, SUM(Blocks) AS TotalBlocks, SUM(Aces) AS TotalAces FROM PlayerMatchStat;
```
*Опис:* Обчислює загальну кількість очок, блоків та ейсів, зароблених усіма гравцями за весь турнір.

**Запит 2 (COUNT, GROUP BY, ORDER BY)**
```sql
SELECT Position, COUNT(PlayerID) AS TotalPlayers FROM Player GROUP BY Position ORDER BY TotalPlayers DESC;
```
*Опис:* Групує гравців за ігровим амплуа та рахує їх кількість, сортуючи від найпопулярнішої позиції до найменш популярної.

**Запит 3 (JOIN, SUM, GROUP BY, ORDER BY)**
```sql
SELECT p.FirstName, p.LastName, SUM(pms.PointsScored) AS TotalPoints 
FROM Player p JOIN PlayerMatchStat pms ON p.PlayerID = pms.PlayerID 
GROUP BY p.FirstName, p.LastName ORDER BY TotalPoints DESC;
```
*Опис:* Об'єднує таблиці гравців та статистики, щоб підрахувати сумарну кількість очок кожного гравця за всі його матчі.

**Запит 4 (HAVING)**
```sql
SELECT MatchID, COUNT(SetID) AS SetsPlayed FROM MatchSet GROUP BY MatchID HAVING COUNT(SetID) > 2;
```
*Опис:* Фільтрує згруповані дані, залишаючи лише ті матчі, в яких було зіграно більше двох сетів.

## 2. Використання різних типів JOIN

**Запит 5 (LEFT JOIN)**
```sql
SELECT v.Name AS VenueName, COUNT(m.MatchID) AS MatchesPlayed 
FROM Venue v LEFT JOIN Match m ON v.VenueID = m.VenueID GROUP BY v.Name ORDER BY MatchesPlayed DESC;
```
*Опис:* Виводить список усіх арен та кількість зіграних на них матчів. Завдяки `LEFT JOIN`, арени без матчів також потрапляють у звіт (з результатом 0).

**Запит 6 (RIGHT JOIN)**
```sql
SELECT t.Name AS TeamName, c.FirstName, c.LastName AS CoachLastName
FROM Team t RIGHT JOIN Coach c ON t.CoachID = c.CoachID;
```
*Опис:* Виводить тренерів та їхні команди. `RIGHT JOIN` гарантує, що у списку будуть усі тренери, навіть ті, хто тимчасово без команди (значення `NULL`).

**Запит 7 (CROSS JOIN)**
```sql
SELECT t.Name AS TeamName, v.Name AS VenueName FROM Team t CROSS JOIN Venue v;
```
*Опис:* Створює добуток, генеруючи всі можливі комбінації існуючих команд та арен.

## 3. Використання підзапитів

**Запит 8 (WHERE)**
```sql
SELECT p.LastName, pms.PointsScored FROM Player p 
JOIN PlayerMatchStat pms ON p.PlayerID = pms.PlayerID 
WHERE pms.PointsScored > (SELECT AVG(PointsScored) FROM PlayerMatchStat);
```
*Опис:* Знаходить гравців, які в конкретному матчі набрали більше очок, ніж становить середній показник за один матч по всьому турніру.

**Запит 9 (SELECT)**
```sql
SELECT Name AS TeamName, (SELECT COUNT(*) FROM Player WHERE TeamID = t.TeamID) AS PlayerCount FROM Team t;
```
*Опис:* Обчислює кількість гравців у кожній команді за допомогою вкладеного запиту замість конструкції `GROUP BY`.

**Запит 10 (HAVING)**
```sql
SELECT p.TeamID, AVG(pms.PointsScored) AS AvgTeamPoints 
FROM Player p JOIN PlayerMatchStat pms ON p.PlayerID = pms.PlayerID 
GROUP BY p.TeamID HAVING AVG(pms.PointsScored) > (SELECT AVG(PointsScored) FROM PlayerMatchStat);
```
*Опис:* Знаходить команди, чий середній результат вищий за загальний турнір. Динамічно фільтрує агреговані групи.

---
**Висновок:** Запити виконуються без помилок у PostgreSQL, використовують усі необхідні оператори (`WHERE`, `JOIN`, `GROUP BY`, `ORDER BY`) та повертають очікувані аналітичні дані, що підтверджує коректність виконання роботи.
