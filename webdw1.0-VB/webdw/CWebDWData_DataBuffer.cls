VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWebDWData_DataBuffer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem WebDW控件对应的数据存储及访问类所使用的数据存储缓存类
Rem 这个类是专门用来定义不同的数据缓存区
Rem 一个DataWindow有如下缓存区:
Rem Primary! = 1 主缓存区，这个缓存区是界面显示用的缓存区
Rem Filter! = 2  过滤缓存区，这个缓存区存放过滤出去的数据
Rem Delete! = 3  删除数据缓存区，所有删除的数据先放到这个缓存区里面
Rem 这样可以明确代码的功能划分，避免代码混乱
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @版权所有 刘峻松 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------

Option Explicit

Public BufferType As Integer    '缓存区的类型，1. Primary 2. Filter 3.Delete

Dim Columns() As String         '列名的集合，来自返回数据，而不是DW定义
Dim DataArray() As String       '所有数据用字符串类型来存储

Public errString As String      '如果调用失败，输出的错误信息。

Public RowNumber As Long        '数据的总行数
Public ColNumber As Long        '列的总数
Public ColLength As Long        '每一行的存储长度

'类成员初始化
Public Function Init() As Integer
    ReDim Columns(1)
    ReDim DataArray(1000)
    errString = ""
    RowNumber = 0
    ColNumber = 0
    ColLength = 0
End Function


'功能描述：从输入的字符串中读取数据，填充columnArray和lineArray
'第一行是列的名称描述，其余行是对应的数据
'这里不处理Null值，数据库上的null值被转换为空字符串

'返回0 成功
'返回-1 失败，错误信息保存在errString中
'sindata    输入数据，字符串表示
'state      数据状态，默认为"normal"
Public Function InitData(sindata As String, Optional state As String = "normal") As Long
    Init                        '调用类初始化的方法
    
    Dim sDataArray As Variant   '原始数据按行分解得到的数组
    Dim vline As Variant        '原始数据每一行
    Dim sline As String         '转换成字符串的原始数据每一行
    
    Dim sdarray As Variant      '中间变量，每一行分解成数据列的数组
    
    Dim lineId As Long          '原始数据的行号，0代表标题，其余代表数据
    Dim colid As Long           '列的序号
    
    ReDim DataArray(1)          '先清空原始数据
    
    sDataArray = Split(sindata, "" & Chr(13) & Chr(10))     '利用回车符号进行分解
    lineId = 0                                              '原始数据的行号
    For Each vline In sDataArray
        sline = vline                                       '读出一行,转成字符串
        If sline = "" Then                                  '遇到空行，退出
            Exit For
        End If
        
        If lineId = 0 Then
            Columns = Split(sline, Chr(9))                 '按chr(9)来分解成列,存到columns里面
            ColNumber = UBound(Columns) + 1                '列的数量,split返回的数组是zero-based.
            ColLength = ColNumber * 2 + 1                  '每一行的长度，等于colnumber*2加1
        Else
            If Trim(sline) = "" Then                        '遇到空行，退出循环
                Exit For
            End If
            
            sdarray = Split(sline, Chr(9))                 '按chr(9)来分解列,分解成多个数据列
            
            If UBound(sdarray) <> UBound(Columns) Then     '检查数据列是否足够，数据不足则报错误
                InitData = -1
                errString = "CWebDWData.ReadDataq数据格式错误:数据列数量不足!行:" & lineId
                Exit Function
            End If
            
            RowNumber = lineId                              '存储当前行数
            
            If UBound(DataArray) < RowNumber * ColLength Then
                ReDim Preserve DataArray(UBound(DataArray) + 1000)  '一次分配1000个空间，避免多次分配
            End If
            
            
            For colid = 1 To ColNumber
                '对null值的特殊处理:将后台返回的NULL变成一个空字符串
                If UCase(sdarray(colid - 1)) = "NULL" Then
                    sdarray(colid - 1) = ""
                End If
            
                DataArray((lineId - 1) * ColLength + colid) = sdarray(colid - 1) '列的数据存储
                DataArray((lineId - 1) * ColLength + ColNumber + colid) = _
                                                              sdarray(colid - 1) '再存储一份作为备份
            Next
            DataArray(lineId * ColLength) = state      'initData的数据是正常状态
            
        End If
        
        lineId = lineId + 1
    Next
