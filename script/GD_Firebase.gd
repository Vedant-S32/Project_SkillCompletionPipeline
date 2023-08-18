class_name C_Firebase
extends Node

var I_APIKeys = C_APIKeys.new()

var API_Register = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=%s" % I_APIKeys.U_FireStoreAPIKeyAPIKKey
var API_Login = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=%s" % I_APIKeys.U_FireStoreAPIKey
var API_Firestore = "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents/" % I_APIKeys.U_FireStoreProjectid

var API_Token = ""
var API_Userinfo = {}


func _get_token_id_from_result(result: Array) -> Dictionary:
	var temp = JSON.new()
	var result_body = JSON.parse_string(result[3].get_string_from_ascii()) as Dictionary
	print(result_body)
	return {
		"token" : result_body.idToken,
		"id" : result_body.localId
	}


func register(email: String, password: String, http: HTTPRequest) -> void:
	var body = {
		"email" : email,
		"password" : password,
		"returnSecureToken" : true
	}
	var json = JSON.new()
	http.request(API_Register, [], HTTPClient.METHOD_POST, JSON.stringify(body))
	var result = await http.request_completed as Array
	if result[1] != 200:
		API_Token = _get_token_id_from_result(result)
