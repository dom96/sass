when defined(macosx):
  const libsass = "libsass.dylib"
elif defined(linux):
  const libsass = "libsass.so"
else:
  const libsass = "libsass.dll"

#[ base.h ]#

##  Different render styles

type
  Output_Style* {.size: sizeof(cint).} = enum
    Nested, Expanded, Compact, Compressed, ##  only used internaly
    Inspect, ToSass


##  to allocate buffer to be filled

proc alloc_memory*(size: csize): pointer {.importc: "sass_alloc_memory",
                                       dynlib: libsass.}
##  to allocate a buffer from existing string

proc copy_c_string*(str: cstring): cstring {.importc: "sass_copy_c_string",
    dynlib: libsass.}
##  to free overtaken memory when done

proc free_memory*(`ptr`: pointer) {.importc: "sass_free_memory", dynlib: libsass.}
##  Some convenient string helper function

proc string_quote*(str: cstring; quote_mark: char): cstring {.
    importc: "sass_string_quote", dynlib: libsass.}
proc string_unquote*(str: cstring): cstring {.importc: "sass_string_unquote",
    dynlib: libsass.}
##  Implemented sass language version
##  Hardcoded version 3.4 for time being

proc version*(): cstring {.importc: "libsass_version", dynlib: libsass.}
##  Get compiled libsass language

proc language_version*(): cstring {.importc: "libsass_language_version",
                                 dynlib: libsass.}

#[
  Generated from context.h, using the following command:
  c2nim --dynlib:libsass --prefix:sass_compiler_ --prefix:sass_file_context_ --prefix:sass_data_context_ --prefix:sass_option_ --prefix:Sass_ --prefix:sass_context_ --prefix:sass_ --suffix:_file_context --suffix:_data_context
]#

##  Forward declaration

type
  Compiler* {.bycopy.} = object
  

##  Forward declaration

type
  Options* {.bycopy.} = object
  

##  base struct

type
  Context* {.bycopy.} = object
  

##  : Sass_Options

type
  File_Context* {.bycopy.} = object
  

##  : Sass_Context

type
  Data_Context* {.bycopy.} = object
  

##  : Sass_Context
##  Compiler states

type
  Compiler_State* {.size: sizeof(cint).} = enum
    SASS_COMPILER_CREATED, SASS_COMPILER_PARSED, SASS_COMPILER_EXECUTED


##  Create and initialize an option struct

proc make_options*(): ptr Options {.importc: "sass_make_options", dynlib: libsass.}
##  Create and initialize a specific context

proc make_file_context*(input_path: cstring): ptr File_Context {.
    importc: "sass_make_file_context", dynlib: libsass.}
proc make_data_context*(source_string: cstring): ptr Data_Context {.
    importc: "sass_make_data_context", dynlib: libsass.}
##  Call the compilation step for the specific context

proc compile*(ctx: ptr File_Context): cint {.importc: "sass_compile_file_context",
                                        dynlib: libsass.}
proc compile*(ctx: ptr Data_Context): cint {.importc: "sass_compile_data_context",
                                        dynlib: libsass.}
##  Create a sass compiler instance for more control

proc make_file_compiler*(file_ctx: ptr File_Context): ptr Compiler {.
    importc: "sass_make_file_compiler", dynlib: libsass.}
proc make_data_compiler*(data_ctx: ptr Data_Context): ptr Compiler {.
    importc: "sass_make_data_compiler", dynlib: libsass.}
##  Execute the different compilation steps individually
##  Usefull if you only want to query the included files

proc parse*(compiler: ptr Compiler): cint {.importc: "sass_compiler_parse",
                                       dynlib: libsass.}
proc execute*(compiler: ptr Compiler): cint {.importc: "sass_compiler_execute",
    dynlib: libsass.}
##  Release all memory allocated with the compiler
##  This does _not_ include any contexts or options

proc delete_compiler*(compiler: ptr Compiler) {.importc: "sass_delete_compiler",
    dynlib: libsass.}
proc delete_options*(options: ptr Options) {.importc: "sass_delete_options",
    dynlib: libsass.}
