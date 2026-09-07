#region // GET
/// @func	console_get_commands()
/// @desc	Retrieves the list of commands available in the console.
/// @ignore
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
/// @ignore
function console_get_message(_type, _command, _params_count=0, _min_params=0, _max_params=1) {
    switch (_type) {
        case EZ_CONSOLE_MSG.NOT_ENOUGH_PARAMS:
            return ("\"" + _command + "\" must receive at least " +
                    string(_min_params) + " argument(s).\n(" + string(_params_count) + " were given)");
        
        case EZ_CONSOLE_MSG.TOO_MANY_PARAMS:
            return ("\"" + _command + "\" must receive at most " +
                    string(_max_params) + " argument(s).\n(" + string(_params_count) + " were given)");
            
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
		
		case EZ_CONSOLE_MSG.UNDEFINED_COMMANDS_FOUND:
			return ($"Undefined commands found after executing \"{_command}\".\nPlease verify the integrity of your commands.");
    }
}

/// @func 	console_get_type_color(type)
/// @param	{real}    type
/// @desc	Retrieves the color associated with a message type.
/// @ignore
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
/// @ignore
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
/// @ignore
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
				var _arg_is_required = _command.args_req[i];
				_suggestion +=
					(i == _msg_trimmed_len - 1 ? "" : " ") +
					(!_arg_is_required ? $"[{_command.args[i]}]" : _command.args[i]);
			}
		}
	}
	
	return _suggestion;
}

