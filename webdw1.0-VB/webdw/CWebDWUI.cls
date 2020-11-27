VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWebDWUI"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem WebDW用户界面解析器，VB功能类
Rem 主要功能：将一个字符串描述转换成相应的图形界面
Rem 图形界面和字符串的描述，两者在逻辑上是完全等价的
Rem 这个功能类似于浏览器的图形解释器,把HTML语言翻译成一个图形化界面
Rem 其中包括文本,图形等多种元素(一开始可能只有文本)
Rem 通过一定的技术把界面和数据库可以关联起来
Rem 第一版本的界面解析器，格式严格按照PB7的数据窗口字符串格式来获取
Rem 所有以DW_开头的方法，提供和PB Datawindow控件类似的功能和调用接口
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @版权所有 刘峻松 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------

Option Explicit

'首先是公用变量的定义
Public errString As String                                  '返回的错误信息字符串
Public sqlca As CWebDWTransaction                           '事务支持？SQL访问支持对象

'其次是私有变量的定义
Private parentClassDW As CWebDWUI_ParentDW                  '定义一个超类
Private iret As Long                                        '通用的返回值定义

'功能描述：设置g_webdw的值
'输入：gg_webdw
'输出：g_webdw
Public Function SetWebDW()
    SetWebDW = parentClassDW.SetLocalWebDW
End Function

'功能描述：读取g_webdw的值
'输入:g_webdw
'输出:gg_webdw
Public Function GetWebDW()
    GetWebDW = parentClassDW.GetLocalWebDW
End Function

'类的初始化方法
Private Sub Class_Initialize()
    Set parentClassDW = New CWebDWUI_ParentDW       '设置父类窗口，绝大部分功能由父类完成
    
    Set parentClassDW.childDW = New CWebDWUI_ChildDW   '在父类数据窗口上，创建一个子数据窗口
    parentClassDW.childDW.SetParentDW Me            '告诉父类的子数据窗口，谁是他爸爸
    
    Set sqlca = parentClassDW.sqlca
End Sub

'根据x,y的位置来判断当前的控件位置
'如果不在任何控件上，返回nothing
'否则返回控件的引用
'Public Function GetCurrentObj(x As Single, y As Single, ByRef controlId As Long) As Control
    'GetCurrentObj = parentClassDW.GetCurrentObj(x, y, controlId)
'End Function


'从一个targetControls容器中，根据给定控件名称来检索控件
'如果控件不存在，则返回Nothing
'Public Function GetObjectByName(objName As String) As Control
'    Set GetObjectByName = parentClassDW.GetObjectByName(objName)
'End Function

'设置dataobject对象，dataobject对象用一个字符串来描述
'这是一个新实现的方法，这个方法中不再传递vscroll,hscroll这些对象
'而是通过其名称来进行访问
Public Function DW_SetDataObject(targetControlsArg As Variant, targetPictArg As PictureBox, _
                             sUIDesc As String) As Long
    iret = parentClassDW.DW_SetDataObject(targetControlsArg, targetPictArg, sUIDesc)
    getParentErr iret
    DW_SetDataObject = iret
End Function

'设置dataobject对象，dataobject对象用一个字符串来描述
'这是一个新实现的方法，这个方法中不再传递vscroll,hscroll这些对象
'而是通过其名称来进行访问
Public Function DW_SetDataObjectByName(targetControlsArg As Variant, targetPictArg As PictureBox, _
                             sdwName As String) As Long
    iret = parentClassDW.DW_SetDataObjectByName(targetControlsArg, targetPictArg, sdwName)
    getParentErr iret
    DW_SetDataObjectByName = iret
End Function


'绘制DW的方法,begId代表开始绘制的一行.begId>0
'targetControls: 目标控件的集合 输入
'targetPict:    要绘制的目标图片框 输入
Public Function DrawDW() As Long
    iret = parentClassDW.DrawDW
    getParentErr iret
    DrawDW = iret
End Function


'数据窗口的检索功能，等价功能dw.Retrieve()
'前提条件是已经设置了datawindow对象
'args是检索调用的参数，各个参数之间用TAB键分割
'20090116对参数进行修改，targetControls和targetPict不再需要外部传入
Public Function DW_Retrieve(Optional args As String = "") As Long
    iret = parentClassDW.DW_Retrieve(args)
    getParentErr iret
    DW_Retrieve = iret
    
