#include "microcode-defs.asm"

ldczh %r0, 0
ldczh %alu_b, 1
loop:
write_port 0, %r0
addq %r1, %r0
movzq %r0, %alu_b
movzq %alu_b, %r1
jnc loop
halt:
jmp halt
