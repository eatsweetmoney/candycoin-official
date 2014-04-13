Name CandyCoin

RequestExecutionLevel highest
SetCompressor /SOLID lzma


# General Symbol Definitions
!define REGKEY "SOFTWARE\$(^Name)"
!define VERSION 0.8.5.4
!define COMPANY "CandyCoin Foundation"
!define URL http://www.candyco.in/

# MUI Symbol Definitions
!define MUI_ICON "..\share\pixmaps\bitcoin.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "..\share\pixmaps\nsis-wizard.bmp"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP "..\share\pixmaps\nsis-header.bmp"
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_STARTMENUPAGE_REGISTRY_ROOT HKLM
!define MUI_STARTMENUPAGE_REGISTRY_KEY ${REGKEY}
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME StartMenuGroup
!define MUI_STARTMENUPAGE_DEFAULTFOLDER CandyCoin
!define MUI_FINISHPAGE_RUN $INSTDIR\candycoin-qt.exe
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "..\share\pixmaps\nsis-wizard.bmp"
!define MUI_UNFINISHPAGE_NOAUTOCLOSE

# Included files
!include Sections.nsh
!include MUI2.nsh

# Variables
Var StartMenuGroup

# Installer pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuGroup
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

# Installer languages
!insertmacro MUI_LANGUAGE English

# Installer attributes
OutFile candycoin-0.8.5.4-win32-setup.exe
InstallDir $PROGRAMFILES\CandyCoin
CRCCheck on
XPStyle on
BrandingText " "
ShowInstDetails show
VIProductVersion 0.8.5.4
VIAddVersionKey ProductName CandyCoin
VIAddVersionKey ProductVersion "${VERSION}"
VIAddVersionKey CompanyName "${COMPANY}"
VIAddVersionKey CompanyWebsite "${URL}"
VIAddVersionKey FileVersion "${VERSION}"
VIAddVersionKey FileDescription ""
VIAddVersionKey LegalCopyright ""
InstallDirRegKey HKCU "${REGKEY}" Path
ShowUninstDetails show

# Installer sections
Section -Main SEC0000
    SetOutPath $INSTDIR
    SetOverwrite on
    File "..\release\candycoin-qt.exe"
    File /oname=COPYING.txt ..\COPYING
    File /oname=readme.txt ..\doc\README_windows.txt
	File "..\release\icudt51.dll"
	File "..\release\icuin51.dll"
	File "..\release\icuuc51.dll"
	File "..\release\libgcc_s_dw2-1.dll"
	File "..\release\libstdc++-6.dll"
	File "..\release\libwinpthread-1.dll"
	File "..\release\mingwm10.dll"
	File "..\release\Qt5Core.dll"
	File "..\release\Qt5Gui.dll"
	File "..\release\Qt5Network.dll"
	File "..\release\Qt5Widgets.dll"
    SetOutPath $INSTDIR\daemon
    File ..\src\candycoind.exe
    SetOutPath $INSTDIR\src
    File /r /x *.exe /x *.o ..\src\*.*
    SetOutPath $INSTDIR
    WriteRegStr HKCU "${REGKEY}\Components" Main 1

    # Remove old wxwidgets-based-bitcoin executable and locales:
    Delete /REBOOTOK $INSTDIR\CandyCoin.exe
    RMDir /r /REBOOTOK $INSTDIR\locale
SectionEnd

Section -post SEC0001
    WriteRegStr HKCU "${REGKEY}" Path $INSTDIR
    SetOutPath $INSTDIR
    WriteUninstaller $INSTDIR\uninstall.exe
    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    CreateDirectory $SMPROGRAMS\$StartMenuGroup
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\CandyCoin.lnk" $INSTDIR\CandyCoin-qt.exe
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\Uninstall CandyCoin.lnk" $INSTDIR\uninstall.exe
    !insertmacro MUI_STARTMENU_WRITE_END
    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayName "$(^Name)"
    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayVersion "${VERSION}"
    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" Publisher "${COMPANY}"
    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" URLInfoAbout "${URL}"
    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayIcon $INSTDIR\uninstall.exe
    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" UninstallString $INSTDIR\uninstall.exe
    WriteRegDWORD HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoModify 1
    WriteRegDWORD HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoRepair 1
    WriteRegStr HKCR "candycoin" "URL Protocol" ""
    WriteRegStr HKCR "candycoin" "" "URL:CandyCoin"
    WriteRegStr HKCR "candycoin\DefaultIcon" "" $INSTDIR\CandyCoin-qt.exe
    WriteRegStr HKCR "candycoin\shell\open\command" "" '"$INSTDIR\CandyCoin-qt.exe" "%1"'
