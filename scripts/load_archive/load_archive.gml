function load_archive(filename) {
    if (!file_exists(filename)) return;
    
    var buffer = buffer_load(filename);
    var version = buffer_read(buffer, buffer_u64);
    var file_count = buffer_read(buffer, buffer_u64);
    var appendage_point = buffer_read(buffer, buffer_u64);
    
    var output = { };
    
    for (var i = 0; i < file_count; i++) {
        var name = buffer_read(buffer, buffer_string);
        var position = buffer_read(buffer, buffer_u64);
        var size = buffer_read(buffer, buffer_u64);
        
        var b = buffer_create(size, buffer_fixed, 1);
        buffer_copy(buffer, appendage_point + position, size, b, 0);
        
        output[$ name] = b;
    }
    
    return output;
}