#region // Base commands
/// @func	console_command_base_message(args)
/// @param	{array}	args
/// @desc	Hide debug overlay
/// @ignore
function console_command_base_message(_args) {		
	show_message_async(_args[0]);
}

/// @func	console_command_base_game(args)
/// @param	{array}	args
/// @desc	Execute game actions
/// @ignore
function console_command_base_game(_args) {
	switch (_args[0]) {
		case "reset":
			game_restart();
			break;
				
		case "end":
			game_end();
			break;
				
		default:
			var _invalid_param = console_get_message(EZ_CONSOLE_MSG.INVALID_PARAM, "game", array_length(_args), 1, 1) + _args[0] + "\".";
			ezConsole_error(_invalid_param);
			break;
	}	
}

/// @func	console_command_base_fullscreen(args)
/// @param	{array}	args
/// @desc	Hide debug overlay
/// @ignore
function console_command_base_fullscreen(_args) {
	var _params_len = array_length(_args);
	if (_params_len == 0) {
		var _is_fullscreen = window_get_fullscreen();
		window_set_fullscreen(!_is_fullscreen);
		ezConsole_warn($"Fullscreen toggled {_is_fullscreen ? "OFF" : "ON"}");
		return;
	}
	
	switch (string_lower(_args[0])) {
		case "0":
		case "false":
			window_set_fullscreen(false);
			ezConsole_warn("Fullscreen toggled OFF.");
			with (ezConsole) {
				console_width	= ezConsole_skin_current[$ "width"] * __original_window_w;
				console_height	= ezConsole_skin_current[$ "height"] * __original_window_h;
				
				// The theme size is the resize floor, so it moves with the resolution.
				console_width_min	= console_width;
				console_height_min	= console_height;
			}
			console_surfaces_rebuild();
			break;
				
		case "1":
		case "true":
			window_set_fullscreen(true);
			ezConsole_warn("Fullscreen toggled ON.");
			with (ezConsole) {
				console_width	= ezConsole_skin_current[$ "width"] * display_get_width();
				console_height	= ezConsole_skin_current[$ "height"] * display_get_height();
				
				// The theme size is the resize floor, so it moves with the resolution.
				console_width_min	= console_width;
				console_height_min	= console_height;
			}
			console_surfaces_rebuild();
			break;
				
		default:
			static _command = "fullscreen";
			var _invalid_param = console_get_message(EZ_CONSOLE_MSG.INVALID_PARAM, _command, _params_len, 1, 1) + _args[0] + "\".";
			ezConsole_error(_invalid_param);
			break;
	}
}

