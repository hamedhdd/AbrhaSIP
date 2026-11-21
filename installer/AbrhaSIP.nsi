; AbrhaSIP NSIS Modern Installer Script
Unicode True

!include "MUI2.nsh"
!include "FileFunc.nsh"

; General Definitions
Name "AbrhaSIP"
Caption "AbrhaSIP 3.23.6 Setup"
OutFile "..\Release\AbrhaSIP-3.23.6-Setup.exe"
InstallDir "$PROGRAMFILES\AbrhaSIP"
InstallDirRegKey HKLM "Software\AbrhaSIP" "InstallDir"
RequestExecutionLevel admin

; Branding and Icons
!define MUI_ICON "..\res\microsip.ico"
!define MUI_UNICON "..\res\microsip.ico"
!define MUI_ABORTWARNING

; Modern UI Pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "..\dist\License.txt"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!define MUI_FINISHPAGE_RUN "$INSTDIR\AbrhaSIP.exe"
!define MUI_FINISHPAGE_RUN_TEXT "Launch AbrhaSIP"
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"

Section "AbrhaSIP Application" SecMain
    SetOutPath "$INSTDIR"
    
    ; Install core application and dependencies
    File "..\dist\AbrhaSIP.exe"
    File /nonfatal "..\dist\SDL2.dll"
    File /nonfatal "..\dist\avcodec-60.dll"
    File /nonfatal "..\dist\avformat-60.dll"
    File /nonfatal "..\dist\avutil-58.dll"
    File /nonfatal "..\dist\swscale-7.dll"
    File /nonfatal "..\dist\lame_enc.dll"
    File /nonfatal "..\dist\hangup.wav"
    File /nonfatal "..\dist\msgin.wav"
    File /nonfatal "..\dist\msgout.wav"
    File /nonfatal "..\dist\ringing.wav"
    File /nonfatal "..\dist\ringing2.wav"
    File /nonfatal "..\dist\ringtone.wav"
    File /nonfatal "..\dist\License.txt"

    ; Store installation folder
    WriteRegStr HKLM "Software\AbrhaSIP" "InstallDir" "$INSTDIR"

    ; Create uninstaller
    WriteUninstaller "$INSTDIR\Uninstall.exe"

    ; Start Menu Shortcuts
    CreateDirectory "$SMPROGRAMS\AbrhaSIP"
    CreateShortcut "$SMPROGRAMS\AbrhaSIP\AbrhaSIP.lnk" "$INSTDIR\AbrhaSIP.exe" "" "$INSTDIR\AbrhaSIP.exe" 0
    CreateShortcut "$SMPROGRAMS\AbrhaSIP\Uninstall AbrhaSIP.lnk" "$INSTDIR\Uninstall.exe" "" "$INSTDIR\Uninstall.exe" 0

    ; Desktop Shortcut
    CreateShortcut "$DESKTOP\AbrhaSIP.lnk" "$INSTDIR\AbrhaSIP.exe" "" "$INSTDIR\AbrhaSIP.exe" 0

    ; Windows Add/Remove Programs Registry Entries
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AbrhaSIP" "DisplayName" "AbrhaSIP"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AbrhaSIP" "DisplayVersion" "3.23.6"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AbrhaSIP" "Publisher" "Abrha"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AbrhaSIP" "DisplayIcon" "$INSTDIR\AbrhaSIP.exe,0"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AbrhaSIP" "UninstallString" "$\"$INSTDIR\Uninstall.exe$\""
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AbrhaSIP" "QuietUninstallString" "$\"$INSTDIR\Uninstall.exe$\" /S"
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AbrhaSIP" "NoModify" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AbrhaSIP" "NoRepair" 1

    ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
    IntFmt $0 "0x%08X" $0
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AbrhaSIP" "EstimatedSize" "$0"
SectionEnd

Section "Uninstall"
    ; Terminate running instance if any
    ExecWait 'taskkill /F /IM AbrhaSIP.exe'

    ; Delete Files
    Delete "$INSTDIR\AbrhaSIP.exe"
    Delete "$INSTDIR\SDL2.dll"
    Delete "$INSTDIR\avcodec-60.dll"
    Delete "$INSTDIR\avformat-60.dll"
    Delete "$INSTDIR\avutil-58.dll"
    Delete "$INSTDIR\swscale-7.dll"
    Delete "$INSTDIR\lame_enc.dll"
    Delete "$INSTDIR\hangup.wav"
    Delete "$INSTDIR\msgin.wav"
    Delete "$INSTDIR\msgout.wav"
    Delete "$INSTDIR\ringing.wav"
    Delete "$INSTDIR\ringing2.wav"
    Delete "$INSTDIR\ringtone.wav"
    Delete "$INSTDIR\License.txt"
    Delete "$INSTDIR\Uninstall.exe"

    ; Remove Shortcuts
    Delete "$SMPROGRAMS\AbrhaSIP\AbrhaSIP.lnk"
    Delete "$SMPROGRAMS\AbrhaSIP\Uninstall AbrhaSIP.lnk"
    RMDir "$SMPROGRAMS\AbrhaSIP"
    Delete "$DESKTOP\AbrhaSIP.lnk"

    ; Remove Registry Keys
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AbrhaSIP"
    DeleteRegKey HKLM "Software\AbrhaSIP"

    RMDir "$INSTDIR"
SectionEnd
