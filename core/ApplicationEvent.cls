VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ApplicationEvent"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'--------------------------------------------------------------
Public WithEvents appEvent As Application
Public WithEvents pptEvent As PowerPoint.Application
Public WithEvents wrdEvent As Word.Application
Attribute appevent.VB_VarHelpID = -1

Private Sub appevent_WorkbookOpen(ByVal Wb As Workbook) '{{{
	Call UpdateMru(Wb.FullName)
	Call cd(Wb.Name)

	' For Each b in Workbooks
	' 	If b.Name Like "Book*" Then
	' 		b.Close
	' 	End If
	' Next b

End Sub '}}}

Private Sub appevent_WorkbookBeforeClose(Byval wb As Workbook, Cancel As Boolean) '{{{
	If Workbooks.count <= 2 Then
		On Error Resume Next
		Workbooks("register.xlsx").Close savechanges:=False
	End If
End Sub '}}}

Private Sub appevent_SheetActivate(ByVal Sh As Object) '{{{
	' Debug.Print "App.cls�ŊĎ����ł�� SheetActivate�C�x���g���������܂����"
	Debug.Print Sh.Name
	If Sh.Name = "Sheet3" Then
	End If
End Sub '}}}

Private Sub appevent_WorkbookActivate(ByVal Wb As Workbook) '{{{
	'Debug.Print "App.cls�ŊĎ����ł��WorkbookActivate�C�x���g���������܂����"
End Sub '}}}

Private Sub pptEvent_PresentationOpen(ByVal Pres As PowerPoint.Presentation)'{{{
	Call UpdateMru(Pres.FullName)
End Sub'}}}

Private Sub wrdEvent_DocumentOpen(ByVal Doc As Word.Document)'{{{
	Call UpdateMru(Doc.FullName)
End Sub'}}}

'------------------sub Function/Sub-----------------------------
Private Sub UpdateMru(filePath As String)'{{{
	'�t�@�C�����J������������������
	openTime = Now
	newRegister = True
	separator = ":::"
	Dim buflines As New Collection

	'If mru_file does not exist, make mru_file.
	Dim mruDir As String: mruDir = Environ("homepath") & "\.vimx" & "\.cache\"
	If Dir(mruDir & "mru.txt") = "" Then
		If Dir(mruDir, vbDirectory) = "" Then
			MkDirRecursively mruDir
		End If
		CreateObject("Scripting.FileSystemObject").CreateTextFile Environ("homepath") & "\.vimx" & "\.cache\" & "mru.txt"
	End If

	Open Environ("homepath") & "\.vimx" & "\.cache\" & "mru.txt" For Input As #1
	Do Until EOF(1)
		Line Input #1, buf
		If Split(buf, separator)(0) = filePath Then
			newRegister = False
			count = Val(Split(buf, separator)(1))
		Else
			buflines.Add Item:=buf
		End If
	Loop
	Close #1
	buflines.Add Item:=filePath & separator & count + 1 & separator & openTime

	Open Environ("homepath") & "\.vimx" & "\.cache\mru.txt" For Output As #1
	For Each record In buflines
		Print #1, record
	Next record
	Close #1

	'TODO ���p������python���w��o����悤�ɂ���B
	PYTHONPATH = "python"
	On Error Resume Next
		Call Shell(PYTHONPATH & " " & ThisWorkbook.Path & "\src\lib\sort.pyw")
	On Error GoTo 0

End Sub'}}}
