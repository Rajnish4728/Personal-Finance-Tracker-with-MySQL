CREATE DATABASE FinanceTrackerDB;
USE FinanceTrackerDB;

CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    UserName VARCHAR(100),
    Email VARCHAR(150),
    JoinDate DATE
);

CREATE TABLE Income (
    IncomeID INT PRIMARY KEY,
    UserID INT,
    Source VARCHAR(100),
    Amount DECIMAL(10,2),
    IncomeDate DATE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Expenses (
    ExpenseID INT PRIMARY KEY,
    UserID INT,
    Category VARCHAR(100),
    Description TEXT,
    Amount DECIMAL(10,2),
    ExpenseDate DATE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE SavingGoals (
    GoalID INT PRIMARY KEY,
    UserID INT,
    GoalName VARCHAR(100),
    TargetAmount DECIMAL(10,2),
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE BudgetAlerts (
    AlertID INT PRIMARY KEY,
    UserID INT,
    Category VARCHAR(100),
    MonthlyLimit DECIMAL(10,2),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

#1. Monthly Income vs Expenses (Cash Flow Overview)

CREATE VIEW Monthly_Income AS
SELECT
    DATE_FORMAT(IncomeDate, '%Y-%m') AS Month,
    SUM(Amount) AS TotalIncome
FROM Income
GROUP BY Month
ORDER BY Month;


CREATE VIEW Monthly_Expenses AS
SELECT
    DATE_FORMAT(ExpenseDate,'%Y-%m') AS Month,
    SUM(Amount) AS TotalExpenses
FROM Expenses
GROUP BY Month;

#2. Total Savings So Far (Income - Expenses) Per User

CREATE VIEW Total_Savings_So_Far_Income_Expense_Per_User AS
SELECT 
    u.UserID,
    u.UserName,
    IFNULL(SUM(i.Amount), 0) - IFNULL(SUM(e.Amount), 0) AS NetSavings
FROM Users u
LEFT JOIN Income i ON u.UserID = i.UserID
LEFT JOIN Expenses e ON u.UserID = e.UserID
GROUP BY u.UserID;

#3. Savings Goal Progress Per User

CREATE VIEW Saving_Goal_Progress_Per_User AS
SELECT
    u.UserName,
    g.GoalName,
    g.TargetAmount,
    ROUND((IFNULL(i.TotalIncome,0) - IFNULL(e.TotalExpenses,0)) /g.TargetAmount *100,2) AS GoalProgressPercent
FROM SavingGoals g
JOIN Users u ON g.UserID = u.UserID
LEFT JOIN (
SELECT UserID,SUM(Amount) AS TotalIncome FROM Income GROUP BY UserID
) i ON g.UserID = i.UserID
LEFT JOIN (
SELECT UserID,SUM(Amount) AS TotalExpenses FROM Expenses GROUP BY UserID
) e ON g.UserID = e.UserID;

#4. Spending Over Budget (Monthly Category-Wise Alert)

CREATE VIEW Spending_Over_Budget_Monthly_Category_Wise_Alert AS
SELECT 
    e.UserID,
    u.UserName,
    e.Category,
    DATE_FORMAT(e.ExpenseDate, '%Y-%m') AS Month,
    SUM(e.Amount) AS TotalSpent,
    ba.MonthlyLimit,
    CASE 
        WHEN SUM(e.Amount) > ba.MonthlyLimit THEN 'Over Budget'
        ELSE 'Within Budget'
    END AS Status
FROM Expenses e
JOIN BudgetAlerts ba 
    ON e.UserID = ba.UserID AND e.Category = ba.Category
JOIN Users u 
    ON e.UserID = u.UserID
GROUP BY 
    e.UserID,
    u.UserName,
    e.Category,
    ba.MonthlyLimit,
    DATE_FORMAT(e.ExpenseDate, '%Y-%m')
ORDER BY 
    Month, e.UserID;
    
   # 5. Top 3 Spending Categories per User
   
   CREATE VIEW Top_3_Spending_Categories_Per_User AS
   SELECT
       UserID,
       Category,
       SUM(Amount) AS TotalSpent
	FROM Expenses
    GROUP BY UserID,Category
    ORDER BY UserID,TotalSpent DESC;
    
     #6. Total Income and Expenses Summary
     
     CREATE VIEW Total_Income_And_Expenses_Summary AS
     SELECT 
    u.UserName,
    IFNULL(SUM(i.Amount), 0) AS TotalIncome,
    IFNULL(SUM(e.Amount), 0) AS TotalExpenses,
    IFNULL(SUM(i.Amount), 0) - IFNULL(SUM(e.Amount), 0) AS `Net Balance`
FROM Users u
LEFT JOIN Income i ON u.UserID = i.UserID
LEFT JOIN Expenses e ON u.UserID = e.UserID
GROUP BY u.UserID;

#Lets Run Create View Queries

#1 Monthly_Income
SELECT * FROM Monthly_Income;
SELECT * FROM Monthly_Expenses;

#2. Total_Savings_So_Far_Income_Expenses_per_User
SELECT * FROM Total_Savings_So_Far_Income_Expense_Per_User;

#3.Savings Goal Progress Per User
SELECT * FROM Saving_Goal_Progress_Per_User;

#4.Spending Over Budget (Monthly Category-Wise Alert)
SELECT * FROM Spending_Over_Budget_Monthly_Category_Wise_Alert;

#5. Top 3 Spending Categories per User
SELECT * FROM Top_3_Spending_Categories_Per_User;

#6. Total Income and Expenses Summary
SELECT * FROM Total_Income_And_Expenses_Summary;


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


    
    
    
    
    








































 















ORDER BY Month;



















































