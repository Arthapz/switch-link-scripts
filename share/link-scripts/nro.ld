OUTPUT_FORMAT(elf64-littleaarch64)
OUTPUT_ARCH(aarch64)
ENTRY(_start)

PHDRS {
	code     PT_LOAD FLAGS(5) /* Read | Execute */;
	rodata   PT_LOAD FLAGS(4) /* Read */;
	data     PT_LOAD FLAGS(6) /* Read | Write */;
	tls      PT_TLS FLAGS(4);
	dyn      PT_DYNAMIC FLAGS(6);
	eh_frame PT_GNU_EH_FRAME;
}

SECTIONS {
	PROVIDE(__start__ = 0x0);
	. = __start__;

    /* code */
	__code_start = . ;

	.text :{
		KEEP (*(.crt0))
		*(.text.unlikely .text.*_unlikely .text.unlikely.*)
		*(.text.exit .text.exit.*)
		*(.text.startup .text.startup.*)
		*(.text.hot .text.hot.*)
		*(.text .stub .text.* .gnu.linkonce.t.*)
		. = ALIGN(8);
	} :code
	.init :{
		KEEP (*(SORT_NONE(.init)))
		. = ALIGN(8);
	} :code
	.plt :{
		*(.plt)
		*(.iplt)
		. = ALIGN(8);
	} :code
	.fini :{
		KEEP (*(SORT_NONE(.fini)))
		. = ALIGN(8);
	} :code

	. = ALIGN(0x1000);

    /* rodata */
	__rodata_start = . ;

	.nx-module-name    : {
		KEEP(*(.nx-module-name))
		. = ALIGN(8);
	} :rodata

	.rodata :{
		*(.rodata .rodata.* .gnu.linkonce.r.*)
	} :rodata
	.eh_frame_hdr     :{
		__eh_frame_hdr_start = .;
		*(.eh_frame_hdr)
		*(.eh_frame_entry .eh_frame_entry.*)
		__eh_frame_hdr_end = .;
	} :rodata :eh_frame
	.eh_frame         : ONLY_IF_RO {
		__eh_frame_start = .;
		KEEP (*(.eh_frame)) *(.eh_frame.*)
		 __eh_frame_end = .;
	} :rodata
	.gcc_except_table : ONLY_IF_RO { *(.gcc_except_table .gcc_except_table.*) } :rodata
	.gnu_extab        : ONLY_IF_RO { *(.gnu_extab*) } :rodata
	.exception_ranges : ONLY_IF_RO { *(.exception_ranges .exception_ranges*) } :rodata

	.dynamic :{
		_DYNAMIC = .;
		*(.dynamic);
	} :rodata :dyn
	.dynsym            : { *(.dynsym) } :rodata
	.dynstr            : { *(.dynstr) } :rodata
	.rela.dyn : { *(.rela.*) } :rodata
	.rela.plt : {
		*(.rela.plt)
		PROVIDE_HIDDEN(__rela_iplt_start = .);
		*(.rela.iplt)
		PROVIDE_HIDDEN(__rela_iplt_end = .);
	} :rodata
	.interp            : { *(.interp) } :rodata
	.hash              : { *(.hash) } :rodata
	.gnu.hash          : { *(.gnu.hash) } :rodata
	.gnu.version       : { *(.gnu.version) } :rodata
	.gnu.version_d     : { *(.gnu.version_d) } :rodata
	.gnu.version_r     : { *(.gnu.version_r) } :rodata
	.note.gnu.build-id : { *(.note.gnu.build-id) } :rodata

	. = ALIGN(0x1000);

	/* data */
	__data_start = .;

	.eh_frame         : ONLY_IF_RW { KEEP (*(.eh_frame)) *(.eh_frame.*) } :data
	.gcc_except_table : ONLY_IF_RW { *(.gcc_except_table .gcc_except_table.*) } :data
	.gnu_extab        : ONLY_IF_RW { *(.gnu_extab*) } :data
	.exception_ranges : ONLY_IF_RW { *(.exception_ranges .exception_ranges*) } :data

      /* tls */
	.tdata ALIGN(8) :{
		__tdata_lma = .;
		*(.tdata .tdata.* .gnu.linkonce.td.*)
		. = ALIGN(8);
		__tdata_lma_end = .;
	} :data :tls

	.tbss ALIGN(8) :{
		*(.tbss .tbss.* .gnu.linkonce.tb.*) *(.tcommon)
	} :tls

	.preinit_array ALIGN(8) :{
		PROVIDE (__preinit_array_start = .);
		KEEP (*(.preinit_array))
		PROVIDE (__preinit_array_end = .);
	} :data
	.init_array ALIGN(8) :{
		PROVIDE(__init_array_start = .);
		KEEP(*(SORT_BY_INIT_PRIORITY(.init_array.*) SORT_BY_INIT_PRIORITY(.ctors.*)))
		KEEP(*(.init_array .ctors) )
		PROVIDE(__init_array_end = .);
	} :data
	.fini_array ALIGN(8) :{
		PROVIDE(__fini_array_start = .);
		KEEP(*(SORT_BY_INIT_PRIORITY(.fini_array.*) SORT_BY_INIT_PRIORITY(.dtors.*)))
		KEEP(*(.fini_array .dtors))
		PROVIDE(__fini_array_end = .);
	} :data

	__got_start__ = .;

	.got     :{ *(.got) *(.igot) } :data
	.got.plt :{ *(.got.plt)  *(.igot.plt) } :data

	__got_end__ = .;

	.data ALIGN(8) :{
		*(.data .data.* .gnu.linkonce.d.*)
		SORT(CONSTRUCTORS)
	} :data

	__bss_start__ = .;
	.bss ALIGN(8) :{
		*(.dynbss)
		*(.bss .bss.* .gnu.linkonce.b.*)
		*(COMMON)
		. = ALIGN(8);

		/* Reserve space for the TLS segment of the main thread */
		__tls_start = .;
		. += SIZEOF(.tdata) + SIZEOF(.tbss);
		__tls_end = .;
	} :data
	__bss_end__ = .;

	. = ALIGN(0x1000);

	__end__ = ABSOLUTE(.);

	. = ALIGN(0x1000);

	__argdata__ = ABSOLUTE(.);

	/* Stabs debugging sections. */
	/DISCARD/ : { *(.group .comment .note) }

	.stab          0 :{ *(.stab) }
	.stabstr       0 :{ *(.stabstr) }
	.stab.excl     0 :{ *(.stab.excl) }
	.stab.exclstr  0 :{ *(.stab.exclstr) }
	.stab.index    0 :{ *(.stab.index) }
	.stab.indexstr 0 :{ *(.stab.indexstr) }

	/* DWARF debug sections.
	   Symbols in the DWARF debugging sections are relative to the beginning
	   of the section so we begin them at 0. */

	/* DWARF 1 */
	.debug          0 :{ *(.debug) }
	.line           0 :{ *(.line) }

	/* GNU DWARF 1 extensions */
	.debug_srcinfo  0 :{ *(.debug_srcinfo) }
	.debug_sfnames  0 :{ *(.debug_sfnames) }

	/* DWARF 1.1 and DWARF 2 */
	.debug_aranges  0 :{ *(.debug_aranges) }
	.debug_pubnames 0 :{ *(.debug_pubnames) }

	/* DWARF 2 */
	.debug_info     0 :{ *(.debug_info) }
	.debug_abbrev   0 :{ *(.debug_abbrev) }
	.debug_line     0 :{ *(.debug_line) }
	.debug_frame    0 :{ *(.debug_frame) }
	.debug_str      0 :{ *(.debug_str) }
	.debug_loc      0 :{ *(.debug_loc) }
	.debug_macinfo  0 :{ *(.debug_macinfo) }
}