SectionEnd

# Macro for selecting uninstaller sections
!macro SELECT_UNSECTION SECTION_NAME UNSECTION_ID
    Push $R0
    ReadRegStr $R0 HKCU "${REGKEY}\Components" "${SECTION_NAME}"
    StrCmp $R0 1 0 next${UNSECTION_ID}
    !insertmacro SelectSection "${UNSECTION_ID}"
    GoTo done${UNSECTION_ID}
next${UNSECTION_ID}:
    !insertmacro UnselectSection "${UNSECTION_ID}"
done${UNSECTION_ID}:
    Pop $R0
!macroend

# Uninstaller sections
Section /o -un.Main UNSEC0000
    Delete /REBOOTOK $INSTDIR\CandyCoin-qt.exe
    Delete /REBOOTOK $INSTDIR\COPYING.txt
    Delete /REBOOTOK $INSTDIR\readme.txt
	Delete /REBOOTOK $INSTDIR\icudt51.dll
	Delete /REBOOTOK $INSTDIR\icuin51.dll
	Delete /REBOOTOK $INSTDIR\icuuc51.dll
	Delete /REBOOTOK $INSTDIR\libgcc_s_dw2-1.dll
	Delete /REBOOTOK $INSTDIR\libstdc++-6.dll
	Delete /REBOOTOK $INSTDIR\libwinpthread-1.dll
	Delete /REBOOTOK $INSTDIR\mingwm10.dll
	Delete /REBOOTOK $INSTDIR\Qt5Core.dll
	Delete /REBOOTOK $INSTDIR\Qt5Gui.dll
	Delete /REBOOTOK $INSTDIR\Qt5Network.dll
	Delete /REBOOTOK $INSTDIR\Qt5Widgets.dll
    RMDir /r /REBOOTOK $INSTDIR\daemon
    RMDir /r /REBOOTOK $INSTDIR\src
    DeleteRegValue HKCU "${REGKEY}\Components" Main
SectionEnd

Section -un.post UNSEC0001
    DeleteRegKey HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\Uninstall CandyCoin.lnk"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\CandyCoin.lnk"
    Delete /REBOOTOK "$SMSTARTUP\CandyCoin.lnk"
    Delete /REBOOTOK $INSTDIR\uninstall.exe
    Delete /REBOOTOK $INSTDIR\debug.log
    Delete /REBOOTOK $INSTDIR\db.log
    DeleteRegValue HKCU "${REGKEY}" StartMenuGroup
    DeleteRegValue HKCU "${REGKEY}" Path
    DeleteRegKey /IfEmpty HKCU "${REGKEY}\Components"
    DeleteRegKey /IfEmpty HKCU "${REGKEY}"
    DeleteRegKey HKCR "candycoin"
    RmDir /REBOOTOK $SMPROGRAMS\$StartMenuGroup
    RmDir /REBOOTOK $INSTDIR
    Push $R0
    StrCpy $R0 $StartMenuGroup 1
    StrCmp $R0 ">" no_smgroup
no_smgroup:
    Pop $R0
SectionEnd

# Installer functions
Function .onInit
    InitPluginsDir
FunctionEnd

# Uninstaller functions
Function un.onInit
    ReadRegStr $INSTDIR HKCU "${REGKEY}" Path
    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuGroup
    !insertmacro SELECT_UNSECTION Main ${UNSEC0000}
FunctionEnd
