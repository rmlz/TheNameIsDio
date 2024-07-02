extends Node

# rename this file as login.gd and change the email and password below.
func _ready():
	await Firebase.ready
	Firebase.Auth.login_with_email_and_password(
		"email", "password"
	)
	
func on_login_failed():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