/// @func 	console_get_typeahead(message)
/// @param	{str}    message
/// @desc	Provides auto-completion suggestions based on user input.
/// @ignore
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
			if (string_lower(_msg_trimmed[0]) == string_lower(string_copy(_command, 1, _msg_len)) && _msg_trimmed[0] != _command) {
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
				
				var _len = array_length(_names);
				var _option;
				for (var i = 0; i < _len; i++) {
					_option = _names[i];
					if (_arg == string_copy(_option, 1, _arg_len) && _arg != _option) {
						array_push(_suggestions, _option);
					}
				}
				
				return (array_length(_suggestions) == 0 && _arg_len < 1 ? _names : _suggestions);
			} else if (_arg_type == ezConsole_type_instance) {
				_names = array_create(256, undefined);
				var _count = 0;
				
				with (all) {
					if (_count >= 256) break;
					
					var _inst = object_get_name(object_index);
					if (_arg == string_copy(_inst, 1, _arg_len) && _arg != _inst) {
						_names[_count] =
							ezConsole_enable_typeahead_inst_ref
							? $"{_inst} ({string_replace(string(id), "instance ", "")})"
							: _inst;
						_count++;
					} else {
						var _inst_ref = string_split(string(id), " ");
						if (is_array(_inst_ref)) {
							_inst_ref = array_last(_inst_ref);
						}
						
						var _arg_ref = string_split(_arg, ":");
						if (is_array(_arg_ref)) {
							_arg_ref = array_last(_arg_ref);
						}
						
						var _arg_ref_len = string_length(_arg_ref);
						var _multiple_colons = string_count(":", _arg) > 1;
						if (!_multiple_colons && _arg_ref == string_copy(_inst_ref, 1, _arg_ref_len) && _arg_ref != _inst_ref) {
							_names[_count] = 
								ezConsole_enable_typeahead_inst_ref
								? $" {_inst} ({string_replace(string(id), "instance ", "")})"
								: $" _inst";
							_count++;
						}
					}
				}
				static _names_filter = function (_elem) {return _elem != undefined;};
				_names = array_filter(_names, _names_filter);
				array_sort(_names, true);
				return _names;
			}
			
			if (_arg_type == ezConsole_type_command) {
				// An argument that names another command, the way `help <command>` does.
				_names = [];
				for (var i = 0; i < _commands_len; i++) {
					if (is_string(_commands[i].name)) {
						array_push(_names, _commands[i].name);
					}
				}
				array_sort(_names, true);
				
				var _names_len = array_length(_names);
				for (var i = 0; i < _names_len; i++) {
					var _command_name = _names[i];
					if (_arg == string_copy(_command_name, 1, _arg_len) && _arg != _command_name) {
						array_push(_suggestions, _command_name);
					}
				}
				
				return (array_length(_suggestions) == 0 && _arg_len < 1 ? _names : _suggestions);
			}
			
			if (_arg_type == ezConsole_type_target_var) {
				/*	Variable-name suggestions are offered for `global` only. An instance's
					variable list is long, changes constantly, and is rarely worth
					scrolling, so the first argument decides whether to suggest at all. */
				if (_msg_trimmed_len < 3 || string_lower(_msg_trimmed[1]) != "global") {
					return _suggestions;
				}
				
				_names = console_target_variable_names(console_get_target("global"));
				
				var _globals_len = array_length(_names);
				for (var i = 0; i < _globals_len; i++) {
					var _global_name = _names[i];
					if (_arg == string_copy(_global_name, 1, _arg_len) && _arg != _global_name) {
						array_push(_suggestions, _global_name);
					}
				}
				
				return (array_length(_suggestions) == 0 && _arg_len < 1 ? _names : _suggestions);
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
/// @ignore
function console_add_command(_cmd) {
    array_push(ezConsole_commands, _cmd);
}

/// @func 	   console_add_commands_from_file(filepath)
/// @param	{str}    filepath
/// @desc	Adds commands from a file to the console.
/// @ignore
function console_add_commands_from_file(_path) {
	if (!file_exists(_path)) {
		show_debug_message($"(EzConsole) ERROR! - File \"{_path}\" not found!");
		return;
	}
	
	var _file = file_text_open_read(_path);
	var _json = __ezConsole_dep_file_to_json(_file);
	var _json_len = array_length(_json);
	
	for (var i = 0; i < _json_len; i++) {
		var _cmd = _json[i];
		var _args = [];
		var _args_len = array_length(_cmd.args);
		
		for (var j = 0; j < _args_len; j++) {
			var _new_arg;
			if (_cmd.args[j].type != "option") {
				_new_arg = new EzConsoleCommandArgument( 
					_cmd.args[j].name, 
					_cmd.args[j].desc, 
					_cmd.args[j].required,
					console_get_type_from_string(_cmd.args[j].type)
				);
			} else {
				_new_arg = new EzConsoleCommandArgumentWithOptions(
					_cmd.args[j].name,
					_cmd.args[j].desc,
					_cmd.args[j].required,
					_cmd.args[j].options
				);
			}
			
			array_push(_args, _new_arg);
		}
		
		new EzConsoleCommand(_cmd.name, _cmd.alias, _cmd.desc, asset_get_index(_cmd.callback), _args);
	}
	
	file_text_close(_file);
}
#endregion

#region // Write on console log logic
/// @func 	console_write_log(message, type, clear_input)
/// @param	{str}	message
/// @param	{real}	type
/// @param	{bool}	clear_input
/// @desc	Writes messages to the console log.
///			`clear_input` empties the input bar, which is what a command that was
///			just submitted wants. Logs triggered by anything else (a resize, a
///			background system) should pass `false` so they don't eat what the user
///			is currently typing.
/// @ignore
function console_write_log(_msg, _type = EZ_CONSOLE_MSG_TYPE.COMMON, _clear_input = true) {
	with (ezConsole) {
		if (script_exists(ezConsole_callback_onLog)) {
			script_execute(ezConsole_callback_onLog);
		}
		
		var _new_msg = new EzConsoleLog(_msg, _type);
		ds_list_add(console_text_log, _new_msg);
	
		if (_clear_input) {
			keyboard_string		= "";
			console_text_actual	= "";
			console_nav_hor		= 0;
		}
		
		console_nav_scroll = ds_list_size(console_text_log);
		event_user(0);
	}
}
#endregion

/// @func 	console_check_command(message)
/// @param	{str}	message
/// @desc	Checks if the provided message is a valid console command.
/// @ignore
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
			_str_param += string_delete(_params[i], string_length(_params[i]), 1);
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
	
	// Remove multiple spaces
	while (string_pos("  ", console_text_actual)) {
		console_text_actual = string_replace_all(console_text_actual, "  ", " ");
	}
	console_text_actual = string_trim_end(console_text_actual);
	
	console_write_log(console_text_actual);
	
	static _commands = console_get_commands();
	static _commands_len = array_length(_commands);
	for (var i = 0; i < _commands_len; i++) {
		if (_commands[i].name == _command || (_commands[i].alias == _command && _commands[i].alias != "-")) {
			if (_commands[i].callback != -1) {
				var _args_len = array_length(_params);
				for (var j = 0; j < _args_len; j++) {
					if (j > array_length(_commands[i].args_type) - 1) break;
					if (_commands[i].args_type[j] == ezConsole_type_instance) {
						var _inst_ref = string_split(_params[j], ":");
						if (!is_array(_inst_ref) || array_length(_inst_ref) < 2) continue;
						
						_inst_ref = array_last(_inst_ref);
						if (_inst_ref == "") continue;
						
						var _inst_id = string_digits(_inst_ref);
						if (_inst_id == "") {
							ezConsole_error("Malformed instance_id or not found!");
							return;
						}
						
						var _instance = instance_find(_inst_id, 0);
						
						if (_instance) {
							_params[j] = _instance;
							continue;
						}
						
						_params[j] = "<undefined>";
					}
				}
				console_command_execute(_commands[i], _params);
				return;
			} else {
				var _non_existing_callback = console_get_message(EZ_CONSOLE_MSG.CALLBACK_DOESNT_EXISTS, _command);
				console_write_log(_non_existing_callback, EZ_CONSOLE_MSG_TYPE.ERROR);
				return;
			}
		}
	}
	
	var _not_found_text = console_get_message(EZ_CONSOLE_MSG.COMMAND_DOESNT_EXISTS, _command);
	console_write_log(_not_found_text, EZ_CONSOLE_MSG_TYPE.INFO);
}

