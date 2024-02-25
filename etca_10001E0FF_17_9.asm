#include "microcode-defs.asm"

#alias %bp                  = %r5
#alias %sp                  = %r6
#alias %ln                  = %r7

#alias %scratch_0           = %r32
#alias %scratch_1           = %r33
#alias %mm_address          = %r34

#alias %cr_int_pc           = %r48
#alias %cr_int_ret_pc       = %r49
#alias %cr_int_mask         = %r50
#alias %cr_int_pending      = %r51
#alias %cr_int_cause        = %r52
#alias %cr_int_data         = %r53
#alias %cr_int_scratch_0    = %r54
#alias %cr_int_scratch_1    = %r55
#alias %cr_int_ret_priv     = %r56

#alias %r_a                 = %ri0
#alias %r_b                 = %ri1
#alias %r_base              = %ri2
#alias %r_index             = %ri3
#alias %r_argb              = %ri4

#alias %r_ss                = %i0
#alias %r_addr_ss           = %i1
#alias %r_op_size_bytes     = %i2
#alias %r_scale             = %i3
#alias %r_imm               = %i4
#alias %r_mem_imm           = %i5
#alias %r_next_instr_addr   = %i6
#alias %r_instr_size        = %i7

#const port_ip              = 0
#const port_flags           = 1
#const port_priv            = 2
#const port_address_mode    = 3
#const port_no_cache_start  = 4
#const port_no_cache_end    = 5

#const cache_line_size      = 32

address_calc:
.base_index_disp:
        movzh %alu_b, %r_scale
        shl_1s %alu_b, %r_index
        add_1s %alu_b, %r_mem_imm
    @   add_1s %mm_address, %r_base
.base_index:
        movzh %alu_b, %r_scale
        shl_1s %alu_b, %r_index
    @   add_1s %mm_address, %r_base
.base_disp:
        movs_1s %alu_b, %r_mem_imm
    @   add_1s %mm_address, %r_base
.index_disp:
        movzh %alu_b, %r_scale
        shl_1s %alu_b, %r_index
    @   add_1s %mm_address, %r_mem_imm
.base:
    @   movs_1s %mm_address, %r_base
.index:
        movzh %alu_b, %r_scale
    @   shl_1s %mm_address, %r_index
.disp:
    @   movs_1s %mm_address, %r_mem_imm

reg_reg_imm:
.add:
     *  movs_0s %alu_b, %r_argb
   !  # add_0s %r_a, %r_a
.sub:
     *  movs_0s %alu_b, %r_argb
   !  # sub_0s %r_a, %r_a
.rsub:
     *  movs_0s %alu_b, %r_a
   !  # sub_0s %r_a, %r_argb
.cmp:
     *  movs_0s %alu_b, %r_argb
   !  # sub_0s %r_null, %r_a
.or:
     *  movs_0s %alu_b, %r_argb
   !  # or_0s %r_a, %r_a
.xor:
     *  movs_0s %alu_b, %r_argb
   !  # xor_0s %r_a, %r_a
.and:
     *  movs_0s %alu_b, %r_argb
   !  # and_0s %r_a, %r_a
.test:
     *  movs_0s %alu_b, %r_argb
   !  # and_0s %r_null, %r_a
.movz:
   ! *  movz_0s %r_a, %r_argb
.movs:
   ! *  movs_0s %r_a, %r_argb
.load:
   ! *  load_0s %r_a, %r_argb
.store:
        movs_0s %alu_b, %r_a
   ! *  store_0s %r_argb
.pop: ; NOTE: b argument can never be an immediate
     *  load_0s %scratch_0, %r_b
        movzh %alu_b, %r_op_size_bytes
        add_1s %r_b, %r_b
   !    movs_0s %r_a, %scratch_0
.push:
     *  movzh %alu_b, %r_op_size_bytes
        sub_1s %scratch_0, %r_a
        movs_0s %alu_b, %r_argb
        store_0s %scratch_0
   !    movs_1s %r_a, %scratch_0
.adc:
     *  movs_0s %alu_b, %r_argb
   !  # adc_0s %r_a, %r_a
.sbb:
     *  movs_0s %alu_b, %r_argb
   !  # sbb_0s %r_a, %r_a
.rsbb:
     *  movs_0s %alu_b, %r_a
   !  # sbb_0s %r_a, %r_argb
.ashr:
     *  movs_0s %alu_b, %r_argb
   !  # ashr_0s %r_a, %r_a
.rol:
     *  movzh %alu_b, %r_argb
   !  # rol_0s %r_a, %r_a
.ror:
     *  movzh %alu_b, %r_argb
   !  # ror_0s %r_a, %r_a
.shl:
     *  movzh %alu_b, %r_argb
   !  # shl_0s %r_a, %r_a
.shr:
     *  movzh %alu_b, %r_argb
   !  # lshr_0s %r_a, %r_a
.rcl:
     *  movs_0s %alu_b, %r_argb
   !  # adc_0s %r_a, %alu_b
.rcr:
   ! *# rcr_0s %r_a, %r_argb
.popcnt:
   ! *# popcnt_0s %r_a, %r_argb
.grev:
     *  movs_0s %alu_b, %r_argb
   !  # grev_0s %r_a, %r_a
.clz:
        ldcsh %alu_b, -1
        grev_0s %scratch_1, %r_argb
        jmp .ctz.common
