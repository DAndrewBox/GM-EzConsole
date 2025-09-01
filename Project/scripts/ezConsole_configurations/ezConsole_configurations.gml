// Initialize ezConsole globals
gml_pragma("global", "ezConsole_init()");

/* ====================================================== */
/* ============ DO NOT MODIFY ANYTHING ABOVE ============ */
/* ====================================================== */


#region // [MODIFY THIS] User configurations setup.
// Files with custom commands to load.
ezConsole_files = [
	// "default_commands.json", <-- Uncomment this to import default commands from file
	// Add you custom commands files here!
];

// Custom skin name
ezConsole_skin_selected	= "default-ImGui";

// Use console **only** on debug mode
#macro	ezConsole_debug_only			false

// Custom Console callbacks on actions
#macro	ezConsole_callback_onOpen		noone
#macro	ezConsole_callback_onClose		noone
#macro	ezConsole_callback_onLog		noone
#macro	ezConsole_callback_onDestroy	noone
#macro	ezConsole_callback_onGameEnd	console_save_log_to_file

// Custom Console flags
#macro	ezConsole_enable_blur				true	// Console backblur
#macro	ezConsole_enable_suggestions		true	// Console suggestions (autocomplete in bar)
#macro	ezConsole_enable_typeahead			true	// Console type-ahead predictions (autocomplete on selection)
#macro	ezConsole_enable_screenfill			true	// Console fills screen with color above everything

// Typeahead enhancements flags
#macro	ezConsole_enable_typeahead_icons	true	// Console show type-ahead icons for elements
#macro	ezConsole_enable_typeahead_inst_ref	true	// Console show type-ahead ref index on instances elements

// Console props
#macro	ezConsole_prop_depth				-10000	// Depth. Keep a large negative number to draw above everything else.
#macro	ezConsole_prop_start_open			true	// Console should always start open when created
#macro	ezConsole_prop_typeahead_elements	20		// Maximum amount of typeahead elements to show at the same time
#macro	ezConsole_prop_nav_scroll_speed		1		// Scroll speed ratio when using mouse wheel
#macro	ezConsole_prop_blur_quality			3		// Quality of the Blur shader. (1: Lowest quality (Low GPU usage) | 4: Best quality (More GPU usage))

// Valid characters that can be typed on console
#macro	ezConsole_valid_charset_letters		"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
#macro	ezConsole_valid_charset_numbers		"0123456789"
#macro	ezConsole_valid_charset_symbols		" _\":.#<>"

// Console would be created a few frames after start game.
#macro	ezConsole_autocreate				true
	
// Console keys to do certain actions
#macro	ezConsole_key_toggle				vk_f1		// Open/Close the console key
#macro	ezConsole_key_nav_up				vk_up		// Type-ahead up navigation key
#macro	ezConsole_key_nav_down				vk_down		// Type-ahead down navigation key
#macro	ezConsole_key_nav_left				vk_left		// Console cursor left navigation key
#macro	ezConsole_key_nav_right				vk_right	// Console cursor right navigation key
#macro	ezConsole_key_auto_complete			vk_tab		// Type-ahead & suggestions autocomplete key
#macro	ezConsole_key_send_line				vk_enter	// Console send message line key
#endregion


/* ====================================================== */
/* ============ DO NOT MODIFY ANYTHING BELOW ============ */
/* ====================================================== */
call_later(3, time_source_units_frames, function () {
	#region // [DO NOT MODIFY] Auto-configurations Setup
	// Setup valid charset
	#macro	ezConsole_valid_charset		$"{ezConsole_valid_charset_letters}{ezConsole_valid_charset_numbers}{ezConsole_valid_charset_symbols}"
	
	// Load command files
	var _files_len = array_length(ezConsole_files);
	if (directory_exists(working_directory + "GM-EzConsole")) {
		for (var i = 0; i < _files_len; i++) {
			console_add_commands_from_file(working_directory + "GM-EzConsole/" + ezConsole_files[i]);
		}
	}
	
	// Automaticly create console after 3 frmaes of start
	// (Wating 3 frames solves some resolutions and fullscreen bugs)
	if (!ezConsole && ezConsole_autocreate) {
		instance_create_depth(0, 0, ezConsole_prop_depth, __EzConsole__);
	}
	#endregion
});