/// @func 	console_check_params_count(command, params_len, min_params, max_params)
/// @param	{str}	command
/// @param	{real}	params_len
/// @param	{real}	min_params
/// @param	{real}	max_params
/// @desc	Checks if the number of parameters in a command is within the expected range.
/// @ignore
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
	
/// @func 	console_save_log_to_file([filename])
/// @param	{str}	[filename]
/// @desc	Saves the console log to a text file in the platform's save area.
///			Returns the filename that was written, or `undefined` on failure.
function console_save_log_to_file(_filename = undefined) {
	if (!ezConsole) return undefined;
	
	if (is_undefined(_filename) || _filename == "") {
		_filename = $"ezConsole_log_{__ezConsole_dep_datetime_stamp()}.txt";
	}
	
	_filename = console_get_log_filename(_filename);
	
	var _file = file_text_open_write(_filename);
	if (_file == -1) return undefined;
	
	with (ezConsole) {
		var _logs = console_text_log;
		var _logs_len = ds_list_size(_logs);
		for (var i = 0; i < _logs_len; i++) {
			file_text_write_string(_file, _logs[| i].timestamp + " " + _logs[| i].message + "\n");
		}
	}
	
	file_text_close(_file);
	return _filename;
}

/// @func 	console_load_log_from_file(filename)
/// @param	{str}	filename
/// @desc	Reads a saved log file back into the console. Returns how many lines were read,
///			or -1 if the file could not be opened.
function console_load_log_from_file(_filename) {
	_filename = console_get_log_filename(_filename);
	
	if (!file_exists(_filename)) return -1;
	
	var _file = file_text_open_read(_filename);
	if (_file == -1) return -1;
	
	var _lines = 0;
	while (!file_text_eof(_file)) {
		var _line = file_text_read_string(_file);
		file_text_readln(_file);
		
		if (_line != "") {
			console_write_log(_line, EZ_CONSOLE_MSG_TYPE.INFO, false);
			_lines++;
		}
	}
	
	file_text_close(_file);
	return _lines;
}

