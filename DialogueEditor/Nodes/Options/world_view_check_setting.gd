@tool
extends PanelContainer

class_name WorldViewCheckSetting

@export var menu : OptionButton
@export var valueLabel : Label
@export var slid : HSlider
@export var possitiveCheckBox : CheckBox

signal worldviewCheckChanged(newType : WorldView.WorldViews)
signal worldviewCheckPossetiveChanged(t : bool)
signal worldviewCheckAmmountChanged(newAmm : float)

func _ready() -> void:
	menu.clear()
	for g in WorldView.WorldViews.keys():
		menu.add_item(g)
	#menu.title = WorldView.WorldViews.keys()[0]

func SetWorldViewCheck(option : Happening_Option) -> void:
	#menu.title = WorldView.WorldViews.keys()[option.WorldviewCheck]
	menu.selected = option.WorldviewCheck
	possitiveCheckBox.set_pressed_no_signal(option.CheckPossetive)
	slid.set_value_no_signal(option.CheckDifficulty)
	valueLabel.text = var_to_str(option.CheckDifficulty)

func _on_popup_menu_index_pressed(index: int) -> void:
	#menu.title = WorldView.WorldViews.keys()[index]
	worldviewCheckChanged.emit(index)
	

func _on_h_slider_value_changed(value: float) -> void:
	valueLabel.text = var_to_str(value)
	worldviewCheckAmmountChanged.emit(value)

func _on_check_box_toggled(toggled_on: bool) -> void:
	worldviewCheckPossetiveChanged.emit(toggled_on)
