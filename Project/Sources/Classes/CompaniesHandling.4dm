shared singleton Class constructor()
	
	// Mock Companies REST API
	// GET    /api/companies        -> list all companies
	// GET    /api/companies/:id    -> get one company
	// POST   /api/companies        -> create company { name, industry, size?, website? }
	// PUT    /api/companies/:id    -> update company { name?, industry?, size?, website? }
	// DELETE /api/companies/:id    -> delete company

Function handleRequest($request : 4D:C1709.IncomingMessage) : 4D:C1709.OutgoingMessage
	var $response : 4D:C1709.OutgoingMessage:=4D:C1709.OutgoingMessage.new()
	$response.setHeader("Content-Type"; "application/json")
	
	This._bootstrap()
	
	var $companyId : Text:=""
	If ($request.urlPath.length>2)
		$companyId:=$request.urlPath[2]
	End if 
	
	Case of 
		: ($request.verb="GET") & ($companyId="")
			This._listCompanies($response)
		: ($request.verb="GET") & ($companyId#"")
			This._getCompany($companyId; $response)
		: ($request.verb="POST")
			This._createCompany($request.getJSON(); $response)
		: ($request.verb="PUT") & ($companyId#"")
			This._updateCompany($companyId; $request.getJSON(); $response)
		: ($request.verb="DELETE") & ($companyId#"")
			This._deleteCompany($companyId; $response)
		Else 
			$response.statusCode:=405
			$response.setBody(cs:C1710.ResponseHelper.me.error("Method not allowed"))
	End case 
	
	return $response

Function _bootstrap()
	Use (Storage:C1525)
		If (Storage:C1525.companiesApp=Null:C1517)
			Storage:C1525.companiesApp:=New shared object:C1526("nextId"; 1)
		End if 
		If (Storage:C1525.companies=Null:C1517)
			Storage:C1525.companies:=New shared collection:C1527
		End if 
	End use 

Function _listCompanies($response : 4D:C1709.OutgoingMessage)
	$response.statusCode:=200
	$response.setBody(cs:C1710.ResponseHelper.me.success(Storage:C1525.companies))

Function _getCompany($id : Text; $response : 4D:C1709.OutgoingMessage)
	var $found : Object:=Storage:C1525.companies.find(Formula:C1597($1.value.id=$id))
	If ($found#Null:C1517)
		$response.statusCode:=200
		$response.setBody(cs:C1710.ResponseHelper.me.success($found))
	Else 
		$response.statusCode:=404
		$response.setBody(cs:C1710.ResponseHelper.me.error("Company not found"))
	End if 

Function _createCompany($body : Object; $response : 4D:C1709.OutgoingMessage)
	var $nextId : Integer
	Use (Storage:C1525.companiesApp)
		$nextId:=Storage:C1525.companiesApp.nextId
	End use 
	
	var $company : Object:=New shared object:C1526()
	Use ($company)
		$company.id:=String:C10($nextId)
		$company.name:=String:C10($body.name)
		$company.industry:=String:C10($body.industry)
		If ($body.size=Null:C1517)
			$company.size:="Small"
		Else 
			$company.size:=String:C10($body.size)
		End if 
		$company.website:=String:C10($body.website)
	End use 
	Use (Storage:C1525.companies)
		Storage:C1525.companies.push($company)
	End use 
	Use (Storage:C1525.companiesApp)
		Storage:C1525.companiesApp.nextId:=Storage:C1525.companiesApp.nextId+1
	End use 
	
	$response.statusCode:=201
	$response.setBody(cs:C1710.ResponseHelper.me.success($company))

Function _updateCompany($id : Text; $body : Object; $response : 4D:C1709.OutgoingMessage)
	var $idx : Integer
	var $updated : Object
	Use (Storage:C1525.companies)
		$idx:=Storage:C1525.companies.findIndex(Formula:C1597($1.value.id=$id))
		If ($idx>=0)
			If ($body.name#Null:C1517)
				Storage:C1525.companies[$idx].name:=String:C10($body.name)
			End if 
			If ($body.industry#Null:C1517)
				Storage:C1525.companies[$idx].industry:=String:C10($body.industry)
			End if 
			If ($body.size#Null:C1517)
				Storage:C1525.companies[$idx].size:=String:C10($body.size)
			End if 
			If ($body.website#Null:C1517)
				Storage:C1525.companies[$idx].website:=String:C10($body.website)
			End if 
			$updated:=Storage:C1525.companies[$idx]
		End if 
	End use 
	If ($idx>=0)
		$response.statusCode:=200
		$response.setBody(cs:C1710.ResponseHelper.me.success($updated))
	Else 
		$response.statusCode:=404
		$response.setBody(cs:C1710.ResponseHelper.me.error("Company not found"))
	End if 

Function _deleteCompany($id : Text; $response : 4D:C1709.OutgoingMessage)
	var $idx : Integer:=Storage:C1525.companies.findIndex(Formula:C1597($1.value.id=$id))
	If ($idx>=0)
		Use (Storage:C1525.companies)
			Storage:C1525.companies.remove($idx)
		End use 
		$response.statusCode:=200
		$response.setBody(cs:C1710.ResponseHelper.me.success(New object:C1471("message"; "Company deleted")))
	Else 
		$response.statusCode:=404
		$response.setBody(cs:C1710.ResponseHelper.me.error("Company not found"))
	End if
