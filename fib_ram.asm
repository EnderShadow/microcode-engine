#include "microcode-defs.asm"

ldczh %alu_b, 1
storex %alu_b
ldczh %r0, 1
ldczh %r1, 2
store_loop:
storex %r1
addx %r2, %r0
movzx %r0, %alu_b
ldczh %alu_b, 1
addh %r1, %r1
ldczh %alu_b, 13
subh %r_null, %r1
movzh %alu_b, %r2
jbe store_loop

ldczh %r0, 0
output_loop:
ldczh %alu_b, 1
loadx %r1, %r0
write_port 0, %r1
addh %r0, %r0
ldczh %alu_b, 14
subh %r_null, %r0
jb output_loop
halt:
jmp halt
