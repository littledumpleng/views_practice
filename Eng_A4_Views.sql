
-- Question 1: ForestGlenInn

CREATE OR REPLACE VIEW weekend_reservations AS
SELECT
	CONCAT(guests.last_name, ', ', guests.first_name) AS 'Guest Name',
    DATE_FORMAT(reservations.check_in_date, '%W, %M %d, %Y') AS 'Check-in Date',
    DATE_FORMAT(reservations.check_out_date, '%W, %M %d, %Y') AS 'Check-out Date'
FROM ForestGlenInn.guests JOIN ForestGlenInn.reservations
	USING(guest_id)
WHERE WEEKDAY(check_in_date) = 4 AND (DATEDIFF(check_out_date, check_in_date) <  3)
ORDER BY check_in_date, DATE_FORMAT(check_in_date, '%w' ), last_name, first_name; 


-- Question 2: ForestGlenInn

CREATE OR REPLACE VIEW guest_reservations AS
SELECT 
	CONCAT(g.last_name, ', ', g.first_name) AS 'Guest Name',
    ro.room_number AS 'Room Number',
    DATE_FORMAT(re.check_in_date, '%W, %M %d, %Y') AS 'Check-in Date',
    DATE_FORMAT(re.check_out_date, '%W, %M %d, %Y') AS 'Check-out Date',
    DATEDIFF(re.check_out_date, re.check_in_date) AS 'Reservation Length',
    CONCAT('$', rt.base_price) AS 'Price Per Night'
FROM ForestGlenInn.guests g
	JOIN ForestGlenInn.reservations re
		USING (guest_id)
	JOIN ForestGlenInn.rooms ro
		USING(room_id)
	JOIN ForestGlenInn.room_types rt
		USING(room_type_id)
WHERE DATEDIFF(re.check_out_date, re.check_in_date) > 3
ORDER BY DATEDIFF(re.check_out_date, re.check_in_date) DESC, g.last_name, g.first_name;


-- Question 3: ap

CREATE OR REPLACE VIEW overdue_accounts AS
SELECT 
	v.vendor_name AS 'Vendors',
    t.terms_due_days AS 'Terms Due Days',
    (DATEDIFF(CAST('2014-09-02' AS DATE), i.invoice_date)) AS 'Days Since 2014-09-02',
    (DATEDIFF(CAST(i.invoice_due_date AS DATE), i.payment_date) - terms_due_days) AS 'Days Overdue', /*date unspecified*/
   (i.invoice_total - i.credit_total - i.payment_total) AS 'Balance Due'
FROM ap.terms t 
JOIN ap.vendors v
	ON t.terms_id= v.default_terms_id
JOIN ap.invoices i
	ON v.vendor_id = i.vendor_id
WHERE (DATEDIFF(CAST("2014-09-02" AS DATE), invoice_date) - terms_due_days) > 0 
	AND (invoice_total - credit_total - payment_total) > 0 

ORDER BY (DATEDIFF(CAST("2014-09-02" AS DATE), invoice_date) - terms_due_days) DESC, v.vendor_name;
    
