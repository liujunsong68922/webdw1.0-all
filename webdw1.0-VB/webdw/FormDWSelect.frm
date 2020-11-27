VERSION 5.00
Begin VB.Form FormDWSelect 
   Caption         =   "Select A DataWindowObject:"
   ClientHeight    =   2490
   ClientLeft      =   4200
   ClientTop       =   2925
   ClientWidth     =   6300
   LinkTopic       =   "Form2"
   ScaleHeight     =   2490
   ScaleWidth      =   6300
   Begin VB.CommandButton CommandOK 
      Caption         =   "cmdOK"
      Height          =   495
      Left            =   1920
      TabIndex        =   1
      Top             =   1800
      Width           =   2295
   End
   Begin VB.Frame Frame1 
      Caption         =   "Please Select a Datawindow Object:"
      Height          =   1215
      Left            =   480
      TabIndex        =   0
      Top             =   360
      Width           =   5295
      Begin VB.ComboBox Combo1 
         Height          =   315
         Left            =   600
         Style           =   2  'Dropdown List
         TabIndex        =   2
         Top             =   480
         Width           =   4095
      End
   End
End
Attribute VB_Name = "FormDWSelect"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub CommandOK_Click()
    Dim dwname As String
    Dim iret As Long
    
    If Combo1.ListIndex < 0 Then
        Exit Sub
    End If
    
    dwname = Combo1.List(Combo1.ListIndex)
    'MsgBox dwname
    
    
    If dwname > "" Then
        iret = FormWebDWUITest.SetDWName(dwname)
        If iret = -1 Then
            MsgBox FormWebDWUITest.errString, vbExclamation, "Error"
        End If
        
        FormDWSelect.Hide
    End If
    
End Sub

Private Sub Form_Load()
    '将此窗口居中显示
    Dim screenx As Single
    Dim screeny As Single
    screenx = Screen.width
    screeny = Screen.height
    
    Me.top = (screeny - Me.height) / 2
    Me.Left = (screenx - Me.width) / 2

    Combo1.AddItem "d_products_grid"
    Combo1.AddItem "d_products_tabular"
    Combo1.AddItem "d_product_freedom"
    Combo1.AddItem "d_employee_list"
    Combo1.AddItem "d_employee_list2"
    Combo1.AddItem "d_employee_001"
    Combo1.AddItem "d_dddw_dept"
    Combo1.AddItem "d_stock_list"
    Combo1.AddItem "d_stock_rec_list"
    Combo1.AddItem "dddw_stock_list"
    Combo1.AddItem "d_dept_employee"
    Combo1.AddItem "d_2"
    
    Combo1.ListIndex = 0
End Sub
