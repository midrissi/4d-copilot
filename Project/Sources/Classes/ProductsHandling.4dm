shared singleton Class constructor()
	
	// Mock Products REST API
	// GET    /api/products        -> list all products
	// GET    /api/products/:id    -> get one product
	// POST   /api/products        -> create product { name, price, category?, inStock? }
	// PUT    /api/products/:id    -> update product { name?, price?, category?, inStock? }
	// DELETE /api/products/:id    -> delete product

Function handleRequest($request : 4D:C1709.IncomingMessage) : 4D:C1709.OutgoingMessage
	var $response : 4D:C1709.OutgoingMessage:=4D:C1709.OutgoingMessage.new()
	$response.setHeader("Content-Type"; "application/json")
	
	This._bootstrap()
	
	var $productId : Text:=""
	If ($request.urlPath.length>2)
		$productId:=$request.urlPath[2]
	End if 
	
	Case of 
		: ($request.verb="GET") & ($productId="")
			This._listProducts($response)
		: ($request.verb="GET") & ($productId#"")
			This._getProduct($productId; $response)
		: ($request.verb="POST")
			This._createProduct($request.getJSON(); $response)
		: ($request.verb="PUT") & ($productId#"")
			This._updateProduct($productId; $request.getJSON(); $response)
		: ($request.verb="DELETE") & ($productId#"")
			This._deleteProduct($productId; $response)
		Else 
			$response.statusCode:=405
			$response.setBody(cs:C1710.ResponseHelper.me.error("Method not allowed"))
	End case 
	
	return $response

Function _bootstrap()
	Use (Storage:C1525)
		If (Storage:C1525.productsApp=Null:C1517)
			Storage:C1525.productsApp:=New shared object:C1526("nextId"; 1)
		End if 
		If (Storage:C1525.products=Null:C1517)
			Storage:C1525.products:=New shared collection:C1527
		End if 
	End use 

Function _listProducts($response : 4D:C1709.OutgoingMessage)
	$response.statusCode:=200
	$response.setBody(cs:C1710.ResponseHelper.me.success(Storage:C1525.products))

Function _getProduct($id : Text; $response : 4D:C1709.OutgoingMessage)
	var $found : Object:=Storage:C1525.products.find(Formula:C1597($1.value.id=$id))
	If ($found#Null:C1517)
		$response.statusCode:=200
		$response.setBody(cs:C1710.ResponseHelper.me.success($found))
	Else 
		$response.statusCode:=404
		$response.setBody(cs:C1710.ResponseHelper.me.error("Product not found"))
	End if 

Function _createProduct($body : Object; $response : 4D:C1709.OutgoingMessage)
	var $nextId : Integer
	Use (Storage:C1525.productsApp)
		$nextId:=Storage:C1525.productsApp.nextId
	End use 
	
	var $product : Object:=New shared object:C1526()
	Use ($product)
		$product.id:=String:C10($nextId)
		$product.name:=String:C10($body.name)
		$product.price:=$body.price
		$product.category:=String:C10($body.category)
		If ($body.inStock=Null:C1517)
			$product.inStock:=True:C214
		Else 
			$product.inStock:=$body.inStock
		End if 
	End use 
	Use (Storage:C1525.products)
		Storage:C1525.products.push($product)
	End use 
	Use (Storage:C1525.productsApp)
		Storage:C1525.productsApp.nextId:=Storage:C1525.productsApp.nextId+1
	End use 
	
	$response.statusCode:=201
	$response.setBody(cs:C1710.ResponseHelper.me.success($product))

Function _updateProduct($id : Text; $body : Object; $response : 4D:C1709.OutgoingMessage)
	var $idx : Integer
	var $updated : Object
	Use (Storage:C1525.products)
		$idx:=Storage:C1525.products.findIndex(Formula:C1597($1.value.id=$id))
		If ($idx>=0)
			If ($body.name#Null:C1517)
				Storage:C1525.products[$idx].name:=String:C10($body.name)
			End if 
			If ($body.price#Null:C1517)
				Storage:C1525.products[$idx].price:=$body.price
			End if 
			If ($body.category#Null:C1517)
				Storage:C1525.products[$idx].category:=String:C10($body.category)
			End if 
			If ($body.inStock#Null:C1517)
				Storage:C1525.products[$idx].inStock:=$body.inStock
			End if 
			$updated:=Storage:C1525.products[$idx]
		End if 
	End use 
	If ($idx>=0)
		$response.statusCode:=200
		$response.setBody(cs:C1710.ResponseHelper.me.success($updated))
	Else 
		$response.statusCode:=404
		$response.setBody(cs:C1710.ResponseHelper.me.error("Product not found"))
	End if 

Function _deleteProduct($id : Text; $response : 4D:C1709.OutgoingMessage)
	var $idx : Integer:=Storage:C1525.products.findIndex(Formula:C1597($1.value.id=$id))
	If ($idx>=0)
		Use (Storage:C1525.products)
			Storage:C1525.products.remove($idx)
		End use 
		$response.statusCode:=200
		$response.setBody(cs:C1710.ResponseHelper.me.success(New object:C1471("message"; "Product deleted")))
	Else 
		$response.statusCode:=404
		$response.setBody(cs:C1710.ResponseHelper.me.error("Product not found"))
	End if