.ctz: ; NOTE: relies on popcnt setting carry when input = -1
        movs_0s %scratch_1, %r_argb
..common:
     *  movs_0s %alu_b, %scratch_1
        sub_0s %scratch_0, %r_null
        and_0s %scratch_0, %scratch_1
        ldczh %alu_b, 1
        sub_0s %scratch_0, %scratch_0
   !  # popcnt_0s %r_a, %scratch_0
.not:
     *  ldcsh %alu_b, -1
   !  # xor_0s %r_a, %r_argb
.andn:
     *  ldcsh %alu_b, -1
        xor_0s %alu_b, %r_a
   !  # and_0s %r_a, %r_argb
.lsb:
     *  movs_0s %alu_b, %r_argb
        sub_0s %alu_b, %r_null
   !  # and_0s %r_a, %r_argb
.lsbmsk: ; NOTE: carry is handled by `xor` lining up with `sbb`
     *  ldczh %alu_b, 1
        sub_0s %alu_b, %r_argb
   !  # xor_0s %r_a, %r_argb
.rlsb: ; NOTE: carry is handled by `and` lining up with `sub`
     *  ldczh %alu_b, 1
        sub_0s %alu_b, %r_argb
   !  # and_0s %r_a, %r_argb
.zhib:
     *  ldczh %alu_b, 3
        shlh %scratch_0, %r_op_size_bytes
        movzh %alu_b, %r_argb
        subh %r_null, %scratch_0
        jbe ..saturate
        ldczh %scratch_0, 1
        shlq %scratch_0, %scratch_0
        ldczh %alu_b, 1
        subq %alu_b, %scratch_0
   !  # and_0s %r_a, %r_a
..saturate:
        ldczh %alu_b, 0
        add_0s %r_a, %r_a
        ldczh %alu_b, 0x4
       -orh %alu_flags, %alu_flags
   !  # nop

imm_only:
.slo:
     *  ldczh %alu_b, 5
        shl_0s %alu_b, %r_a
   !    or_0s %r_a, %r_imm
.readcr:
        ldczh %alu_b, 4
        subq %r_null, %r_imm
        jb ..skip_priv_check
        ldczh %alu_b, 12
        subq %r_null, %r_imm
        jeq ..skip_priv_check
        ldczh %alu_b, 14
        subq %r_null, %r_imm
        jeq ..skip_priv_check
        ldczh %alu_b, 17
        subq %r_null, %r_imm
        jeq ..skip_priv_check
        ja general_protection_fault     ; invalid control register
        ldczh %alu_b, 1                 ; priviledge check
        read_port port_priv, %scratch_0
        subh %r_null, %scratch_0
        jne general_protection_fault
..skip_priv_check:
     *  ldczh %alu_b, 3
        shlq %scratch_0, %r_imm
        ldczh %alu_b, ..table - $ - 2
        addq %scratch_0, %scratch_0
        jmp %scratch_0
..cpuid1:
        ldczh %alu_b, 26
        ldczx %scratch_0, 0b001_0000_0000_00
        shlq %scratch_0, %scratch_0
        ldczh %alu_b, 13
        ldczx %scratch_1, 0b00_0000_0001_111
        shlq %alu_b, %scratch_1
        orq %scratch_0, %scratch_0
        ldczx %alu_b, 0b0_0000_1111_1111
   !    or_0s %r_a, %scratch_0
#align 32 * 2
..table:
...cpuid1:
        jmp ..cpuid1
#align 32 * 2
...cpuid2:
   !    ldczh %r_a, 0x17
#align 32 * 2
...feat:
   !    ldczh %r_a, 0x9
#align 32 * 2
...flags:
        read_port port_flags, %r_a
   !    movs_0s %r_a, %r_a
#align 32 * 2
...int_pc:
   !    movs_0s %r_a, %cr_int_pc
#align 32 * 2
...int_ret_pc:
   !    movs_0s %r_a, %cr_int_ret_pc
#align 32 * 2
...int_mask:
   !    movs_0s %r_a, %cr_int_mask
#align 32 * 2
...int_pending:
   !    movs_0s %r_a, %cr_int_pending
#align 32 * 2
...int_cause:
   !    movs_0s %r_a, %cr_int_cause
#align 32 * 2
...int_data:
   !    movs_0s %r_a, %cr_int_data
#align 32 * 2
...int_scratch_0:
   !    movs_0s %r_a, %cr_int_scratch_0
#align 32 * 2
...int_scratch_1:
   !    movs_0s %r_a, %cr_int_scratch_1
#align 32 * 2
...priv:
        read_port port_priv, %r_a
   !    movs_0s %r_a, %r_a
#align 32 * 2
...int_ret_priv:
   !    movzh %r_a, %cr_int_ret_priv
#align 32 * 2
...cache_line_size:
   !    ldczh %r_a, cache_line_size
#align 32 * 2
...no_cache_start:
        read_port port_no_cache_start, %r_a
   !    movs_0s %r_a, %r_a
#align 32 * 2
...no_cache_end:
        read_port port_no_cache_end, %r_a
   !    movs_0s %r_a, %r_a
#align 32 * 2
...address_mode:
        read_port port_address_mode, %r_a
   !    movs_0s %r_a, %r_a
.writecr:

general_protection_fault:
unimplemented:
        jmp unimplemented