##  Release all memory allocated and also ourself

proc delete*(ctx: ptr File_Context) {.importc: "sass_delete_file_context",
                                  dynlib: libsass.}
proc delete*(ctx: ptr Data_Context) {.importc: "sass_delete_data_context",
                                  dynlib: libsass.}
##  Getters for context from specific implementation

proc get_context*(file_ctx: ptr File_Context): ptr Context {.
    importc: "sass_file_context_get_context", dynlib: libsass.}
proc get_context*(data_ctx: ptr Data_Context): ptr Context {.
    importc: "sass_data_context_get_context", dynlib: libsass.}
##  Getters for Context_Options from Sass_Context

proc get_options*(ctx: ptr Context): ptr Options {.
    importc: "sass_context_get_options", dynlib: libsass.}
proc get_options*(file_ctx: ptr File_Context): ptr Options {.
    importc: "sass_file_context_get_options", dynlib: libsass.}
proc get_options*(data_ctx: ptr Data_Context): ptr Options {.
    importc: "sass_data_context_get_options", dynlib: libsass.}
proc set_options*(file_ctx: ptr File_Context; opt: ptr Options) {.
    importc: "sass_file_context_set_options", dynlib: libsass.}
proc set_options*(data_ctx: ptr Data_Context; opt: ptr Options) {.
    importc: "sass_data_context_set_options", dynlib: libsass.}
##  Getters for Context_Option values

proc get_precision*(options: ptr Options): cint {.
    importc: "sass_option_get_precision", dynlib: libsass.}
proc get_output_style*(options: ptr Options): Output_Style {.
    importc: "sass_option_get_output_style", dynlib: libsass.}
proc get_source_comments*(options: ptr Options): bool {.
    importc: "sass_option_get_source_comments", dynlib: libsass.}
proc get_source_map_embed*(options: ptr Options): bool {.
    importc: "sass_option_get_source_map_embed", dynlib: libsass.}
proc get_source_map_contents*(options: ptr Options): bool {.
    importc: "sass_option_get_source_map_contents", dynlib: libsass.}
proc get_source_map_file_urls*(options: ptr Options): bool {.
    importc: "sass_option_get_source_map_file_urls", dynlib: libsass.}
proc get_omit_source_map_url*(options: ptr Options): bool {.
    importc: "sass_option_get_omit_source_map_url", dynlib: libsass.}
proc get_is_indented_syntax_src*(options: ptr Options): bool {.
    importc: "sass_option_get_is_indented_syntax_src", dynlib: libsass.}
proc get_indent*(options: ptr Options): cstring {.importc: "sass_option_get_indent",
    dynlib: libsass.}
proc get_linefeed*(options: ptr Options): cstring {.
    importc: "sass_option_get_linefeed", dynlib: libsass.}
proc get_input_path*(options: ptr Options): cstring {.
    importc: "sass_option_get_input_path", dynlib: libsass.}
proc get_output_path*(options: ptr Options): cstring {.
    importc: "sass_option_get_output_path", dynlib: libsass.}
proc get_source_map_file*(options: ptr Options): cstring {.
    importc: "sass_option_get_source_map_file", dynlib: libsass.}
proc get_source_map_root*(options: ptr Options): cstring {.
    importc: "sass_option_get_source_map_root", dynlib: libsass.}
# proc get_c_headers*(options: ptr Options): Importer_List {.
#     importc: "sass_option_get_c_headers", dynlib: libsass.}
# proc get_c_importers*(options: ptr Options): Importer_List {.
#     importc: "sass_option_get_c_importers", dynlib: libsass.}
# proc get_c_functions*(options: ptr Options): Function_List {.
#     importc: "sass_option_get_c_functions", dynlib: libsass.}
##  Setters for Context_Option values

proc set_precision*(options: ptr Options; precision: cint) {.
    importc: "sass_option_set_precision", dynlib: libsass.}
proc set_output_style*(options: ptr Options; output_style: Output_Style) {.
    importc: "sass_option_set_output_style", dynlib: libsass.}
proc set_source_comments*(options: ptr Options; source_comments: bool) {.
    importc: "sass_option_set_source_comments", dynlib: libsass.}
