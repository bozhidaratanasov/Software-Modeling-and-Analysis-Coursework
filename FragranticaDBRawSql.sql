CREATE DATABASE FragranticaDB;

CREATE TABLE Account
(
	AccountID int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	FirstName nvarchar(50) NOT NULL,
	LastName nvarchar(50) NOT NULL,
	Username varchar(30) NOT NULL UNIQUE,
	Email varchar(100) NOT NULL UNIQUE,
	AccountPassword varchar(30) NOT NULL CHECK (LEN(AccountPassword) > 5 AND LEN(AccountPassword) <= 30),
	JoinDate date DEFAULT GETDATE()
);

CREATE TABLE Brand
(
	BrandID int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	BrandName varchar(50) NOT NULL UNIQUE,
	Country varchar(50) NOT NULL,
	BrandType varchar(10) NOT NULL CHECK (BrandType = 'Designer' OR BrandType = 'Niche')
);

CREATE TABLE Fragrance
(
	FragranceID int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	BrandID int NOT NULL,
	FragranceName varchar(100) NOT NULL,
	ReleaseYear smallint NOT NULL CHECK(ReleaseYear > 0),
	Perfumer varchar(100) NOT NULL,
	AppropriateFor varchar(10) NOT NULL CHECK(AppropriateFor = 'Summer' OR AppropriateFor = 'Fall' OR AppropriateFor = 'Winter' OR AppropriateFor = 'Spring'),
	AverageRating float DEFAULT 0,
	CONSTRAINT FK_Fragrance_Brand
	FOREIGN KEY (BrandID) REFERENCES Brand(BrandID)
);

CREATE TABLE Note
(
	NoteID int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	NoteName varchar(30) NOT NULL UNIQUE
);

CREATE TABLE Comment
(
	CommentID int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	AccountID int NOT NULL,
	FragranceID int NOT NULL,
	Content nvarchar(1000) NOT NULL,
	LikeCount smallint DEFAULT 0,
	PostedOn datetime DEFAULT GETDATE(),
	CONSTRAINT FK_Comment_Account
	FOREIGN KEY (AccountID) REFERENCES Account(AccountID),
	CONSTRAINT FK_Comment_Fragrance
	FOREIGN KEY (FragranceID) REFERENCES Fragrance(FragranceID)
);

CREATE TABLE Rating
(
	RatingID int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	AccountID int NOT NULL,
	FragranceID int NOT NULL,
	Rating float NOT NULL CHECK(Rating >= 1 AND rating <= 5),
	CONSTRAINT FK_Rating_Account
	FOREIGN KEY (AccountID) REFERENCES Account(AccountID),
	CONSTRAINT FK_Rating_Fragrance
	FOREIGN KEY (FragranceID) REFERENCES Fragrance(FragranceID)
);

CREATE TABLE CommentLike
(
	CommentLikeID int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	AccountID int NOT NULL,
	CommentID int NOT NULL,
	CONSTRAINT FK_CommentLike_Account
	FOREIGN KEY (AccountID) REFERENCES Account(AccountID),
	CONSTRAINT FK_CommentLike_Fragrance
	FOREIGN KEY (CommentID) REFERENCES Comment(CommentID)
);

CREATE TABLE FragranceHasNote
(
	FragranceID int NOT NULL,
	NoteID int NOT NULL,
	CONSTRAINT PK_FragranceHasNote
	PRIMARY KEY(FragranceID, NoteID),
	CONSTRAINT FK_FragranceHasNote_Fragrance
	FOREIGN KEY(FragranceID) REFERENCES Fragrance(FragranceID),
	CONSTRAINT FK_FragranceHasNote_Note
	FOREIGN KEY(NoteID) REFERENCES Note(NoteID)
);

-- Constraints

ALTER TABLE Rating
ADD CONSTRAINT UNIQUE_AccountID_FragranceID UNIQUE(AccountID, FragranceID);

ALTER TABLE CommentLike
ADD CONSTRAINT UNIQUE_AccountID_CommentID UNIQUE(AccountID, CommentID);

-- Data Insertion

