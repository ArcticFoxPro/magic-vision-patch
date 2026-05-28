; Magic Vision Patch
; Copyright (C) 2026 ArcticFoxPro
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU Affero General Public License as published
; by the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU Affero General Public License for more details.
;
; You should have received a copy of the GNU Affero General Public License
; along with this program.  If not, see <https://www.gnu.org/licenses/>.

Unicode true
SetCompressor /SOLID lzma
SetCompressorDictSize 64
RequestExecutionLevel admin
ShowInstDetails show
InstallDir "$PROGRAMFILES64\HONOR\MagicAnimation"
InstallDirRegKey HKLM "SOFTWARE\HONOR\MagicAnimation" "InstallLocation"
Name "Magic Vision"
OutFile "MagicAnimation_Setup_10.0.0.37.exe"
BrandingText "HONOR Magic Vision Setup"

!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "WinMessages.nsh"
!include "x64.nsh"

Var StartAfterInstall
Var InstallMode

!define PRODUCT_VERSION "10.0.0.37(C233HONOR)"
!define PRODUCT_VERSION_DISPLAY "10.0.0.37"
!define PRODUCT_PKNAME "MagicAnimation_Setup_10.0.0.37(C233HONOR)"

!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"
!define MUI_WELCOMEPAGE_TITLE "Magic Vision 安装向导"
!define MUI_WELCOMEPAGE_TEXT "此程序将引导你完成 Magic视界 的安装。$\r$\n$\r$\n建议在开始安装前关闭其他应用程序。"
!define MUI_FINISHPAGE_RUN "$INSTDIR\Launcher.exe"
!define MUI_FINISHPAGE_RUN_PARAMETERS "start"
!define MUI_FINISHPAGE_RUN_TEXT "运行 Magic视界"
!define MUI_FINISHPAGE_SHOWREADME ""
!define MUI_FINISHPAGE_SHOWREADME_TEXT "创建桌面快捷方式"
!define MUI_FINISHPAGE_SHOWREADME_FUNCTION CreateDesktopShortcut

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "SimpChinese"
!insertmacro MUI_LANGUAGE "English"

Function .onInit
  ${If} ${RunningX64}
    SetRegView 64
  ${Else}
    MessageBox MB_ICONSTOP "此安装包仅支持 64 位 Windows。"
    Abort
  ${EndIf}

  System::Call 'kernel32::CreateMutexW(i 0, i 0, w "MagicVisualsComponentInstall") i .r1 ?e'
  Pop $0
  StrCmp $0 0 +3
    MessageBox MB_ICONSTOP|MB_OK "已有安装程序正在运行，请稍后再试。"
    Abort

  StrCpy $InstallMode "Manual"
  StrCpy $StartAfterInstall "0"

  IfSilent 0 +2
    StrCpy $InstallMode "Silent"

  CreateDirectory "C:\ProgramData\Comms\MagicAnimation\log"
FunctionEnd

Function CreateDesktopShortcut
  SetShellVarContext all
  Delete "$DESKTOP\Magic 视界.lnk"
  Delete "$DESKTOP\Magic Vision.lnk"
  Delete "$DESKTOP\AI Desktop.lnk"
  Delete "$DESKTOP\AI 桌面.lnk"
  SetShellVarContext current
  Delete "$DESKTOP\Magic 视界.lnk"
  Delete "$DESKTOP\Magic Vision.lnk"
  Delete "$DESKTOP\AI Desktop.lnk"
  Delete "$DESKTOP\AI 桌面.lnk"

  ; 为所有用户创建
  SetShellVarContext all
  ${If} $LANGUAGE == 2052
    CreateShortCut "$DESKTOP\Magic 视界.lnk" "$INSTDIR\Launcher.exe" "start" "$INSTDIR\res\icons\main.ico" 0 "" "" "$INSTDIR"
  ${Else}
    CreateShortCut "$DESKTOP\Magic Vision.lnk" "$INSTDIR\Launcher.exe" "start" "$INSTDIR\res\icons\main.ico" 0 "" "" "$INSTDIR"
  ${EndIf}
  SetShellVarContext current
  
  System::Call 'shell32.dll::SHChangeNotify(i 0x08000000, i 0, i 0, i 0)'
FunctionEnd

