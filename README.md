# AbrhaSIP

**AbrhaSIP** is a customized, high-performance, lightweight Windows softphone based on the portable MicroSIP VoIP client (powered by PJSIP). It has been tailored for seamless integration with corporate Asterisk PBX deployments and custom enterprise environments.

---

## Key Customizations

1. **Asterisk Feature Transfer Integration (`*2`)**:
   - The Blind Transfer action has been re-engineered to trigger Asterisk's standard transfer feature code (`*2`) via DTMF along with the destination extension.
   - Eliminates SIP `REFER` interoperability problems and matches PBX attended/in-call feature handling directly.

2. **Hardcoded Connection Settings & Hidden Server Fields**:
   - Creating a new SIP account automatically locks and defaults:

   - UI input fields and labels for SIP Server, SIP Proxy, and Domain are completely hidden from both Add Account and Edit Account dialogs (`res/dialog.rc2` and `AccountDlg.cpp`).
   - All connection settings are strictly preserved behind the scenes, and the form layout is compacted so only the relevant editable fields (Account Name, Username, Login, Password, Display Name) and locked auxiliary options appear.

3. **Disabled Auto-Answer (AA)**:
   - Hidden Auto Answer controls from the Settings dialog (`res/dialog.rc2`).
   - Suppressed dynamic Auto Answer toggle creation in the main dialer window (`Dialer.cpp`).

4. **GitHub Release Update Checks**:
   - Replaced default vendor update URL with direct GitHub Release verification (`https://raw.githubusercontent.com/hamedhdd/AbrhaSIP/main/update.txt`).
   - Validates HTTPS update payloads directly against GitHub repositories and prompts users with direct download links to new releases.

5. **Custom Cloud Headset Identity & Multi-Resolution Icons**:
   - Custom application branding (`res/microsip.ico`) with anti-aliased alpha transparency and zero white borders.
   - Multi-resolution icon layers (16x16 up to 256x256) embedded in PE header for high-DPI Windows 10/11 taskbars, start menus, and desktop shortcuts.
   - Matching desaturated tray icon (`res/tray_inactive.ico`) indicating disconnected/unregistered PBX states.

6. **Quick Audio Source Selector on Main Dialer**:
   - Left-clicking the Microphone or Speaker icon beside the volume sliders immediately presents a popup menu listing all available audio input/output devices.
   - The active device is shown with a checkmark and displayed in the button's hover tooltip.
   - Live device switching via `msip_set_sound_device` hot-swaps audio pipelines instantly without disconnecting active calls.
   - Integrated Mute toggle within the menu plus instant right-click mute shortcuts.

---

## Prerequisites & Build Instructions

### Prerequisites
- Windows 10 / 11
- Visual Studio 2022 Community / Professional with:
  - Desktop development with C++
  - C++ MFC for v143 build tools (x86 & x64)
- MSBuild toolset

### Build Steps

1. **Clone Repository**:
   ```powershell
   git clone https://github.com/hamedhdd/AbrhaSIP.git
   cd AbrhaSIP
   ```

2. **Compile Release Binary**:
   Run MSBuild from a Developer PowerShell / Visual Studio Command Prompt:
   ```powershell
   & "C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe" "microsip.vcxproj" /p:Configuration=Release /p:Platform=Win32 /m
   ```

3. **Output Binaries & Packages**:
   - **Standalone Executable**: `Release\AbrhaSIP.exe` (~4.56 MB)
   - **Installer Setup**: `Release\AbrhaSIP-3.23.6-Setup.exe` (~5.22 MB)
   - **Portable Package**: `Release\AbrhaSIP-3.23.6-portable.zip` (~4.89 MB)

4. **Building Installer**:
   Compile the NSIS script using `makensis`:
   ```powershell
   & "C:\Users\Hamed\Desktop\Projects\nsis\makensis.exe" ".\installer\AbrhaSIP.nsi"
   ```

---

## Configuration & Feature Codes

| Action | Code | Implementation |
| :--- | :--- | :--- |
| **Transfer (Blind)** | `*2` | In-band DTMF sequence dispatched to Asterisk with destination digits |
| **Call Pickup** | `**` | Direct directed pickup prefix |
| **SIP Server / Proxy** | `10.0.124.1:3096` | Hardcoded default for newly added accounts |

---

## License
AbrhaSIP is licensed under the GNU General Public License v2 (GPLv2).