INSERT INTO Account(FirstName, LastName, Username, Email, AccountPassword)
VALUES
	('Ivan', 'Ivanov', 'ivancho', 'ivan@abv.bg', 'dummypass'),
	('John', 'Smith', 'johnie1', 'john.smith@gmail.com', 'dummypass'),
	('Jessica', 'Roberts', 'jessie85', 'jessica1985@gmail.com', 'dummypass'),
	('Jose', 'Peres', 'jperes', 'jose_peres@gmail.com', 'dummypass'),
	('Sarah', 'Williams', 'SarahTheFragranceLover', 'sarahwilliams33@gmail.com', 'dummypass');

INSERT INTO Brand(BrandName, Country, BrandType)
VALUES
	('Giorgio Armani', 'Italy', 'Designer'),
	('Christian Dior', 'France', 'Designer'),
	('Yves Saint Laurent', 'France', 'Designer'),
	('Versace', 'Italy', 'Designer'),
	('By Kilian', 'France', 'Niche'),
	('Amouage', 'Oman', 'Niche'),
	('Xerjoff', 'Italy', 'Niche')

INSERT INTO Fragrance(BrandID, FragranceName, ReleaseYear, Perfumer, AppropriateFor)
VALUES
	(1, 'Acqua di Gio Profumo', 2015, 'Alberto Morillas', 'Spring'),
	(1, 'Code Profumo', 2016, 'Antoine Maisondieu', 'Winter'),
	(2, 'Sauvage', 2015, 'Francois Demachy', 'Summer'),
	(2, 'Sauvage Elixir', 2021, 'Francois Demachy', 'Fall'),
	(2, 'Homme Parfum', 2014, 'Francois Demachy', 'Winter'),
	(3, 'Y Eau de Parfum', 2018, 'Dominique Ropion', 'Spring'),
	(3, 'La Nuit De L''Homme Bleu Electrique', 2021, 'Dominique Ropion', 'Fall'),
	(4, 'Eros', 2012, 'Aurelien Guichard', 'Fall'),
	(4, 'Pour Homme', 2008, 'Alberto Morillas', 'Summer'),
	(5, 'Black Phantom', 2017, 'Sidonie Lancesseur', 'Winter'),
	(5, 'Intoxicated', 2014, 'Calice Becker', 'Winter'),
	(6, 'Reflection Man', 2007, 'Lucas Sieuzac', 'Spring'),
	(6, 'Jubilation XXV', 2008, 'Bertrand Duchaufour', 'Winter'),
	(7, 'Starlight', 2019, 'Chris Maurice', 'Fall'),
	(7, 'Nio', 2009, 'Chris Maurice', 'Summer');



INSERT INTO Note(NoteName)
VALUES
	('Bergamot'), 
	('Apple'), 
	('Cardamom'), 
	('Nutmeg'), 
	('Amber'), 
	('Vanilla'),
	('Tonka Bean'),
	('Iris'),
	('Incense'),
	('Leather'),
	('Patchouli'),
	('Coffee'),
	('Dark Chocolate');


INSERT INTO FragranceHasNote(FragranceID, NoteID)
VALUES
	(1, 1),
	(1, 9),
	(1, 11),
	(2, 2),
	(2, 3),
	(2, 4),
	(2, 5),
	(3, 1),
	(3, 5),
	(3, 11),
	(4, 3),
	(4, 4),
	(4, 5),
	(4, 11),
	(5, 1),
	(5, 8),
	(5, 10),
	(6, 2),
	(6, 5),
	(6, 7),
	(7, 1),
	(7, 3),
	(7, 7),
	(8, 2),
	(8, 6),
	(8, 7),
	(9, 1),
	(9, 5),
	(9, 7),
	(10, 6),
	(10, 12),
	(10, 13),
	(11, 3),
	(11, 4),
	(11, 12),
	(12, 1),
	(12, 8),
	(12, 11),
	(13, 1),
	(13, 9),
	(13, 11),
	(14, 3),
	(14, 4),
	(14, 6),
	(15, 1),
	(15, 4),
	(15, 5);


