/// @description Free memory
if (ezConsole_debug_only && debug_mode) exit;

// Do destroy callback
if (script_exists(ezConsole_callback_onDestroy)) {
	script_execute(ezConsole_callback_onDestroy);
}

// Destroy log structs
var _log_len = ds_list_size(console_text_log);
for (var i = 0; i < _log_len; i++) {
	delete console_text_log[| i]; 
}

// Destroy data struct
ds_list_destroy(console_text_log);

// Free surfaces from memory
if (surface_exists(console_surf))		surface_free(console_surf);
if (surface_exists(console_blur_surf))	surface_free(console_blur_surf);
if (surface_exists(console_bar_surf))	surface_free(console_bar_surf);

// Give the mouse cursor back if the resize corner was still holding it
if (console_cursor_owned) {
	window_set_cursor(ezConsole_prop_cursor_default);
	console_cursor_owned = false;
}