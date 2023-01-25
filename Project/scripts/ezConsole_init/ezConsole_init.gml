global.__ezConsole_skins_selected	= "default-dark";
global.__ezConsole_skins = console_skin_load_all();
global.__ezConsole_commands = [{
	"name": "COMMAND",
	"short": "SHORT",
	"desc": "DESCRIPTION",
	"args": ["ARGUMENT"],
	"args_req": [true],
	"args_desc": ["VALUE"],
	"callback": "console_write_log"
}];

#region // Load commands from file
var _files_to_load = [
	"default_commands.json",
]

for (var i = 0; i < array_length(_files_to_load); i++) {
	console_add_commands_from_file(working_directory + "GM-EzConsole/" + _files_to_load[i]);
}
#endregion

#region // Enumerators
enum EZ_CONSOLE_MSG {
	INTIALIZATION,
	NOT_ENOUGH_PARAMS,
	TOO_MANY_PARAMS,
	NOT_A_COMMAND,
	INVALID_PARAM,
	HELP_MENU,
	COMMAND_DOESNT_EXISTS,
	CALLBACK_DOESNT_EXISTS,
}

enum EZ_CONSOLE_MSG_TYPE {
	COMMON,
	ERROR,
	WARNING,
	INFO,
}

enum EZ_CONSOLE_ANCHOR {
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT,
}
#endregion

#region // Macros
#macro	ezConsole_commands	global.__ezConsole_commands
#macro	ezConsole_skin		global.__ezConsole_skins[$ global.__ezConsole_skins_selected]
#endregion