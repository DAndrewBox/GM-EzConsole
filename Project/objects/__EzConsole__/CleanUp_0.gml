/// @description Free memory
if (ezConsole_debug_only && debug_mode) exit;

// Do destroy callback
if (is_callable(ezConsole_callback_onDestroy)) {
	// Feather ignore once GM1041 - This is already validated to be a callable.
	script_execute(ezConsole_callback_onDestroy);
}

// Destroy log structs
var _log_len = ds_list_size(console_text_log);
for (var i = 0; i < _log_len; i++) {
	delete console_text_log[| i]; 
}

// Destroy data struct
ds_list_destroy(console_text_log);

// Free surface from memory
surface_free(console_surf);