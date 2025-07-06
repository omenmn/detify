# 📀 Detify

Detify is a CLI tool that automatically downloads your currently playing Spotify track using spotdl, with both manual and auto-download modes.

# Examples

### download

![video](assets/download.mp4)

### auto

![video](assets/auto.mp4)

It supports:

- detify download → download the current track
- detify auto → auto-detect and download new tracks when they change
- detify → run a custom Python script (init.py)
- Tracks saved in your Music folder by default (~/Music)

# 📦 Installation

Run the installer script:

```bash
./install.sh
```

What it does:

- Creates a virtual environment in: ~/.local/share/detify/venv
- Installs dependencies: spotdl, dbus-python
- Copies the init.py script to the app folder
- Installs the detify CLI to /usr/local/bin
- Ensures ~/Music exists

You can now run detify from anywhere.

# 🛠 Usage

## ✅ Download current track

```bash
detify download
```

Calls your `init.py` script to check if the song is already downloaded. If not, downloads it using `spotdl`.

## 🔄 Auto-download when track changes

```bash
detify auto
```

Listens to `playerctl` via `dbus-monitor`, detects track changes, waits to confirm (debounced), and then downloads.

## 🐍 Run custom Python logic

```bash
detify
```

Runs the `init.py` script inside the virtual environment with no arguments.

# 🧪 Dev Workflow

If you're developing locally:

```bash
# Update main script
nano detify

# Update logic
nano init.py

# Re-run installer
./install.sh
```

# 📝 Config

Music folder is stored in:

```bash
~/.local/share/detify/config
```

To change the download directory:

```bash
echo "/custom/path/to/music" > ~/.local/share/detify/config
```

# 📚 Dependencies

Installed via `pip` inside virtualenv:

- [spotdl](https://github.com/spotDL/spotify-downloader) – Spotify downloader
- dbus-python – used for dbus-monitor interaction

System tools needed:

- playerctl
- dbus-monitor
- python3, venv, pip

🧹 Uninstall

```bash
sudo rm /usr/local/bin/detify
rm -rf ~/.local/share/detify
```