End Function


'得到指定行列的数据
'row 行号
'col 列号
'iret 返回值
Public Function GetItemString(row As Long, col As Long, ByRef iret As Long) As String
    '判断行的准确性
    If row < 1 Or row > RowNumber Then
        iret = -1
        errString = "Invalid row:" & row
        GetItemString = ""
        Exit Function
    End If
    
    '判断列的准确性
    If col < 1 Or col > ColNumber Then
        iret = -1
        errString = "Invalid col:" & col
        GetItemString = ""
        Exit Function
    End If
    
    '返回结果数据,GetItemString只能返回当前值，要得到原始值需要调用其它方法
    iret = 0
    GetItemString = DataArray((row - 1) * ColLength + col)
    
End Function

'得到最初的指定行列的数据
'row 行号
'col 列号
'iret 返回值
Public Function GetOriginalItemString(row As Long, col As Long, ByRef iret As Long) As String
    '判断行的准确性
    If row < 1 Or row > RowNumber Then
        iret = -1
        errString = "Invalid row:" & row
        GetOriginalItemString = ""
        Exit Function
    End If
    
    '判断列的准确性
    If col < 1 Or col > ColNumber Then
        iret = -1
        errString = "Invalid col:" & col
        GetOriginalItemString = ""
        Exit Function
    End If
    
    '返回结果数据,GetOriginalItemString只能返回原始值
    iret = 0
    GetOriginalItemString = DataArray((row - 1) * ColLength + ColNumber + col)
    
End Function

'得到指定行的状态数据
'从DataArray中读取，对应行的colnumber + 1的变量就代表其状态
Public Function GetRowState(row As Long, ByRef iret As Long) As String
    '判断行的准确性
    If row < 1 Or row > RowNumber Then
        iret = -1
        errString = "Invalid row:" & row
        GetRowState = ""
        Exit Function
    End If
    
    iret = 0
    GetRowState = DataArray(row * ColLength)  '如果每行5列，第11个数据就代表其状态
End Function

'设置指定行的状态数据
Public Function SetRowState(row As Long, state As String, ByRef iret As Long) As String
    '判断行的准确性
    If row < 1 Or row > RowNumber Then
        iret = -1
        errString = "Invalid row:" + row
        SetRowState = ""
        Exit Function
    End If
    
    iret = 0
    DataArray(row * ColLength) = state
    SetRowState = ""

End Function


'设置指定行列的数据,返回值无用
Public Function SetItemString(row As Long, col As Long, sdata As String) As Long
    
    '判断行的准确性
    If row < 1 Or row > RowNumber Then
        errString = "Invalid row:" & row
        SetItemString = -1
        Exit Function
    End If
    
    '判断列的准确性
    If col < 1 Or col > ColNumber Then
        errString = "Invalid col:" & col
        SetItemString = -1
        Exit Function
    End If
    
    DataArray((row - 1) * ColLength + col) = sdata        '只能设置当前值，历史数据无法设置
    
    If DataArray(row * ColLength) = "normal" Then         '只有当当前状态为normal时，修改为更新
        DataArray(row * ColLength) = "modify"             '这一行状态为更新
    End If
    
    SetItemString = 0
End Function

'设置指定行列的原始数据,返回值无用
Public Function SetOriginalItemString(row As Long, col As Long, sdata As String, _
                                ByRef iret As Long) As String
    '判断行的准确性
    If row < 1 Or row > RowNumber Then
        iret = -1
        errString = "Invalid row:" & row
        SetOriginalItemString = ""
        Exit Function
    End If
    
    '判断列的准确性
    If col < 1 Or col > ColNumber Then
        iret = -1
        errString = "Invalid col:" & col
        SetOriginalItemString = ""
        Exit Function
    End If
    
    iret = 0
    DataArray((row - 1) * ColLength + ColNumber + col) = sdata         '设置历史数据
    
    iret = 0
    SetOriginalItemString = ""