INSERT INTO Comment(AccountID, FragranceID, Content)
VALUES
	(1, 1, 'Perfect!'),
	(2, 1, 'Kinda average!'),
	(3, 2, 'Very nice winter scent.'),
	(4, 2, 'Has great performance'),
	(5, 3, 'Too common and boring!'),
	(1, 3, 'Perfect for any occasion.'),
	(2, 4, 'Different and unique!'),
	(3, 4, 'Performance is outstanding.'),
	(4, 4, 'Price is too high.'),
	(5, 5, 'Best designer fragrance of all time!'),
	(1, 5, 'New 2020 batch is same as old 75ml bottles.'),
	(2, 6, 'The best blue scent on the market!'),
	(3, 6, 'Nothing new under the sun.'),
	(4, 7, 'Best flanker in the line!'),
	(5, 7, 'Better than the vintage La Nuit.'),
	(1, 8, 'Best clubbing fragrance ever!'),
	(2, 8, 'Total mess after reformulation.'),
	(3, 9, 'Old but gold!'),
	(4, 9, 'Performance is weak.'),
	(5, 10, 'Super yummy and delicious!'),
	(1, 10, 'Best gourmand on the market.'),
	(2, 10, 'The bottle and the packaging are very high class.'),
	(3, 10, 'If you want only one By Kilian go for this!'),
	(4, 11, 'Smells like turkish coffee.'),
	(5, 11, 'Very interesting and different scent.'),
	(1, 12, 'Perfect for a wedding.'),
	(2, 12, 'If you want to dive into men''s floral scents, try this!'),
	(3, 13, 'A scent fit for kings! Wanna smell like a royalty, get this!'),
	(4, 13, 'Very complex scent with different nuances.'),
	(5, 14, 'Bottle and packaging are out of this world!'),
	(1, 14, 'Smells like Christmas'),
	(2, 14, 'Spicy in the opening and creamy smooth in the drydown.'),
	(3, 15, 'The highest quality citrus fragrance on earth!');




INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(1, 1, 5);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(2, 1, 3);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(3, 1, 4);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(4, 1, 4);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(5, 1, 5);


INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(1, 2, 2);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(2, 2, 5);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(4, 2, 5);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(5, 2, 4);


INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(1, 3, 4);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(2, 3, 3);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(3, 3, 3);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(4, 3, 3);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(5, 3, 5);


INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(1, 4, 4);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(2, 4, 5);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(3, 4, 3);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(4, 4, 5);


INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(1, 5, 5);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(2, 5, 5);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(4, 5, 4);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(5, 5, 5);


INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(2, 6, 5);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(3, 6, 4);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(4, 6, 5);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(5, 6, 3);


INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(1, 7, 4);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(2, 7, 5);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(3, 7, 5);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(4, 7, 4);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(5, 7, 5);


INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(1, 8, 4);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(2, 8, 4);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(3, 8, 3);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(4, 8, 4);


INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(1, 9, 5);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(2, 9, 3);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(3, 9, 5);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(4, 9, 4);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(5, 9, 5);


INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(1, 10, 5);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(2, 10, 5);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(3, 10, 5);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(4, 10, 5);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(5, 10, 5);


INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(1, 11, 3);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(2, 11, 5);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(4, 11, 5);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(5, 11, 5);


INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(1, 12, 5);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(3, 12, 5);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(4, 12, 4);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(5, 12, 5);
	

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(1, 13, 3);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(3, 13, 5);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(5, 13, 5);
	

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(2, 14, 5);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(3, 14, 5);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(4, 14, 4);
	

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(1, 15, 3);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(2, 15, 5);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(4, 15, 4);

INSERT INTO Rating(AccountID, FragranceID, Rating)
VALUES(5, 15, 5);
	
-----------------------------------------------------

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(1, 2);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(2, 3);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(3, 1);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(3, 4);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(4, 2);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(4, 3);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(6, 2);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(7, 1);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(7, 5);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(8, 1);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(8, 2);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(8, 4);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(9, 3);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(10, 2);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(10, 3);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(10, 4);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(11, 1);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(12, 2);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(13, 5);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(14, 3);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(14, 4);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(15, 3);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(15, 4);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(16, 1);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(18, 2);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(18, 3);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(19, 5);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(20, 2);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(20, 3);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(20, 5);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(20, 1);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(21, 3);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(21, 4);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(21, 5);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(21, 2);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(22, 2);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(23, 1);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(23, 3);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(24, 1);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(24, 3);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(25, 2);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(26, 4);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(26, 5);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(27, 3);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(28, 1);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(28, 2);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(28, 4);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(28, 5);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(29, 2);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(29, 3);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(30, 1);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(30, 4);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(30, 5);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(31, 2);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(31, 3);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(32, 1);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(33, 2);

