#region // GET
/// @func	console_get_commands()
/// @desc	Retrieves the list of commands available in the console.
function console_get_commands() {
    static _commands = array_create_ext(array_length(ezConsole_commands), function (_index) {
        return ezConsole_commands[_index];
    });
    
    return _commands;
}

/// @func	console_get_message(message_type, command, params_count, min_params, max_params)
/// @param	{real}    message_type
/// @param	{str}    command
/// @param	{real}    params_count
/// @param	{real}    min_params
/// @param	{real}    max_params
/// @desc	Retrieves console messages based on message types.
function console_get_message(_type, _command, _params_count=0, _min_params=0, _max_params=1) {
    switch (_type) {
        case EZ_CONSOLE_MSG.NOT_ENOUGH_PARAMS:
            return ("\"" + _command + "\" must receive at least " +
                    string(_min_params) + " argument(s).\n(" + string(_params_count) + " were given)");
        
        case EZ_CONSOLE_MSG.TOO_MANY_PARAMS:
            return ("\"" + _command + "\" must receive " +
                    string(_max_params) + " argument(s).\n(" + string(_params_count) + " were given)");
            
        case EZ_CONSOLE_MSG.NOT_A_COMMAND:
            return ("\"" + _command + "\" is not a command.");
            
        case EZ_CONSOLE_MSG.INVALID_PARAM:
            return ("Command \"" + _command + "\" has no param \"");
            
        case EZ_CONSOLE_MSG.HELP_MENU:
            return ("Type \"help <command>\" to get more information about the command.");
            
        case EZ_CONSOLE_MSG.COMMAND_DOESNT_EXISTS:
            return ("Command \"" + _command + "\" does not exist.");
            
        case EZ_CONSOLE_MSG.INTIALIZATION:
            return ($"=== GM EzConsole v{ezConsole_version} ===\nType \"help\" to start.");
            
        case EZ_CONSOLE_MSG.CALLBACK_DOESNT_EXISTS:
            return ("Callback for this command is not defined!");
    }
}

/// @func 	console_get_type_color(type)
/// @param	{real}    type
/// @desc	Retrieves the color associated with a message type.
function console_get_type_color(_type) {
    switch (_type) {
        default:
        case EZ_CONSOLE_MSG_TYPE.COMMON:    return __ezConsole_dep_hex_to_dec(ezConsole_skin_current[$ "text_color_common"]);
        case EZ_CONSOLE_MSG_TYPE.ERROR:		return __ezConsole_dep_hex_to_dec(ezConsole_skin_current[$ "text_color_error"]);
        case EZ_CONSOLE_MSG_TYPE.WARNING:   return __ezConsole_dep_hex_to_dec(ezConsole_skin_current[$ "text_color_warning"]);
        case EZ_CONSOLE_MSG_TYPE.INFO:      return __ezConsole_dep_hex_to_dec(ezConsole_skin_current[$ "text_color_info"]);
    }
}

/// @func 	console_get_timestamp(time)
/// @param	{real}    time
/// @desc	Retrieves a formatted timestamp.
function console_get_timestamp(_t) {
    var _hh, _mm, _ss;
    _hh = string_replace(string_format(date_get_hour(_t), 2, 0), " ", "0");
    _mm = string_replace(string_format(date_get_minute(_t), 2, 0), " ", "0");
    _ss = string_replace(string_format(date_get_second(_t), 2, 0), " ", "0");
    
    return "<" + _hh + ":" + _mm + ":" + _ss + "> ";
}

/// @func 	console_get_suggestion(message)
/// @param	{str}    message
/// @desc	Provides command suggestions based on user input.
function console_get_suggestion(_msg) {
	var _msg_trimmed	= string_split(_msg, " ");
	var _is_command		= array_length(_msg_trimmed) < 2;
	var _suggestion		= "";
	var _commands		= console_get_commands();
	var _commands_len	= array_length(_commands);
	
	if (_is_command) {
		var _command  = "";
		var _msg_len  = string_length(_msg_trimmed[0]);
		for (var i = 0; i < _commands_len; i++) {
			if !(is_struct(_commands[i])) continue;
			_command = _commands[i].name;
			if (_msg_trimmed[0] == string_copy(_command, 1, _msg_len)) {
				var _command_len = string_length(_command);
				_suggestion = string_copy(_command, _msg_len + 1, _command_len - _msg_len);
			}
		}
	} else {
		var _prev_word_is_command = false;
		var _command = _commands[0];
		for (var i = 0; i < _commands_len; i++) {
			if (_msg_trimmed[0] == _commands[i].name) {
				_command = _commands[i];
				_prev_word_is_command = true;
				break;
			}
		}
		
		if (_prev_word_is_command) {
			var _msg_trimmed_len = array_length(_msg_trimmed) - 1;
			var _command_args_len = array_length(_command.args) - 1;
			
			for (var i = _msg_trimmed_len - 1; i <= _command_args_len; i++) {
				if (_msg_trimmed_len >= i + 1 && string_length(_msg_trimmed[i + 1]) >= 1) continue;
				_suggestion += (i == _msg_trimmed_len - 1 ? "" : " ") + _command.args[i];
			}
		}
	}
	
	return _suggestion;
}

