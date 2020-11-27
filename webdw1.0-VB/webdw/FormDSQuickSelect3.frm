VERSION 5.00
Begin VB.Form FormDSQuickSelect3 
   Caption         =   "Quick Select"
   ClientHeight    =   3840
   ClientLeft      =   4005
   ClientTop       =   3180
   ClientWidth     =   7605
   LinkTopic       =   "Form1"
   ScaleHeight     =   3840
   ScaleWidth      =   7605
   Begin VB.CommandButton CommandCancel 
      Caption         =   "ȡ��"
      Height          =   375
      Left            =   5040
      TabIndex        =   8
      Top             =   3240
      Width           =   1575
   End
   Begin VB.CommandButton CommandSelectAll 
      Caption         =   "ȫѡ"
      Height          =   375
      Left            =   1080
      TabIndex        =   7
      Top             =   3240
      Width           =   1575
   End
   Begin VB.CommandButton CommandNext 
      Caption         =   "��һ��"
      Height          =   375
      Left            =   3120
      TabIndex        =   6
      Top             =   3240
      Width           =   1455
   End
   Begin VB.ListBox List2 
      Height          =   1620
      Left            =   4080
      MultiSelect     =   1  'Simple
      TabIndex        =   5
      Top             =   1320
      Width           =   3015
   End
   Begin VB.ListBox List1 
      Height          =   1620
      Left            =   120
      TabIndex        =   4
      Top             =   1320
      Width           =   3015
   End
   Begin VB.Label Label4 
      Caption         =   "���б�"
      Height          =   255
      Left            =   4080
      TabIndex        =   3
      Top             =   960
      Width           =   3015
   End
   Begin VB.Label Label3 
      Caption         =   "3.ѡ�������ѡ������"
      Height          =   255
      Left            =   240
      TabIndex        =   2
      Top             =   960
      Width           =   3015
   End
   Begin VB.Label Label2 
      Caption         =   "2.ѡ��һ�л��߶���"
      Height          =   255
      Left            =   240
      TabIndex        =   1
      Top             =   600
      Width           =   3015
   End
   Begin VB.Label Label1 
      Caption         =   "1.�������ݱ�����ѡ���ȡ��ѡ��"
      Height          =   255
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   3015
   End
End
Attribute VB_Name = "FormDSQuickSelect3"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Option Base 0

Dim ui As CWebDWUI                      'ui��һ���ܵĽӿڣ����еĹ��ܶ�ͨ��ui�����е���
Public sDWtype As String                '�����õ�DW����
Private langsupport As New CMultiLang   '������֧�ֹ���

'ȡ����ť
Private Sub CommandCancel_Click()
    Unload FormDSQuickSelect3
End Sub

Private Sub CommandNext_Click()
    '��������������ѡ������SQL���������SQL����������DWSyntax������DW
    
    Dim sColDefString As String '��ʾѡ�����������͵��ַ������Ӻ�̨����
    
    Dim strsql As String        'ѡ���SQL���
    Dim strDWSyntax As String   '���ɵ�DW�﷨�ַ���
    Dim strcollist As String    'ѡ����������б����ַ�����ʾ�����ŷָ�
    Dim stablename As String    '���ݱ�����
    Dim i As Long               '����ֵ����ѭ������
    
    stablename = List1.List(List1.ListIndex)    '���ݱ�����
    
    strcollist = ""                             'ѡ�����б�
    For i = 0 To List2.ListCount - 1
        If List2.Selected(i) Then
            If strcollist = "" Then
                strcollist = stablename & "." & List2.List(i)
            Else
                strcollist = strcollist & " , " _
                        & stablename & "." & List2.List(i)
            End If
        End If
    Next i
    
    strsql = "select " & strcollist _
            & " from " & stablename             '����SQL���
    MsgBox strsql, , "SQL"                      '��ʾSQL
    
    ui.sqlca.opertype = 1
    ui.sqlca.command = "Select TNAME,COLNO,CNAME,COLTYPE,WIDTH from col" _
                    & " where TNAME='" & stablename & "'"
    ui.sqlca.beginPos = 0
    ui.sqlca.readNum = 100
    
    sColDefString = ui.sqlca.ExecuteSelect(i)   'ִ��SQL����õ������ͱ�ʾ
    If i = -1 Then                              '����������ʾ������ֹ
        MsgBox ui.sqlca.ErrString, , "Error"
        Exit Sub
    End If
    
    If Right(sColDefString, 2) = "OK" Then      'ȥ�����һ�е�OK
        sColDefString = Left(sColDefString, Len(sColDefString) - 2)
    End If
    
    ui.SetColumnDefString sColDefString  '�����е����������ַ���
    strDWSyntax = ui.DW_SyntaxFromSQL(strsql, sDWtype, i) '����g_webdw,����ֵ�����õ�
    
    If i = -1 Then                              '���ɴ�����ʾ������ֹ
        MsgBox ui.ErrString, , "Error"
        Exit Sub
    End If
    
    strDWSyntax = ui.DW_GetSyntax(i) '����g_webdw���ɶ�Ӧ��DWSyntax�ַ���
    
    'MsgBox strDWSyntax
    
    FormDWDefineShow4.showText = strDWSyntax
    
    FormDSQuickSelect3.Hide
    FormDWDefineShow4.Show
   
