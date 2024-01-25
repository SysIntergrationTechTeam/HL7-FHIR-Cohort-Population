Class UCDavis.FHIR.RADResultsFHIRBPL Extends Ens.BusinessProcess [ ClassType = persistent ]
{

Property TargetConfigNames As %String(MAXLEN = 1000);

Property FHIRInstance As %String(MAXLEN = 1000);

Parameter SETTINGS = "TargetConfigNames:Basic:selector?multiSelect=0&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},FHIRInstance:Basic";

Method OnRequest(pRequest As EnsLib.HL7.Message, Output pResponse As Ens.Response) As %Status
{
	
	#DIM tRequest,tResponse as EnsLib.REST.GenericMessage
	
	do ..PatientSearch(pRequest, .pResponse)
	/// If error in response 
	s tResponseObj=##class(%DynamicObject).%FromJSON(pResponse.Stream.Read())

	if ((pResponse.HTTPHeaders.GetAt("StatusLine") '[" 200 ") || ((pResponse.HTTPHeaders.GetAt("StatusLine") [" 200 ") && (tResponseObj.Error'="")) || ($L(pResponse.Stream.Size)=0)) {
		// Return the FHIR ID
		$$$TRACE("LOCATION="_pResponse.HTTPHeaders.GetAt("LOCATION"))
		s tPatFHIRID=$Piece(pResponse.HTTPHeaders.GetAt("LOCATION"), "/",10)
		$$$TRACE("Match Found! The FHIR ID for the record is "_tPatFHIRID)	
	} 
	else {
		// No Patient Found, Create New Patient
		if tResponseObj.total=0 {
			do ..CreatePatient(pRequest, .pResponse)
			if ((pResponse.HTTPHeaders.GetAt("StatusLine") '[" 201 ") || ((pResponse.HTTPHeaders.GetAt("StatusLine") [" 201 ") && (tResponseObj.Error'="")) ){
		
			}
			else {

			}	
			$$$TRACE("LOCATION="_pResponse.HTTPHeaders.GetAt("LOCATION"))
			s tPatFHIRID=$Piece(pResponse.HTTPHeaders.GetAt("LOCATION"), "/",10)
		
		}
	}
	Quit $$$OK
}

