#once

#subruledef register
{
    r{num: u8} =>
    {
        assert(num < 0xD0)
        num
    }
    %r{num: u8} =>
    {
        assert(num < 0xD0)
        num
    }
    alu_a => 0xD0
    %alu_a => 0xD0
    alu_b => 0xD1
    %alu_b => 0xD1
    alu_flags => 0xD2
    %alu_flags => 0xD2
    alu_o => 0xD3
    %alu_o => 0xD3
    r_null => 0xDF
    %r_null => 0xDF
    ri{num: u4} => 0xE @ num
    %ri{num: u4} => 0xE @ num
    i{num: u4} => 0xF @ num
    %i{num: u4} => 0xF @ num
}

#subruledef signed
{
    z => 0b0
    s => 0b1
}

#subruledef size
{
    h => 0x0
    x => 0x1
    d => 0x2
    q => 0x3
    s{num: u4} => 
    {
        assert(num < 12)
        num + 4
    }
}

#subruledef jump_name
{
    jz => 0x00`5
    je => 0x00`5
    jeq => 0x00`5

    jnz => 0x01`5
    jne => 0x01`5

    jn => 0x02`5

    jnn => 0x03`5

    jc => 0x04`5
    jb => 0x04`5

    jnc => 0x05`5
    jae => 0x05`5

    jo => 0x06`5

    jno => 0x07`5

    jbe => 0x08`5

    ja => 0x09`5

    jl => 0x0A`5
    jlt => 0x0A`5

    jge => 0x0B`5

    jle => 0x0C`5

    jg => 0x0D`5
    jgt => 0x0D`5

    jmp => 0x0E`5

    ; nop => 0x0F`5 ; not a valid jump name

    jau => 0x10`5

    jnau => 0x11`5
}

#subruledef operation
{
    and => 0x01
    or => 0x02
    xor => 0x03
    add => 0x04
    sub => 0x05
    adc => 0x06
    sbb => 0x07
    
    shl => 0x09
    rol => 0x0A
    rcl => 0x0B
    lshr => 0x0C
    ashr => 0x0D
    ror => 0x0E
    rcr => 0x0F
    load => 0x10
    ; store => 0x11 ; skipped because of special argument handling
}

#subruledef has_cf_flag_instruction
{
    mov{s: signed}{sz: size} {dst: register}, {src: register} => 0x00`6 @ s @ 0b0 @ dst @ src @ sz @ 0x0

    ldc{s: signed}{sz: size} {dst: register}, {imm: u8} => 0x00`6 @ s @ 0b0 @ dst @ imm @ sz @ 0x1

    {op: operation}{sz: size} {dst: register} => 0x00 @ dst @ op @ sz @ 0x2
    store{sz: size} => 0x00 @ 0xDF @ 0x11 @ sz @ 0x2

    read_port {port: u4}, {dst: register} => 0x00 @ dst @ 0x00 @ port @ 0x3

    write_port {port: u4}, {dst: register} => 0x0000 @ src @ port @ 0x4
}

#subruledef no_cf_flag_instruction
{
    {j: jump_name} {target: register} => 0x0000 @ target @ j @ 0b110

    {j: jump_name} {displacement: i16} => 0x00 @ displacement @ j @ 0b111
    
    nop => 0x0000007F
}

#subruledef instruction
{
    {instr: has_cf_flag_instruction} => instr
    !{instr: has_cf_flag_instruction} => (instr | 0x0000008)`32 ; no clue why it doesn't know it's 26 bits already
    @{instr: has_cf_flag_instruction} => (instr | 0x1000000)`32
    !@{instr: has_cf_flag_instruction} => (instr | 0x1000008)`32 ; no clue why it doesn't know it's 26 bits already

    {instr: no_cf_flag_instruction} => instr
}

#ruledef
{
    {i: instruction} => le(i)
}

#bankdef microcode
{
    #bits 32
    #size 0x10000
    #outp 0
}
