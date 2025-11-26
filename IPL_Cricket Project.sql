Create Database IPL_DB;
Use IPL_DB;

-- 1. Teams
CREATE TABLE Teams (
    TeamID INT PRIMARY KEY,
    TeamName VARCHAR(50),
    City VARCHAR(50)
);

-- 2. Players
CREATE TABLE Players (
    PlayerID INT PRIMARY KEY,
    PlayerName VARCHAR(50),
    Role VARCHAR(30),
    TeamID INT,
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID)
);

-- 3. Stadiums
CREATE TABLE Stadiums (
    StadiumID INT PRIMARY KEY,
    StadiumName VARCHAR(100),
    City VARCHAR(50),
    Capacity INT
);

-- 4. Matches
CREATE TABLE Matches (
    MatchID INT PRIMARY KEY,
    Date DATE,
    StadiumID INT,
    Team1ID INT,
    Team2ID INT,
    WinnerID INT,
    FOREIGN KEY (StadiumID) REFERENCES Stadiums(StadiumID),
    FOREIGN KEY (Team1ID) REFERENCES Teams(TeamID),
    FOREIGN KEY (Team2ID) REFERENCES Teams(TeamID),
    FOREIGN KEY (WinnerID) REFERENCES Teams(TeamID)
);

-- 5. Scorecard
CREATE TABLE Scorecard (
    ScoreID INT PRIMARY KEY,
    MatchID INT,
    TeamID INT,
    Runs INT,
    Wickets INT,
    Overs DECIMAL(4,1),
    FOREIGN KEY (MatchID) REFERENCES Matches(MatchID),
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID)
);

-- Teams
INSERT INTO Teams VALUES
(1, 'Mumbai Indians', 'Mumbai'),
(2, 'Chennai Super Kings', 'Chennai'),
(3, 'Royal Challengers Bangalore', 'Bangalore'),
(4, 'Kolkata Knight Riders', 'Kolkata'),
(5, 'Delhi Capitals', 'Delhi'),
(6, 'Rajasthan Royals', 'Jaipur'),
(7, 'Punjab Kings', 'Mohali'),
(8, 'Sunrisers Hyderabad', 'Hyderabad'),
(9, 'Gujarat Titans', 'Ahmedabad'),
(10, 'Lucknow Super Giants', 'Lucknow');

-- Players
INSERT INTO Players VALUES
(1, 'Rohit Sharma', 'Batsman', 1),
(2, 'MS Dhoni', 'Wicket-Keeper', 2),
(3, 'Virat Kohli', 'Batsman', 3),
(4, 'Andre Russell', 'All-rounder', 4),
(5, 'Rishabh Pant', 'Batsman', 5),
(6, 'Sanju Samson', 'Batsman', 6),
(7, 'Shikhar Dhawan', 'Batsman', 7),
(8, 'Kane Williamson', 'Batsman', 8),
(9, 'Hardik Pandya', 'All-rounder', 9),
(10, 'KL Rahul', 'Batsman', 10);

-- Stadiums
INSERT INTO Stadiums VALUES
(1, 'Wankhede Stadium', 'Mumbai', 33000),
(2, 'M. A. Chidambaram Stadium', 'Chennai', 50000),
(3, 'M. Chinnaswamy Stadium', 'Bangalore', 40000),
(4, 'Eden Gardens', 'Kolkata', 66000),
(5, 'Arun Jaitley Stadium', 'Delhi', 48000);

-- Matches
INSERT INTO Matches VALUES
(1, '2023-04-01', 1, 1, 2, 2),
(2, '2023-04-02', 2, 3, 4, 3),
(3, '2023-04-03', 3, 5, 6, 6),
(4, '2023-04-04', 4, 7, 8, 7),
(5, '2023-04-05', 5, 9, 10, 9);

-- Scorecard
INSERT INTO Scorecard VALUES
(1, 1, 1, 180, 6, 20.0),
(2, 1, 2, 185, 5, 19.3),
(3, 2, 3, 200, 4, 20.0),
(4, 2, 4, 195, 7, 20.0),
(5, 3, 5, 170, 8, 20.0),
(6, 3, 6, 175, 6, 19.4),
(7, 4, 7, 190, 5, 20.0),
(8, 4, 8, 180, 9, 20.0),
(9, 5, 9, 210, 3, 20.0),
(10, 5, 10, 200, 6, 20.0);

ALTER TABLE Teams
ADD Captain VARCHAR(50);
UPDATE Teams SET Captain = 'Rohit Sharma' WHERE TeamID = 1;
UPDATE Teams SET Captain = 'MS Dhoni' WHERE TeamID = 2;
UPDATE Teams SET Captain = 'Virat Kohli' WHERE TeamID = 3;
UPDATE Teams SET Captain = 'Andre Russell' WHERE TeamID = 4;
UPDATE Teams SET Captain = 'Rishabh Pant' WHERE TeamID = 5;
UPDATE Teams SET Captain = 'Sanju Samson' WHERE TeamID = 6;
UPDATE Teams SET Captain = 'Shikhar Dhawan' WHERE TeamID = 7;
UPDATE Teams SET Captain = 'Kane Williamson' WHERE TeamID = 8;
UPDATE Teams SET Captain = 'Hardik Pandya' WHERE TeamID = 9;
UPDATE Teams SET Captain = 'KL Rahul' WHERE TeamID = 10;

