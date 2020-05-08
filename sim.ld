/*

Very simple, hand-generated linker script for RISC-V diag compilation.

*/
OUTPUT_ARCH("riscv")
ENTRY(_start)


SECTIONS
{
  . = 0x80000000;
  .text.init : { *(.text.init) }
  . = ALIGN(0x1000);
  .tohost : { *(.tohost) }
  . = ALIGN(0x1000);
  .text : { *(.text) }
  . = ALIGN(0x1000);
  .data : { *(.data) }
  .bss : { *(.bss) }

  /* nasty: fixed address also in aril.diag.pagetable python */
  . = 0x81000000;
  .pagetable : { *(.pagetable) }
  _end = .;
}
