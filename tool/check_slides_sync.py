#!/usr/bin/env python3
"""Checks that docs/slides.md and lib/slides/*.dart are in sync.

Compares: slide order, route, drawer number, steps, every quoted on-slide
string, and speaker notes. Run from the project root:

    python3 tool/check_slides_sync.py
"""
import pathlib
import re
import sys

md = pathlib.Path('docs/slides.md').read_text()
main = pathlib.Path('lib/main.dart').read_text()
STR = r"'((?:[^'\\]|\\.)*)'|\"((?:[^\"\\]|\\.)*)\""


def norm_dart(s):
    s = re.sub(r"'\s*\n\s*'", '', s)
    s = re.sub(r'"\s*\n\s*"', '', s)
    s = re.sub(r"""'\s*\n\s*\"""", '', s)
    s = re.sub(r"""\"\s*\n\s*'""", '', s)
    return s.replace("\\'", "'").replace('\\"', '"')


def words(s):
    return re.findall(r"[a-z0-9']+", s.lower())


problems, checked, order = [], 0, []
slides = re.findall(r'^## (\d\d)\. (.*?) \((/[^)]+)\)\n(.*?)(?=^## |\Z)', md, re.S | re.M)
for num, _title, route, body in slides:
    f = pathlib.Path('lib/slides/%s.dart' % route[1:].replace('-', '_'))
    if not f.exists():
        problems.append(f'{num} {route}: missing {f}')
        continue
    raw = f.read_text()
    src = norm_dart(raw)
    if f"route: '{route}'" not in src:
        problems.append(f'{num} {route}: route mismatch')
    m = re.search(r"title: ['\"](\d\d)\. ", src)
    if not m or m.group(1) != num:
        problems.append(f'{num} {route}: drawer number is {m and m.group(1)}')
    md_steps = int(re.search(r'steps: (\d+)', body.split('\n')[0]).group(1))
    d = re.search(r'steps: (\d+),', src)
    if md_steps != (int(d.group(1)) if d else 1):
        problems.append(f'{num} {route}: steps md={md_steps} dart={d and d.group(1)}')
    order.append(re.search(r'class (\w+) extends FlutterDeckSlideWidget', src).group(1))

    for line in body.split('\n'):
        if not line.startswith('- ') or re.match(r'- (notes|todo|verify|graph|table|step \d|speaker info)', line):
            continue
        for q in re.findall(r'"((?:[^"\\]|\\.)*)"', line):
            q = q.replace('\\"', '"')
            if '<' in q:
                continue
            checked += 1
            if q not in src:
                problems.append(f'{num} {route}: on-slide text not in code: {q!r}')

    note = re.search(r'^- notes: (.*)$', body, re.M)
    block = re.search(r'speakerNotes:\s*((?:\s*(?:%s))+)' % STR, raw)
    if note and block:
        code = ''.join(a or b for a, b in re.findall(STR, block.group(1)))
        code = code.replace('\\n', ' ').replace("\\'", "'")
        # Lines appended from verify: / todo: are allowed extras.
        code = ' '.join(p for p in code.split(' - ') if not re.match(r'\s*-?\s*(\[NEEDS VERIFICATION\]|TODO)', p))
        text = re.sub(r'\s*\(「.*?\)\s*$', '', note.group(1))
        if words(text) != words(code):
            problems.append(f'{num} {route}: notes differ\n   md  : {text}\n   code: {code}')

dart_order = re.findall(r'^        (\w+)\(\),$', main, re.M)
if dart_order != order:
    problems.append(f'order mismatch:\n   md  : {order}\n   dart: {dart_order}')

print(f'{len(slides)} slides, {checked} on-slide strings checked')
print('\n'.join(problems) if problems else 'IN SYNC')
sys.exit(1 if problems else 0)
