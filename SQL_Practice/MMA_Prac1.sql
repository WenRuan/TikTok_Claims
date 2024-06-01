-------------------------------------------------------------------------------------------------
-- Introduction
-------------------------------------------------------------------------------------------------
-- All data necessary for this exercise is provided as part of this script.
-- Fill in your solution in the provided space.
-- Executing the entire script should result in rows selected from the tables populated from your solution.

-- Mixed Martial Arts academy has various locations around the world.
-- It is owned by three partners that each has different shares of the company.
-- The partners share the profit of the business based on their shares.

-- Not all fields may be utilized in this test as there are different variations of this test using the same dataset.
-- For your efficiency, review the questions first before analyzing the table structure
-- so that irrelevant data can be skipped.

IF OBJECT_ID('tempdb.dbo.#partners') IS NOT NULL DROP TABLE #partners
CREATE TABLE #partners
(
    OwnerCode NVARCHAR(10)
    ,OwnerName NVARCHAR(100)
    ,Share FLOAT
)

INSERT INTO #partners
VALUES
('IPM', 'Ip Man'         , 40)    
,('CHN', 'Chuck Norris'  , 25)
,('MHA', 'Muhammad Ali'  , 35);

-- Mixed martial arts academy has its location information stored in below table
-- Each location has a set monthly membership fee for students in local currency
IF OBJECT_ID('tempdb.dbo.#locations') IS NOT NULL DROP TABLE #locations
CREATE TABLE #locations
(
    LocationCode NVARCHAR(10)
    ,LocationName NVARCHAR(100)
    ,StateCode NVARCHAR(2)
    ,CountryCode NVARCHAR(3)
    ,CurrencyCode NVARCHAR(3)
    ,MonthlyMembershipFee FLOAT
)

INSERT INTO #locations
VALUES 
('RNO', 'Reno', 'NV', 'USA', 'USD', 3200)
, ('PHX', 'Phoenix', 'AZ', 'USA', 'USD', 3700)
, ('SAN', 'San Diego', 'CA', 'USA', 'USD', 3900)
, ('LGB', 'Long Beach', 'CA', 'USA', 'USD', 3700)
, ('YOW', 'Ottawa', 'ON', 'CAN', 'CAD', 4500)
, ('YYZ', 'Toronto', 'ON', 'CAN', 'CAD', 5000)
, ('TAE', 'Daegu', NULL, 'ROK', 'KRW', 6300000)
, ('BEY', 'Beirut', NULL, 'LEB', 'LBP', 6450000);

-- Following table contains list of instructors and their information
-- rate and salary are in local currency
IF OBJECT_ID('tempdb.dbo.#instructors') IS NOT NULL DROP TABLE #instructors
CREATE TABLE #instructors
(
    InstructorCode NVARCHAR(10)
    ,InstructorName NVARCHAR(100)
    ,LocationCode NVARCHAR(MAX)
    ,ClassCodes NVARCHAR(MAX)
    ,Rate FLOAT -- Rate charged to students per hour on private lessons
    ,StartYear INT
    ,Salary FLOAT -- Yearly salary paid to the instructor
)

INSERT INTO #instructors
VALUES 
('TMJ', 'Tom Jones'         , 'RNO', 'KFU;UFC;BJJ'                      , 800       , 2010 , 75000)
,('JYZ', 'Joe Zoghbi'       , 'PHX', 'NEG;UFC;WRS'                      , 800       , 2016 , 75000)
,('YSH', 'Soo Yoon'         , 'TAE', 'BJJ;MTH;PSM'                      , 470000    , 2012 , 82000000)
,('TCH', 'Truman Chan'      , 'RNO', 'BJJ;NEG;ESC;WRS'                  , 400       , 2015 , 75000)
,('TNG', 'Timmy Ngo'        , 'YYZ', 'BJJ;MTH;KFU;WRS;NEG;UFC;ESC;PWR'  , 900       , 2017 , 100000)
,('SHM', 'Samer Hamam'      , 'BEY', 'NEG;UFC;BJJ;MTH;WRS'              , 900000    , 2020 , 93000000)
,('SDN', 'Saad Nahlous'     , 'YOW', 'MTH;UFC;KFU;ESC;PWR'              , 800       , 2019 , 80000)
,('SZB', 'Suzan Balaa'      , 'LGB', 'NEG;UFC;KFU;WRS'                  , 800       , 2017 , 90000)
,('RRZ', 'Rejane Rizkallah' , 'SAN', 'MTH;UFC;ESC'					    , 800       , 2018 , 93000);

-- Students with membership are stored in below table.    
-- Membership is a fixed monthly fee charged to students. 
-- Private lessons are separately charged by the hour based on the instructor's rate
IF OBJECT_ID('tempdb.dbo.#students') IS NOT NULL DROP TABLE #students
CREATE TABLE #students
(
    StudentCode NVARCHAR(10)
    ,FirstName NVARCHAR(100)
    ,LastName NVARCHAR(100)
    ,LocationCode NVARCHAR(3)
    ,Active NVARCHAR(1) -- 'Y' for active member, 'N' for inactive member
    ,DiscountRate FLOAT -- Contains rate of membership fee addition/reduction.  For example, 0.2 implies 20% reduced membership fee, -0.3 implies 30% increased membership fee.  If the location's monthly membership fee is 100, student with DiscountRate = 0.2 pays 80 a month
    ,StartDate DATE -- start date of current membership always on 1st of the month
    ,TerminationDate DATE -- termination date of membership always on 1st of the month
    ,LastStartDate DATE -- If the student had terminated the membership in the past and restarted the membership, this field is populated with last start date.  If the student never has terminated the membership, this field doesn't contain a valid date
)

