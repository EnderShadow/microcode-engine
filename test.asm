#include "microcode-defs.asm"

movzh r1, r2
movsx %r3, %r4
!movzd r5, r6
!movsq alu_b, ri3

movzh %r7, %r15
movsh %r7, %r15
@movzh %r7, %r15
@movsh %r7, %r15
!movzh %r7, %r15
!movsh %r7, %r15
!@movzh %r7, %r15
!@movsh %r7, %r15

read_port 1, %r2
write_port 3, %r4
write_port 5, 0x9876

addh %r0, %r1
-addh %r0, %r1

!@*#-and_0s %r_null, %r_null

jmp from_ra(0x0102)
