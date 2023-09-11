var save_file = buffer_create(1, buffer_grow, 1);
buffer_write(save_file, buffer_text, json_stringify(self.files));
buffer_save(save_file, SAVE_FILE_LOCATION);
buffer_delete(save_file);