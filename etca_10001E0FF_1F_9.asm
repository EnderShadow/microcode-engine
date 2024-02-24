#include "microcode-defs.asm"

#alias %bp                  = %r5
#alias %sp                  = %r6
#alias %ln                  = %r7

#alias %scratch_0           = %r32
#alias %scratch_1           = %r33

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
#const port_cache_start     = 4
#const port_cache_end       = 5

address_calc:
.base_index_disp:
        movs_1s %alu_a, %r_index
        movzh %alu_b, %r_scale
        shl_1s %alu_a
        movs_1s %alu_b, %r_mem_imm
        add_1s %alu_a
        movs_1s %alu_b, %r_base
    @   add_1s %alu_a
.base_index:
        movs_1s %alu_a, %r_index
        movzh %alu_b, %r_scale
        shl_1s %alu_a
        movs_1s %alu_b, %r_base
    @   add_1s %alu_a
.base_disp:
        movs_1s %alu_a, %r_mem_imm
        movs_1s %alu_b, %r_base
    @   add_1s %alu_a
.index_disp:
        movs_1s %alu_a, %r_index
        movzh %alu_b, %r_scale
        shl_1s %alu_a
        movs_1s %alu_b, %r_mem_imm
    @   add_1s %alu_a
.base:
    @   movs_1s %alu_a, %r_base
.index:
        movs_1s %alu_a, %r_index
        movzh %alu_b, %r_scale
    @   shl_1s %alu_a
.disp:
    @   movs_1s %alu_a, %r_mem_imm

reg_reg_imm:
.add:
     *  movs_0s %alu_a, %r_a
        movs_0s %alu_b, %r_argb
   !  # add_0s %r_a
.sub:
     *  movs_0s %alu_a, %r_a
        movs_0s %alu_b, %r_argb
   !  # sub_0s %r_a
.rsub:
     *  movs_0s %alu_b, %r_a
        movs_0s %alu_a, %r_argb
   !  # sub_0s %r_a
.cmp:
     *  movs_0s %alu_a, %r_a
        movs_0s %alu_b, %r_argb
   !  # sub_0s %r_null
.or:
     *  movs_0s %alu_a, %r_a
        movs_0s %alu_b, %r_argb
   !  # or_0s %r_a
.xor:
     *  movs_0s %alu_a, %r_a
        movs_0s %alu_b, %r_argb
   !  # xor_0s %r_a
.and:
     *  movs_0s %alu_a, %r_a
        movs_0s %alu_b, %r_argb
   !  # and_0s %r_a
.test:
     *  movs_0s %alu_a, %r_a
        movs_0s %alu_b, %r_argb
   !  # and_0s %r_null
.movz:
   ! *  movz_0s %r_a, %r_argb
.movs:
   ! *  movs_0s %r_a, %r_argb
.load:
     *  movs_0s %alu_a, %r_argb
   !    load_0s %r_a
.store:
     *  movs_0s %alu_a, %r_argb
        movs_0s %alu_b, %r_a
   !    store_0s
.pop:
     *  movs_1s %alu_a, %r_b
        load_0s %scratch_0
        movzh %alu_b, %r_op_size_bytes
        add_1s %r_b
   !    movs_0s %r_a, %scratch_0
.push:
     *  movs_1s %alu_a, %r_a
        movzh %alu_b, %r_op_size_bytes
        sub_1s %alu_a
        movs_0s %alu_b, %r_argb
        store_0s
   !    movs_1s %r_a, %alu_a
.adc:
     *  movs_0s %alu_a, %r_a
        movs_0s %alu_b, %r_argb
   !  # adc_0s %r_a
.sbb:
     *  movs_0s %alu_a, %r_a
        movs_0s %alu_b, %r_argb
   !  # sbb_0s %r_a
.rsbb:
     *  movs_0s %alu_b, %r_a
        movs_0s %alu_a, %r_argb
   !  # sbb_0s %r_a
.ashr:
     *  movs_0s %alu_a, %r_a
        movs_0s %alu_b, %r_argb
   !  # ashr_0s %r_a
.rol:
     *  movs_0s %alu_a, %r_a
        movzh %alu_b, %r_argb
   !  # rol_0s %r_a
.ror:
     *  movs_0s %alu_a, %r_a
        movzh %alu_b, %r_argb
   !  # ror_0s %r_a
.shl:
     *  movs_0s %alu_a, %r_a
        movzh %alu_b, %r_argb
   !  # shl_0s %r_a
.shr:
     *  movs_0s %alu_a, %r_a
        movzh %alu_b, %r_argb
   !  # lshr_0s %r_a
.rcl:
     *  movs_0s %alu_a, %r_argb
        movs_0s %alu_b, %alu_a
   !  # adc_0s %r_a
.rcr:
     *  movs_0s %alu_a, %r_argb
   !  # rcr_0s %r_a
.popcnt:
     *  movs_0s %alu_a, %r_argb
   !  # popcnt_0s %r_a
.grev:
     *  movs_0s %alu_a, %r_a
        movs_0s %alu_b, %r_argb
   !  # grev_0s %r_a
.not:
     *  ldcsh %alu_a, -1
        movs_0s %alu_b, %r_argb
   !  # xor_0s %r_a
.andn:
     *  movs_0s %alu_a, %r_a
        ldcsh %alu_b, -1
        xor_0s %alu_a
        movs_0s %alu_b, %r_argb
   !  # and_0s %r_a
.zhib:
     *  movzh %alu_a, %r_op_size_bytes
        ldczh %alu_b, 3
        shlh %alu_a
        movzh %alu_b, %r_argb
        subh %r_null
        jbe ..saturate
        ldczh %alu_a, 1
        shlq %alu_a
        ldczh %alu_b, 1
        subq %alu_a
        movzq %alu_b, %r_a
   !  # and_0s %r_a
..saturate:
        movsq %alu_a, %r_a
        ldczh %alu_b, 0
        add_0s %r_a
        movzh %alu_a, %alu_flags
        ldczh %alu_b, 0x4
       -orh %alu_flags
   !    write_port port_flags, %alu_flags
