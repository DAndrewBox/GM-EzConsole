#region // [MODIFY THIS] User configurations setup.
// Files with custom commands to load.
ezConsole_files = [
	"default_commands.json",
	// Add you custom commands files here!
];

// Custom skin name
ezConsole_skin_selected	= "default-dark-example";

// Use console **only** on debug mode
ezConsole_debug_only	= false;

// Custom Console callbacks on actions
ezConsole_callback_onOpen		= -1;
ezConsole_callback_onClose		= -1;
ezConsole_callback_onLog		= -1;
ezConsole_callback_onDestroy	= -1;
ezConsole_callback_onGameEnd	= console_save_log_to_file;
	
#macro	ezConsole_enable_blur				true	// Console backblur
#macro	ezConsole_enable_suggestions		true	// Console suggestions (autocomplete in bar)
#macro	ezConsole_enable_typeahead			true	// Console type-ahead predictions (autocomplete on selection)
#macro	ezConsole_enable_screenfill			true	// Console fills screen with color above everything
	
#macro	ezConsole_enable_typeahead_icons	true	// Console show type-ahead icons for elements
#macro	ezConsole_enable_typeahead_inst_ref	true	// Console show type-ahead ref index on instances elements

#macro	ezConsole_prop_depth				-10000
#macro	ezConsole_prop_start_open			true
#macro	ezConsole_prop_typeahead_elements	20
#macro	ezConsole_prop_nav_scroll_speed		1
#macro	ezConsole_prop_blur_quality			4		// Quality of the Blur shader. (1: Lowest quality (Low GPU usage) | 4: Best quality (More GPU usage))

#macro	ezConsole_autocreate				true
	
#macro	ezConsole_key_toggle				vk_f1
#endregion

call_later(3, time_source_units_frames, function () {
	#region // [DO NOT MODIFY] Auto-configurations Setup
	var _files_len = array_length(ezConsole_files);
	for (var i = 0; i < _files_len; i++) {
		console_add_commands_from_file(working_directory + "GM-EzConsole/" + ezConsole_files[i]);
	}
	
	if (!ezConsole && ezConsole_autocreate) {
		instance_create_depth(0, 0, ezConsole_prop_depth, __EzConsole__);
	}
	#endregion
});
