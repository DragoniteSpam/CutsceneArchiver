combine multiple .yarn files into a single .yarn file

for reading the files:

    function load_archive(filename) {
        if (!file_exists(filename)) return;
        
        var source = buffer_load(filename);
        var decompressed = buffer_decompress(source);
        var version = buffer_read(decompressed, buffer_u64);
        var file_count = buffer_read(decompressed, buffer_u64);
        var appendage_point = buffer_read(decompressed, buffer_u64);
        
        var output = array_create(file_count);
        
        for (var i = 0; i < file_count; i++) {
            var name = buffer_read(decompressed, buffer_string);
            var position = buffer_read(decompressed, buffer_u64);
            var size = buffer_read(decompressed, buffer_u64);
            var buffer = buffer_create(size, buffer_fixed, 1);
            buffer_copy(decompressed, appendage_point + position, size, buffer, 0);
            
            output[i] = {
                name,
                buffer
            };
        }
        
        buffer_delete(source);
        buffer_delete(decompressed);
        
        return output;
    }
