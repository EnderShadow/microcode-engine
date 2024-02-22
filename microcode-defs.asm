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

#subruledef end_of_instruction
{
    ! => 0b1
    {} => 0b0
}

#subruledef jmpseg
{
    @ => 0b1
    {} => 0b0
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
    shl => 0x08
    rol => 0x09
    lshr => 0x0A
    ashr => 0x0B
    ror => 0x0C
    rcr => 0x0D
    popcnt => 0x0E
    grev => 0x0F
    load => 0x10
    ; store => 0x11 ; skipped because of special argument handling
}

#subruledef instruction
{
    ; mov
    {eoi: end_of_instruction}{js: jmpseg}mov{s: signed}{sz: size} {dst: register}, {src: register} => 0x00`6 @ s @ js @ dst @ src @ sz @ eoi @ 0b000

    ; ldc
    {eoi: end_of_instruction}{js: jmpseg}ldc{s: signed}{sz: size} {dst: register}, {imm: u8} => 0x00`6 @ s @ js @ dst @ imm @ sz @ eoi @ 0b001

    ; alu + other operations
    {eoi: end_of_instruction}{js: jmpseg}{op: operation}{sz: size} {dst: register} => 0x00`7 @ js @ dst @ op @ sz @ eoi @ 0b010
    {eoi: end_of_instruction}{js: jmpseg}store{sz: size} => 0x00`7 @ js @ 0xDF @ 0x11 @ sz @ eoi @ 0b010

    ; read_port
    {eoi: end_of_instruction}{js: jmpseg}read_port {port: u4}, {dst: register} => 0x00`7 @ js @ dst @ 0x00 @ port @ eoi @ 0b011

    ; write_port reg
    {eoi: end_of_instruction}{js: jmpseg}write_port {port: u4}, {src: register} => 0x00`7 @ js @ 0x00 @ src @ port @ eoi @ 0b100

    ; write_port imm
    {eoi: end_of_instruction}{js: jmpseg}write_port {port: u4}, {imm: u16} => 0x00`7 @ js @ imm @ port @ eoi @ 0b101

    ; reg jump
    {j: jump_name} {target: register} => 0x0000 @ target @ j @ 0b110

    ; immediate jump
    {j: jump_name} {displacement: i16} => 0x00 @ displacement @ j @ 0b111
    
    ; nop
    nop => 0x0000007F
}

annotated = false

#if annotated
{
    #ruledef
    {
        {i: instruction} => i
    }
}
#else
{
    #ruledef
    {
        {i: instruction} => le(i)
    }
}

#bankdef microcode
{
    #bits 32
    #size 0x10000
    #outp 0
}
