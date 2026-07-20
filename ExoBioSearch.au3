#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <FileConstants.au3>
#include <StringConstants.au3>
#include <Array.au3>
#include <ListBoxConstants.au3>
#include <GuiListView.au3>

Global $ProgName="ExoBioSearch"
Global $ProgVer="1.1"
Global $ProgTitle

Global $IniFile

Global $PlanetArray
Global $AtmoArray
Global $TypeArray

Global $SpeciesArray[1][9]

Global $IDList = 0
Global $IDFootfall = 0
Global $IDStrict = 0

Global $FootFallMultiplier = 1

Global $PayoutMin
Global $PayoutMax
Global $UpdatePayout = 0

;---------------------------------------------------------------------------------------------------
$ProgTitle=$ProgName & " v" & $ProgVer

; Set Our Working Directory
FileChangeDir(@ScriptDir)

; Determine INI Config file name based on Name of the Script
$IniFile = StringTrimRight(@ScriptFullPath,4) & ".ini"

; Get Configuration Info
GetConfig($IniFile)

MainDialog()

Exit

;---------------------------------------------------------------------------------------------------

Func GetConfig($Ini)
	If not FileExists($Ini) then
		MsgBox(16, $ProgName, "Config File (" & $Ini & ") Not Found!")
		Exit
	EndIf

	$SectionArray = IniReadSectionNames($Ini)
	$NumSections = $SectionArray[0]
	ReDim $SpeciesArray[$NumSections + 1][9]

	$SpeciesArray[0][0] = $NumSections
	For $i = 1 to $NumSections

		$SpeciesArray[$i][0] = $SectionArray[$i]
		$SpeciesArray[$i][1] = IniRead($Ini, $SectionArray[$i], "Payout", "")
		$SpeciesArray[$i][2] = IniRead($Ini, $SectionArray[$i], "Atmospheres", "")
		$SpeciesArray[$i][3] = IniRead($Ini, $SectionArray[$i], "Planets", "")
		$SpeciesArray[$i][4] = IniRead($Ini, $SectionArray[$i], "Color", "")
		$SpeciesArray[$i][5] = IniRead($Ini, $SectionArray[$i], "Volcanism", "")
		$SpeciesArray[$i][6] = IniRead($Ini, $SectionArray[$i], "Areas", "")
		$SpeciesArray[$i][7] = IniRead($Ini, $SectionArray[$i], "Distance", "")
		$SpeciesArray[$i][8] = IniRead($Ini, $SectionArray[$i], "Notes", "")

	Next

	_ArraySort($SpeciesArray)

	$PlanetArray = GetFieldArray($SpeciesArray, 3)
	$AtmoArray   =  GetFieldArray($SpeciesArray, 2)
	$TypeArray   =  GetFieldArray($SpeciesArray, 0, 1)

EndFunc

Func GetFieldArray($SourceArray, $SourceField, $Truncate=0)

	Local $NewArray[1]

	For $i = 1 to $SourceArray[0][0]
		$NewArray[0] = _ArrayAdd($NewArray, $SourceArray[$i][$SourceField], 0, ",")
	Next

	For $i = 1 to $NewArray[0]
		$NewArray[$i] = StringStripWS($NewArray[$i], $STR_STRIPLEADING + $STR_STRIPTRAILING)
		If $Truncate Then
				$TempArray = StringSplit($NewArray[$i], " ")
				$NewArray[$i] = $TempArray[1]
		EndIf
	Next

	$NewArray = _ArrayUnique($NewArray, 0, 1)
	_ArraySort($NewArray, 0, 1)
	_ArrayInsert($NewArray, 1, "ANY")
	$NewArray[0] += 1

	_ArrayColInsert($NewArray, 0)
	$NewArray[0][0] = $NewArray[0][1]
	$NewArray[0][1] = ""

	return $NewArray

EndFunc

