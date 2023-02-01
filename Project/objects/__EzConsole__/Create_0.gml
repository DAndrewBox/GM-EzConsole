/// @description Setup
try {
	console_width	= console_skin_get_width(ezConsole_skin[$ "width"]);
	console_height	= console_skin_get_height(ezConsole_skin[$ "height"]);
	
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

console_anchor	= ezConsole_skin[$ "anchor"];
console_position_set_by_anchor(console_anchor);

console_bg_color			= __ezConsole_dep_hex_to_dec(ezConsole_skin[$ "bg_color"]);
console_bg_alpha			= ezConsole_skin[$ "bg_alpha"];

console_text_font			= asset_get_index(ezConsole_skin[$ "text_font"]);
console_text_font_xoff		= ezConsole_skin[$ "text_font_xoff"];
console_text_font_yoff		= ezConsole_skin[$ "text_font_yoff"];
console_text_alpha			= ezConsole_skin[$ "text_alpha"];
console_text_log			= ds_list_create();
console_text_actual			= "";
console_text_actual_color	= __ezConsole_dep_hex_to_dec(ezConsole_skin[$ "text_color_common"]);
console_text_blink_t		= 0;
console_text_blink_rate		= ezConsole_skin[$ "text_blink_rate"];
console_text_blink_char		= ezConsole_skin[$ "text_blink_char"];
console_text_start_char		= ezConsole_skin[$ "text_start_char"];

console_bar_height			= ezConsole_skin[$ "bar_height"];
console_bar_color			= __ezConsole_dep_hex_to_dec(ezConsole_skin[$ "bar_color"]);
console_bar_color_highlight	= __ezConsole_dep_hex_to_dec(ezConsole_skin[$ "bar_color_highlight"]);

console_log_xpad			= ezConsole_skin[$ "bar_xpad"];
console_log_ypad			= ezConsole_skin[$ "bar_ypad"];
console_log_total_h			= 0;

console_surf				= -1;
console_surf_yoffset		= 0;

console_key_toggle			= vk_f1;
console_key_nav_up			= vk_up;
console_key_nav_down		= vk_down;
console_key_nav_left		= vk_left;
console_key_nav_right		= vk_right;

console_nav_hor				= 0;
console_nav_scroll			= 0;
console_nav_scroll_speed	= ezConsole_skin[$ "nav_scroll_speed"];

console_fps_t		= 0;
console_fps_show	= false;
console_fps_real	= string(round(fps_real));
console_fps			= string(round(fps));
console_fps_avg		= string(round(fps));
console_fps_hist	= [];

console_debug_overlay_show		= false;

console_callback_on_open		= -1;
console_callback_on_close		= -1;
console_callback_on_log			= -1;
console_callback_on_destroy		= -1;
console_callback_on_game_end	= console_save_log_to_file;

console_blur_flag				= ezConsole_skin[$ "blur_flag"];
console_blur_surf				= -1;
console_blur_amount				= ezConsole_skin[$ "blur_amount"];

console_screenfill_flag			= ezConsole_skin[$ "screenfill_flag"];
console_screenfill_color		= __ezConsole_dep_hex_to_dec(ezConsole_skin[$ "screenfill_color"]);
console_screenfill_alpha		= ezConsole_skin[$ "screenfill_alpha"];

console_suggestions_flag		= ezConsole_skin[$ "suggestions_flag"];
console_suggestion_text			= "";

console_typeahead_flag			= ezConsole_skin[$ "typeahead_flag"];
console_typeahead_show			= false;
console_typeahead_elements		= [];
console_typeahead_selected		= -1;
console_typeahead_elements_max	= ezConsole_skin[$ "typeahead_max_elements"];

depth = -1000;
display_set_gui_maximize();
surface_depth_disable(true);

/* Initial message */
var _init_message = console_get_message(EZ_CONSOLE_MSG.INTIALIZATION, "");
console_write_log(_init_message, EZ_CONSOLE_MSG_TYPE.WARNING);