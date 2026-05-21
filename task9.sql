use hospital;

-- q1. total billing amount paid by each patient display: patientid, total amount

select patient_id,
sum(amount) as total_amount
from billing
group by patient_id;
 
-- q2. total number of appointments booked for each doctor display: doctorname, appointmentcount

select
concat(d.firstname, ' ', d.lastname) as doctor_name,
 count(a.appointment_id)  as appointment_count
from doctor d
join appointment a on d.doctor_id = a.doctor_id
group by d.doctor_id, d.firstname, d.lastname;
 
-- q3. average billing amount from the billing table

select
avg(amount) as average_billing_amount
from billing;
 
-- q4. maximum and minimum billing amount in billing table

select max(amount) as maximum_amount,
min(amount) as minimum_amount
from billing;
 
-- q5. doctors who have issued more than 2 prescriptions display: doctorname, prescriptioncount

select
concat(d.firstname, ' ', d.lastname) as doctor_name,
count(p.prescription_id)as prescription_count
from doctor d
join prescription p on d.doctor_id = p.doctor_id
group by d.doctor_id, d.firstname, d.lastname
having count(p.prescription_id) > 2;
 
-- q6. total number of medical records grouped by diagnosis  display: diagnosis, recordcount

select
diagnosis,
count(records_id) as recordcount
from medicalrecords
group by diagnosis;
 
-- q7. full name of each patient along with their diagnosis (from medicalrecord table)

select concat(p.firstname, ' ', p.lastname) as fullname,
 mr.diagnosis
from patient p
join medicalrecords mr on p.patient_id = mr.patient_id;
 
 
-- -------------------------------------------------------
-- q8. all appointments with patient's full name and doctor's full name

select a.appointment_id,a.appointment_date,a.reason,a.status,
p.firstname  as patientfirstname, p.lastname  as patientlastname,
d.firstname  as doctorfirstname, d.lastname   as doctorlastname
from appointment a
join patient p on a.patient_id = p.patient_id
join doctor  d on a.doctor_id  = d.doctor_id;
 
-- q9. all prescriptions with medication name, patient name, and prescribing doctor's name

select pr.prescription_id,pr.medicine_name,
concat(p.firstname, ' ', p.lastname) as patientname,
concat(d.firstname, ' ', d.lastname) as doctorname
from prescription pr
join patient p on pr.patient_id = p.patient_id
join doctor  d on pr.doctor_id  = d.doctor_id;
 
-- q10. all patients and their billing details (include patients with no billing records)

select p.patient_id,
concat(p.firstname, ' ', p.lastname) as patientname,
b.billing_id, b.amount
from patient p
left join billing b on p.patient_id = b.patient_id;

-- q11. all doctors and any appointments they have(include doctors with no appointments)

select d.doctor_id,
concat(d.firstname, ' ', d.lastname) as doctorname,
a.appointment_id,a.appointment_date, a.status
from doctor d
left join appointment a on d.doctor_id = a.doctor_id;
 
-- q12. each patient's full name and total amount billed  (join patient and billing tables)

select concat(p.firstname," ", p.lastname) as fullname,
sum(b.amount)  as total_billed_amount
from patient p
join billing b on p.patient_id = b.patient_id
group by p.patient_id, p.firstname, p.lastname;
 
-- q13. appointment details with patient's gender  and contact info

select a.appointment_id,a.appointment_date,a.reason,a.status,
p.gender,p.phone as phone
from appointment a 
join patient p on a.patient_id = p.patient_id;
 
-- q14. all appointments where status is 'scheduled'and appointment date is after jan 1, 2026

select *from appointment
where status = 'scheduled'
and appointment_date > '2026-01-01';
 
-- q15. all patients whose first name starts with 'a'

select *from patient
where firstname like 'a%';
 
-- q16. all billing records where amount is between 500 and 2000

select *from billing
where amount between 500 and 2000;
 
-- q17. all prescriptions where medication is 'paracetamol', 'ibuprofen', or 'amoxicillin'

select *
from prescription
where medicine_name in ('paracetamol', 'ibuprofen', 'amoxicillin');
 
-- q18. medical records where treatment contains 'surgery'or notes are not null

select *from medicalrecords
where treatment like '%surgery%'
or note is not null;
 
-- q19. add a new column bloodgroup varchar(5) to the patient table

alter table patient
add bloodgroup varchar(5);
 
-- question20. modify the phone column in doctor table from varchar(15) to varchar(20)

alter table doctor
modify column phone varchar(20);
