VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWebDWColor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem WebDW的颜色转换功能
Rem PB中的定义的颜色代码，和VB中定义的颜色代码有所差异
Rem 所以需要定义一个转换方法来进行显示的转换
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @版权所有 刘峻松 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------

Const SYSCOLOR = 16777215                       '最大颜色值,256 * 256 * 256 - 1


'功能描述：输入一个PB定义的颜色，可能是系统颜色，也可能不是系统颜色
'如果是系统颜色，就逐一进行转换(这个转换是基于调色板定义的)
'如果不是系统颜色，就直接返回
'判断是否是系统颜色，看它的值是否小于255 * 256 * 256 + 255 * 256 + 255
'如果没有符合条件的判断命中，那么返回一个默认值
'pbColor    :输入的PB颜色值
'defColor   :输入的默认颜色值
Public Function getVBColor(pbColor As Long, defColor As Long) As Long
    Dim iret As Long
    
    If pbColor <= SYSCOLOR Then
        getVBColor = pbColor
        Exit Function
    End If
    
    iret = defColor                         '设置默认颜色
    If pbColor = 1090519039 Then iret = vbWindowBackground    '如果是windows默认背景色
    If pbColor = 276856960 Then iret = vbApplicationWorkspace ' 如果是应用工作区默认背景色
    If pbColor = 81324524 Then iret = vbButtonFace            ' 如果是按钮表色
    If pbColor = 33554432 Then iret = vbWindowText            'window文本默认颜色
    
    getVBColor = iret
End Function
