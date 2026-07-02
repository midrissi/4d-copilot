---
description: "Scaffold a new 4D HTTP request handler (CRUD) backed by a shared singleton class, following the 4d-qodly-guidelines skill."
name: "Create HTTP Handler"
argument-hint: "Name the resource and its fields (e.g. products with label, price)"
agent: "agent"
---
Create a new 4D HTTP request handler for the resource described by the user: ${input:request:Name the resource and its fields (e.g. products with label, price)}.

Follow these steps precisely:

1. **Load conventions**: Read the `4d-qodly-guidelines` skill at [.github/skills/4d-qodly-guidelines/SKILL.md](../skills/4d-qodly-guidelines/SKILL.md), focusing on the *HTTP API Design*, *Storage Rules*, *Use Block Rules*, and *Collection Callback* sections. Apply every rule before writing code.
2. **Reuse the response envelope**: Wrap all payloads with [Project/Sources/Classes/ResponseHelper.4dm](../../Project/Sources/Classes/ResponseHelper.4dm) via `cs.ResponseHelper.me.success(...)` and `cs.ResponseHelper.me.error(...)`. Do not invent a new envelope.
3. **Create the handler class**: Write `Project/Sources/Classes/<Resource>Handling.4dm` as a `shared singleton Class constructor()`. Expose a single public `handleRequest($request : 4D.IncomingMessage) : 4D.OutgoingMessage` dispatcher that:
   - creates the `4D.OutgoingMessage`, sets `Content-Type: application/json`, and calls a private `_bootstrap()`;
   - extracts the `:id` from `$request.urlPath` (segment index 2);
   - routes on `$request.verb` and id presence with a `Case of`;
   - returns `405` for any unmatched verb/route.
4. **Add private helpers**: One function per operation — `_bootstrap`, `_list`, `_get`, `_create`, `_update`, `_delete`. Each sets `$response.statusCode` and the body. Do **not** mark helpers as `exposed` or `onHTTPGet`.
5. **Mock data + Storage rules**: Seed mock records in `_bootstrap` using a `Storage` shared collection and a shared object counter for the next id. Store only shared objects/collections on `Storage`. Wrap every mutation in a `Use` block for the specific shared entity; keep reads outside `Use`. Create a shared object, mutate it in its own `Use` block, then push it in a separate `Use (Storage.<resource>)` block. Never nest a `Use` on one shared entity inside a `Use` on another.
6. **Query with callbacks**: Use `Storage.<resource>.find(Formula($1.value.id=$id))` and `findIndex(Formula(...))` — reference the element via `$1.value`, never `$1.id`.
7. **Validate input**: Return `400` when required fields are missing on create, and `404` when an id is not found on get/update/delete.
8. **Register routes**: Add two entries to `Project/Sources/HTTPHandlers.json` (create the file if absent) — one `regexPattern` `"/api/<resource>/[^/]+"` with `verbs "GET, PUT, DELETE"` and one `"/api/<resource>"` with `verbs "GET, POST"`, both pointing at the same `handleRequest` dispatcher.
9. **Validate**: Ensure the `.4dm` compiles with no errors and `HTTPHandlers.json` is well-formed JSON.

Then give the user a brief summary listing the resource name, the endpoints table (verb + route + action), and a reminder that the Web server must be restarted for route changes to take effect.
