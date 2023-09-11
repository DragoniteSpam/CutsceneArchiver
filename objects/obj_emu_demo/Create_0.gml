self.files = [];
self.filename_cache = { };

var ew = 400;
var eh = 32;

self.container = new EmuCore(0, 0, 640, 640, "main").AddContent([
    new EmuText(32, 32, ew, eh, "[c_aqua]Cutscene Archiver"),
    new EmuList(32, EMU_AUTO, ew, eh, "Files:", eh, 12, function() {
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
        .SetRefresh(function() {
            self.SetInteractive(!!self.GetSibling("LIST").GetSelectedItem());
        })
        .SetID("REMOVE"),
    new EmuInput(32, EMU_AUTO, ew, eh, "Name:", "", "The file's internal name", 30, E_InputTypes.STRING, function() {
        var item = self.GetSibling("LIST").GetSelectedItem();
        item.name = self.value;
    })
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
            self.SetInteractive(!!item);
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