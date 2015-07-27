-- Create table from lending club csv

DROP TABLE lendingclub;

CREATE TABLE lendingclub
(
id int,
term int,
intrate numeric,
grade varchar,
homeownership varchar,
annualinc numeric,
issued date,
loanstatus varchar,
title varchar,
zipcode varchar,
addrstate varchar,
dti numeric,
ficorangelow int,
totalpymnt numeric,
totalpymntinv numeric,
lastficorangelow int
)
WITH (
  OIDS=FALSE
);
ALTER TABLE lendingclub
  OWNER TO postgres;



-- Create table from zipcodes csv

DROP TABLE zipcodes;

CREATE TABLE zipcodes
(
zipcode varchar,
AverageHouseValue int,
IncomePerHousehold int,
State varchar,
NumberOfBusinesses int,
NumberOfEmployees int,
BusinessAnnualPayroll int,
PopulationEstimate int
)
WITH (
  OIDS=FALSE
);
ALTER TABLE zipcodes
  OWNER TO postgres;


-- Created new zip code table to transform zipcode column.

Drop table zipcodes_grouped;

SELECT substring(zipcode,1,3)||'00' zipcode, 
	avg(averagehousevalue) averagehousevalue, 
	avg(incomeperhousehold) incomeperhousehold,
	state, avg(numberofbusinesses) numberofbusinesses, 
	avg(numberofemployees) numberofemployees,
	avg(businessannualpayroll) businessannualpayroll, 
	avg(populationestimate) populationestimate
INTO zipcodes_grouped
FROM zipcodes
GROUP BY substring(zipcodes.zipcode,1,3),state;


-- Join lending club table with new zipcodes table (from code above).
-- Used "Execute to File" in Query menu to save joined results
--    to csv file named lendingclub_zipcodes.

SELECT l.*, z.*
FROM lendingclub l
      LEFT JOIN zipcodes_grouped z
      ON l.zipcode = z.zipcode
      and l.addrstate = z.state
ORDER BY id;
