@tool
extends BaseDialogueNode

class_name StageDialogueNode

@export var textInput : TextEdit
@export var rich : RichTextLabel
@export var PicPicket : ResourcePicker
@export var texturePreview : TextureRect

var text : HappeningText
var stage : HappeningStage

var currentlyChanging : bool = false

#------------------------------------------------------------------------
func ConfigureStage(st : HappeningStage, t : HappeningText) -> void:
	if (text != t):
		text = t
		text.changed.connect(TextChanged.bind(text))
	
	if (stage != st):
		stage = st

	textInput.text = text.Text
	
	rich.text = TranslationServer.get_or_add_domain(&"godot.editor").translate(text.Text)
	
	if (text.Pic != ""):
		PicPicket.SetFile(text.Pic)
		
		if (!ResourceLoader.exists(text.Pic)):
			var modDir : String = ProjectSettings.get_setting("application/config/mod_dir")
			var finalLoc = text.Pic.replace("res:/", modDir)
			var img = Image.load_from_file(finalLoc)
			var tex = ImageTexture.create_from_image(img)
			texturePreview.texture = tex
		else:
			texturePreview.texture = load(text.Pic)

#------------------------------------------------------------------------
func TextChanged(t : HappeningText) -> void:
	if (currentlyChanging):
		return

	textInput.text = t.Text
	rich.text = TranslationServer.get_or_add_domain(&"godot.editor").translate(t.Text)

#------------------------------------------------------------------------
func _on_text_edit_text_changed() -> void:
	var newText = textInput.text
	currentlyChanging = true
	text.Text = newText
	rich.text = TranslationServer.get_or_add_domain(&"godot.editor").translate(newText)
	currentlyChanging = false

	Changed.emit()

#------------------------------------------------------------------------
func _on_editor_resource_picker_resource_changed(resource: Resource) -> void:
	text.Pic = resource.resource_path
	Changed.emit()

#------------------------------------------------------------------------
func _on_res_picker_resource_changed(resource: Resource) -> void:
	ConfigureStage(resource, text)
	Changed.emit()

#------------------------------------------------------------------------
func _on_text_picket_resource_changed(resource: Resource) -> void:
	ConfigureStage(stage, resource)
	Changed.emit()


func _on_happening_picker_changed(t: String) -> void:
	ConfigureStage(load(t), text)
	Changed.emit()


func _on_text_picker_changed(t: String) -> void:
	ConfigureStage(stage, load(t))
	Changed.emit()

func _on_textrure_picker_changed(t: String) -> void:
	text.Pic = t
	if (!ResourceLoader.exists(text.Pic)):
		var modDir : String = ProjectSettings.get_setting("application/config/mod_dir")
		var finalLoc = text.Pic.replace("res:/", modDir)
		var img = Image.load_from_file(finalLoc)
		var tex = ImageTexture.create_from_image(img)
		texturePreview.texture = tex
	else:
		texturePreview.texture = load(text.Pic)
	Changed.emit()
