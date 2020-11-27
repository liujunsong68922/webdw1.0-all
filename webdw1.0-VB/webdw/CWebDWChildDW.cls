VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWebDWUI_ChildDW"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem WebDW子数据窗口的解析定义类，VB功能类
Rem 主要功能：专门用来绘制和显示子数据窗口
Rem 大部分代码和CWebDWUI类似,但有适当的简化
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @版权所有 刘峻松 2009-2010
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------

Option Explicit

Public webdw As CWebDW                                      '定义webdw对应的文件读取类(这里存一个指针)
Public errString As String                                  '返回的错误信息字符串
Public webdwData As CWebDWData                              '定义webdw的数据对象类

'------------下面的定义是界面上的动态元素对应的事件处理器定义
Private WithEvents myTextBox As TextBox             'myTextBox是一个虚拟的文本框，用来定义文本框事件响应
Attribute myTextBox.VB_VarHelpID = -1
'------------界面动态元素定义完毕

Public parentControlName As String                  '父数据窗口的控件名称
Public dataColumnName As String                      '数据列名称

Private parentDW As CWebDWUI                        '设置父数据窗口的句柄
Private parentClassDW As CWebDWUI_ParentDW          '设置父类的数据窗口类的句柄，本类不再存储大量的重复方法

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

'画标签的方法
'targetControls 目标窗体或者用户控件的控件集合
'pictTarget 目标图片框
'lineNum    行号0代表绘制表头，其他代表具体的行号
'leftpos    所有元素的左偏移量 leftpos <=0
'图形数据来源: g_webdw
Private Function DrawLabel(targetControls As Variant, targetPict As PictureBox, convertRate As Double, _
                            lineNum As Long, Optional leftPos As Long = 0) As Long
    DrawLabel = parentClassDW.DrawLabel(lineNum, leftPos)
    
End Function

'画文本框的方法
'targetControls 目标控件集合
'pictTarget     要绘制的图片框
'lineNum        行号，从1开始，文本框只在detail区域绘制，不考虑其他区域
'leftpos        左偏移量，对象向左偏移leftpos<0
Private Function DrawColumn(targetControls As Variant, targetPict As PictureBox, convertRate As Double, _
                            lineNum As Long, Optional leftPos As Long = 0) As Long
    DrawColumn = parentClassDW.DrawColumn(lineNum, leftPos)
End Function
'类的初始化方法
Private Sub Class_Initialize()
   
    Set parentClassDW = New CWebDWUI_ParentDW           '设置父类指针，生成一个新的父类
    Set webdw = parentClassDW.webdw
    Set webdwData = parentClassDW.webdwData
    
End Sub


'设置dataobject对象，dataobject对象用一个字符串来描述
'这是一个新实现的方法，这个方法中不再传递vscroll,hscroll这些对象
'而是通过其名称来进行访问
Public Function DW_SetDataObject(targetControlsArg As Variant, targetPictArg As PictureBox, _
                             sUIDesc As String, childFlag As Boolean) As Long
    
    DW_SetDataObject = parentClassDW.DW_SetDataObject(targetControlsArg, targetPictArg, sUIDesc, childFlag)
End Function

'设置dataobject对象，dataobject对象用一个字符串来描述
'这是一个新实现的方法，这个方法中不再传递vscroll,hscroll这些对象
'而是通过其名称来进行访问
Public Function DW_SetDataObjectByName(targetControlsArg As Variant, targetPictArg As PictureBox, _
                             sdwName As String) As Long
    Dim iret As Long
    iret = parentClassDW.DW_SetDataObjectByName(targetControlsArg, targetPictArg, sdwName)
    getParentErr iret
    DW_SetDataObjectByName = iret
End Function

'绘制DW的方法,begId代表开始绘制的一行.begId>0
'targetControls: 目标控件的集合 输入
'targetPict:    要绘制的目标图片框 输入
Public Function DrawDW() As Long
    DrawDW = parentClassDW.DrawDW
        
End Function

'在界面上画线的方法
'通过这个方法支持在界面上进行画线
'leftpos 左偏移量 leftpos<=0
Public Function DrawLine(targetControls As Variant, targetPict As PictureBox, _
                            convertRate As Double, lineNum As Long, _
                            Optional leftPos As Long = 0) As Long
    DrawLine = parentClassDW.DrawLine(lineNum, leftPos)
End Function



'数据窗口的检索功能，等价功能dw.Retrieve()
'前提条件是已经设置了datawindow对象
'args是检索调用的参数，各个参数之间用TAB键分割
'20090116对参数进行修改，targetControls和targetPict不再需要外部传入
Public Function DW_Retrieve(Optional args As String = "") As Long
    DW_Retrieve = parentClassDW.DW_Retrieve(args)
End Function


'利用给定的数据，来初始化数据存储
'targetControls 控件的集合
'pictTarget     要绘图的控件
'indata         重新设置的数据
'datastate      可选项,数据的状态,默认为"normal"
Public Function SetData(indata As String, _
                        Optional datastate As String = "normal") As Long
    SetData = parentClassDW.SetData(indata, datastate)
