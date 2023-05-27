add_rules("mode.debug", "mode.release")

set_allowedplats("switch")
set_allowedarchs("switch|aarch64")

option("objectdir")
    set_default("lib")
    set_showmenu(true)
option_end()

target("switch-support-files")
    set_kind("object")

    add_files("src/*.S")

    add_options("objectdir")

    set_objectdir("$(objectdir)")