End Function


'根据列的序号，得到列的名称
Public Function GetColumnName(colid) As String
    If colid <= ColNumber And colid >= 0 Then
        GetColumnName = Columns(colid - 1)
    Else
        GetColumnName = ""
    End If
End Function

'类的初始化
Private Sub Class_Initialize()
    Init    '调用类初始化的方法
End Sub

'功能描述：在DataArray中插入一行记录，这行记录用字符串来表示
'rowid:要插入的当前行号，插入以后，这一行数据将代表当前行，如果rowid=0，在最后追加
'sline:用字符串表示的一行记录
'返回值：>0 代表插入以后的行号，-1代表失败，错误信息在errString中
Public Function InsertRow(insertid As Long, sline As String) As Long
    Dim data() As String
    Dim colid As Long
    Dim rowid As Long
    
    If insertid < 0 Or insertid > RowNumber Then
        InsertRow = -1
        errString = "Invalid rowid:" + rowid
        Exit Function
    End If
    
    data = Split(sline, Chr(9))
    
    If UBound(data) <> ColNumber - 1 Then
        InsertRow = -1
        errString = "插入列数据列和要求不符合:" + sline
        Exit Function
    End If
    
    '判断是否需要扩展存储区域
    If UBound(DataArray) < (RowNumber + 1) * ColLength Then
        ReDim Preserve DataArray(UBound(DataArray) + 1000)  '一次分配1000个空间，避免多次分配
    End If

    RowNumber = RowNumber + 1
    
    If insertid > 0 Then
        '先移动现有数据,向后移动一行,包括其状态
        For rowid = RowNumber - 1 To insertid + 1 Step -1
            For colid = 1 To ColLength
                DataArray(rowid * ColLength + colid) = DataArray((rowid - 1) * ColLength + colid)
            Next
        Next
        rowid = insertid
    Else
        rowid = RowNumber
    End If
    
    For colid = 1 To ColNumber
        DataArray((rowid - 1) * ColLength + colid) = ""     '初始化
    Next
    
    '复制插入这一行的数据
    For colid = 1 To ColNumber
        DataArray((rowid - 1) * ColLength + colid) = data(colid - 1)
    Next
    DataArray(rowid * ColLength) = "new"                    '默认情况下，设置为new,在外面可能会修改这个值
    InsertRow = rowid
    
End Function

'功能描述：从当前的数据集合中删除一行记录
'后续记录向前移动一条记录
'返回0 删除成功
'返回-1 删除失败
Public Function DeleteRow(delRowId As Long) As Long
    '判断delrowid的合法性
    If delRowId <= 0 Or delRowId > RowNumber Then
        DeleteRow = -1
        errString = "invalid delete row:" + delRowId
        Exit Function
    End If
    
    Dim colid As Long       '行号
    Dim rowid As Long       '列号
    
    For rowid = delRowId To RowNumber - 1
        For colid = 1 To ColLength
            '等于下一行的数据,包括移动状态
            DataArray((rowid - 1) * ColLength + colid) = DataArray(rowid * ColLength + colid)
        Next
    Next
    
    rowid = RowNumber
    For colid = 1 To ColLength                          '最后一行的数据清空,包括其状态
        DataArray((rowid - 1) * ColLength + colid) = ""
    Next
    
    RowNumber = RowNumber - 1                               '总行数减1
    DeleteRow = 0
End Function

'将某一行表示成一个标准的字符串，各列之间用chr(9)分割
'如果行号非法，返回空字符串
Public Function GetRowString(rowid As Long) As String
    If rowid <= 0 Or rowid > RowNumber Then
        GetRowString = ""
        errString = "Invalid row:" + rowid
        Exit Function
    End If
    
    Dim colid As Long   '列号
    Dim sret As String  '返回字符串
    sret = ""
    For colid = 1 To ColNumber
        If colid < ColNumber Then
            sret = sret & DataArray((rowid - 1) * ColLength + colid) & Chr(9)
        Else
            sret = sret & DataArray((rowid - 1) * ColLength + colid)
        End If
    Next
    
    '返回字符串
    GetRowString = sret
