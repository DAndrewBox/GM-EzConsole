call_later(1, time_source_units_frames, function () {
	new EzConsoleCommand(
		"message",
		"msg",
		"Shows a message and pauses the game.",
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
		"help",,
		"Show help about commands.",
		console_command_base_help,
		[
			new EzConsoleCommandArgument(
				"command",
				"Command to search help for.",
				false
			),
		]
	);
	
	new EzConsoleCommand(
		"create",,
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
		"set",,
		"Set a new value to a variable on an instance",
		console_command_base_instance_set,
		[
			new EzConsoleCommandArgument(
				"instance_id",
				"Instance to modify.",
				true,
				ezConsole_type_instance
			),
			new EzConsoleCommandArgument(
				"variable",
				"Variable to modify.",
				true
			),
			new EzConsoleCommandArgument(
				"value",
				"New value to set.",
				true
			),
		]
	);
	
	new EzConsoleCommand(
		"get",,
		"Get the value of a variable on an instance",
		console_command_base_instance_get,
		[
			new EzConsoleCommandArgument(
				"instance_id",
				"Instance to get the value from.",
				true,
				ezConsole_type_instance
			),
			new EzConsoleCommandArgument(
				"variable",
				"Variable to get the value from.",
				true
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
		"fps",,
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
		"debug_view",,
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
		"goto",,
		"Go to a new room.",
		console_command_base_goto,
		[
			new EzConsoleCommandArgument("room", "Room Name", true, ezConsole_type_room),
		]
	);
});