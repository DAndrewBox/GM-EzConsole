/// @description Setup
if (ezConsole_debug_only && debug_mode) {
	instance_destroy(id, false);
	exit;
}

x = 200;
y = 200;

visible = ezConsole_prop_start_open;

try {	
	/* [Bugfix EZC-2]
		Going fullscreen doesn't resize console nor blur surface.
	*/
	__original_window_w = window_get_width();
	__original_window_h = window_get_height();
} catch(e) {
	/* [Bugfix EZC-1]
		Console crash games when starting before main window is initialized.
	*/
	show_debug_message(e.longMessage);
	instance_destroy();
}

event_user(1);

console_drag_mouse_active	= false;
console_drag_mouse_xoff		= 0;
console_drag_mouse_yoff		= 0;

console_window_title		= $"GameMaker's EzConsole (v{ezConsole_version})";
console_window_open			= true;

console_text_actual			= "";
console_text_blink_t		= 0;

console_text_log			= ds_list_create();
console_log_total_h			= 0;

console_surf				= -1;
console_surf_yoffset		= 0;
console_surf_yoffset_to		= 0;

console_key_toggle			= ezConsole_key_toggle;
console_key_nav_up			= ezConsole_key_nav_up;
console_key_nav_down		= ezConsole_key_nav_down;
console_key_nav_left		= ezConsole_key_nav_left;
console_key_nav_right		= ezConsole_key_nav_right;

console_nav_hor				= 0;
console_nav_scroll			= 0;
console_nav_scroll_speed	= ezConsole_prop_nav_scroll_speed;

console_fps_t		= 0;
console_fps_show	= false;
console_fps_real	= string(round(fps_real));
console_fps			= string(round(fps));
console_fps_avg		= string(round(fps));
console_fps_hist	= [];

console_debug_overlay_show		= false;

console_callback_on_open		= ezConsole_callback_onOpen;
console_callback_on_close		= ezConsole_callback_onClose;
console_callback_on_log			= ezConsole_callback_onLog;
console_callback_on_destroy		= ezConsole_callback_onDestroy;
console_callback_on_game_end	= ezConsole_callback_onGameEnd;

console_blur_flag				= ezConsole_enable_blur;
console_blur_surf				= -1;

console_screenfill_flag			= ezConsole_enable_screenfill;
console_suggestions_flag		= ezConsole_enable_suggestions;
console_suggestion_text			= "";

console_typeahead_flag			= ezConsole_enable_typeahead;
console_typeahead_show			= false;
console_typeahead_elements		= [];
console_typeahead_selected		= -1;
console_typeahead_elements_max	= ezConsole_prop_typeahead_elements;
console_typeahead_selected_yoff	= 0;

console_instance_highlight_index = 0;

depth = ezConsole_prop_depth;
display_set_gui_maximize();
surface_depth_disable(true);

/* Initial message */
var _init_message = console_get_message(EZ_CONSOLE_MSG.INTIALIZATION, "");
console_write_log(_init_message, EZ_CONSOLE_MSG_TYPE.WARNING);