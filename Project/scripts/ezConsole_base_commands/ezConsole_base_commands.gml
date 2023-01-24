#region // Base commands
/// @function console_command_show(args)
/// @param	{array}	args
/// @desc	Show debug overlay
function console_command_show(_args) {
	var _command	= "show";
	var _params_len = array_length(_args);
	
	if (_params_len < 1) {
		// Not enough params
		var _not_enough_text = console_get_message(EZ_CONSOLE_MSG.NOT_ENOUGH_PARAMS, _command, _params_len, 1, 1);
		console_write_log(_not_enough_text, EZ_CONSOLE_MSG_TYPE.INFO);
	} else if (_params_len > 1) {
		// Too much params
		var _too_much_text = console_get_message(EZ_CONSOLE_MSG.TOO_MUCH_PARAMS, _command, _params_len, 1, 1);
		console_write_log(_too_much_text, EZ_CONSOLE_MSG_TYPE.INFO);
	} else {
		switch (_args[0]) {
			case "fps":
				__debug_console__.console_fps_show = true;
				console_write_log("FPS are now visible!", EZ_CONSOLE_MSG_TYPE.WARNING);
				break;
			
			case "overlay":
				show_debug_overlay(true);
				console_write_log("Debug overlay activated", EZ_CONSOLE_MSG_TYPE.WARNING);
				break;
				
			default:
				var _invalid_param = console_get_message(EZ_CONSOLE_MSG.INVALID_PARAM, _command, _params_len, 1, 1) + _args[0] + "\".";
				console_write_log(_invalid_param, EZ_CONSOLE_MSG_TYPE.ERROR);
				break;
		}	
	}
}

/// @function console_command_hide(args)
/// @param	{array}	args
/// @desc	Hide debug overlay
function console_command_hide(_args) {
	var _command	= "hide";
	var _params_len = array_length(_args);
	
	if (_params_len < 1) {
		// Not enough params
		var _not_enough_text = console_get_message(EZ_CONSOLE_MSG.NOT_ENOUGH_PARAMS, _command, _params_len, 1, 1);
		console_write_log(_not_enough_text, EZ_CONSOLE_MSG_TYPE.INFO);
	} else if (_params_len > 1) {
		// Too much params
		var _too_much_text = console_get_message(EZ_CONSOLE_MSG.TOO_MUCH_PARAMS, _command, _params_len, 1, 1);
		console_write_log(_too_much_text, EZ_CONSOLE_MSG_TYPE.INFO);
	} else {
		switch (_args[0]) {
			case "fps":
				__debug_console__.console_fps_show = false;
				console_write_log("FPS are now invisible!", EZ_CONSOLE_MSG_TYPE.WARNING);
				break;
				
			case "overlay":
				show_debug_overlay(false);
				console_write_log("Debug overlay deactivated", EZ_CONSOLE_MSG_TYPE.WARNING);
				break;
				
			default:
				var _invalid_param = console_get_message(EZ_CONSOLE_MSG.INVALID_PARAM, _command, _params_len, 1, 1) + _args[0] + "\".";
				console_write_log(_invalid_param, EZ_CONSOLE_MSG_TYPE.ERROR);
				break;
		}	
	}
}

/// @function console_command_message(args)
/// @param	{array}	args
/// @desc	Hide debug overlay
function console_command_message(_args) {
	var _command	= "message";
	var _params_len = array_length(_args);
	
	if (_params_len < 1) {
		// Not enough params
		var _not_enough_text = console_get_message(EZ_CONSOLE_MSG.NOT_ENOUGH_PARAMS, _command, _params_len, 1, 1);
		console_write_log(_not_enough_text, EZ_CONSOLE_MSG_TYPE.INFO);
	} else if (_params_len > 99) {
		// Too much params
		var _too_much_text = console_get_message(EZ_CONSOLE_MSG.TOO_MUCH_PARAMS, _command, _params_len, 1, 1);
		console_write_log(_too_much_text, EZ_CONSOLE_MSG_TYPE.INFO);
	} else {
		var _msg = "";
		for (var i = 0; i < _params_len; i++) {
			_msg += _args[i] + (i == _params_len - 1 ? "" : " ");
		}
		
		show_message(_msg);
	}
}

