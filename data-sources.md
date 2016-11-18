
# Jail Population Management Dashboard Data Sources

1. [From the Jail Management System or other internal data sources](#from-the-jail-management-system-or-other-internal-data-sources)
2. [From Data sources maintained by stakeholders](#from-data-sources-maintained-by-stakeholders)
3. [Configured in the application](#configured-in-the-application)

## From the Jail Management System or other internal data sources

Scheduled Extract-Transform-Load (**ETL**) scripts collect the data below from the agency's JMS multiple times every day. Data for historical visualizations is generated and stored on import. Historical data for visualizations can be backfilled by exporting JMS data with appropriate date ranges.

Sample proposed data formats for this data are available in [CSV](/tmp/sample-data/csv), [JSON](/tmp/sample-data/json/people.json), and [XML](/tmp/sample-data/xml/people.xml) formats.

1. [People](#people)
2. [Bookings](#bookings)
3. [Charges](#charges)

### People

Individual records for people who are or have been in jail. This is relatively static data that is unlikely to change as time passes or bookings are associated to a person. We've included baseline data here, but other characteristics such as _education_, _occupation_, _language spoken_, or _military service status_ could be included if desired.

Variable Name | Description | Example
------------- | ----------- | -------
jms_person_id | the JMS Person ID | `AB124589`
first_name | First name | `MATTHEW`
middle_name | Middle name | `ALAN`
last_name | Last name | `SIMON`
date_of_birth | Birth date | `1970-03-21T00:00:00-04:00`
gender | Gender | `MALE`
race | Race | `WHITE`

### Bookings

Individual booking records for people in jail. A person may have many bookings, and we are allowing for the possiblity of different Inmate Numbers, Facility Names, Cell IDs, and Statuses across different bookings for the same individual.

Variable Name | Description | Example
------------- | ----------- | -------
jms_booking_id | the JMS Booking ID | `201531837`
person_id | Associated JMS Person ID | `AB124589`
booking_date_time | Date booked | `2016-02-21T07:00:00-04:00`
release_date_time | Date released | `2016-03-02T07:00:00-04:00`
inmate_number | Inmate Number | `00948870`
facility_name | Facility Name | `MAIN JAIL COMPLEX`
cell_id | Cell ID | `4N1`
status | Status (may be derived from other variables) | `PRE-TRIAL`

### Charges

A person who has been booked can have multiple charges.

Variable Name | Description | Example
------------- | ----------- | -------
jms_charge_id | the JMS Charge ID | `98-1234-QQ`
booking_id | Associated JMS Booking ID | `201531837`
code | Charge code | `38010`
description | Charge description | `OPERATING ON SUSPENDED OR REVOKED OPERATORS LICENSE`
category | Charge category | `MISDEMEANOR`
court_case_number | Court case number | `13-M-006975`
bond_amount | Bond amount | `500.00`

## From Data sources maintained by stakeholders

The dashboard also displays non-jail program information, which is maintained by program managers or other stakeholders. This data may be stored in an external location, such as a Google spreadsheet, or editable in the application's admin interface.

1. [Non-Jail Program Details](#non-jail-program-details)
1. [Non-Jail Program Populations](#non-jail-program-populations)
1. [Non-Jail Program Capacities](#non-jail-program-capacities)

### Non-Jail Program Details

In-depth descriptions of non-jail programs, including contact information.

Variable Name | Description | Example
------------- | ----------- | -------
name | Name | `Home Incarceration Program`
id | Program ID | `home-incarceration-program`
abbreviation | Abbreviation | `HIP`
description | Description | `An alternative to jail incarceration which allows court-ordered individuals to serve their sentence at home while being electronically monitored. An offender in the HIP Program is required to wear a monitoring device and follow all rules and regulations of the program. A person serving a sentence on HIP is responsible for all costs related to food, housing, clothing and medical care.`
target_population | Target population | `Determined by the sentencing court. HIP population typically includes pretrial offenders (34% of HIP population is pretrial felony and 5% is pretrial misdemeanor) along with sentenced offenders (18% of HIP population is sentenced felony and 43% is sentenced misdemeanor); top offense categories typically include DUI, assault, theft, robbery, burglary, controlled substances, non-support and contempt.`
outcomes_recidivism | Outcomes/Recidivism | `XMDC review in 2008 found an estimated 77% compliance rate; 2011 Jail Trend Analysis found HIP had lower re-arrest rates within 24-mos. of release than jail or work release; XMDC review in 2011 found 19% violation rate (HIP violation used as key indicator)`
participation_requirements | Participation requirements | `Land-line or cellular phone; alcohol and drug testing; curfews; service fees; in-person reporting; employed or seeking employment.`
history | Program history | `Originally initiated in December 1986 through a private contract as the County Home Arrest Monitoring Program (CHAMP). In June 1988, operation of the program was assumed by the county and the name was changed to the Home Incarceration Program.`
eligibility_criteria | Eligibility criteria | `Felony and misdemeanor offenses; pretrial status or sentenced`
operating_agency | Operating agency | `XMDC`
funding | Funding | `XMDC budget`
services | Services offered | `Court-ordered community treatment.`
risk_needs_assessment | Risk/Needs assessment | `Needs assessment performed during orientation phase of program.`
contact_name | Contact name | `Jane Smith`
contact_email | Contact email address | `janesmith@example.com`
contact_phone | Contact phone number | `555-555-5555`
photos | Photos of the program or facility (a list of photo URLs) | `hip-1.jpg,hip-2.jpg,hip-3.jpg`

### Non-Jail Program Populations

The current populations of non-jail programs.

Variable Name | Description | Example
------------- | ----------- | -------
program_id | Program ID | `home-incarceration-program`
population | Population | `522`
as_of | Date updated | `2016-05-04`

### Non-Jail Program Capacities

The current capacities of non-jail programs.

Variable Name | Description | Example
------------- | ----------- | -------
program_id | Program ID | `home-incarceration-program`
capacity | Capacity | `700`
as_of | Date updated | `2015-03-01`

## Configured in the application

This data–along with other site-specific data like facility descriptions, images, and contact information–will be editable by authorized users in the application's admin interface.

1. [Jail Facility Limits](#jail-facility-limits)

### Jail Facility Limits

These numbers are used for facility population visualizations (see the image below), to see when certain thresholds are passed.

Variable Name | Description | Example
------------- | ----------- | -------
MAX_BEDS | Maximum number of beds available | `2168`
SOFT_CAP | Soft cap on jail population | `2300`
RED_ZONE_START | Start of the 'red zone' for jail population | `2420`
RED_ZONE_END | End of the 'red zone' for jail population | `2480`
HARD_CAP | Hard cap on jail population | `2480`
MAX_JAIL_POPULATION | Maximum supportable jail population | `2600`
