-- EDA AND FE    

-- Q price column information
SELECT MIN(resale_price),
MAX(resale_price),
AVG(resale_price),STD(resale_price)
FROM car ;

-- Q brandwise count

SELECT brand_name,COUNT(brand_name) AS Count 
FROM cars.car
GROUP BY brand_name 
ORDER BY Count DESC;

 -- Maruti and Hyundai have the most cars for resale.



-- Q brandwise study

SELECT brand_name,AVG(resale_price),AVG(kms_driven),AVG(engine_capacity),AVG(max_power),AVG(mileage),COUNT(brand_name)
FROM car  
GROUP BY brand_name 
HAVING COUNT(brand_name)>10 
ORDER BY AVG(resale_price) DESC  ;

-- Interestingly, Porsche,LandRower,Mercedes-Benz,BMW and Volvo, all of these have the highest resale value.Also, the maximum power and mileage
-- of these cars are the best in the same order.


-- Q. Does reuse value matter?

SELECT Hand,AVG(resale_price),AVG(kms_driven),AVG(engine_capacity),AVG(max_power),AVG(mileage) FROM car
GROUP BY Hand;

-- avg resale price is clearly affected negatively and kms driven is direct proportional to amount of hands on it, 
-- engine capacity,mileage and max power are unhinged by how many times the vehicle has been used.

-- Q. Transmission type value matter?

SELECT transmission_type, AVG(resale_price),AVG(kms_driven),AVG(engine_capacity),AVG(max_power),AVG(mileage) FROM car
GROUP BY transmission_type;

-- Automatic cars are three times costlier than manual cars. Engine capacity and maximum power generated are
-- much higher too though mileage remains unaffected.

-- Q. fuel type analysis in second hand cars specifically 

SELECT fuel_type, AVG(resale_price),AVG(kms_driven),AVG(engine_capacity),AVG(max_power),AVG(mileage) FROM car
WHERE Hand= '2nd'
GROUP BY fuel_type;
 
 -- Electric vehicles have the most resale value in general followed by Diesel,  Diesel also has good 
 -- average 'maximum power' and also has the maximum of engine capacity. CNG as expected has the best mileage.
 -- Electric Vehicles are well known for its performance and has the best average of maximum power.
 
-- Q. Generating the best selling car of each brand:

WITH Ranked_cars AS 
(SELECT *,ROW_NUMBER() OVER (PARTITION BY brand_name) AS 'Brand_Rank' FROM car )

SELECT * FROM Ranked_cars WHERE Brand_Rank=1;


-- Q. WHich body type is most common in the cars from the last five years:

SELECT body_type, COUNT(*) AS count
FROM car
WHERE registered_year > 2018
GROUP BY body_type ORDER BY count DESC LIMIT 1;

-- SUVs are the most commonly resold car types in the last 5 years

-- Q. Which is the most resold car brand in each city

WITH RankedCars AS (
    SELECT brand_name, city,
	ROW_NUMBER() OVER (PARTITION BY city ORDER BY COUNT(*) DESC) AS Brand_Rank
    FROM car
    GROUP BY brand_name, city
)
SELECT brand_name,city
FROM RankedCars
WHERE Brand_Rank = 1;

 -- Except Kolkata which has Hyundai, Maruti Suzuki is the most resold brand in the other 12 cities.
 
 -- Q. SHow data of those cars which are above the average price of their respective brand cars and fint how many cars 
 -- each car has there and its percentage (for those brands with cars>15)
 
 
SELECT 
    c.brand_name,
    COUNT(*) AS total_cars,
    SUM(CASE WHEN c.resale_price > avg_prices.avg_brand_price THEN 1 ELSE 0 END) AS count_above_avg_price,
    ROUND(SUM(CASE WHEN c.resale_price > avg_prices.avg_brand_price THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS percentage_above_avg_price
FROM 
    car c
INNER JOIN (
    SELECT 
        `index`,
        brand_name,
        resale_price,
        AVG(resale_price) OVER (PARTITION BY brand_name) AS avg_brand_price
    FROM 
        car
) AS avg_prices
ON c.`index` = avg_prices.`index`
GROUP BY 
    c.brand_name HAVING total_cars> 15
ORDER BY 
    percentage_above_avg_price DESC;
    
-- Volvo is the only brand which has more cars above average than below. Top percentage cars are Volvo, Fiat and Maruti Suzuki.
 
