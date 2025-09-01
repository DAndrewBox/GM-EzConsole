/// @func 	EzConsoleLog(message, [type])
/// @param	{String}	message
/// @param	{Real}		[type]
/// @desc	Logs messages to the console with specified types.
function EzConsoleLog(_msg, _type = EZ_CONSOLE_MSG_TYPE.COMMON) constructor {
	message		= _msg;
	type		= _type;
	color		= console_get_type_color(type);
	time		= date_current_datetime();
	timestamp	= console_get_timestamp(time);
}

/// @func	EzConsoleCommand(name, alias, description, callback, arguments)
/// @param	{String}	name
/// @param	{String}	alias
/// @param	{String}	description
/// @param	{Function}	callback
/// @param	{Array}		arguments
/// @desc	Used to create a new ezConsole command
function EzConsoleCommand(_name, _alias = "", _desc = "", _cb = noone, _args = []) constructor {
	name		= _name;
	alias		= _alias;
	desc		= _desc;
	callback	= _cb;
	
	var _args_len = array_length(_args);
	args		= array_create(_args_len, "");
	args_desc	= array_create(_args_len, "");
	args_req	= array_create(_args_len, true);
	args_type	= array_create(_args_len, noone);
	args_options= array_create(_args_len, noone);
	
	args_min	= 0;
	args_max	= _args_len;

	for (var i = 0; i < _args_len; i++) {
		args[i]			= _args[i].name;
		args_desc[i]	= _args[i].desc;
		args_req[i]		= _args[i].required;
		args_type[i]	= _args[i].type;
		args_options[i]	= _args[i].options;
		
		if (_args[i].required) {
			args_min += 1;
		}
	}
	
	console_add_command(self);
}

/// @func	EzConsoleCommandArgument(name, description, required, ezConsole_type)
/// @param	{String}	name
/// @param	{String}	description
/// @param	{Bool}	required
/// @param	{Real}	ezConsole_type
/// @desc	Used to create a new Argument for an ezConsole command.
function EzConsoleCommandArgument(_arg_name, _arg_desc = "", _arg_req = true, _arg_type = noone) constructor {
	name = _arg_name;
	desc = _arg_desc;
	required = _arg_req;
	type = _arg_type;
	options = [];
}

/// @func	EzConsoleCommandArgumentWithOptions(name, description, required, options)
/// @param	{String}	name
/// @param	{String}	description
/// @param	{Bool}	required
/// @param	{Array}	options
/// @desc	Used to create a new Argument for an ezConsole command that can only select from the options array.
function EzConsoleCommandArgumentWithOptions(_arg_name, _arg_desc = "", _arg_req = true, _arg_options = []) constructor {
	array_sort(_arg_options, true);
	
	name = _arg_name;
	desc = _arg_desc;
	required = _arg_req;
	type = ezConsole_type_options;
	options = _arg_options;
}

/// @func	EzConsoleSkin(ownership, size, background_props, text_props, bar_props, misc_props)
/// @param	{Struct}	ownership
/// @param	{Struct}	size
/// @param	{Struct}	background_props
/// @param	{Struct}	text_props
/// @param	{Struct}	bar_props
/// @param	{Struct}	misc_props
function EzConsoleSkin(_owner, _size, _bg, _text, _bar, _misc) constructor {
	name	= _owner.name;
	author	= _owner.author;
	version = _owner.version;
	
	width	= _size.width;
	height	= _size.height;
	anchor	= _size.anchor;
	
	bg_color	= _bg.bg_color;
	bg_alpha	= _bg.bg_alpha;
	blur_amount = _bg.blur_amount;
	
	border_color	= _bg.border_color;
	border_alpha	= _bg.border_alpha;
	
	text_font			= _text.text_font;
	text_font_xoff		= _text.text_font_xoff;
	text_font_yoff		= _text.text_font_yoff;
	text_color_common	= _text.text_color_common;
	text_color_error	= _text.text_color_error;
	text_color_warning	= _text.text_color_warning;
	text_color_info		= _text.text_color_info;
	text_alpha			= _text.text_alpha;
		
	bar_height			= _bar.bar_height;
	bar_color			= _bar.bar_color;
	bar_color_highlight = _bar.bar_color_highlight;
	bar_xpad			= _bar.bar_xpad;
	bar_ypad			= _bar.bar_ypad;
	bar_inset			= _bar.bar_inset;
	
	screenfill_color = _misc.screenfill_color;
	screenfill_alpha = _misc.screenfill_alpha;
	
	text_blink_char = _misc.text_blink_char;
	text_blink_rate = _misc.text_blink_rate;
	text_start_char = _misc.text_start_char;
	
	typeahead_text_color			= _misc.typeahead_text_color;
	typeahead_text_color_highlight	= _misc.typeahead_text_color_highlight;
	
	console_add_skin(self);
	
	/// @func	toJSON()
	function toJSON() {
		var _json = variable_clone(self);
		var _json_key_names = struct_get_names(_json);
		var _json_key_names_len = array_length(_json_key_names);
		
		for (var i = 0; i < _json_key_names_len; i++) {
			var _key = _json_key_names[i];
			if (string_pos("color", _key)) {
				_json[$ _key] = __ezConsole_dep_dec_to_hex(_json[$ _key]);
			}
		}

		return json_stringify(_json, true);
	}
}