End Function

'将某一行的原始数据表示成一个标准的字符串，各列之间用chr(9)分割
'如果行号非法，返回空字符串
Public Function GetOriginalRowString(rowid As Long) As String
    If rowid <= 0 Or rowid > RowNumber Then
        GetOriginalRowString = ""
        errString = "Invalid row:" + rowid
        Exit Function
    End If
    
    Dim colid As Long   '列号
    Dim sret As String  '返回字符串
    sret = ""
    For colid = 1 To ColNumber
        If colid < ColNumber Then
            sret = sret & DataArray((rowid - 1) * ColLength + ColNumber + colid) & Chr(9)
        Else
            sret = sret & DataArray((rowid - 1) * ColLength + ColNumber + colid)
        End If
    Next
    
    '返回字符串
    GetOriginalRowString = sret
End Function



'得到column()的字符串表示,这一功能用来输出并初始化其它dw
Public Function GetColumnString() As String
    Dim sret As String
    Dim colid As Long
    For colid = 1 To ColNumber
        If colid < ColNumber Then
            sret = sret & Columns(colid - 1) & Chr(9)
        Else
            sret = sret & Columns(colid - 1)
        End If
    Next
    GetColumnString = sret
    
End Function

'将所有的数据都组合成一个字符串返回
Public Function GetAllData() As String
    Dim sret As String
    Dim rowid As Long
    
    sret = ""
    For rowid = 1 To RowNumber
        If sret = "" Then
            sret = GetRowString(rowid)
        Else
            sret = sret & Chr(13) & Chr(10) & GetRowString(rowid)
        End If
    Next
    GetAllData = sret
    
End Function

'功能描述：清空所有的数据，保留列信息
Public Function ResetData() As Long
    
    ReDim DataArray(1000)
    RowNumber = 0
    
End Function

'得到所有行的更新SQL语句组合
Public Function GetAllUpdateSQL(stablename As String, ByRef iret As Long) As String
    Dim rowid As Long
    Dim strsql As String
    Dim sql1 As String
    
    strsql = ""
    For rowid = 1 To RowNumber
        sql1 = GetUpdateSql(stablename, rowid, iret)
        If iret = -1 Then
            GetAllUpdateSQL = ""
            Exit Function
        End If
        
        If sql1 <> "" Then
            If strsql = "" Then
                strsql = sql1
            Else
                strsql = strsql & Chr(13) & Chr(10) & sql1
            End If
        End If
    Next
    
    GetAllUpdateSQL = strsql
    
    
End Function