/// @func	console_command_base_help(args)
/// @param	{array}	args
/// @desc	Show help about commands
/// @ignore
function console_command_base_help(_args) {
	static _command	= "help";
	var _params_len = array_length(_args);
	
	if (_params_len > 1) {
		// Too much params
		var _too_much_text = console_get_message(EZ_CONSOLE_MSG.TOO_MANY_PARAMS, _command, _params_len, 0, 1);
		ezConsole_info(_too_much_text);
		return -1;
	}
	
	var _console_comands = variable_clone(ezConsole_commands);
	
	array_sort(_console_comands, function (_elem_a, _elem_b) {
		return (_elem_a.name > _elem_b.name) - (_elem_a.name < _elem_b.name);
	})
	
	if (_params_len == 0) {
		var _help_text = console_get_message(EZ_CONSOLE_MSG.HELP_MENU, "help");
		var _console_commands_len = array_length(_console_comands);
		
		/*	Size the columns to the commands actually registered, so a long command name
			never runs into its alias. The console can be resized, so this cannot be
			cached in a `static`. */
		var _names = [];
		var _aliases = [];
		for (var i = 0; i < _console_commands_len; i++) {
			array_push(_names, _console_comands[i].name);
			array_push(_aliases, _console_comands[i].alias);
		}
		
		var _name_col	= console_get_column_width(_names, string_length("COMMAND"));
		var _alias_col	= console_get_column_width(_aliases, string_length("ALIAS"));
		
		ezConsole_warn(_help_text);
		console_write_table_header(["COMMAND", "ALIAS", "DESCRIPTION"], [_name_col, _alias_col]);
	
		// General help
		var _undefined_commands_detected = false;
		for (var i = 0; i < _console_commands_len; i++) {
			var _com_name = _console_comands[i].name;
			var _com_shrt = _console_comands[i].alias;
			var _com_desc = _console_comands[i].desc;
			
			if (is_undefined(_com_name) || is_undefined(_com_shrt) || is_undefined(_com_desc)) {
				_undefined_commands_detected = true;
				continue;
			}
			
			ezConsole_info(
				__ezConsole_dep_string_pad(_com_name, _name_col) +
				__ezConsole_dep_string_pad(_com_shrt, _alias_col) +
				_com_desc,
				true, false
			);
		}
		
		if (_undefined_commands_detected) {
			var _undefined_message = console_get_message(EZ_CONSOLE_MSG.UNDEFINED_COMMANDS_FOUND, _command);
			ezConsole_error(_undefined_message);
		}
	} else if (_params_len == 1) {
		// First Checks if command exists
		var _command_exists = false;
		var _commands_len = array_length(_console_comands);
		
		for (var i = 0; i < _commands_len; i++) {
			if (_command_exists) break;

			_command_exists = (
				_console_comands[i].name == _args[0] || _console_comands[i].alias == _args[0]
				? true
				: _command_exists
			);
		}
		
		if !(_command_exists) {
			var _command_doesnt_exists_text = console_get_message(EZ_CONSOLE_MSG.COMMAND_DOESNT_EXISTS, _args[0]);
			ezConsole_error(_command_doesnt_exists_text);
			return -1;
		}
		
		
		// Command help
		var _com_name, _com_shrt, _com_desc, _com_args;
		
		for (var i = 0; i < _commands_len; i++) {
			_com_name = _console_comands[i].name;
			_com_shrt = _console_comands[i].alias;
			
			if (_com_name != _args[0] && _com_shrt != _args[0]) continue;
			
			_com_name = _com_name;
			_com_desc = _console_comands[i].desc;
			_com_args = _console_comands[i].args;			
			
			// Function
			var _com_args_str = "";
			var _com_args_len = array_length(_com_args);
			for (var j = 0; j < _com_args_len; j++) {
				_com_args_str += _com_args[j] + "  ";
			}
			
			ezConsole_warn("> USAGE");
			ezConsole_info(_com_name + "  " + _com_args_str);
			
			if (_com_shrt != "") {
				ezConsole_info(_com_shrt + "  " + _com_args_str);
			}
			
			// Description
			ezConsole_warn("\n> DESCRIPTION");
			ezConsole_info(_com_desc);
			
			// Arguments description
			var _command_args_len = array_length(_com_args);
			if (_command_args_len > 0) {
				var _com_args_val	= _console_comands[i].args_desc;
				var _arg_col		= console_get_column_width(_com_args, string_length("ARGUMENT"));
				
				ezConsole_warn("\n> ARGUMENTS");
				console_write_table_header(["ARGUMENT", "DESCRIPTION"], [_arg_col]);
				
				for (var j = 0; j < _command_args_len; j++) {
					ezConsole_info(
						__ezConsole_dep_string_pad(_com_args[j], _arg_col) + _com_args_val[j],
						true, false
					);
				}
			}
			
			break;
		}		
	}
}

/// @func	console_command_base_create(args)
/// @param	{array}	args
/// @desc	Creates an instance
/// @ignore
function console_command_base_create(_args) {
	var _asset = asset_get_index(_args[0]);
	var _params_len = array_length(_args);
		
    var _x, _y, _depth;
    
	try {
		_x = ( _params_len > 1 ? real(_args[1]) : mouse_x );
		_y = ( _params_len > 2 ? real(_args[2]) : mouse_y );
		_depth = ( _params_len > 3 ? real(_args[3]) : -100 );
	} catch (e) {
		ezConsole_error(e.message);
		return -1;
	}
		
	if (_asset == -1) {
		ezConsole_error("There's no object named \"" + _args[0] + "\"!");
	} else {
		var _inst = instance_create_depth(_x, _y, _depth, _asset);
		ezConsole_info("Instance created with id " + string(_inst.id) + ".");
	}
}