Method PatientSearch(pRequest As EnsLib.HL7.Message, Output pResponse As EnsLib.REST.GenericMessage)
{
	#DIM tRequest,tResponse as EnsLib.REST.GenericMessage
	
	set tRequest=##class(EnsLib.HTTP.GenericMessage).%New()
	do ..AddHeaders(tRequest.HTTPHeaders,"GET",..FHIRInstance_"/Patient?family="_(pRequest.GetValueAt("PID:5(1).1.1"))_"&given="_(pRequest.GetValueAt("PID:5(1).2"))_"&birthdate="_(##class(Ens.Util.FunctionSet).ConvertDateTime(pRequest.GetValueAt("PID:7.1"),"%Y%m%d","%Y-%m-%d")))

	set tRequest.Stream=##class(%Stream.GlobalCharacter).%New()
	set json={
	    "resourceType":"Patient",
        "name": [
        {
           "given": [(pRequest.GetValueAt("PID:5(1).2"))], 
           "family": (pRequest.GetValueAt("PID:5(1).1.1"))
        }
       ],
       "birthDate": (##class(Ens.Util.FunctionSet).ConvertDateTime(pRequest.GetValueAt("PID:7.1"),"%Y%m%d","%Y-%m-%d")),
       "gender": (pRequest.GetValueAt("PID:8")),
       "telecom": [
        {
            "value": (pRequest.GetValueAt("PID:13")),
            "use": "home"
        }
       ],
     	"address": [
        {
            "line": [
                (pRequest.GetValueAt("PID:11(1).1"))
            ],
            "city": (pRequest.GetValueAt("PID:11(1).3")),
            "state":(pRequest.GetValueAt("PID:11(1).4")),
            "postalCode": (pRequest.GetValueAt("PID:11(1).5")),
            "country": "US",
            "district": ""
        	}
    	]       
	}

	do tRequest.Stream.Write(json.%ToJSON())
	do tRequest.HTTPHeaders.SetAt(tRequest.Stream.Size,"Content-Length")
	set tStatus = ..SendRequestSync(..TargetConfigNames, tRequest, .tResponse)
		
	s pResponse=tResponse.%ConstructClone()
	
	s tResponseObj=##class(%DynamicObject).%FromJSON(tResponse.Stream.Read())
	s tPatFHIRID=tResponseObj.entry."0".resource.id
	$$$TRACE("Match Found! The FHIR ID for the record is "_tPatFHIRID)	
			
	return
}

Method CreatePatient(pRequest As EnsLib.HL7.Message, Output pResponse As EnsLib.REST.GenericMessage)
{
	set tRequest=##class(EnsLib.REST.GenericMessage).%New()
	do ..AddHeaders(tRequest.HTTPHeaders,"POST",..FHIRInstance_"/Patient")
	
	//prep & handle gender correctly. can be refactored out
	if (pRequest.GetValueAt("PID:8")="M") {
		set tGender = "male"
	}
	else { 
		if (pRequest.GetValueAt("PID:8")="F") {
		   set tGender = "female"
		}
		else {
		   if (pRequest.GetValueAt("PID:8")="O") {
		      set tGender = "other" 
		   }
		   else {
		      set tGender = "unknown"
		   }
		}
	}
	
	set tRequest.Stream=##class(%Stream.GlobalCharacter).%New()
	set json={
        "resourceType":"Patient",
        "name": [
        {
           "given": [(pRequest.GetValueAt("PID:5(1).2"))], 
           "family": (pRequest.GetValueAt("PID:5(1).1.1"))
        }
       ],
       "birthDate": (##class(Ens.Util.FunctionSet).ConvertDateTime(pRequest.GetValueAt("PID:7.1"),"%Y%m%d","%Y-%m-%d")),
       "gender": (tGender),
       "telecom": [
        {
            "value": (pRequest.GetValueAt("PID:13")),
            "use": "home"
        }
       ],
     	"address": [
        {
            "line": [
                (pRequest.GetValueAt("PID:11(1).1"))
            ],
            "city": (pRequest.GetValueAt("PID:11(1).3")),
            "state":(pRequest.GetValueAt("PID:11(1).4")),
            "postalCode": (pRequest.GetValueAt("PID:11(1).5")),
            "country": "US"        
        	}
    	]
	}
			
	do tRequest.Stream.Write(json.%ToJSON())
	set tStatus = ..SendRequestSync(..TargetConfigNames, tRequest, .tResponse)
	set pResponse=tResponse

	return
}

Method AddHeaders(Output headers, reqType As %String, url As %String)
{
	do headers.SetAt(url,"URL")
	do headers.SetAt(reqType,"HttpRequest")
	do headers.SetAt("application/fhir+json","Content-Type")
	do headers.SetAt("*/*","Accept")
	
	return
}

/// Add connections from TargetConfigNames
ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
	Do ##super(.pArray,pItem)

	If pItem.GetModifiedSetting("TargetConfigNames",.tValue) {
		For i=1:1:$L(tValue,",") { Set tOne=$ZStrip($P(tValue,",",i),"<>W")  Continue:""=tOne  Set pArray(tOne)="" }
	}

	If pItem.GetModifiedSetting("TargetConfigNamesEmail",.tValue) {
		For i=1:1:$L(tValue,",") { Set tOne=$ZStrip($P(tValue,",",i),"<>W")  Continue:""=tOne  Set pArray(tOne)="" }
	}
}

Storage Default
{
<Data name="RADResultsFHIRBPLDefaultData">
<Subscript>"RADResultsFHIRBPL"</Subscript>
<Value name="1">
<Value>TargetConfigNames</Value>
</Value>
<Value name="2">
<Value>FHIRInstance</Value>
</Value>
<Value name="3">
<Value>BasicAuth</Value>
</Value>
<Value name="4">
<Value>EpicClientID</Value>
</Value>
<Value name="5">
<Value>X509Config</Value>
</Value>
</Data>
<DefaultData>RADResultsFHIRBPLDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
