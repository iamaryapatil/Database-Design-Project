--Name: Arya Ramesh Patil
--StudentID: s4060675@student.rmit.edu.au

-- Task C.1

-- Locations table
CREATE TABLE Locations (
    iso_code TEXT PRIMARY KEY,
    location TEXT NOT NULL
);

-- Vaccines table
CREATE TABLE Vaccines (
    vaccine_id INTEGER PRIMARY KEY,
    vaccines TEXT NOT NULL
);

--Data_Source table
CREATE TABLE Data_Source (
    iso_code TEXT REFERENCES Locations (iso_code) NOT NULL,
    last_observation_date DATE,
    source_name TEXT NOT NULL,
    source_website TEXT
);

-- US_State_Vaccinations
CREATE TABLE US_State_Vaccinations (
    iso_code TEXT REFERENCES Locations (iso_code) NOT NULL,
    date DATE NOT NULL,
    location TEXT,
    total_vaccinations INTEGER,
    total_distributed INTEGER,
    people_vaccinated INTEGER,
    people_fully_vaccinated_per_hundred REAL,
    total_vaccinations_per_hundred REAL,
    people_fully_vaccinated INTEGER, 
    people_vaccinated_per_hundred REAL,
    distributed_per_hundred REAL,
    daily_vaccinations_raw INTEGER,
    daily_vaccinations INTEGER,
    daily_vaccinations_per_million INTEGER,
    share_doses_used REAL,
    total_boosters INTEGER,
    total_boosters_per_hundred INTEGER
);

-- Vaccinations_by_age_group table
CREATE TABLE Vaccinations_by_age_group (
    iso_code TEXT REFERENCES Locations (iso_code) NOT NULL,
    date DATE NOT NULL,
    age_group TEXT,
    people_vaccinated_per_hundred INTEGER,
    people_fully_vaccinated_per_hundred INTEGER,
    people_with_booster_per_hundred INTEGER
);

-- Vaccinations_by_namufacturer table
CREATE TABLE Vaccinations_by_manufacturer (
    iso_code TEXT REFERENCES Locations (iso_code) NOT NULL,
    date DATE NOT NULL,
    vaccine_id INTEGER NOT NULL,
    total_vaccinations INTEGER
);

-- VAccinations table
CREATE TABLE Vaccinations(
    iso_code TEXT REFERENCES Locations (iso_code) NOT NULL,
    date  DATE NOT NULL,
    total_vaccinations INTEGER,
    people_vaccinated INTEGER,
    people_fully_vaccinated INTEGER,
    total_boosters INTEGER,
    daily_vaccinations_raw INTEGER,
    daily_vaccinations INTEGER,
    total_vaccinations_per_hundred REAL,
    people_vaccinated_per_hundred REAL,
    people_fully_vaccinated_per_hundred REAL,
    total_boosters_per_hundred REAL,
    daily_vaccinations_per_million INTEGER,
    daily_people_vaccinated INTEGER,
    daily_people_vaccinated_per_hundred REAL
);

-- Location_vaccines relationship table
CREATE TABLE Location_vaccines (
    iso_code TEXT REFERENCES Locations (iso_code) NOT NULL,
    vaccine_id INTEGER REFERENCES Vaccines (vaccine_id) NOT NULL
);

-- Country_statistics table
CREATE TABLE Country_statistics (
    iso_code TEXT REFERENCES Locations (iso_code) NOT NULL,
    date DATE NOT NULL,
    total_vaccinations INTEGER,
    people_vaccinated INTEGER,
    people_fully_vaccinated INTEGER,
    total_boosters INTEGER
);