Func MainDialog()

	$MaxLines = $PlanetArray[0][0]
	If $AtmoArray[0][0] > $MaxLines Then $MaxLines = $AtmoArray[0][0]
	If $TypeArray[0][0] > $MaxLines Then $MaxLines = $TypeArray[0][0]

	GUICreate($ProgTitle, 700, ($MaxLines*30)+100)

	GUICtrlCreateLabel("Planet",      20, 10, 100, 30)
	GUICtrlCreateLabel("Atmosphere", 140, 10, 100, 30)
	GUICtrlCreateLabel("Species",    260, 10, 100, 30)

	GUIStartGroup()
	For $i = 1 to $PlanetArray[0][0]
		$YCoord = $i * 30
		$PlanetArray[$i][0] = GUICtrlCreateRadio($PlanetArray[$i][1], 20, $YCoord, 120, 30)
	Next
	GUICtrlSetState($PlanetArray[1][0], $GUI_CHECKED)

	GUIStartGroup()
	For $i = 1 to $AtmoArray[0][0]
		$YCoord = $i * 30
		$AtmoArray[$i][0] = GUICtrlCreateRadio($AtmoArray[$i][1], 140, $YCoord, 120, 30)
	Next
	GUICtrlSetState($AtmoArray[1][0], $GUI_CHECKED)

	GUIStartGroup()
	For $i = 1 to $TypeArray[0][0]
		$YCoord = $i * 30
		$TypeArray[$i][0] = GUICtrlCreateCheckbox($TypeArray[$i][1], 260, $YCoord, 120, 30)
	Next
	GUICtrlSetState($TypeArray[1][0], $GUI_CHECKED)

	$IDList = GUICtrlCreateListView("Species | Payout| Volcanism | Notes", 400, 30, 280, ($MaxLines*30))
	_GUICtrlListView_JustifyColumn($IDList, 1, 1)
	_GUICtrlListView_SetColumnWidth($IDList, 0, 150)
	_GUICtrlListView_SetColumnWidth($IDList, 1, 50)
	_GUICtrlListView_SetColumnWidth($IDList, 2, 250)
	_GUICtrlListView_SetColumnWidth($IDList, 3, 500)

	$IDFootFall = GUICtrlCreateCheckbox("&First Footfall", 20, ($MaxlINES*30)+60,  100)

	$IDStrict = GUICtrlCreateCheckbox("&Strict", 140, ($MaxlINES*30)+60,  100)

	$Exit = GUICtrlCreateButton("&Exit", 260, ($MaxlINES*30)+60,  50)

	ProcessSelections()

	$IDPayout = GUICtrlCreateLabel("Payout Potential: " & $PayoutMin & " - " & $PayoutMax, 400, ($MaxlINES*30)+60,  280)

	GUISetState()

	While 1
		$msg = GUIGetMsg()

		Switch ($msg)
			Case $GUI_EVENT_CLOSE
				Exit
			Case $Exit
				Exit
			Case $IDFootfall
				If BitAND(GUICtrlRead($IDFootfall), $GUI_CHECKED) = $GUI_CHECKED Then
					$FootFallMultiplier = 5
				Else
					$FootFallMultiplier = 1
				EndIf
				ProcessSelections()
			Case $IDStrict
				ProcessSelections()
		EndSwitch

		For $i = 1 to $PlanetArray[0][0]
			If $msg = $PlanetArray[$i][0] then ProcessSelections()
		Next

		For $i = 1 to $AtmoArray[0][0]
			If $msg = $AtmoArray[$i][0] then ProcessSelections()
		Next

		If $msg = $TypeArray[1][0] Then
			If BitAND(GUICtrlRead($TypeArray[1][0]), $GUI_CHECKED) = $GUI_CHECKED Then
				For $i = 2 to $TypeArray[0][0]
					GUICtrlSetState($TypeArray[$i][0], $GUI_UNCHECKED)
				Next
			EndIf
			ProcessSelections()
		EndIf

		$Trigger = 0
		For $i = 2 to $TypeArray[0][0]
			If $msg = $TypeArray[$i][0] then $Trigger += 1
		Next
		If $Trigger Then
			$Count = 0
			For $i = 2 to $TypeArray[0][0]
				If BitAND(GUICtrlRead($TypeArray[$i][0]), $GUI_CHECKED) = $GUI_CHECKED Then $Count += 1
			Next
			If $Count Then
				GUICtrlSetState($TypeArray[1][0], $GUI_UNCHECKED)
			Else
				GUICtrlSetState($TypeArray[1][0], $GUI_CHECKED)
			EndIf
			ProcessSelections()
		EndIf

		If $UpdatePayout Then
			GUICtrlSetData($IDPayout, "Payout Potential: " & $PayoutMin & " - " & $PayoutMax)
			$UpdatePayout = 0
		EndIf
	WEnd