Function CleanupMagicSpaceShortcut
  SetShellVarContext all
  Delete "$DESKTOP\Magic Space.lnk"
  SetShellVarContext current
  Delete "$DESKTOP\Magic Space.lnk"
  System::Call 'shell32.dll::SHChangeNotify(i 0x08000000, i 0, i 0, i 0)'
FunctionEnd

Function WriteStartupRegistry
  WriteRegStr HKLM "SOFTWARE\HONOR\Setup" "MagicAnimation_Setup" "$EXEDIR\$EXEFILE"
  WriteRegStr HKLM "SOFTWARE\HONOR\ProcessWatchFilter" "MagicVisuals" "MagicVisuals.exe"
  WriteRegStr HKLM "SOFTWARE\HONOR\ProcessWatchFilter" "HonorDesktop" "HonorDesktop.exe"
FunctionEnd

Function InitializeDumpRegistry
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\MagicVisuals.exe" "DumpCount" 10
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\MagicVisuals.exe" "DumpFlags" 0
  WriteRegExpandStr HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\MagicVisuals.exe" "DumpFolder" "C:\ProgramData\Comms\PCManager\werdump"
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\MagicVisuals.exe" "DumpType" 1
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\MagicAnimationService.exe" "DumpCount" 10
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\MagicAnimationService.exe" "DumpFlags" 0
  WriteRegExpandStr HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\MagicAnimationService.exe" "DumpFolder" "C:\ProgramData\Comms\PCManager\werdump"
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\MagicAnimationService.exe" "DumpType" 1
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\capturePic.exe" "DumpCount" 10
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\capturePic.exe" "DumpFlags" 0
  WriteRegExpandStr HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\capturePic.exe" "DumpFolder" "C:\ProgramData\Comms\PCManager\werdump"
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\capturePic.exe" "DumpType" 1
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\WinTransMonitor.exe" "DumpCount" 10
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\WinTransMonitor.exe" "DumpFlags" 0
  WriteRegExpandStr HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\WinTransMonitor.exe" "DumpFolder" "C:\ProgramData\Comms\PCManager\werdump"
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\WinTransMonitor.exe" "DumpType" 1
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\magictaskbar-srv.exe" "DumpCount" 10
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\magictaskbar-srv.exe" "DumpFlags" 0
  WriteRegExpandStr HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\magictaskbar-srv.exe" "DumpFolder" "C:\ProgramData\Comms\PCManager\werdump"
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\magictaskbar-srv.exe" "DumpType" 1
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\magictaskbar-ui.exe" "DumpCount" 10
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\magictaskbar-ui.exe" "DumpFlags" 0
  WriteRegExpandStr HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\magictaskbar-ui.exe" "DumpFolder" "C:\ProgramData\Comms\PCManager\werdump"
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\magictaskbar-ui.exe" "DumpType" 1
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\HonorDesktop.exe" "DumpCount" 10
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\HonorDesktop.exe" "DumpFlags" 0
  WriteRegExpandStr HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\HonorDesktop.exe" "DumpFolder" "C:\ProgramData\Comms\PCManager\werdump"
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\HonorDesktop.exe" "DumpType" 1
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\HonorDesktopMenu.exe" "DumpCount" 10
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\HonorDesktopMenu.exe" "DumpFlags" 0
  WriteRegExpandStr HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\HonorDesktopMenu.exe" "DumpFolder" "C:\ProgramData\Comms\PCManager\werdump"
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\HonorDesktopMenu.exe" "DumpType" 1
FunctionEnd

Function WriteUninstallRegistry
  DeleteRegValue HKLM "SOFTWARE\HONOR\ProcessWatchFilter" "MagicVisuals"
  DeleteRegValue HKLM "SOFTWARE\HONOR\ProcessWatchFilter" "HonorDesktop"
  DeleteRegValue HKLM "SOFTWARE\HONOR\Setup" "MagicAnimation_Setup"

  SetRegView 64
  WriteRegStr HKLM "SOFTWARE\HONOR\MagicAnimation" "MagicAnimationVersion" "${PRODUCT_VERSION}"
  WriteRegStr HKLM "SOFTWARE\HONOR\MagicAnimation" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "SOFTWARE\HONOR\MagicAnimation" "InstallMode" "$InstallMode"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MagicAnimation" "DisplayName" "Magic 视界"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MagicAnimation" "UninstallString" "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MagicAnimation" "DisplayIcon" "$INSTDIR\res\icons\main.ico"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MagicAnimation" "Publisher" "Honor Device Co., Ltd."
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MagicAnimation" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MagicAnimation" "DisplayVersion" "${PRODUCT_VERSION_DISPLAY}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MagicAnimation" "DisplayPkName" "${PRODUCT_PKNAME}"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MagicAnimation" "SystemComponent" 0
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MagicAnimation" "EstimatedSize" 40000
  DeleteRegValue HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MagicAnimation" "NewVersion"
