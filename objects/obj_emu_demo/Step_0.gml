var array = file_dropper_get_files(".yarn");
file_dropper_flush();

if (array_length(array) > 0) {
    array_foreach(array, function(item) {
        obj_emu_demo.Add(item);
    });
}

if (!EmuOverlay.GetTop()) {
    if (keyboard_check(vk_control)) {
        if (keyboard_check_pressed(ord("S"))) {
            var filename = get_save_filename("cutscene save json|*.cutscenesavejson", "");
            self.Save(filename);
        }
        
        if (keyboard_check_pressed(ord("O"))) {
            var filename = get_open_filename("cutscene save json|*.cutscenesavejson", "");
            self.Load(filename);
        }
    }
}