/// @function console_command_game(args)
/// @param	{array}	args
/// @desc	Hide debug overlay
function console_command_game(_args) {
	var _command	= "game";
	var _params_len = array_length(_args);
	
	if (_params_len < 1) {
		// Not enough params
		var _not_enough_text = console_get_message(EZ_CONSOLE_MSG.NOT_ENOUGH_PARAMS, _command, _params_len, 1, 1);
		console_write_log(_not_enough_text, EZ_CONSOLE_MSG_TYPE.INFO);
	} else if (_params_len > 1) {
		// Too much params
		var _too_much_text = console_get_message(EZ_CONSOLE_MSG.TOO_MUCH_PARAMS, _command, _params_len, 1, 1);
		console_write_log(_too_much_text, EZ_CONSOLE_MSG_TYPE.INFO);
	} else {
		switch (_args[0]) {
			case "restart":
			case "reset":
				game_restart();
				break;
				
			case "end":
				game_end();
				break;
				
			default:
				var _invalid_param = console_get_message(EZ_CONSOLE_MSG.INVALID_PARAM, _command, _params_len, 1, 1) + _args[0] + "\".";
				console_write_log(_invalid_param, EZ_CONSOLE_MSG_TYPE.ERROR);
				break;
		}	
	}
}

/// @function console_command_fullscreen(args)
/// @param	{array}	args
/// @desc	Hide debug overlay
function console_command_fullscreen(_args) {
	var _command	= "fullscreen";
	var _params_len = array_length(_args);
	
	if (_params_len < 1) {
		// Not enough params
		var _not_enough_text = console_get_message(EZ_CONSOLE_MSG.NOT_ENOUGH_PARAMS, _command, _params_len, 1, 1);
		console_write_log(_not_enough_text, EZ_CONSOLE_MSG_TYPE.INFO);
	} else if (_params_len > 1) {
		// Too much params
		var _too_much_text = console_get_message(EZ_CONSOLE_MSG.TOO_MUCH_PARAMS, _command, _params_len, 1, 1);
		console_write_log(_too_much_text, EZ_CONSOLE_MSG_TYPE.INFO);
	} else {
		switch (string_lower(_args[0])) {
			case "0":
			case "false":
				window_set_fullscreen(false);
				console_write_log("Fullscreen toggled OFF.", EZ_CONSOLE_MSG_TYPE.WARNING);
				break;
				
			case "1":
			case "true":
				window_set_fullscreen(true);
				console_write_log("Fullscreen toggled ON.", EZ_CONSOLE_MSG_TYPE.WARNING);
				break;
				
			default:
				var _invalid_param = console_get_message(EZ_CONSOLE_MSG.INVALID_PARAM, _command, _params_len, 1, 1) + _args[0] + "\".";
				console_write_log(_invalid_param, EZ_CONSOLE_MSG_TYPE.ERROR);
				break;
		}	
	}
}

/// @function console_command_help(args)
/// @param	{array}	args
/// @desc	Show help about commands
function console_command_help(_args) {
	var _command	= "help";
	var _params_len = array_length(_args);
	
	if (_params_len > 1) {
		// Too much params
		var _too_much_text = console_get_message(EZ_CONSOLE_MSG.TOO_MUCH_PARAMS, _command, _params_len, 0, 1);
		console_write_log(_too_much_text, EZ_CONSOLE_MSG_TYPE.INFO);
		return -1;
	}
	
	var _console_comands = global.__debug_console_commands;
	
	if (_params_len == 0) {
		// Show help text
		var _help_text = console_get_message(EZ_CONSOLE_MSG.HELP_MENU, _command);
		console_write_log(_help_text, EZ_CONSOLE_MSG_TYPE.INFO);
		
	
		// General help
		for (var i = 0; i < array_length(_console_comands); i++) {
			var _com_name = string_upper(_console_comands[i].name);
			var _com_shrt = string_upper(_console_comands[i].short);
			var _com_desc = _console_comands[i].desc;
			
			console_write_log(string_pad(_com_name, 12) + string_pad(_com_shrt, 8) + _com_desc, EZ_CONSOLE_MSG_TYPE.INFO);
		}
	} else if (_params_len == 1) {
		// First Checks if command exists
		var _command_exists = false;
		
		for (var i = 0; i < array_length(_console_comands); i++) {
			_command_exists = ( _console_comands[i].name == _args[0] || _console_comands[i].short == _args[0]
								? true
								: _command_exists );
		}
		
		if !(_command_exists) {
			var _command_doesnt_exists_text = console_get_message(EZ_CONSOLE_MSG.COMMAND_DOESNT_EXISTS, _args[0]);
			console_write_log(_command_doesnt_exists_text, EZ_CONSOLE_MSG_TYPE.ERROR);
			return -1;
		}
		
		
		// Command help
		var _com_name, _com_desc, _com_args;
		
		for (var i = 0; i < array_length(_console_comands); i++) {
			var _com_name = _console_comands[i].name;
			var _com_shrt = _console_comands[i].short;
			
			if (_com_name != _args[0] && _com_shrt != _args[0]) { continue; }
			
			_com_name = _com_name;
			_com_desc = _console_comands[i].desc;
			_com_args = _console_comands[i].args;			
			
			// Function
			var _com_args_str = "";
			for (var j = 0; j < array_length(_com_args); j++) {
				_com_args_str += _com_args[j] + "  ";
			}
			
			console_write_log(string_pad(_com_name, 12) + _com_args_str, EZ_CONSOLE_MSG_TYPE.WARNING);
			
			// Description
			console_write_log(_com_desc + "\n\n", EZ_CONSOLE_MSG_TYPE.INFO);
			
			// Arguments description
			var _com_args_val = _console_comands[i].values;
			console_write_log(_console_comands[0].args[0] + "   " + _console_comands[0].values[0], EZ_CONSOLE_MSG_TYPE.INFO);
			
			for (var j = 0; j < array_length(_com_args); j++) {
				
				console_write_log(string_pad(_com_args[j], 12) + _com_args_val[j], EZ_CONSOLE_MSG_TYPE.INFO);
			}
			
			return -1;
		}		
	}
}

