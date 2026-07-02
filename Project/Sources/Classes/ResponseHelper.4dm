shared singleton Class constructor()
	
/**
* Success response wrapper
* Returns: { success: true, result: data }
*/
Function success($result : Variant) : Object
	return New object:C1471("success"; True:C214; "result"; $result)
	
/**
* Error response wrapper
* Returns: { success: false, error: message }
*/
Function error($message : Text) : Object
	return New object:C1471("success"; False:C215; "error"; $message)
	