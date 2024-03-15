#once

#subruledef register
{
    r{num: u7} =>
    {
        assert(num < 0x50)
        num
    }
    %r{num: u7} =>
    {
        assert(num < 0x50)
        num
    }
    alu_b => 0x50`7
    %alu_b => 0x50`7
    alu_flags => 0x51`7
    %alu_flags => 0x51`7
    alu_o => 0x52`7
    %alu_o => 0x52`7
    r_null => 0x5F`7
    %r_null => 0x5F`7
    ri{num: u4} => 0x6`3 @ num
    %ri{num: u4} => 0x6`3 @ num
    i{num: u4} => 0x7`3 @ num
    %i{num: u4} => 0x7`3 @ num
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

#subruledef suppress_flags
{
    - => 0b0
    {} => 0b1
}

#subruledef update_ext_flags
{
    # => 0b1
    {} => 0b0
}

#subruledef size
{
    h => 0x0
    x => 0x1
    d => 0x2
    q => 0x3
    _{num: u4}s => 
    {
        assert(num < 12)
        (num + 4)`4
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

#fn from_ra(relative_address) => relative_address + $

#subruledef operation
{
    and => 0x01`6
    or => 0x02`6
    xor => 0x03`6
    add => 0x04`6
    sub => 0x05`6
    adc => 0x06`6
    sbb => 0x07`6
    shl => 0x08`6
    rol => 0x09`6
    lshr => 0x0A`6
    ashr => 0x0B`6
    ror => 0x0C`6
    rcr => 0x0D`6
    popcnt => 0x0E`6
    grev => 0x0F`6
    load => 0x10`6
    ; store => 0x11`6 ; skipped because of special argument handling
}

#subruledef common_suffix_most
{
    {eoi: end_of_instruction}{js: jmpseg}{ef: update_ext_flags} => js @ eoi @ 0b0 @ ef
}

#subruledef common_suffix_jmp
{
    {ef: update_ext_flags} => 0b000 @ ef
}


#subruledef instruction
{
    ; mov
    {cs: common_suffix_most}mov{s: signed}{sz: size} {dst: register}, {src: register} => cs @ dst @ 0x00`6 @ src @ sz @ s @ 0b000

    ; ldc
    {cs: common_suffix_most}ldc{s: signed}{sz: size} {dst: register}, {imm: i13} => cs @ dst @ imm @ sz @ s @ 0b001

    ; alu + other operations
    {cs: common_suffix_most}{sf: suppress_flags}{op: operation}{sz: size} {dst: register}, {src: register} => cs @ dst @ op @ src @ sz @ sf @ 0b010
    {cs: common_suffix_most}{sf: suppress_flags}store{sz: size} {src: register} => cs @ 0x5F`7 @ 0x11`6 @ src @ sz @ sf @ 0b010

    ; read_port
    {cs: common_suffix_most}read_port {port: u4}, {dst: register} => cs @ dst @ 0x0000`13 @ port @ 0b0 @ 0b011

    ; write_port reg
    {cs: common_suffix_most}write_port {port: u4}, {src: register} => cs @ 0x0000`13 @ src @ port @ 0b0 @ 0b100

    ; write_port imm
    {cs: common_suffix_most}write_port {port: u4}, {imm: i20} => cs @ imm @ port @ 0b0 @ 0b101

    ; reg jump
    {cs: common_suffix_jmp}{j: jump_name} {target: register} => cs @ 0x0000`13 @ target @ j @ 0b110

    ; immediate jump
    {cs: common_suffix_jmp}{j: jump_name} {address: i20} => cs @ (address - $)`20 @ j @ 0b111
    
    ; nop
    {cs: common_suffix_most}nop => cs @ 0x5F`7 @ 0x0`6 @ 0x5F`7 @ 0x00
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