EndFunc

Func ProcessSelections()

	For $i = 1 to $PlanetArray[0][0]
		If BitAND(GUICtrlRead($PlanetArray[$i][0]), $GUI_CHECKED) = $GUI_CHECKED Then
			$PText = $PlanetArray[$i][1]
			ExitLoop
		EndIf
	Next

	For $i = 1 to $AtmoArray[0][0]
		If BitAND(GUICtrlRead($AtmoArray[$i][0]), $GUI_CHECKED) = $GUI_CHECKED Then
			$AText = $AtmoArray[$i][1]
			ExitLoop
		EndIf
	Next

	$ResultArray = $SpeciesArray

	If $PText <> "ANY" Then
		For $i = $ResultArray[0][0] to 1 step -1
			If not StringInStr($ResultArray[$i][3], $PText) Then
				_ArrayDelete($ResultArray, $i)
				$ResultArray[0][0] -= 1
			EndIf
		Next
	EndIf

	If $AText <> "ANY" Then
		For $i = $ResultArray[0][0] to 1 step -1
			$Keep = 0
			$FieldArray = StringSplit($ResultArray[$i][2], ",")
			For $j = 1 to $FieldArray[0]
				$Field = StringStripWS($FieldArray[$j], $STR_STRIPLEADING + $STR_STRIPTRAILING)
				If BitAND(GUICtrlRead($IDStrict), $GUI_CHECKED) = $GUI_CHECKED Then
					If $Field = $Atext Then $Keep = 1
				Else
					If StringinStr($Field, $Atext) Then $Keep = 1
				EndIf
			Next
			If $Keep = 0 Then
				_ArrayDelete($ResultArray, $i)
				$ResultArray[0][0] -= 1
			EndIf
		Next
	EndIf

	If not BitAND(GUICtrlRead($TypeArray[1][0]), $GUI_CHECKED) = $GUI_CHECKED Then
		For $i = $ResultArray[0][0] to 1 step -1
			$Keep = 0
			For $j = 2 to $TypeArray[0][0]
				If BitAND(GUICtrlRead($TypeArray[$j][0]), $GUI_CHECKED) = $GUI_CHECKED Then
					If StringInStr($ResultArray[$i][0], $TypeArray[$j][1]) Then
						$Keep = 1
						ExitLoop
					EndIf
				EndIf
			Next
			If not $Keep Then
				_ArrayDelete($ResultArray, $i)
				$ResultArray[0][0] -= 1
			EndIf
		Next
	EndIf

	_GUICtrlListView_DeleteAllItems($IDList)

	$TypeCheck = ""
	$TypeMin = 0
	$TypeMax = 0
	$PayoutMin = 0
	$PayoutMax = 0
	For $i = 1 to $ResultArray[0][0]

		$Credits = FormatPayout($ResultArray[$i][1])
		$ListViewItem = $ResultArray[$i][0] & "|" & $Credits & "|" & $ResultArray[$i][5]& "|" & $ResultArray[$i][8]
		GUICtrlCreateListViewItem($ListViewItem, $IDList)

		$TArray = StringSplit($ResultArray[$i][0], " ")
		$Type = $TArray[1]
		$Payout = Int($ResultArray[$i][1])
		If $Type <> $TypeCheck Then
			$PayoutMin += $TypeMin
			$PayoutMax += $TypeMax
			$TypeCheck = $Type
			$TypeMin = $Payout
			$TypeMax = $Payout
		Else
			If $Payout < $TypeMin Then $TypeMin = $Payout
			If $Payout > $TypeMax Then $TypeMax = $Payout
		EndIf

	Next

	$PayoutMin += $TypeMin
	$PayoutMax += $TypeMax

	$PayoutMin = FormatPayout($PayoutMin)
	$PayoutMax = FormatPayout($PayoutMax)

	$UpdatePayout = 1

EndFunc

Func FormatPayout($Payout)

		$Payout = $Payout * $FootFallMultiplier
		$Monetize = StringFormat("%.2f", $Payout)
		$Dollars = StringRegExpReplace($Monetize, "(\d)(?=(\d{3})+\.)", "$1,")
		$Credits = StringTrimRight($Dollars, 3)

		Return $Credits
EndFunc


