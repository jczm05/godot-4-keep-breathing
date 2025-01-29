extends HBoxContainer

@onready var option_button: OptionButton = $Res_OptionButton
@onready var full_screen_check_box: CheckBox = $FullScreen_CheckBox

var Resolutions: Dictionary = {"3840x2160":Vector2i(3840,2160),
								"2560x1440":Vector2i(2560,1440),
								"1920x1080":Vector2i(1920,1080),
								"1600x900":Vector2i(1600,900),
								"1366x768":Vector2i(1366,768),
								"1280x720":Vector2i(1280,720)}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Add_Resolution()
	Check_Variables()

func Check_Variables():
	var _window = get_window()
	var mode = _window.get_mode()
	if mode == Window.MODE_FULLSCREEN:
		full_screen_check_box.set_pressed_no_signal(true)

func Add_Resolution():
	var Current_Res = get_window().get_size()
	var ID = 0
	for r in Resolutions:
		option_button.add_item(r, ID)
		if Resolutions[r] == Current_Res:
			option_button.select(ID)
		ID += 1
func _on_option_button_item_selected(index):
	var ID = option_button.get_item_text(index)
	get_window().set_size(Resolutions[ID])
	Center_Window()
	
func Center_Window():
	var Centre_Screen = DisplayServer.screen_get_position()+DisplayServer.screen_get_size()/2
	var Window_Size = get_window().get_size_with_decorations()
	get_window().set_position(Centre_Screen-Window_Size/2)


func _on_full_screen_check_box_toggled(toggled_on):
	if toggled_on:
		get_window().set_mode(Window.MODE_FULLSCREEN)
	else:
		get_window().set_mode(Window.MODE_WINDOWED)
		Center_Window()