INSERT INTO #students
SELECT '0001', 'Cameron', 'Slater', 'RNO', 'Y', 0.4, '2021-12-01', NULL, '2021-07-01'
UNION ALL SELECT '0002', 'Anne', 'Black', 'RNO', 'N', NULL, '2020-12-01', '2021-04-01', NULL
UNION ALL SELECT '0003', 'Leonard', 'Mills', 'YOW', 'Y', NULL, '2020-07-01', NULL, NULL
UNION ALL SELECT '0004', 'Irene', 'Coleman', 'YYZ', 'Y', 0.4, '2022-02-01', NULL, NULL
UNION ALL SELECT '0005', 'Irene', 'Butler', 'SAN', 'Y', 0.3, '2021-01-01', NULL, '2020-10-01'
UNION ALL SELECT '0006', 'Madeleine', 'Pullman', 'PHX', 'Y', -0.2, '2022-10-01', NULL, NULL
UNION ALL SELECT '0007', 'Natalie', 'Edmunds', 'RNO', 'Y', NULL, '2020-09-01', NULL, NULL
UNION ALL SELECT '0008', 'Heather', 'Randall', 'LGB', 'Y', NULL, '2021-10-01', NULL, '2021-07-01'
UNION ALL SELECT '0009', 'Frank', 'Tucker', 'YYZ', 'Y', -0.1, '2021-01-01', NULL, NULL
UNION ALL SELECT '0010', 'Virginia', 'Forsyth', 'BEY', 'Y', NULL, '2020-08-01', NULL, NULL
UNION ALL SELECT '0011', 'Faith', 'Paige', 'LGB', 'Y', NULL, '2020-10-01', NULL, NULL
UNION ALL SELECT '0012', 'Irene', 'North', 'RNO', 'Y', NULL, '2022-04-01', NULL, '2022-02-01'
UNION ALL SELECT '0013', 'Diana', 'Wright', 'LGB', 'Y', -0.2, '2021-03-01', NULL, NULL
UNION ALL SELECT '0014', 'Joshua', 'North', 'YOW', 'Y', 0.4, '2020-09-01', NULL, '2020-06-01'
UNION ALL SELECT '0015', 'Irene', 'Oliver', 'BEY', 'Y', NULL, '2021-02-01', NULL, NULL
UNION ALL SELECT '0016', 'Robert', 'Pullman', 'LGB', 'Y', NULL, '2022-04-01', NULL, NULL
UNION ALL SELECT '0017', 'Kylie', 'Lawrence', 'PHX', 'Y', -0.1, '2021-02-01', NULL, NULL
UNION ALL SELECT '0018', 'Warren', 'Clarkson', 'RNO', 'N', NULL, '2020-09-01', '2021-02-01', '2020-05-01'
UNION ALL SELECT '0019', 'Ava', 'Mathis', 'YYZ', 'Y', NULL, '2021-04-01', NULL, '2021-02-01'
UNION ALL SELECT '0020', 'Sally', 'Turner', 'TAE', 'Y', 0.4, '2022-06-01', NULL, NULL
UNION ALL SELECT '0021', 'Leah', 'Cameron', 'TAE', 'N', NULL, '2020-04-01', '2020-08-01', '2019-12-01'
UNION ALL SELECT '0022', 'Diane', 'Abraham', 'LGB', 'Y', 0.1, '2022-05-01', NULL, '2022-02-01'
UNION ALL SELECT '0023', 'Diana', 'Ross', 'YOW', 'Y', NULL, '2022-03-01', NULL, '2022-01-01'
UNION ALL SELECT '0024', 'Rachel', 'Hudson', 'PHX', 'Y', 0.1, '2021-07-01', NULL, NULL
UNION ALL SELECT '0025', 'Joanne', 'Chapman', 'SAN', 'Y', NULL, '2021-05-01', NULL, NULL
UNION ALL SELECT '0026', 'Amy', 'Avery', 'TAE', 'Y', NULL, '2020-06-01', NULL, '2020-01-01'
UNION ALL SELECT '0027', 'Nathan', 'Scott', 'BEY', 'Y', NULL, '2022-05-01', NULL, NULL
UNION ALL SELECT '0028', 'Owen', 'Blake', 'RNO', 'Y', NULL, '2022-07-01', NULL, NULL
UNION ALL SELECT '0029', 'Justin', 'Abraham', 'RNO', 'Y', NULL, '2021-04-01', NULL, NULL
UNION ALL SELECT '0030', 'Kevin', 'Avery', 'YOW', 'Y', NULL, '2021-08-01', NULL, NULL
UNION ALL SELECT '0031', 'Joan', 'Alsop', 'YOW', 'Y', NULL, '2020-04-01', NULL, NULL
UNION ALL SELECT '0032', 'Emma', 'Lewis', 'YOW', 'Y', NULL, '2022-07-01', NULL, '2022-05-01'
UNION ALL SELECT '0033', 'Madeleine', 'Newman', 'LGB', 'Y', NULL, '2021-05-01', NULL, '2021-02-01'
UNION ALL SELECT '0034', 'Gavin', 'Welch', 'BEY', 'Y', -0.1, '2020-12-01', NULL, NULL
UNION ALL SELECT '0035', 'Sally', 'Baker', 'LGB', 'Y', NULL, '2022-01-01', NULL, '2021-09-01'
UNION ALL SELECT '0036', 'Leonard', 'Marshall', 'YOW', 'Y', NULL, '2020-09-01', NULL, '2020-05-01'
UNION ALL SELECT '0037', 'Ryan', 'Terry', 'PHX', 'Y', 0.3, '2022-09-01', NULL, NULL
UNION ALL SELECT '0038', 'Jacob', 'Morgan', 'BEY', 'Y', -0.2, '2020-08-01', NULL, NULL
UNION ALL SELECT '0039', 'Gavin', 'Jones', 'YOW', 'Y', -0.1, '2020-09-01', NULL, '2020-07-01'
UNION ALL SELECT '0040', 'Joseph', 'Taylor', 'YYZ', 'Y', -0.2, '2020-12-01', NULL, NULL
UNION ALL SELECT '0041', 'Matt', 'Coleman', 'TAE', 'Y', 0.1, '2022-04-01', NULL, '2022-01-01'
UNION ALL SELECT '0042', 'Sophie', 'King', 'SAN', 'Y', NULL, '2021-01-01', NULL, NULL
UNION ALL SELECT '0043', 'Wanda', 'Forsyth', 'YYZ', 'Y', NULL, '2021-08-01', NULL, '2021-04-01'
UNION ALL SELECT '0044', 'Jan', 'James', 'SAN', 'Y', -0.1, '2021-11-01', NULL, NULL
UNION ALL SELECT '0045', 'Amy', 'Hunter', 'LGB', 'Y', NULL, '2021-09-01', NULL, NULL
UNION ALL SELECT '0046', 'Elizabeth', 'Powell', 'RNO', 'Y', NULL, '2022-05-01', NULL, NULL
UNION ALL SELECT '0047', 'Jake', 'Hart', 'LGB', 'Y', 0.2, '2021-04-01', NULL, NULL
UNION ALL SELECT '0048', 'Sonia', 'Underwood', 'YYZ', 'Y', NULL, '2021-03-01', NULL, NULL
UNION ALL SELECT '0049', 'Andrea', 'Buckland', 'YYZ', 'Y', 0.3, '2020-10-01', NULL, NULL
UNION ALL SELECT '0050', 'Stewart', 'Sutherland', 'TAE', 'Y', NULL, '2022-07-01', NULL, '2022-04-01'
UNION ALL SELECT '0051', 'Owen', 'James', 'PHX', 'Y', 0.3, '2021-06-01', NULL, '2021-02-01'
UNION ALL SELECT '0052', 'Joseph', 'Cameron', 'YYZ', 'Y', NULL, '2021-04-01', NULL, NULL
UNION ALL SELECT '0053', 'Jane', 'Welch', 'LGB', 'N', NULL, '2020-04-01', '2020-07-01', '2020-02-01'
UNION ALL SELECT '0054', 'Michelle', 'Baker', 'TAE', 'N', 0.4, '2021-07-01', '2021-10-01', NULL
UNION ALL SELECT '0055', 'Diana', 'Rampling', 'SAN', 'Y', 0.4, '2021-07-01', NULL, NULL
UNION ALL SELECT '0056', 'Oliver', 'Walker', 'YYZ', 'Y', NULL, '2022-10-01', NULL, NULL
UNION ALL SELECT '0057', 'Mary', 'Henderson', 'LGB', 'Y', NULL, '2020-05-01', NULL, '2020-02-01'
UNION ALL SELECT '0058', 'Melanie', 'Avery', 'TAE', 'Y', 0.3, '2022-09-01', NULL, NULL
UNION ALL SELECT '0059', 'Hannah', 'Vance', 'YOW', 'Y', NULL, '2020-05-01', NULL, NULL
UNION ALL SELECT '0060', 'Ryan', 'Smith', 'BEY', 'Y', NULL, '2022-08-01', NULL, NULL
UNION ALL SELECT '0061', 'Bernadette', 'Hill', 'RNO', 'Y', NULL, '2021-07-01', NULL, '2021-03-01'
UNION ALL SELECT '0062', 'Rachel', 'Henderson', 'TAE', 'Y', NULL, '2020-10-01', NULL, NULL
UNION ALL SELECT '0063', 'Lisa', 'Springer', 'YYZ', 'Y', NULL, '2021-10-01', NULL, '2021-06-01'
UNION ALL SELECT '0064', 'Andrew', 'Sanderson', 'SAN', 'Y', NULL, '2021-09-01', NULL, NULL
UNION ALL SELECT '0065', 'Stephen', 'Tucker', 'RNO', 'Y', NULL, '2021-07-01', NULL, NULL
UNION ALL SELECT '0066', 'Liam', 'Mills', 'SAN', 'Y', NULL, '2021-10-01', NULL, NULL
UNION ALL SELECT '0067', 'Edward', 'Clark', 'YOW', 'Y', NULL, '2021-07-01', NULL, NULL
UNION ALL SELECT '0068', 'Julian', 'Bailey', 'BEY', 'Y', 0.4, '2021-06-01', NULL, '2021-04-01'
UNION ALL SELECT '0069', 'Thomas', 'Coleman', 'LGB', 'Y', -0.2, '2022-01-01', NULL, '2021-11-01'
UNION ALL SELECT '0070', 'Paul', 'Bell', 'YOW', 'Y', NULL, '2021-09-01', NULL, '2021-06-01'
UNION ALL SELECT '0071', 'Eric', 'Mitchell', 'RNO', 'Y', NULL, '2020-12-01', NULL, '2020-09-01'
UNION ALL SELECT '0072', 'Melanie', 'Johnston', 'YOW', 'Y', 0.1, '2020-09-01', NULL, NULL
UNION ALL SELECT '0073', 'Leah', 'Hardacre', 'SAN', 'Y', NULL, '2021-10-01', NULL, '2021-05-01'
UNION ALL SELECT '0074', 'Amy', 'Morrison', 'LGB', 'Y', NULL, '2021-07-01', NULL, '2021-03-01'
UNION ALL SELECT '0075', 'Joanne', 'Welch', 'YOW', 'Y', NULL, '2021-06-01', NULL, '2021-01-01'
UNION ALL SELECT '0076', 'Justin', 'Taylor', 'YYZ', 'Y', NULL, '2021-12-01', NULL, NULL
UNION ALL SELECT '0077', 'Joanne', 'Hemmings', 'YOW', 'Y', -0.1, '2020-09-01', NULL, '2020-06-01'
UNION ALL SELECT '0078', 'Jan', 'Reid', 'TAE', 'Y', NULL, '2021-06-01', NULL, NULL
UNION ALL SELECT '0079', 'Joshua', 'Black', 'SAN', 'Y', 0.2, '2022-03-01', NULL, NULL
UNION ALL SELECT '0080', 'Sue', 'Coleman', 'SAN', 'Y', NULL, '2021-09-01', NULL, NULL
UNION ALL SELECT '0081', 'David', 'Gill', 'RNO', 'Y', NULL, '2022-01-01', NULL, '2021-11-01'
UNION ALL SELECT '0082', 'Matt', 'Ball', 'LGB', 'N', 0.1, '2020-10-01', '2020-12-01', '2020-06-01'
UNION ALL SELECT '0083', 'Audrey', 'Brown', 'LGB', 'Y', NULL, '2021-08-01', NULL, NULL
UNION ALL SELECT '0084', 'Vanessa', 'Springer', 'BEY', 'N', 0.4, '2021-12-01', '2022-05-01', '2021-09-01'
UNION ALL SELECT '0085', 'Austin', 'Morrison', 'RNO', 'Y', 0.4, '2021-05-01', NULL, '2020-12-01'
UNION ALL SELECT '0086', 'Max', 'Oliver', 'PHX', 'Y', NULL, '2021-07-01', NULL, NULL
UNION ALL SELECT '0087', 'Dylan', 'Brown', 'TAE', 'Y', -0.1, '2020-09-01', NULL, NULL
UNION ALL SELECT '0088', 'Tracey', 'MacDonald', 'BEY', 'N', 0.2, '2022-07-01', '2022-12-01', '2022-05-01'
UNION ALL SELECT '0089', 'Rebecca', 'Wilson', 'LGB', 'Y', NULL, '2020-08-01', NULL, '2020-06-01'
UNION ALL SELECT '0090', 'Sophie', 'Fisher', 'YOW', 'Y', NULL, '2020-04-01', NULL, '2019-11-01'
UNION ALL SELECT '0091', 'Adam', 'Sanderson', 'TAE', 'Y', NULL, '2021-11-01', NULL, NULL
UNION ALL SELECT '0092', 'Jennifer', 'Dickens', 'RNO', 'Y', 0.3, '2020-11-01', NULL, NULL
UNION ALL SELECT '0093', 'Wendy', 'Ball', 'TAE', 'N', NULL, '2022-03-01', '2022-07-01', NULL
UNION ALL SELECT '0094', 'Stephen', 'Bower', 'RNO', 'N', 0.3, '2022-02-01', '2022-07-01', NULL
UNION ALL SELECT '0095', 'Alan', 'Peake', 'BEY', 'Y', NULL, '2022-04-01', NULL, NULL
UNION ALL SELECT '0096', 'Jason', 'Hamilton', 'YOW', 'Y', NULL, '2021-12-01', NULL, '2021-09-01'
UNION ALL SELECT '0097', 'Michael', 'Rampling', 'YOW', 'Y', 0.3, '2021-09-01', NULL, '2021-07-01'
UNION ALL SELECT '0098', 'Joan', 'Kerr', 'YOW', 'Y', 0.3, '2020-12-01', NULL, NULL
UNION ALL SELECT '0099', 'Amy', 'Gibson', 'RNO', 'Y', NULL, '2022-04-01', NULL, NULL
UNION ALL SELECT '0100', 'Ava', 'Jones', 'BEY', 'N', 0.2, '2020-10-01', '2020-12-01', NULL