End Function


'利用给定的数据，来初始化数据存储
'targetControls 控件的集合
'pictTarget     要绘图的控件
'indata         重新设置的数据
'datastate      可选项,数据的状态,默认为"normal"
Public Function SetData(indata As String, _
                        Optional datastate As String = "normal") As Long
    iret = parentClassDW.SetData(indata, datastate)
    getParentErr iret
    SetData = iret
End Function

'功能描述：删除当前行
'返回0 成功
'返回-1 发生错误
Public Function DW_DeleteRow(rowid As Long) As Long
    iret = parentClassDW.DW_DeleteRow(rowid)
    getParentErr iret
    DW_DeleteRow = iret
End Function

'功能描述：得到当前行
'要得到当前行，需要传入当前所在对象的ID号
Public Function DW_GetRow() As Long
    iret = parentClassDW.DW_GetRow
    getParentErr iret
    DW_GetRow = iret
End Function
'设置当前行
Public Function DW_SetRow(rowid As Long) As Long
    iret = parentClassDW.DW_SetRow(rowid)
    getParentErr iret
    DW_SetRow = iret
End Function

'根据给定的当前控件的名字，判断当前所在列的序号
'返回-1代表失败，>=0代表序号
Public Function GetRowIdColumnId(currentControlName As String, _
                                    ByRef rowid As Long, ByRef colid As Long) As Long
    iret = parentClassDW.GetRowIdColumnId(currentControlName, rowid, colid)
    getParentErr iret
    GetRowIdColumnId = iret
    
End Function

'根据给定的columnname，计算返回的列编号(1 based)
'Public Function GetColumnIdByColumnName(colname As String) As Long
'    iret = parentClassDW.GetColumnIdByColumnName(colname)
'    getParentErr iret
'    GetColumnIdByColumnName = iret
'End Function

'设置数据,只能设置PrimaryBuffer的数据
Public Function DW_SetItem(rowid As Long, colid As Long, sdata As String) As Long
    iret = parentClassDW.DW_SetItem(rowid, colid, sdata)
    getParentErr iret
    DW_SetItem = iret
End Function

'得到最近要提交到后台的更新数据库的命令集合
'多条命令之间用chr(13)chr(10)来分隔
'目前仅支持单表的更新操作所需要的SQL命令
Public Function DW_GetSQLPreview(ByRef iret1 As Long) As String
    Dim strsql As String
    strsql = parentClassDW.DW_GetSQLPreview(iret1)
    getParentErr iret1
    DW_GetSQLPreview = strsql
    
End Function

'执行Dw的Update方法,更新数据
'返回0代表调用成功
'返回-1代表调用发生错误
'将targetControls,targetPict都从参数中去掉
Public Function DW_Update() As Long
    iret = parentClassDW.DW_Update
    getParentErr iret
    DW_Update = iret
End Function

'得到当前DataWindow内的记录总数
'返回-1代表失败
'正常情况返回值>=0
Public Function DW_RowCount() As Long
    iret = parentClassDW.DW_RowCount
    getParentErr iret
    DW_RowCount = iret
End Function

'在数据窗口中插入一条记录，返回这条记录的当前行号，如果出错，返回-1
'rowid代表要插入的行号，如果为0代表在最后插入
Public Function DW_InsertRow(rowid As Long) As Long
    iret = parentClassDW.DW_InsertRow(rowid)
    getParentErr iret
    DW_InsertRow = iret
End Function

'设置当前的文本框对象，以使之可以响应外部事件
Public Function SetTextBox(textArg As TextBox) As Long
    SetTextBox = parentClassDW.SetTextBox(textArg)
End Function

'设置当前的单选框对象，以使之可以响应外部事件
Public Function SetOptionButton(OptionButtonArg As OptionButton) As Long
    SetOptionButton = parentClassDW.SetOptionButton(OptionButtonArg)
End Function

'设置当前的复选框对象，使之可以响应外部事件
Public Function SetCheckBox(checkArg As checkbox) As Long
    SetCheckBox = parentClassDW.SetCheckBox(checkArg)
End Function

'设置当前的下拉框对象，使之可以响应外部事件
Public Function SetComboBox(comboArg As combobox) As Long
    SetComboBox = parentClassDW.SetComboBox(comboArg)
End Function

