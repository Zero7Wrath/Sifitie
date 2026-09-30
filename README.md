# 🔵🔴 Ghost Script for EAGLERcraft

<p align="center">
  <img src="https://img.shields.io/badge/GHOST-SCRIPT-1e90ff?style=for-the-badge&labelColor=090b10" alt="Ghost Script">
  <img src="https://img.shields.io/badge/EAGLERcraft-e53935?style=for-the-badge&labelColor=090b10" alt="EAGLERcraft">
  <img src="https://img.shields.io/badge/Linux-111827?style=for-the-badge&logo=linux&logoColor=ffffff" alt="Linux">
</p>

<p align="center">
  <strong>🔵 GHOST SCRIPT 🔴</strong><br>
  <em>A lightweight launcher setup for EAGLERcraft.</em>
</p>

---

## 🔵 Overview

**Ghost Script for EAGLERcraft** is a small, terminal-focused project built around a simple `start.sh` launcher.

The README uses a blue-and-red terminal aesthetic to match the Ghost Script name.

## 🔴 Quick Start

Clone the repository, enter the project directory, then launch:

```bash
git clone https://github.com/Zero7Wrath/Sifitie.git
cd Sifitie

chmod +x ./start.sh
./start.sh
```

### One-command launch

Once you're inside the repository:

```bash
./start.sh
```

---

## 🔵 Features

- 🔵 Simple `start.sh` entry point
- 🔴 EAGLERcraft-focused project branding
- ⚡ Minimal setup
- 🖥️ Terminal-friendly workflow
- 🎨 Blue + red Ghost Script theme
- 📁 Designed to stay easy to modify

---

## 🔴 Project Layout

```text
Sifitie/
├── start.sh        # Main launcher
└── README.md       # Project documentation
```

> If additional files are added later, update this section to keep the layout accurate.

---

## 🔵 Requirements

Before launching, make sure your environment has:

- A Unix-like shell
- Permission to execute shell scripts
- The files required by `start.sh`

Check that the launcher exists:

```bash
ls -la ./start.sh
```

---

## 🔴 Troubleshooting

### Permission denied

If Linux refuses to execute the launcher:

```bash
chmod +x ./start.sh
./start.sh
```

### File not found

Make sure you're in the repository directory:

```bash
pwd
ls -la
```

Then run:

```bash
./start.sh
```

### Shell errors

If the script reports a shell-related error, inspect the first lines with:

```bash
head -n 20 ./start.sh
```

---

## 🔵 Development

Keep launcher logic inside `start.sh` and update this README whenever the setup or required commands change.

For local changes:

```bash
git status
git diff
```

---

## 🔴 Project Identity

```text
╔══════════════════════════════════════╗
║        G H O S T   S C R I P T       ║
║                                      ║
║          EAGLERcraft // CLI          ║
╚══════════════════════════════════════╝
```

**🔵 GHOST** // **🔴 EAGLERcraft**

---

## 🔵 License

No license is currently specified in this repository.

If you intend to distribute the project, add a license file and update this section.

---

<p align="center">
  <strong>🔵 Ghost Script 🔴</strong><br>
  <sub>Keep it simple. Keep it terminal-first.</sub>
</p>
