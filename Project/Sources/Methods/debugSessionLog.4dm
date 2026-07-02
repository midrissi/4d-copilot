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
