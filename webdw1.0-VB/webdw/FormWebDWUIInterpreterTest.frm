VERSION 5.00
Begin VB.Form FormWebDWUITest 
   Caption         =   "���Դ���"
   ClientHeight    =   9270
   ClientLeft      =   2130
   ClientTop       =   1515
   ClientWidth     =   9855
   LinkTopic       =   "Form1"
   ScaleHeight     =   9270
   ScaleWidth      =   9855
   Begin VB.CommandButton cmdSort 
      Caption         =   "����"
      Height          =   375
      Left            =   6960
      TabIndex        =   26
      Top             =   960
      Width           =   1215
   End
   Begin VB.CommandButton cmdGetSort 
      Caption         =   "����������"
      Height          =   375
      Left            =   5400
      TabIndex        =   25
      Top             =   960
      Width           =   1335
   End
   Begin VB.CommandButton cmdSetSort 
      Caption         =   "��������"
      Height          =   375
      Left            =   3840
      TabIndex        =   24
      Top             =   960
      Width           =   1215
   End
   Begin VB.Timer Timer1 
      Interval        =   100
      Left            =   2880
      Top             =   600
   End
   Begin VB.CommandButton cmdInsertRow 
      Caption         =   "����"
      Height          =   375
      Left            =   5400
      TabIndex        =   19
      Top             =   480
      Width           =   1335
   End
   Begin VB.CommandButton cmdRowCount 
      Caption         =   "����"
      Height          =   375
      Left            =   3840
      TabIndex        =   18
      Top             =   480
      Width           =   1215
   End
   Begin VB.CommandButton cmdUpdate 
      Caption         =   "����"
      Height          =   375
      Left            =   8400
      TabIndex        =   17
      Top             =   0
      Width           =   1335
   End
   Begin VB.CommandButton cmdDelete 
      Caption         =   "ɾ��"
      Height          =   375
      Left            =   6960
      TabIndex        =   16
      Top             =   0
      Width           =   1215
   End
   Begin VB.Frame Frame3 
      Caption         =   "��ʾ����"
      Height          =   615
      Left            =   120
      TabIndex        =   14
      Top             =   480
      Width           =   2655
      Begin VB.TextBox TextConvertRate 
         Height          =   405
         Left            =   1320
         TabIndex        =   15
         Text            =   "4.1"
         Top             =   120
         Width           =   1095
      End
   End
   Begin VB.CommandButton cmdSetDataObject 
      Caption         =   "�������ݴ���"
      Height          =   375
      Left            =   3840
      TabIndex        =   12
      Top             =   0
      Width           =   1215
   End
   Begin VB.CommandButton CommandR2 
      Caption         =   "��������"
      Height          =   375
      Left            =   5400
      TabIndex        =   11
      Top             =   0
      Width           =   1335
   End
   Begin VB.CommandButton CommandMax 
      Caption         =   "���"
      Height          =   375
      Left            =   8400
      TabIndex        =   10
      Top             =   480
      Width           =   1335
   End
   Begin VB.PictureBox Picture1 
      Height          =   5775
      Left            =   120
      ScaleHeight     =   5715
      ScaleWidth      =   9555
      TabIndex        =   3
      Top             =   3360
      Width           =   9615
      Begin VB.VScrollBar Picture2_VScroll_Page 
         Height          =   5295
         Left            =   9120
         Max             =   0
         TabIndex        =   13
         Top             =   0
         Width           =   255
      End
      Begin VB.HScrollBar Picture2_HScroll_Page 
         Height          =   375
         LargeChange     =   2
         Left            =   0
         Max             =   0
         TabIndex        =   9
         Top             =   5280
         Width           =   9255
      End
      Begin VB.VScrollBar Picture2_VScroll_Line 
         Height          =   5295
         LargeChange     =   10
         Left            =   9360
         Max             =   0
         TabIndex        =   5
         Top             =   -120
         Width           =   255
      End
      Begin VB.PictureBox Picture2 
         AutoRedraw      =   -1  'True
         Height          =   5175
         Left            =   0
         ScaleHeight     =   5115
         ScaleWidth      =   8955
         TabIndex        =   4
         Top             =   0
         Width           =   9015
         Begin VB.HScrollBar PictureChild_HScroll_Page 
            Height          =   255
            Left            =   3840
            TabIndex        =   22
            Top             =   4200
            Width           =   4215
         End
         Begin VB.VScrollBar PictureChild_VScroll_Line 
            Height          =   3015
            Left            =   8040
            TabIndex        =   21
            Top             =   1200
            Width           =   255
         End
         Begin VB.PictureBox PictureChild 
            Height          =   3015
            Left            =   3840
            ScaleHeight     =   2955
            ScaleWidth      =   4155
            TabIndex        =   20
            Top             =   1200
            Width           =   4215
            Begin VB.VScrollBar PictureChild_VScroll_Page 
               Height          =   2535
               Left            =   3840
               TabIndex        =   23
               Top             =   360
               Width           =   255
            End
            Begin VB.Image PictChild_ImageClose 
               Height          =   285
               Left            =   3840
               Picture         =   "FormWebDWUIInterpreterTest.frx":0000
               Stretch         =   -1  'True
               Top             =   0
               Width           =   285
            End
            Begin VB.Image PictureChild_ImagePoint 
               Height          =   225
               Left            =   0
               Picture         =   "FormWebDWUIInterpreterTest.frx":0582
               Top             =   0
               Width           =   9630
            End
         End
         Begin VB.Line LineAuto 
            BorderWidth     =   3
            X1              =   1800
            X2              =   1800
            Y1              =   960
            Y2              =   2400
         End
         Begin VB.Image Picture2_ImagePoint 
            Height          =   225
            Left            =   0
            Picture         =   "FormWebDWUIInterpreterTest.frx":2F80
            Top             =   0
            Width           =   9630
         End
      End
   End
   Begin VB.CommandButton CommandShow 
      Caption         =   "������ʾ"
      Height          =   375
      Left            =   6960
      TabIndex        =   2
      Top             =   480
      Width           =   1215
   End
   Begin VB.Frame Frame1 
      Caption         =   "WebDW��������:"
      Height          =   1575
      Left            =   120
      TabIndex        =   0
      Top             =   1680
      Width           =   4455
      Begin VB.TextBox Text1 
         Height          =   1215
         Left            =   120
         MultiLine       =   -1  'True
         ScrollBars      =   3  'Both
         TabIndex        =   1
         Text            =   "FormWebDWUIInterpreterTest.frx":597E
         Top             =   240
         Width           =   4215
      End
   End
   Begin VB.Frame Frame2 
      Caption         =   "��ʾ����"
      Height          =   1575
      Left            =   4800
      TabIndex        =   7
      Top             =   1680
      Width           =   4935
      Begin VB.TextBox Text2 
         Height          =   1215
         Left            =   120
         MultiLine       =   -1  'True
         ScrollBars      =   3  'Both
         TabIndex        =   8
         Text            =   "FormWebDWUIInterpreterTest.frx":789D
         Top             =   240
         Width           =   4695
      End
   End
   Begin VB.Label LabelInfo 
      Caption         =   "LabelInfo"
      Height          =   375
      Left            =   120
      TabIndex        =   6
      Top             =   120
      Width           =   3495
   End
   Begin VB.Menu menuSelectDW 
      Caption         =   "ѡ��������ݴ���"
   End
