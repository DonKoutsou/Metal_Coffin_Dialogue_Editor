@tool
extends OptionDialogueNode

class_name DroneOptionDialogueNode

@export var DronePicker : ResourcePicker

func ConfigureOption(options : Happening_Option) -> void:
	super(options)
	if (options is not Drone_Happening_Option):
		print_stack()
	var op : Drone_Happening_Option = options
	if (op.Cpt):
		DronePicker.SetFile(op.Cpt.resource_path)


func _on_dron_picker_resource_changed(resource: Resource) -> void:
	var op : Drone_Happening_Option = option
	op.Cpt = resource
	Changed.emit()


func _on_drone_picker_changed(t: String) -> void:
	var op : Drone_Happening_Option = option
	op.Cpt = load(t)
	Changed.emit()
