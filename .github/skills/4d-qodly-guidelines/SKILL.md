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

## Related Skill

For bug diagnosis workflow, use the `4d-debugger` skill.
