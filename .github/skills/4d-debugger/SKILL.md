---
name: 4d-debugger
user-invocable: true
description: "Use when debugging 4D/Qodly issues, investigating failing endpoints or methods, instrumenting with debugSessionLog, running hypothesis-driven diagnosis, implementing fixes, and cleaning debug traces afterward."
---

# 4D Debugger

Specialized debugging workflow for 4D/Qodly code with `debugSessionLog` instrumentation.

## Primary Goal

Diagnose and fix bugs systematically with minimal user effort:
- Add targeted instrumentation.
- Analyze logs.
- Implement fix.
- Remove debug traces and logs.

## Workflow

1. Clarify the bug
- Ask expected behavior vs actual behavior.
- Confirm reproducibility and trigger conditions.

2. Form a hypothesis
- State likely root cause.
- Identify exact files and code paths to instrument.

3. Ensure logging method exists
- Check for `Project/Sources/Methods/debugSessionLog.4dm`.
- If missing, create it before adding instrumentation.
- Use this baseline implementation:

```4d
//%attributes = {"executedOnServer":false,"preemptive":false}
// #region agent log
#DECLARE($location : Text; $message : Text; $hypothesisId : Text; $runId : Text; $payload : Object)
var $data : Object
var $line : Text
var $file : 4D:C1709.File
var $handle : 4D:C1709.FileHandle

If ($payload#Null:C1517)
  $data:=$payload
Else 
  $data:=New object:C1471
End if 

$line:=JSON Stringify:C1217({\
sessionId: "b19abf"; \
timestamp: Round:C94(Milliseconds:C459/1; 0); \
location: $location; \
message: $message; \
data: $data; \
hypothesisId: $hypothesisId; \
runId: $runId})

$file:=Folder("/PACKAGE").folder(".vscode/logs").file("debug-b19abf.log")

Try
  $file.parent.create()
  $handle:=$file.open("append")
  $handle.writeLine($line)
Catch
  // Debug logging must never break application flow.
End try
```

4. Instrument code
- Add `debugSessionLog` calls at:
  - Function entry/exit
  - Branch points
  - Before/after Storage operations
  - Error paths
  - State-changing operations

5. Request a precise test run
- Give one exact scenario to execute (endpoint, payload, sequence).

6. Analyze logs
- Read `.vscode/logs/debug-*.log`.
- Parse JSON lines and correlate `runId`/`hypothesisId`.

7. Decide next step
- If confirmed, fix code.
- If rejected, state new hypothesis and re-instrument.

8. Implement and verify fix
- Apply minimal code fix.
- Ask user to run same scenario again.

9. Cleanup on confirmation
- Remove debug instrumentation added during session.
- Delete `.vscode/logs/debug-*.log` files.
- Leave only the production fix.

## debugSessionLog Reference

```4d
debugSessionLog($location : Text; $message : Text; $hypothesisId : Text; $runId : Text; $payload : Object)
```

Example:

```4d
var $runId : Text := String(Milliseconds)
debugSessionLog("handleUsers"; "POST entry"; "hyp-001"; $runId; New object("verb"; $request.verb))
```

## Tool Guidance

Prefer these tools while debugging:
- `read_file` for flow analysis.
- `grep_search` for locating paths/conditions.
- `create_file` to create `debugSessionLog.4dm` when missing.
- `apply_patch` for instrumentation/fixes/cleanup.
- `run_in_terminal` for quick test commands and log cleanup.
- `list_dir` and `read_file` for log inspection.

## Response Style

- Be explicit and hypothesis-driven.
- Ask the user only for concrete test execution and final confirmation.
- Keep summaries short and include the exact root cause and final fix.

## Related Skill

Use `4d-qodly-guidelines` for coding conventions and Storage thread-safety rules.
