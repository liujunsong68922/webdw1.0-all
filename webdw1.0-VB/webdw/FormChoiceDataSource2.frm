VERSION 5.00
Begin VB.Form FormChoiceDataSource2 
   Caption         =   "step2:��ѡ������Դ������"
   ClientHeight    =   3345
   ClientLeft      =   5175
   ClientTop       =   3960
   ClientWidth     =   4665
   LinkTopic       =   "Form1"
   ScaleHeight     =   3345
   ScaleWidth      =   4665
   Begin VB.PictureBox ImageList1 
      BackColor       =   &H80000005&
      Height          =   480
      Left            =   360
      ScaleHeight     =   420
      ScaleWidth      =   1140
      TabIndex        =   4
      Top             =   3360
      Width           =   1200
   End
   Begin VB.CommandButton CommandCancel 
      Caption         =   "ȡ  ��"
      Height          =   375
      Left            =   2640
      TabIndex        =   2
      Top             =   2760
      Width           =   1215
   End
   Begin VB.CommandButton commandNext 
      Caption         =   "��һ��"
      Height          =   375
      Left            =   720
      TabIndex        =   1
      Top             =   2760
      Width           =   1215
   End
   Begin VB.PictureBox ListView1 
      BackColor       =   &H80000005&
      ForeColor       =   &H80000008&
      Height          =   2055
      Left            =   240
      ScaleHeight     =   1995
      ScaleWidth      =   4155
      TabIndex        =   0
      Top             =   240
      Width           =   4215
   End
   Begin VB.Label Label1 
      Caption         =   "˵����Ŀǰ��֧��Quick Select���͵Ķ��塣"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   2400
      Width           =   4335
   End
   Begin VB.Image Image2 
      Height          =   540
      Left            =   2520
      Picture         =   "FormChoiceDataSource2.frx":0000
      Top             =   3360
      Width           =   645
   End
   Begin VB.Image Image1 
      Height          =   555
      Left            =   1320
      Picture         =   "FormChoiceDataSource2.frx":0A72
      Top             =   3360
      Width           =   735
   End
End
Attribute VB_Name = "FormChoiceDataSource2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim sqlType As Integer 'sql��������
Private langsupport As New CMultiLang   '������֧�ֹ���


Private Sub CommandCancel_Click()
    FormChoiceDataSource2.Hide
End Sub

Private Sub CommandNext_Click()
'�ж�Listview1�ĵ�ǰѡ������û��ѡ���򲻽��е���һ��
    'MsgBox "sqlType=" & sqlType
    Dim strinfo As String
    
    
    'If sqlType = 0 Then
    '    strinfo = langsupport.SumAllLang("��ѡ����ʵ�����Դ����!", _
    '                                "Please select right datasource type!")
    '    MsgBox langsupport.GetCurrent(strinfo)
    '    Exit Sub
    'End If
    sqlType = 1
    
    FormChoiceDataSource2.Hide
    'Ŀǰ�Ȳ������������ͣ�ֱ�Ӵ�QuickSelect
    FormDSQuickSelect3.Show vbModal
End Sub

Private Sub Form_Load()
    '���˴��ھ�����ʾ
    Dim screenx As Single
    Dim screeny As Single
    screenx = Screen.width
    screeny = Screen.height
    
    Me.top = (screeny - Me.height) / 2
    Me.Left = (screenx - Me.width) / 2


    '�Ƚ�ͼƬ����ImageList1��ȥ
    Dim imgx As Object
'    Set imgx = ImageList1.ListImages.Add(, , Image1.Picture)
'    Set imgx = ImageList1.ListImages.Add(, , Image2.Picture)

'    Dim obj As Object
'    ListView1.Icons = ImageList1
    'ListView1.SmallIcons = ImageList1
'    Set obj = ListView1.ListItems.Add(, , "Quick select", 1)
'    Set obj = ListView1.ListItems.Add(, , "SQL select", 2)

'    sqlType = 1 'Ĭ��ѡ��quick select���ͣ����������ݲ�֧��
    
'    ChangeTitleLang '�޸ı��������

End Sub

'Private Sub ListView1_ItemClick(ByVal item As MSComctlLib.ListItem)
    '����sqlType
 '   sqlType = item.Index
'End Sub

'�ı�����ϵĸ���������ʾ
Private Function ChangeTitleLang() As Long
    Dim strinfo As String
    
    '���ڱ���
    strinfo = langsupport.SumAllLang("step2:��ѡ������Դ������", _
                                    "step2:Select datasource")
    Me.Caption = langsupport.GetCurrent(strinfo)
    
    '��һ����ť
    strinfo = langsupport.SumAllLang("��һ��", "Next")
    CommandNext.Caption = langsupport.GetCurrent(strinfo)
    
    'ȡ����ť
    strinfo = langsupport.SumAllLang("ȡ��", "Cacel")
    CommandCancel.Caption = langsupport.GetCurrent(strinfo)
    
    '����˵������
    strinfo = langsupport.SumAllLang("˵����Ŀǰ��֧��Quick Select���͵Ķ��塣", _
                        "Tip: current only Quick Select is supported.")
    Label1.Caption = langsupport.GetCurrent(strinfo)
End Function

