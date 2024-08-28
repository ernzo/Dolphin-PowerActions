# Dolphin-PowerActions 0.1

**Release**: 28 Aug 2024  
**Author**: [ernzo](https://github.com/ernzo)  
**Repository**: [Dolphin-PowerActions](https://github.com/ernzo/Dolphin-PowerActions)

A collection of Action scripts to extend [Dolphin](https://github.com/KDE/dolphin)'s functionality.

## PowerActions Features

- **Extended File Info**: Displays detailed file information.
- **Run in Konsole**: Opens the selected file or directory in Konsole.
- **Run as Admin**: Runs the selected file or directory as an administrator in Konsole.
- **Open as Admin**: Opens a new Dolphin window with elevated privileges.



## Extended File Info

Fully featured; displays a comprehensive list of file information, including:

- **File Name**, **Path**
- **File Type**, **MIME Type**, **Encoding**, **Size**, **Owner**, **Permissions**
- **Version**, **Magic Number**, **MD5 Hash**, **SHA-1 Hash**, **SHA-256 Hash**, **CRC32 Checksum**, **Encryption**, **Extended Attributes**, **Creation Date**, **Last Modification Date**



## Compatibility

Tested and working perfectly on Debian (Trixie) with KDE Plasma/Wayland.

## Installation Instructions

1. **Copy the Scripts:**
   - Copy `fileinfo.sh`, `openasadmin.sh`, `runasadmin.sh`, `xpermission.sh`, and `runinconsole.sh` to `/home/USER/scripts/`.

2. **Copy the Desktop Entries:**
   - Copy `poweractions.desktop`, `fileinfo.desktop`, `runinconsole.desktop`, `runasadmin.desktop`, `openasadmin.desktop`, and `xpermission.desktop` to `/home/USER/.local/share/kservices5/ServiceMenus/`.
   - Alternatively, copy them to `/usr/share/kservices5/ServiceMenus/` for a system-wide application.

3. **Set Permissions:**
   ```bash
   cd /home/USER/scripts
   chmod +x fileinfo.sh openasadmin.sh runasadmin.sh xpermission.sh runinconsole.sh

   cd /home/USER/.local/share/kservices5/ServiceMenus/
   chmod 644 poweractions.desktop fileinfo.desktop runinconsole.desktop runasadmin.desktop openasadmin.desktop xpermission.desktop
