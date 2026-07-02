---
name: 4d-qodly-guidelines
user-invocable: true
description: "ALWAYS use when asked to write 4D code, generate 4D methods/classes, or modify 4D/Qodly code. Also use for reviewing/refactoring 4D code, 4D syntax rules, Storage shared object rules, Use block thread-safety, collection callback patterns, and method conventions."
---

# 4D Qodly Guidelines

Use this skill for day-to-day coding in this 4D/Qodly project.

## Mandatory Invocation

- If the user asks to write 4D code, this skill must be invoked.
- If the task edits `.4dm` files, this skill must be invoked.
- Apply these rules before proposing or editing 4D code.

## Official Docs

- Main docs: https://developer.4d.com/docs/
- Command themes: https://developer.4d.com/docs/category/themes
- Command index: https://developer.4d.com/docs/commands/command-index
- Language reference: https://developer.4d.com/docs/category/4d-language

## Core 4D Syntax Rules

- Use semicolons for method parameters: `divide(10; 2)`.
- Use `$` for variables: `$result`, `$count`.
- Prefer explicit typing in declarations.

Example declaration pattern:

```4d
//%attributes = {
//  "kind": "projectMethod",
//  "description": "Method description"
//}
#DECLARE($param1 : Type; $param2 : Type)->$result : Type
```

## Storage Rules (Critical)

Storage properties must be one of:
- Shared objects
- Shared collections
- Null

Do not store primitives directly on `Storage`.

Correct initialization pattern:

```4d
Use (Storage)
	If (Storage.app=Null)
		Storage.app:=New shared object("nextId"; 1; "maxUsers"; 100)
	End if
	If (Storage.users=Null)
		Storage.users:=New shared collection
	End if
End use
```

## Use Block Rules (Critical)

- Read operations are safe without `Use`.
- Any mutation must be wrapped in `Use` for the specific shared object/collection being modified.

Correct mutation pattern:

```4d
Use (Storage.app)
	Storage.app.nextId:=Storage.app.nextId+1
End use

Use (Storage.users)
	Storage.users.push($newUser)
End use
```

## Shared Object Creation and Mutation (Strict)

When creating a shared object, mutate it inside a dedicated `Use` block, then store it using a separate `Use` block.

```4d
$newUser:=New shared object()

Use ($newUser)
	$newUser.id:=String($nextId)
	$newUser.name:=String($body.name)
	$newUser.email:=String($body.email)
End use

Use (Storage.users)
	Storage.users.push($newUser)
End use
```

## Collection Callback Rule

With collection callbacks, use `$1.value` for the current element.

```4d
var $found : Object := Storage.users.find(Formula($1.value.id="123"))
var $idx : Integer := Storage.users.findIndex(Formula($1.value.name="John"))
```

Do not use `$1.id` directly.

## Project Methods

Do not rely on a hardcoded list of methods.

When method details are needed, discover them from the project source at runtime:
- Read files in `Project/Sources/Methods/`.
- Infer signatures and behavior from `#DECLARE`, method body, and inline comments.
- Prefer current workspace code over static documentation when the two differ.

## HTTP API Design (Preferred Pattern)

When asked to create HTTP APIs, **always use HTTP Handlers** backed by a shared singleton class.

**Reference**: https://developer.4d.com/docs/WebServer/http-request-handler

### Rules

- The handler class **must** be a `shared singleton`.
- Group one REST resource per handler class. Expose a **single public dispatcher** (e.g. `handleRequest`) that inspects the verb and URL path, then delegates to **private helper functions** — one per operation (list, get, create, update, delete). Do not mix unrelated resources into the same class.
- The dispatcher and helpers receive a `4D.IncomingMessage` and the dispatcher must return a `4D.OutgoingMessage`.
- Do **not** mark handler functions as `exposed` or `onHTTPGet`.
- Register all routes in `Project/Sources/HTTPHandlers.json`. Changes require a Web server restart.

### The dispatcher pattern

The recurring structure is:

1. **Build the response** and set `Content-Type: application/json`.
2. **Bootstrap** any `Storage` structures the resource needs (see Storage Rules).
3. **Extract the path parameter** (the `:id`) from `$request.urlPath`. `urlPath` is a collection of path segments, so `/api/things/42` gives `["api"; "things"; "42"]` and the id is at index `2`.
4. **Route** on `$request.verb` and on whether an id is present, using a `Case of`.
5. **Delegate** to a private `_operation` function that sets `$response.statusCode` and the body.
6. Return `405` for any unmatched verb/route combination.

Wrap outgoing payloads in a consistent envelope (a shared `ResponseHelper` class with `success`/`error` functions keeps status handling uniform).

```4d
// ProductsHandling.4dm
shared singleton Class constructor()

	// GET    /api/products      -> list
	// GET    /api/products/:id  -> read one
	// POST   /api/products      -> create { label, price }
	// PUT    /api/products/:id  -> update { label?, price? }
	// DELETE /api/products/:id  -> delete

Function handleRequest($request : 4D.IncomingMessage) : 4D.OutgoingMessage
	var $response : 4D.OutgoingMessage:=4D.OutgoingMessage.new()
	$response.setHeader("Content-Type"; "application/json")

	This._bootstrap()

	var $id : Text:=""
	If ($request.urlPath.length>2)
		$id:=$request.urlPath[2]
	End if

	Case of
		: ($request.verb="GET") & ($id="")
			This._list($response)
		: ($request.verb="GET") & ($id#"")
			This._get($id; $response)
		: ($request.verb="POST")
			This._create($request.getJSON(); $response)
		: ($request.verb="PUT") & ($id#"")
			This._update($id; $request.getJSON(); $response)
		: ($request.verb="DELETE") & ($id#"")
			This._delete($id; $response)
		Else
			$response.statusCode:=405
			$response.setBody(cs.ResponseHelper.me.error("Method not allowed"))
	End case

	return $response
```

### Private helper functions

Each helper owns one operation, sets `statusCode`, and uses `Storage` following the Storage/Use rules above. Reads run without `Use`; mutations are wrapped.

```4d
Function _bootstrap()
	Use (Storage)
		If (Storage.products=Null)
			Storage.products:=New shared collection
		End if
	End use

Function _get($id : Text; $response : 4D.OutgoingMessage)
	var $found : Object:=Storage.products.find(Formula($1.value.id=$id))
	If ($found#Null)
		$response.statusCode:=200
		$response.setBody(cs.ResponseHelper.me.success($found))
	Else
		$response.statusCode:=404
		$response.setBody(cs.ResponseHelper.me.error("Product not found"))
	End if
```

### HTTPHandlers.json template

Register the **same dispatcher** for both the collection route and the item route. `regexPattern` lets one entry match `/:id`, and `verbs` narrows which methods hit it.

```json
[
  {
    "class": "ProductsHandling",
    "method": "handleRequest",
    "regexPattern": "/api/products/[^/]+",
    "verbs": "GET, PUT, DELETE"
  },
  {
    "class": "ProductsHandling",
    "method": "handleRequest",
    "regexPattern": "/api/products",
    "verbs": "GET, POST"
  }
]
```

### Reading request data

| Need | API |
|------|-----|
| Path segments (for `:id`) | `$request.urlPath` (collection) |
| URL query params | `$request.urlQuery.myParam` |
| Request header | `$request.getHeader("Content-Type")` |
| Body as JSON | `$request.getJSON()` |
| Body as text | `$request.getText()` |
| Body as blob | `$request.getBlob()` |
| Body as picture | `$request.getPicture()` |

## Related Skill

For bug diagnosis workflow, use the `4d-debugger` skill.
