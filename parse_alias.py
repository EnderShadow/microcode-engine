#!/usr/bin/python3

import sys

def parse_aliases(aliases: list[str]):
    new_aliases = []
    for alias in aliases:
        name, substitution = alias.split('=')
        name = name.strip()
        substitution = substitution.strip()
        new_aliases.append((name, substitution))

    new_aliases.sort(key=lambda x: len(x[0]), reverse=True)

    return new_aliases

def substitute(text: str, aliases: list[(str, str)]):
    used_aliases = set()
    for alias, sub in aliases:
        old_text = text
        text = text.replace(alias, sub)
        if old_text != text:
            used_aliases.add(alias)

    return (text, used_aliases)

def main():
    lines = sys.stdin.read().splitlines()
    code = []
    aliases = []
    for line in list(lines):
        stripped = line.strip()
        if len(stripped) > 6 and stripped.startswith('#alias') and stripped[6].isspace() and stripped.count('=') == 1:
            aliases.append(stripped[7:])
            code.append("")
        else:
            code.append(line)

    aliases = parse_aliases(aliases)
    used_aliases = set()
    for idx, line in enumerate(code):
        code[idx], used = substitute(line, aliases)
        used_aliases.update(used)

    unused_aliases = [x[0] for x in aliases if x[0] not in used_aliases]
    if len(unused_aliases) > 0:
        print('The following aliases are unused:', file=sys.stderr)
        for alias in unused_aliases:
            print(f'\t{alias}', file=sys.stderr)

    for x in code:
        print(x)

if __name__ == "__main__":
    main()
