/// @func	console_skin_load_all()
/// @desc	Loads all console skins from folder
function console_skin_load_all() {
	var _folder_path = working_directory + "GM-EzConsole/";
	var _skins = {};
	var _file_name, _file, _json;
	_file_name = file_find_first(_folder_path + "*.skin", 0);
	while (_file_name != "") {
		_file = file_text_open_read(_folder_path + _file_name);
		_json = __ezConsole_dep_file_to_json(_file);
		_skins[$ _json.name] = _json;
		file_text_close(_file);

		_file_name = file_find_next();
	}
	
	file_find_close();
	return _skins;
}

/// @func	console_skin_get_width(width)
/// @param	{real}	width
function console_skin_get_width(_w) {
	return round( _w <= 1 ? _w * window_get_width() : _w );
}

/// @func	console_skin_get_height(height)
/// @param	{real}	height
function console_skin_get_height(_h) {
	return round( _h <= 1 ? _h * window_get_height() : _h );
}