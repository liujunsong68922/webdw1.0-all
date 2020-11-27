VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWebDWUIInterpreter"
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
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @版权所有 刘峻松 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------

Option Explicit

Dim myControls(1 To 10000) As Control                       'myControls代表界面上自动创建的控件的集合
                                                            '上述控件的实际物理地址在form上，
                                                            '这里存放的只是一个控件对象的指针

Dim controlSeg As Long                                      '相当于一个控件的序列，每增加一个自动加一
Public webdw As CWebDW                                      '定义webdw对应的文件读取类
Public webdwReader As CWebDWReader                          '定义webdwReader的读取类对象
Public webdwData As CWedDWData                              '定义webdw的数据对象类
Public beginRowId As Long                                   '界面上显示的开始行，默认为1
Public errString As String                                  '返回的错误信息字符串


'画标签的方法
'targetControls 目标窗体或者用户控件的控件集合
'pictTarget 目标图片框
'lineNum    行号0代表绘制表头，其他代表具体的行号
'图形数据来源: g_webdw
Private Function DrawLabel(targetControls As Variant, targetPict As PictureBox, lineNum As Long) As Long
    Dim id As Long
    Dim sname As String
    Dim obj As Control
    Dim top As Long
    
    For id = 1 To 100
        If g_webdw.text(id).name = "" Then
            DrawLabel = 0
            Exit Function
        End If
        
        If lineNum = 0 And g_webdw.text(id).band <> "header" Then   '绘制头部，band不为header,退出
            GoTo ContinueNext
        End If
        
        If lineNum > 0 And g_webdw.text(id).band <> "detail" Then   '绘制细节，band不为detail,退出
            GoTo ContinueNext
        End If
        
        '先计算标签的top值，以此来判断是否需要继续创建对象并绘制之
        If g_webdw.text(id).band = "header" Then top = g_webdw.text(id).y
        If g_webdw.text(id).band = "detail" Then top = g_webdw.text(id).y _
                        + g_webdw.header.height _
                        + g_webdw.detail.height * (lineNum - beginRowId)
                    
        '根据top值进行判断，如果这个值超过了targetPict的范围，就跳出本次循环
        If top <= 0 Or top > targetPict.height Then
            GoTo ContinueNext
        End If
        
        controlSeg = controlSeg + 1
        sname = targetPict.name & "_" & lineNum _
                    & "_" & g_webdw.text(id).name
        
        Set obj = targetControls.Add("VB.Label", sname, targetPict)
        Set myControls(controlSeg) = obj                    '存储对于控件的引用
         
        
        With obj
            .top = top
            .Left = g_webdw.text(id).x
            .width = g_webdw.text(id).width
            .height = g_webdw.text(id).height
            .BorderStyle = 0
            .alignment = g_webdw.text(id).alignment
            .Caption = g_webdw.text(id).text
        End With
        obj.Visible = True
    
ContinueNext:
    Next
End Function

'画文本框的方法
'targetControls 目标控件集合
'pictTarget     要绘制的图片框
'lineNum        行号，从1开始，文本框只在detail区域绘制，不考虑其他区域
Private Function DrawColumn(targetControls As Variant, targetPict As PictureBox, lineNum As Long) As Long
    Dim id As Long
    Dim sname As String
    Dim obj As Control
    Dim top As Long
    Dim iborder As Long
    Dim svalue As String
    
    For id = 1 To 100
        If g_webdw.column(id).name = "" Then    '列名为空，退出执行
            DrawColumn = 0
            Exit Function
        End If
        
        If lineNum = 0 Then                     '控件不可在头部绘制，跳出循环
            GoTo ContinueNext
        End If
        
        '先计算标签的top值，以此来判断是否需要继续创建对象并绘制之
         top = g_webdw.column(id).y + g_webdw.header.height _
                + g_webdw.detail.height * (lineNum - beginRowId)
        
        If top <= 0 Or top > targetPict.height Then
            GoTo ContinueNext
        End If
        
        controlSeg = controlSeg + 1
        sname = targetPict.name & "_" & lineNum _
                    & "_" & g_webdw.column(id).name
        
        svalue = webdwData.getItemString(lineNum, id)
        
         Set obj = targetControls.Add("VB.TextBox", sname, targetPict)
         Set myControls(controlSeg) = obj                    '存储对于控件的引用
        
        
         If g_webdw.column(id).border > 0 Then
            iborder = 1
         Else
            iborder = 0
         End If
         With obj
             .top = top
             .Left = g_webdw.column(id).x
             .width = g_webdw.column(id).width
             .height = g_webdw.column(id).height
             .BorderStyle = iborder
             .alignment = g_webdw.column(id).alignment
             .text = svalue
        End With
         obj.Visible = True
