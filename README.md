# Dolphin-PowerActions 1.0

**Release**: 28 Aug 2024  
**Author**: [ernzo](https://github.com/ernzo)  
**Repository**: [Dolphin-PowerActions](https://github.com/ernzo/Dolphin-PowerActions)

A collection of Action scripts to extend [Dolphin](https://github.com/KDE/dolphin)'s functionality.

## PowerActions Features

- **Open as Admin**: Opens a new Dolphin window with elevated privileges.
- **Run as Admin**: Runs the selected file as Administrator in Konsole.
- **Run in Konsole**: Runs the selected file in Konsole.
- **Extended File Info**: Displays detailed file information.
- **Add Execute Permission**: Adds Execute Permission to a file.

<p align="center">
  <img src="https://i.imgur.com/lLXSffR.png" alt="Dolphin Ultracopier">
</p>

## Extended File Info

Fully featured; displays a comprehensive list of file information, including:

- **File Name**, **Path**
- **File Type**, **MIME Type**, **Encoding**, **Size**, **Owner**, **Permissions**
- **Version**, **Magic Number**, **MD5 Hash**, **SHA-1 Hash**, **SHA-256 Hash**, **CRC32 Checksum**, **Encryption**, **Extended Attributes**, **Creation Date**, **Last Modification Date**

<p align="center">
  <img src="https://i.imgur.com/1El7FOc.png" alt="Dolphin Ultracopier">
</p>

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
