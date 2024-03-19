#include "microcode-defs.asm"

#alias %sp                  = %r8

#alias %r_src1              = %ri0
#alias %r_src2              = %ri1
#alias %r_arg1              = %ri2
#alias %r_arg2              = %ri3
#alias %r_dst               = %ri4

#alias %r_imm1              = %i0
#alias %r_imm2              = %i1
#alias %r_imm3              = %i2
#alias %r_minus_one         = %i3

#const port_io              = 0
#const port_ip              = 1

;  !@ #-instruction

read_ip:
    @   read_port port_ip, %r6
read_input:
    @   read_port port_io, %r7
write_ip:
        write_port port_ip, %r6
   !    nop
write_output:
   !    write_port port_io, %r7
add:
        movzh %alu_b, %r_arg2
    @   addh %r_dst, %r_arg1
sub:
        movzh %alu_b, %r_arg2
    @   subh %r_dst, %r_arg1
and:
        movzh %alu_b, %r_arg2
    @   andh %r_dst, %r_arg1
or:
        movzh %alu_b, %r_arg2
    @   orh %r_dst, %r_arg1
not:
        movzh %alu_b, %r_minus_one
    @   xorh %r_dst, %r_arg1
xor:
        movzh %alu_b, %r_arg2
    @   xorh %r_dst, %r_arg1
shl:
        movzh %alu_b, %r_arg2
    @   shlh %r_dst, %r_arg1
shr:
        movzh %alu_b, %r_arg2
    @   lshrh %r_dst, %r_arg1
load:
    @   loadh %r_dst, %r_arg1
store:
        movzh %alu_b, %r_arg2
   !    storeh %r_arg1
push:
        ldczh %alu_b, 1
        subh %sp, %sp
        movzh %alu_b, %r_arg2
   !    storeh %sp
pop:
        loadh %r_dst, %sp
        ldczh %alu_b, 1
    @   addh %sp, %sp
call:
        ldczh %alu_b, 1
        subh %sp, %sp
        read_port port_ip, %r6
        ldczh %alu_b, 4
        addh %alu_b, %r6
        write_port port_ip, %r_imm3
   !    storeh %sp
ret:
        loadh %r6, %sp
        ldczh %alu_b, 1
        write_port port_ip, %r6
   !    addh %sp, %sp
jmp_prefix:
        movzh %alu_b, %r_arg2
    @   subh %r_null, %r_arg1
jeq:
        jeq jmp
   !    nop
jne:
        jne jmp
   !    nop
jb:
        jb jmp
   !    nop
jbe:
        jbe jmp
   !    nop
ja:
        ja jmp
   !    nop
jae:
        jae jmp
   !    nop
jmp:
        write_port port_ip, %r_imm3
nop:
   !    nop