ContinueNext:
    Next
End Function
'类的初始化方法
Private Sub Class_Initialize()
    '初始化时设置controlSeg值
    controlSeg = 0
    Set webdw = New CWebDW                              '设置webdw的存储对象
    Set webdwReader = New CWebDWReader                  '设置webdw的读取对象
    Set webdwData = New CWedDWData                      '设置webdw的数据对象
End Sub


'从窗口删除所有已经创建的按钮
Private Function DeleteAllControl(targetControls As Variant) As Integer
    Dim i As Integer
    For i = 1 To 10000
        If Not (myControls(i) Is Nothing) Then            '这个判断是一个安全性判断，以避免异常情况发生
            targetControls.Remove (myControls(i).name)
            Set myControls(i) = Nothing
        End If
    Next
    controlSeg = 0                                         '复位序列对象
End Function


'根据x,y的位置来判断当前的控件位置
'如果不在任何控件上，返回nothing
'否则返回控件的引用
Public Function GetCurrentObj(x As Single, y As Single, ByRef controlId As Long) As Control
    Dim i As Long
    Dim curObj As Object
    Dim d1 As Double
    Dim d2 As Double
    Dim oldid As Long
    oldid = controlId
    
    For i = 1 To 10000
        Set curObj = myControls(i)
        If curObj Is Nothing Then
            GoTo ContinueNext
        End If
        
        If x > curObj.Left - 20 And x < curObj.Left + curObj.width + 20 _
         And y > curObj.top - 20 And y < curObj.top + curObj.height + 20 Then
            'TODO:精确的判断用户要进入的到底是那个按钮控件
            '这一功能留到以后来具体完成
         Set GetCurrentObj = curObj
         controlId = i
         Exit Function
        End If
        
ContinueNext:
    Next i
    Set GetCurrentObj = Nothing
    controlId = 0
End Function

'功能描述：给出一个控件id号
'判断是否是下拉编辑框，如果是，取得编辑框数据并返回,设置标志为0
'如果不是，返回空字符串,设置标志为-1

'Public Function GetDdlbList(controlId As Long, ByRef iflag As Long) As String
'    Dim id As Long
'    Dim colName As String
'    Dim colid As Long
'
'    iflag = -1
'    GetDdlbList = ""
'    If myControls(controlId) Is Nothing Then
'        Exit Function
'    End If
'
'    id = controlId - webdw.getLableNum()
'    colName = g_webdw.column(id).name
'
'    For colid = 1 To 100
'        If g_webdw.table.columns(colid).name = colName Then
'            GetDdlbList = g_webdw.table.columns(colid).values
'            iflag = 0
'            Exit Function
'        End If
'    Next
'
'End Function
'利用sData来填充数据窗口
'Private Function FillData(targetControls As Variant, pictTarget As PictureBox, sData As String) As Long
'    Dim sDataArray As Variant
'    Dim vline As Variant
'    Dim sline As String
'    Dim lineId As Long
'    Dim colarray As Variant
'    Dim sdarray As Variant
'    Dim sdd As Variant
'    Dim sdd1 As String
'    Dim controlName As String
'    Dim obj As Control
'    Dim id As Long
'    Dim allcol() As String
'
'    sDataArray = Split(sData, "" & Chr(13) & Chr(10)) '利用回车符号进行分解
'    lineId = 0
'    For Each vline In sDataArray
'        sline = vline                                      '读出一行
'        If lineId = 0 Then
'             allcol = Split(sline, Chr(9))             '按chr(9)来分解成列
'        Else
'             sdarray = Split(sline, Chr(9))              '按chr(9)来分解列
'            id = 0
'            For Each sdd In sdarray
'                sdd1 = sdd                                  '列的数据
'                controlName = pictTarget.name & "_" & lineId _
'                            & "_" & allcol(id)
'                id = id + 1
'                Set obj = targetControls(controlName)
'                If Not obj Is Nothing Then
'                    obj.text = sdd1
'                End If
'            Next
'        End If
'
'        lineId = lineId + 1
'    Next
'
'End Function
'初始化DW的方法，这个方法用来在程序开始时初始化指定的数据窗口
'数据窗口实际上是一个PictureBox控件
'利用程序在这个PictureBox上面进行必要的绘图操作出来的
'targetControls : 目标窗体，或者用户控件的控件集合
'targetPict     : 目标picturebox,本程序在一个picturebox上进行绘图
'vscroll        : targetPict对应的vscrollbar，这个vscrollbar表示当前的开始行(beginRowId)
'sUIDesc        : sUIDesc代表用户界面的字符串表示
'sData          : sData代表给定的数据表示

