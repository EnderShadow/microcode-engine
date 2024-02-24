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
    for alias, sub in aliases:
        text = text.replace(alias, sub)

    return text

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
    for idx, line in enumerate(code):
        code[idx] = substitute(line, aliases)

    for x in code:
        print(x)

if __name__ == "__main__":
    main()
