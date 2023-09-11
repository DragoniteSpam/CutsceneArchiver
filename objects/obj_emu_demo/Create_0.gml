self.files = [];

var ew = 320;
var eh = 32;

self.container = new EmuCore(0, 0, 640, 640, "main").AddContent([
    new EmuText(32, 32, ew, eh, "[c_aqua]Cutscene Archiver"),
    new EmuList(32, EMU_AUTO, ew, eh, "Files:", eh, 12, function() {
    }),
    new EmuButton(32, EMU_AUTO, ew, eh, "Add", function() {
    }),
    new EmuButton(32, EMU_AUTO, ew, eh, "Remove", function() {
    }),
    new EmuInput(32, EMU_AUTO, ew, eh, "Name:", "", "The file's internal name", 30, E_InputTypes.STRING, function() {
    })
        .SetInputBoxPosition(ew / 3, 0),
    new EmuButton(32, EMU_AUTO, ew, eh, "Credits", function() {
    })
]);