Public Function initDW(targetControls As Variant, targetPict As PictureBox, _
                        vscroll As VScrollBar, convertRate As Double, _
                       sUIDesc As String, sData As String) As Long
    Dim iret As Long
    Dim totalHeight As Long
    Dim rowid As Long
    Dim colid As Long
    Dim controlName As String
    Dim obj As Control
    
    'step1:初始化界面表示,初始化完毕以后，界面信息存储在g_webdw里面了
    iret = webdw.convertDW(sUIDesc)
    
    If iret = -1 Then                   '如果发生错误，截获错误，抛出错误（异常?）
        initDW = -1
        errString = webdw.errString
        Exit Function
    End If
    
    'step2:初始化数据表示，初始化完毕后，实际数据存储在webdwData里面了，可以通过方法来访问
    iret = webdwData.ReadData(sData)
    
    If iret = -1 Then                   '如果发生错误，截获错误，抛出错误（异常?）
        initDW = -1
        errString = webdwData.errString
        Exit Function
    End If
    
    'step3:计算逻辑高度，根据需要设置VscrollBar的数据
    totalHeight = g_webdw.header.height _
                + g_webdw.detail.height * webdwData.GetRowCount() _
                + g_webdw.footer.height
    totalHeight = totalHeight / convertRate         '坐标逻辑转换比例
    
    If totalHeight > targetPict.height Then       '如果逻辑高度大于物理高度，则设置滚动条
        vscroll.Min = 0
        vscroll.Max = (totalHeight - targetPict.height) / g_webdw.detail.height * convertRate
        vscroll.SmallChange = 1                                        '翻记录
        vscroll.LargeChange = targetPict.height / g_webdw.detail.height * convertRate '翻页
        vscroll.Value = 0
        vscroll.Enabled = True
    Else
        vscroll.Enabled = False
        vscroll.Max = 0
        vscroll.Min = 0
        vscroll.Value = 0
    End If
'    beginRowId = vscroll.Value + 1                  '开始行代表这个滚动条数据+1
'
'    '开始绘制图形数据
'
'    For rowid = 0 To webdwData.GetRowCount()
'        iret = DrawLabel(targetControls, targetPict, rowid)
'        iret = DrawColumn(targetControls, targetPict, rowid)
'    Next rowid
    DrawDW targetControls, targetPict, 1            '从第一行开始绘制
    
End Function

'绘制DW的方法,begId代表开始绘制的一行.
Public Function DrawDW(targetControls As Variant, targetPict As PictureBox, begId As Long) As Long
    Dim rowid As Long
    Dim iret As Long
    
    'step1 设置beginRowId
    beginRowId = begId
    
    'step2 删除所有控件
    DeleteAllControl targetControls
    
    'step3 重新绘制
    For rowid = 0 To webdwData.GetRowCount()
        iret = DrawLabel(targetControls, targetPict, rowid)
        iret = DrawColumn(targetControls, targetPict, rowid)
    Next rowid
    
    
End Function

