--Name: Arya Ramesh Patil
--StudentID: s4060675@student.rmit.edu.au

-- Task D

-- D.1

SELECT
    -- selecting the columns needed for the query results
    om1.month AS 'Observation Months 1 (OM1)',
    loc.location AS 'Country Name',
    om1.total_vaccinations AS 'Administered Vaccine on OM1 (VOM1)',
    om2.month AS 'Observation Months 2 (OM2)',
    om2.total_vaccinations AS 'Administered Vaccine on OM2(VOM2)',
    om2.total_vaccinations - om1.total_vaccinations AS 'Difference of totals'
FROM
    -- selecting the first column OM1
    (SELECT
        iso_code,
        strftime('%Y-%m', substr(date, 7, 4) || '-' || substr(date, 4, 2) || '-' || substr(date, 1, 2)) AS month, -- using substr to convert the date format to strftime format
        SUM(total_vaccinations) AS total_vaccinations
    FROM Vaccinations
    WHERE strftime('%Y-%m', substr(date, 7, 4) || '-' || substr(date, 4, 2) || '-' || substr(date, 1, 2)) = '2022-04' -- filtering the April data
    GROUP BY iso_code, strftime('%Y-%m', substr(date, 7, 4) || '-' || substr(date, 4, 2) || '-' || substr(date, 1, 2))) AS om1 -- naming it as om1 for easy access
JOIN
    -- joining on iso_code
    -- selecting the fifth column OM2
    (SELECT
        iso_code,
        strftime('%Y-%m', substr(date, 7, 4) || '-' || substr(date, 4, 2) || '-' || substr(date, 1, 2)) AS month,
        SUM(total_vaccinations) AS total_vaccinations
    FROM Vaccinations
    WHERE strftime('%Y-%m', substr(date, 7, 4) || '-' || substr(date, 4, 2) || '-' || substr(date, 1, 2)) = '2022-05' 
    GROUP BY iso_code, strftime('%Y-%m', substr(date, 7, 4) || '-' || substr(date, 4, 2) || '-' || substr(date, 1, 2))) AS om2
ON
    om1.iso_code = om2.iso_code
JOIN
    -- joining on Locations table to get country names
    Locations loc ON om1.iso_code = loc.iso_code
ORDER BY
    loc.location;


-- D.2 

SELECT
    -- selecting the columns needed for the query results
    loc.location AS 'Country_Name',
    vacc.month AS 'Month',
    vacc.total_vaccinations AS 'Cumulative_Doses'
FROM
    -- to get Month and Cumulative doses
    (
        SELECT
            iso_code, -- selecting this to use it in group_by clause
            strftime('%Y-%m', substr(date, 7, 4) || '-' || substr(date, 4, 2) || '-' || substr(date, 1, 2)) AS Month,
            SUM(total_vaccinations) AS total_vaccinations
        FROM Vaccinations
        GROUP BY iso_code, strftime('%Y-%m', substr(date, 7, 4) || '-' || substr(date, 4, 2) || '-' || substr(date, 1, 2))
    ) AS vacc -- naming it as vacc for easy access
JOIN
    -- joining in iso_code and to get country name
    Locations loc ON vacc.iso_code = loc.iso_code
    
-- total vaccinations should be greater than the average of total_vaccinations
WHERE vacc.total_vaccinations > (
                                SELECT
                                    AVG(vacc1.total_vaccinations)
                                FROM
                                    (
                                        SELECT
                                            iso_code,
                                            strftime('%Y-%m', substr(date, 7, 4) || '-' || substr(date, 4, 2) || '-' || substr(date, 1, 2)) AS Month,
                                            SUM(total_vaccinations) AS total_vaccinations
                                        FROM Vaccinations
                                        GROUP BY iso_code, strftime('%Y-%m', substr(date, 7, 4) || '-' || substr(date, 4, 2) || '-' || substr(date, 1, 2))
                                    ) AS vacc1
                               WHERE vacc1.month = vacc.month -- same column to match the months
                                )
ORDER BY
    Month,
    Country_Name;


--D.3 

SELECT
    -- selecting the columns needed for the query results
    v.vaccines AS 'Vaccine Type',
    loc.location AS 'Country'
FROM
    Location_vaccines lv
JOIN
    Locations loc ON lv.iso_code = loc.iso_code
JOIN
    Vaccines v ON lv.vaccine_id = v.vaccine_id
;


--D.4 

SELECT
    -- selecting the columns needed for the query results
    loc.location AS 'Country Name',
    ds.source_name || ' ' || ds.source_website AS 'Source Name (URL)',
    SUM(vacc.total_vaccinations) AS 'Total_Administered_Vaccines'
FROM
    Vaccinations vacc
JOIN
    -- joining on data source to get source website
    Data_Source ds ON vacc.iso_code = ds.iso_code
JOIN
    -- joining on locations to get country name
    Locations loc ON vacc.iso_code = loc.iso_code
GROUP BY
    loc.iso_code, ds.source_website
ORDER BY
    Total_Administered_Vaccines DESC;


-- D.5

SELECT
    -- selecting the columns needed for the query results
    Month,
    -- if country name is found return the total_fully_vaccinated people or else return 0
    MAX(CASE WHEN Country = 'United States' THEN Total_Fully_Vaccinated ELSE 0 END) AS 'United States',
    MAX(CASE WHEN Country = 'Wales' THEN Total_Fully_Vaccinated ELSE 0 END) AS 'Wales',
    MAX(CASE WHEN Country = 'Canada' THEN Total_Fully_Vaccinated ELSE 0 END) AS 'Canada',
    MAX(CASE WHEN Country = 'Denmark' THEN Total_Fully_Vaccinated ELSE 0 END) AS 'Denmark'
FROM
    (
        SELECT
            strftime('%Y-%m', substr(date, 7, 4) || '-' || substr(date, 4, 2) || '-' || substr(date, 1, 2)) AS Month,
            loc.location AS Country, --selecting to use this in group_by clause
            SUM(cs.people_fully_vaccinated) AS Total_Fully_Vaccinated
        FROM
            Country_statistics cs
        JOIN
            Locations loc ON cs.iso_code = loc.iso_code
        WHERE
            strftime('%Y', substr(date, 7, 4) || '-' || substr(date, 4, 2) || '-' || substr(date, 1, 2)) IN ('2022', '2023') -- filtering the years
        GROUP BY
            Month, loc.location
    ) 
GROUP BY
    Month
ORDER BY
    Month;