/// @func 	console_get_log_filename(filename)
/// @param	{str}	filename
/// @desc	Normalises a log filename: drops any directory part so the file always stays in
///			the sandboxed save area, and defaults the extension to `.txt`.
/// @ignore
function console_get_log_filename(_filename) {
	_filename = filename_name(string(_filename));
	
	if (filename_ext(_filename) == "") {
		_filename += ".txt";
	}
	
	return _filename;
}

/// @func 	console_get_log_directory()
/// @desc	Readable location of the sandboxed save area that log files are written to.
///			A relative filename given to `file_text_open_write` already lands there on every
///			platform, so only the label shown to the user changes.
function console_get_log_directory() {
	if (os_browser != browser_not_a_browser) {
		return "the browser's local storage";
	}
	
	if (is_string(game_save_id) && game_save_id != "") {
		return game_save_id;
	}
	
	return working_directory;
}

/// @func 	console_get_log_columns()
/// @desc	How many characters fit on one line of the log at the current console size.
///			Tables size themselves from this so they grow with the console instead of
///			assuming a fixed 80 columns. Assumes the skin font is monospaced, which the
///			bundled fonts are.
/// @ignore
function console_get_log_columns() {
	static _fallback = 80;
	if (!ezConsole) return _fallback;
	
	var _columns = _fallback;
	
	with (ezConsole) {
		draw_set_font(console_text_font);
		var _char_w = string_width("M");
		
		if (_char_w > 0) {
			// Log messages wrap at the console width minus the padding on both sides.
			_columns = floor((console_width - (2 * console_log_xpad)) / _char_w);
		}
	}
	
	return max(24, _columns);
}

/// @func 	console_get_column_width(values, [minimum])
/// @param	{array}	values
/// @param	{real}	[minimum]
/// @desc	Width of a column that fits every value in `values`, never narrower than
///			`minimum`, plus two characters of gutter.
/// @ignore
function console_get_column_width(_values, _minimum = 0) {
	var _len = array_length(_values);
	var _widest = _minimum;
	
	for (var i = 0; i < _len; i++) {
		_widest = max(_widest, string_length(string(_values[i])));
	}
	
	return _widest + 2;
}

/// @func 	console_write_table_header(headers, widths)
/// @param	{array}	headers
/// @param	{array}	widths
/// @desc	Writes a table header row followed by a divider spanning the console width.
///			The last header needs no width, it runs to the end of the line.
/// @ignore
function console_write_table_header(_headers, _widths) {
	var _len = array_length(_headers);
	var _row = "";
	
	for (var i = 0; i < _len; i++) {
		_row += (
			i >= array_length(_widths)
			? _headers[i]
			: __ezConsole_dep_string_pad(_headers[i], _widths[i])
		);
	}
	
	ezConsole_info(_row, true, false);
	ezConsole_info(string_repeat("-", console_get_log_columns()), true, false);
}

/// @func 	console_write_table_separator()
/// @desc	Writes a heavier divider, used between two tables in the same output.
/// @ignore
function console_write_table_separator() {
	ezConsole_info(string_repeat("=", console_get_log_columns()), true, false);
}

/// @func 	console_get_target(target)
/// @param	{str}	target
/// @desc	Resolves a command argument into something whose variables can be read or written.
///			Accepts an instance id, an object name, an `object_name:ref` type-ahead entry, or
///			the literal `global`. Returns a struct with `valid`, `is_global`, `ref` and `name`.
/// @ignore
function console_get_target(_target) {
	var _result = {
		valid:		false,
		is_global:	false,
		ref:		noone,
		name:		string(_target),
	};
	
	/*	console_check_command() already converts an argument declared as
		`ezConsole_type_instance` into a real instance reference whenever it contains a
		`:`, so the callback can receive it pre-resolved instead of as a string. */
	if (!is_string(_target)) {
		if (instance_exists(_target)) {
			_result.valid	= true;
			_result.ref		= _target;
			_result.name	= $"{object_get_name(_target.object_index)}:{_target.id}";
		}
		
		return _result;
	}
	
	if (string_lower(_target) == "global") {
		_result.valid		= true;
		_result.is_global	= true;
		_result.name		= "global";
		return _result;
	}
	
	// The type-ahead writes instance references as `object_name:ref`, so keep the ref only.
	var _id = array_last(string_split(_target, ":"));
	if (_id == "") return _result;
	
	var _ref = (string_digits(_id) == _id ? real(_id) : asset_get_index(_id));
	if (_ref == -1 || !instance_exists(_ref)) return _result;
	
	_result.valid	= true;
	_result.ref		= _ref;
	return _result;
}