/// @func	console_command_base_instances(args)
/// @param	{array}	args
/// @desc	Get all instances
/// @ignore
function console_command_base_instances(_args) {
	var _command	= "instances";
	var _params_len = array_length(_args);
	
	if (_params_len > 1) {
		// Too much params
		var _too_much_text = console_get_message(EZ_CONSOLE_MSG.TOO_MANY_PARAMS, _command, _params_len, 1, 1);
		ezConsole_info(_too_much_text);
	} else if (_params_len == 1) {
		// Get all instances of 1 specific object
		var _asset = asset_get_index(_args[0]);
		
		if (_asset == -1) {
			ezConsole_error("There's no object named \"" + _args[0] + "\"!");
		} else {
			var _rows = [];
			var _len = instance_number(_asset);
			
			for (var i = 0; i < _len; i++) {
				array_push(_rows, console_get_instance_row(instance_find(_asset, i)));
			}
			
			console_write_instance_table(_rows);
		}
	} else if (_params_len == 0) {
		// Get all active instances
		var _rows = [];
		
		with (all) {
			array_push(_rows, console_get_instance_row(id));
		}
		
		console_write_instance_table(_rows);
	}
}

/// @func	console_get_instance_row(instance)
/// @param	{any}	instance
/// @desc	One row of the `instances` table.
/// @ignore
function console_get_instance_row(_inst) {
	return {
		name:	object_get_name(_inst.object_index),
		id:		string_replace_all(string(_inst.id), "ref instance ", ""),
		pos:	$"({_inst.x}, {_inst.y})",
		depth:	string(_inst.depth),
	};
}

/// @func	console_write_instance_table(rows)
/// @param	{array}	rows
/// @desc	Writes a NAME / ID / POSITION / DEPTH table sized to its own contents.
/// @ignore
function console_write_instance_table(_rows) {
	var _len = array_length(_rows);
	var _names = [], _ids = [], _positions = [];
	
	for (var i = 0; i < _len; i++) {
		array_push(_names, _rows[i].name);
		array_push(_ids, _rows[i].id);
		array_push(_positions, _rows[i].pos);
	}
	
	var _name_col	= console_get_column_width(_names, string_length("NAME"));
	var _id_col		= console_get_column_width(_ids, string_length("ID"));
	var _pos_col	= console_get_column_width(_positions, string_length("POSITION"));
	
	console_write_table_header(["NAME", "ID", "POSITION", "DEPTH"], [_name_col, _id_col, _pos_col]);
	
	for (var i = 0; i < _len; i++) {
		ezConsole_info(
			__ezConsole_dep_string_pad(_rows[i].name, _name_col) +
			__ezConsole_dep_string_pad(_rows[i].id, _id_col) +
			__ezConsole_dep_string_pad(_rows[i].pos, _pos_col) +
			_rows[i].depth,
			true, false
		);
	}
}

/// @func	console_command_base_instance_set(args)
/// @param	{array}	args
/// @desc	Sets a variable on an instance or on `global`
/// @ignore
function console_command_base_instance_set(_args) {
	var _target_name	= _args[0];
	var _variable_name	= string(_args[1]);
	var _variable_value	= _args[2];
	
	var _target = console_get_target(_target_name);
	if (!_target.valid) {
		ezConsole_error($"\"{_target_name}\" is not an instance, an object with instances, or \"global\".");
		return;
	}
	
	/*	Writing a variable that does not exist yet creates it, which is how a new global or
		a new variable on an instance gets added from the console. There is no current value
		to take a type from, so the type is read off the argument itself. */
	if (!console_target_variable_exists(_target, _variable_name)) {
		var _new_value = console_arg_to_value(_variable_value);
		
		console_target_variable_set(_target, _variable_name, _new_value);
		ezConsole_info(
			$"Variable {_variable_name} created as {__ezConsole_dep_value_to_string(_new_value)} on {_target.name}.",
			false, false
		);
		return;
	}
	
	/*	Everything typed in the bar arrives as a string, so coerce it to whatever the
		variable already holds. Otherwise `set inst visible false` would store the string
		"false", which is truthy. */
	switch (typeof(console_target_variable_get(_target, _variable_name))) {
		case "number":
		case "int32":
		case "int64":
			try {
				_variable_value = real(_variable_value);
			} catch (_e) {
				ezConsole_error($"\"{_variable_value}\" is not a valid number for {_variable_name}.");
				return;
			}
			break;
		
		case "bool":
			_variable_value = console_arg_is_true(_variable_value);
			break;
	}
	
	console_target_variable_set(_target, _variable_name, _variable_value);
	ezConsole_info($"Variable {_variable_name} set as {_variable_value} on {_target.name}.", false, false);
}

