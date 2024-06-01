-------------------------------------------------------------------------------------------------
-- Introduction
-------------------------------------------------------------------------------------------------
-- All data necessary for this exercise is provided as part of this script.
-- Fill in your solution in the provided space.
-- Executing the entire script should result in rows selected from the tables populated from your solution.

-- Not all fields may be utilized in this test as there are different variations of this test using the same dataset.
-- For your efficiency, review the questions first before analyzing the table structure
-- so that irrelevant data can be skipped.

-- Mixed Martial Arts academy has various locations around the world.
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

-- Following table contains available classes
IF OBJECT_ID('tempdb.dbo.#classes') IS NOT NULL DROP TABLE #classes
CREATE TABLE #classes
(
    ClassCode NVARCHAR(10)
    ,ClassDescription NVARCHAR(100)
)

INSERT INTO #classes
VALUES 
('BJJ', 'Brazilian Jiu-Jitsu')
,('MTH', 'Muay Thai')
,('KFU', 'Kung Fu')
,('WRS', 'Wrestling')
,('NEG', 'Conflict Negotiation')
,('ESC', 'Escrima/Filipino Stick Fighting') 
,('PSM', 'Possum tactics')
,('PWR', 'Power Kickboxing')
,('UFC', 'Octagon Sparring');

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
,('RRZ', 'Rejane Rizkallah' , 'SAN', 'MTH;UFC;ESC'                      , 800       , 2018 , 93000);

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


/*
SELECT * FROM #locations
SELECT * FROM #classes
SELECT * FROM #instructors
SELECT * FROM #students
SELECT * FROM #fxrate
*/
--------------------------------------------------------------------------------------------------
-- Begin
--------------------------------------------------------------------------------------------------
-- Based on each instructor's skillset, what classes does each instructor offer in each location?
-- Store each class in a single row, ordered by instructor code, location code, then class code.
--------------------------------------------------------------------------------------------------
IF OBJECT_ID('tempdb.dbo.#classByInstructorLocation') IS NOT NULL DROP TABLE #classByInstructorLocation
CREATE TABLE #classByInstructorLocation
(
    InstructorCode NVARCHAR(10)
    ,LocationCode NVARCHAR(10)
    ,ClassCode NVARCHAR(10)
)

-- Result set is below.  Write SQL statements that produce the same result and insert into provided table
/*
InstructorCode	LocationCode	ClassCode
JYZ				PHX				NEG
JYZ				PHX				UFC
JYZ				PHX				WRS
RRZ				SAN				ESC
RRZ				SAN				MTH
RRZ				SAN				UFC
SDN				YOW				ESC
SDN				YOW				KFU
SDN				YOW				MTH
SDN				YOW				PWR
SDN				YOW				UFC
SHM				BEY				BJJ
SHM				BEY				MTH
SHM				BEY				NEG
SHM				BEY				UFC
SHM				BEY				WRS
SZB				LGB				KFU
SZB				LGB				NEG
SZB				LGB				UFC
SZB				LGB				WRS
TCH				RNO				BJJ
TCH				RNO				ESC
TCH				RNO				NEG
TCH				RNO				WRS
TMJ				RNO				BJJ
TMJ				RNO				KFU
TMJ				RNO				UFC
TNG				YYZ				BJJ
TNG				YYZ				ESC
TNG				YYZ				KFU
TNG				YYZ				MTH
TNG				YYZ				NEG
TNG				YYZ				PWR
TNG				YYZ				UFC
TNG				YYZ				WRS
YSH				TAE				BJJ
YSH				TAE				MTH
YSH				TAE				PSM
*/
--------------------------------------------------------------------------------------------------
-- ## BEGIN SOLUTION ##																			--
--------------------------------------------------------------------------------------------------
-- Below functions may be useful for some of many approaches to the solution.
-- These are provided as a general helpful reference and not required to be used.
-- STRING_SPLIT ( string , separator [ , enable_ordinal ] )  -- Table-valued function SELECT value FROM STRING_SPLIT('Lorem ipsum dolor sit amet.', ' ')
-- CHARINDEX ( expressionToFind , expressionToSearch [ , start_location ] ) -- This function searches for one character expression inside a second character expression, returning the starting position of the first expression if found.
-- SUBSTRING ( expression ,start , length )  -- Returns part of a character, binary, text, or image expression in SQL Server.

INSERT INTO #classByInstructorLocation
SELECT InstructorCode, LocationCode, value AS ClassCodes
FROM #instructors
	CROSS APPLY STRING_SPLIT(ClassCodes, ';')


--------------------------------------------------------------------------------------------------
-- ## END SOLUTION ##																			--
--------------------------------------------------------------------------------------------------

