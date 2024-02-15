/// @function __ezConsole_dep_string_pad(text, spaces, on_right)
/// @param	{string}	text
/// @param	{real}		spaces
/// @param	{bool}		on_right
function __ezConsole_dep_string_pad(_text, _spaces, _on_right = true) {
	var _pad = "";
	if (_on_right) {
		for (var i = 0; i < _spaces - string_length(_text); i++) {
			_pad += " ";
		}
		return _text + _pad;
	}
	
	for (var i = 0; i < _spaces; i++) {
		_pad += " ";
	}
	return _pad + _text;
}

/// @func	__ezConsole_dep_file_text_read_whole(file)
/// @param	{real}	file
/// @desc	Read all lines of a file and returns it as a string
function __ezConsole_dep_file_text_read_whole(_file) {
	if (_file < 0) return "";
	
	var _file_str = ""
	while (!file_text_eof(_file)) {
	    _file_str += file_text_readln(_file);
	}
	
	return _file_str;
}

/// @func	__ezConsole_dep_file_to_json(file)
/// @param	{real}	file
/// @desc	Read a file a transforms it into a json struct
function __ezConsole_dep_file_to_json(_file) {
	var _str = __ezConsole_dep_file_text_read_whole(_file);
	return json_parse(_str);
}

/// @func	__ezConsole_dep_draw_surface_blur(surf, blur_amount, x, y, xscale, yscale, rot, col, alpha)
/// @param	{real}	surf
/// @param	{real}	blur_amount
/// @param	{real}	x
/// @param	{real}	y
/// @param	{real}	xscale
/// @param	{real}	yscale
/// @param	{real}	rot
/// @param	{real}	col
/// @param	{real}	alpha
function __ezConsole_dep_draw_surface_blur(_surf, _amount, _x, _y, _xscale = 1, _yscale = 1, _rot = 0, _col = -1, _alpha = 1) {
	if !(surface_exists(_surf)) return;
	
	static _shader		= shd_gml_ext_blur_gauss;
	static _u_texel		= shader_get_uniform(_shader, "texel");
	
	var _tex			= surface_get_texture(_surf);
	var _texel_w		= texture_get_texel_width(_tex);
	var _texel_h		= texture_get_texel_height(_tex);
	
	shader_set_uniform_f(_u_texel, _texel_w, _texel_h);

	shader_set(_shader);
	draw_surface_ext(_surf, _x, _y, _xscale, _yscale, _rot, _col, _alpha);
	shader_reset();
}

/// @func	__ezConsole_dep_hex_to_dec(hex)
/// @param	{str}	hex
function __ezConsole_dep_hex_to_dec(hex) {
	if (is_undefined(hex))	return 0;
	if (is_real(hex)) return hex;
	
	var hex_upper = string_delete(string_upper(hex), 1, 1);
	var hex_fixed = string_copy(hex_upper, 5, 2) + string_copy(hex_upper, 3, 2) + string_copy(hex_upper, 1, 2);
    var dec = 0;
    var dig = "0123456789ABCDEF";
    var len = string_length(hex_fixed);
    for (var pos = 1; pos <= len; pos++) {
        dec = dec << 4 | (string_pos(string_char_at(hex_fixed, pos), dig) - 1);
    }
 
    return dec;
}

/// @func	__ezConsole_dep_value_to_string(value)
///	@param	{any}	value
function __ezConsole_dep_value_to_string(_val, _recursive = 0) {
	switch(typeof(_val)) {
		case "string":		return "\"" + _val + "\"";
		case "undefined":	return "undefined";
		case "null":		return "null";
		case "bool":		return ( _val ? "true" : "false" );
		
		case "number":
		case "int32":
		case "int64":		return string(_val);
		
		case "array":
			var _len = array_length(_val);
			var _out = string("Array[{0}]", _len);
			for (var i = 0; i < _len; i++) {
				_out +=
					"\n" +
					__ezConsole_dep_string_pad(
						string("- [{0}] ", i) + __ezConsole_dep_value_to_string(_val[i], _recursive + 1),
						32 + 2 * (_recursive - 1),
						false
					);
			}
			return _out;
			
		case "struct":
			var _keys = variable_struct_get_names(_val);
			var _len = array_length(_keys);
			var _out = string("Struct[{0}]", _len);
			var _spaces = 32 - 4 * _recursive;
			
			for (var i = 0; i < _len; i++) {
				var _value = _val[$ _keys[i]];
				_out +=
					"\n" +
					__ezConsole_dep_string_pad(string(".{0}", _keys[i]), _spaces) +
					__ezConsole_dep_value_to_string(_value, _recursive + 1);
			}
			
			return _out;
			
		default:
			return "Unknown type of value.";
	}
}

/// @func	__ezConsole_dep_get_asset_names(asset_type)
function __ezConsole_dep_get_asset_names(_asset_type) {
	var _cb;
	switch (_asset_type) {
		case asset_sprite:	_cb = sprite_get_name;	break;
		case asset_object:	_cb = object_get_name;	break;
		case asset_sound:	_cb = audio_get_name;	break;
		case asset_font:	_cb = font_get_name;	break;
		case asset_room:	_cb = room_get_name;	break;
		case asset_script:	_cb = script_get_name;	break;
		default:			return [];				break;
	}
	
	var _ids = asset_get_ids(_asset_type);
	var _ids_len = array_length(_ids);	
	var _names = [];
	
	for (var i = 0; i < _ids_len; i++) {
		var _name = _cb(_ids[@ i]);
		if (string_pos("@", _name) || string_pos("___struct___", _name)) continue;
		if (_asset_type == asset_script && (string_pos("ezConsole_", _name) || string_pos("console_", _name))) continue;
		if (_asset_type == asset_script && __ezConsole_dep_is_constructor(_ids[@ i])) continue;
		
		array_push(_names, _name);
	}
	
	array_sort(_names, true);
	return _names;
}

/// @func	__ezConsole_dep_is_constructor(function)
/// @param	{any}	function
function __ezConsole_dep_is_constructor(_func){
	try {
		var _temp = new _func();
		delete _temp;
		
		return true;
	}
	catch (err) {
		if (string_pos("constructor", err.message))
		|| (string_pos("'new'", err.message)) {
			return false;
		}
		return true;
	}
}