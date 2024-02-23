#!/usr/bin/python3

import sys

def parse_aliases(aliases: list[str]):
    new_aliases = {}
    for alias in aliases:
        name, substitution = alias.split('=')
        name = name.strip()
        substitution = substitution.strip()
        new_aliases[name] = substitution

    return new_aliases

def substitute(text: str, aliases: dict[str, str]):
    for alias, sub in aliases.items():
        text = text.replace(alias, sub)

    return text

def main():
    lines = sys.stdin.read().splitlines()
    code = []
    aliases = []
    for line in list(lines):
        stripped = line.strip()
        if stripped.startswith('#alias'):
            aliases.append(stripped[6:])
        else:
            code.append(line)

    aliases = parse_aliases(aliases)
    for idx, line in enumerate(code):
        code[idx] = substitute(line, aliases)

    for x in code:
        print(x)

if __name__ == "__main__":
    main()