'得到指定一行的Update SQL语句
'如果是 new,返回一个Insert语句(仅在primarybuffer中)
'如果是 modify,返回一个Update语句(仅在primarybuffer中)
'如果是 modify,normal ,返回一个Delete语句(仅在deleteBuffer中)
'sTableName     要更新的数据表名称
'rowid          要更新的行号
'iret           返回标志位 0 正常 -1 发生错误
Public Function GetUpdateSql(stablename As String, rowid As Long, ByRef iret As Long) As String
    Dim state As String
    Dim strSet As String
    Dim strWhere As String
    
    'part1 primarybuffer的处理,根据状态生成Update和Insert
    If BufferType = 1 Then
        state = GetRowState(rowid, iret)
        If iret = -1 Then
            GetUpdateSql = ""
            Exit Function
        End If
        
        '插入语句的生成
        If state = "new" Then
            GetUpdateSql = GenerateInsertSQL(stablename, rowid, iret)
            If iret = -1 Then
                GetUpdateSql = ""
                Exit Function
            End If
            
            Exit Function
        End If
        
        '更新语句的生成
        If state = "modify" Then
            strSet = GetSetClause(rowid, iret)
            If iret = -1 Then
                GetUpdateSql = ""
                Exit Function
            End If
            
            strWhere = GetWhereClause(rowid, iret)
            If iret = -1 Then
                GetUpdateSql = ""
                Exit Function
            End If
            
            GetUpdateSql = "Update " & stablename & strSet & strWhere
            Exit Function
        End If
        
        GetUpdateSql = ""                       '其他状态下不生成SQL语句,直接返回
        Exit Function
    End If
    
    'part2 filterBuffer的处理                   '目前暂不处理
    If BufferType = 2 Then
        iret = 0
        GetUpdateSql = ""                       '目前暂不处理
    End If
    
    'part3 deleteBuffer的处理
    If BufferType = 3 Then
        state = GetRowState(rowid, iret)        '如果当前状态是new,不处理
        If state <> "new" Then
        
            strWhere = GetWhereClause(rowid, iret)
            If iret = -1 Then
                GetUpdateSql = ""
                Exit Function
            End If
                
            GetUpdateSql = "Delete " & stablename & strWhere
            Exit Function
        End If
    End If
    
    GetUpdateSql = ""

End Function

'生成Insert命令的方法
'暂时只考虑单表的维护问题
'多表的操作方式待定
Private Function GenerateInsertSQL(stablename As String, rowid As Long, ByRef iret As Long) As String
    If BufferType <> 1 Then
        iret = -1
        errString = "Wrong Buffer Type for Insert:" & BufferType
        GenerateInsertSQL = ""
        Exit Function
    End If
    
    If stablename = "" Then
        iret = -1
        errString = "Empty tableName"
        GenerateInsertSQL = ""
        Exit Function
    End If
        
    
    Dim state As String
    state = GetRowState(rowid, iret)
    
    Dim scollist As String
    Dim strsql As String
    Dim colid As Long
    
    If iret = -1 Then       '获取行状态发生错误
        GenerateInsertSQL = ""
        Exit Function
    End If
    
    If state <> "new" Then                                  '不是新建状态
        iret = -1
        errString = "Wrong Row State for Insert:" & state
        GenerateInsertSQL = ""
        Exit Function
    Else                                                    '是新建状态
        scollist = GetColumnList()
        If scollist = "" Then
            iret = -1
            errString = "Empty Column List"
            GenerateInsertSQL = ""
            Exit Function
        End If
        strsql = "Insert Into " & stablename & "(" & scollist & ") Values("
        
        For colid = 1 To ColNumber
            If colid < ColNumber Then
                strsql = strsql & "'" & GetItemString(rowid, colid, iret) & "',"
            Else
                strsql = strsql & "'" & GetItemString(rowid, colid, iret) & "')"
            End If
            
            If iret = -1 Then                               '错误判断
                GenerateInsertSQL = ""
                Exit Function
            End If
        Next
            
        GenerateInsertSQL = strsql
    End If
End Function

'得到列的列表,按照id排列,各字段之间用逗号分割
Private Function GetColumnList() As String
    Dim colid As Long
    Dim slist As String
    slist = ""
    For colid = 0 To ColNumber - 1
        If colid < ColNumber - 1 Then
            slist = slist & Columns(colid) & " , "
        Else
            slist = slist & Columns(colid)
        End If
    Next
    
    GetColumnList = slist
End Function

'根据rowid,生成更新和删除时所需要的Where字句
Private Function GetWhereClause(rowid As Long, iret As Long) As String
    Dim strWhere As String
    Dim colid As Long
    Dim sdata As String
    Dim colwhere As String
    
    strWhere = ""
    For colid = 0 To ColNumber - 1
        sdata = GetOriginalItemString(rowid, colid + 1, iret)
        If iret = -1 Then
            GetWhereClause = ""
            Exit Function
        End If
        
        If sdata = "" Then      '空字符串做空值处理
            colwhere = Columns(colid) & " is null "
        Else
            colwhere = Columns(colid) & " = '" & sdata & "'"
        End If
        
        If strWhere = "" Then
            strWhere = colwhere
        Else
            strWhere = strWhere & " AND " & colwhere
        End If
        
    Next
    If strWhere <> "" Then
        GetWhereClause = " Where " & strWhere
    Else
        GetWhereClause = ""
    End If
