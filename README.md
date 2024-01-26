# HL7 to FHIR Cohort Population

## About the Project
This project gets HL7 Radiology Result messages and checks to see if the patients in those messages exist in the 
InterSystems FHIR server repository. If the patients exist, then the FHIR IDs of those patients are returned. 
If the patients don't exist, then new FHIR Patient resources are created based on the demographics information parsed
in from the PID segments in the HL7 messages. This process helps to create FHIR cohorts that can be used for analytics,
research, and other purposes while expanding the InterSystems FHIR repository.

## Built With
InterSystems FHIR Server
InterSystems HealthShare
InterSystems IRIS for Health
InterSystems IRIS Studio

## Prerequisites
1.	Install and Configure [InterSystems HealthShare](https://www.intersystems.com/interoperability-platform/) or [InsterSystems IRIS for Health](https://www.intersystems.com/data-platform/)

2.	Install and Configure [InterSystems FHIR Server](https://www.intersystems.com/resources/intersystems-fhir-server/)

3.	Understanding and working knowledge of InterSystems IRIS for Health or InterSysems HealthShare technology, HL7 FHIR Specification, and HL7 Message Structure

## Installation
1. Create an Integration Production in InterSystems IRIS for Health or HealthShare instance that receives 
HL7 Radiology Results messages (Message Type - ORU_R01)

![image](https://github.com/SysIntergrationTechTeam/HL7-FHIR-Cohort-Population/assets/110857238/68e76db6-4516-4d8e-a0a7-45e2956c08e1)


![image](https://github.com/SysIntergrationTechTeam/HL7-FHIR-Cohort-Population/assets/110857238/12aa2faa-130a-4da7-a3ac-998d47d9e835)

 

2. Create a Business Process Logic (BPL) in the InterSystems FHIR Namespace to parse in the HL7 Messages and create FHIR calls
       to search and create patients in the FHIR repository. Please refer to the BPLCode.cls file for complete code.

![image](https://github.com/SysIntergrationTechTeam/HL7-FHIR-Cohort-Population/assets/110857238/dd009200-53e1-43af-bc5f-b7e83137933b)




3. Route the radiology result messages from HealthShare to the Service in the FHIR Server Production, process the messages through the BPL,
       and get information back in the Operation

![image](https://github.com/SysIntergrationTechTeam/HL7-FHIR-Cohort-Population/assets/110857238/13ae8a64-22f1-4126-abaa-b7327be50eb5)


![image](https://github.com/SysIntergrationTechTeam/HL7-FHIR-Cohort-Population/assets/110857238/5e41e8d9-4e79-4993-8a72-dc9f36ae63c1)


## Usage

**Scenario 1: If Patient exists in the FHIR Repository**

  
*Incoming HL7 Radiology Result Message*

![image](https://github.com/SysIntergrationTechTeam/HL7-FHIR-Cohort-Population/assets/110857238/9e5d7c30-b600-4918-9529-460edb5562ca)


*Parse in the patient demographics data from the HL7 Message and search for the patient in the FHIR repository*

![image](https://github.com/SysIntergrationTechTeam/HL7-FHIR-Cohort-Population/assets/110857238/4fcff931-a95b-4c94-be43-3cc59aca68e4)


*InterSystems FHIR server returns response after querying the repository with the Patient resource details*

![image](https://github.com/SysIntergrationTechTeam/HL7-FHIR-Cohort-Population/assets/110857238/35dc215e-2633-4ff0-aebd-46db939436fa)


![image](https://github.com/SysIntergrationTechTeam/HL7-FHIR-Cohort-Population/assets/110857238/16705eb3-00a1-4f4f-bde7-d6cc1b0e47b4)



**Scenario 2: If Patient doesn’t exist in the FHIR Repository**
  
*Incoming HL7 Radiology Result Message*

![image](https://github.com/SysIntergrationTechTeam/HL7-FHIR-Cohort-Population/assets/110857238/8d543542-4563-4362-a0ad-d39c8afcd282)


*Parse in the patient demographics data from the HL7 Message and search for the patient in the FHIR repository*

![image](https://github.com/SysIntergrationTechTeam/HL7-FHIR-Cohort-Population/assets/110857238/0db75c56-a325-4139-876c-6d936ea1c1f2)


*InterSystems FHIR server returns response after querying for the patient in the repository*

![image](https://github.com/SysIntergrationTechTeam/HL7-FHIR-Cohort-Population/assets/110857238/4691f1a8-79ba-4829-869c-727a8ffffd4b)


*FHIR POST call sends a request to create the Patient resource in the FHIR repository*

![image](https://github.com/SysIntergrationTechTeam/HL7-FHIR-Cohort-Population/assets/110857238/dceeeecb-e272-4a7f-b120-2ec868e29437)



*InterSystems FHIR server returns response with **'HTTP/1.1 201 Created'** after creating the Patient resource successfully*

![image](https://github.com/SysIntergrationTechTeam/HL7-FHIR-Cohort-Population/assets/110857238/ff6225f5-d2b0-4166-9c88-af94146ee7fd)



*Run SQL queries on the FHIR repository to get the details on the cohort that was created from the steps above*

![image](https://github.com/SysIntergrationTechTeam/HL7-FHIR-Cohort-Population/assets/110857238/83197de8-3f41-482d-8f4a-634950873a61)



## Authors and Acknowledgements
[@Momeena.Ali](https://community.intersystems.com/user/momeena-ali), [@Marvin.Asercion](https://community.intersystems.com/user/marvin-asercion), [@Katie Bourbeau](https://community.intersystems.com/user/katie-bourbeau), [@Darren.Marks](https://community.intersystems.com/user/darren-marks), [@Scott.Nathanson](https://community.intersystems.com/user/scott-nathanson)