/// @func	console_command_base_instance_get(args)
/// @param	{array}	args
/// @desc	Gets a variable, or every variable, from an instance or from `global`
/// @ignore
function console_command_base_instance_get(_args) {
	var _args_len		= array_length(_args);
	var _target_name	= _args[0];
	var _variable_name	= "";
	var _include_builtin = false;
	
	var _target = console_get_target(_target_name);
	if (!_target.valid) {
		ezConsole_error($"\"{_target_name}\" is not an instance, an object with instances, or \"global\".");
		return;
	}
	
	if (_args_len > 2) {
		// Both optionals given, in order: <include_builtin> <variable>
		_include_builtin	= console_arg_is_true(_args[1]);
		_variable_name		= string(_args[2]);
	} else if (_args_len > 1) {
		/*	Only one optional given. Empty arguments are stripped before a command runs, so
			there is no placeholder to skip the flag with: a `true`/`false` here is read as
			the flag, anything else as a variable name. A variable that really is called
			`true` still wins, because that is checked first. */
		var _second = string(_args[1]);
		
		if (console_arg_is_boolean(_second) && !console_target_variable_exists(_target, _second)) {
			_include_builtin = console_arg_is_true(_second);
		} else {
			_variable_name = _second;
		}
	}
	
	// A named variable is shown on its own, expanded in full.
	if (_variable_name != "") {
		if (!console_target_variable_exists(_target, _variable_name)) {
			ezConsole_error($"Variable {_variable_name} doesn't exists on {_target.name}");
			return;
		}
		
		var _name_col = console_get_column_width([_variable_name], string_length("VARIABLE NAME"));
		
		console_write_table_header(["VARIABLE NAME", "VALUE"], [_name_col]);
		ezConsole_info(
			__ezConsole_dep_string_pad(_variable_name, _name_col) +
			__ezConsole_dep_value_to_string(console_target_variable_get(_target, _variable_name)),
			true, false
		);
		return;
	}
	
	// `global` has no built-in variables to report, only declared ones.
	if (_include_builtin && !_target.is_global) {
		console_write_variable_table(
			_target,
			__ezConsole_dep_get_builtin_variable_names(),
			"BUILT-IN VARIABLE"
		);
		console_write_table_separator();
	}
	
	console_write_variable_table(
		_target,
		console_target_variable_names(_target),
		_target.is_global ? "GLOBAL VARIABLE" : "INSTANCE VARIABLE"
	);
}

/// @func	console_arg_is_boolean(value)
/// @param	{any}	value
/// @desc	Whether a command argument reads as a true/false flag.
/// @ignore
function console_arg_is_boolean(_value) {
	switch (string_lower(string(_value))) {
		case "true":
		case "false":
		case "1":
		case "0":	return true;
		default:	return false;
	}
}

/// @func	console_arg_is_numeric(value)
/// @param	{any}	value
/// @desc	Whether a command argument reads as a number, sign and decimal point included.
/// @ignore
function console_arg_is_numeric(_value) {
	var _string = string(_value);
	
	if (string_starts_with(_string, "-")) {
		_string = string_delete(_string, 1, 1);
	}
	
	if (_string == "") return false;
	if (string_count(".", _string) > 1) return false;
	
	var _digits = string_replace_all(_string, ".", "");
	return (_digits != "" && string_digits(_digits) == _digits);
}

/// @func	console_arg_to_value(value)
/// @param	{any}	value
/// @desc	Reads a command argument as the value it looks like: a boolean, a number, or the
///			string itself. Used when writing a variable that has no current type to match.
/// @ignore
function console_arg_to_value(_value) {
	var _string = string(_value);
	
	switch (string_lower(_string)) {
		case "true":	return true;
		case "false":	return false;
	}
	
	if (console_arg_is_numeric(_string)) {
		return real(_string);
	}
	
	return _string;
}

