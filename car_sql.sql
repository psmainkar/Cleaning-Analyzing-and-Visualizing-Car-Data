USE cars;
SELECT * FROM cars.car;
-- CREATE TABLE backup LIKE car;
-- INSERT INTO backup SELECT * FROM car;

ALTER TABLE car
CHANGE `No` `index` int;

ALTER TABLE car MODIFY COLUMN full_name VARCHAR(255);
UPDATE car SET full_name =SUBSTR(full_name,6);

DELETE FROM car
WHERE registered_year = "";


UPDATE cars.car
SET registered_year = TRIM(SUBSTR(registered_year,5)) ;

UPDATE car SET resale_price=  SUBSTR(resale_price,5);

UPDATE car SET resale_price= 
  CASE
      WHEN resale_price LIKE "%Lakh" THEN CAST(REPLACE(resale_price,"Lakh","") AS DECIMAL(10,2)) *100000
      WHEN resale_price LIKE "%,%" THEN (REPLACE(resale_price,",",""))
      WHEN resale_price LIKE "%Crore%" THEN CAST((REPLACE(resale_price,"Crore","")* 10000000) AS UNSIGNED)
      ELSE resale_price
  END;
  
ALTER TABLE car ADD COLUMN brand_name VARCHAR(255) AFTER full_name; 
UPDATE car SET brand_name =(SUBSTRING_INDEX(full_name," ",1));

UPDATE car SET engine_capacity = SUBSTRING_INDEX(engine_capacity,' ',1);

UPDATE car
SET insurance = 
    CASE
        WHEN insurance = 'Third Party insurance' OR insurance = 'Comprehensive' OR insurance = 'Third Party' OR insurance = 2 OR insurance = 1 THEN 1
        WHEN insurance = 'Not Available' THEN 0
        ELSE 0
    END;
    
SELECT DISTINCT(transmission_type) FROM car;

UPDATE car SET kms_driven = REPLACE(REPLACE(kms_driven,'Kms',""),',','');

SELECT DISTINCT(owner_type) FROM car;
UPDATE car SET owner_type= 
    CASE
         WHEN owner_type= 'First Owner' THEN '2nd'
         WHEN owner_type= 'Second Owner' THEN '3rd'
         WHEN owner_type= 'Third Owner' THEN '4th'
	     ELSE NULL
    END  ;
ALTER TABLE car CHANGE owner_type Hand VARCHAR(255);

SELECT DISTINCT(fuel_type) FROM car;

UPDATE car SET max_power = SUBSTRING_INDEX(max_power,'bhp',1);
UPDATE car SET max_power = SUBSTRING_INDEX(max_power,'PS',1);
UPDATE car SET max_power = SUBSTRING_INDEX(max_power,'kW',1);


UPDATE car SET mileage= SUBSTRING_INDEX(mileage,'kmpl',1);

SELECT DISTINCT(city) FROM car;
SELECT DISTINCT(body_type) FROM car;

UPDATE car
SET body_type = 

   CASE
        WHEN body_type IN ('Toyota', 'Chevrolet', 'Mercedes-Benz', 'Audi', 'Maruti', 'Porsche', 'Tata', 'Mahindra', 'Volvo', 'Jaguar', 'BMW', 'Cars', 'Datsun', 'Skoda', 'Isuzu','Hyundai','Honda') THEN NULL
        ELSE body_type
    END;
    
ALTER TABLE car
CHANGE `engine_capacity` `engine_capacity(cc)` FLOAT;    

ALTER TABLE car
CHANGE `max_power` `max_power(bhp)` FLOAT;    

ALTER TABLE car
CHANGE `mileage` `mileage(kmpl)` FLOAT;    
    


