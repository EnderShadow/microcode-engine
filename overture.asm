#include "microcode-defs.asm"

#alias %r_src               = %ri0

#alias %r_imm               = %i0
#alias %r_minus_one         = %i1

#const port_io              = 0
#const port_ip              = 1

;  !@ #-instruction

read_input:
    @   read_port port_io, %r6
nop_seg:
    @   nop
mov_r0:
   !    movzh %r0, %r_src
mov_r1:
   !    movzh %r1, %r_src
mov_r2:
   !    movzh %r2, %r_src
ldc:
   !    movzh %r0, %r_imm
or:
        movzh %alu_b, %r2
   !    orh %r3, %r1
nand:
        movzh %alu_b, %r2
        andh %alu_b, %r1
   !    xorh %r3, %r_minus_one
nor:
        movzh %alu_b, %r2
        orh %alu_b, %r1
   !    xorh %r3, %r_minus_one
and:
        movzh %alu_b, %r2
   !    andh %r3, %r1
add:
        movzh %alu_b, %r2
   !    addh %r3, %r1
sub:
        movzh %alu_b, %r2
   !    subh %r3, %r1
jmp_prefix:
        movzh %alu_b, %r_null
    @   subh %r_null, %r3
nop:
   !    nop
jeq:
        jne nop
   !    write_port port_ip, %r0
jlt:
        jge nop
   !    write_port port_ip, %r0
jle:
        jgt nop
   !    write_port port_ip, %r0
jmp:
   !    write_port port_ip, %r0
jne:
        jeq nop
   !    write_port port_ip, %r0
jge:
        jlt nop
   !    write_port port_ip, %r0
jgt:
        jle nop
   !    write_port port_ip, %r0
mov_r3:
   !    movzh %r3, %r_src
mov_r4:
   !    movzh %r4, %r_src
mov_r5:
   !    movzh %r5, %r_src
mov_io:
   !    write_port port_io, %r_src
