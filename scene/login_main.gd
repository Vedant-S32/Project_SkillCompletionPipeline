extends Control


var main = preload("res://scene/main.tscn").instantiate()
@onready var U_Username = $TextureRect/username
@onready var U_Password = $TextureRect/password
@onready var notification = $Notification

func _ready():
	Firebase.Auth.login_succeeded.connect(_on_FirebaseAuth_login_succeeded)
	Firebase.Auth.signup_succeeded.connect(_on_FirebaseAuth_login_succeeded)
	Firebase.Auth.login_failed.connect(on_login_failed)
	Firebase.Auth.signup_failed.connect(on_signup_failed)

func _on_FirebaseAuth_login_succeeded(_auth):
	Firebase.Auth.get_user_data()
	get_tree().get_root().add_child(main)


func on_login_failed(error_code, message):
	print("error code: " + str(error_code))
	print("message: " + str(message))


func on_signup_failed(error_code, message):
	print("error code: " + str(error_code))
	print("message: " + str(message))


func _on_register_button_button_up():
	var email = U_Username.text
	var password = U_Password.text
	Firebase.Auth.signup_with_email_and_password(email, password)


func _on_login_button_button_up():
	var email = U_Username.text
	var password = U_Password.text
	Firebase.Auth.login_with_email_and_password(email, password)