/// @func	console_arg_is_true(value)
/// @param	{any}	value
/// @desc	Reads a command argument as a boolean.
/// @ignore
function console_arg_is_true(_value) {
	var _flag = string_lower(string(_value));
	return (_flag == "true" || _flag == "1");
}

/// @func	console_write_variable_table(target, names, header)
/// @param	{struct}	target
/// @param	{array}		names
/// @param	{str}		header
/// @desc	Writes a name/value table for a resolved target to the console log.
/// @ignore
function console_write_variable_table(_target, _names, _header) {
	var _columns	= console_get_log_columns();
	var _names_len	= array_length(_names);
	
	// Follow the longest name, but always leave room for the value column.
	var _name_col = min(
		console_get_column_width(_names, string_length(_header)),
		max(16, _columns - 16)
	);
	
	console_write_table_header([_header, "VALUE"], [_name_col]);
	
	if (_names_len == 0) {
		ezConsole_info("(none)", true, false);
		return;
	}
	
	for (var i = 0; i < _names_len; i++) {
		/*	A built-in is not readable on every instance, and a declared variable can be
			removed between listing it and reading it, so never let one row abort the table. */
		try {
			var _value = console_target_variable_get(_target, _names[i]);
			
			// One row per variable: an array or struct is summarised, not expanded.
			ezConsole_info(
				__ezConsole_dep_string_pad(_names[i], _name_col) +
				__ezConsole_dep_value_to_string(_value, 0, 0),
				true, false
			);
		} catch (_e) {
			continue;
		}
	}
}

/// @func	console_command_base_instance_delete(args)
/// @param	{array}	args
/// @desc	Delete an instance
/// @ignore
function console_command_base_instance_delete(_args) {
	var _instance_id	= _args[0];
	var _exec_ev		= ( array_length(_args) > 1 ? _args[1] : "1" );
	
	_instance_id = array_last(string_split(_instance_id, ":"));
	
	if (_instance_id == "") {
		ezConsole_error("Instance id not valid doesn't exists");
	}
		
	var _inst_to_check = (
		string_digits(_instance_id) == _instance_id
		? _instance_id
		: asset_get_index(_instance_id)
	);

	if (_inst_to_check.object_index == __EzConsole__) {
		ezConsole_error("The ezConsole instance cannot be deleted!");
		return;
	}

	if (!instance_exists(_inst_to_check) || _inst_to_check == -1) {
		ezConsole_error("Instance " + _instance_id + " doesn't exists");
		return;
	}
		
	instance_destroy(_inst_to_check, _exec_ev == "1" || _exec_ev == "true");
	ezConsole_info($"Instance \"{_instance_id}\" destroyed.");
}

/// @func	console_command_base_clear(args)
/// @param	{array}	args
/// @desc	Clears console log
/// @ignore
function console_command_base_clear(_args) {
	with (ezConsole) {
		ds_list_clear(console_text_log);
		console_log_total_h = 0;
		console_nav_scroll = 0;
		console_log_copied_index = -1;
		console_log_copied_t = 0;
		console_surf_yoffset = 0;
		console_surf_yoffset_to = 0;
	}
		
	var _init_message = console_get_message(EZ_CONSOLE_MSG.INTIALIZATION, "");
	console_write_log(_init_message, EZ_CONSOLE_MSG_TYPE.WARNING);
}

/// @func	console_command_base_fps(args)
/// @param	{array}	args
/// @desc	Toggle or set and set FPS on screen
/// @ignore
function console_command_base_fps(_args) {
	var _args_len = array_length(_args);
	if (_args_len == 0) {
		ezConsole.console_fps_show = !ezConsole.console_fps_show;
		ezConsole_warn(
			$"FPS are now {( ezConsole.console_fps_show ? "visible" : "invisible" )}!"
		);
		return;
	}
	
	switch (_args[0]) {
		case "0":
		case "false":
			ezConsole.console_fps_show = false;
			ezConsole_warn("FPS are now invisible!");
			break;
					
		case "1":
		case "true":
			ezConsole.console_fps_show = true;
			ezConsole_warn("FPS are now visible!");
			break;
					
		default:
			var _invalid_param = console_get_message(EZ_CONSOLE_MSG.INVALID_PARAM, "fps", _args_len, 1, 1) + _args[1] + "\".";
			ezConsole_error(_invalid_param);
	}
}

