# Dolphin-PowerActions 1.7 <img src="https://i.imgur.com/Wg1A3Xp.png" alt="Dolphin PowerActions" width="23" height="23">

**Release**: 28 Aug 2024  
**Author**: [ernzo](https://github.com/ernzo)  
**Repository**: [Dolphin-PowerActions](https://github.com/ernzo/Dolphin-PowerActions)

Collection of Action scripts to extend [Dolphin](https://github.com/KDE/dolphin)'s functionality.

## PowerActions Features

- **Open as Admin**: Opens folder in a new Dolphin window with elevated privileges.
- **Run as Admin**: Runs selected file as Administrator in Konsole.
- **Run in Terminal**: Runs selected file in Terminal.
- **Extended File Info**: Displays detailed file information.
- **Add Execute Permission**: Adds Execute Permission to selected file/s.

<p align="center">
  <img src="https://i.imgur.com/53nWCWD.png" alt="Dolphin PowerActions">
</p>

## Extended File Info

Fully featured; displays a comprehensive list of file information, including:

- **File Name**, **Path**
- **File Type**, **MIME Type**, **Encoding**, **Size**, **Owner**, **Permissions**, **Lock** & **Visibility**
- **Version**, **Magic Number**, **MD5 Hash**, **SHA-1 Hash**, **SHA-256 Hash**, **CRC32 Checksum**, **Encryption**, **Extended Attributes**, **Creation Date**, **Last Modification Date**

<p align="center">
  <img src="https://i.imgur.com/uI9lVy3.png" alt="xfileinfo">
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

4. **Install Dependencies**
   
   Make sure all dependencies required by "Extended File Info" are installed:
   ```bash
   sudo apt-get update
   sudo apt-get install xxd bc rpm snapd exiftool

Changelog
-----------
	1.0 - First release
 	1.1 - Updated file Size fetch method, format & presentation.
  	1.2 - Execution Permission: Added check to retry action with sudo if adding permission fails.
   	1.3 - Extended File Info: Added file Visibility and Lock status, adjusted time/date format.
	Execution Permission: Adjusted process presentation.
	1.4 - Changed "Run in Konsole" command to execute in Terminal emulator, renamed it accordingly;
 	Execution Permission: Added auto window closing countdown.
	1.5 - Changed "Run as Admin" command to execute in Terminal emulator.
	1.6 - Updated XPermissions, "Run in Term" and "Run as Admin" to better handle special paths.
	1.7 - Extended File Info: Added data Caching and limited Entropy estimation to 10MB sample for better performance; 
	improved Encryption detection logic, added Shannon method; improved Version detection method for deb, rpm, snap, appimage packages and exe files; 
	improved Magic Number fetching; streamlined kdialog command formatting, added/improved debugging checks.