/// @func 	console_get_typeahead(message)
/// @param	{str}    message
/// @desc	Provides auto-completion suggestions based on user input.
function console_get_typeahead(_msg) {
	var _msg_trimmed	= string_split(_msg, " ");
	var _is_command		= array_length(_msg_trimmed) == 1;
	var _suggestions	= [];
	var _commands		= console_get_commands();
	var _commands_len	= array_length(_commands);
	
	if (_is_command) {
		var _command  = "";
		var _msg_len  = string_length(_msg_trimmed[0]);
		for (var i = 0; i < _commands_len; i++) {
			_command = _commands[i].name;
			if (_msg_trimmed[0] == string_copy(_command, 1, _msg_len) && _msg_trimmed[0] != _command) {
				array_push(_suggestions, _command);
			}
		}
	} else {
		// When is an argument, check if it's has type ezConsole_type_*
		var _msg_trimmed_len = array_length(_msg_trimmed);
		var _command		 = _msg_trimmed[0];
		var _command_index	 = 0;
		var _command_exists	 = false;
		for (var i = 0; i < _commands_len; i++) {
			if (_commands[i].name == _command) {
				_command_exists = true;
				_command_index = i;
				break;
			}
		}
		
		if (_command_exists && (_msg_trimmed_len - 2) < array_length(_commands[_command_index].args_type)) {
			var _arg			 = _msg_trimmed[_msg_trimmed_len - 1];
			var _arg_type		 = _commands[_command_index].args_type[_msg_trimmed_len - 2];
			var _asset			 = "";
			var _arg_len		 = string_length(_arg);
			var _names;
			
			if (_arg_type == ezConsole_type_options) {
				_names = _commands[_command_index].args_options[_msg_trimmed_len - 2];
				return _names;
			} else if (_arg_type == ezConsole_type_instance) {
				_names = array_create(128, undefined);
				var _count = 0;
				
				with (all) {
					if (_count >= 128) break;
					
					var _inst = object_get_name(object_index);
					if (_arg == string_copy(_inst, 1, _arg_len) && _arg != _inst) {
						_names[_count] =
							ezConsole_enable_typeahead_inst_ref
							? $"{_inst} ({string_replace(string(id), "instance ", "")})"
							: _inst;
						_count++;
					}
				}
				
				_names = array_filter(_names, function (_elem) {
					return _elem != undefined;
				});
				array_sort(_names, true);
				return _names;
			}
			
			_names = console_typeahead_get_names(_arg_type);
			var _len = array_length(_names);
		
			for (var i = 0; i < _len; i++) {
				_asset = _names[i];
				if (_arg == string_copy(_asset, 1, _arg_len) && _arg != _asset) {
					array_push(_suggestions, _asset);
				}
			}
		}
	}	

	return _suggestions;
}
#endregion

#region // ADD
/// @func 	   console_add_command(command)
/// @param	{any}    command
/// @desc	Adds a new command to the console.
function console_add_command(_cmd) {
    array_push(ezConsole_commands, _cmd);
}

/// @func 	   console_add_commands_from_file(filepath)
/// @param	{str}    filepath
/// @desc	Adds commands from a file to the console.
function console_add_commands_from_file(_path) {
	var _file = file_text_open_read(_path);
	var _json = __ezConsole_dep_file_to_json(_file);
	var _json_len = array_length(_json);
	
	for (var i = 0; i < _json_len; i++) {
		var _cmd = _json[i];
		var _args = [];
		var _args_len = array_length(_cmd.args);
		
		for (var j = 0; j < _args_len; j++) {
			var _new_arg = new EzConsoleCommandArgument(
				_cmd.args[j].name,
				_cmd.args[j].desc,
				_cmd.args[j].required,
				console_get_type_from_string(_cmd.args[j].type),
			);
			
			array_push(_args, _new_arg);
		}
		
		new EzConsoleCommand(_cmd.name, _cmd.short, _cmd.desc, asset_get_index(_cmd.callback), _args);
	}
	
	file_text_close(_file);
}
#endregion