/// @func	console_command_base_debug_overlay(args)
/// @param	{array}	args
/// @desc	Toggle or set and set debug overlay on screen
/// @ignore
function console_command_base_debug_overlay(_args) {
	if (array_length(_args) == 0) {
		ezConsole.console_debug_overlay_show = !ezConsole.console_debug_overlay_show;
		show_debug_overlay(ezConsole.console_debug_overlay_show);
		ezConsole_warn(string("Debug overlay is now {0}!", ( ezConsole.console_debug_overlay_show ? "visible" : "invisible" )));
	} else {
		switch (_args[0]) {
			case "0":
			case "false":
				ezConsole.console_debug_overlay_show = false;
				ezConsole_warn("Debug overlay is now invisible!");
				break;
					
			case "1":
			case "true":
				ezConsole.console_debug_overlay_show = true;
				ezConsole_warn("Debug overlay is now visible!");
				break;
					
			default:
				var _invalid_param = console_get_message(EZ_CONSOLE_MSG.INVALID_PARAM, "debug_view", array_length(_args), 1, 1) + _args[0] + "\".";
				ezConsole_error(_invalid_param);
		}
	}
}

/// @func	console_command_base_goto(args)
/// @param	{array}	args
/// @desc	Toggle or set and set debug overlay on screen
/// @ignore
function console_command_base_goto(_args) {
    var _room = asset_get_index(_args[0]);
    
    if (!_room || asset_get_type(_room) != asset_room) {
        ezConsole_error($"Room with name {_args[0]} does not exist!");
		return;
    }
    
    room_goto(_room);
}

/// @func	console_command_base_skin(args)
/// @param	{array}	args
/// @desc	Toggle or set and set debug overlay on screen
/// @ignore
function console_command_base_skin(_args) {
	var _args_len = array_length(_args);
	var _current_skin;
    
	switch (_args[0]) {
		case "set":
			_current_skin = struct_get(ezConsole_skin_list, ezConsole_skin_selected);
			
			if (_args_len < 3) {
				var _msg = console_get_message(EZ_CONSOLE_MSG.NOT_ENOUGH_PARAMS, "skin set", _args_len, 3, 3);
				console_write_log(_msg, EZ_CONSOLE_MSG_TYPE.ERROR);
				return;
			}
			
			if (!array_contains(console_get_skin_prop_names(), _args[1])) {
				console_write_log($"Prop \"{_args[1]}\" doesn't exists!", EZ_CONSOLE_MSG_TYPE.ERROR);
				return;
			}
			
			console_skin_set_prop(_args[1], _args[2]);
			console_write_log($"New value for prop \"{_args[1]}\": {_args[2]}", EZ_CONSOLE_MSG_TYPE.INFO);
			with (ezConsole) {
				event_user(1);
			}
			break;
					
		case "get":
			_current_skin = struct_get(ezConsole_skin_list, ezConsole_skin_selected);
			
			if (_args_len == 1) {
				var _json_str = _current_skin.toJSON();
				clipboard_set_text(_json_str);
				console_write_log("Console skin JSON copied to clipboard!", EZ_CONSOLE_MSG_TYPE.INFO);
			} else if (_args_len == 2) {
				var _current_param = struct_get(_current_skin, _args[1]);
				if (!is_undefined(_current_param)) {
					var _param_is_color = string_pos("color", _args[1]);
					console_write_log($"{_args[1]}: {_param_is_color ? __ezConsole_dep_dec_to_hex(_current_param) : _current_param}", EZ_CONSOLE_MSG_TYPE.INFO);
					return;
				}
				console_write_log($"Prop \"{_args[1]}\" doesn't exists!", EZ_CONSOLE_MSG_TYPE.ERROR);
			} else {
				var _msg = console_get_message(EZ_CONSOLE_MSG.TOO_MANY_PARAMS, "skin get", _args_len, 1, 2);
				console_write_log(_msg, EZ_CONSOLE_MSG_TYPE.ERROR);
			}
			break;
					
		default:
			var _invalid_param = console_get_message(EZ_CONSOLE_MSG.INVALID_PARAM, "skin", _args_len, 1, 1) + _args[0] + "\".";
			console_write_log(_invalid_param, EZ_CONSOLE_MSG_TYPE.ERROR);
	}
}