-- below table contains exchange rate for currencies 
-- USD is the system currency (USD=1.0000)
IF OBJECT_ID('tempdb.dbo.#fxrate') IS NOT NULL DROP TABLE #fxrate
CREATE TABLE #fxrate
(
    EffectiveDate DATETIME
    ,Rate FLOAT
    ,CurrencyCode NVARCHAR(3)
)
-- insert fxrate lookup
INSERT INTO #fxrate
SELECT '2020-12-28', 1.2727, 'CAD' 
UNION ALL SELECT '2021-01-04', 1.2683, 'CAD' 
UNION ALL SELECT '2021-01-11', 1.2732, 'CAD' 
UNION ALL SELECT '2021-01-18', 1.2735, 'CAD' 
UNION ALL SELECT '2021-01-25', 1.2777, 'CAD' 
UNION ALL SELECT '2021-02-01', 1.2751, 'CAD' 
UNION ALL SELECT '2021-02-08', 1.2694, 'CAD' 
UNION ALL SELECT '2021-02-15', 1.261, 'CAD' 
UNION ALL SELECT '2021-02-22', 1.2739, 'CAD' 
UNION ALL SELECT '2021-03-01', 1.2655, 'CAD' 
UNION ALL SELECT '2021-03-08', 1.2471, 'CAD' 
UNION ALL SELECT '2021-03-15', 1.2497, 'CAD' 
UNION ALL SELECT '2021-03-22', 1.2576, 'CAD' 
UNION ALL SELECT '2021-03-29', 1.2573, 'CAD' 
UNION ALL SELECT '2021-04-05', 1.2527, 'CAD' 
UNION ALL SELECT '2021-04-12', 1.2504, 'CAD' 
UNION ALL SELECT '2021-04-19', 1.2475, 'CAD' 
UNION ALL SELECT '2021-04-26', 1.2289, 'CAD' 
UNION ALL SELECT '2021-05-03', 1.213, 'CAD' 
UNION ALL SELECT '2021-05-10', 1.2102, 'CAD' 
UNION ALL SELECT '2021-05-17', 1.2066, 'CAD' 
UNION ALL SELECT '2021-05-24', 1.2068, 'CAD' 
UNION ALL SELECT '2021-05-31', 1.2079, 'CAD' 
UNION ALL SELECT '2021-06-07', 1.2155, 'CAD' 
UNION ALL SELECT '2021-06-14', 1.2462, 'CAD' 
UNION ALL SELECT '2021-06-21', 1.2294, 'CAD' 
UNION ALL SELECT '2021-06-28', 1.2319, 'CAD' 
UNION ALL SELECT '2021-07-05', 1.2446, 'CAD' 
UNION ALL SELECT '2021-07-12', 1.2611, 'CAD' 
UNION ALL SELECT '2021-07-19', 1.2561, 'CAD' 
UNION ALL SELECT '2021-07-26', 1.247, 'CAD' 
UNION ALL SELECT '2021-08-02', 1.2552, 'CAD' 
UNION ALL SELECT '2021-08-09', 1.2513, 'CAD' 
UNION ALL SELECT '2021-08-16', 1.2821, 'CAD' 
UNION ALL SELECT '2021-08-23', 1.2626, 'CAD' 
UNION ALL SELECT '2021-08-30', 1.2526, 'CAD' 
UNION ALL SELECT '2021-09-06', 1.2689, 'CAD' 
UNION ALL SELECT '2021-09-13', 1.2766, 'CAD' 
UNION ALL SELECT '2021-09-20', 1.2652, 'CAD' 
UNION ALL SELECT '2021-09-27', 1.2647, 'CAD' 
UNION ALL SELECT '2021-10-04', 1.2469, 'CAD' 
UNION ALL SELECT '2021-10-11', 1.2366, 'CAD' 
UNION ALL SELECT '2021-10-18', 1.2367, 'CAD' 
UNION ALL SELECT '2021-10-25', 1.2387, 'CAD' 
UNION ALL SELECT '2021-11-01', 1.2454, 'CAD' 
UNION ALL SELECT '2021-11-08', 1.2542, 'CAD' 
UNION ALL SELECT '2021-11-15', 1.2638, 'CAD' 
UNION ALL SELECT '2021-11-22', 1.2786, 'CAD' 
UNION ALL SELECT '2021-11-29', 1.2842, 'CAD' 
UNION ALL SELECT '2021-12-06', 1.272, 'CAD' 
UNION ALL SELECT '2021-12-13', 1.2886, 'CAD' 
UNION ALL SELECT '2021-12-20', 1.281, 'CAD' 
UNION ALL SELECT '2021-12-27', 1.2634, 'CAD' 
UNION ALL SELECT '2020-12-28', 1505.7, 'LBP' 
UNION ALL SELECT '2021-01-04', 1505.7, 'LBP' 
UNION ALL SELECT '2021-01-11', 1505.7, 'LBP' 
UNION ALL SELECT '2021-01-18', 1505.5, 'LBP' 
UNION ALL SELECT '2021-01-25', 1505.7, 'LBP' 
UNION ALL SELECT '2021-02-01', 1505.5, 'LBP' 
UNION ALL SELECT '2021-02-08', 1505.7, 'LBP' 
UNION ALL SELECT '2021-02-15', 1505.7, 'LBP' 
UNION ALL SELECT '2021-02-22', 1505.5, 'LBP' 
UNION ALL SELECT '2021-03-01', 1505.7, 'LBP' 
UNION ALL SELECT '2021-03-08', 1505.7, 'LBP' 
UNION ALL SELECT '2021-03-15', 1505.5, 'LBP' 
UNION ALL SELECT '2021-03-22', 1505.7, 'LBP' 
UNION ALL SELECT '2021-03-29', 1505.5, 'LBP' 
UNION ALL SELECT '2021-04-05', 1505.5, 'LBP' 
UNION ALL SELECT '2021-04-12', 1505.5, 'LBP' 
UNION ALL SELECT '2021-04-19', 1505.7, 'LBP' 
UNION ALL SELECT '2021-04-26', 1505.7, 'LBP' 
UNION ALL SELECT '2021-05-03', 1501.55, 'LBP' 
UNION ALL SELECT '2021-05-10', 1501.5, 'LBP' 
UNION ALL SELECT '2021-05-17', 1501.7, 'LBP' 
UNION ALL SELECT '2021-05-24', 1501.7, 'LBP' 
UNION ALL SELECT '2021-05-31', 1501.5, 'LBP' 
UNION ALL SELECT '2021-06-07', 1501.5, 'LBP' 
UNION ALL SELECT '2021-06-14', 1505.7, 'LBP' 
UNION ALL SELECT '2021-06-21', 1505.5, 'LBP' 
UNION ALL SELECT '2021-06-28', 1505.7, 'LBP' 
UNION ALL SELECT '2021-07-05', 1505.7, 'LBP' 
UNION ALL SELECT '2021-07-12', 1505.7, 'LBP' 
UNION ALL SELECT '2021-07-19', 1505.5, 'LBP' 
UNION ALL SELECT '2021-07-26', 1505.7, 'LBP' 
UNION ALL SELECT '2021-08-02', 1505.5, 'LBP' 
UNION ALL SELECT '2021-08-09', 1505.7, 'LBP' 
UNION ALL SELECT '2021-08-16', 1505.5, 'LBP' 
UNION ALL SELECT '2021-08-23', 1505.7, 'LBP' 
UNION ALL SELECT '2021-08-30', 1505.5, 'LBP' 
UNION ALL SELECT '2021-09-06', 1502.49, 'LBP' 
UNION ALL SELECT '2021-09-13', 1505.7, 'LBP' 
UNION ALL SELECT '2021-09-20', 1505.5, 'LBP' 
UNION ALL SELECT '2021-09-27', 1505.7, 'LBP' 
UNION ALL SELECT '2021-10-04', 1505.5, 'LBP' 
UNION ALL SELECT '2021-10-11', 1505.7, 'LBP' 
UNION ALL SELECT '2021-10-18', 1503.49, 'LBP' 
UNION ALL SELECT '2021-10-25', 1505.5, 'LBP' 
UNION ALL SELECT '2021-11-01', 1505.5, 'LBP' 
UNION ALL SELECT '2021-11-08', 1504.49, 'LBP' 
UNION ALL SELECT '2021-11-15', 1505.5, 'LBP' 
UNION ALL SELECT '2021-11-22', 1503.99, 'LBP' 
UNION ALL SELECT '2021-11-29', 1503.99, 'LBP' 
UNION ALL SELECT '2021-12-06', 1505.7, 'LBP' 
UNION ALL SELECT '2021-12-13', 1505.49, 'LBP' 
UNION ALL SELECT '2021-12-20', 1507, 'LBP' 
UNION ALL SELECT '2021-12-27', 1505.7, 'LBP' 
UNION ALL SELECT '2020-12-28', 1084.73, 'KRW' 
UNION ALL SELECT '2021-01-04', 1092.93, 'KRW' 
UNION ALL SELECT '2021-01-11', 1103.27, 'KRW' 
UNION ALL SELECT '2021-01-18', 1105.41, 'KRW' 
UNION ALL SELECT '2021-01-25', 1117.64, 'KRW' 
UNION ALL SELECT '2021-02-01', 1116.77, 'KRW' 
UNION ALL SELECT '2021-02-08', 1102.59, 'KRW' 
UNION ALL SELECT '2021-02-15', 1104.27, 'KRW' 
UNION ALL SELECT '2021-02-22', 1123.89, 'KRW' 
UNION ALL SELECT '2021-03-01', 1128, 'KRW' 
UNION ALL SELECT '2021-03-08', 1136, 'KRW' 
UNION ALL SELECT '2021-03-15', 1129.12, 'KRW' 
UNION ALL SELECT '2021-03-22', 1128.52, 'KRW' 
UNION ALL SELECT '2021-03-29', 1128.64, 'KRW' 
UNION ALL SELECT '2021-04-05', 1120.98, 'KRW' 
UNION ALL SELECT '2021-04-12', 1116.5, 'KRW' 
UNION ALL SELECT '2021-04-19', 1114.72, 'KRW' 
UNION ALL SELECT '2021-04-26', 1117.16, 'KRW' 
UNION ALL SELECT '2021-05-03', 1111.23, 'KRW' 
UNION ALL SELECT '2021-05-10', 1125.79, 'KRW' 
UNION ALL SELECT '2021-05-17', 1127.63, 'KRW' 
UNION ALL SELECT '2021-05-24', 1113.08, 'KRW' 
UNION ALL SELECT '2021-05-31', 1110.52, 'KRW' 
UNION ALL SELECT '2021-06-07', 1116.4, 'KRW' 
UNION ALL SELECT '2021-06-14', 1134.94, 'KRW' 
UNION ALL SELECT '2021-06-21', 1127.12, 'KRW' 
UNION ALL SELECT '2021-06-28', 1130.53, 'KRW' 
UNION ALL SELECT '2021-07-05', 1143.73, 'KRW' 
UNION ALL SELECT '2021-07-12', 1141.51, 'KRW' 
UNION ALL SELECT '2021-07-19', 1151.52, 'KRW' 
UNION ALL SELECT '2021-07-26', 1151.41, 'KRW' 
UNION ALL SELECT '2021-08-02', 1144.93, 'KRW' 
UNION ALL SELECT '2021-08-09', 1161.37, 'KRW' 
UNION ALL SELECT '2021-08-16', 1175.15, 'KRW' 
UNION ALL SELECT '2021-08-23', 1161.23, 'KRW' 
UNION ALL SELECT '2021-08-30', 1154.28, 'KRW' 
UNION ALL SELECT '2021-09-06', 1170.23, 'KRW' 
UNION ALL SELECT '2021-09-13', 1180.69, 'KRW' 
UNION ALL SELECT '2021-09-20', 1179.68, 'KRW' 
UNION ALL SELECT '2021-09-27', 1180.35, 'KRW' 
UNION ALL SELECT '2021-10-04', 1196.79, 'KRW' 
UNION ALL SELECT '2021-10-11', 1182.07, 'KRW' 
UNION ALL SELECT '2021-10-18', 1177.48, 'KRW' 
UNION ALL SELECT '2021-10-25', 1174.47, 'KRW' 
UNION ALL SELECT '2021-11-01', 1181.05, 'KRW' 
UNION ALL SELECT '2021-11-08', 1179.2, 'KRW' 
UNION ALL SELECT '2021-11-15', 1187.1, 'KRW' 
UNION ALL SELECT '2021-11-22', 1194.43, 'KRW' 
UNION ALL SELECT '2021-11-29', 1180, 'KRW' 
UNION ALL SELECT '2021-12-06', 1180.86, 'KRW' 
UNION ALL SELECT '2021-12-13', 1187.7, 'KRW' 
UNION ALL SELECT '2021-12-20', 1185.99, 'KRW' 
UNION ALL SELECT '2021-12-27', 1187.96, 'KRW' 

