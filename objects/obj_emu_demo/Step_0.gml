var array = file_dropper_get_files([".yarn", "." + SAVE_FILE_EXTENSION]);
file_dropper_flush();

if (array_length(array) > 0) {
    array_foreach(array, function(item) {
        switch (filename_ext(item)) {
            case "." + SAVE_FILE_EXTENSION:
                obj_emu_demo.Load(item);
                break;
            case ".yarn":
                obj_emu_demo.Add(item);
                break;
        }
    });
}

if (!EmuOverlay.GetTop()) {
    if (keyboard_check(vk_control)) {
        if (keyboard_check_pressed(ord("S"))) {
            var filename = get_save_filename($"cutscene save json|*.{SAVE_FILE_EXTENSION}", "");
            self.Save(filename);
        }
        
        if (keyboard_check_pressed(ord("O"))) {
            var filename = get_open_filename($"cutscene save json|*.{SAVE_FILE_EXTENSION}", "");
            self.Load(filename);
        }
    }
}