SELECT * 
FROM #classByInstructorLocation
ORDER BY InstructorCode, LocationCode, ClassCode







--------------------------------------------------------------------------------------------------
-- What was the student to instructor ratio in July 2021 in each location?
-- Student to instructor ratio is calculated by taking the number of students and dividing it by the number of instructors
--------------------------------------------------------------------------------------------------
IF OBJECT_ID('tempdb.dbo.#stiRatio') IS NOT NULL DROP TABLE #STIRatio
CREATE TABLE #STIRatio
(
    LocationCode NVARCHAR(10)
    ,STIRatio FLOAT
)

-- Result set is below.  Write SQL statements that produce the same result and insert into provided table
/*
LocationCode	STIRatio
BEY				5
LGB				7
PHX				4
RNO				3.5
SAN				4
TAE				5
YOW				12
YYZ				6
*/

--------------------------------------------------------------------------------------------------
-- ## BEGIN SOLUTION ##																			--
--------------------------------------------------------------------------------------------------

-- First find the count of students in July 2021
-- Make sure the student was still active in July 2021, Must check that July 2021 is an active month per location

--Find active within July 2021
SELECT COUNT(StudentCode) AS NumOfStudents, LocationCode
INTO #NumOfStudentsPerLocation
FROM #students
WHERE '2021-07-01' between StartDate AND (ISNULL(TerminationDate, '2025-12-01'))
GROUP BY LocationCode

--Find Count of Instructors per location
SELECT COUNT(InstructorCode) AS NumOfInstructors, LocationCode
INTO #NumOfInstructorPerLocation
FROM #instructors
GROUP BY LocationCode

--Join the two counts and find the ratio
INSERT INTO #STIRatio
SELECT S.LocationCode, CAST(S.NumOfStudents AS float) / I.NumOfInstructors AS STIRatio
FROM #NumOfStudentsPerLocation S
	INNER JOIN #NumOfInstructorPerLocation I ON I.LocationCode = S.LocationCode
GROUP BY S.LocationCode, S.NumOfStudents, I.NumOfInstructors



--------------------------------------------------------------------------------------------------
-- ## END SOLUTION ##																			--
--------------------------------------------------------------------------------------------------
SELECT * FROM #STIRatio







--------------------------------------------------------------------------------------------------
-- How much revenue did each location have based on student membership fees in July 2021 in USD?
-- Use a simple average exchange rate for the month. Do not calculate weighted average. 
-- (Use a simple average of available daily rates for the month in provided sample data)
--------------------------------------------------------------------------------------------------
IF OBJECT_ID('tempdb.dbo.#RevenueByLocation') IS NOT NULL DROP TABLE #RevenueByLocation
CREATE TABLE #RevenueByLocation
(
    LocationCode NVARCHAR(10)
    ,Revenue FLOAT
)

-- Result set is below.  Write SQL statements that produce the same result and insert into provided table
/*
LocationCode	Revenue
BEY				20990.9341480424
TAE				25814.2135099615
YOW				40967.8965021562
YYZ				23957.8342117873
*/

--------------------------------------------------------------------------------------------------
-- ## BEGIN SOLUTION ##																			--
--------------------------------------------------------------------------------------------------
SELECT * FROM #NumOfStudentsPerLocation
--Take the active count of students from before and join with Location
SELECT S.LocationCode, S.NumOfStudents, L.MonthlyMembershipFee, L.CurrencyCode, (S.NumOfStudents * L.MonthlyMembershipFee) AS MonthlyTotal
INTO #StudentCountAndFee
FROM #NumOfStudentsPerLocation S
	INNER JOIN #locations L ON L.LocationCode = S.LocationCode

--Find the average currency exchange rate by getting simple average of JULY 2021
SELECT AVG(Rate) AS AvgRate, CurrencyCode
INTO #AvgExchange
FROM #fxrate
WHERE MONTH(EffectiveDate) = 7 AND YEAR(EffectiveDate) = 2021
GROUP BY CurrencyCode

SELECT * FROM #AvgExchange
SELECT * FROM #StudentCountAndFee

--Join the two tables and calculate for average revenue in USD
SELECT LocationCode, (S.MonthlyTotal / A.AvgRate) AS Revenue
FROM #StudentCountAndFee S
	INNER JOIN #AvgExchange A ON S.CurrencyCode = A.CurrencyCode

--------------------------------------------------------------------------------------------------
-- ## END SOLUTION ##																			--
--------------------------------------------------------------------------------------------------





SELECT * FROM #RevenueByLocation ORDER BY Revenue DESC


SELECT * FROM #locations
SELECT * FROM #classes
SELECT * FROM #instructors
SELECT * FROM #students
SELECT * FROM #fxrate
SELECT * FROM #classByInstructorLocation