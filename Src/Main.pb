; *=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; [D]-Jongg v0.7 (Beta/Demo)
; Developed in 2010 by Guevara-chan.
; *=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

; TO.DO[
; Добавить неудаляемые кубы для сложности.
; Доработать вращение куба по вертикали и приблежение\удаление.
; Проверить проблемы с автообновлением DirectX под Vist'ой.
; Улучшить главное меню.
; ]TO.DO

; --Preparations--
EnableExplicit
Macro InitXors3D() ; Initializer.
IncludeFile "Xors3d.pbi"
EndMacro
Prototype FontLoader(FileName.s, Flag, Dummy)

;{ Definitions
;{ --Constants--
#Title        = "=[D]-Jongg="
#ScreenWidth  = 800
#ScreenHeight = 600
#GUIWidth     = #ScreenWidth 
#GUIHeight    = #ScreenHeight
#GUIRes       = 1024
#AlphaEdge    = 1
#AlphaStep    = 0.05
#DiceTypes    = 6
#DiceColors   = 6
#MaxField     = 8
#MaxFPS       = 40
#Ambient      = 100
#Light        = 205 - #Ambient
#AltLight     = 240 - #Ambient ; For old videocards.
#CFrames      = 12 ; Число кадров у курсора.
#FrameEdge    = 0.7
#BloomRes     = 256
#TrayIcon     = 0
#NoButton     = -1
#MaxYAngle    = 40
#EndGame      = 2
#Hint         = 0.5
#MainWindow   = 0
#SplashWindow = #MainWindow + 1
#GUIScaleX    = #GUIWidth / #ScreenWidth
#GUIScaleY    = #GUIHeight / #ScreenHeight
#RedistURL    = "http://file1.softsea.com/Driver_Update/dxwebsetup.exe"
#DBufferSize  = 1024 ; Downloading buffer's size.
;}
;{ --Enumerations--
Enumeration ; Animations
#aRaising
#aNormal
#aFading
EndEnumeration

Enumeration -1 ; System states
#sMenuToGame
#sGame
#sGameToMenu
#sMainMenu
EndEnumeration

Enumeration ; Menu buttons
#mCube4X
#mCube6X
#mCube8X
#mExit
#MenuButtons = #PB_Compiler_EnumerationValue - 1
EndEnumeration

Enumeration ; Pause modes
#pActive
#pBossKey
#pFocusLost
#pMessageBox
EndEnumeration
;}
;{ --Structures--
Structure Point3D
X.i : Y.i : Z.i
EndStructure

Structure ARGB
B.a : G.A : R.a : A.a
EndStructure

Structure Dice
Pos.Point3D
*Entity
AnimType.i
Frame.f
Type.i
IsHinted.i
StructureUnion
Color.ARGB
ARGB.l
EndStructureUnion
EndStructure

Structure Button
*Image 
Y.i
Width.i
Height.i
EndStructure

Structure SystemData
State.i
Paused.i
SinFeeder.i
; -Input\Output-
FPS.i
Input.i
MousePos.Point
*AppIcon
*Window
XRotation.f
YRotation.f
FontLoader.FontLoader
; -Timing-
Absent.i
*FPSTimer
*TimerFont
StartTime.i
; -GUI-
*Logo
*Cursor
*Camera
*Preview
*BackDrop
*BackTex
*GUIFont
*MenuFont
CFrame.i
ShowHint.i
*PreviewFrame
FrameTurn.i
*GUIPlane
*GUIBuffer
GUIAlpha.f
*PickedButton
*FrameBuffer
MenuButtons.Button[#MenuButtons+1]
; -Dices-
*DiceTex
*DiceMesh
DiceSize.i
*PickedDice.Dice
*ChoosenDice.Dice
ColorsTable.l[#DiceColors]
; -Area-
AreaSize.i
*AreaPiv
Moves.i
*Light
Edge.i
; -Shading-
*PostPoly
*Bloomer
*DiffuseTex
*EmmisiveTex
; -Networking-
NetFileSize.i
NetProgress.i
*NetBuffer
EndStructure
;}
;{ --Variables--
Global System.SystemData
Global NewList Dices.Dice()
Global NewList History.Dice()
Global Dim *DiceMatrix.Dice(#MaxField - 1, #MaxField - 1, #MaxField - 1)
;}
;} EndDefinitions

;{ Procedures
;{ --Math & Logic--
Macro GSin(Angle) ; Pseudo-procedure
Sin(Angle * #PI / 180)
EndMacro

Macro GCos(Angle) ; Pseudo-procedure
Cos(Angle * #PI / 180)
EndMacro

Procedure.f MinF(ValA.f, ValB.f)
If ValA < ValB : ProcedureReturn ValA
Else : ProcedureReturn ValB
EndIf
EndProcedure

Procedure.f MaxF(ValA.f, ValB.f)
If ValA > ValB : ProcedureReturn ValA
Else : ProcedureReturn ValB
EndIf
EndProcedure
;}
;{ --Autoupdating support--
Macro WndW(WindowIDX) ; Shortcut.
WindowWidth(WindowIDX)
EndMacro

Macro WndH(WindowIDX) ; Shortcut.
WindowHeight(WindowIDX)
EndMacro

Macro ShowProgress(BytesRead = System\NetProgress, BytesCount = System\NetFileSize) ; Partializer
SetGadgetText(#StrGadget,"Downloading ("+StrF((BytesRead+0.01)/(BytesCount+0.01)*100,0)+"%)... Please wait.")
EndMacro

Procedure.s URL2Domain (URL.s)
Define.i Pos, PosEnd
Pos = FindString(URL, ":", 1)
If Pos
If Mid(URL, Pos + 1, 2) = "//"
PosEnd = FindString(URL, "/", Pos + 3)
If PosEnd : PosEnd - (Pos + 3)
Else : PosEnd = Len(URL) - (Pos + 2)
EndIf
If PosEnd 
ProcedureReturn Mid(URL, Pos + 3, PosEnd)
EndIf
EndIf
EndIf
EndProcedure

Procedure.s URL2FilePath(URL.s)
Define.i Pos, PosEnd
Pos = FindString(URL, ":", 1)
If Pos
If Mid(URL, Pos + 1, 2) = "//"
PosEnd = FindString(URL, "/", Pos + 3)
If PosEnd
ProcedureReturn Right(URL, Len(URL) - PosEnd + 1)
EndIf
EndIf
EndIf
EndProcedure

Macro OpenNetwork(ID = "DX_Updater") ; Pseudo-procedure.
InternetOpen_(ID, 0, #Null, #Null, 0)
EndMacro

Procedure RequestFileSize(URL.s)
Define Result.i, ResultSize.i = SizeOf(Integer)
Define *Network = OpenNetwork()
Define *Connect = InternetConnect_(*Network, URL2Domain(URL), 80, #Null, #Null, 3, 0, 0)
Define *Request = HttpOpenRequest_(*Connect,"GET",URL2FilePath(URL),0,0,0,2147484160,0)
HttpSendRequest_(*Request, #Null, 0, 0, 0)
HttpQueryInfo_(*Request, $20000000|5, @Result, @ResultSize, #Null)
InternetCloseHandle_(*Request)
InternetCloseHandle_(*Connect)
InternetCloseHandle_(*Network)
ProcedureReturn Result
EndProcedure

Macro OpenSplashWindow() ; Partializer
#SpashFont = 0 : #StrGadget = 0
#FontSize = 16 : #TC = #PB_Text_Center
OpenWindow(#SplashWindow, 0, 0, 230, 20, #Title, #PB_Window_ScreenCentered|#PB_Window_Invisible)
Define *Window = WindowID(#SplashWindow)
SetWindowLong_(*Window,#GWL_STYLE,GetWindowLong_(*Window,#GWL_STYLE)&~#WS_CAPTION|#WS_DLGFRAME)
SetWindowPos_(*Window, 0, 0, 0, 0, 0, #SWP_NOZORDER|#SWP_NOMOVE|#SWP_NOSIZE|#SWP_DRAWFRAME)
SetWindowColor(#SplashWindow, #Black) 
TextGadget(#StrGadget,0,(WndH(#SplashWindow)-#FontSize)/2,WndW(#SplashWindow),#FontSize,"",#TC)
LoadFont(#SpashFont, "FixedSys", 21) : ShowProgress()
SetGadgetFont(#StrGadget, #SpashFont)
SetGadgetColor(#StrGadget, #PB_Gadget_FrontColor, #Green)
SetGadgetColor(#StrGadget, #PB_Gadget_BackColor, #Black)
AddWindowTimer(#SplashWindow, 0, 500)
EndMacro

Macro DeleteTmp() ; Partializer
DeleteFile(DXInstaller)
EndMacro

Macro CleanUp(Level = 1) ; Partializer
CompilerIf Level > 2 : CloseFile(#DXFile)
CompilerIf Level < 5 : System\NetProgress = 0
CompilerEndIf
CompilerEndIf
CompilerIf Level <> 2 And Level <> 5
InternetCloseHandle_(*FHandle)
InternetCloseHandle_(*Network)
CompilerElse : DeleteTmp() : End
CompilerEndIf
EndMacro

Procedure FailReq(Msg.s) ; Nearly partializer.
#FailMsg = "Failed to download '" + #RedistURL + "'. Retry ?"
HideWindow(#SplashWindow, #True)
ProcedureReturn MessageRequester(#Title, Msg, #MB_YESNO|#MB_ICONERROR)
EndProcedure

Procedure DownloadFile(DXInstaller.s) ; Thread.
#DXFile = 1 : Define BytesRead
Redownload: :Repeat : System\NetFileSize = RequestFileSize(#RedistURL)
If System\NetFileSize ; Если удалось получить размер файла...
Define *NetWork = OpenNetwork() ; Получение дескриптора сети.
Define *FHandle = InternetOpenUrl_(*Network, #RedistURL, 0, 0, $80000000, 0)
If *FHandle : Break : EndIf ; Начало закачки файла.
EndIf : If FailReq(#FailMsg) = #IDYES : CleanUP() : Else : CleanUP(2) : EndIf
ForEver : HideWindow(#SplashWindow, #False) ; Отображение счетчика прогресса.
CreateFile(#DXFile, DXInstaller) ; Файл для закачки инсталлятора.
While System\NetProgress < System\NetFileSize ; Пока идет закачка...
If InternetReadFile_(*FHandle, System\NetBuffer, #DBufferSize, @BytesRead)
WriteData(#DXFile, System\NetBuffer, BytesRead) : System\NetProgress + BytesRead
ElseIf FailReq(#FailMsg) = #IDYES : CleanUP(3) : Goto Redownload ; Идем на перекачку.
Else : CleanUP(5) ; Выход из программы закачки.
EndIf
Wend 
System\NetFileSize = 0 ; Для корректного отображения прогресса.
CleanUP(4) ; Очистка данных.
EndProcedure

Procedure.s TempFileName(TmpDir.S, Prefix.s, Postfix.s = ".tmp")
Repeat : Define I, FileName.s = TmpDir + "\" + Prefix
For I = 1 To 5 : FileName + Chr(Random('z' - 'a') + 'a')
Next I : FileName + Postfix
Until FileSize(FileName) = -1
ProcedureReturn FileName
EndProcedure

Macro UpdateDX() ; Pseudo-procedure.
Define DXInstaller.s = Space(#MAX_PATH)
GetTempPath_(#MAX_PATH, @DXInstaller)
DXInstaller = TempFileName(DXInstaller, "DirectX9 (", ").exe")
GetTempFileName_(@DXInstaller, @"#DirectX9_", 0, @DXInstaller)
OpenSplashWindow() ; Создание окна прогресса.
DisableDebugger
Define *Downloader = CreateThread(@DownloadFile(), @DXInstaller)
While ThreadID(*Downloader) 
If WaitWindowEvent() = #PB_Event_Timer : ShowProgress() : EndIf
Wend
EnableDebugger
CloseWindow(#SplashWindow)
RunProgram(DXInstaller, "", "", #PB_Program_Wait)
DeleteTmp()
EndMacro

Procedure RequestDownload(Title.s, Prefix.s, URL.s)
Define FileSize = RequestFileSize(#RedistURL)
Prefix + #CR$ + "Do you want to download it now ("
If FileSize : Prefix + StrF(FileSize / (1024 * 1024), 1) + "Mb, " : EndIf
Prefix + "connection required) ?"
ProcedureReturn MessageRequester(Title, Prefix, #MB_YESNO | #MB_ICONERROR)
EndProcedure

Procedure CheckDXVersion()
#DXTest = 1
#InvalidDX = "Unable to locate required revision (March 2008) of DirectX 9"
System\NetBuffer = AllocateMemory(#DBufferSize)
While OpenLibrary(#DXTest, "d3dx9_36.dll") = #Null
If RequestDownload(#Title, #InvalidDX, #RedistURL) = #IDYES 
UpdateDX() : Else : End
EndIf
Wend : CloseLibrary(#DXTest)
FreeMemory(System\NetBuffer)
EndProcedure

Define FixDir.s = GetPathPart(ProgramFilename()) ; На случай cmd и тому подобного.
If FixDir <> GetTemporaryDirectory() : SetCurrentDirectory(FixDir) : EndIf
CheckDXVersion() ; Should be here (fgj).
InitXors3D() ; For further usage.
;}
;{ --Render support--
Macro UpdateScreen() ; Pseudo-procedure.
xFlip() : WaitForSingleObject_(System\FPSTimer, #INFINITE)
EndMacro

Macro RestoreFrame() ; Pseudo-procedure.
xCls() : xDrawImage(System\FrameBuffer, 0, 0)
UpdateScreen()
EndMacro

Macro Render3D() ; Pseudo-procedure
xRenderWorld()
If System\Bloomer ; If shading had been invented...
xStretchBackBuffer(System\DiffuseTex, 0, 0, #BloomRes, #BloomRes, 0)
xStretchBackBuffer(System\EmmisiveTex, 0, 0, #ScreenWidth, #ScreenHeight, 0)
xSetEffectTechnique(System\PostPoly, "Diffuse")
xRenderPostEffect(System\PostPoly)
xStretchBackBuffer(System\DiffuseTex, 0, 0, #BloomRes, #BloomRes, 0)
xSetEffectTechnique(System\PostPoly, "DiffuseV")
xRenderPostEffect(System\PostPoly)
EndIf
EndMacro
;}
;{ --Input/Ouput--
Procedure CreateTimer(Period)
Define Junk.FILETIME, *Timer
*Timer = CreateWaitableTimer_(#Null, #False, #Null)
SetWaitableTimer_(*Timer, @Junk, Period, #Null, #Null, #False)
ProcedureReturn *Timer
EndProcedure

Macro CheckMouseHit(ButtonIdx, Message) ; Pseudo-procedure.
Static Button_#ButtonIdx
If xMouseDown(ButtonIdx) : Button_#ButtonIdx = #True
ElseIf Button_#ButtonIdx = #True : Button_#ButtonIdx = 0
ProcedureReturn Message
EndIf
EndMacro

Macro RotatorsBlock(Left, Right, Up, Down) ; Partializer.
If xKeyDown(Left)  : System\XRotation + 1 : EndIf
If xKeyDown(Right) : System\XRotation - 1 : EndIf
If xKeyDown(Up)    : System\YRotation - 1 : EndIf
If xKeyDown(Down)  : System\YRotation + 1 : EndIf
EndMacro

Procedure GetInput()
With System
\XRotation = 0 : \YRotation = 0 : #Sens = 2
Define MXSpeed = xMouseXSpeed()
Define MYSpeed = xMouseZSpeed()
If xKeyDown(57) : \ShowHint = #True : Else : \ShowHint = #False : EndIf
CheckMouseHit(1, 'Lclk') : CheckMouseHit(2, 'Rclk')
RotatorsBlock(203, 205, 200, 208) ; Arrows
RotatorsBlock(30, 32, 17, 31) ; WASD
If xKeyHit(1)    : ProcedureReturn 'Exit' : EndIf
If xKeyHit(14)   : ProcedureReturn 'Undo' : EndIf
If xKeyHit(15)   : ProcedureReturn 'Boss' : EndIf
If xMouseDown(3) : xMoveMouse(\MousePos\X, \MousePos\Y)
If     MXSpeed < 0 : \XRotation - Round(MXSpeed  / #Sens, 1)
ElseIf MXSpeed > 0 : \XRotation + Round(-MXSpeed / #Sens, 1) : EndIf
If     MYSpeed < 0 : \YRotation + Round(MYSpeed  / #Sens, 1)
ElseIf MYSpeed > 0 : \YRotation - Round(-MYSpeed / #Sens, 1) : EndIf
EndIf
EndWith
EndProcedure

Procedure LoadFontFile(FName.s, Font.s, Size)
System\FontLoader(FName, 16, 0)
ProcedureReturn xLoadFont(Font, Size)
EndProcedure

Macro StopTimer() ; Pseudo-procedure.
System\Absent = Date() 
EndMacro

Macro ResumeTimer() ; Pseudo-procedure.
System\StartTime + (Date() - System\Absent)
EndMacro

Macro PauseGame(PauseType = #pBossKey) ; Pseudo-procedure.
CompilerIf PauseType <> #pBossKey ; If window may be visible.
; Would be changed to xGrabImage at first chance.
xCopyRect(0,0,#ScreenWidth,#ScreenHeight,0,0,xBackBuffer(),xImageBuffer(System\FrameBuffer))
CompilerEndIf
StopTimer() : System\Paused = PauseType
xShowPointer()
EndMacro

Macro FlushInput() ; Pseudo-procedure.
xFlushKeys()
xFlushMouse()
EndMacro

Macro ResumeGame() ; Pseudo-procedure.
System\Paused = #pActive : FlushInput()
ResumeTimer() : xHidePointer()
EndMacro

Procedure FrameMaintainer(Dummy) ; Thread.
Repeat : RestoreFrame()
Until System\Paused = #pActive
EndProcedure

Procedure MsgBox(Title.s, Message.S, Flags)
PauseGame(#pMessageBox)
Define Result
xShowPointer()
CreateThread(@FrameMaintainer(), 0)
Result = MessageRequester(Title, Message, Flags)
xHidePointer()
ResumeGame()
ProcedureReturn Result
EndProcedure

Procedure DoPicking()
With System
xCameraPick(\Camera, \MousePos\X, \MousePos\Y)
Define *Entity = xPickedEntity()
If *Entity
Define EName.s = xEntityName(*Entity)
ProcedureReturn Val(EName)
EndIf
EndWith
EndProcedure

Procedure RegisterInput()
With System
\Input = GetInput()
\FPS = xGetFPS()
\MousePos\X = xMouseX()
\MousePos\Y = xMouseY()
\PickedDice = DoPicking()
EndWith
EndProcedure

Macro Hide2Tray() ; Pseudo-procedure
#ToolTip = #Title + #CR$ + "-Left click to continue" + #CR$ + "-Right click to terminate"
If AddSysTrayIcon(#TrayIcon, WindowID(#MainWindow), System\AppIcon)
PauseGame() : SysTrayIconToolTip(#TrayIcon, #ToolTip)
HideWindow(#MainWindow, #True)
EndIf
EndMacro

Macro WindowVisible(Window) ; Pseudo-procedure
GetWindowState(Window) <> #PB_Window_Minimize And System\State <> #pBossKey
EndMacro
;}
;{ --Dicez management--
Macro ActualizeDice(Dice = *Dice, DX = *Dice\Pos\X, DY = *Dice\Pos\Y, DZ = *Dice\Pos\Z)
xEntityPickMode(Dice\Entity, 2, #True)
xNameEntity(Dice\Entity, Str(Dice))
EndMacro

Procedure ColorizeDice(*Entity, ARGB.l)
Define *Color.ARGB = @ARGB
xEntityColor(*Entity, *Color\R, *Color\G, *Color\B)
EndProcedure

Macro DiceType2RGB(DiceType) ; Pseudo-procedure.
System\ColorsTable[DiceType % #DiceColors]
EndMacro

Procedure PaintDice(*Entity, Type)
xEntityTexture(*Entity, System\DiceTex, Type / #DiceColors)
ColorizeDice(*Entity, DiceType2RGB(Type))
EndProcedure

Macro PokeMatrix(MPos, NewVal = #Null) ; Pseudo-procedure.
*DiceMatrix(MPos\X, MPos\Y, MPos\Z) = NewVal
EndMacro

Procedure NewDice(X, Y, Z, Type)
; Mesh creation.
With System
Define *DiceMesh = xCopyEntity(\DiceMesh, \AreaPiv)
xTranslateEntity(*DiceMesh, \Edge + X * \DiceSize, \Edge + Y * \DiceSize, \Edge + Z * \DiceSize)
xEntityAlpha(*DiceMesh, 0.0)
EndWith
; Data addition.
AddElement(Dices())
Define *NewDice.Dice = Dices()
With *NewDice
\Pos\X = X : \Pos\Y = Y : \Pos\Z = Z
PokeMatrix(\Pos, *NewDice)
\Entity = *DiceMesh
\Type = Type
EndWith
ProcedureReturn *NewDice
EndProcedure

Procedure CheckSide(*Dice.Dice, Direction)
With *Dice\Pos
Select Direction
Case 1 ; Dice from left.
If \X > 0 : ProcedureReturn *DiceMatrix(\X - 1, \Y, \Z) : EndIf
Case 2 ; Dice further.
If \Z < System\AreaSize : ProcedureReturn *DiceMatrix(\X, \Y, \Z + 1) : EndIf
Case 3 ; Dice from right.
If \X < System\AreaSize : ProcedureReturn *DiceMatrix(\X + 1, \Y, \Z) : EndIf
Case 4 ; Dice below.
If \Z > 0 : ProcedureReturn *DiceMatrix(\X, \Y, \Z - 1) : EndIf
EndSelect
EndWith
EndProcedure

Procedure DiceFree(*Dice.Dice)
Define I, Freedom, First = CheckSide(*Dice, 1)
If First = 0 : Freedom = 1 : EndIf
For I = 2 To 4
If CheckSide(*Dice, I) : Freedom = 0
Else : Freedom + 1
If FreeDom = 2 : Break : EndIf
EndIf
Next I
If First = 0 : Freedom + 1 : EndIf
If Freedom => 2 : ProcedureReturn I : EndIf
EndProcedure

CompilerIf #PB_Compiler_Version < 460
Procedure RandomizeList(List *Target.Dice())
Define I, Tofix = ListSize(*Target()) - 1
Dim Tmp(ToFix)
ForEach *Target() : Tmp(I) = @*Target() : I + 1 : Next
For I = 0 To ToFix
SwapElements(*Target(), Tmp(Random(ToFix)), Tmp(Random(ToFix)))
Next
EndProcedure
CompilerEndIf

Procedure FillFreeDice(List *Blanks.Dice(), Type)
Define *Blank.Dice
With *Blank
ForEach *Blanks() : *Blank = *Blanks()
If DiceFree(*Blank) : *Blank\Type = Type
PaintDice(*Blank\Entity, Type)
*Blank\ARGB = DiceType2RGB(Type)
DeleteElement(*Blanks())
ProcedureReturn \Pos
EndIf
Next
EndWith
EndProcedure

Procedure SetupArea(AreaSize)
Define X, Y, Z
NewList *Blanks.Dice()
; Preparations.
System\Edge = -(System\DiceSize * AreaSize / 2) + System\DiceSize / 2
AreaSize - 1 : System\AreaSize - 1
; -Map creation-
For X = 0 To AreaSize
For Y = 0 To AreaSize
For Z = 0 To AreaSize
AddElement(*Blanks())
*Blanks() = NewDice(X, Y, Z, 0)
Next Z
Next Y
Next X
; -Map painting-
X = Pow(#MaxField, 3) * SizeOf(Integer)
Define *Reserve = AllocateMemory(X)
CopyMemory(@*DiceMatrix(), *Reserve, X)
Z = ListSize(*Blanks()) ; Количество незакрашенных кубиков.
While Z : RandomizeList(*Blanks())
Define *Pos1.Point3D = FillFreeDice(*Blanks(), Y)
Define *Pos2.Point3D = FillFreeDice(*Blanks(), Y)
PokeMatrix(*Pos1) : PokeMatrix(*Pos2)
Y = Random(#DiceTypes * #DiceColors - 1) : Z - 2
Wend
CopyMemory(*Reserve, @*DiceMatrix(), X)
FreeMemory(*Reserve)
EndProcedure

Procedure MakeFading(*Dice.Dice)
With *Dice
CopyMemory(*Dice, AddElement(History()), SizeOf(Dice))
xEntityPickMode(\Entity, #Null, #False)
\AnimType = #aFading
EndWith
EndProcedure

Procedure RestoreDice()
Define *HistDice.Dice = History()
With *HistDice\Pos
Define *Dice.Dice = *DiceMatrix(\X, \Y, \Z)
EndWith
With *Dice
If *Dice = #Null 
*Dice = AddElement(Dices())
CopyMemory(*HistDice, *Dice, SizeOf(Dice))
PokeMatrix(\Pos, *Dice)
xNameEntity(\Entity, "")
xEntityPickMode(\Entity, 2, #True)
xShowEntity(\Entity)
\Frame = 0
EndIf
\AnimType = #aRaising
DeleteElement(History())
EndWith
EndProcedure

Macro StartGame(FieldSize = #MaxField) ; Pseudo-procedure.
xShowEntity(System\PreviewFrame)
System\AreaPiv = xCreatePivot()
SetupArea(FieldSize)
System\State = #sGame
System\StartTime = Date()
EndMacro

Procedure.f ForceMaxPitch(*Entity, DesiredAngle.f)
If DesiredAngle < 0 : ProcedureReturn MaxF(DesiredAngle, -#MaxYAngle - xEntityPitch(*Entity))
Else : ProcedureReturn MinF(DesiredAngle, #MaxYAngle - xEntityPitch(*Entity))
EndIf
EndProcedure
;}
;{ --GUI management--
Procedure Choose(*Dice.Dice) ; Pseudo-procedure
If *Dice
With System
If DiceFree(*Dice)
xShowEntity(\Preview)
xEntityFX(\PreviewFrame, #FX_FULLBRIGHT)
PaintDice(\Preview, *Dice\Type)
\ChoosenDice = *Dice
EndIf
Else : xHideEntity(\Preview)
xEntityFX(\PreviewFrame, 0)
\ChoosenDice = 0
EndWith
EndIf
EndProcedure

Procedure Eliminatable(*Dice1.Dice, *Dice2.Dice)
With System
If \PickedDice <> \ChoosenDice
If \PickedDice\Type = \ChoosenDice\Type
If DiceFree(*Dice2)
ProcedureReturn #True
EndIf
EndIf
EndIf
EndWith
EndProcedure 

Macro Eliminate(Dice1, Dice2) ; Pseudo-procedure
MakeFading(Dice1) : MakeFading(Dice2) : Choose(0)
System\Moves + 1
EndMacro

Macro Return2Menu() ; Pseudo-procedure.
System\State = #sGameToMenu
EndMacro

Macro ApplyHint(Dice) ; Pseudo-procedure.
xEntityColor(Dice\Entity, Dice\Color\R * #Hint, Dice\Color\G * #Hint, Dice\Color\B * #Hint)
xEntityAlpha(Dice\Entity, #Hint)
Dice\IsHinted = #True
EndMacro

Macro RestoreFromHint(Dice, ResetAlpha = #True) ; Pseudo-procedure.
ColorizeDice(Dice\Entity, Dice\ARGB)
CompilerIf ResetAlpha
xEntityAlpha(Dice\Entity, #AlphaEdge)
CompilerEndIf
Dice\IsHinted = #False
EndMacro

Macro ApplyHL(Dice) ; Pseudo-procedure.
xEntityFX(Dice\Entity, #FX_FULLBRIGHT)
xEntityAlpha(Dice\Entity, 0.95)
EndMacro

Macro RemoveHL(Dice) ; Pseudo-procedure.
xEntityFX(Dice\Entity, 0)
xEntityAlpha(Dice\Entity, #AlphaEdge)
EndMacro

Procedure AnimateDice(*Dice.Dice)
With *Dice
; -Update HL-
If \IsHinted Or (*Dice <> System\PickedDice And *Dice <> System\ChoosenDice)
RemoveHL(*Dice)
Else : ApplyHL(*Dice)
EndIf
; -Update animtaions-
Select \AnimType
Case #aRaising
If \Frame < #AlphaEdge : \Frame + #AlphaStep
xEntityAlpha(\Entity, \Frame)
Else : \AnimType = #aNormal : ActualizeDice()
EndIf
Case #aFading
If \Frame > 0 : \Frame - #AlphaStep
xEntityAlpha(\Entity, \Frame)
Else : PokeMatrix(\Pos)
xHideEntity(\Entity)
DeleteElement(Dices())
Select ListSize(Dices())
Case 0 ; Empty field (game over).
If System\State = #sGame
If MsgBox(#Title, "Congratulations: game over ! Return to menu ?", #MB_YESNO) = #IDYES
Return2Menu() : Else : End
EndIf
EndIf
Case #EndGame ; Last pair (auto-elimination).
Eliminate(FirstElement(Dices()), LastElement(Dices()))
EndSelect
EndIf
Case #aNormal
If System\ShowHint 
If DiceFree(*Dice) = 0 : ApplyHint(*Dice) : Else : RestoreFromHint(*Dice) : EndIf
Else : RestoreFromHint(*Dice)
EndIf
EndSelect
EndWith
EndProcedure

Macro HintMsgColor() ; Partializer.
xColor(90, 220, 255)
EndMacro

Macro GUIStyle() ; Partializer.
xSetFont(System\GUIFont) : xColor(242, 91, 201)
EndMacro

Macro RenderGUI() ; Pseudo-procedure.
#LowLine = #GUIHeight - 60
xSetFont(System\TimerFont) : xColor(222, 204, 33)
xText(#GUIWidth / 2, 20, FormatDate("%hh:%ii:%ss", Date() - System\StartTime), 1)
If ListSize(Dices()) > #EndGame : GUIStyle()
xText(100, #LowLine, "Dicez: " + Str(ListSize(Dices())), 1)
Else : xColor(217, 66, 176) : xText(100, #LowLine, "Bravo !", 1)
GUIStyle()
EndIf
xText(#GUIWidth - 100, #LowLine, "Moves: " + Str(System\Moves), 1)
CompilerIf #PB_Compiler_Debugger
HintMsgColor() : xText(#GUIWidth - 100, 20, "FPS: " + Str(System\FPS), 1)
CompilerEndIf
If System\ShowHint ; Show reminder
HintMsgColor() : xText(#GUIWidth / 2, #LowLine - 10, "[hint mode]", 1, 1)
EndIf
EndMacro

Macro RenderMenu() ; Pseudo-procedure.
Define I, *Btn.Button
For I = 0 To #MenuButtons
*Btn = System\MenuButtons[I]
If System\PickedButton = I
xDrawImage(*Btn\Image, #GUIWidth / 2, *Btn\Y, 1)
Else : xDrawImage(*Btn\Image, #GUIWidth / 2, *Btn\Y, 0)
EndIf
Next I
xDrawImage(System\Logo, #GUIWidth / 2, 100)
xSetFont(System\MenuFont) : xColor(255, 255, 255)
xText(#GUIWidth / 2, #GUIHeight - 15, "Developed in 2010 by Guevara-chan", 1, 1)
If System\Bloomer = #Null ; Reminder message for shader-less world.
xColor(255, 255, 50) : xText(#GUIWidth / 2, 10, "WARNING: NO PS 2.0 SUPPORT FOUND !", 1)
EndIf
EndMacro

Macro ActivateMenu(AfterGame = #False) ; Pseudo-procedure.
CompilerIf AfterGame ; Очистка данных после игры.
xFreeEntity(System\AreaPiv)
ClearList(History())
ClearList(Dices())
System\Moves = 0
CompilerEndIf
System\State = #sMainMenu
xHideEntity(System\PreviewFrame)
EndMacro

Procedure LoadMenuElement(FileName.s, YPos = -1)
Define *Btn.Button, *Image = xLoadImage(FileName.S)
Static LastButton
If YPos >= 0 ; Если загружаем кнопку...
*Btn = System\MenuButtons[LastButton]
With *Btn
\Y = YPos
\Width = xImageWidth(*Image)
\Height = xImageHeight(*Image) / 2
xFreeImage(*Image) 
*Image = xLoadAnimImage(FileName.S, \Width, \Height, 0, 2)
\Image = *Image
LastButton + 1
EndWith
EndIf
xMidHandle(*Image)
xMaskImage(*Image, 0, 0, 0)
ProcedureReturn *Image
EndProcedure

Procedure CheckMenu()
With System
Define CX = \MousePos\X * #GUIScaleX
Define CY = \MousePos\Y * #GUIScaleY
EndWith
Define I, *Btn.Button
For I = 0 To #MenuButtons
*Btn = System\MenuButtons[I]
With *Btn
If Abs(CX - #GUIWidth / 2) <= \Width / 2 ; Width check.
If Abs(CY - \Y) <= \Height / 2 ; Height check.
If xReadPixel(CX, CY, xTextureBuffer(System\GUIBuffer)) ; Texel check.
ProcedureReturn I
EndIf
EndIf
EndIf
EndWith
Next I
ProcedureReturn #NoButton
EndProcedure

Macro PrepareGame(FieldSize) ; Pseudo-procedure
System\AreaSize = FieldSize
System\State = #sMenuToGame
EndMacro
;}
;} EndProcedures

;{ Macros
Macro Initialization()
Define I ; Shared counter.
SetCurrentDirectory("Media\")
; -Window preparations-
#WindowParams = #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget | #PB_Window_Invisible 
OpenWindow(#MainWindow, 0, 0, #ScreenWidth, #ScreenHeight, #Title, #WindowParams|#PB_Window_NoGadgets)
xSetRenderWindow(WindowID(#MainWindow))
xGraphics3D(#ScreenWidth, #ScreenHeight, 32)
; -Cursor preparations-
System\Cursor = xLoadAnimImage("Cursor.png", 480 / #CFrames, 30, 0, #CFrames)
xMaskImage(System\Cursor, 0, 0, 0)
xHidePointer()
; -Fonts preparations-
System\FontLoader = GetProcAddress_(GetModuleHandle_("GDI32.DLL"), "AddFontResourceExA")
System\MenuFont  = xLoadFont("Sylfaen", 9)
System\GUIFont   = LoadFontFile("GUI_Font.ttf", "PlagueDeath"   , 30)
System\TimerFont = LoadFontFile("Timer.otf"   , "Grunge serifia", 30)
; -Quaility setup-
xSetTextureFiltering(#TF_ANISOTROPIC)
xSetAntiAliasType(xGetMaxAntiAlias())
xAntiAlias(#True)
; -Timer preparation-
System\FPSTimer = CreateTimer(1000 / #MaxFPS)
; -Tray icon preparation-
ExtractIconEx_(ProgramFilename(), 0, 0, @System\AppIcon, 1)
; -Dice preparations-
System\DiceMesh = xLoadMesh("Dice.b3d")
System\DiceSize = xMeshWidth(System\DiceMesh)
xHideEntity(System\DiceMesh)
System\DiceTex = xLoadAnimTexture("DiceTex.png", 1, 512 / 3, 512 / 3, 0, 6)
; -Colors table preparations-
System\ColorsTable[0] = $00FF00
System\ColorsTable[1] = $FFFF00
System\ColorsTable[2] = $00FFFF
System\ColorsTable[3] = $FF0078
System\ColorsTable[4] = $FF70FF
System\ColorsTable[5] = $FFFFFF
; -Scene preparatioins-
System\Camera = xCreateCamera()
System\Light = xCreateLight(2)
xEntityParent(System\Light, System\Camera)
xMoveEntity(System\Camera, 0, 0, -System\DiceSize * 19)
xAmbientLight(#Ambient, #Ambient, #Ambient)
XCameraClsMode(System\Camera, #False, #True)
; -Preview preparations-
System\Preview = xCopyEntity(System\DiceMesh)
xPositionEntity(System\Preview, -90, 65, 0)
xTurnEntity(System\Preview, 40, 0, 0)
xEntityOrder(System\Preview, -1)
xHideEntity(System\Preview)
System\PreviewFrame = xLoadSprite("Selection.png", #FLAGS_MASKED, System\Preview)
xScaleSprite(System\PreviewFrame, System\DiceSize * 1.2, System\DiceSize * 1.2)
xEntityAlpha(System\PreviewFrame, 0.85)
xEntityParent(System\PreviewFrame, #Null)
; -Backdrop preparations-
System\BackDrop = xCreateCylinder(32, 0)
xScaleEntity(System\BackDrop, 200, 200, 200)
xEntityFX(System\BackDrop, #FX_FULLBRIGHT)
xFlipMesh(System\BackDrop)
System\BackTex = xLoadTexture("BackDrop.jpg")
xScaleTexture(System\BackTex, 0.1, 0.3)
xEntityTexture(System\BackDrop, System\BackTex)
; -Bloom preparations-
System\Bloomer = xLoadFXFile("Bloom.fx")
If System\Bloomer ; If it's possible to use shading...
System\PostPoly = xCreatePostEffectPoly(System\Camera, 1)
System\DiffuseTex = xCreateTexture(#BloomRes, #BloomRes)
System\EmmisiveTex = xCreateTexture(#ScreenWidth, #ScreenHeight) 
xSetEntityEffect(System\PostPoly, System\Bloomer)
xSetEffectTechnique(System\PostPoly, "Diffuse")
xSetEffectMatrixSemantic(System\PostPoly, "MatWorldViewProj", #WORLDVIEWPROJ)
xSetEffectTexture(System\PostPoly, "tDiffuse", System\DiffuseTex)
xSetEffectTexture(System\PostPoly, "tEmissive", System\EmmisiveTex)
xLightColor(System\Light, #Light, #Light, #Light)
Else : xLightColor(System\Light, #AltLight, #AltLight, #AltLight)
EndIf
; -GUI preparations-
System\GUIPlane = xCreateSprite(System\Camera)
xMoveEntity(System\GUIPlane, 0, 0, 2.4) ; Just a guess, may need fine tuning.
xScaleSprite(System\GUIPlane, 1.0 * (#ScreenWidth / #ScreenHeight), 1.0)
xEntityOrder(System\GUIPlane, -1)
xEntityFX(System\GUIPlane, #FX_FULLBRIGHT)
System\GUIBuffer = xCreateTexture(#GUIRes, #GUIRes, #FLAGS_MASKED)
xEntityTexture(System\GUIPlane, System\GUIBuffer)
xScaleTexture(System\GUIBuffer, #GUIRes / #GUIWidth, #GUIRes / #GUIHeight)
xCreateDSS(#GUIRes, #GUIRes) ; Depth surface for nVidia drivers.
; -Frame buffer preparations-
System\FrameBuffer = xCreateImage(#ScreenWidth, #ScreenHeight)
xImageAlpha(System\FrameBuffer, 0.6) ; Darkened frame.
; -Main menu preparations-
System\Logo = LoadMenuelement("Logo.png")
For I = 0 To #MenuButtons
LoadMenuElement("MenuButton" + Str(I) + ".png", 250 + I * 85)
Next I
ActivateMenu()
; -Window showup-
HideWindow(#MainWindow, #False)
EndMacro

Macro SystemChecks()
; -Focus check-
If GetActiveWindow() <> #MainWindow
If System\Paused = #pActive : PauseGame(#pFocusLost) : EndIf
ElseIf System\Paused = #pFocusLost : ResumeGame()
EndIf
; -Check messages-
Select WindowEvent()
Case #PB_Event_SysTray
Select EventType()
Case #PB_EventType_LeftClick 
RemoveSysTrayIcon(#TrayIcon)
HideWindow(#Mainwindow, #False)
ResumeGame()
Case #PB_EventType_RightClick : End
EndSelect
Case #PB_Event_CloseWindow : End
EndSelect
EndMacro

Macro Controls()
RegisterInput()
; -System controls check-
Select System\Input
Case 'Boss' : Hide2Tray() ; Экстренно свернуть игру.
Case 'Exit' ; Выход в главное меню.
If System\State = #sGame ; Если требуется подтверждение...
If MsgBox(#Title, "Return to main menu ?", #MB_YESNO) = #IDYES
ForEach Dices() : MakeFading(Dices()) : RestoreFromHint(Dices(), #False) : Next
Choose(0) : Return2Menu()
EndIf
Else : End ; ...Иначе просто выходим.
EndIf
EndSelect
; -Input check-
If System\State = #sGame ; Если меню не активно...
Select System\Input
Case 'Undo' ; Отмена действия.
If ListSize(Dices()) > #EndGame
If ListSize(History())
RestoreDice() : RestoreDice() : Choose(0)
EndIf
EndIf
Case 'Lclk' ; Выбор кубика
If System\PickedDice
If System\ChoosenDice
If Eliminatable(System\ChoosenDice, System\PickedDice)
Eliminate(System\ChoosenDice, System\PickedDice)
Else : Choose(System\PickedDice)
EndIf
Else : Choose(System\PickedDice)
EndIf
EndIf
Case 'Rclk' : Choose(0) ; Cнятие выбора
EndSelect
; -Rotation chamber-
If System\XRotation : xTurnEntity(System\AreaPiv, 0, 2 * System\XRotation, 0, #True) : EndIf
; Temporary[
; Frozen for better times, sorry.
;If System\YRotation
;xTurnEntity(System\AreaPiv, ForceMaxPitch(System\AreaPiv, 2 * System\YRotation), 0, 0)
;EndIf
; ]Temporary
; -Menu controls-
ElseIf System\State = #sMainMenu And System\GUIAlpha >= #AlphaEdge
System\PickedButton = CheckMenu()
Select System\Input
Case 'Lclk' ; Активизация элемента меню.
Select System\PickedButton
Case #mCube4X : PrepareGame(4)
Case #mCube6X : PrepareGame(6)
Case #mCube8X : PrepareGame(8)
Case #mExit : End
EndSelect
EndSelect
Else : System\PickedButton = #NoButton
EndIf
EndMacro
Macro AnimateWorld()
If System\State = #sGame Or System\State = #sGameToMenu
; -Update feeder-
If System\SinFeeder = 180 : System\SinFeeder = 0 
Else : System\SinFeeder + 2
EndIf
; -Animating dicez-
ForEach Dices()
AnimateDice(Dices())
Next
; -Animate GUI-
xTurnEntity(System\Preview, 0, 7, 0, 1)
System\FrameTurn = (System\FrameTurn - 1) % 360
xRotateSprite(System\PreviewFrame, System\FrameTurn)
EndIf
; -Update GUI's alpha-
If System\State = #sGame Or System\State = #sMainMenu
If System\GUIAlpha < #AlphaEdge : System\GUIAlpha + #AlphaStep
xEntityAlpha(System\GUIPlane, System\GUIAlpha)
EndIf
ElseIf System\GUIAlpha > 0 : System\GUIAlpha - #AlphaStep
xEntityAlpha(System\GUIPlane, System\GUIAlpha)
ElseIf System\State = #sGameToMenu : ActivateMenu(#True)
Else : StartGame(System\AreaSize)
EndIf
; -Shared animations-
xEntityAlpha(System\PreviewFrame,(#FrameEdge+(1-#FrameEdge)*GSin(System\SinFeeder))*System\GUIAlpha)
xTurnEntity(System\BackDrop, 0, -0.2, 0)
EndMacro

Macro Visualization()
; -GUI render-
If System\State <> #sGameToMenu
xSetBuffer(xTextureBuffer(System\GUIBuffer)) : xClsColor(0, 0, 0, 0) : xCls()
If System\State = #sGame Or System\State = #sGameToMenu : RenderGUI() : Else : RenderMenu() : EndIf
xSetBuffer(xBackBuffer())
EndIf
; -World render-
Render3D()
; -Cursor render-
xDrawImage(System\Cursor, System\MousePos\X, System\MousePos\Y, Abs(System\CFrame - #CFrames + 1))
System\CFrame = (System\CFrame + 1) % (#CFrames * 2 - 2)
UpdateScreen()
EndMacro
;} EndMacros

; ==Main loop==
Initialization()
Repeat : SystemChecks()
If System\Paused = #pActive
Controls()
AnimateWorld()
Visualization()
ElseIf WindowVisible(#MainWindow)
RestoreFrame() ; Pause screen.
EndIf
ForEver
; IDE Options = PureBasic 5.30 (Windows - x86)
; Folding = h3-94-4-
; EnableXP
; UseIcon = ..\Media\Dice.ico
; Executable = ..\[D]-Jongg.exe
; CurrentDirectory = ..\
; IncludeVersionInfo
; VersionField0 = 0,7,0,0
; VersionField1 = 0,7,0,0
; VersionField2 = Guevara-chan [~R.i.P]
; VersionField3 = [D]-Jongg
; VersionField4 = 0.7
; VersionField5 = 0.7
; VersionField6 = [D]-Jongg puzzle
; VersionField7 = [D]-Jongg
; VersionField8 = [D]-Jongg.exe
; VersionField13 = Guevara-chan@Mail.ru
; VersionField14 = http://vk.com/guevara_chan