-------------------------------------------------------------------------------------------------
-- Review the input data
-------------------------------------------------------------------------------------------------
/*
Following 5 tables will be used for this test.  Executing the entire script will populate below tables with data
SELECT * FROM #partners
SELECT * FROM #locations
SELECT * FROM #instructors
SELECT * FROM #students
SELECT * FROM #fxrate
*/
















-------------------------------------------------------------------------------------------------
-- Begin
-------------------------------------------------------------------------------------------------

-- What is the yearly average exchange rate of each currency?
-- For simplicity sake, do not calculate weighted average.
-- Simply group the available rows by calendar year by currency and calculate an average number.

IF OBJECT_ID('tempdb.dbo.#yearlyAvgFxrate') IS NOT NULL DROP TABLE #yearlyAvgFxRate
CREATE TABLE #yearlyAvgFxrate
(
    CalendarYear INT -- Stored in "yyyy" format
    ,Rate FLOAT
    ,CurrencyCode NVARCHAR(3)
)

-- Result set is below.  Write SQL statements that produce the same result and insert into provided table
/*
CalendarYear	Rate				CurrencyCode
2020			1.2727				CAD
2021			1.253353846153846	CAD
2020			1084.73				KRW
2021			1145.6698076923078	KRW
2020			1505.7				LBP
2021			1504.9863461538457	LBP
*/