proc set_source_map_embed*(options: ptr Options; source_map_embed: bool) {.
    importc: "sass_option_set_source_map_embed", dynlib: libsass.}
proc set_source_map_contents*(options: ptr Options; source_map_contents: bool) {.
    importc: "sass_option_set_source_map_contents", dynlib: libsass.}
proc set_source_map_file_urls*(options: ptr Options; source_map_file_urls: bool) {.
    importc: "sass_option_set_source_map_file_urls", dynlib: libsass.}
proc set_omit_source_map_url*(options: ptr Options; omit_source_map_url: bool) {.
    importc: "sass_option_set_omit_source_map_url", dynlib: libsass.}
proc set_is_indented_syntax_src*(options: ptr Options; is_indented_syntax_src: bool) {.
    importc: "sass_option_set_is_indented_syntax_src", dynlib: libsass.}
proc set_indent*(options: ptr Options; indent: cstring) {.
    importc: "sass_option_set_indent", dynlib: libsass.}
proc set_linefeed*(options: ptr Options; linefeed: cstring) {.
    importc: "sass_option_set_linefeed", dynlib: libsass.}
proc set_input_path*(options: ptr Options; input_path: cstring) {.
    importc: "sass_option_set_input_path", dynlib: libsass.}
proc set_output_path*(options: ptr Options; output_path: cstring) {.
    importc: "sass_option_set_output_path", dynlib: libsass.}
proc set_plugin_path*(options: ptr Options; plugin_path: cstring) {.
    importc: "sass_option_set_plugin_path", dynlib: libsass.}
proc set_include_path*(options: ptr Options; include_path: cstring) {.
    importc: "sass_option_set_include_path", dynlib: libsass.}
proc set_source_map_file*(options: ptr Options; source_map_file: cstring) {.
    importc: "sass_option_set_source_map_file", dynlib: libsass.}
proc set_source_map_root*(options: ptr Options; source_map_root: cstring) {.
    importc: "sass_option_set_source_map_root", dynlib: libsass.}
# proc set_c_headers*(options: ptr Options; c_headers: Importer_List) {.
#     importc: "sass_option_set_c_headers", dynlib: libsass.}
# proc set_c_importers*(options: ptr Options; c_importers: Importer_List) {.
#     importc: "sass_option_set_c_importers", dynlib: libsass.}
# proc set_c_functions*(options: ptr Options; c_functions: Function_List) {.
#     importc: "sass_option_set_c_functions", dynlib: libsass.}
##  Getters for Sass_Context values

proc get_output_string*(ctx: ptr Context): cstring {.
    importc: "sass_context_get_output_string", dynlib: libsass.}
proc get_error_status*(ctx: ptr Context): cint {.
    importc: "sass_context_get_error_status", dynlib: libsass.}
proc get_error_json*(ctx: ptr Context): cstring {.
    importc: "sass_context_get_error_json", dynlib: libsass.}
proc get_error_text*(ctx: ptr Context): cstring {.
    importc: "sass_context_get_error_text", dynlib: libsass.}
proc get_error_message*(ctx: ptr Context): cstring {.
    importc: "sass_context_get_error_message", dynlib: libsass.}
proc get_error_file*(ctx: ptr Context): cstring {.
    importc: "sass_context_get_error_file", dynlib: libsass.}
proc get_error_src*(ctx: ptr Context): cstring {.
    importc: "sass_context_get_error_src", dynlib: libsass.}
proc get_error_line*(ctx: ptr Context): csize {.
    importc: "sass_context_get_error_line", dynlib: libsass.}
proc get_error_column*(ctx: ptr Context): csize {.
    importc: "sass_context_get_error_column", dynlib: libsass.}
proc get_source_map_string*(ctx: ptr Context): cstring {.
    importc: "sass_context_get_source_map_string", dynlib: libsass.}
proc get_included_files*(ctx: ptr Context): cstringArray {.
    importc: "sass_context_get_included_files", dynlib: libsass.}
##  Getters for options include path array