End
Attribute VB_Name = "FormWebDWUITest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @��Ȩ���� ������ 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------

Option Explicit
Public ui As CWebDWUI                              'ui��һ���ܵĽӿڣ����еĹ��ܶ�ͨ��ui�����е���
Public errString As String                      '������Ϣ
Dim currentControlName As String                '�洢��ǰ�Ŀؼ�����
Dim langsupport As New CMultiLang               '������֧�ֵĹ���


Private Sub cmdDelete_Click()
    'ɾ����ǰ�еĵ��ù��ܲ���
    Dim strinfo As String
    Dim irow As Long        '��ǰ�ж���
    irow = ui.DW_GetRow    '�õ���ǰ�У���ǰ��Ϊ0����û�е�ǰ��
    
    If irow = -1 Then       '�����жϺ���ʾ
        strinfo = langsupport.SumAllLang("�õ���ǰ�д���", "GetRow Error")
        MsgBox ui.errString, vbExclamation, langsupport.GetCurrent(strinfo)
        Exit Sub
    End If
    
    Dim iret As Long
    If irow > 0 Then
        iret = ui.DW_DeleteRow(irow)
        If iret = -1 Then
            strinfo = langsupport.SumAllLang("ɾ������", "DeleteRow Error")
            MsgBox ui.errString, vbExclamation, langsupport.GetCurrent(strinfo)
        End If
    End If
    