-- ## BEGIN SOLUTION ## --
INSERT INTO #yearlyAvgFxrate
	SELECT YEAR(EffectiveDate) as CalendarYear, AVG(rate) as Rate, CurrencyCode
	FROM #fxrate
	GROUP BY YEAR(EffectiveDate), CurrencyCode
	ORDER BY CurrencyCode
-- KEWKLOL


-- ## END SOLUTION ## --
SELECT * FROM #yearlyAvgFxrate






-- How many number of months was each student active during the year 2021 across all locations?
-- Ignore the LastStartDate as there is no way of knowing previous termination date of students

IF OBJECT_ID('tempdb.dbo.#ActiveMonthsByStudentIn2021') IS NOT NULL DROP TABLE #ActiveMonthsByStudentIn2021
CREATE TABLE #ActiveMonthsByStudentIn2021
(
    StudentCode NVARCHAR(10)
    ,NumberOfActiveMonths INT
)

-- Result set is below.  Write SQL statements that produce the same result and insert into provided table
/*
StudentCode	NumberOfActiveMonths
0001	1
0002	3
0003	12
0004	0
0005	12
0006	0
0007	12
0008	3
0009	12
0010	12
0011	12
0012	0
0013	10
0014	12
0015	11
0016	0
0017	11
0018	1
0019	9
0020	0
0021	0
0022	0
0023	0
0024	6
0025	8
0026	12
0027	0
0028	0
0029	9
0030	5
0031	12
0032	0
0033	8
0034	12
0035	0
0036	12
0037	0
0038	12
0039	12
0040	12
0041	0
0042	12
0043	5
0044	2
0045	4
0046	0
0047	9
0048	10
0049	12
0050	0
0051	7
0052	9
0053	0
0054	3
0055	6
0056	0
0057	12
0058	0
0059	12
0060	0
0061	6
0062	12
0063	3
0064	4
0065	6
0066	3
0067	6
0068	7
0069	0
0070	4
0071	12
0072	12
0073	3
0074	6
0075	7
0076	1
0077	12
0078	7
0079	0
0080	4
0081	0
0082	0
0083	5
0084	1
0085	8
0086	6
0087	12
0088	0
0089	12
0090	12
0091	2
0092	12
0093	0
0094	0
0095	0
0096	1
0097	4
0098	12
0099	0
0100	0
*/

