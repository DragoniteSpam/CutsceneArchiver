function File(filename) constructor {
    self.filename = filename;
    self.name = filename_name(filename);
    
    self.toString = function() {
        return self.name;
    };
}