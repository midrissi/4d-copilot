//%attributes = {}
#DECLARE($a : Real; $b : Real)->$result : Real

If ($b=0)
	THROW(-1; "Division by zero is not allowed")
Else
	$result:=$a/$b
End if
