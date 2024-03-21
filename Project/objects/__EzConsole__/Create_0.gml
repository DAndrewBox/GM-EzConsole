/// @description Setup
if (ezConsole_debug_only && debug_mode) {
	instance_destroy(id, false);
	exit;
}

display_set_gui_maximize();

visible = ezConsole_prop_start_open;
depth = ezConsole_prop_depth;


try {	
	/* [Bugfix EZC-2]
		Going fullscreen doesn't resize console nor blur surface.
	*/
	__original_window_w = display_get_gui_width();
	__original_window_h = display_get_gui_height();
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

console_blur_surf				= -1;

console_suggestion_text			= "";

console_typeahead_show			= false;
console_typeahead_elements		= [];
console_typeahead_selected		= -1;
console_typeahead_elements_max	= ezConsole_prop_typeahead_elements;
console_typeahead_selected_yoff	= 0;
console_typeahead_nav_t			= 0;
console_typeahead_filter		= function (e) {return is_string(e);};

console_instance_highlight_index = 0;

surface_depth_disable(true);

/* Initial message */
var _init_message = console_get_message(EZ_CONSOLE_MSG.INTIALIZATION, "");
console_write_log(_init_message, EZ_CONSOLE_MSG_TYPE.WARNING);