/// @func 	console_target_variable_names(target)
/// @param	{struct}	target
/// @desc	Sorted names of the variables declared on a resolved target.
/// @ignore
function console_target_variable_names(_target) {
	if (!_target.is_global) {
		var _instance_names = variable_instance_get_names(_target.ref);
		array_sort(_instance_names, true);
		return _instance_names;
	}
	
	/*	There is no `variable_global_get_names()` in GML: globals are listed by handing the
		`global` scope to variable_instance_get_names(). That scope also holds every script
		function in the project plus a few runtime internals, none of which are global
		variables anyone set, so they are filtered out here. */
	var _all		= variable_instance_get_names(global);
	var _all_len	= array_length(_all);
	var _names		= [];
	
	for (var i = 0; i < _all_len; i++) {
		var _name = _all[i];
		
		// Runtime internals, and EzConsole's own globals.
		if (string_pos("@@", _name) || string_pos("___struct___", _name)) continue;
		if (string_pos("__ezConsole_", _name) == 1) continue;
		
		// Script functions live in global scope, but they are not variables.
		if (is_method(variable_global_get(_name))) continue;
		
		array_push(_names, _name);
	}
	
	array_sort(_names, true);
	return _names;
}

/// @func 	console_target_variable_exists(target, variable)
/// @param	{struct}	target
/// @param	{str}		variable
/// @ignore
function console_target_variable_exists(_target, _variable) {
	return (
		_target.is_global
		? variable_global_exists(_variable)
		: variable_instance_exists(_target.ref, _variable)
	);
}

/// @func 	console_target_variable_get(target, variable)
/// @param	{struct}	target
/// @param	{str}		variable
/// @ignore
function console_target_variable_get(_target, _variable) {
	return (
		_target.is_global
		? variable_global_get(_variable)
		: variable_instance_get(_target.ref, _variable)
	);
}

/// @func 	console_target_variable_set(target, variable, value)
/// @param	{struct}	target
/// @param	{str}		variable
/// @param	{any}		value
/// @ignore
function console_target_variable_set(_target, _variable, _value) {
	if (_target.is_global) {
		variable_global_set(_variable, _value);
		return;
	}
	
	variable_instance_set(_target.ref, _variable, _value);
}

/// @func 	console_release_cursor()
/// @desc	Hands the mouse cursor back, but only if the console was the one that changed it.
/// @ignore
function console_release_cursor() {
	if (!ezConsole) return;
	
	with (ezConsole) {
		if (!variable_instance_exists(id, "console_cursor_owned") || !console_cursor_owned) return;
		window_set_cursor(ezConsole_prop_cursor_default);
		console_cursor_owned = false;
	}
}

/// @func 	console_surfaces_rebuild()
/// @desc	Frees the console surfaces so they get rebuilt at the current console size.
///			Must be called after anything that changes console_width / console_height.
/// @ignore
function console_surfaces_rebuild() {
	if (!ezConsole) return;
	
	with (ezConsole) {
		if (variable_instance_exists(id, "console_surf") && surface_exists(console_surf)) {
			surface_free(console_surf);
		}
		console_surf = -1;
		
		if (variable_instance_exists(id, "console_blur_surf") && surface_exists(console_blur_surf)) {
			surface_free(console_blur_surf);
		}
		console_blur_surf = -1;
		
		if (variable_instance_exists(id, "console_bar_surf") && surface_exists(console_bar_surf)) {
			surface_free(console_bar_surf);
		}
		console_bar_surf = -1;
		
		// Log height depends on the surface size, so it has to be measured again.
		if (variable_instance_exists(id, "console_text_log") && ds_exists(console_text_log, ds_type_list)) {
			event_user(0);
			console_surf_yoffset_to	= clamp(console_surf_yoffset_to, 0, max(0, console_log_total_h));
			console_surf_yoffset	= console_surf_yoffset_to;
		}
	}
}

