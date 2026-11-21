# AbrhaSIP

**AbrhaSIP** is a customized, high-performance, lightweight Windows softphone based on the portable MicroSIP VoIP client (powered by PJSIP). It has been tailored for seamless integration with corporate Asterisk PBX deployments and custom enterprise environments.

---

## Key Customizations

1. **Asterisk Feature Transfer Integration (`*2`)**:
   - The Blind Transfer action has been re-engineered to trigger Asterisk's standard transfer feature code (`*2`) via DTMF along with the destination extension.
   - Eliminates SIP `REFER` interoperability problems and matches PBX attended/in-call feature handling directly.

2. **Hardcoded Connection Settings for New Accounts**:
   - Creating a new SIP account automatically locks and defaults:
     - **SIP Server**: `10.0.124.1:3096`
     - **SIP Proxy**: `10.0.124.1:3096`
     - **SIP Domain**: `10.0.124.1:3096`
   - UI input fields for these three parameters are rendered read-only for new account dialogs to prevent misconfigurations, while preserving custom credentials for existing account profiles.

3. **Disabled Auto-Answer (AA)**:
   - Hidden Auto Answer controls from the Settings dialog (`res/dialog.rc2`).
   - Suppressed dynamic Auto Answer toggle creation in the main dialer window (`Dialer.cpp`).

4. **GitHub Release Update Checks**:
   - Replaced default vendor update URL with direct GitHub Release verification (`https://raw.githubusercontent.com/hamedhdd/AbrhaSIP/main/update.txt`).
   - Validates HTTPS update payloads directly against GitHub repositories and prompts users with direct download links to new releases.

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
