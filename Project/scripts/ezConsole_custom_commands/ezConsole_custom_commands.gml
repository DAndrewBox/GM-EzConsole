
call_later(1, time_source_units_frames, function () {
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
	#endregion
});