/// @func 	console_position_set_by_anchor(anchor)
/// @param	{real}	anchor
/// @desc	Sets the console position based on the anchor point.
/// @ignore
function console_position_set_by_anchor(_anchor) {
	if (!ezConsole) return;
	var _x, _y;
	switch (_anchor) {
		case EZ_CONSOLE_ANCHOR.TOP_LEFT:
			_x = 0;
			_y = 0;
			break;
		
		case EZ_CONSOLE_ANCHOR.TOP_RIGHT:
			_x = ezConsole.__original_window_w - ezConsole.console_width;
			_y = 0;
			break;
		
		case EZ_CONSOLE_ANCHOR.BOTTOM_LEFT:
			_x = 0;
			_y = ezConsole.__original_window_h - ezConsole.console_height;
			break;
			
		case EZ_CONSOLE_ANCHOR.BOTTOM_RIGHT:
			_x = ezConsole.__original_window_w - ezConsole.console_width;
			_y = ezConsole.__original_window_h - ezConsole.console_height;
			break;
		
		case EZ_CONSOLE_ANCHOR.NONE:
			_x = ezConsole.__original_window_w / 2 - ezConsole.console_width / 2;
			_y = ezConsole.__original_window_h / 2 - ezConsole.console_height / 2;
			break;
		
		default:
			if (is_array(_anchor)) {
				_x = _anchor[0];
				_y = _anchor[1];
			}
			break;
	}
	
	ezConsole.console_x = _x;
	ezConsole.console_y = _y;
}

/// @func	console_command_execute(command, args_given)
/// @param	{any}	command
/// @param	{array}	args_given
/// @ignore
function console_command_execute(_cmd, _args_given) {
	static _args_given_filter = function (_elem) { return _elem != "" };
	_args_given = array_filter(_args_given, _args_given_filter);
	
	if (console_check_params_count(_cmd.name, array_length(_args_given), _cmd.args_min, _cmd.args_max)) {
		script_execute(_cmd.callback, _args_given);
	}
}

/// @func	console_typeahead_get_names(ezConsole_type)
/// @param	{real}	ezConsole_type
/// @desc	Retrieves a list of names for type-ahead suggestions based on asset type.
/// @ignore
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
/// @ignore
function console_get_type_from_string(_name) {
	switch (_name) {
		case "sprite":		return ezConsole_type_sprite;
		case "object":		return ezConsole_type_object;
		case "audio":		
		case "sound":		return ezConsole_type_sound;
		case "font":		return ezConsole_type_font;
		case "room":		return ezConsole_type_room;
		case "script":		return ezConsole_type_script;
		case "inst":
		case "instance":	return ezConsole_type_instance;
		case "variable":
		case "target_var":	return ezConsole_type_target_var;
		case "command":		return ezConsole_type_command;
		default:	return noone;
	}
}

/// @func	console_get_typeahead_icon(asset_index, asset_type)
/// @param	{real}	asset_index
/// @param	{real}	asset_type
/// @ignore
function console_get_typeahead_icon(_index, _type) {
	switch (_type) {
		case asset_sprite:	return _index;
		case asset_object:
			var _obj_spr = object_get_sprite(_index);
			return (_obj_spr ? _obj_spr : s_ezConsole_icon_object);
		case asset_sound:	return s_ezConsole_icon_sound;
		case asset_font:	return s_ezConsole_icon_font;
		case asset_script:	return s_ezConsole_icon_script;
		case asset_room:	return s_ezConsole_icon_room;
		default:			return noone;
	}
}

/// @func	console_get_typeahead_asset_valid(asset_index)
/// @param	{real}	asset_index
/// @ignore
function console_get_typeahead_asset_valid(_index) {
	var _type = asset_get_type(_index);
	switch (_type) {
		case asset_sprite:	
		case asset_object:	
		case asset_sound:	
		case asset_font:	
		case asset_script:	
		case asset_room:	return true;
		default:			return false;
	}
}