'调用子数据窗口的刷新方法
Public Function DrawChildDW() As Long
    iret = parentClassDW.DrawChildDW
    getParentErr iret
    DrawChildDW = iret
End Function

'得到父类的错误
Private Function getParentErr(iret As Long) As Long
    If iret = -1 Then
        errString = parentClassDW.errString
    End If
End Function

'设置当前的文本框对象，以使之可以响应外部事件
Public Function SetChildTextBox(textArg As TextBox) As Long
    SetChildTextBox = parentClassDW.SetChildTextBox(textArg)
End Function

'设置列定义字符串
Public Function SetColumnDefString(sColDefString As String) As Long
    SetColumnDefString = parentClassDW.SetColumnDefString(sColDefString)
End Function

'得到检索用的select语句，和数据库相关
Public Function DW_GetSQLSelect() As String
    DW_GetSQLSelect = parentClassDW.DW_GetSQLSelect
End Function

'设置检索用的Select语句
Public Function DW_SetSQLSelect(strsql As String) As Long
    DW_SetSQLSelect = parentClassDW.DW_SetSQLSelect(strsql)
End Function

'根据给定dw语法进行转换，看看能否测试功能
'此方法属于语法层次，不影响界面的显示
'如果转换失败，返回-1
Public Function DW_Create(dwSyntax As String) As Long
    Dim iret As Long
    iret = parentClassDW.DW_Create(dwSyntax)
    If iret = -1 Then
        errString = parentClassDW.errString
    End If
        
    DW_Create = iret
End Function

'得到数据窗口的语法表示
'返回iret 0 代表成功 -1 代表失败
Public Function DW_GetSyntax(ByRef iret As Long) As String
    DW_GetSyntax = parentClassDW.DW_GetSyntax(iret)
End Function

'根据给定的SQL语句，以及对应的数据窗口类型
'设置到g_webdw中去
'从而再转换，得到一个对应的数据窗口对象出来。
'iret返回值，0 正常 -1 失败
'错误信息存放在errstring中
'这个方法是一个Select语句的小型解析器
Public Function DW_SyntaxFromSQL(strsql As String, stype As String, ByRef iret As Long) As String
    DW_SyntaxFromSQL = parentClassDW.DW_SyntaxFromSQL(strsql, stype, iret)
    If iret = -1 Then
        errString = parentClassDW.errString
    End If
End Function

'功能描述：得到当前界面的网格线竖线描述
'数据来源:local_webdw
'数据输出：将所有竖线的X值组合起来，用逗号分割，返回
'仅用于Grid风格和Tabular风格的数据窗口，其他风格的返回""
Public Function GetGridLineInfo() As String
    GetGridLineInfo = parentClassDW.GetGridLineInfo
End Function

'重新设置修改网格表示的字段列宽度
'newX 新的字段X值
'oldX 旧的字段X值
'修改local_webdw的数值
Public Function SetGridWidth(newx As Long, oldx As Long) As Long
    SetGridWidth = parentClassDW.SetGridWidth(newx, oldx)
End Function

'检索数据窗口中的当前数据
'rowid 行号
'colid 列号
'返回值：当前值
Public Function DW_GetItemString(rowid As Long, colid As Long) As String
    DW_GetItemString = parentClassDW.DW_GetItemString(rowid, colid)
End Function

Public Sub Picture_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    parentClassDW.Picture_MouseDown Button, Shift, X, Y
End Sub
Public Sub Picture_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    parentClassDW.Picture_MouseMove Button, Shift, X, Y
End Sub
Public Sub Picture_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    parentClassDW.Picture_MouseUp Button, Shift, X, Y
End Sub

Public Sub myTextBox_GotFocus()
    parentClassDW.myTextBox_GotFocus
End Sub

'设置网格线的颜色0-15有效
Public Function DW_SetGridLineColor(color As Long) As Long
    DW_SetGridLineColor = parentClassDW.DW_SetGridLineColor(color)
    errString = parentClassDW.errString
End Function

'和排序相关的方法
Public Function DW_SetSort(sorter As String) As Long
    DW_SetSort = parentClassDW.DW_SetSorter(sorter)
End Function

'读取排序字段
Public Function DW_GetSort() As String
    DW_GetSort = parentClassDW.DW_GetSorter()
End Function

'数据排序
Public Function DW_Sort() As Long
    DW_Sort = parentClassDW.DW_Sort
    errString = parentClassDW.errString
End Function
