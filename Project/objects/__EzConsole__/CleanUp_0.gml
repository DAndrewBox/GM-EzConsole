/// @description Free memory
if (ezConsole_debug_only && debug_mode) exit;

// Do destroy callback
if (console_callback_on_destroy) console_callback_on_destroy();

// Destroy log structs
var _log_len = ds_list_size(console_text_log);
for (var i = 0; i < _log_len; i++) {
	delete console_text_log[| i]; 
}

// Destroy data struct
ds_list_destroy(console_text_log);

// Free surface from memory
surface_free(console_surf);