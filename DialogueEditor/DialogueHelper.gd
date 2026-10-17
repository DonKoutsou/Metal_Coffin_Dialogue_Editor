extends RefCounted

class_name DialogueHelper

static func get_uid_from_tres(path: String) -> String:
	if not FileAccess.file_exists(path):
		return ""

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return ""

	var header := file.get_line()
	file.close()

	var regex := RegEx.new()
	regex.compile('uid="(uid://[^"]+)"')

	var result := regex.search(header)
	if result:
		return result.get_string(1)

	return ""

static func write_uid_to_tres(path: String, uid: String) -> bool:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return false

	var content := file.get_as_text()
	file.close()

	var regex := RegEx.new()
	regex.compile('(?m)^\\[gd_resource([^\\]]*)\\]')

	var match_result := regex.search(content)
	if match_result == null:
		return false

	var header := match_result.get_string(0)
	var attributes := match_result.get_string(1)

	# Remove any existing UID attribute.
	var uid_regex := RegEx.new()
	uid_regex.compile('\\s+uid="[^"]*"')
	attributes = uid_regex.sub(attributes, "", true)

	# Add the new UID.
	attributes += ' uid="' + uid + '"'

	content = content.replace(
		header,
		"[gd_resource" + attributes + "]"
	)

	file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return false

	file.store_string(content)
	file.close()
	return true
