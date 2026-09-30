#!/usr/bin/env bash
set -euo pipefail

BLUE='\033[1;34m'
RED='\033[1;31m'
RESET='\033[0m'

banner() {
  printf '%b\n' "\${BLUE}S I F T\${RESET}"
  printf '%b\n' "\${RED}WASMGC HTML CLIENT BUILDER\${RESET}"
  echo
}

usage() {
  echo "Usage: $0 <input.html>"
}

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
WASM="$WORK/wasm"
MODULES="$ROOT/modules"
OUTPUT="$ROOT/sift-$NAME"

banner
printf '%bInput:%b %s\n' "$BLUE" "$RESET" "$INPUT"

rm -rf "$WORK"
mkdir -p "$ASSETS" "$WASM" "$MODULES"

python3 - "$INPUT" "$ASSETS" "$WASM" <<'PY'
import base64, html.parser, os, re, shutil, sys
from urllib.parse import urlparse, unquote

source, assets, wasm_dir = sys.argv[1:4]
base = os.path.dirname(source)
text = open(source, encoding="utf-8", errors="replace").read()

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
            path = os.path.normpath(os.path.join(base, unquote(parsed.path)))
            if not os.path.isfile(path):
                continue
            name = os.path.basename(path)
            dest = os.path.join(assets, name)
            shutil.copy2(path, dest)
            print("  asset: " + name)
            if name.lower().endswith(".wasm"):
                shutil.copy2(path, os.path.join(wasm_dir, name))
                print("  wasm:  " + name)

Parser().feed(text)

# Detect inline base64 WASM data URLs without executing them.
matches = re.findall(r'data:application/(?:wasm|wasm\+binary);base64,([A-Za-z0-9+/=]+)', text, re.I)
for i, encoded in enumerate(matches, 1):
    try:
        data = base64.b64decode(encoded, validate=True)
    except Exception:
        continue
    if data[:4] == b'\\x00asm':
        name = f"inline-{i}.wasm"
        with open(os.path.join(wasm_dir, name), "wb") as f:
            f.write(data)
        print("  inline WASM: " + name)
PY

WASM_COUNT=$(find "$WASM" -type f -name '*.wasm' | wc -l | tr -d ' ')

if [[ "$WASM_COUNT" -gt 0 ]]; then
  printf '%bWASM modules found:%b %s\n' "$BLUE" "$RESET" "$WASM_COUNT"
  if command -v wasm-tools >/dev/null 2>&1; then
    for file in "$WASM"/*.wasm; do
      echo "  checking $(basename "$file")"
      wasm-tools validate "$file" >/dev/null 2>&1 || \
        echo "  warning: validation failed for $(basename "$file")"
    done
  elif command -v wasm-objdump >/dev/null 2>&1; then
    echo "  wasm-objdump detected; use it to inspect module sections."
  else
    echo "  note: install wasm-tools for local WASM validation."
  fi
else
  echo "No external or inline WASM module was detected in the HTML."
fi

if compgen -G "$MODULES/*.js" > /dev/null; then
  mkdir -p "$WORK/modules"
  cp "$MODULES"/*.js "$WORK/modules/"
fi

python3 - "$INPUT" "$WORK" "$OUTPUT" <<'PY'
import html, os, sys

source, work, output = sys.argv[1:4]
text = open(source, encoding="utf-8", errors="replace").read()

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

open(output, "w", encoding="utf-8").write(text)
print("Built: " + output)
PY

printf '%bDone.%b\n' "$RED" "$RESET"
printf 'Workspace: %s\n' "$WORK"
printf 'WASM:      %s\n' "$WASM"
printf 'Output:    %s\n' "$OUTPUT"