Select t.TeamName,max(s.Runs) as Hights_Run From Scorecard s
join Teams t  on t.TeamID = s.TeamID
group by t.TeamName 
Order by Hights_Run DESC
limit 1;

------ Question & Answer ---------

-- Q1. Show all players with their teams.
SELECT p.PlayerName, t.TeamName
FROM Players p
JOIN Teams t ON p.TeamID = t.TeamID;

-- Q2. Find only batsmen players 
SELECT TeamID,PlayerName
FROM Players
WHERE Role = 'Batsman';

-- Q3. List all matches with stadium names. 
SELECT m.MatchID, s.StadiumName, m.Date
FROM Matches m
JOIN Stadiums s ON m.StadiumID = s.StadiumID;

-- Q4. Who won each match? 
SELECT m.MatchID, t.TeamName AS Winner
FROM Matches m
JOIN Teams t ON m.WinnerID = t.TeamID;

-- Q5. List all Players and their Teams. 
SELECT p.PlayerName, t.TeamName
FROM Players p
JOIN Teams t ON p.TeamID = t.TeamID
ORDER BY t.TeamName;

-- Q6. Highest team score. 
SELECT t.TeamName, MAX(s.Runs) AS HighestScore
FROM Scorecard s
JOIN Teams t ON s.TeamID = t.TeamID
GROUP BY t.TeamName
ORDER BY HighestScore DESC
LIMIT 1;

-- Q7. Lowest team score. 
SELECT t.TeamName, min(s.Runs) AS LowestScore
FROM Scorecard s
JOIN Teams t ON s.TeamID = t.TeamID
GROUP BY t.TeamName
ORDER BY LowestScore ASC
LIMIT 1;

-- Q8. Average runs scored by each team. 
SELECT t.TeamName, AVG(s.Runs) AS AvgRuns
FROM Scorecard s
JOIN Teams t ON s.TeamID = t.TeamID
GROUP BY t.TeamName
order by AvgRuns DESC 
limit 1;

-- Q9. Top 3 matches with highest total runs. 
SELECT m.MatchID, 
       t1.TeamName AS Team1, 
       t2.TeamName AS Team2, 
       s.Runs AS TotalRuns
FROM Matches m
JOIN Teams t1 ON m.Team1ID = t1.TeamID
JOIN Teams t2 ON m.Team2ID = t2.TeamID
JOIN Scorecard s ON m.MatchID = s.MatchID
ORDER BY TotalRuns DESC
LIMIT 3;

-- Q10. Matches played in Delhi. 
SELECT m.MatchID, 
       t1.TeamName AS Team1, 
       t2.TeamName AS Team2, s.StadiumName, m.Date
FROM Matches m
JOIN Teams t1 ON m.Team1ID = t1.TeamID
JOIN Teams t2 ON m.Team2ID = t2.TeamID
JOIN Stadiums s ON m.StadiumID = s.StadiumID
WHERE s.City = 'Delhi';

-- Q11. Find how many matches each team has won. 
SELECT t.TeamName, COUNT(m.WinnerID) AS TotalWins
FROM Teams t
LEFT JOIN Matches m ON t.TeamID = m.WinnerID
GROUP BY t.TeamName
ORDER BY TotalWins DESC;

-- Q12. Player-Team mapping (sorted). 
SELECT p.PlayerName, t.TeamName
FROM Players p
JOIN Teams t ON p.TeamID = t.TeamID
ORDER BY t.TeamName, p.PlayerName;

-- Q13. Match with smallest margin of victory. 
SELECT t1.TeamName AS Team1,
       s1.Runs AS Team1Runs,
       t2.TeamName AS Team2,
       s2.Runs AS Team2Runs,
       ABS(s1.Runs - s2.Runs) AS Margin,
       tw.TeamName AS Winner
FROM Matches m
JOIN Scorecard s1 ON m.MatchID = s1.MatchID 
                  AND m.Team1ID = s1.TeamID
JOIN Scorecard s2 ON m.MatchID = s2.MatchID 
                  AND m.Team2ID = s2.TeamID
JOIN Teams t1 ON m.Team1ID = t1.TeamID
JOIN Teams t2 ON m.Team2ID = t2.TeamID
JOIN Teams tw ON m.WinnerID = tw.TeamID
ORDER BY Margin ASC
LIMIT 1;

-- Q14. Matches where both teams scored above 170.
SELECT t.Teams,m.MatchID
FROM Teams 
join Matches m ON m.Team1ID = t1.TeamID
JOIN Teams t2 ON m.Team2ID = t2.TeamID
JOIN Scorecard s1 ON m.MatchID = s1.MatchID
JOIN Scorecard s2 ON m.MatchID = s2.MatchID AND s1.TeamID <> s2.TeamID
GROUP BY m.MatchID
HAVING MIN(s1.Runs) > 170 AND MIN(s2.Runs) > 170;
 
-- Q15. Show winner team name with its runs.
SELECT m.MatchID, t.TeamName AS Winner, s.Runs
FROM Matches m
JOIN Teams t ON m.WinnerID = t.TeamID
JOIN Scorecard s ON m.MatchID = s.MatchID AND m.WinnerID = s.TeamID;


