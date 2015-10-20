/***************************************************************************\
| Programmer: Chris Frazier a.k.a. "Intern A"								|
|  ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  |
| Purpose: To discover what percentage of members have their member numbers | 
| recorded during a visit to a community financial center.				    |
| ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ |
| Sorted by date(range) and location.									    |
| Average Execution Time: ~25 seconds									    |
\***************************************************************************/

--change the date range below
DECLARE @startDate datetime = '2014-05-11' --the starting date
DECLARE @endDate datetime = '2015-05-11' --the ending date

/*
   Caution:																
     If no results are showing up, then your dates need to be modified.	
  	   Make sure your dates are in the format 'YYYY-MM-DD' and that the	
	     starting date is earlier than the ending date.					
																	    */

USE lobbyCentral

SELECT T1."Community Financial Center", "Total Member Visits", "No Member Number", 
	(((100*(T2."Total Member Visits"-T1."No Member Number"))/T2."Total Member Visits")) 
	AS "Percentage of Recorded Member Numbers"
FROM
    (
		SELECT locationName AS "Community Financial Center", COUNT(internalCustomerID) AS "No Member Number"
		FROM tblCustomer JOIN tblRequest
			ON  tblCustomer.customerID = tblRequest.customerID JOIN tblRequestTicket
			ON  tblRequest.requestID = tblRequestTicket.requestID Join tblUser
			ON  tblRequestTicket.userID = tblUser.userID Join tblLocation
			ON  tblUser.locationID = tblLocation.locationID
		WHERE internalCustomerID = '' AND dateCreated >= @startDate AND dateCreated <= @endDate
		GROUP BY locationName
	) T1
	
    JOIN
	(
		SELECT locationName, COUNT(internalCustomerID) AS "Total Member Visits"
		FROM tblCustomer JOIN tblRequest
			ON  tblCustomer.customerID = tblRequest.customerID JOIN tblRequestTicket
			ON  tblRequest.requestID = tblRequestTicket.requestID Join tblUser
			ON  tblRequestTicket.userID = tblUser.userID Join tblLocation
			ON  tblUser.locationID = tblLocation.locationID
		WHERE dateCreated >= @startDate AND dateCreated <= @endDate
		GROUP BY locationName
	) T2
	
	ON T1."Community Financial Center" = T2.locationName