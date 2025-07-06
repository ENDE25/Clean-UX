#!/bin/bash

# Interactive banner
banner() {
    clear
    echo -e "\e[1;36m"
    echo " ██████╗██╗     ███████╗ █████╗ ███╗   ██╗      ██╗   ██╗██╗  ██╗"
    echo "██╔════╝██║     ██╔════╝██╔══██╗████╗  ██║      ██║   ██║╚██╗██╔╝"
    echo "██║     ██║     █████╗  ███████║██╔██╗ ██║█████╗██║   ██║ ╚███╔╝ "
    echo "██║     ██║     ██╔══╝  ██╔══██║██║╚██╗██║╚════╝██║   ██║ ██╔██╗ "
    echo "╚██████╗███████╗███████╗██║  ██║██║ ╚████║      ╚██████╔╝██╔╝ ██╗"
    echo " ╚═════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝       ╚═════╝ ╚═╝  ╚═╝"
    echo -e "                             \e[2mby ENDE\e[0m\n"
}

banner

echo "Starting system cleaning..."

echo "Available cleaning levels:"
echo "  1) Basic        - Clean package cache and temporary package files."
echo "  2) Intermediate - All of the above + remove unnecessary packages and old logs."
echo "  3) Deep         - All of the above + clean /tmp and empty the trash."
echo "  x) Exit         - Cancel and exit without doing anything."
echo -n "Select cleaning level (1/2/3/x): "
read -r level
if [[ "$level" == "x" || "$level" == "X" ]]; then
    echo "Operation cancelled by user."
    exit 0
fi

# Show summary of actions and list files to be deleted according to level
case "$level" in
    1)
        summary="- Clean package cache\n- Clean temporary package files"
        echo -e "\nPackage cache files to be deleted (apt):"
        if command -v apt &> /dev/null; then
            while IFS= read -r file; do echo -e "\e[0;32m$file\e[0m"; done < <(find /var/cache/apt/archives/ -type f)
        elif command -v dnf &> /dev/null; then
            echo "DNF cache files:"
            while IFS= read -r file; do echo -e "\e[0;32m$file\e[0m"; done < <(find /var/cache/dnf/ -type f)
        fi
        ;;
    2)
        summary="- Clean package cache\n- Clean temporary package files\n- Remove unnecessary packages\n- Remove old logs (>30 days)"
        echo -e "\nPackage cache files to be deleted (apt):"
        if command -v apt &> /dev/null; then
            while IFS= read -r file; do echo -e "\e[0;32m$file\e[0m"; done < <(find /var/cache/apt/archives/ -type f)
        elif command -v dnf &> /dev/null; then
            echo "DNF cache files:"
            while IFS= read -r file; do echo -e "\e[0;32m$file\e[0m"; done < <(find /var/cache/dnf/ -type f)
        fi
        echo -e "\nOld logs (>30 days) to be deleted:"
        if command -v apt &> /dev/null || command -v dnf &> /dev/null; then
            while IFS= read -r file; do echo -e "\e[1;33m$file\e[0m"; done < <(sudo find /var/log -name "*.log" -mtime +30)
        fi
        echo -e "\nUnnecessary packages to be removed:"
        if command -v apt &> /dev/null; then
            apt-mark showauto | xargs apt-cache show 2>/dev/null | grep -E '^Package:' | awk '{print $2}' | while IFS= read -r pkg; do echo -e "\e[1;33m$pkg\e[0m"; done
        elif command -v dnf &> /dev/null; then
            dnf repoquery --extras | while IFS= read -r pkg; do echo -e "\e[1;33m$pkg\e[0m"; done
        fi
        ;;
    3)
        summary="- Clean package cache\n- Clean temporary package files\n- Remove unnecessary packages\n- Remove old logs (>30 days)\n- Clean /tmp (files not accessed in 10 days)\n- Empty the trash"
        echo -e "\nPackage cache files to be deleted (apt):"
        if command -v apt &> /dev/null; then
            while IFS= read -r file; do echo -e "\e[0;32m$file\e[0m"; done < <(find /var/cache/apt/archives/ -type f)
        elif command -v dnf &> /dev/null; then
            echo "DNF cache files:"
            while IFS= read -r file; do echo -e "\e[0;32m$file\e[0m"; done < <(find /var/cache/dnf/ -type f)
        fi
        echo -e "\nOld logs (>30 days) to be deleted:"
        if command -v apt &> /dev/null || command -v dnf &> /dev/null; then
            while IFS= read -r file; do echo -e "\e[1;33m$file\e[0m"; done < <(sudo find /var/log -name "*.log" -mtime +30)
        fi
        echo -e "\nUnnecessary packages to be removed:"
        if command -v apt &> /dev/null; then
            apt-mark showauto | xargs apt-cache show 2>/dev/null | grep -E '^Package:' | awk '{print $2}' | while IFS= read -r pkg; do echo -e "\e[1;33m$pkg\e[0m"; done
        elif command -v dnf &> /dev/null; then
            dnf repoquery --extras | while IFS= read -r pkg; do echo -e "\e[1;33m$pkg\e[0m"; done
        fi
        echo -e "\nFiles in /tmp to be deleted (not accessed in 10 days):"
        while IFS= read -r file; do echo -e "\e[1;31m$file\e[0m"; done < <(sudo find /tmp -type f -atime +10)
        echo -e "\nFiles in the trash to be deleted:"
        find ~/.local/share/Trash/ -type f | while IFS= read -r file; do echo -e "\e[1;31m$file\e[0m"; done
        ;;
    *)
        echo "Invalid option. Operation cancelled."
        exit 1
        ;;
