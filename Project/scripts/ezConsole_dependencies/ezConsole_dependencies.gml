/// @function __ezConsole_dep_string_pad(text, spaces, on_right)
/// @param	{string}	text
/// @param	{real}		spaces
/// @param	{bool}		on_right
/// @ignore
function __ezConsole_dep_string_pad(_text, _spaces, _on_right = true) {
	var _pad = "";
	if (_on_right) {
		/*	A name longer than the column would otherwise run straight into the next one,
			so always leave at least a single space behind it. */
		var _pad_max = max(1, _spaces - string_length(_text));
		for (var i = 0; i < _pad_max; i++) {
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
/// @ignore
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
/// @ignore
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
/// @ignore
function __ezConsole_dep_draw_surface_blur(_surf, _amount, _x, _y, _xscale = 1, _yscale = 1, _rot = 0, _col = -1, _alpha = 1) {
	if !(surface_exists(_surf)) return;
	var _w, _h;
	_w = surface_get_width(_surf);
	_h = surface_get_height(_surf);
	
	static _shader = shd_gml_ext_blur_gauss;
	static _blur_size = shader_get_uniform(_shader, "u_size");
	static _blur_quality = shader_get_uniform(_shader, "u_quality");

	shader_set(_shader);
	shader_set_uniform_f(_blur_size, _w, _h, 25 * _amount * ezConsole_prop_blur_multiplier);
	shader_set_uniform_f(_blur_quality, ezConsole_prop_blur_quality);

	draw_surface_ext(_surf, _x, _y, _xscale, _yscale, _rot, _col, _alpha);
	shader_reset();
}

/// @func	__ezConsole_dep_hex_to_dec(hex)
/// @param	{str}	hex
/// @ignore
function __ezConsole_dep_hex_to_dec(_hex) {
	if (is_undefined(_hex))	return 0;
	if (is_real(_hex)) return _hex;
	
	_hex = _hex;
	var _hex_upper	= string_delete(string_upper(_hex), 1, 1);
	var _hex_fixed	= string_copy(_hex_upper, 5, 2) + string_copy(_hex_upper, 3, 2) + string_copy(_hex_upper, 1, 2);
    var _dec		= 0;
    static _digits	= "0123456789ABCDEF";
    var _len		= string_length(_hex_fixed);
    
	for (var _pos = 1; _pos <= _len; _pos++) {
        _dec = _dec << 4 | (string_pos(string_char_at(_hex_fixed, _pos), _digits) - 1);
    }
 
    return _dec;
}

/// @func	__ezConsole_dep_dec_to_hex(dec)
/// @param	{real}	dec
/// @ignore
function __ezConsole_dep_dec_to_hex(dec) {
    if (is_undefined(dec)) return "#000000";
    if (!is_real(dec)) return "#000000";

    static _digits	= "0123456789ABCDEF";
    var _hex	= "";

    for (var _i = 0; _i < 6; _i++) {
        var _digit	= (dec >> (_i * 4)) & 0xF;
        _hex = string_char_at(_digits, _digit + 1) + _hex;
    }

    // Adjusting the format to #RRGGBB
    _hex = string_copy(_hex, 5, 2) + string_copy(_hex, 3, 2) + string_copy(_hex, 1, 2);

    return "#" + _hex;
}
/// @func	__ezConsole_dep_value_to_string(value, [recursive], [max_depth])
///	@param	{any}	value
///	@param	{real}	[recursive]
///	@param	{real}	[max_depth]	How deep arrays and structs may be expanded. At the limit
///								they are printed as `Array[n]` / `Struct[n]` instead, which
///								is what a one-line table row wants.
/// @ignore
function __ezConsole_dep_value_to_string(_val, _recursive = 0, _max_depth = infinity) {
    var _len, _out;
    
	switch(typeof(_val)) {
		case "string":
			/*	A newline or tab inside a value would break the row it is printed on, so show
				them escaped instead of letting them wrap the table. */
			_out = string_replace_all(_val, "\r", "");
			_out = string_replace_all(_out, "\n", "\\n");
			_out = string_replace_all(_out, "\t", "\\t");
			return "\"" + _out + "\"";
		
		case "undefined":	return "undefined";
		case "null":		return "null";
		case "bool":		return ( _val ? "true" : "false" );
		case "method":		return "function";
		
		case "number":
		case "int32":
		case "int64":		return string(_val);
		
		case "array":
			_len = array_length(_val);
			_out = string("Array[{0}]", _len);
			
			if (_recursive >= _max_depth) return _out;
            
			for (var i = 0; i < _len; i++) {
				_out +=
					"\n" +
					__ezConsole_dep_string_pad(
						string("- [{0}] ", i) + __ezConsole_dep_value_to_string(_val[i], _recursive + 1, _max_depth),
						32 + 2 * (_recursive - 1),
						false
					);
			}
			return _out;
			
		case "struct":
			var _keys = variable_struct_get_names(_val);
			_len = array_length(_keys);
			_out = string("Struct[{0}]", _len);
			
			if (_recursive >= _max_depth) return _out;
			
			var _spaces = 32 - 4 * _recursive;
			
			for (var i = 0; i < _len; i++) {
				var _value = _val[$ _keys[i]];
				_out +=
					"\n" +
					__ezConsole_dep_string_pad(string(".{0}", _keys[i]), _spaces) +
					__ezConsole_dep_value_to_string(_value, _recursive + 1, _max_depth);
			}
			
			return _out;
			
		default:
			/*	Asset and instance references, surfaces, data structure handles and any
				future type all land here. string() renders every one of them, so report
				that rather than giving up with "unknown". */
			try {
				return string(_val);
			} catch (_e) {
				return $"<{typeof(_val)}>";
			}
	}
}

/// @func	__ezConsole_dep_datetime_stamp()
/// @desc	Current date and time as `YYYYMMDD_hhmmss`, safe to use inside a filename.
/// @ignore
function __ezConsole_dep_datetime_stamp() {
	static _pad = function (_value, _len) {
		return string_replace_all(string_format(_value, _len, 0), " ", "0");
	};
	
	var _t = date_current_datetime();
	return
		_pad(date_get_year(_t), 4) + _pad(date_get_month(_t), 2) + _pad(date_get_day(_t), 2) +
		"_" +
		_pad(date_get_hour(_t), 2) + _pad(date_get_minute(_t), 2) + _pad(date_get_second(_t), 2);
}

/// @func	__ezConsole_dep_get_os_name()
/// @desc	Readable name for the platform the game is running on.
/// @ignore
function __ezConsole_dep_get_os_name() {
	if (os_browser != browser_not_a_browser) return "HTML5";
	
	switch (os_type) {
		case os_windows:	return "Windows";
		case os_macosx:		return "macOS";
		case os_linux:		return "Linux";
		case os_ios:		return "iOS";
		case os_tvos:		return "tvOS";
		case os_android:	return "Android";
		case os_ps4:		return "PlayStation 4";
		case os_ps5:		return "PlayStation 5";
		case os_switch:		return "Nintendo Switch";
		case os_xboxone:	return "Xbox One";
		case os_uwp:		return "UWP";
		/*	Only long-standing os_type constants are listed. A newer or more obscure target
			falls through and reports its raw os_type, which is still enough for a bug
			report, and referencing a constant the runtime does not define would not
			compile at all. */
		default:			return $"Unknown (os_type {os_type})";
	}
}

/// @func	__ezConsole_dep_get_builtin_variable_names()
/// @desc	Built-in instance variables worth showing in the console.
///			`variable_instance_get_names()` only reports variables the project declared, so
///			the built-ins have to be listed by hand. Physics (`phy_*`) variables are left out
///			on purpose: reading them on a non-physics instance is noisy and rarely useful.
/// @ignore
function __ezConsole_dep_get_builtin_variable_names() {
	static _names = [
		"id", "object_index", "persistent", "solid", "visible", "depth", "layer",
		"x", "y", "xprevious", "yprevious", "xstart", "ystart",
		"hspeed", "vspeed", "direction", "speed", "friction", "gravity", "gravity_direction",
		"sprite_index", "sprite_width", "sprite_height", "sprite_xoffset", "sprite_yoffset",
		"image_index", "image_number", "image_speed", "image_alpha", "image_angle",
		"image_blend", "image_xscale", "image_yscale",
		"mask_index", "bbox_left", "bbox_right", "bbox_top", "bbox_bottom",
		"alarm",
	];
	
	return _names;
}

/// @func	__ezConsole_dep_get_asset_names(asset_type)
/// @ignore
function __ezConsole_dep_get_asset_names(_asset_type) {
	var _cb, _exists;
	switch (_asset_type) {
		case asset_sprite:	_cb = sprite_get_name;	_exists = sprite_exists;	break;
		case asset_object:	_cb = object_get_name;	_exists = object_exists;	break;
		case asset_sound:	_cb = audio_get_name;	_exists = audio_exists;		break;
		case asset_font:	_cb = font_get_name;	_exists = font_exists;		break;
		case asset_room:	_cb = room_get_name;	_exists = room_exists;		break;
		case asset_script:	_cb = script_get_name;	_exists = script_exists;	break;
		default:			return [];
	}
	
	var _ids = asset_get_ids(_asset_type);
	var _ids_len = array_length(_ids);	
	var _names = [];
	
	for (var i = 0; i < _ids_len; i++) {
		/*	[Bugfix EZC-7]
			asset_get_ids() can hand back an id with nothing behind it, and passing one of
			those to a *_get_name() or tag function makes the runtime log
			"A given parameter was nullptr". Skip them before touching them. */
		if (!_exists(_ids[@ i])) continue;
		
		var _name = _cb(_ids[@ i]);
		if (!is_string(_name) || _name == "") continue;
		if (string_pos("@", _name) || string_pos("___struct___", _name)) continue;
            
        // Logic for scripts, functions and constructors
        if (_asset_type == asset_script) {
            // Skip if it's an internal/private function (starts with "__")
            if (string_starts_with(_name, "__")) continue;
                
            // Skip if it's a EzConsole native function
            if (string_pos("console_", _name) || string_pos("ezconsole", string_lower(_name))) continue;
                
            // Skip if it's a constructor (We don't support executing constructors)
            if (__ezConsole_dep_is_constructor(_ids[@ i])) continue;
        }
		
		array_push(_names, _name);
	}
	
	array_sort(_names, true);
	return _names;
}

/// @func	__ezConsole_dep_is_constructor(function)
/// @param	{any}	function
/// @ignore
function __ezConsole_dep_is_constructor(_func){
	/*	[Bugfix EZC-7]
		asset_has_tags() warns "A given parameter was nullptr" for the script ids that are
		not tagged assets, and asset_get_ids(asset_script) returns plenty of those. Reading
		the tagged set once and testing membership never hands it a bad id. Scripts cannot
		be created at runtime, so caching it is safe. */
	static _constructors = tag_get_asset_ids("@@constructor", asset_script);
	
	return array_contains(_constructors, _func);
}