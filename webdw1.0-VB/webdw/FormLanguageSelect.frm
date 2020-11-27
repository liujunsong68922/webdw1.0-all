VERSION 5.00
Begin VB.Form FormLanguageSelect 
   Caption         =   "Please Select Your Language:"
   ClientHeight    =   3915
   ClientLeft      =   4770
   ClientTop       =   4260
   ClientWidth     =   5580
   LinkTopic       =   "Form2"
   ScaleHeight     =   3915
   ScaleWidth      =   5580
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      Height          =   375
      Left            =   1800
      TabIndex        =   7
      Top             =   3360
      Width           =   1935
   End
   Begin VB.Frame Frame1 
      Caption         =   "Select Your Language:"
      Height          =   1815
      Left            =   480
      TabIndex        =   2
      Top             =   1320
      Width           =   4575
      Begin VB.OptionButton Option4 
         Caption         =   "Japanese(Not Aaviable Now)"
         Enabled         =   0   'False
         Height          =   375
         Left            =   1200
         TabIndex        =   6
         Top             =   1320
         Width           =   2655
      End
      Begin VB.OptionButton Option3 
         Caption         =   "French(Not Avaiable Now)"
         Enabled         =   0   'False
         Height          =   375
         Left            =   1200
         TabIndex        =   5
         Top             =   960
         Width           =   2535
      End
      Begin VB.OptionButton Option_english 
         Caption         =   "English"
         Height          =   375
         Left            =   1200
         TabIndex        =   4
         Top             =   600
         Width           =   2415
      End
      Begin VB.OptionButton Option_simplechinese 
         Caption         =   "Simple Chinese(简体中文)"
         Height          =   375
         Left            =   1200
         TabIndex        =   3
         Top             =   240
         Value           =   -1  'True
         Width           =   2415
      End
   End
   Begin VB.Label Label2 
      Caption         =   "You can select different language to use this software:"
      Height          =   375
      Left            =   600
      TabIndex        =   1
      Top             =   840
      Width           =   4335
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
      Caption         =   "Welcome to WebDW"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   600
      TabIndex        =   0
      Top             =   360
      Width           =   4335
   End
End
Attribute VB_Name = "FormLanguageSelect"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmdOK_Click()
    FormMain.Show
    FormLanguageSelect.Hide
End Sub

Private Sub Form_Load()
    
    '将此窗口居中显示
    Dim screenx As Single
    Dim screeny As Single
    screenx = Screen.width
    screeny = Screen.height
    
    Me.top = (screeny - Me.height) / 2
    Me.Left = (screenx - Me.width) / 2
End Sub


Private Sub Option_english_Click()
    '设置为英文
    G_Lang = G_LangDef.Lang_English
End Sub

Private Sub Option_simplechinese_Click()
    '设置为简体中文
    G_Lang = G_LangDef.Lang_SimpleChinese
    
End Sub