-- ## BEGIN SOLUTION ## --

INSERT INTO #ActiveMonthsByStudentIn2021
SELECT StudentCode, 
CASE
	WHEN YEAR(TerminationDate) > 2021 AND YEAR(StartDate) = 2021 THEN 13- MONTH(StartDate)
	WHEN YEAR(StartDate) = 2021 AND TerminationDate IS NULL THEN 13 - MONTH(StartDate)
	WHEN YEAR(StartDate) = 2021 AND TerminationDate IS NOT NULL THEN MONTH(TerminationDate) - MONTH(StartDate)
	WHEN YEAR(StartDate) < 2021 AND TerminationDate IS NULL THEN 12
	WHEN YEAR(StartDate) < 2021 AND TerminationDate IS NOT NULL AND YEAR(TerminationDate) = 2021 THEN MONTH(TerminationDate) - 1
	WHEN YEAR(TerminationDate) < 2021 THEN 0
	ELSE 0
END AS NumberOfActiveMonths 
FROM #students

SELECT * FROM #students
-- ## END SOLUTION ## --
SELECT * FROM #ActiveMonthsByStudentIn2021








-- What is the revenue of each location in USD in year 2021? 
-- Assume that revenue is 100% generated from student membership.
-- Each student follows the location's monthly fee with their individual discount rate applied.
-- Use the monthly average exchange rate to convert currency to USD from above table