proc get_include_path_size*(options: ptr Options): csize {.
    importc: "sass_option_get_include_path_size", dynlib: libsass.}
proc get_include_path*(options: ptr Options; i: csize): cstring {.
    importc: "sass_option_get_include_path", dynlib: libsass.}
##  Calculate the size of the stored null terminated array

proc get_included_files_size*(ctx: ptr Context): csize {.
    importc: "sass_context_get_included_files_size", dynlib: libsass.}
##  Take ownership of memory (value on context is set to 0)

proc take_error_json*(ctx: ptr Context): cstring {.
    importc: "sass_context_take_error_json", dynlib: libsass.}
proc take_error_text*(ctx: ptr Context): cstring {.
    importc: "sass_context_take_error_text", dynlib: libsass.}
proc take_error_message*(ctx: ptr Context): cstring {.
    importc: "sass_context_take_error_message", dynlib: libsass.}
proc take_error_file*(ctx: ptr Context): cstring {.
    importc: "sass_context_take_error_file", dynlib: libsass.}
proc take_output_string*(ctx: ptr Context): cstring {.
    importc: "sass_context_take_output_string", dynlib: libsass.}
proc take_source_map_string*(ctx: ptr Context): cstring {.
    importc: "sass_context_take_source_map_string", dynlib: libsass.}
proc take_included_files*(ctx: ptr Context): cstringArray {.
    importc: "sass_context_take_included_files", dynlib: libsass.}
##  Getters for Sass_Compiler options

proc get_state*(compiler: ptr Compiler): Compiler_State {.
    importc: "sass_compiler_get_state", dynlib: libsass.}
proc get_context*(compiler: ptr Compiler): ptr Context {.
    importc: "sass_compiler_get_context", dynlib: libsass.}
proc get_options*(compiler: ptr Compiler): ptr Options {.
    importc: "sass_compiler_get_options", dynlib: libsass.}
proc get_import_stack_size*(compiler: ptr Compiler): csize {.
    importc: "sass_compiler_get_import_stack_size", dynlib: libsass.}
# proc get_last_import*(compiler: ptr Compiler): Import_Entry {.
#     importc: "sass_compiler_get_last_import", dynlib: libsass.}
# proc get_import_entry*(compiler: ptr Compiler; idx: csize): Import_Entry {.
#     importc: "sass_compiler_get_import_entry", dynlib: libsass.}
proc get_callee_stack_size*(compiler: ptr Compiler): csize {.
    importc: "sass_compiler_get_callee_stack_size", dynlib: libsass.}
# proc get_last_callee*(compiler: ptr Compiler): Callee_Entry {.
#     importc: "sass_compiler_get_last_callee", dynlib: libsass.}
# proc get_callee_entry*(compiler: ptr Compiler; idx: csize): Callee_Entry {.
#     importc: "sass_compiler_get_callee_entry", dynlib: libsass.}
##  Push function for import extenions

proc push_import_extension*(options: ptr Options; ext: cstring) {.
    importc: "sass_option_push_import_extension", dynlib: libsass.}
##  Push function for paths (no manipulation support for now)

proc push_plugin_path*(options: ptr Options; path: cstring) {.
    importc: "sass_option_push_plugin_path", dynlib: libsass.}
proc push_include_path*(options: ptr Options; path: cstring) {.
    importc: "sass_option_push_include_path", dynlib: libsass.}
##  Resolve a file via the given include paths in the sass option struct
##  find_file looks for the exact file name while find_include does a regular sass include

proc find_file*(path: cstring; opt: ptr Options): cstring {.importc: "sass_find_file",
    dynlib: libsass.}
proc find_include*(path: cstring; opt: ptr Options): cstring {.
    importc: "sass_find_include", dynlib: libsass.}
##  Resolve a file relative to last import or include paths in the sass option struct
##  find_file looks for the exact file name while find_include does a regular sass include

proc find_file*(path: cstring; compiler: ptr Compiler): cstring {.
    importc: "sass_compiler_find_file", dynlib: libsass.}
proc find_include*(path: cstring; compiler: ptr Compiler): cstring {.
    importc: "sass_compiler_find_include", dynlib: libsass.}