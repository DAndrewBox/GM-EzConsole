/// @description Free memory
// Do destroy callback
if (console_callback_on_destroy) console_callback_on_destroy();

// Destroy log structs
for (var i = 0; i < ds_list_size(console_text_log); i++) {
	delete console_text_log[| i]; 
}

// Destroy data struct
ds_list_destroy(console_text_log);

// Free surface from memory
surface_free(console_surf);