global.__debug_console_commands = [{
	"name": "COMMAND",
	"short": "short",
	"desc": "DESCRIPTION",
	"args": ["ARGUMENT"],
	"req": [true],
	"values": ["VALUE"],
	"callback": "console_write_log"
}];

#region // Load commands from file
var _files_to_load = [
	"default_commands.json",
]

for (var i = 0; i < array_length(_files_to_load); i++) {
	console_add_commands_from_file(working_directory + _files_to_load[i]);
}
#endregion

#region // Enumerators
enum EZ_CONSOLE_MSG {
	INTIALIZATION,
	NOT_ENOUGH_PARAMS,
	TOO_MUCH_PARAMS,
	NOT_A_COMMAND,
	INVALID_PARAM,
	HELP_MENU,
	COMMAND_DOESNT_EXISTS,
}

enum EZ_CONSOLE_MSG_TYPE {
	COMMON,
	ERROR,
	WARNING,
	INFO,
}
#endregion