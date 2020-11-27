VERSION 5.00
Begin VB.Form FormDWConst 
   Caption         =   "FormDWConst"
   ClientHeight    =   5550
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   11070
   LinkTopic       =   "Form2"
   ScaleHeight     =   5550
   ScaleWidth      =   11070
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame Frame5 
      Caption         =   "d_employee_list2"
      Height          =   1695
      Left            =   3840
      TabIndex        =   8
      Top             =   1920
      Width           =   3375
      Begin VB.TextBox Text_d_employee_list2 
         Height          =   1335
         Left            =   120
         MultiLine       =   -1  'True
         ScrollBars      =   3  'Both
         TabIndex        =   9
         Text            =   "FormDWConst.frx":0000
         Top             =   240
         Width           =   3135
      End
   End
   Begin VB.Frame Frame4 
      Caption         =   "d_employee_list"
      Height          =   1695
      Left            =   120
      TabIndex        =   6
      Top             =   1920
      Width           =   3495
      Begin VB.TextBox Text_d_employee_list 
         Height          =   1335
         Left            =   120
         MultiLine       =   -1  'True
         ScrollBars      =   3  'Both
         TabIndex        =   7
         Text            =   "FormDWConst.frx":1830
         Top             =   240
         Width           =   3255
      End
   End
   Begin VB.Frame Frame3 
      Caption         =   "d_dddw_depart"
      Height          =   1695
      Left            =   7440
      TabIndex        =   4
      Top             =   120
      Width           =   3495
      Begin VB.TextBox Text_d_dddw_depart 
         Height          =   1335
         Left            =   120
         MultiLine       =   -1  'True
         ScrollBars      =   3  'Both
         TabIndex        =   5
         Text            =   "FormDWConst.frx":305D
         Top             =   240
         Width           =   3255
      End
   End
   Begin VB.Frame Frame2 
      Caption         =   "d_products_freedom"
      Height          =   1695
      Left            =   3840
      TabIndex        =   2
      Top             =   120
      Width           =   3375
      Begin VB.TextBox Text_d_products_freedom 
         Height          =   1335
         Left            =   120
         MultiLine       =   -1  'True
         ScrollBars      =   3  'Both
         TabIndex        =   3
         Text            =   "FormDWConst.frx":37B8
         Top             =   240
         Width           =   3135
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "d_products_listform"
      Height          =   1695
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   3495
      Begin VB.TextBox Text_d_products_listform 
         Height          =   1335
         Left            =   120
         MultiLine       =   -1  'True
         ScrollBars      =   3  'Both
         TabIndex        =   1
         Text            =   "FormDWConst.frx":56CF
         Top             =   240
         Width           =   3255
      End
   End
End
Attribute VB_Name = "FormDWConst"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Rem 这个窗口没有实际功能,用来进行数据窗口的常量定义
Rem 在这个窗口上设置多个TextBox,里面存储了测试窗口用的数据窗口定义字符串
Rem 版权所有，翻录必究


Private Sub Form_Load()
'    MsgBox "这是一个测试用的窗口", , "Demo"
End Sub