End Sub

Private Sub CommandSelectAll_Click()
    'ȫѡ���е��б���
    '�������ж����Ϊѡ����
    Dim i As Long
    For i = 0 To List2.ListCount - 1
        List2.Selected(i) = True
    Next
End Sub

Private Sub Form_Load()
    '���˴��ھ�����ʾ
    Dim screenx As Single
    Dim screeny As Single
    screenx = Screen.width
    screeny = Screen.height
    
    Me.top = (screeny - Me.height) / 2
    Me.Left = (screenx - Me.width) / 2
    
    
    'Dim table(1000) As String
    'Dim tableNum As Integer
    'Dim i As Integer
    Dim sret As String
    Dim iret As Long
    Dim table() As String
    Dim tablev As Variant
    Dim stable As String
    Dim tabletype() As String
    Dim i As Integer
    
    Set ui = New CWebDWUI
    
    ui.sqlca.opertype = 3       '3����õ����ݱ��б�
    ui.sqlca.beginPos = 0
    ui.sqlca.readNum = 1000
    
    sret = ui.sqlca.ExecuteSelect(iret)
    
    If iret = -1 Then
        MsgBox sret, , "Error"
        Exit Sub
    End If
    
    '���ü����������ݱ��������List1
    If Right(sret, 2) = "OK" Then
        sret = Left(sret, Len(sret) - 2)
    End If
    table = Split(sret, "" & Chr(13) & Chr(10))
    i = 0
    For Each tablev In table
        
        '������һ��,��һ�з��ص��Ǳ��⣬��Ч
        If i = 0 Then
            GoTo continueNext
        End If
        
        stable = tablev
        tabletype = Split(stable, "" & Chr(9))
        
        If UBound(tabletype) = 1 Then
            List1.AddItem tabletype(0)
        End If
continueNext:
        i = i + 1
    Next
    
    ChangeTitleLang '�޸Ľ���ı�������
    
End Sub

Private Sub List1_Click()
    Dim stablename As String
    Dim cols(1000) As String
    Dim colNum As Integer
    Dim i As Integer
    Dim iret As Long
    Dim sret As String
    Dim column() As String
    Dim columnv As Variant
    Dim sColumn As String
    
    
    If List1.ListIndex < 0 Then
        Exit Sub
    End If
    
    '�õ����ݱ�����
    stablename = List1.List(List1.ListIndex)
    
    
    '������������б�
    ui.sqlca.opertype = 4       '4��������ж���
    ui.sqlca.beginPos = 0
    ui.sqlca.readNum = 1000
    ui.sqlca.command = stablename
    
    sret = ui.sqlca.ExecuteSelect(iret)
    
    If iret = -1 Then
        MsgBox sret, , "Error"
        Exit Sub
    End If
    
    'ˢ��List2
    List2.Clear

    '���ü����������ݱ��������List1
    If Right(sret, 2) = "OK" Then
        sret = Left(sret, Len(sret) - 2)
    End If
    
    column = Split(sret, "" & Chr(13) & Chr(10))
    i = 0
    For Each columnv In column
        '������һ�У��������
        If i = 0 Then
            GoTo continueNext
        End If
        
        sColumn = columnv
        If sColumn > "" Then
            List2.AddItem sColumn
        End If
        
continueNext:
        i = i + 1
    Next

End Sub

'�ı�����ϵĸ���������ʾ
Private Function ChangeTitleLang() As Long
    Dim strinfo As String
    
    '���ڱ���
    strinfo = langsupport.SumAllLang("step3:Quick Select", _
                                    "step3:Quick Select")
    Me.Caption = langsupport.GetCurrent(strinfo)
    
    'ȫѡ��ť
    strinfo = langsupport.SumAllLang("ȫѡ", "Select All")
    CommandSelectAll.Caption = langsupport.GetCurrent(strinfo)
    
    '��һ����ť
    strinfo = langsupport.SumAllLang("��һ��", "Next")
    CommandNext.Caption = langsupport.GetCurrent(strinfo)
    
    'ȡ����ť
    strinfo = langsupport.SumAllLang("ȡ��", "Cacel")
    CommandCancel.Caption = langsupport.GetCurrent(strinfo)
    
    'label1
    strinfo = langsupport.SumAllLang("1.�������ݱ�����ѡ���ȡ��ѡ��", _
                        "1.Click table name to select and deselect")
    Label1.Caption = langsupport.GetCurrent(strinfo)
    
    'label2
    strinfo = langsupport.SumAllLang("2.ѡ��һ�л��߶���", _
                        "2.Select one column or multi columns")
    Label2.Caption = langsupport.GetCurrent(strinfo)
    
    'label3
    strinfo = langsupport.SumAllLang("3.ѡ�������ѡ������", _
                        "3. Choice sort and filter condition.")
    Label3.Caption = langsupport.GetCurrent(strinfo)
    
    '���б�
    strinfo = langsupport.SumAllLang("���б�", "List of Columns")
    Label4.Caption = langsupport.GetCurrent(strinfo)
    
    
End Function


