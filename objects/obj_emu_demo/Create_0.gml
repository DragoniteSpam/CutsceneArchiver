#macro SAVE_FILE_LOCATION "files.json"

self.files = [];
self.filename_cache = { };

if (file_exists(SAVE_FILE_LOCATION)) {
    var buffer = buffer_load(SAVE_FILE_LOCATION);
    self.files = json_parse(buffer_read(buffer, buffer_text));
    buffer_delete(buffer);
    
    for (var i = 0, n = array_length(self.files); i < n; i++) {
        var file = self.files[i];
        file.toString = method(file, function() { return self.name; });
        self.filename_cache[$ file.filename] = file;
    }
}

self.Export = function() {
    var save_filename = get_save_filename("", "output");
    if (save_filename == "") return;
    
    var buffer_content = buffer_create(1, buffer_fixed, 1);
    var buffer = buffer_create(1000, buffer_grow, 1);
    var total = 0;
    var skipped = 0;
    
    buffer_write(buffer, buffer_u64, 0);        // versioning?
    buffer_write(buffer, buffer_u64, 0);        // count
    buffer_write(buffer, buffer_u64, 0);        // appendage starts here
    
    for (var i = 0, n = array_length(obj_emu_demo.files); i < n; i++) {
        var file = obj_emu_demo.files[i];
        
        if (!file_exists(file.filename)) {
            skipped++;
            return;
        }
        
        var file_position = buffer_get_size(buffer_content);
        var file_buffer = buffer_load(file.filename);
        var file_size = buffer_get_size(file_buffer);
        
        buffer_write(buffer, buffer_string, file.name);
        buffer_write(buffer, buffer_u64, file_position);
        buffer_write(buffer, buffer_u64, file_size);
        
        total++;
        
        buffer_resize(buffer_content, file_position + buffer_get_size(file_buffer));
        buffer_copy(file_buffer, 0, file_size, buffer_content, file_position);
        buffer_delete(file_buffer);
    };
    
    var appendage = buffer_tell(buffer);
    
    buffer_poke(buffer, 8, buffer_u64, total);
    buffer_poke(buffer, 16, buffer_u64, appendage);
    
    var content_size = buffer_get_size(buffer_content);
    buffer_resize(buffer, appendage + content_size);
    buffer_copy(buffer_content, 0, content_size, buffer, appendage);
    
    buffer_save(buffer, save_filename);
    
    buffer_delete(buffer_content);
    buffer_delete(buffer);
};

self.Clear = function() {
    array_resize(self.files, 0);
};

var ew = 400;
var eh = 32;

self.container = new EmuCore(0, 0, 640, 640, "main").AddContent([
    new EmuText(32, 32, ew, eh, "[c_aqua]Cutscene Archiver"),
    new EmuList(32, EMU_AUTO, ew, eh, "Files:", eh, 10, function() {
        self.root.Refresh();
    })
        .SetCallbackMiddle(function() {
            array_sort(obj_emu_demo.files, function(a, b) {
                return (a.name > b.name) ? 1 : (a.name == b.name ? 0 : -1);
            });
        })
        .SetID("LIST")
        .SetList(self.files),
    new EmuButton(32, EMU_AUTO, ew, eh, "Add", function() {
        var filename = get_open_filename("Yarn files|*.yarn", "");
        if (!file_exists(filename)) return;
        
        self.GetSibling("LIST").ClearSelection();
        
        // dont add duplicate filenames
        if (obj_emu_demo.filename_cache[$ filename]) {
            var index = array_find_index(obj_emu_demo.files, method({ filename }, function(item) {
                return item.filename == self.filename;
            }));
            self.GetSibling("LIST").Select(index);
            return;
        }
        
        var file = new File(filename);
        array_push(obj_emu_demo.files, file);
        obj_emu_demo.filename_cache[$ filename] = file;
        self.GetSibling("LIST").Select(array_length(obj_emu_demo.files) - 1);
    }),
    new EmuButton(32, EMU_AUTO, ew, eh, "Remove", function() {
        var selection = self.GetSibling("LIST").GetSelection();
        var file = obj_emu_demo.files[selection];
        array_delete(obj_emu_demo.files, selection, 1);
        struct_remove(obj_emu_demo.filename_cache, file.filename);
        self.root.Refresh();
    })
        .SetInteractive(false)
        .SetRefresh(function() {
            self.SetInteractive(!!self.GetSibling("LIST").GetSelectedItem());
        })
        .SetID("REMOVE"),
    new EmuInput(32, EMU_AUTO, ew, eh, "Name:", "", "The file's internal name", 30, E_InputTypes.STRING, function() {
        var item = self.GetSibling("LIST").GetSelectedItem();
        item.name = self.value;
    })
        .SetInteractive(false)
        .SetRefresh(function() {
            var item = self.GetSibling("LIST").GetSelectedItem();
            self.SetInteractive(!!item);
            if (item) {
                self.SetValue(item.name);
            }
        })
        .SetID("NAME")
        .SetInputBoxPosition(ew / 3, 0),
    new EmuText(32, EMU_AUTO, ew, eh, "[c_gray]No file selected")
        .SetRefresh(function() {
            static text_length_limit = 30;
            static text_beginning_chars = 10;
            static text_ending_chars = 18;
            
            var item = self.GetSibling("LIST").GetSelectedItem();
            if (item) {
                var text = item.filename;
                if (string_length(text) > text_length_limit) {
                    text = string_copy(text, 1, text_beginning_chars) + "... " + string_copy(text, string_length(text) - text_ending_chars + 1, text_ending_chars);
                }
                
                self.text = text;
                
                if (!file_exists(item.filename)) {
                    self.text = "[c_orange]" + self.text;
                }
            } else {
                self.text = "[c_gray]No file selected";
            }
        })
        .SetID("FULLNAME"),
    new EmuButton(32, EMU_AUTO, ew, eh, "Export", function() {
        obj_emu_demo.Export();
    }),
    new EmuButton(32, EMU_AUTO, ew, eh, "Clear", function() {
        obj_emu_demo.Clear();
    }),
    new EmuButton(32, EMU_AUTO, ew, eh, "Credits", function() {
        var ew = 320;
        var eh = 32;
        new EmuDialog(360, 240, "Cutscene Archiver").AddContent([
            new EmuText(32, EMU_AUTO, ew, eh, "Made by drago"),
            new EmuText(32, EMU_AUTO, ew, eh, "Emu by drago"),
            new EmuText(32, EMU_AUTO, ew, eh, "Scribble by juju")
        ]).AddDefaultCloseButton("thanks!");
    })
]);