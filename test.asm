#include "microcode-defs.asm"

movzh r1, r2
movsx %r3, %r4
!movzd r5, r6
!movsq alu_a, ri3

movzh %r7, %r15
movsh %r7, %r15
@movzh %r7, %r15
@movsh %r7, %r15
!movzh %r7, %r15
!movsh %r7, %r15
!@movzh %r7, %r15
!@movsh %r7, %r15

jmp 0x0102
