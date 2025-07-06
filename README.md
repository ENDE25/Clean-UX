# Clean-UX

**Clean-UX** is an advanced, interactive and reliable system cleaning script for Linux, compatible with both APT-based (Debian, Ubuntu) and DNF-based (Fedora, RHEL, etc) systems.

## How to Download and Use Clean-UX from the Command Line

### 1. Download the tool

Clone the repository:

```bash
git clone https://github.com/ENDE25/Clean-UX.git
cd Clean-UX
```

Or download only the script:

```bash
wget https://raw.githubusercontent.com/ENDE25/Clean-UX/main/clean_ux.sh
chmod +x clean_ux.sh
```

### 2. Run Clean-UX

#### As a regular user (recommended for cleaning user files and trash):

```bash
./clean_ux.sh
```

#### With sudo (required for full system cleaning: package cache, logs, /tmp, etc):

```bash
sudo ./clean_ux.sh
```

> **Note:**
> - Running as a regular user will only clean files you have permission to delete (mainly your home directory and trash).
> - Running with `sudo` is necessary to clean system directories (package cache, logs, /tmp, etc) and is required for full cleaning on most systems.

## Main Features

- **Interactive menu**: Select cleaning level (basic, intermediate, deep, exit) with an explanation of each level.
- **Summary and confirmation**: Before execution, shows a summary of actions and a list of files to be deleted, with colors according to the level:
  - Green: basic cleaning
  - Yellow: intermediate cleaning
  - Red: deep cleaning
- **Effective cleaning**:
  - For APT: runs `apt clean`, `apt autoclean`, and `apt autoremove` according to the selected level.
  - For DNF: runs `dnf clean all`, `dnf autoremove` and forcefully deletes the entire cache (`sudo rm -rf /var/cache/dnf/*`) to ensure no residual files remain.
  - Deletes old logs (>30 days), temporary files in `/tmp` (not accessed in 10 days), and empties the user's trash.
- **Permission handling**: Attempts to adjust permissions of stubborn files to ensure their deletion.
- **Final report**: Shows freed space and number of deleted files in blue.
- **Explanations**: If files remain undeleted, explains possible causes (permissions, files in use, etc).

## Cleaning Levels

1. **Basic**: Cleans package cache and temporary package files.
2. **Intermediate**: All of the above + removes unnecessary packages and old logs.
3. **Deep**: All of the above + cleans `/tmp` and empties the trash.

## Requirements

- Bash
- Sudo permissions to clean system caches and logs
- APT or DNF based systems

## Notes

- On DNF systems, cache cleaning is forced to ensure no residual files remain.
- On APT systems, standard cleaning is sufficient and safe.
- The script handles spaces and permissions in file names.

---

Enjoy a clean and optimized system with Clean-UX!