IF OBJECT_ID('tempdb.dbo.#YearlyRevenueByLocation') IS NOT NULL DROP TABLE #YearlyRevenueByLocation
CREATE TABLE #YearlyRevenueByLocation
(
    LocationCode NVARCHAR(10)
    ,AnnualRevenueInUSD FLOAT
)

-- Result set is below.  Write (a) SQL statement(s) that produces the same result and insert into provided table
/*
LocationCode	AnnualRevenueInUSD
BEY				237430.72547680928
LGB				300440
PHX				105080
RNO				200960
SAN				187980
TAE				263950.39650134125
YOW				497624.8342907645
YYZ				291218.6379928316
*/
-- ## BEGIN SOLUTION ## --

SELECT * FROM #ActiveMonthsByStudentIn2021
SELECT * FROM #locations
SELECT * FROM #students

SELECT S.StudentCode, DiscountRate, S.LocationCode, NumberOfActiveMonths, L.MonthlyMembershipFee, L.CurrencyCode
INTO #LocationAndFees
FROM #students S
INNER JOIN #ActiveMonthsByStudentIn2021 A ON S.StudentCode = A.StudentCode
INNER JOIN #locations L ON L.LocationCode = S.LocationCode

SELECT * FROM #LocationAndFees

SELECT LocationCode,CurrencyCode,
CASE
	WHEN DiscountRate IS NOT NULL THEN ((1 - DiscountRate) * MonthlyMembershipFee * NumberOfActiveMonths)
	ELSE (NumberOfActiveMonths * MonthlyMembershipFee)