End Function
'功能描述：得到当前行
'要得到当前行，需要传入当前所在对象的ID号
Public Function DW_GetRow() As Long
    DW_GetRow = parentClassDW.DW_GetRow
End Function
'设置当前行
Public Function DW_SetRow(rowid As Long) As Long
    DW_SetRow = parentClassDW.DW_SetRow(rowid)
    
End Function

'根据给定的当前控件的名字，判断当前所在列的序号
'返回-1代表失败，>=0代表序号
Public Function GetRowIdColumnId(currentControlName As String, _
                                    ByRef rowid As Long, ByRef colid As Long) As Long
    GetRowIdColumnId = parentClassDW.GetRowIdColumnId(currentControlName, rowid, colid)
End Function

'根据给定的columnname，计算返回的列编号(1 based)
'Public Function GetColumnIdByColumnName(colname As String) As Long
'    GetColumnIdByColumnName = parentClassDW.GetColumnIdByColumnName(colname)
'End Function

'设置数据,只能设置PrimaryBuffer的数据
Public Function SetItemString(rowid As Long, colid As Long, sData As String) As String
    webdwData.SetItemString rowid, colid, sData
End Function

'得到最近要提交到后台的更新数据库的命令集合
'多条命令之间用chr(13)chr(10)来分隔
'目前仅支持单表的更新操作所需要的SQL命令
Public Function DW_GetSQLPreview(ByRef iret As Long) As String
        
    DW_GetSQLPreview = parentClassDW.DW_GetSQLPreview(iret)
    
       
End Function

'执行Dw的Update方法,更新数据
'返回0代表调用成功
'返回-1代表调用发生错误
'将targetControls,targetPict都从参数中去掉
Public Function DW_Update() As Long
    
    DW_Update = parentClassDW.DW_Update
    
End Function

'得到当前DataWindow内的记录总数
'返回-1代表失败
'正常情况返回值>=0
Public Function DW_RowCount() As Long
    
    DW_RowCount = parentClassDW.DW_RowCount
End Function

'在数据窗口中插入一条记录，返回这条记录的当前行号，如果出错，返回-1
'rowid代表要插入的行号，如果为0代表在最后插入
Public Function DW_InsertRow(rowid As Long) As Long
    DW_InsertRow = parentClassDW.DW_InsertRow(rowid)
End Function

'设置当前的文本框对象，以使之可以响应外部事件
Public Function SetTextBox(textArg As TextBox) As Long
    Dim iret As Long
    Dim rowid As Long
    Dim colid As Long
    
    iret = GetRowIdColumnId(textArg.Name, rowid, colid)
    If iret = 0 Then
        If rowid <> parentClassDW.DW_GetRow Then
            parentClassDW.DW_SetRow (rowid)
            parentClassDW.DrawDW_ImageOnly
        End If
    End If

    Set myTextBox = textArg
    'myTextBox_Click
End Function

'当在文本框上单击时，设置当前行
'未来根据元素定义的编辑风格来进行弹出控件设置
Private Sub myTextBox_Click()
    Dim iret As Long
    Dim rowid As Long
    Dim colid As Long
    
    'MsgBox "click"
    
    iret = GetRowIdColumnId(myTextBox.Name, rowid, colid)
    If iret = 0 Then
        If rowid <> parentClassDW.DW_GetRow Then
            parentClassDW.DW_SetRow rowid
        End If
    End If
    
End Sub


'设置父数据窗口的句柄
Public Function SetParentDW(pui As CWebDWUI) As Long
    Set parentDW = pui
    SetParentDW = 0
End Function

Public Function GetItemString(rowid As Long, colid As Long)
    GetItemString = webdwData.GetItemString(rowid, colid)
End Function

Private Function drawImageOnly() As Long
    parentClassDW.DrawDW_ImageOnly
End Function


'得到父类的错误
Private Function getParentErr(iret As Long) As Long
    If iret = -1 Then
        errString = parentClassDW.errString
    End If
End Function

'当文本框上面双击的时候，设置所在父窗口的当前行当前列的对应数值
Private Sub myTextBox_DblClick()
    Dim dataColId As Long
    Dim selectdata As String
    
    Dim pcolId As Long
    Dim prowId As Long
    Dim rowid As Long
    '当在子窗口的控件上进行双击以后，设置父数据窗口的对应内容的数据
    If Not parentDW Is Nothing And dataColumnName > "" Then
        dataColId = webdw.GetColumnIdByColumnName(dataColumnName) '得到数据列序号
            
        rowid = DW_GetRow() '得到当前行
        
        If dataColId > 0 And rowid > 0 Then
            selectdata = GetItemString(rowid, dataColId)    '得到选择的数据
            
            parentDW.GetRowIdColumnId parentControlName, prowId, pcolId '读取父窗口的数据,行列
            
            If prowId > 0 And pcolId > 0 And Len(selectdata) > 0 Then
                parentDW.DW_SetItem prowId, pcolId, selectdata   '设置父窗口数据
                parentDW.DrawDW  '重新绘制
            End If
        End If
    End If

End Sub