#region // Write on console log logic
/// @func 	ConsoleLog(message, [type])
/// @param	{str}	message
/// @param	{real}		[type]
/// @desc	Logs messages to the console with specified types.
function ConsoleLog(_msg, _type = EZ_CONSOLE_MSG_TYPE.COMMON) constructor {
	message		= _msg;
	type		= _type;
	color		= console_get_type_color(type);
	time		= date_current_datetime();
	timestamp	= console_get_timestamp(time);
}

/// @func 	console_write_log(message, type)
/// @param	{str}	message
/// @param	{real}		[type]
/// @desc	Writes messages to the console log.
function console_write_log(_msg, _type = EZ_CONSOLE_MSG_TYPE.COMMON) {
	with (ezConsole) {
		if (console_callback_on_log) console_callback_on_log();
		var _new_msg = new ConsoleLog(_msg, _type);
		ds_list_add(console_text_log, _new_msg);
	
		keyboard_string = "";
		console_text_actual = "";
		console_nav_scroll = ds_list_size(console_text_log);
		event_user(0);
	}
}
#endregion

/// @func 	console_set_visible()
/// @desc	Sets the console to be visible based on user interaction.
function console_set_visible() {
	if (keyboard_check_pressed(console_key_toggle)) {
		// Reset console text bar when visible again
		keyboard_lastkey = noone;
		keyboard_string = "";
		console_text_actual = "";
		visible = true;
		if (console_callback_on_open) console_callback_on_open();
	}
}

/// @func 	console_set_invisible()
/// @desc	Sets the console to be invisible based on user interaction.
function console_set_invisible() {
	visible = false;
	if (console_callback_on_close) console_callback_on_close();
}

/// @func 	console_check_command(message)
/// @param	{str}	message
/// @desc	Checks if the provided message is a valid console command.
function console_check_command(_msg) {
	var _msg_array	= string_split(_msg, " ");
	var _command	= _msg_array[0];
	var _params		= [];
	array_copy(_params, 0, _msg_array, 1, array_length(_msg_array) - 1);
	
	#region // Set all arguments between quotes to just 1 argument
	var _params_len = array_length(_params);
	var _str_param = "";
	var _in_str_param = false;
	var _new_params = [];
	
	for (var i = 0; i < _params_len; i++) {
		if (_in_str_param && string_ends_with(_params[i], "\"")) {
			_str_param += _params[i];
			_in_str_param = false;
			array_push(_new_params, _str_param);
			
			_str_param = "";
			continue;
		}
		
		if (_in_str_param || string_starts_with(_params[i], "\"")) {
			_str_param += _params[i] + " ";
			_str_param = string_replace_all(_str_param, "\"", "");
			_in_str_param = true;
		}		
	
		if (!_in_str_param) {
			array_push(_new_params, _params[i]);
		}
	}
	
	if (_in_str_param) {
		// Failsafe in case of string still open
		_new_params = _params;
	}
	#endregion
	
	_params = _new_params;
	console_write_log(console_text_actual);
	
	static _commands = console_get_commands();
	static _commands_len = array_length(_commands);
	for (var i = 0; i < _commands_len; i++) {
		if (_commands[i].name == _command || (_commands[i].short == _command && _commands[i].short != "-")) {
			if (_commands[i].callback != -1) {
				console_command_execute(_commands[i], _params);
				return;
			} else {
				var _non_existing_callback = console_get_message(EZ_CONSOLE_MSG.CALLBACK_DOESNT_EXISTS, _command);
				console_write_log(_non_existing_callback, EZ_CONSOLE_MSG_TYPE.ERROR);
				return;
			}
		}
	}
	
	var _not_found_text = console_get_message(EZ_CONSOLE_MSG.NOT_A_COMMAND, _command);
	console_write_log(_not_found_text, EZ_CONSOLE_MSG_TYPE.INFO);
}

/// @func 	console_check_params_count(command, params_len, min_params, max_params)
/// @param	{str}	command
/// @param	{real}	params_len
/// @param	{real}	min_params
/// @param	{real}	max_params
/// @desc	Checks if the number of parameters in a command is within the expected range.
function console_check_params_count(_command, _params_len, _min_params, _max_params) {
	if (_params_len < _min_params) {
		// Not enough params
		var _not_enough_text = console_get_message(EZ_CONSOLE_MSG.NOT_ENOUGH_PARAMS, _command, _params_len, _min_params, _max_params);
		console_write_log(_not_enough_text, EZ_CONSOLE_MSG_TYPE.INFO);
		return false;
	} else if (_params_len > _max_params) {
		// Too much params
		var _too_much_text = console_get_message(EZ_CONSOLE_MSG.TOO_MANY_PARAMS, _command, _params_len, _min_params, _max_params);
		console_write_log(_too_much_text, EZ_CONSOLE_MSG_TYPE.INFO);
		return false;
	}
	
	return true;
}
	
