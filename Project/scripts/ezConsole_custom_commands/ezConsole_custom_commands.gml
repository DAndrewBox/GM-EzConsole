call_later(1, time_source_units_frames, function () {
	#region // Add yor custom commands functions logic below

	#endregion

	#region // Use `new EzConsoleCommand()` below		
	new EzConsoleCommand(
		"types",,
		"Check types",
		function (_args) {
			show_message(_args);
		},
		[
			new EzConsoleCommandArgument("sprite", "", true, ezConsole_type_sprite),
			new EzConsoleCommandArgument("object", "", true, ezConsole_type_object),
			new EzConsoleCommandArgument("sound", "", true, ezConsole_type_sound),
			new EzConsoleCommandArgument("font", "", true, ezConsole_type_font),
			new EzConsoleCommandArgument("room", "", true, ezConsole_type_room),
			new EzConsoleCommandArgument("script", "", true, ezConsole_type_script),
			new EzConsoleCommandArgument("instance", "", true, ezConsole_type_instance),
		]
	);
	
	new EzConsoleCommand(
		"goto",,
		"Go to a new room.",
		function (_args) {
			room_goto(asset_get_index(_args[0]));
		},
		[
			new EzConsoleCommandArgument("room", "Room Name", true, ezConsole_type_room),
		]
	);
	
	new EzConsoleCommand(
		"trace",,
		"Trace a message with options.",
		function (_args) {
			show_message_async(_args[0]);
		},
		[
			new EzConsoleCommandArgumentWithOptions(
				"message",,
				true,
				[
					"lorem",
					"ipsum",
					"good",
					"game",
					"this",
					"is",
					"a",
					"test",
				]
			),
		]
	);
	#endregion
});
