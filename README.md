# HL7 to FHIR Cohort Population

## About the Project
This project gets HL7 Radiology Result messages and checks to see if the patients in those messages exist in the 
InterSystems FHIR server repository. If the patients exist, then the FHIR IDs of those patients are returned. 
If the patients don't exist, then new FHIR Patient resources are created based on the demographics information parsed
in from the PID segments in the HL7 messages. This process helps to create FHIR cohorts that can be used for analytics,
research, and other purposes while expanding the InterSystems FHIR repository.

## Built With
InterSystems FHIR Server,
InterSystems HealthShare,
InterSystems IRIS for Health,
InterSystems IRIS Studio

## Prerequisites
1.	Install and Configure [InterSystems HealthShare](https://www.intersystems.com/interoperability-platform/) or [InsterSystems IRIS for Health](https://www.intersystems.com/data-platform/)

2.	Install and Configure [InterSystems FHIR Server](https://www.intersystems.com/resources/intersystems-fhir-server/)

3.	Understanding and working knowledge of InterSystems IRIS for Health or InterSysems HealthShare technology, HL7 FHIR Specification, and HL7 Message Structure

## Installation
1. Create an Integration Production in InterSystems IRIS for Health or HealthShare instance that receives 
HL7 Radiology Results messages (Message Type - ORU_R01)

![image](https://github.com/SysIntergrationTechTeam/HL7-FHIR-Cohort-Population/assets/110857238/68e76db6-4516-4d8e-a0a7-45e2956c08e1)


![image](https://github.com/SysIntergrationTechTeam/Intersystems-Contest-FHIR/assets/110857238/838e1af1-a7c1-47f0-a558-5df2250d761c)
 

2. Create a Business Process Logic (BPL) in the InterSystems FHIR Namespace to parse in the HL7 Messages and create FHIR calls
       to search and create patients in the FHIR repository. Please refer to the BPLCode.cls file for complete code.

![image](https://github.com/SysIntergrationTechTeam/Intersystems-Contest-FHIR/assets/110857238/51e1ce3b-d8e6-41e2-958e-172e4c63bd07)



3. Route the radiology result messages from HealthShare to the Service in the FHIR Server Production, process the messages through the BPL,
       and get information back in the Operation

![image](https://github.com/SysIntergrationTechTeam/Intersystems-Contest-FHIR/assets/110857238/19599d00-c8c9-4bdf-879b-157620ea5dc8)

![image](https://github.com/SysIntergrationTechTeam/Intersystems-Contest-FHIR/assets/110857238/ac8084cd-836a-403f-852e-96a54fae8a06)

## Usage

**Scenario 1: If Patient exists in the FHIR Repository**

  
*Incoming HL7 Radiology Result Message*

![image](https://github.com/SysIntergrationTechTeam/Intersystems-Contest-FHIR/assets/110857238/6b1d7ca1-7a65-4dff-bb4a-ab291040621f)

*Parse in the patient demographics data from the HL7 Message and search for the patient in the FHIR repository*

![image](https://github.com/SysIntergrationTechTeam/Intersystems-Contest-FHIR/assets/110857238/4f3a8c27-d8c5-4747-9536-53d27320db0b)

*InterSystems FHIR server returns response after querying the repository with the Patient resource details*

![image](https://github.com/SysIntergrationTechTeam/Intersystems-Contest-FHIR/assets/110857238/0ac4e6c1-6a8d-49c5-a73d-517ac2495249)

![image](https://github.com/SysIntergrationTechTeam/Intersystems-Contest-FHIR/assets/110857238/2b9d5daa-dca1-4c88-97ce-dd552e0873ba)



**Scenario 2: If Patient doesn’t exist in the FHIR Repository**
  
*Incoming HL7 Radiology Result Message*

![image](https://github.com/SysIntergrationTechTeam/Intersystems-Contest-FHIR/assets/110857238/6b1d7ca1-7a65-4dff-bb4a-ab291040621f)

*Parse in the patient demographics data from the HL7 Message and search for the patient in the FHIR repository*

![image](https://github.com/SysIntergrationTechTeam/Intersystems-Contest-FHIR/assets/110857238/4f3a8c27-d8c5-4747-9536-53d27320db0b)

*InterSystems FHIR server returns response after querying for the patient in the repository*

![image](https://github.com/SysIntergrationTechTeam/Intersystems-Contest-FHIR/assets/110857238/4a0e939f-ff2e-43fd-aff8-d0c3bfba4c62)


*FHIR POST call sends a request to create the Patient resource in the FHIR repository*

![image](https://github.com/SysIntergrationTechTeam/Intersystems-Contest-FHIR/assets/110857238/d99cb433-14ab-4ae5-b588-d8f8fb3b2eb8)


*InterSystems FHIR server returns response with **'HTTP/1.1 201 Created'** after creating the Patient resource successfully*

![image](https://github.com/SysIntergrationTechTeam/Intersystems-Contest-FHIR/assets/110857238/47dda997-7dac-4b3d-b84f-6fc8ed5a5331)


*Run SQL queries on the FHIR repository to get the details on the cohort that was created from the steps above*

![image](https://github.com/SysIntergrationTechTeam/Intersystems-Contest-FHIR/assets/110857238/aeb8ba60-f7e3-4936-bd51-367f30b481da)


## Authors and Acknowledgements
[@Momeena.Ali](https://community.intersystems.com/user/momeena-ali), [@Marvin.Asercion](https://community.intersystems.com/user/marvin-asercion), [@Katie Bourbeau](https://community.intersystems.com/user/katie-bourbeau), [@Darren.Marks](https://community.intersystems.com/user/darren-marks), [@Scott.Nathanson](https://community.intersystems.com/user/scott-nathanson)