/// @func	console_command_base_version(args)
/// @param	{array}	args
/// @desc	Shows the console, runtime and platform versions
/// @ignore
function console_command_base_version(_args) {
    ezConsole_info(__ezConsole_dep_string_pad("EzConsole Version", 16) + string(ezConsole_version), false, false);
	ezConsole_info(__ezConsole_dep_string_pad("Game Version", 16) + string(GM_version), false, false);
	ezConsole_info(__ezConsole_dep_string_pad("Runtime", 16) + string(GM_runtime_version), false, false);
	ezConsole_info(__ezConsole_dep_string_pad("Platform", 16) + __ezConsole_dep_get_os_name(), false, false);
	
	if (os_browser != browser_not_a_browser) {
		ezConsole_info(__ezConsole_dep_string_pad("Browser", 16) + string(os_browser), false, false);
	}
	
	ezConsole_info(__ezConsole_dep_string_pad("Debug mode", 16) + (debug_mode ? "yes" : "no"), false, false);
	ezConsole_info(__ezConsole_dep_string_pad("Skin", 16) + string(ezConsole_skin_selected), false, false);
}

/// @func	console_command_base_log(args)
/// @param	{array}	args
/// @desc	Saves the console log to a file, or reads a saved one back in
/// @ignore
function console_command_base_log(_args) {
	static _command = "log";
	var _args_len	= array_length(_args);
	var _action		= string_lower(_args[0]);
	var _filename	= (_args_len > 1 ? _args[1] : "");
	
	switch (_action) {
		case "save":
			var _saved = console_save_log_to_file(_filename);
			
			if (is_undefined(_saved)) {
				ezConsole_error("The log file could not be written.");
				return;
			}
			
			ezConsole_info($"Log saved as \"{_saved}\" in {console_get_log_directory()}", false, false);
			break;
		
		case "load":
			if (_filename == "") {
				var _not_enough = console_get_message(EZ_CONSOLE_MSG.NOT_ENOUGH_PARAMS, $"{_command} load", _args_len, 2, 2);
				ezConsole_error(_not_enough);
				return;
			}
			
			var _normalised	= console_get_log_filename(_filename);
			var _lines		= console_load_log_from_file(_filename);
			
			if (_lines == -1) {
				ezConsole_error($"Log \"{_normalised}\" was not found in {console_get_log_directory()}");
				return;
			}
			
			ezConsole_info($"Loaded {_lines} line(s) from \"{_normalised}\".", false, false);
			break;
		
		default:
			var _invalid_param = console_get_message(EZ_CONSOLE_MSG.INVALID_PARAM, _command, _args_len, 1, 2) + _args[0] + "\".";
			ezConsole_error(_invalid_param);
			break;
	}
}

/// @func	console_command_base_play(args)
/// @param	{array}	args
/// @desc	Plays a sound asset once
/// @ignore
function console_command_base_play(_args) {
	var _args_len	= array_length(_args);
	var _sound_name	= _args[0];
	var _sound		= asset_get_index(_sound_name);
	
	if (_sound == -1 || asset_get_type(_sound_name) != asset_sound) {
		ezConsole_error($"Sound \"{_sound_name}\" doesn't exists.");
		return;
	}
	
	var _gain	= 1;
	var _pitch	= 1;
	
	if (_args_len > 1) {
		try {
			_gain = real(_args[1]);
		} catch (_e) {
			ezConsole_error($"\"{_args[1]}\" is not a valid volume. Use a value between 0 and 1.");
			return;
		}
	}
	
	if (_args_len > 2) {
		try {
			_pitch = real(_args[2]);
		} catch (_e) {
			ezConsole_error($"\"{_args[2]}\" is not a valid pitch. Use a value between 0.25 and 4.");
			return;
		}
	}
	
	_gain	= clamp(_gain, 0, 1);
	_pitch	= clamp(_pitch, .25, 4);
	
	var _playing = audio_play_sound(_sound, 100, false, _gain, 0, _pitch);
	
	if (_playing < 0) {
		ezConsole_error($"Sound \"{_sound_name}\" could not be played.");
		return;
	}
	
	ezConsole_info($"Playing \"{_sound_name}\" (volume {_gain}, pitch {_pitch}).", false, false);
}
#endregion
