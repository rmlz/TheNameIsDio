extends Node

# rename this file as login.gd and change the email and password below.
func _ready():
	await Firebase.ready
	Firebase.Auth.login_with_email_and_password(
		"email", "password"
	)
	
func on_login_failed(code, message):
	print("Login failed!!!")
	print("Code: " + str(code))
	print("Message:" + message)
	print("Make sure you have configured the login credentials at login.gd")
	get_tree().quit()

func on_login_succeed():
	print("Login succeeded!!!")
