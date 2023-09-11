var array = file_dropper_get_files(".yarn");
file_dropper_flush();

if (array_length(array) > 0) {
    array_foreach(array, function(item) {
        obj_emu_demo.Add(item);
    });
}