End Function

'根据rowid,生成更新和删除时所需要的Where字句
Private Function GetSetClause(rowid As Long, iret As Long) As String
    Dim strSet As String
    Dim colid As Long
    Dim sdata As String
    
    strSet = " Set "
    For colid = 0 To ColNumber - 1
        sdata = GetItemString(rowid, colid + 1, iret)
        If iret = -1 Then
            GetSetClause = ""
            Exit Function
        End If
        
        If colid = 0 Then
            strSet = strSet & Columns(colid) & " = " & "'" & sdata & "' "
        Else
            strSet = strSet & " , " & Columns(colid) & " = " & "'" & sdata & "' "
        End If
    Next
    
    GetSetClause = strSet
End Function

'根据名字来检索列名，返回-1代表没找到
'返回的列序号从1开始，关于行序号和列序号的问题，需要重新规划，统一定义
'现在代码有点混乱
Public Function GetColIdByName(colname As String) As Long
    Dim colid As Long
    For colid = 0 To ColNumber - 1
        If UCase(Columns(colid)) = UCase(colname) Then
            GetColIdByName = colid + 1
            Exit Function
        End If
    Next
    GetColIdByName = -1
End Function

'根据给定的排序条件进行数据排序
'sorter是输入的排序条件
'sorter的格式为 #1 A , #2 D(暂时不处理按照列名排序的要求)
'如果不符合这一格式，则退出
'各条件之间按照逗号进行分割，如果没有AD，则默认为A(升序)
'数据列如果是数值型，按照数值进行判断比较
'数据列如果不是数值型，按照字符串进行判断比较
'暂时不支持日期，时间型的排序比较
Public Function Sort(sorter As String) As Long
    If sorter = "" Then
        Sort = 0
        Exit Function
    End If
    
    Dim rowid As Long
    Dim minrowid As Long
    For rowid = 1 To RowNumber
        minrowid = Sort_GetMinLine(sorter, rowid, RowNumber)   '得到从当前行开始最小的行号
        
        If minrowid = -1 Then                                   '查找最小行失败
            Sort = -1                                           '排序失败
            Exit Function
        End If
        
        If minrowid > rowid Then                                '非当前行
            Sort_SwapLine rowid, minrowid                       '交换数据
        End If
    Next
    
    Sort = 0
End Function

'行交换的功能
'主要用于排序功能
'将两行的数据进行交换
Private Function Sort_SwapLine(row1 As Long, row2 As Long) As Long
    '首先判断输入参数的正确性
    '如果输入参数错误，那么就不进行操作了
    If Not (row1 > 0 And row1 <= RowNumber And row2 > 0 And row2 <= RowNumber) Then
        Sort_SwapLine = -1
        Exit Function
    End If
    
    Dim colid As Long
    Dim stemp As String
    For colid = 1 To ColLength
        stemp = DataArray((row1 - 1) * ColLength + colid)
        DataArray((row1 - 1) * ColLength + colid) = DataArray((row2 - 1) * ColLength + colid)
        DataArray((row2 - 1) * ColLength + colid) = stemp
    Next
End Function

'根据给定的排序条件定义，从beginrow到endrow进行查找，找到最小的一条记录号出来
'返回0代表数据错误,属于调用问题
Private Function Sort_GetMinLine(sorter As String, beginrow As Long, endrow As Long) As Long
    If Not (beginrow > 0 And beginrow <= RowNumber And endrow > 0 And endrow <= RowNumber And beginrow <= endrow) Then
        Sort_GetMinLine = -1
        Exit Function
    End If
    
    Dim rowid As Long
    Dim irow As Long
    
    irow = beginrow
    For rowid = beginrow + 1 To endrow
        irow = Sort_Compare(sorter, irow, rowid)
        If irow = -1 Then
            Sort_GetMinLine = -1
            Exit Function
        End If
    Next
    
    Sort_GetMinLine = irow
