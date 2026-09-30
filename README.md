# 🔵🔴 Sift

Local HTML client builder.

## Run

```bash
chmod +x ./sift.sh
./sift.sh ./your-file.html
```

Example:

```bash
./sift.sh ./game.html
```

Sift creates `sift-game.html` and a temporary `.sift/` workspace.

### Local modules

Put JavaScript modules you own in:

```
modules/*.js
```

They are inserted into the rebuilt HTML before `</body>`.

Sift only works with local files. It does not download code or try to reconstruct unavailable original source from compiled HTML/WASM.

## Requirements

- Bash
- Python 3
- An HTML file you are authorized to modify
