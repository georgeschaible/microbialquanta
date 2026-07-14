#!/usr/bin/env python3
"""
One-time patch: add Hackaday link support to the Lab Tools section.

Run from the repo root:   python3 patch-hackaday.py
Safe to run twice - it detects existing changes and skips them.

Touches:
  themes/microbialquanta/layouts/lab-tools/list.html
  archetypes/lab-tools.md
"""
import re
import sys
import pathlib
import shutil

ROOT = pathlib.Path.cwd()
LIST = ROOT / "themes/microbialquanta/layouts/lab-tools/list.html"
ARCH = ROOT / "archetypes/lab-tools.md"

BLOCK = """{{{{ with .Params.hackaday_url }}}}
{i}<a href="{{{{ . }}}}" target="_blank" rel="noopener" class="tool-link">
{i}  <span class="link-label">Hackaday</span>
{i}  <span class="link-arrow">&rarr;</span>
{i}</a>
{i}{{{{ end }}}}"""


def fail(msg):
    print(f"  ERROR  {msg}")
    sys.exit(1)


def patch_list():
    if not LIST.exists():
        fail(f"not found: {LIST}")
    src = LIST.read_text()

    if "hackaday_url" in src:
        print("  skip   list.html already has hackaday_url")
        return

    # Find the `{{ with .Params.thingiverse_url }}` line, then the first
    # `{{ end }}` that closes it. Insert our block right after that.
    m = re.search(r"^([ \t]*)\{\{\s*with\s+\.Params\.thingiverse_url\s*\}\}",
                  src, re.M)
    if not m:
        fail("could not find the thingiverse_url block in list.html")

    indent = m.group(1)
    end_re = re.compile(r"^[ \t]*\{\{-?\s*end\s*-?\}\}[ \t]*$", re.M)
    end_m = end_re.search(src, m.end())
    if not end_m:
        fail("could not find the {{ end }} closing the thingiverse block")

    block = "\n" + indent + BLOCK.format(i=indent)
    src = src[:end_m.end()] + block + src[end_m.end():]

    # Widen the `or` guard so the button row still appears for a tool that
    # has ONLY a Hackaday link and nothing else.
    guard = re.search(r"\{\{\s*if\s+or\s+((?:\.Params\.\w+\s*)+)\}\}", src)
    if guard and "hackaday_url" not in guard.group(1):
        src = (src[:guard.start()]
               + guard.group(0).replace("}}", ".Params.hackaday_url }}")
               + src[guard.end():])
        print("  ok     widened the `if or` guard to include hackaday_url")

    shutil.copy(LIST, str(LIST) + ".bak")
    LIST.write_text(src)
    print("  ok     list.html patched (backup: list.html.bak)")


def patch_archetype():
    if not ARCH.exists():
        print(f"  skip   {ARCH} not found, nothing to do")
        return
    src = ARCH.read_text()
    if "hackaday_url" in src:
        print("  skip   archetype already has hackaday_url")
        return
    m = re.search(r"^thingiverse_url:.*$", src, re.M)
    if not m:
        print("  skip   no thingiverse_url line in archetype, add by hand")
        return
    src = src[:m.end()] + '\nhackaday_url: ""' + src[m.end():]
    ARCH.write_text(src)
    print("  ok     archetype patched")


if __name__ == "__main__":
    if not (ROOT / "config").is_dir():
        fail("run this from the repo root (~/microbialquanta)")
    print("Patching Lab Tools for Hackaday links...")
    patch_list()
    patch_archetype()
    print("Done. Run `hugo server -D` to check, then commit.")
