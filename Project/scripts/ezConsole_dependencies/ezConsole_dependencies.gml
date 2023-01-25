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

/// @func	__EzConsole_dep_file_text_read_whole(file)
/// @param	{real}	file
/// @desc	Read all lines of a file and returns it as a string
function __EzConsole_dep_file_text_read_whole(_file) {
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
	var _str = __EzConsole_dep_file_text_read_whole(_file);
	return json_parse(_str);
}

///	@func	__ezConsole_dep_shader_set_ext(params)
/// @param	{any}	params
/// @desc	Setup a shader with uniform params
function __ezConsole_dep_shader_set_ext(_shader, _params) {	
	var _keys = variable_struct_get_names(_params);
	var _shd_callbacks = {
		u_float:	[shader_set_uniform_f, shader_set_uniform_f_array],
		u_int:		[shader_set_uniform_i, shader_set_uniform_i_array],
		u_texture:	shader_get_sampler_index,
	};
	
	shader_set(_shader);
	for (var i = 0; i < array_length(_keys); i++) {
		var _key = _keys[i];
		var _uniforms = _params[$ _key];
		var _u_names = variable_struct_get_names(_uniforms);

		for (var j = 0; j < array_length(_u_names); j++) {
			var _shd_u;
			var _value = _uniforms[$ _u_names[j]];
			
			if (_key == "u_texture") {
				_shd_u = _shd_callbacks[$ _key](_shader, _uniforms[i]);
				texture_set_stage(_shd_u, _value);
				continue;
			}
			_shd_u = shader_get_uniform(_shader, _u_names[j]);
			_shd_callbacks[$ _key][is_array(_value)](_shd_u, _value);
		}
	}
	delete _params;
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
	
	var _w, _h;
	_w = surface_get_width(_surf);
	_h = surface_get_height(_surf);
	__ezConsole_dep_shader_set_ext(shd_gml_ext_blur_gauss, {
		u_float: {
			size: [_w, _h, 25 * _amount],
		}
	});
	draw_surface_ext(_surf, _x, _y, _xscale, _yscale, _rot, _col, _alpha);
	shader_reset();
}

/// @func	__ezConsole_dep_hex_to_dec(hex)
/// @param	{str}	hex
function __ezConsole_dep_hex_to_dec(hex) {
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
	}
}