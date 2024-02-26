ezConsole_skin_list		= console_skin_load_all();
ezConsole_commands		= [];
global.__EzConsole_callbacks = {
	onClose:	-1,
	onOpen:		-1,
	onGameEnd:	-1,
	onDestroy:	-1,
	onLog:		-1,
};

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
	UNDEFINED_COMMANDS_FOUND,
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

#region // Internal Definitions
#macro	ezConsole_type_sprite		0
#macro	ezConsole_type_object		1
#macro	ezConsole_type_sound		2
#macro	ezConsole_type_font			3
#macro	ezConsole_type_script		4
#macro	ezConsole_type_room			5
#macro	ezConsole_type_instance		6

#macro	ezConsole_type_options		10

#macro	ezConsole_files				global.__ezConsole_files
#macro	ezConsole_commands			global.__ezConsole_commands
#macro	ezConsole_skin_list			global.__ezConsole_skins
#macro	ezConsole_skin_current		ezConsole_skin_list[$ ezConsole_skin_selected]
#macro	ezConsole_skin_selected		global.__ezConsole_skins_selected
#macro	ezConsole_debug_only		global.__ezConsole_debug_only

#macro	ezConsole					instance_find(__EzConsole__, 0)

#macro	ezConsole_callback_onOpen		global.__EzConsole_callbacks.onOpen
#macro	ezConsole_callback_onClose		global.__EzConsole_callbacks.onClose
#macro	ezConsole_callback_onLog		global.__EzConsole_callbacks.onLog
#macro	ezConsole_callback_onDestroy	global.__EzConsole_callbacks.onDestroy
#macro	ezConsole_callback_onGameEnd	global.__EzConsole_callbacks.onGameEnd

#macro	ezConsole_version			"1.3.beta-2"
#endregion