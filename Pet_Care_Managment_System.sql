USE sql_assi3;

/*1 SELECT petowners.PoName, pets.Name AS PetName
FROM petowners 
INNER JOIN pets ON petowners.OwnerID = pets.OwnerID;


/*2  List all pets and their owner names, including pets that don't have recorded owners.
SELECT pets.Name AS PetName, 
       IFNULL(petowners.PoName, 'No owner recorded') AS OwnerName
FROM pets 
LEFT JOIN petowners ON pets.OwnerID = petowners.OwnerID;


/*3 Combine the information of pets and their owners, including those pets without 
owners and owners without pets. 

-- Combine pets with their owners
SELECT p.*, po.PoName AS OwnerName
FROM pets p
LEFT JOIN petowners po ON p.OwnerID = po.OwnerID

UNION

-- Include pets without owners
SELECT p.*, NULL AS OwnerName
FROM pets p
LEFT JOIN petowners po ON p.OwnerID = po.OwnerID
WHERE po.OwnerID IS NULL

UNION

-- Include owners without pets
SELECT NULL AS PetID, NULL AS PetName, NULL AS Kind, NULL AS Gender, NULL AS Age, po.OwnerID, po.PoName AS OwnerName
FROM petowners po
LEFT JOIN pets p ON po.OwnerID = p.OwnerID
WHERE p.OwnerID IS NULL;

/*4.  List all pet owners and the number of dogs they own. 
SELECT  petowners.PoName AS OwnerName, COUNT(pets.PetID) AS NumberOfDogsOwned
FROM petowners
LEFT JOIN pets ON petowners.OwnerID = pets.OwnerID
GROUP BY petowners.OwnerID, petowners.PoName;

/*5.Identify pets that have not had any procedures. 
SELECT pets.*, procedureshistory.PetID as PHisPetID
FROM pets 
LEFT JOIN procedureshistory ON pets.PetID = procedureshistory.PetID
WHERE procedureshistory.PetID IS NULL;

/*6. Find the name of the oldest pet
SELECT * FROM pets 
WHERE AGE=(SELECT MAX(Age) FROM pets)

/* 7. Find the details of procedures performed on 'Cuddles'.
SELECT proceduresdetails.Description, proceduresdetails.Price
FROM proceduresdetails
JOIN procedureshistory ON proceduresdetails.ProcedureSubCode = procedureshistory.ProcedureSubCode
JOIN pets ON procedureshistory.PetID = pets.PetID
WHERE pets.Name = 'Cuddles';

/*8  List the pets who have undergone a procedure called 'VACCINATIONS'.
SELECT pets.Name, procedureshistory.ProcedureType
FROM pets 
JOIN procedureshistory  ON pets.PetID = procedureshistory.PetID
JOIN proceduresdetails  ON procedureshistory .ProcedureSubCode = proceduresdetails.ProcedureSubCode
WHERE proceduresdetails.ProcedureType = 'VACCINATIONS';



/*9. Count the number of pets of each kind.
SELECT Kind, COUNT(*) AS TotalPets
FROM pets
GROUP BY Kind;


/* 10 Group pets by their kind and gender and count the number of pets in each group
SELECT Kind, Gender , Count(*) as pet_count FROM pets 
GROUP BY Kind, Gender;

/* 11.Show the average age of pets for each kind, but only for kinds that have more than 5 pets. 
SELECT AVG(Age) as Average_age ,Kind
FROM pets 
GROUP BY kind
HAVING Count(*) > 5

/*12 Find the types of procedures that have an average cost greater than $50.
SELECT ProcedureType, AVG(Price) AS AveragePrice
FROM proceduresdetails
GROUP BY ProcedureType
HAVING AVG(Price) > 50;


/* 13 .Classify pets as 'Young', 'Adult', or 'Senior' based on their age. Age less then 3  Young, Age between 3and 8 Adult, else Senior. 
SELECT *,
       CASE
           WHEN Age < 3 THEN 'Young'
           WHEN Age BETWEEN  3 AND  8 THEN "Adult"
           ELSE 'Senior'
       END AS Pets_Category
FROM pets;


/* 14. .Show the gender of pets with a custom label ('Boy' for male, 'Girl' for female).
SELECT *,
       CASE
        WHEN Gender="Male" THEN "Boy"
		WHEN Gender="Female" THEN "Girl"
	 END  AS Gender_Categorization
FROM pets;
    


/* 15. For each pet, display the pet's name, the number of procedures they've had, and a 
status label: 'Regular' for pets with 1 to 3 procedures, 'Frequent' for 4 to 7 
procedures, and 'Super User' for more than 7 procedure

SELECT 
    PetName,
    NumberOfProcedures,
    CASE
        WHEN NumberOfProcedures BETWEEN 1 AND 3 THEN 'Regular'
        WHEN NumberOfProcedures BETWEEN 4 AND 7 THEN 'Frequent'
        ELSE 'Super User'
    END AS StatusLabel
FROM (
    SELECT 
        p.Name AS PetName,
        COUNT(*) AS NumberOfProcedures
    FROM 
        pets p
    JOIN 
        procedureshistory ph ON p.PetID = ph.PetID
    GROUP BY 
        p.PetID, p.Name
) AS PetProcedures;


