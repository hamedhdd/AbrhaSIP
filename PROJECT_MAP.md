# Living Project Codebase Map: AbrhaSIP (MicroSIP Fork)

## 1. Directory Tree & Component Index

```
MicroSIP-3.22.3-src/
│
├── .gitignore                  # Git ignore rules for build artifacts and temporary files
├── PROJECT_MAP.md              # Living codebase architecture, component map, and data flow
├── README.md                   # Project overview, build instructions, and configuration runbook
├── CHANGELOG.md                # Version history categorized by Keep a Changelog conventions
├── update.txt                  # Update manifest checked by client pointing to GitHub releases
│
├── const.h                     # Global constants, versioning (_GLOBAL_VERSION), and application identity
├── define.h                    # UI layout definitions, URLs, shortcuts, and global feature flags
├── microsip.sln                # Visual Studio solution file
├── microsip.vcxproj            # MSBuild C++ project configuration (Win32 Release/Debug)
├── resource.h                  # Resource identifier definitions (dialogs, controls, menus, icons)
├── main.rc                     # Windows resource script
│
├── res/                        # Visual assets and sub-resource definitions
│   ├── dialog.rc2              # Dialog template resource script (Settings, Transfer, Add, etc.)
│   ├── menu.rc2                # Context and main menu definitions
│   ├── microsip.ico            # Custom application & window icon (Cloud headset branding, 16-256px)
│   ├── tray_inactive.ico       # Offline/unregistered tray icon (Grayscale cloud headset, 16-32px)
│   └── *.ico / *.bmp           # Application and status tray icons
│
├── installer/
│   └── AbrhaSIP.nsi            # NSIS installer definition script (builds standalone setup exe)
│
├── build_icons.py              # Script to build multi-resolution alpha de-fringed Windows icons
│
├── Core Controllers & Views:
│   ├── mainDlg.h / .cpp        # Primary application coordinator, PJSIP lifecycle, background updates
│   ├── Dialer.h / .cpp         # Main softphone dialer tab, DTMF generation, call initiation
│   ├── MessagesDlg.h / .cpp    # Active call manager, messaging tab, call transfer & DTMF feature actions
│   ├── AccountDlg.h / .cpp     # Account setup and editor dialog (Server/Proxy/Domain hidden, locked to 10.0.124.1:3096)
│   ├── Transfer.h / .cpp       # Call transfer popup modal (Attended vs Blind Asterisk Transfer)
│   ├── SettingsDlg.h / .cpp    # Settings configuration dialog (Auto Answer hidden)
│   ├── FeatureCodesDlg.h / .cpp# Feature codes editor modal (** CP, *2 AT/BT)
│   ├── Contacts.h / .cpp       # Contact management tab and phonebook directory
│   ├── Calls.h / .cpp          # Call log history and journal
│   └── ShortcutsDlg.h / .cpp   # Keyboard shortcuts and quick dial keys configuration
│
└── lib/                        # Supporting utility libraries and wrappers
    ├── MSIP.h / .cpp           # PJSIP utility helpers, string conversions, UTF8/Unicode encoders
    ├── Crypto.h / .cpp         # AES encryption helpers for credentials and tokens
    ├── CSVFile.h / .cpp        # CSV import/export utility
    ├── Markup.h / .cpp         # XML parser for directory and presence data
    ├── MessageBoxX.h / .cpp    # Custom themed message boxes
    └── VisualStylesXP.h / .cpp # Windows XP/7/10/11 visual styles wrapper
```

---

## 2. Data & Telemetry Flow

```
[ User Interaction: Transfer Button ]
               │
               ▼
   [ Transfer Dialog (Transfer.cpp) ]
               │ User submits destination number
               ▼
   [ MessagesDlg::CallAction (MessagesDlg.cpp) ]
               │
      action == MSIP_ACTION_TRANSFER (Blind Transfer)
               │
               ▼
   Format Asterisk Transfer DTMF:
   `str = "*2" + number` (e.g. "*2102")
               │
               ▼
   [ Dialer::DTMF (Dialer.cpp) ]
               │ (force = true)
               ▼
   [ msip_call_dial_dtmf (global.cpp) ]
               │
               ▼
   [ pjsua_call_dial_dtmf (PJSIP Engine) ]
               │
               ▼
   Asterisk PBX receives "*2" in-call feature code,
   puts caller on hold, and transfers call to extension.
```

---

## 3. Update Verification Architecture

```
[ Scheduled Timer / Menu: "Check for Updates" ]
                      │
                      ▼
            [ CmainDlg::CheckUpdates ]
                      │
                      ▼
   Fetch: https://raw.githubusercontent.com/hamedhdd/AbrhaSIP/main/update.txt
                      │
                      ▼
         [ CmainDlg::OnUpdateCheckerLoaded ]
                      │
   Validate HTTPS domain: (github.com / githubusercontent.com)
                      │
   Compare Version: `remote_version > _GLOBAL_VERSION`
                      │
         ┌────────────┴────────────┐
         │ (Yes)                   │ (No)
         ▼                         ▼
 Prompt user to update.      Show "No new version found"
 On click Yes:               (if manual check initiated).
 Opens GitHub Releases
 URL in default browser.
```

---

## 4. UI & Form Layout Catalog

| View / Dialog | Resource ID | Description | Customization / Status |
| :--- | :--- | :--- | :--- |
| **Main Softphone Window** | `IDD_MAIN` | Root frame hosting tabs, status bar, and tray icon | Branded as `AbrhaSIP` |
| **Dialer Tab** | `IDD_DIALER` | Numeric keypad, call status, and account indicator | Auto Answer (AA) button hidden |
| **Settings Dialog** | `IDD_SETTINGS` | Audio, network, and application preferences | Auto Answer label, dropdown, options & help hidden (`NOT WS_VISIBLE`) |
| **Account Editor** | `IDD_ACCOUNT` | SIP account registration settings | All fields read-only/disabled except Account Name, Username, Login, Password, and Display Name |
| **Call Transfer Modal** | `IDD_TRANSFER` | Number entry and transfer action selection | Blind Transfer triggers Asterisk `*2` DTMF code |
