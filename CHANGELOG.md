# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.23.6] - 2026-11-21

### Added
- Integrated MicroSIP 3.23.6 status bar dark theme engine and memory safety verification in `StatusBar.h` and `StatusBar.cpp`.
- Modern NSIS installer script (`installer/AbrhaSIP.nsi`) generating standalone Setup executable (`AbrhaSIP-3.23.6-Setup.exe`).
- Portable distribution archive (`AbrhaSIP-3.23.6-portable.zip`) including all audio and codec dependencies.
- Custom application and tray branding icons derived from cloud headset artwork with transparent background de-fringing across multiple resolutions (16x16 to 256x256).

### Changed
- Updated application main icon (`res/microsip.ico`) and disconnected tray icon (`res/tray_inactive.ico`) with new cloud headset identity.
- Updated application version to `3.23.6` in `const.h` and update manifest `update.txt`.
- Locked all Account settings as read-only / disabled in `AccountDlg.cpp` except for Account Name (`IDC_ACCOUNT_LABEL`), Username (`IDC_EDIT_USERNAME`), Login (`IDC_EDIT_AUTHID`), Password (`IDC_EDIT_PASSWORD`), and Display Name (`IDC_EDIT_DISPLAYNAME`).
- Re-routed Blind Transfer action in `MessagesDlg.cpp` to dispatch Asterisk in-call feature code `*2` with destination number via DTMF instead of SIP `REFER`.
- Changed default blind transfer feature code (`featureCodeBT`) in `settings.cpp` to `*2` and enabled feature codes by default (`enableFeatureCodeBT = 1`).
- Linked version checker in `mainDlg.cpp` to custom GitHub repository raw manifest (`https://raw.githubusercontent.com/hamedhdd/AbrhaSIP/main/update.txt`).

### Fixed
- Ensured DTMF feature code dispatch utilizes forced execution (`DTMF(str, true)`) so UI dialer states do not drop transfer requests.

## [3.22.4] - 2026-11-21

### Added
- Linked version checker in `mainDlg.cpp` to custom GitHub repository raw manifest (`https://raw.githubusercontent.com/hamedhdd/AbrhaSIP/main/update.txt`).
- Domain whitelisting for `github.com` and `githubusercontent.com` inside HTTPS URL validation routines.
- `update.txt` manifest format for GitHub release notifications.
- Codebase architecture map `PROJECT_MAP.md` cataloging data flow, controller index, and UI components.

### Changed
- Locked all Account settings as read-only / disabled in `AccountDlg.cpp` except for Account Name (`IDC_ACCOUNT_LABEL`), Username (`IDC_EDIT_USERNAME`), Login (`IDC_EDIT_AUTHID`), Password (`IDC_EDIT_PASSWORD`), and Display Name (`IDC_EDIT_DISPLAYNAME`).
- Re-routed Blind Transfer action in `MessagesDlg.cpp` to dispatch Asterisk in-call feature code `*2` with destination number via DTMF instead of SIP `REFER`.
- Changed default blind transfer feature code (`featureCodeBT`) in `settings.cpp` to `*2` and enabled feature codes by default (`enableFeatureCodeBT = 1`).
- Updated external links in `define.h` (`_GLOBAL_MENU_WEBSITE`, `_GLOBAL_MENU_HELP`, `_GLOBAL_URL_CHECK_VERSION`) to point to the GitHub repository.
- Incremented project version to `3.22.4` in `const.h`.

### Fixed
- Ensured DTMF feature code dispatch utilizes forced execution (`DTMF(str, true)`) so UI dialer states do not drop transfer requests.

## [3.22.3] - 2026-06-21

### Added
- Pre-filled hardcoded connection values (`10.0.124.1:3096`) for SIP Server, SIP Proxy, and Domain when adding new accounts (`AccountDlg.cpp`).
- Enforced read-only state for Server, Proxy, and Domain fields during new account creation.

### Changed
- Brand renamed to `AbrhaSIP` across executable target name and window titles.

### Security
- Locked server and proxy endpoint modifications for newly registered extensions.
- Hidden Auto Answer controls across Settings dialog (`res/dialog.rc2`) and main form dialer (`Dialer.cpp`).
