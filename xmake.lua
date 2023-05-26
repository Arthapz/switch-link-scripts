add_rules("mode.debug", "mode.release")

set_allowedplats("switch")
set_allowedarchs("switch|aarch64")

target("crtn")
    set_kind("static")

    add_files("src/crtn.S")

target("crti")
    set_kind("static")

    add_files("src/crti.S")

    add_deps("crti")