esac

echo -e "\nSummary of actions to be performed:\n$summary"
echo -n "Do you want to continue with these actions and delete the listed files? (y/n): "
read -r confirmation
if [[ "$confirmation" != "y" && "$confirmation" != "Y" ]]; then
    echo "Operation cancelled by user."
    exit 0
fi

# Calculate free space before cleaning
disk_before=$(df --output=avail / | tail -1)

# Cleaning function for APT
clean_apt() {
    if [[ "$level" -ge 1 ]]; then
        echo "Cleaning temporary package files..."
        sudo apt clean
        sudo apt autoclean
    fi
    if [[ "$level" -ge 2 ]]; then
        echo "Removing unnecessary packages..."
        sudo apt autoremove --purge -y
        echo "Removing old log files (non-critical)..."
        sudo find /var/log -name "*.log" -mtime +30 -exec rm -f {} \;
    fi
    if [[ "$level" -ge 3 ]]; then
        echo "Deleting temporary files..."
        deleted_tmp=$(sudo find /tmp -type f -atime +10 -print -delete | wc -l)
        echo -e "\e[1;34mFiles deleted from /tmp: $deleted_tmp\e[0m"
        echo "Emptying the trash..."
        trash_dir="$HOME/.local/share/Trash/files"
        if [ -d "$trash_dir" ]; then
            # Improved method: handles spaces in names and avoids sudo
            find "$trash_dir" -type f -print0 | while IFS= read -r -d $'\0' file; do
                if ! rm -f "$file" 2>/dev/null; then
                    # Try to adjust permissions only if necessary
                    chmod u+rw "$file" 2>/dev/null
                    rm -f "$file" 2>/dev/null
                fi
            done
            deleted_trash=$(find "$trash_dir" -type f | wc -l)
            echo -e "\e[1;34mFiles deleted from trash: $deleted_trash\e[0m"
        else
            echo -e "\e[1;34mTrash directory not found.\e[0m"
        fi
    fi
}

# Cleaning function for DNF
clean_dnf() {
    if [[ "$level" -ge 1 ]]; then
        echo "Cleaning temporary package files..."
        sudo dnf clean all
        # Forced cleaning of DNF cache
        echo "Forcing total removal of DNF cache..."
        sudo rm -rf /var/cache/dnf/*
    fi
    if [[ "$level" -ge 2 ]]; then
        echo "Removing unnecessary packages..."
        sudo dnf autoremove -y
        echo "Removing old log files (non-critical)..."
        sudo find /var/log -name "*.log" -mtime +30 -exec rm -f {} \;
    fi
    if [[ "$level" -ge 3 ]]; then
        echo "Deleting temporary files..."
        deleted_tmp=$(sudo find /tmp -type f -atime +10 -print -delete | wc -l)
        echo -e "\e[1;34mFiles deleted from /tmp: $deleted_tmp\e[0m"
        echo "Emptying the trash..."
        trash_dir="$HOME/.local/share/Trash/files"
        if [ -d "$trash_dir" ]; then
            find "$trash_dir" -type f -print0 | while IFS= read -r -d $'\0' file; do
                if ! rm -f "$file" 2>/dev/null; then
                    chmod u+rw "$file" 2>/dev/null
                    rm -f "$file" 2>/dev/null
                fi
            done
            deleted_trash=$(find "$trash_dir" -type f | wc -l)
            echo -e "\e[1;34mFiles deleted from trash: $deleted_trash\e[0m"
        else
            echo -e "\e[1;34mTrash directory not found.\e[0m"
        fi
    fi
}

# Identify package manager
disk_after=""
if command -v apt &> /dev/null; then
    clean_apt
    disk_after=$(df --output=avail / | tail -1)
elif command -v dnf &> /dev/null; then
    clean_dnf
    disk_after=$(df --output=avail / | tail -1)
else
    echo "Could not identify a compatible package manager (APT or DNF)."
    exit 1
fi

# Calculate and show freed space
if [[ -n "$disk_before" && -n "$disk_after" ]]; then
    space_freed=$(( (disk_after - disk_before) * 1024 ))
    if [[ $space_freed -gt 0 ]]; then
        human_freed=$(numfmt --to=iec --suffix=B $space_freed)
        echo -e "\e[1;34mFreed space: $human_freed\e[0m"
    fi
fi

echo -e "\e[1;34mCleaning completed.\e[0m"
