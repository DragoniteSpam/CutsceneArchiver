self.files = [];

var ew = 400;
var eh = 32;

self.container = new EmuCore(0, 0, 640, 640, "main").AddContent([
    new EmuText(32, 32, ew, eh, "[c_aqua]Cutscene Archiver"),
    new EmuList(32, EMU_AUTO, ew, eh, "Files:", eh, 12, function() {
        self.root.Refresh();
    })
        .SetID("LIST")
        .SetList(self.files),
    new EmuButton(32, EMU_AUTO, ew, eh, "Add", function() {
        var file = get_open_filename("Yarn files|*.yarn", "");
        if (!file_exists(file)) return;
        array_push(obj_emu_demo.files, new File(file));
    }),
    new EmuButton(32, EMU_AUTO, ew, eh, "Remove", function() {
        var selection = self.GetSibling("LIST").GetSelection();
        array_delete(obj_emu_demo.files, selection, 1);
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
    })
]);