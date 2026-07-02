shared singleton Class constructor()
	
	// Mock Users REST API
	// GET    /api/users        -> list all users
	// GET    /api/users/:id    -> get one user
	// POST   /api/users        -> create user { name, email }
	// PUT    /api/users/:id    -> update user { name?, email? }
	// DELETE /api/users/:id    -> delete user
	
Function handleRequest($request : 4D:C1709.IncomingMessage) : 4D:C1709.OutgoingMessage
	var $response : 4D:C1709.OutgoingMessage:=4D:C1709.OutgoingMessage.new()
	$response.setHeader("Content-Type"; "application/json")
	
	This:C1470._bootstrap()
	
	var $userId : Text:=""
	If ($request.urlPath.length>2)
		$userId:=$request.urlPath[2]
	End if 
	
	Case of 
		: ($request.verb="GET") & ($userId="")
			This:C1470._listUsers($response)
		: ($request.verb="GET") & ($userId#"")
			This:C1470._getUser($userId; $response)
		: ($request.verb="POST")
			This:C1470._createUser($request.getJSON(); $response)
		: ($request.verb="PUT") & ($userId#"")
			This:C1470._updateUser($userId; $request.getJSON(); $response)
		: ($request.verb="DELETE") & ($userId#"")
			This:C1470._deleteUser($userId; $response)
		Else 
			$response.statusCode:=405
			$response.setBody(cs:C1710.ResponseHelper.me.error("Method not allowed"))
	End case 
	
	return $response
	
Function _bootstrap()
	Use (Storage:C1525)
		If (Storage:C1525.app=Null:C1517)
			Storage:C1525.app:=New shared object:C1526("nextId"; 1)
		End if 
		If (Storage:C1525.users=Null:C1517)
			Storage:C1525.users:=New shared collection:C1527
		End if 
	End use 
	
Function _listUsers($response : 4D:C1709.OutgoingMessage)
	$response.statusCode:=200
	$response.setBody(cs:C1710.ResponseHelper.me.success(Storage:C1525.users))
	
Function _getUser($id : Text; $response : 4D:C1709.OutgoingMessage)
	var $found : Object:=Storage:C1525.users.find(Formula:C1597($1.value.id=$id))
	If ($found#Null:C1517)
		$response.statusCode:=200
		$response.setBody(cs:C1710.ResponseHelper.me.success($found))
	Else 
		$response.statusCode:=404
		$response.setBody(cs:C1710.ResponseHelper.me.error("User not found"))
	End if 
	
Function _createUser($body : Object; $response : 4D:C1709.OutgoingMessage)
	var $nextId : Integer
	Use (Storage:C1525.app)
		$nextId:=Storage:C1525.app.nextId
	End use 
	
	var $user : Object:=New shared object:C1526()
	Use ($user)
		$user.id:=String:C10($nextId)
		$user.name:=String:C10($body.name)
		$user.email:=String:C10($body.email)
	End use 
	Use (Storage:C1525.users)
		Storage:C1525.users.push($user)
	End use 
	Use (Storage:C1525.app)
		Storage:C1525.app.nextId:=Storage:C1525.app.nextId+1
	End use 
	
	$response.statusCode:=201
	$response.setBody(cs:C1710.ResponseHelper.me.success($user))
	
Function _updateUser($id : Text; $body : Object; $response : 4D:C1709.OutgoingMessage)
	var $idx : Integer
	var $updated : Object
	Use (Storage:C1525.users)
		$idx:=Storage:C1525.users.findIndex(Formula:C1597($1.value.id=$id))
		If ($idx>=0)
			If ($body.name#Null:C1517)
				Storage:C1525.users[$idx].name:=String:C10($body.name)
			End if 
			If ($body.email#Null:C1517)
				Storage:C1525.users[$idx].email:=String:C10($body.email)
			End if 
			$updated:=Storage:C1525.users[$idx]
		End if 
	End use 
	If ($idx>=0)
		$response.statusCode:=200
		$response.setBody(cs:C1710.ResponseHelper.me.success($updated))
	Else 
		$response.statusCode:=404
		$response.setBody(cs:C1710.ResponseHelper.me.error("User not found"))
	End if 
	
Function _deleteUser($id : Text; $response : 4D:C1709.OutgoingMessage)
	var $idx : Integer:=Storage:C1525.users.findIndex(Formula:C1597($1.value.id=$id))
	If ($idx>=0)
		Use (Storage:C1525.users)
			Storage:C1525.users.remove($idx)
		End use 
		$response.statusCode:=200
		$response.setBody(cs:C1710.ResponseHelper.me.success(New object:C1471("message"; "User deleted")))
	Else 
		$response.statusCode:=404
		$response.setBody(cs:C1710.ResponseHelper.me.error("User not found"))
	End if 
	