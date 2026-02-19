extends CanvasLayer

@onready var resume_btn = $menu_box/resume_btn
@onready var quit_btn = $menu_box/quit_btn
@onready var start_sfx = $start_sound
@onready var select_sfx = $select_sound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass

func _unhandled_input(event) -> void:
	
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = true
		visible = true
		resume_btn.grab_focus()
		
		
func _on_resume_btn_pressed() -> void:
	get_tree().paused = false
	visible = false
	start_sfx.play()
	
	pass # Replace with function body.


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_resume_btn_focus_entered() -> void:
	select_sfx.play()
	pass # Replace with function body.


func _on_quit_btn_focus_entered() -> void:
	select_sfx.play()
	pass # Replace with function body.
	

func _on_resume_btn_mouse_entered() -> void:
	select_sfx.play()
	pass # Replace with function body.


func _on_quit_btn_mouse_entered() -> void:
	select_sfx.play()
	pass # Replace with function body.
