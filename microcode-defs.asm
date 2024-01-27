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

#subruledef size
{
    h => 0b000
    x => 0b001
    d => 0b010
    q => 0b011
    s{num: u2} => 0b1 @ num
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

#subruledef instruction
{
    movz{sz: size} {dst: register}, {src: register} => 0b0 @ sz @ 0x0 @ src @ dst
    movs{sz: size} {dst: register}, {src: register} => 0b1 @ sz @ 0x0 @ src @ dst
    !movz{sz: size} {dst: register}, {src: register} => 0b0 @ sz @ 0x8 @ src @ dst
    !movs{sz: size} {dst: register}, {src: register} => 0b1 @ sz @ 0x8 @ src @ dst

    ldcz{sz: size} {dst: register}, {imm: u8} => 0b0 @ sz @ 0x1 @ imm @ dst
    ldcs{sz: size} {dst: register}, {imm: i8} => 0b1 @ sz @ 0x1 @ imm @ dst
    !ldcz{sz: size} {dst: register}, {imm: u8} => 0b0 @ sz @ 0x9 @ imm @ dst
    !ldcs{sz: size} {dst: register}, {imm: i8} => 0b1 @ sz @ 0x9 @ imm @ dst

    {op: operation}{sz: size} {dst: register} => 0b0 @ sz @ 0x2 @ op @ dst
    !{op: operation}{sz: size} {dst: register} => 0b0 @ sz @ 0xA @ op @ dst
    store{sz: size} => 0b0 @ sz @ 0x2 @ 0x11 @ 0xDF
    !store{sz: size} => 0b0 @ sz @ 0xA @ 0x11 @ 0xDF

    read_port {port: u4}, {dst: register} => port @ 0x3 @ 0x00 @ dst
    !read_port {port: u4}, {dst: register} => port @ 0xB @ 0x00 @ dst

    write_port {port: u4}, {dst: register} => port @ 0x4 @ src @ 0x00
    !write_port {port: u4}, {src: register} => port @ 0xC @ src @ 0x00

    seg{j: jump_name} => j @ 0b101 @ 0x00 @ 0x00

    {j: jump_name} {target: register} => j @ 0b110 @ target @ 0x00

    {j: jump_name} {displacement: i16} => j @ 0b111 @ le(displacement)
    
    nop => 0x7F @ 0x00 @ 0x00
}

pad_to_32_bits = 0

#if pad_to_32_bits == 1
{
    #ruledef
    {
        {instr: instruction} => instr @ 0x00
    }

    #bankdef microcode
    {
        #bits 32
        #size 0x10000
        #outp 0
    }
}
#else
{
    #ruledef
    {
        {instr: instruction} => instr
    }

    #bankdef microcode
    {
        #bits 24
        #size 0x10000
        #outp 0
    }
}
