/// @function string_pad(text, spaces)
/// @param	{string}	text
/// @param	{real}		spaces
function string_pad(_text, _spaces) {
	var _pad = "";
	for (var i = 0; i < _spaces - string_length(_text); i++) {
		_pad += " ";
	}
	
	return _text + _pad;
}

/// @func	file_text_read_whole(file)
/// @param	{real}	file
/// @desc	Read all lines of a file and returns it as a string
function file_text_read_whole(_file) {
	if (_file < 0) return "";
	
	var _file_str = ""
	while (!file_text_eof(_file)) {
	    _file_str += file_text_readln(_file);
	}
	
	return _file_str;
}

/// @func	file_to_json(file)
/// @param	{real}	file
/// @desc	Read a file a transforms it into a json struct
function file_to_json(_file) {
	var _str = file_text_read_whole(_file);
	return json_parse(_str);
}

///	@func	shader_set_ext(params)
/// @param	{any}	params
/// @desc	Setup a shader with uniform params
function shader_set_ext(_shader, _params) {	
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

/// @func	draw_surface_blur(surf, blur_amount, x, y, xscale, yscale, rot, col, alpha)
/// @param	{real}	surf
/// @param	{real}	blur_amount
/// @param	{real}	x
/// @param	{real}	y
/// @param	{real}	xscale
/// @param	{real}	yscale
/// @param	{real}	rot
/// @param	{real}	col
/// @param	{real}	alpha
function draw_surface_blur(_surf, _amount, _x, _y, _xscale = 1, _yscale = 1, _rot = 0, _col = -1, _alpha = 1) {
	if !(surface_exists(_surf)) return;
	
	var _w, _h;
	_w = surface_get_width(_surf);
	_h = surface_get_height(_surf);
	shader_set_ext(shd_gml_ext_blur_gauss, {
		u_float: {
			size: [_w, _h, 25 * _amount],
		}
	});
	draw_surface_ext(_surf, _x, _y, _xscale, _yscale, _rot, _col, _alpha);
	shader_reset();
}