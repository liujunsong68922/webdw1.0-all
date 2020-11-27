VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWebDWData"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem WebDW控件对应的数据存储及访问类
Rem 这个类是专门用来操作实际数据的
Rem 数据通过一个固定格式的字符串来进行初始化
Rem 数据存储在CWebDWData中
Rem 这样可以明确代码的功能划分，避免代码混乱
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @版权所有 刘峻松 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------

Option Explicit

Public PrimaryBuffer As New CWebDWData_DataBuffer   '主Buffer定义
Public FilterBuffer As New CWebDWData_DataBuffer    '过滤Buffer定义
Public DeleteBuffer As New CWebDWData_DataBuffer    '删除Buffer定义

Public errString As String      '如果调用失败，输出的错误信息。
Private data_filter As String   '数据的过滤条件定义
Private data_sorter As String   '数据的排序条件定义

'功能描述：从输入的字符串中读取数据，填充columnArray和lineArray
'返回0 成功
'返回-1 失败，错误信息保存在errString中
'sindata    输入数据
'state      数据状态,可选项，默认为normal
Public Function InitData(sindata As String, Optional state As String = "normal") As Long
    PrimaryBuffer.InitData sindata, state
    
    Dim sColumn As String                   'sColumn取sindata第一行,代表列定义
    sColumn = PrimaryBuffer.GetColumnString
    
    FilterBuffer.InitData sColumn
    DeleteBuffer.InitData sColumn
    
End Function

'功能描述：清空所有的数据，只保留基本的结构
Public Function ResetData() As Long
    
    PrimaryBuffer.ResetData
    FilterBuffer.ResetData
    DeleteBuffer.ResetData
    
End Function

'功能描述：删除一行
'具体处理方式是：在primarybuffer中删除一行，后续数据前移
'把这一行插入到deletebuffer中去，在最后一行

Public Function DeleteRow(rowid As Long) As Long
    Dim sdata As String
    Dim newrowid As Long
    Dim colid As Long
    Dim iret As Long
    
    sdata = ""
    
    If rowid > 0 And rowid <= PrimaryBuffer.RowNumber Then
        
        '复制当前数据
        sdata = PrimaryBuffer.GetRowString(rowid)
        newrowid = DeleteBuffer.InsertRow(0, sdata)
        
        '复制这条数据的原始数据
        For colid = 1 To PrimaryBuffer.ColNumber
            sdata = PrimaryBuffer.GetOriginalItemString(rowid, colid, iret)
            If iret = -1 Then
                DeleteRow = -1
                Exit Function
            End If
            DeleteBuffer.SetOriginalItemString newrowid, colid, sdata, iret
            
            If iret = -1 Then
                DeleteRow = -1
                Exit Function
            End If
            
            sdata = PrimaryBuffer.GetRowState(rowid, iret)
            DeleteBuffer.SetRowState newrowid, sdata, iret
        Next
        
        '删除原buffer的数据
        PrimaryBuffer.DeleteRow (rowid)
    End If

End Function

'在primarybuffer中插入一行,这一行的标记为new
Public Function InsertRow(rowid As Long, sdata As String) As Long
    Dim iret As Long
    iret = PrimaryBuffer.InsertRow(rowid, sdata)
    InsertRow = iret
    If iret = -1 Then
        errString = PrimaryBuffer.errString
    End If
End Function

'得到行的数量
Public Function GetRowCount(Optional BufferType As Integer = 1) As Long
    Select Case BufferType
        Case 1
            GetRowCount = PrimaryBuffer.RowNumber
        Case 2
            GetRowCount = FilterBuffer.RowNumber
        Case 3
            GetRowCount = DeleteBuffer.RowNumber
        Case Else
            GetRowCount = 0
    End Select
End Function

'得到列的数量
Public Function GetColumnNumber(Optional BufferType As Integer = 1) As Long
    Select Case BufferType
        Case 1
            GetColumnNumber = PrimaryBuffer.ColNumber
        Case 2
            GetColumnNumber = FilterBuffer.ColNumber
        Case 3
            GetColumnNumber = DeleteBuffer.ColNumber
        Case Else
            GetColumnNumber = 0
    End Select
    
End Function

'功能描述:得到指定行列的数据
'row:行号
'col:列号
'buffertype: 可选，buffer类型，默认为主缓存区
Public Function GetItemString(row As Long, col As Long, Optional BufferType As Integer = 1) As String
    Dim iret As Long
    Dim sret As String
    
    '根据不同的buffertype来进行不同对象的调用
    Select Case BufferType
        Case 1
            sret = PrimaryBuffer.GetItemString(row, col, iret)
        Case 2
            sret = FilterBuffer.GetItemString(row, col, iret)
        Case 3
            sret = DeleteBuffer.GetItemString(row, col, iret)
    End Select
    
    GetItemString = sret
        
