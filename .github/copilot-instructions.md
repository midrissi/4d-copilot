# Copilot Instructions

## API Responses

- Use @file:ResponseHelper.4dm to format API responses.
- In HTTP handlers, return success/error envelopes only through `cs.ResponseHelper.me.success(...)` and `cs.ResponseHelper.me.error(...)`.