End Function

'根据给定的排序条件定义，比较rowid1,rowid2的内容，
'返回rowid1,rowid2中数据较小的那个行数
'这一方法假设rowid1,rowid2都是合法的行数
'返回-1代表比较失败，发生错误
Private Function Sort_Compare(sorter As String, row1 As Long, row2 As Long) As Long
    If sorter = "" Then
        Sort_Compare = -1
        errString = "Compare argument is empty"
        Exit Function
    End If
    
    Dim sorts() As String
    Dim sortid As Long
    Dim sortcolid As Long           '排序字段序号
    Dim sortcoltype As String       '排序字段类型A 升序 D 降序,其他字符一律按升序处理
    Dim coldatatype As String       '列的数据类型定义
    Dim pos1 As Long                '#的位置
    Dim pos2 As Long                '空格的位置
    Dim sdata1 As String
    Dim sdata2 As String
    
    sorts = Split(sorter, ",")  '一个排序条件切分成多个排序条件
    For sortid = 0 To UBound(sorts)
        pos1 = InStr(sorts(sortid), "#")
        If pos1 <= 0 Then
            Sort_Compare = -1
            errString = "Compare argument error"
            Exit Function
        End If
        
        pos2 = InStr(pos1, sorts(sortid), " ") '找到下一个空格的位置
        If pos2 <= 0 Then
            Sort_Compare = -1
            errString = "Compare argument error"
            Exit Function
        End If
        
        If pos2 = pos1 + 1 Then
            Sort_Compare = -1
            errString = "Compare argument error"
            Exit Function
        End If
        
        sortcolid = Mid(sorts(sortid), pos1 + 1, pos2 - (pos1 + 1))
        sortcoltype = UCase(Trim(Mid(sorts(sortid), pos2 + 1)))
        
        If sortcolid < 1 Or sortcolid > ColNumber Then
            Sort_Compare = -1
            errString = "Compare argument error"
            Exit Function
        End If
        
        If sortcoltype = "" Then
            sortcoltype = "A"
        ElseIf sortcoltype <> "A" And sortcoltype <> "D" Then
            Sort_Compare = -1
            errString = "Comapre argument error"
        End If
        
        '判断sortcolid的数据类型，如果是字符串，直接比较
        '如果是数值型，转换成数值进行比较
        '如果不同，那么就可以直接返回退出，否则进行下一轮循环，比较下一个列的大小
        sdata1 = DataArray((row1 - 1) * ColLength + sortcolid)
        sdata2 = DataArray((row2 - 1) * ColLength + sortcolid)
        
        Dim v1 As Double
        Dim v2 As Double
        If IsNumeric(sdata1) And IsNumeric(sdata2) Then '如果两个都是数值型的数据，则比较
            v1 = sdata1
            v2 = sdata2
            If v1 > v2 Then
                If sortcoltype = "A" Then
                    Sort_Compare = row2
                    Exit Function
                Else
                    Sort_Compare = row1
                    Exit Function
                End If
            ElseIf v1 < v2 Then
                If sortcoltype = "A" Then
                    Sort_Compare = row1
                    Exit Function
                Else
                    Sort_Compare = row2
                    Exit Function
                End If
            End If
            '两数相等，继续循环
        Else
            '不是数值，直接比较
            If sdata1 > sdata2 Then
                If sortcoltype = "A" Then
                    Sort_Compare = row2
                    Exit Function
                Else
                    Sort_Compare = row1
                    Exit Function
                End If
            ElseIf sdata1 < sdata2 Then
                If sortcoltype = "A" Then
                    Sort_Compare = row1
                    Exit Function
                Else
                    Sort_Compare = row2
                    Exit Function
                End If
            End If
            '两数相等，继续循环
        End If
    Next
    Sort_Compare = row1     '两者相等，返回第一行
End Function