/// @function console_command_create(args)
/// @param	{array}	args
/// @desc	Create an instance
function console_command_create(_args) {
	var _command	= "create";
	var _params_len = array_length(_args);
	
	if (_params_len < 1) {
		// Not enough params
		var _not_enough_text = console_get_message(EZ_CONSOLE_MSG.NOT_ENOUGH_PARAMS, _command, _params_len, 1, 4);
		console_write_log(_not_enough_text, EZ_CONSOLE_MSG_TYPE.INFO);
	} else if (_params_len > 4) {
		// Too much params
		var _too_much_text = console_get_message(EZ_CONSOLE_MSG.TOO_MUCH_PARAMS, _command, _params_len, 1, 4);
		console_write_log(_too_much_text, EZ_CONSOLE_MSG_TYPE.INFO);
	} else {
		var _asset = asset_get_index(_args[0]);
		
		try {
			var _x = ( _params_len > 1 ? real(_args[1]) : mouse_x );
			var _y = ( _params_len > 2 ? real(_args[2]) : mouse_y );
			var _depth = ( _params_len > 3 ? real(_args[3]) : -100 );
		} catch (e) {
			console_write_log(e.message, EZ_CONSOLE_MSG_TYPE.ERROR);
			return -1;
		}
		
		if (_asset == -1) {
			console_write_log("There's no object named \"" + _args[0] + "\"!", EZ_CONSOLE_MSG_TYPE.ERROR);
		} else {
			var _inst = instance_create_depth(_x, _y, _depth, _asset);
			console_write_log("Instance created with id " + string(_inst.id) + ".", EZ_CONSOLE_MSG_TYPE.INFO);
		}
	}
}

/// @function console_command_instances(args)
/// @param	{array}	args
/// @desc	Get all instances
function console_command_instances(_args) {
	var _command	= "instances";
	var _params_len = array_length(_args);
	
	if (_params_len > 1) {
		// Too much params
		var _too_much_text = console_get_message(EZ_CONSOLE_MSG.TOO_MUCH_PARAMS, _command, _params_len, 1, 4);
		console_write_log(_too_much_text, EZ_CONSOLE_MSG_TYPE.INFO);
	} else if (_params_len == 1) {
		// Get all instances of 1 specific object
		var _asset = asset_get_index(_args[0]);
		
		if (_asset == -1) {
			console_write_log("There's no object named \"" + _args[0] + "\"!", EZ_CONSOLE_MSG_TYPE.ERROR);
		} else {
			console_write_log(string_pad("NAME", 32) +
							  string_pad("ID", 16) +
							  string_pad("POSITION", 16) +
							  string_pad("DEPTH", 8),
							  EZ_CONSOLE_MSG_TYPE.INFO);
			
			var _inst, _name, _id, _pos, _depth;
			for (var i = 0; i < instance_number(_asset); i++) {
				_inst = instance_find(_asset, i);
				_name = string_pad(_args[0], 32);
				_id	  = string_pad(string(_inst.id), 16);
				_pos  = string_pad("(" + string(_inst.x) + ", " + string(_inst.y) + ")", 16);
				_depth= string_pad(string(_inst.depth), 8);
				
				console_write_log(_name + _id + _pos + _depth, EZ_CONSOLE_MSG_TYPE.INFO);
			}
		}
	} else if (_params_len == 0) {
		// Get all active instances
		console_write_log(	string_pad("NAME", 32) +
							string_pad("ID", 16) +
							string_pad("POSITION", 16) +
							string_pad("DEPTH", 8),
							EZ_CONSOLE_MSG_TYPE.INFO);
							  
		with (all) {
			var _name, _id, _pos, _depth;
			_name = string_pad(object_get_name(object_index), 32);
			_id	  = string_pad(string(id), 16);
			_pos  = string_pad("(" + string(x) + ", " + string(y) + ")", 16);
			_depth= string_pad(string(depth), 8);
			
			console_write_log(_name + _id + _pos + _depth, EZ_CONSOLE_MSG_TYPE.INFO);
		}
	}
}

#endregion