End Sub

Private Sub cmdGetSort_Click()
    MsgBox ui.DW_GetSort()
End Sub

Private Sub cmdInsertRow_Click()
'���빦�ܵĲ���
    Dim strinfo As String
    Dim iret As Long
    iret = ui.DW_InsertRow(0)
    
    If iret = -1 Then
        strinfo = langsupport.SumAllLang("�����д���", "InsertRow Error:")
        MsgBox ui.errString, vbExclamation, langsupport.GetCurrent(strinfo)
    End If

End Sub

Private Sub cmdRowCount_Click()
    'RowCount()�����Ĳ��Դ���
    Dim iret As Long
    Dim strinfo As String
    iret = ui.DW_RowCount
    
    If iret = -1 Then
        strinfo = langsupport.SumAllLang("��������", "RowCount Error")
        MsgBox ui.errString, vbExclamation, langsupport.GetCurrent(strinfo)
    Else
        strinfo = langsupport.SumAllLang("�����ɹ�", "RowCount")
        MsgBox iret, , langsupport.GetCurrent(strinfo)
    End If
End Sub

Private Sub cmdSetDataObject_Click()
    Dim strinfo As String
    '�������ݴ��ڶ���Ĳ��Թ���
    Dim iret As Long
    iret = ui.DW_SetDataObject(FormWebDWUITest.Controls, Picture2, Text1.text)
    
    If iret = -1 Then   '����-1����������
        strinfo = langsupport.SumAllLang("����SetDataObject��������:", "Call SetDataObject Error:")
        MsgBox ui.errString, vbExclamation, langsupport.GetCurrent(strinfo)
    Else
        MsgBox "OK"
    End If

End Sub

Private Sub cmdSetSort_Click()
    ui.DW_SetSort ("#1 A")
End Sub

Private Sub cmdSort_Click()
    Dim iret As Long
    iret = ui.DW_Sort
    
    If iret = -1 Then
        MsgBox ui.errString, vbExclamation, "sort error"
        Exit Sub
    End If
    
    ui.DrawDW   'ˢ�½���
End Sub

Private Sub cmdUpdate_Click()
    'Update�����Ĳ��԰�ť
    Dim strinfo As String
    Dim strUpdate As String
    Dim iret As Long
    strUpdate = ui.DW_GetSQLPreview(iret)
    
    If iret = -1 Then
        strinfo = langsupport.SumAllLang("�õ�Update������", "GetSQLPreview Error:")
        MsgBox ui.errString, vbExclamation, langsupport.GetCurrent(strinfo)
        Exit Sub
    Else
        strinfo = langsupport.SumAllLang("����Update���:", "GetSQLPreview return:")
        MsgBox strUpdate, , langsupport.GetCurrent(strinfo)
    End If
    
    If strUpdate = "" Then
        Exit Sub
    End If
    
    If Len(strUpdate) > 1500 Then
        strinfo = langsupport.SumAllLang("Update���̫��", "Update SQL too large")
        MsgBox langsupport.GetCurrent(strinfo), vbExclamation
        Exit Sub
    End If
    iret = ui.DW_Update     '���ø��·���
    
    If iret = -1 Then
        strinfo = langsupport.SumAllLang("�������", "Update Error:")
        MsgBox ui.errString, vbExclamation, langsupport.GetCurrent(strinfo)
    Else
        strinfo = langsupport.SumAllLang("����ɹ�", "Update")
        MsgBox "OK", , langsupport.GetCurrent(strinfo)
    End If
    
End Sub


Private Sub CommandMax_Click()
    Picture1.top = CommandMax.top + CommandMax.height + 200
    Picture1.Left = 0
    Picture1.width = FormWebDWUITest.width - 400
    Picture1.height = FormWebDWUITest.height - Picture1.top - 700
    
    Picture2.Left = 0
    Picture2.top = 0
    Picture2.height = Picture1.height - 300
    Picture2.width = Picture1.width - 2 * Picture2_VScroll_Line.width
        
    Picture2_VScroll_Line.height = Picture1.height - 300
    Picture2_VScroll_Line.Left = Picture1.width - Picture2_VScroll_Line.width
    
    Picture2_VScroll_Page.height = Picture1.height - 300
    Picture2_VScroll_Page.Left = Picture1.width - Picture2_VScroll_Line.width _
                                - Picture2_VScroll_Page.width
    
    Picture2_HScroll_Page.top = Picture1.height - 300
    Picture2_HScroll_Page.width = Picture1.width - 300
    
