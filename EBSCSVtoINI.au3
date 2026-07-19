#include <String.au3>
#include <StringConstants.au3>
#include <File.au3>
#include <array.au3>

$CSVFile = FileOpenDialog("Select tab delimited CSV File to Convert: ", @ScriptDir, "CSV (*.csv)", $FD_FILEMUSTEXIST)
If @error Then Exit(1)

$CSVHandle = FileOpen($CSVFile, 0)

Local $Drive
Local $Dir
Local $FileName
Local $Extension

_PathSplit($CSVFile, $Drive, $Dir, $FileName, $Extension)

$INIFile = $Drive & $Dir & "ExoBioSearch.ini"

If FileExists($INIFile) Then
	If MsgBox($MB_YESNO, "File Exists", $INIFile & " exists.  OK to Overwrite?") = $IDNO Then Exit(2)
EndIf


$INIHandle = FileOpen($INIFile, $FO_OVERWRITE)

$SectionCount = 0

While 1
	$Line = FileReadLine($CSVHandle)
	If @error = -1 Then ExitLoop

	$FieldArray = StringSplit($Line, @Tab)

	If $SectionCount <> 0 Then		; Skip Field Headers

		FileWriteLine($INIHandle,"[" & $FieldArray[1] & "]")

		FileWriteLine($INIHandle,"Payout=" & $FieldArray[2])
		FileWriteLine($INIHandle,"Atmospheres=" & $FieldArray[3])
		FileWriteLine($INIHandle,"Planets=" & $FieldArray[4])
		FileWriteLine($INIHandle,"Color=" & $FieldArray[5])
		FileWriteLine($INIHandle,"Volcanism=" & $FieldArray[6])
		FileWriteLine($INIHandle,"Areas=" & $FieldArray[7])
		FileWriteLine($INIHandle,"Distance=" & $FieldArray[8])
		If $FieldArray[0] > 8 Then FileWriteLine($INIHandle,"Notes=" & $FieldArray[9])

	FileWriteLine($INIHandle,"")

	EndIf

	$SectionCount += 1

WEnd

FileClose($INIHandle)
FileClose($CSVHandle)

MsgBox($MB_ICONINFORMATION, "Done", "Done!")