/// @func	EzConsoleSkinOwnership(theme_name, author, version)
/// @param	{String}	theme_name
/// @param	{String}	author
/// @param	{String}	version
function EzConsoleSkinOwnership(_name, _author = "unknown", _version = ezConsole_version) constructor {
	name = _name;
	author = _author;
	version = _version;
}

/// @func	EzConsoleSkinSize(width, height, anchor)
/// @param	{Real}	width
/// @param	{Real}	height
/// @param	{Real}	anchor
function EzConsoleSkinSize(_w, _h, _anchor = 0) constructor {
	width = _w;
	height = _h;
	anchor = _anchor;
}

/// @func	EzConsoleSkinBackground(bg_color, border_color, bg_alpha, border_alpha, blur_amount)
/// @param	{Real}	bg_color
/// @param	{Real}	border_color
/// @param	{Real}	alpha
/// @param	{Real}	border_alpha
/// @param	{Real}	blur_amount
function EzConsoleSkinBackground(_col, _border_col, _alpha = 1., _border_alpha = .0, _blur_amount = .20) constructor {
	bg_color = _col;
	bg_alpha = _alpha;
	
	border_color = _border_col;
	border_alpha = _border_alpha;
	
	blur_amount = _blur_amount;
}

/// @func	EzConsoleSkinText(font, font_xoff, font_yoff, color_default, color_error, color_warn, color_info, alpha)
/// @param	{ref}	font
/// @param	{Real}	font_xoff
/// @param	{Real}	font_yoff
/// @param	{Real}	color_default
/// @param	{Real}	color_error
/// @param	{Real}	color_warn
/// @param	{Real}	color_info
/// @param	{Real}	alpha
function EzConsoleSkinText(_fnt, _fnt_xoff, _fnt_yoff, _col_default, _col_error, _col_warn, _col_info, _alpha) constructor {
	text_font =				is_string(_fnt) ? _fnt : font_get_name(_fnt);
	text_font_xoff =		_fnt_xoff;
	text_font_yoff =		_fnt_yoff;
	text_color_common =		_col_default;
	text_color_error =		_col_error;
	text_color_warning =	_col_warn;
	text_color_info =		_col_info;
	text_alpha =			_alpha;
}

/// @func	EzConsoleSkinBar(height, color_default, color_highlight, xpad, ypad, inset)
/// @param	{Real}	height
/// @param	{Real}	color_default
/// @param	{Real}	color_highlight
/// @param	{Real}	xpad
/// @param	{Real}	ypad
/// @param	{Real}	inset
function EzConsoleSkinBar(_h, _col_default, _col_highlight, _xpad = 4, _ypad = 4, _inset = 0) constructor {
	bar_height =			_h;
	bar_color =				_col_default;
	bar_color_highlight =	_col_highlight;
	bar_xpad =				_xpad;
	bar_ypad =				_ypad;
	bar_inset =				abs(_inset);
}

/// @func	EzConsoleSkinMisc(blink_char, blink_rate, start_char, screenfill_color, screenfill_alpha, typeahead_text_color, typeahead_text_highlight)
/// @param	{String}	blink_char
/// @param	{Real}	blink_rate
/// @param	{String}	start_char
/// @param	{Real}	screenfill_color
/// @param	{Real}	screenfill_alpha
/// @param	{Real}	typeahead_text_color
/// @param	{Real}	typeahead_text_highlight
function EzConsoleSkinMisc(_blink_char="_", _blink_rate=1, _start_char=">", _sf_col=#eeeeee, _sf_alpha=.33, _ta_color_default=#eeeeee, _ta_color_high=#0f0f3c) constructor {
	text_blink_char = _blink_char;
	text_blink_rate = _blink_rate;
	text_start_char = _start_char;
	screenfill_color = _sf_col;
	screenfill_alpha = _sf_alpha;
	typeahead_text_color = _ta_color_default;
	typeahead_text_color_highlight = _ta_color_high;
}