End Sub

Private Sub CommandR2_Click()
    Dim strinfo As String
    '�������ܵĲ��԰�ť
    Dim iret As Long
    iret = ui.DW_Retrieve()     '����ֻ��Ҫ������������Ϳ�����
    
    If iret = -1 Then   '����-1�����������
        strinfo = langsupport.SumAllLang("��������", "Retrieve Error")
        MsgBox ui.errString, vbExclamation, langsupport.GetCurrent(strinfo)
    End If
End Sub


Private Sub CommandShow_Click()
    '��ʾ���ݵĹ��ܲ��԰�ť
     ui.DW_SetDataObject FormWebDWUITest.Controls, Picture2, Text1.text
     ui.SetData Text2.text, "new"
     ui.DrawDW
    
End Sub

Private Sub Form_Load()
    '���˴��ھ�����ʾ
    Dim screenx As Single
    Dim screeny As Single
    screenx = Screen.width
    screeny = Screen.height
    
    Me.top = (screeny - Me.height) / 2
    Me.Left = (screenx - Me.width) / 2
    
    Set ui = New CWebDWUI                           '����UI����������
    
    '�ر������ݴ��ڵ���ʾ
    PictureChild.Visible = False
    PictureChild_VScroll_Line.Visible = False
    PictureChild_HScroll_Page.Visible = False
    
    '��������ѡ���޸Ľ�����ʾ
    ChangeTitleLang
     
    LineAuto.Visible = False        '���������ƶ���Ϊ���ɼ�
End Sub

'����������仯�����»�ͼ
Private Sub HScroll_Page_Change()
    ui.DrawDW
End Sub


Private Sub Image2_Click()
    
End Sub

Private Sub menu_d_dddw_depart_Click()
    '����Text1���ı��ǳ������ڵ�d_dddw_depart
    Text1.text = FormDWConst.Text_d_dddw_depart.text
    
End Sub

Private Sub menu_d_employee_list_Click()
    '����Text1���ı��ǳ������ڵ�d_employee_list
    Text1.text = FormDWConst.Text_d_employee_list.text
End Sub

Private Sub menu_d_employee_list2_Click()
    Text1.text = FormDWConst.Text_d_employee_list2.text
End Sub

Private Sub menu_d_product_freedom_Click()
    '����text1���ı��ǳ������ڵ�d_product_freedom
    Text1.text = FormDWConst.Text_d_products_freedom.text
End Sub

Private Sub menu_d_product_list_Click()
    Text1.text = FormDWConst.Text_d_products_listform.text
End Sub

Private Sub menuSelectDW_Click()
    FormDWSelect.Show vbModal
End Sub

Private Sub PictChild_ImageClose_Click()
    '�ڹر�ͼƬ�ϵ������ر������ݴ���
    PictureChild.Visible = False
    PictureChild_VScroll_Line.Visible = False
    PictureChild_HScroll_Page.Visible = False
    
    Dim obj As Control
    Set obj = GF_GetObjectByName(FormWebDWUITest.Controls, PictureChild.tag)
    If Not obj Is Nothing Then
        obj.SetFocus
    End If
End Sub

Private Sub Picture2_HScroll_Page_Change()
    ui.DrawDW
End Sub

Private Sub Picture2_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    ui.Picture_MouseDown Button, Shift, X, Y
End Sub

'����ƶ�����ʾ��ǰ����
Private Sub Picture2_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    LabelInfo.Caption = "MouseMove X,Y: " & X & " , " & Y
        
    ui.Picture_MouseMove Button, Shift, X, Y
   
End Sub

Private Sub Picture2_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    ui.Picture_MouseUp Button, Shift, X, Y
End Sub

Private Sub Picture2_VScroll_Line_Change()
    '�ػ����ݴ���
    ui.DrawDW
End Sub

Private Sub PictureChild_HScroll_Page_Change()
    '�ػ��Ӵ���
    ui.DrawChildDW
End Sub

Private Sub PictureChild_VScroll_Line_Change()
    '�ػ��Ӵ���
    ui.DrawChildDW
End Sub

'˫�������ı������
Private Sub Text1_DblClick()
    Text1.text = ""
End Sub



