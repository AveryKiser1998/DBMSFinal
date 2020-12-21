--Document and tables created by Avery Kiser

--All tables based on the data that was given in the assignment, I tried to simplify
--it as much as possible for ease of the queries. 

--create table patient
--JDBC does not like the data types for the first query
CREATE table patient (
patient_name varchar(40),
DOB DATE,
address varchar(40),
phone varchar(40),
comp_name varchar(40),
primary key(patient_name, DOB),
CONSTRAINT fk_comp_name FOREIGN KEY(comp_name)
    REFERENCES insurance(comp_name)
);

--insert into patient
insert into patient values ('Avery Kiser', DATE '1998-01-12', '710 2nd ST NE LF MN',
'1-320-733-2478', 'None');
insert into patient values ('George Foreman', DATE '1949-01-10',  'Marshall TX',
'1-800-947-3745', 'Geico');
insert into patient values ('Alexis Newhouse', DATE '1989-09-25', '205 1st ST NY NY',
'1-348-924-6431', 'Allstate');
insert into patient values ('Zoe Vixen', DATE '1969-04-20', '1050 Walker AVE LA CA',
'1-850-360-6284', 'Esure');
insert into patient values ('Derrick Henry', DATE '1994-01-04', '972 9th ST Nashville TN',
'1-729-982-6751', 'None');

/*SELECT *
FROM patient;*/

--create table insurance
CREATE table insurance (
comp_name varchar(40),
group_number varchar(40),
primary key(comp_name)
);

--insert into insurance
insert into insurance values ('Geico', '0195');
insert into insurance values ('Esure', '0952');
insert into insurance values ('Allstate', '45216');
insert into insurance values ('Xfinity', '5654');
insert into insurance values ('Parker Brothers', '2152214');
insert into insurance values ('None', 'None');

/*SELECT *
FROM insurance;*/

--create table prescription
CREATE table prescription (
drug_name varchar(40),
phys_name varchar(40),
issue_date DATE,
patient varchar(40),
directions varchar(40),
quantity varchar(40),
dosage varchar(40),
primary key(drug_name, patient)
);

--insert into prescription
insert into prescription values ('Acetaminophen', 'Dr.Love', DATE '2019-01-09',
'Avery Kiser', 'Take 700 mgs at a time 2 times a day', '2 at once, 100 total', 
'350 mgs');
insert into prescription values ('Paracetamol', 'Dr.Pain', DATE '2018-12-31',
'Derrick Henry', 'Take 800 mgs at a time 2 times a day', '2 at once, 200 total', 
'400 mgs');
insert into prescription values ('Oxycodone', 'Dr.Fix', DATE '2020-07-07',
'George Foreman', 'Take 600 mgs at a time 1 time a day', '2 at once, 50 total', 
'300 mgs');
insert into prescription values ('Acetaminophen', 'Dr.Fix', DATE '2020-10-31',
'George Foreman', 'Take 750 mgs at a time twice a day', '2 at once, 250 total', 
'375 mgs');

/*SELECT *
FROM prescription;*/

--create table filled
--timestamp function found from stack overflow
CREATE table filled (
prescribe_time TIMESTAMP,
patient_name varchar(40),
DOB DATE,
pharm_name varchar(40),
primary key(prescribe_time, patient_name)
);

--insert into filled
insert into filled values (TIMESTAMP '2020-12-10 14:30:00', 'Avery Kiser', DATE 
'1998-01-12', 'Janice');
insert into filled values (TIMESTAMP '2018-09-18 12:18:12', 'Derrick Henry', DATE 
'1994-01-04', 'Jackie');
insert into filled values (TIMESTAMP '2019-06-15 2:47:00', 'George Foreman', DATE 
'1949-01-10', 'Victoria');
insert into filled values (TIMESTAMP '2020-10-31 15:51:35', 'George Foreman', DATE 
'1949-01-10', 'Victoria');

/*SELECT *
FROM filled;*/

--create table drug
CREATE table drug (
NDC varchar(40),
drug_name varchar(40),
lab_name varchar(40),
number_units varchar(40),
primary key (NDC)
);

--insert into drug
insert into drug values ('69618-010', 'Acetaminophen', 'Mayo Clinic labs', '100');
insert into drug values ('42367-090', 'Oxycodone', 'NYC labs', '50');
insert into drug values ('55315-0333', 'Paracetamol', 'Freds inc', '200');
insert into drug values ('57844013001', 'Adderall', 'Florida industries', '200');

/*SELECT *
FROM drug;*/

--create table pharmacist
CREATE table pharmacist (
EIN varchar(40),
pharmacist_name varchar(40),
primary key(EIN)
);

--insert into pharmacist
insert into pharmacist values('122433', 'Janice');
insert into pharmacist values ('889163', 'Jackie');
insert into pharmacist values ('815149', 'Victoria');
insert into pharmacist values ('572918', 'Alexander');
insert into pharmacist values ('93296', 'Mack');
insert into pharmacist values ('689542', 'Jackson');

/*SELECT *
FROM pharmacist;*/

--Indexes
create index patient_info on patient (patient_name, DOB); 

create index drug_totals on prescription (drug_name);

/* I made these indexes because they were the key parts of the queries that I am
looking to run in eclipse, so I figured having them ready on hand would be beneficial.
*/

--Query 1 test
--This query works in oracle but not JDBC
SELECT drug_name
FROM patient JOIN prescription ON patient.patient_name = prescription.patient
WHERE patient_name = 'Avery Kiser' AND DOB = DATE '1998-01-12';

--Query 2 test
--This query works both in oracle and JDBC and Oracle
SELECT drug_name, COUNT(drug_name) AS drug_ranked
FROM prescription
WHERE ROWNUM <= 4
GROUP BY drug_name
ORDER BY drug_ranked DESC;


--Did not know if we needed to make these as tables or not

/*CREATE table is_filled (
drug_name varchar(40),
prescribe_date DATE,
prescribe_time TIME,
patient_name varchar(40),
primary key(drug_name, date, time, patient_name), 
CONSTRAINT fk_drug_name FOREIGN KEY(prescription)
    REFERENCES prescription(drug_name),
CONSTRAINT prescribe_date FOREIGN KEY (filled)
    REFERENCES filled(prescribe_date),
CONSTRAINT prescribe_time FOREIGN KEY (filled)
    REFERENCES filled(prescribe_time),
CONSTRAINT patient_name FOREIGN KEY (filled)
    REFERENCES filled(patient_name)
);*/    

/*CREATE table filled_by (
prescribe_date DATE,
prescribe_time TIME,
patient_name varchar(40),
EIN varchar(40),
primary key(date, time, patient_name, EIN), 
CONSTRAINT prescribe_date FOREIGN KEY (filled)
    REFERENCES filled(prescribe_date),
CONSTRAINT prescribe_time FOREIGN KEY (filled)
    REFERENCES filled(prescribe_time),
CONSTRAINT patient_name FOREIGN KEY (filled)
    REFERENCES filled(patient_name),
CONSTRAINT EIN FOREIGN KEY(pharmacist)
    REFERENCES pharmacist(EIN)
);*/