END AS REVENUE
INTO #IndividualRevenueByLocation2021
FROM #LocationAndFees

SELECT * FROM #IndividualRevenueByLocation2021

SELECT LocationCode, CurrencyCode, SUM(REVENUE) AS AnnualRevenue
INTO #SumOfRevenue
FROM #IndividualRevenueByLocation2021
GROUP BY LocationCode, CurrencyCode

SELECT * FROM #SumOfRevenue

--CONVERT THE CURRENCY TO USD
SELECT * FROM #yearlyAvgFxrate

INSERT INTO #YearlyRevenueByLocation
SELECT S.LocationCode, (S.AnnualRevenue/ISNULL(Y.Rate,1)) AS AnnualRevenueInUSD
FROM #SumOfRevenue S
LEFT JOIN #yearlyAvgFxrate Y ON S.CurrencyCode = Y.CurrencyCode AND Y.CalendarYear = 2021
ORDER BY S.LocationCode ASC

-- ## END SOLUTION ## --
SELECT * FROM #YearlyRevenueByLocation
ORDER BY LocationCode ASC


SELECT * FROM #instructors







-- Gross profit of the business is calculated by subtracting instructors' salary from revenue.
-- What is the gross profit of each location in 2021 in USD?

IF OBJECT_ID('tempdb.dbo.#YearlyGrossProfitByLocation') IS NOT NULL DROP TABLE #YearlyGrossProfitByLocation
CREATE TABLE #YearlyGrossProfitByLocation
(
    LocationCode NVARCHAR(10)
    ,GrossProfitInUSD FLOAT
)

-- Result set is below.  Write SQL statements that produce the same result and insert into provided table
/*
LocationCode	GrossProfitInUSD
BEY				175636.14492285842
LGB				210440
PHX				30080
RNO				50960
SAN				94980
TAE				192376.54559819977
YOW				433796.09171699325
YYZ				211432.70977561746
*/
-- ## BEGIN SOLUTION ## --

SELECT I.LocationCode, SUM(Salary / ISNULL(Y.Rate,1)) AS Salary, Y.CurrencyCode
INTO #ConvertedSalaries
FROM #instructors I
INNER JOIN #locations L ON L.LocationCode = I.LocationCode
LEFT JOIN #yearlyAvgFxrate Y ON Y.CurrencyCode = L.CurrencyCode AND Y.CalendarYear = 2021
GROUP BY I.LocationCode, Y.CurrencyCode

SELECT * FROM #ConvertedSalaries
SELECT * FROM #YearlyRevenueByLocation

INSERT INTO #YearlyGrossProfitByLocation
SELECT C.LocationCode, (AnnualRevenueInUSD - Salary) AS GrossProfitsInUSD
FROM #ConvertedSalaries C
INNER JOIN #YearlyRevenueByLocation Y ON C.LocationCode = Y.LocationCode


-- ## END SOLUTION ## --
SELECT * FROM #YearlyGrossProfitByLocation
ORDER BY LocationCode ASC








-- The owners/partners of BigHand Martial Arts Academy takes the profits from the business based on their % share of the company.
-- How much gross profit in USD did each partner make in 2021?
IF OBJECT_ID('tempdb.dbo.#YearlyGrossProfitByPartner') IS NOT NULL DROP TABLE #YearlyGrossProfitByPartner
CREATE TABLE #YearlyGrossProfitByPartner
(
    OwnerCode NVARCHAR(10)
    ,OwnerName NVARCHAR(100)
    ,GrossProfitInUSD FLOAT
)

-- Result set is below.  Write SQL statements that produce the same result and insert into provided table
/*
OwnerCode	OwnerName		GrossProfitInUSD
IPM			Ip Man			559880.5968054675
CHN			Chuck Norris	349925.37300341716
MHA			Muhammad Ali	489895.5222047841
*/
-- ## BEGIN SOLUTION ## --


Select * from #partners

SELECT SUM(GrossProfitInUSD) AS TOTAL
INTO #TotalSalary
FROM #YearlyGrossProfitByLocation

SELECT * FROm #YearlyGrossProfitByLocation

INSERT INTO #YearlyGrossProfitByPartner
SELECT P.OwnerCode, P.OwnerName, T.TOTAL * (P.Share/100) AS GrossProfitInUSD
FROM #partners P, #TotalSalary T

SELECT * FROM #TotalSalary

-- ## END SOLUTION ## --
SELECT * FROM #YearlyGrossProfitByPartner