'�������Timer�¼��������鵱ǰ��ؼ��Ƿ��Ƕ�̬������
'��������õ�ǰ�ؼ����ƣ��Լ���ǰ�ؼ����¼��������
Private Sub Timer1_Timer()
    Dim sname As String
    Dim control1 As Control
    Dim strinfo As String
    
    Set control1 = FormWebDWUITest.ActiveControl
    
    If control1 Is Nothing Then
        currentControlName = ""
        Exit Sub
    End If
    
    sname = control1.Name
    strinfo = langsupport.SumAllLang("��ǰ�ؼ�:", "Current Control:")
    'LabelInfo.Caption = langsupport.GetCurrent(strinfo) & sname
    
    '�жϵ�ǰ�ؼ��Ƿ��Ƕ�̬���������ģ��ж�����:��ΪPicture2_
    If InStr(1, sname, "Picture2_") > 0 And sname <> currentControlName Then
        If TypeOf control1 Is TextBox Then      '��ǰ�ؼ����ı���
            ui.SetTextBox control1
            'ui.myTextBox_GotFocus
            currentControlName = sname
        ElseIf TypeOf control1 Is OptionButton Then '��ǰ�ؼ���һ����ѡ��ť
            ui.SetOptionButton control1
            currentControlName = sname
        ElseIf TypeOf control1 Is checkbox Then     '��ǰ�ؼ���һ����ѡ��ť
            ui.SetCheckBox control1
            currentControlName = sname
        ElseIf TypeOf control1 Is combobox Then     '��ǰ�ؼ���һ��������
            ui.SetComboBox control1
            currentControlName = sname
        End If
        
    ElseIf InStr(1, sname, "PictureChild_") > 0 And sname <> currentControlName Then
        If TypeOf control1 Is TextBox Then  '��ǰ�ؼ����ı���
            ui.SetChildTextBox control1
            currentControlName = sname
        End If
    Else
        currentControlName = ""
    End If
    
End Sub

'����������仯����ͼ
Private Sub VScroll_Line_Change()
    ui.DrawDW
End Sub

'����ȫ�ֱ��������ԵĶ��壬�޸ĵ�ǰ����Ĳ˵�������ʾ����
Private Function ChangeTitleLang() As Long
    Dim strinfo As String
    
    '���ڱ���
    strinfo = langsupport.SumAllLang("WebDW UI���ܲ���", "WebDW UI Test")
    Me.Caption = langsupport.GetCurrent(strinfo)
    
    '�˵�����
    strinfo = langsupport.SumAllLang("ѡ��������ݴ���...", "&Choice a DataWindow...")
    menuSelectDW.Caption = langsupport.GetCurrent(strinfo)
    
    'frame
    strinfo = langsupport.SumAllLang("WebDW��������:", "WebDW UI Desc:")
    Frame1.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = langsupport.SumAllLang("WebDW��ʾ����:", "WebDW Show Data:")
    Frame2.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = langsupport.SumAllLang("��ʾ�����趨", "Convert Rate:")
    Frame3.Caption = langsupport.GetCurrent(strinfo)
    
    '��ť��ʾ
    strinfo = langsupport.SumAllLang("�������ݴ��ڶ���", "SetDataObject")
    cmdSetDataObject.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = langsupport.SumAllLang("��������", "Retrieve")
    CommandR2.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = langsupport.SumAllLang("ɾ��", "DeleteRow")
    cmdDelete.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = langsupport.SumAllLang("����", "Update")
    cmdUpdate.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = langsupport.SumAllLang("����", "RowCount")
    cmdRowCount.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = langsupport.SumAllLang("����", "InsertRow")
    cmdInsertRow.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = langsupport.SumAllLang("�������", "Fill Data")
    CommandShow.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = langsupport.SumAllLang("���", "Maxinum")
    CommandMax.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = langsupport.SumAllLang("������������", "SetSort")
    cmdSetSort.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = langsupport.SumAllLang("��ȡ��������", "GetSort")
    cmdGetSort.Caption = langsupport.GetCurrent(strinfo)
    
    strinfo = langsupport.SumAllLang("����", "Sort")
    cmdSort.Caption = langsupport.GetCurrent(strinfo)
    
End Function

Public Function SetDWName(dwname As String) As Long
    Dim iret As Long
    iret = ui.DW_SetDataObjectByName(Me.Controls, Picture2, dwname)
   
    If iret = -1 Then
        errString = ui.errString
    End If
End Function
