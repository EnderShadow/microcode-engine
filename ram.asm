#include "microcode-defs.asm"

ldczh %r0, 1
ldczh %alu_b, 0
loop:
storex %alu_b
addh %alu_b, %r0
jnc loop
ldczh %alu_b, 0
output_loop:
loadx %r1, %alu_b
write_port 0, %r1
addh %alu_b, %r0
jnc output_loop
halt:
jmp halt
