VERSION 5.00
Begin VB.Form FormDWDefineShow4 
   Caption         =   "�Զ����ɵ�WebDW�ļ���ʾ"
   ClientHeight    =   5265
   ClientLeft      =   5145
   ClientTop       =   3120
   ClientWidth     =   9585
   LinkTopic       =   "Form1"
   ScaleHeight     =   5265
   ScaleWidth      =   9585
   Begin VB.CommandButton CommandOK 
      Caption         =   "ȷ��"
      Height          =   375
      Left            =   3960
      TabIndex        =   1
      Top             =   4800
      Width           =   2055
   End
   Begin VB.Frame Frame1 
      Caption         =   "���ɵ�DW�����ļ���ʾ"
      Height          =   4575
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   9375
      Begin VB.TextBox Text1 
         Height          =   4215
         Left            =   120
         MultiLine       =   -1  'True
         ScrollBars      =   2  'Vertical
         TabIndex        =   2
         Top             =   240
         Width           =   9135
      End
   End
End
Attribute VB_Name = "FormDWDefineShow4"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'����������������ʾһ���Զ����ɵ�DW�ļ�������
'DW�ļ��ı༭���ɹ�����ʱ����Ϊϵͳ�Ĺ����ص�
'���ǹ����û�ʹ��PowerBuilder�����ļ��ı�д�༭
'����������ܵ�Ŀ����ʹ����Ӧ������������Ϊһ������

Option Explicit
Public showText As String           'Ҫ��ʾ��text��ֵ�����ⲿֱ�Ӵ�������
Private langsupport As New CMultiLang   '������֧�ֹ���


Private Sub CommandOK_Click()
    FormDWDefineShow4.Hide
    
    FormWebDWUITest.Text1.text = showText
    FormWebDWUITest.Text2.text = ""
    FormWebDWUITest.Show
End Sub

Private Sub Form_Load()
    '���˴��ھ�����ʾ
    Dim screenx As Single
    Dim screeny As Single
    screenx = Screen.width
    screeny = Screen.height
    
    Me.top = (screeny - Me.height) / 2
    Me.Left = (screenx - Me.width) / 2
    
    Text1.text = showText
    
    ChangeTitleLang     '�޸Ľ������ʾ
End Sub

'�ı�����ϵĸ���������ʾ
Private Function ChangeTitleLang() As Long
    Dim strinfo As String
    
    '���ڱ���
    strinfo = langsupport.SumAllLang("step4���Զ����ɵ�WebDW�ļ���ʾ", _
                                    "step4: Display the generated WebDW File")
    Me.Caption = langsupport.GetCurrent(strinfo)
    
    'frame����
    strinfo = langsupport.SumAllLang("���ɵ�DW�����ļ���ʾ��", "DW File Content:")
    Frame1.Caption = langsupport.GetCurrent(strinfo)
    
    'ȷ����ť����
    strinfo = langsupport.SumAllLang("ȷ��", "OK")
    CommandOK.Caption = langsupport.GetCurrent(strinfo)
    
    
    
End Function

