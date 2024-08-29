# Dolphin-PowerActions 1.0 <img src="https://i.imgur.com/Wg1A3Xp.png" alt="Dolphin PowerActions" width="22" height="22">


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
  <img src="https://i.imgur.com/lLXSffR.png" alt="Dolphin PowerActions">
</p>

## Extended File Info

Fully featured; displays a comprehensive list of file information, including:

- **File Name**, **Path**
- **File Type**, **MIME Type**, **Encoding**, **Size**, **Owner**, **Permissions**
- **Version**, **Magic Number**, **MD5 Hash**, **SHA-1 Hash**, **SHA-256 Hash**, **CRC32 Checksum**, **Encryption**, **Extended Attributes**, **Creation Date**, **Last Modification Date**

<p align="center">
  <img src="https://i.imgur.com/1El7FOc.png" alt="xfileinfo">
</p>

## Compatibility

Tested and working perfectly on Debian (Trixie) with KDE Plasma/Wayland.

## Installation Instructions

1. **Copy the Scripts:**
   - Copy `openasadmin.sh`, `runasadmin.sh`, `runinconsole.sh`, `xfileinfo.sh` and `xpermission.sh` to `/home/USER/scripts/PowerActions/`.

2. **Copy the Desktop Entry:**
   - Copy `poweractions.desktop` to `/home/USER/.local/share/kservices5/ServiceMenus/`.
   - Alternatively, copy it to `/usr/share/kservices5/ServiceMenus/` for a system-wide application.

3. **Copy the Icons**
   - Copy `poweractions.png`, `openasadmin.png`, and `xfileinfo.png` to `/usr/share/icons/`

3. **Set Permissions:**
   ```bash
   cd /home/USER/scripts/PowerActions/
   chmod +x openasadmin.sh runasadmin.sh runinconsole.sh xfileinfo.sh xpermission.sh

   cd /home/USER/.local/share/kservices5/ServiceMenus/
   chmod 644 poweractions.desktop

Changelog
-----------
	1.0 - First release