End Function

'功能描述：设置指定行列的数据
'row: 行号
'col: 列号
'buffertype 可选项，默认为1
Public Function SetItemString(row As Long, col As Long, sdata As String, _
                                Optional BufferType As Integer = 1) As Long
    
    Dim iret As Long
    
    If BufferType = 1 Then
        iret = PrimaryBuffer.SetItemString(row, col, sdata)
        If iret = -1 Then
            errString = PrimaryBuffer.errString
        End If
    End If
    If BufferType = 2 Then
        iret = FilterBuffer.SetItemString(row, col, sdata)
        If iret = -1 Then
            errString = FilterBuffer.errString
        End If
    End If
    If BufferType = 3 Then
        iret = DeleteBuffer.SetItemString(row, col, sdata)
        If iret = -1 Then
            errString = DeleteBuffer.errString
        End If
    End If
    
    SetItemString = iret
        
End Function

Private Sub Class_Initialize()
    '类初始化时，设置三个不同buffer的类型变量
    PrimaryBuffer.BufferType = 1        '1代表主缓存区
    FilterBuffer.BufferType = 2         '2代表过滤缓存区
    DeleteBuffer.BufferType = 3         '3代表删除缓存区
    data_filter = ""                    '默认情况下没有数据的过滤条件
    
End Sub

'根据DataBuffer的当前状态，得到要更新的SQL语句，
'此处返回的是多条SQL语句，组合在一个String中
'多个SQL语句之间用chr(13)chr(10)来进行分割
'最后一行不包括回车符号
'从PrimaryBuffer和DeleteBuffer中检索数据，FilterBuffer不涉及
'sTableName     数据表名称
'iret           返回标志位0 正常 -1 失败
Public Function GetUpdateSql(stablename As String, ByRef iret As Long) As String

    Dim sql1 As String
    Dim sql2 As String
    
    sql1 = PrimaryBuffer.GetAllUpdateSQL(stablename, iret)
    If iret = -1 Then
        GetUpdateSql = ""
        Exit Function
    End If
    
    sql2 = DeleteBuffer.GetAllUpdateSQL(stablename, iret)
    If iret = -1 Then
        GetUpdateSql = ""
        Exit Function
    End If
    
    If sql1 <> "" Then
        GetUpdateSql = sql1 & Chr(13) & Chr(10) & sql2
    Else
        GetUpdateSql = sql2
    End If
End Function

'在成功调用Update以后进行处理
'清空DeleteBuffer
'将primaryBuffer中的modify的状态改为normal
Public Function AfterUpdate() As Long
    
    '清空DeleteBuffer
    DeleteBuffer.Init
    
    Dim rowid As Long
    Dim iret As Long
    For rowid = 1 To PrimaryBuffer.RowNumber
        PrimaryBuffer.SetRowState rowid, "normal", iret
    Next
        
End Function

'得到所有的字符串
Public Function GetAllData() As String
    GetAllData = PrimaryBuffer.GetAllData()
End Function

'得到列的序号
Public Function GetColIdByName(colname As String) As Long
    GetColIdByName = PrimaryBuffer.GetColIdByName(colname)
End Function

'得到指定行的状态数据
'从DataArray中读取，对应行的colnumber + 1的变量就代表其状态
Public Function GetRowState(row As Long, ByRef iret As Long) As String
    GetRowState = PrimaryBuffer.GetRowState(row, iret)
End Function

'得到当前定义的数据过滤条件
Public Function GetDataFilter() As String
    GetDataFilter = data_filter
End Function

'设置当前的数据过滤条件
'返回0代表设置成功
Public Function SetDataFilter(Filter As String) As Long
    data_filter = Filter
    SetDataFilter = 0
End Function

'此功能需要一个语法解释器的支持，来计算每一行的返回值是否是Boolean型的
'来决定是否要放置入过滤缓冲区之中
'因此这一方法需要等待VB的解释器完成以后才能实现
'暂时先跳过
'如果直接使用VB提供的解释器，未来还是无法脱离这个基本环境来运行
'那样的话就要受很多的限制了
Public Function Filter() As Long
    'TODO:完成这一功能
End Function

'功能描述：得到当前数据窗口设置的排序条件定义
Public Function GetDataSorter() As String
    GetDataSorter = data_sorter
End Function

'功能描述：设置数据窗口当前的排序条件定义
'返回0代表设置成功
Public Function SetDataSorter(sorter As String) As Long
    data_sorter = sorter
    SetDataSorter = 0
End Function

'功能描述：按照上面给定的排序方式进行排序处理
Public Function Sort() As Long
    Sort = PrimaryBuffer.Sort(data_sorter)
    errString = PrimaryBuffer.errString
End Function

