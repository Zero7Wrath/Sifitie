#!/usr/bin/env bash
set -euo pipefail

BLUE='\033[1;34m'
RED='\033[1;31m'
RESET='\033[0m'

banner() {
  printf '%b\n' "\${BLUE}S I F T\${RESET}"
  printf '%b\n' "\${RED}HTML GHOST CLIENT BUILDER\${RESET}"
  echo
}

usage() { echo "Usage: $0 <input.html>"; }

[[ $# -eq 1 ]] || { usage; exit 2; }
INPUT=$1
[[ -f "$INPUT" ]] || { echo "Error: HTML file not found: $INPUT" >&2; exit 1; }

case "\${INPUT##*.}" in
  html|htm|HTML|HTM) ;;
  *) echo "Error: input must be an HTML file." >&2; exit 1 ;;
esac

ROOT="$(cd "$(dirname "$INPUT")" && pwd)"
INPUT="$ROOT/$(basename "$INPUT")"
NAME="$(basename "$INPUT")"
WORK="$ROOT/.sift"
ASSETS="$WORK/assets"
MODULES="$ROOT/modules"
OUTPUT="$ROOT/sift-$NAME"

banner
printf '%bInput:%b %s\n' "$BLUE" "$RESET" "$INPUT"

rm -rf "$WORK"
mkdir -p "$ASSETS" "$MODULES"

python3 - "$INPUT" "$ASSETS" <<'PY'
import html.parser, os, shutil, sys
from urllib.parse import urlparse, unquote

source, dest = sys.argv[1:3]
base = os.path.dirname(source)

class Parser(html.parser.HTMLParser):
    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        refs = []
        if tag == "script" and attrs.get("src"):
            refs.append(attrs["src"])
        if tag == "link" and attrs.get("href"):
            refs.append(attrs["href"])
        if tag in {"img", "audio", "video", "source"} and attrs.get("src"):
            refs.append(attrs["src"])
        for ref in refs:
            parsed = urlparse(ref)
            if parsed.scheme or parsed.netloc or ref.startswith(("data:", "#")):
                continue
            src = os.path.normpath(os.path.join(base, unquote(parsed.path)))
            if os.path.isfile(src):
                shutil.copy2(src, os.path.join(dest, os.path.basename(src)))
                print("  copied " + os.path.basename(src))

with open(source, encoding="utf-8", errors="replace") as f:
    Parser().feed(f.read())
PY

if compgen -G "$MODULES/*.js" > /dev/null; then
  mkdir -p "$WORK/modules"
  cp "$MODULES"/*.js "$WORK/modules/"
fi

python3 - "$INPUT" "$WORK" "$OUTPUT" <<'PY'
import html, os, sys

source, work, output = sys.argv[1:4]
with open(source, encoding="utf-8", errors="replace") as f:
    text = f.read()

module_dir = os.path.join(work, "modules")
modules = []
if os.path.isdir(module_dir):
    modules = sorted(
        os.path.join(module_dir, f) for f in os.listdir(module_dir)
        if f.endswith(".js") and os.path.isfile(os.path.join(module_dir, f))
    )

injection = ""
for path in modules:
    rel = os.path.relpath(path, os.path.dirname(output)).replace(os.sep, "/")
    injection += '<script src="' + html.escape(rel, quote=True) + '"></script>\n'

lower = text.lower()
if injection and "</body>" in lower:
    idx = lower.rfind("</body>")
    text = text[:idx] + injection + text[idx:]
elif injection:
    text += injection

with open(output, "w", encoding="utf-8") as f:
    f.write(text)

print("Built: " + output)
PY

printf '%bDone.%b\n' "$RED" "$RESET"
printf 'Workspace: %s\n' "$WORK"
printf 'Output:    %s\n' "$OUTPUT"
