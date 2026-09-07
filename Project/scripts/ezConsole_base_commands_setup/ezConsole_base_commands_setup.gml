call_later(1, time_source_units_frames, function () {
	new EzConsoleCommand(
		"message",
		"msg",
		"Shows a message on screen.",
		console_command_base_message,
		[
			new EzConsoleCommandArgument("text", "Message to show", true),
		]
	);
	
	new EzConsoleCommand(
		"fullscreen",
		"fs",
		"Toggle fullscreen.",
		console_command_base_fullscreen,
		[
			new EzConsoleCommandArgumentWithOptions(
				"active",
				"Can take values \"false\" or \"true\" (\"0\" or \"1\" are also valid).",
				false,
				["true", "false"]
			),
		]
	);
	
	new EzConsoleCommand(
		"game",
		"gm",
		"Choose to end or restart the game.",
		console_command_base_game,
		[
			new EzConsoleCommandArgumentWithOptions(
				"method",
				"Can take values \"end\" & \"reset\".",
				true,
				["end", "reset"]
			),
		]
	);
	
	new EzConsoleCommand(
		"help", "",
		"Show help about commands.",
		console_command_base_help,
		[
			new EzConsoleCommandArgument(
				"command",
				"Command to search help for.",
				false,
				ezConsole_type_command
			),
		]
	);
	
	new EzConsoleCommand(
		"create", "",
		"Creates an instance on position.",
		console_command_base_create,
		[
			new EzConsoleCommandArgument(
				"object_name",
				"name of the object.",
				true,
				ezConsole_type_object
			),
			new EzConsoleCommandArgument(
				"x",
				"x position of the instance. (mouse_x as default)",
				false
			),
			new EzConsoleCommandArgument(
				"y",
				"y position of the instance. (mouse_y as default)",
				false
			),
			new EzConsoleCommandArgument(
				"depth",
				"Depth of the instance. (-100 as default)",
				false
			),
		]
	);
	
	new EzConsoleCommand(
		"instances",
		"inst",
		"Get all active instances from an object.",
		console_command_base_instances,
		[
			new EzConsoleCommandArgument(
				"object_name",
				"Name of the object.",
				false,
				ezConsole_type_object
			),
		]
	);
	
	new EzConsoleCommand(
		"set", "",
		"Set a variable on an instance or on \"global\", creating it if it does not exist.",
		console_command_base_instance_set,
		[
			new EzConsoleCommandArgument(
				"instance_id",
				"Instance to modify. Accepts \"global\" to modify a global variable instead.",
				true,
				ezConsole_type_instance
			),
			new EzConsoleCommandArgument(
				"variable",
				"Variable to modify. It is created when it does not exist yet.",
				true,
				ezConsole_type_target_var
			),
			new EzConsoleCommandArgument(
				"value",
				"New value to set.",
				true
			),
		]
	);
	
	new EzConsoleCommand(
		"get", "",
		"Get one variable, or every variable, from an instance or from \"global\".",
		console_command_base_instance_get,
		[
			new EzConsoleCommandArgument(
				"instance_id",
				"Instance to read from. Accepts \"global\" to read global variables instead.",
				true,
				ezConsole_type_instance
			),
			new EzConsoleCommandArgumentWithOptions(
				"include_builtin",
				"Also list the built-in instance variables. (\"false\" as default)",
				false,
				["true", "false"]
			),
			new EzConsoleCommandArgument(
				"variable",
				"Variable to read. Every variable is listed when this is left out.",
				false,
				ezConsole_type_target_var
			),
		]
	);
	
	new EzConsoleCommand(
		"delete",
		"del",
		"Delete an instance",
		console_command_base_instance_delete,
		[
			new EzConsoleCommandArgument(
				"instance_id",
				"Instance to delete.",
				true,
				ezConsole_type_instance
			),
		]
	);
	
	new EzConsoleCommand(
		"clear",
		"cls",
		"Clears the console logs.",
		console_command_base_clear
	);
	
	new EzConsoleCommand(
		"fps", "",
		"Show FPS on screen.",
		console_command_base_fps,
		[
			new EzConsoleCommandArgumentWithOptions(
				"active",
				"Can take values \"false\" or \"true\" (\"0\" or \"1\" are also valid).",
				false,
				["true", "false"]
			),
		]
	);
	
	new EzConsoleCommand(
		"debug_view", "",
		"Enables the debug view.",
		console_command_base_debug_overlay,
		[
			new EzConsoleCommandArgumentWithOptions(
				"active",
				"Can take values \"false\" or \"true\" (\"0\" or \"1\" are also valid).",
				false,
				["true", "false"]
			),
		]
	);
	
	new EzConsoleCommand(
		"goto", "",
		"Go to a new room.",
		console_command_base_goto,
		[
			new EzConsoleCommandArgument("room", "Room Name", true, ezConsole_type_room),
		]
	);
	
	new EzConsoleCommand(
		"version",
		"ver",
		"Show the console, runtime and platform versions.",
		console_command_base_version
	);
	
	new EzConsoleCommand(
		"log", "",
		"Save the console log to a file, or read a saved one back in.",
		console_command_base_log,
		[
			new EzConsoleCommandArgumentWithOptions(
				"action",
				"Can take values \"save\" or \"load\".",
				true,
				["save", "load"]
			),
			new EzConsoleCommandArgument(
				"filename",
				"Name of the log file. Generated from the current date and time when saving without one.",
				false
			),
		]
	);
	
	new EzConsoleCommand(
		"play", "",
		"Play a sound once.",
		console_command_base_play,
		[
			new EzConsoleCommandArgument(
				"sound",
				"Name of the sound asset.",
				true,
				ezConsole_type_sound
			),
			new EzConsoleCommandArgument(
				"volume",
				"Volume between 0 and 1. (1 as default)",
				false
			),
			new EzConsoleCommandArgument(
				"pitch",
				"Pitch between 0.25 and 4. (1 as default)",
				false
			),
		]
	);
});