INSERT INTO CommentLike(CommentID, AccountID)
VALUES(33, 4);


-- Procedures

CREATE PROCEDURE usp_GetData
AS
BEGIN
	SELECT B.BrandName, B.Country, B.BrandType, F.FragranceName, F.ReleaseYear, F.Perfumer, F.AppropriateFor, F.AverageRating 
	FROM Fragrance as F JOIN Brand as B
	ON F.BrandID = B.BrandID
END

CREATE PROCEDURE usp_GetDataOrderedByRating
AS
BEGIN
	SELECT B.BrandName, B.Country, B.BrandType, F.FragranceName, F.ReleaseYear, F.Perfumer, F.AppropriateFor, F.AverageRating 
	FROM Fragrance as F JOIN Brand as B
	ON F.BrandID = B.BrandID
	ORDER BY F.AverageRating DESC
END

CREATE PROCEDURE usp_GetDataByBrand @BrandName varchar(50)
AS
BEGIN
	SELECT B.BrandName, B.Country, B.BrandType, F.FragranceName, F.ReleaseYear, F.Perfumer, F.AppropriateFor, F.AverageRating 
	FROM Fragrance as F JOIN Brand as B
	ON F.BrandID = B.BrandID
	WHERE B.BrandName = @BrandName
END

CREATE PROCEDURE usp_GetDataBySeason @Season varchar(10)
AS
BEGIN
	SELECT B.BrandName, B.Country, B.BrandType, F.FragranceName, F.ReleaseYear, F.Perfumer, F.AppropriateFor, F.AverageRating 
	FROM Fragrance as F JOIN Brand as B
	ON F.BrandID = B.BrandID
	WHERE F.AppropriateFor = @Season
END

EXECUTE usp_GetData
EXECUTE usp_GetDataOrderedByRating
EXECUTE usp_GetDataByBrand @BrandName = 'Christian Dior'
EXECUTE usp_GetDataBySeason @Season = 'Winter'


-- Triggers

CREATE TRIGGER tr_IncrementLike
	ON CommentLike
	AFTER INSERT
AS
BEGIN
	UPDATE Comment
	SET LikeCount = LikeCount + 1
	FROM Comment AS C JOIN CommentLike AS CL
	ON C.CommentID = CL.CommentID
	WHERE
	CL.CommentLikeID = IDENT_CURRENT('CommentLike')
END


CREATE TRIGGER tr_DecrementLike
	ON CommentLike
	AFTER DELETE
AS
BEGIN
	UPDATE Comment
	SET LikeCount = LikeCount - 1
	FROM Comment AS C JOIN CommentLike AS CL
	ON C.CommentID = CL.CommentID
	WHERE
	CL.CommentID = C.CommentID
END


CREATE TRIGGER tr_CalculateAverageRating
	ON Rating
	AFTER INSERT
AS
BEGIN

	DECLARE @INSERTED_FRAGRANCEID INT = 0 
	SET @INSERTED_FRAGRANCEID = (SELECT inserted.FragranceID from inserted);
	

	DECLARE @AVG_RATING float
	SET @AVG_RATING = (SELECT AVG(R.Rating) 
	FROM Rating AS R JOIN FRAGRANCE AS F 
	ON R.FragranceID = F.FragranceID
	WHERE R.FragranceID = @INSERTED_FRAGRANCEID)

	IF(@INSERTED_FRAGRANCEID > 0)
		UPDATE Fragrance
		SET AverageRating = ROUND(@AVG_RATING, 2)
		FROM Rating AS R JOIN FRAGRANCE AS F
		ON R.FragranceID = F.FragranceID
		WHERE R.RatingID = IDENT_CURRENT('Rating')

	ELSE
		UPDATE Fragrance
		SET AverageRating = ROUND(@AVG_RATING, 2)
		FROM Rating AS R JOIN FRAGRANCE AS F
		ON R.FragranceID = F.FragranceID
		WHERE F.FragranceID IN (SELECT deleted.FragranceID from deleted)
				
END

