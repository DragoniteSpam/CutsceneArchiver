function load_archive(filename) {
    if (!file_exists(filename)) return;
    
    var buffer = buffer_load(filename);
    var decompressed = buffer_decompress(buffer);
    var version = buffer_read(decompressed, buffer_u64);
    var file_count = buffer_read(decompressed, buffer_u64);
    var appendage_point = buffer_read(decompressed, buffer_u64);
    
    var output = { };
    
    for (var i = 0; i < file_count; i++) {
        var name = buffer_read(decompressed, buffer_string);
        var position = buffer_read(decompressed, buffer_u64);
        var size = buffer_read(decompressed, buffer_u64);
        var b = buffer_create(size, buffer_fixed, 1);
        buffer_copy(decompressed, appendage_point + position, size, b, 0);
        
        output[$ name] = b;
    }
    
    buffer_delete(buffer);
    buffer_delete(decompressed);
    
    return output;
}