/// @func 	console_save_log_to_file()
/// @desc	Saves the console log to a file.
function console_save_log_to_file() {
	var _logs = console_text_log;
	var _msg, _time, _file;	
	_file = file_text_open_write(string("ezConsole_logs_{0}.txt", current_time));
	
	for (var i = 0; i < ds_list_size(_logs); i++) {
		_time = _logs[| i].timestamp;
		_msg = _logs[| i].message;
		file_text_write_string(_file, _time + " " + _msg + "\n");
	}
	
	file_text_close(_file);
}

/// @func 	console_position_set_by_anchor(anchor)
/// @param	{real}	anchor
/// @desc	Sets the console position based on the anchor point.
function console_position_set_by_anchor(_anchor) {
	var _x, _y;
	switch (_anchor) {
		case EZ_CONSOLE_ANCHOR.TOP_LEFT:
			_x = 0;
			_y = 0;
			break;
		
		case EZ_CONSOLE_ANCHOR.TOP_RIGHT:
			_x = window_get_width() - console_width;
			_y = 0;
			break;
		
		case EZ_CONSOLE_ANCHOR.BOTTOM_LEFT:
			_x = 0;
			_y = window_get_height() - console_height;
			break;
			
		case EZ_CONSOLE_ANCHOR.BOTTOM_RIGHT:
			_x = window_get_width() - console_width;
			_y = window_get_height() - console_height;
			break;
		
		default:
			if (is_array(_anchor)) {
				_x = _anchor[0];
				_y = _anchor[1];
			}
			break;
	}
	
	console_x = _x;
	console_y = _y;
}

/// @func	console_is_open()
/// @desc	Checks if the console is currently open.
function console_is_open() {
	return ezConsole && ezConsole.visible;
}

/// @func	console_command_execute(command, args_given)
/// @param	{any}	command
/// @param	{array}	args_given
function console_command_execute(_cmd, _args_given) {
	if (console_check_params_count(_cmd.name, array_length(_args_given), _cmd.args_min, _cmd.args_max)) {
		script_execute(_cmd.callback, _args_given);
	}
}

/// @func	console_typeahead_get_names(ezConsole_type)
/// @param	{real}	ezConsole_type
/// @desc	Retrieves a list of names for type-ahead suggestions based on asset type.
function console_typeahead_get_names(_type) {
	static _names = {
		sprite:	__ezConsole_dep_get_asset_names(asset_sprite),
		object:	__ezConsole_dep_get_asset_names(asset_object),
		sound:	__ezConsole_dep_get_asset_names(asset_sound),
		font:	__ezConsole_dep_get_asset_names(asset_font),
		room:	__ezConsole_dep_get_asset_names(asset_room),
		script:	__ezConsole_dep_get_asset_names(asset_script),
	};
	
	switch (_type) {
		case ezConsole_type_sprite:		return _names.sprite;
		case ezConsole_type_object:		return _names.object;
		case ezConsole_type_sound:		return _names.sound;
		case ezConsole_type_font:		return _names.font;
		case ezConsole_type_room:		return _names.room;
		case ezConsole_type_script:		return _names.script;
		default:	return [];
	}
}

/// @func console_get_type_from_string(type_name)
/// @param	{str}	type_name
function console_get_type_from_string(_name) {
	switch (_name) {
		case "sprite":		return ezConsole_type_sprite;
		case "object":		return ezConsole_type_object;
		case "audio":		
		case "sound":		return ezConsole_type_sound;
		case "font":		return ezConsole_type_font;
		case "room":		return ezConsole_type_room;
		case "script":		return ezConsole_type_script;
		case "instance":	return ezConsole_type_instance;
		default:	return noone;
	}
}

/// @func	console_get_typeahead_icon(asset_index, asset_type)
/// @param	{real}	asset_index
/// @param	{real}	asset_type
function console_get_typeahead_icon(_index, _type) {
	switch (_type) {
		case asset_sprite:	return _index;
		case asset_object:	return (_index.sprite_index ? _index.sprite_index : s_ezConsole_icon_object);
		case asset_sound:	return s_ezConsole_icon_sound;
		case asset_font:	return s_ezConsole_icon_font;
		case asset_script:	return s_ezConsole_icon_script;
		case asset_room:	return s_ezConsole_icon_room;
		default:			return noone;
	}
}

/// @func	console_get_typeahead_asset_valid(asset_index)
/// @param	{real}	asset_index
function console_get_typeahead_asset_valid(_index) {
	var _type = asset_get_type(_index);
	switch (_type) {
		case asset_sprite:	
		case asset_object:	
		case asset_sound:	
		case asset_font:	
		case asset_script:	
		case asset_room:	return true;
		default:		return false;
	}
}