FunctionEnd

Function InstallRetailResources
  nsExec::ExecToLog '"$INSTDIR\Launcher.exe" isRetailComputer'
  Pop $0
  StrCmp $0 1 +3
  RMDir /r "$INSTDIR\res\Retail"
  Return
  IfFileExists "$INSTDIR\res\Retail\*.*" 0 retail_done
  nsExec::ExecToLog '"$INSTDIR\Launcher.exe" copyRetailResources "$INSTDIR\res\Retail" "D:\HONOR Share\Retail"'
  Pop $0
  RMDir /r "$INSTDIR\res\Retail"
retail_done:
FunctionEnd

Function PostInstall
  DetailPrint "执行安装后配置..."

  Call WriteStartupRegistry

  nsExec::ExecToLog '"$INSTDIR\Preinstall\Launcher.exe" "checkEnable"'
  Pop $StartAfterInstall

  nsExec::ExecToLog "$SYSDIR\sc.exe stop MagicAnimationService"
  Pop $0
  nsExec::ExecToLog '"$INSTDIR\Launcher.exe" exit'
  Pop $0
  nsExec::ExecToLog '"$INSTDIR\MonProcessBinary\ProcessMasterUninstall.exe"'
  Pop $0
  nsExec::ExecToLog '"$INSTDIR\Preinstall\Launcher.exe" reNameAllFiles "$INSTDIR" "build/images"'
  Pop $0

  nsExec::ExecToLog '"$INSTDIR\Launcher.exe" checkWebView2'
  Pop $0
  Call InstallRetailResources
  Call InitializeDumpRegistry

  nsExec::ExecToLog '"$INSTDIR\Launcher.exe" stopService'
  Pop $0
  nsExec::ExecToLog '"$INSTDIR\Launcher.exe" refreshSrvBinPath'
  Pop $0
  nsExec::ExecToLog '"$INSTDIR\Launcher.exe" createService'
  Pop $0
  nsExec::ExecToLog 'sc.exe sdset MagicAnimationService D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWRPLOCRRC;;;IU)(A;;CCLCSWLOCRRC;;;SU)'
  Pop $0
  nsExec::ExecToLog "$SYSDIR\sc.exe failure MagicAnimationService reset=86400 actions=restart/1000"
  Pop $0

  nsExec::ExecToLog '"$INSTDIR\Launcher.exe" InstallComponent'
  Pop $0
  nsExec::ExecToLog '"$INSTDIR\Launcher.exe" WaitComponentInstall'
  Pop $0
  RMDir /r "$INSTDIR\ComponentSetup"

  nsExec::ExecToLog '"$INSTDIR\Launcher.exe" delMagicSpaceTaskbarRunPin'
  Pop $0
  Call CleanupMagicSpaceShortcut
  nsExec::ExecToLog '"$INSTDIR\Launcher.exe" deleteAllRenameFiles "$INSTDIR"'
  Pop $0
  nsExec::ExecToLog '"$INSTDIR\Launcher.exe" moveDir "$INSTDIR\MagicClaw" "$INSTDIR\..\MagicClaw"'
  Pop $0

  RMDir /r "$INSTDIR\Preinstall"
  Call WriteUninstallRegistry

  StrCmp $StartAfterInstall 1 0 post_done
  nsExec::ExecToLog '"$INSTDIR\Launcher.exe" start'
  Pop $0
post_done:
FunctionEnd

Section "MainSection" SEC01
  SectionIn RO
  SetOutPath "$INSTDIR"
  SetOverwrite on

  !include "files_section.nsh"

  Call PostInstall
SectionEnd
