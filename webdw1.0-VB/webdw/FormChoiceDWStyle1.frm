VERSION 5.00
Begin VB.Form FormChoiceDWStyle1 
   Caption         =   "step1:��ѡ��DW�ķ��"
   ClientHeight    =   3240
   ClientLeft      =   5370
   ClientTop       =   3765
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3240
   ScaleWidth      =   4680
   Begin VB.CommandButton CommandCancel 
      Caption         =   "ȡ ��"
      Height          =   375
      Left            =   2400
      TabIndex        =   2
      Top             =   2760
      Width           =   1215
   End
   Begin VB.CommandButton CommandNext 
      Caption         =   "��һ��"
      Height          =   375
      Left            =   840
      TabIndex        =   1
      Top             =   2760
      Width           =   1095
   End
   Begin VB.PictureBox ImageList1 
      BackColor       =   &H80000005&
      Height          =   480
      Left            =   480
      ScaleHeight     =   420
      ScaleWidth      =   1140
      TabIndex        =   4
      Top             =   4320
      Width           =   1200
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
      Height          =   255
      Left            =   360
      TabIndex        =   3
      Top             =   2400
      Width           =   3975
   End
   Begin VB.Image Image2 
      Height          =   525
      Left            =   2520
      Picture         =   "FormChoiceDWStyle1.frx":0000
      Top             =   4320
      Width           =   660
   End
   Begin VB.Image Image1 
      Height          =   555
      Left            =   1680
      Picture         =   "FormChoiceDWStyle1.frx":124E
      Top             =   4320
      Width           =   705
   End
End
Attribute VB_Name = "FormChoiceDWStyle1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private selectType As Integer
Private langsupport As New CMultiLang   '������֧�ֹ���

'ȡ����ť,�رմ���
Private Sub CommandCancel_Click()
    FormChoiceDWStyle1.Hide
End Sub

Private Sub CommandNext_Click()
'�ж�Listview1�ĵ�ǰѡ������û��ѡ���򲻽��е���һ��
    'MsgBox "selectType=" & selectType
    'If selectType = 0 Then
    '    MsgBox "��ѡ����ʵ����ݴ���չʾ���!"
    '    Exit Sub
    'End If
    
    selectType = 2
    
    If selectType = 1 Then FormDSQuickSelect3.sDWtype = "freedom"
    If selectType = 2 Then FormDSQuickSelect3.sDWtype = "grid"
    
    FormChoiceDWStyle1.Hide
    FormChoiceDataSource2.Show vbModal
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

    Dim obj As Object
'    ListView1.Icons = ImageList1
    
    Dim strinfo As String
'    strinfo = langsupport.SumAllLang("Freedom����ʽ", "Freedom")
'    Set obj = ListView1.ListItems.Add(, , langsupport.GetCurrent(strinfo), 1)
'    strinfo = langsupport.SumAllLang("Grid ����ʽ", "Grid")
'    Set obj = ListView1.ListItems.Add(, , langsupport.GetCurrent(strinfo), 2)

'    selectType = 1 'Ĭ��ѡ��Freedom��ʽ
'    strinfo = langsupport.SumAllLang("Freedom����ʽ", "Freedom")
'    ListView1.SelectedItem = langsupport.GetCurrent(strinfo)
    
    ChangeTitleLang
End Sub

'Private Sub ListView1_ItemClick(ByVal item As MSComctlLib.ListItem)
'    selectType = item.Index '����selectType
'End Sub

'�ı�����ϵĸ���������ʾ
Private Function ChangeTitleLang() As Long
    Dim strinfo As String
    
    '���ڱ���
    strinfo = langsupport.SumAllLang("step1:��ѡ��DW����ʾ���", "step1:Select DW Style")
    Me.Caption = langsupport.GetCurrent(strinfo)
    
    '��һ����ť
    strinfo = langsupport.SumAllLang("��һ��", "Next")
    CommandNext.Caption = langsupport.GetCurrent(strinfo)
    
    'ȡ����ť
    strinfo = langsupport.SumAllLang("ȡ��", "Cacel")
    CommandCancel.Caption = langsupport.GetCurrent(strinfo)
End Function

