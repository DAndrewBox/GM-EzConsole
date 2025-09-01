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

/// @func	console_add_skin(skin_struct)
/// @param	{Struct}	skin_struct
function console_add_skin(_skin) {
	ezConsole_skin_list[$ _skin.name] = _skin;
}

/// @func	console_skin_get_width(width)
/// @param	{Real}	width
function console_skin_get_width(_w) {
	_w = real(_w);
	return round( _w <= 1 ? (_w * window_get_width()) : _w );
}

/// @func	console_skin_get_height(height)
/// @param	{Real}	height
function console_skin_get_height(_h) {
	_h = real(_h);
	return round( _h <= 1 ? (_h * window_get_height()) : _h );
}

/// @func	console_get_skin_prop_names()
function console_get_skin_prop_names() {
	static _prop_names = [
		"name",
		"author",
		"version",
		"width",
		"height",
		"anchor",
		"bg_color",
		"bg_alpha",
		"text_font",
		"text_font_xoff",
		"text_font_yoff",
		"text_color_common",
		"text_color_error",
		"text_color_warning",
		"text_color_info",
		"text_alpha",
		"text_blink_char",
		"text_blink_rate",
		"text_start_char",
		"bar_height",
		"bar_color",
		"bar_color_highlight",
		"bar_xpad",
		"bar_ypad",
		"bar_inset",
		"blur_amount",
		"screenfill_color",
		"screenfill_alpha",
		"typeahead_text_color",
		"typeahead_text_color_highlight"
	];
	
	return _prop_names;
}

/// @func	console_skin_set_prop(prop, value)
/// @param	{String}	prop
/// @param	{any}	value
function console_skin_set_prop(_prop, _val) {
	var _fixed_val;
	
	var _is_color = string_pos("color", _prop);
	if (_is_color) {
		_fixed_val = __ezConsole_dep_hex_to_dec(_val);
	}
	
	var _is_string =
		string_pos("char", _prop)
		|| _prop == "name"
		|| _prop == "author"
		|| _prop == "version";
	if (_is_string) {
		_fixed_val = _val;
	}
	
	if (!_is_color && !_is_string) {
		_fixed_val = real(_val);
	}
	
	show_debug_message(_val)
	show_debug_message(_fixed_val);
	struct_set(ezConsole_skin_current, _prop, _fixed_val);
}