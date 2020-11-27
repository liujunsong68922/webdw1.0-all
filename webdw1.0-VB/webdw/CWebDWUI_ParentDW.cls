VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWebDWUI_ParentDW"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem WebDW用户界面解析器，VB功能类
Rem 这个类有两个子类
Rem CWebDWUI 和 CWebDWChildDW
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

Public errString As String                                  '返回的错误信息字符串
Dim controlSeg As Long                                      '相当于一个控件的序列，每增加一个自动加一
Dim myControls(1 To 10000) As Control                       'myControls代表界面上自动创建的控件的集合
                                                            '上述控件的实际物理地址在form上，
                                                            '这里存放的只是一个控件对象的指针
'-------------------------------本地组合类定义------------------------------------------------------
Public webdw As CWebDW                                     '定义webdw对应的文件读取类
Public webdwData As CWebDWData                              '定义webdw的数据对象类
Public sqlca As CWebDWTransaction                           '事务支持？SQL访问支持对象
Public childDW As CWebDWUI_ChildDW                          '子数据窗口的类定义
Public displayformate As CWebDWDisplayFormat                '数据显示格式化
Public gridLineColor As Long                                '表格线的颜色定义

'------------下面的定义是界面上的对应元素定义，这个定义在setdataobject中设置
    Dim targetControls As Variant  '这个容器，表示所有的控件集合容器对象,在SetDataObject中初始化设置,20090116日添加
    Dim targetPict   As PictureBox '这个代表要进行绘制的PictureBox,20090116日添加
    Dim VScroll_Page As vscrollbar '表示一页内变化的VScrollBar,最大翻动到一页
    Dim VScroll_Line As vscrollbar '表示行变化的VScrollBar,一次最少翻动一行
    Dim HScroll_Page As HScrollBar '表示页面左右翻动的HscrollBar，一次翻动半页
    Dim ImagePoint As Image         '指示当前行用的图标,可以用底色图片来表示当前行
    Dim childPict As PictureBox     '子数据窗口绘制用的窗口
'------------界面元素的定义完毕

'------------下面的定义是界面上的动态元素对应的事件处理器定义
    Private WithEvents myTextBox As TextBox             'myTextBox是一个虚拟的文本框，用来定义文本框事件响应
Attribute myTextBox.VB_VarHelpID = -1
    Private WithEvents myOptionButton As OptionButton   'myOptionButton是一个虚拟的选择按钮，定义选择按钮响应
Attribute myOptionButton.VB_VarHelpID = -1
    Private WithEvents myCheckBox As checkbox           'myCheckBox是一个虚拟的检查框，定义选择按钮响应
Attribute myCheckBox.VB_VarHelpID = -1
    Private WithEvents myComboBox As combobox           'myComboBox是一个虚拟的下拉框，定义响应事件
Attribute myComboBox.VB_VarHelpID = -1
'------------界面动态元素定义完毕
Private currentRow As Long                               '界面当前行定义
Private local_webdw As WebDWSyntax                       'g_webdw现在是一个局部变量了，而不是全局变量了
Private langsupport As CMultiLang                        '多语言支持对象定义

'功能描述：设置local_webdw的值
'输入：gg_webdw
'输出：local_webdw
Public Function SetLocalWebDW()
    local_webdw = GG_webdw
End Function

'功能描述：读取local_webdw的值
'输入:local_webdw
'输出:gg_webdw
Public Function GetLocalWebDW()
    GG_webdw = local_webdw
End Function


'画标签的方法
'targetControls 目标窗体或者用户控件的控件集合
'pictTarget 目标图片框
'lineNum    行号0代表绘制表头，其他代表具体的行号
'leftpos    所有元素的左偏移量 leftpos <=0
'图形数据来源: g_webdw
Public Function DrawLabel(lineNum As Long, Optional leftPos As Long = 0) As Long
    Dim id As Long
    Dim sname As String
    Dim obj As Control
    Dim top As Long
    Dim stf As StdFont
    Dim beginRowid As Long
    Dim convertRate As Double
    
    beginRowid = VScroll_Line.value + 1
    convertRate = GF_GetConvertRate(targetControls)
    
    For id = 1 To 100
        If local_webdw.text(id).Name = "" Then
            DrawLabel = 0
            Exit Function
        End If
        
        If lineNum = 0 And local_webdw.text(id).band <> "header" Then   '绘制头部，band不为header,退出
            GoTo continueNext
        End If
        
        If lineNum > 0 And local_webdw.text(id).band <> "detail" Then   '绘制细节，band不为detail,退出
            GoTo continueNext
        End If
        
        '先计算标签的top值，以此来判断是否需要继续创建对象并绘制之
        If local_webdw.text(id).band = "header" Then top = local_webdw.text(id).Y * convertRate
        If local_webdw.text(id).band = "detail" Then top = Int(local_webdw.text(id).Y * convertRate) _
                        + Int(local_webdw.header.height * convertRate) _
                        + Int(local_webdw.detail.height * convertRate) * (lineNum - beginRowid)
                    
        '根据top值进行判断，如果这个值超过了targetPict的范围，就跳出本次循环
        If top <= 0 Or top > targetPict.height Then
            GoTo continueNext
        End If
        
        If top >= 0 And top <= local_webdw.header.height * convertRate _
            And local_webdw.text(id).band <> "header" Then
            GoTo continueNext
        End If
        
        
        '为了避免创建无效的控件，仅创建在当前界面可见范围内的控件出来
        '行号的判断在DrawDW中进行
        '此处仅判断width是否超标
        If (local_webdw.text(id).X + local_webdw.text(id).width) * convertRate + leftPos < 0 Or _
           (local_webdw.text(id).X * convertRate + leftPos) > targetPict.width Then
            GoTo continueNext
        End If
        
        sname = targetPict.Name & "_" & lineNum _
                    & "_" & local_webdw.text(id).Name
        controlSeg = controlSeg + 1
        Set obj = targetControls.Add("VB.Label", sname, targetPict) '创建控件
        Set myControls(controlSeg) = obj                            '存储对于控件的引用
        
        With obj
            .top = top
            .Left = local_webdw.text(id).X * convertRate + leftPos                    '加上对应的偏移量
            .width = local_webdw.text(id).width * convertRate
            .height = local_webdw.text(id).height * convertRate
            .BorderStyle = 0
            .alignment = local_webdw.text(id).alignment
            .Caption = local_webdw.text(id).text
            
            '增加对颜色的支持20081219日添加
            If local_webdw.text(id).background_mode = 2 Then    '不是透明显示模式，取标签颜色
                .BackColor = GF_GetVBColor( _
                            local_webdw.text(id).background_color, 256# * 256 * 256 - 1)
            Else                                                '透明显示模式，取对应底色
                .BackColor = GF_GetVBColor(local_webdw.datawindow.color, 256# * 256 * 256 - 1)
            End If
            
            .ForeColor = GF_GetVBColor( _
                            local_webdw.text(id).color, 256# * 256 * 256 - 1)
                            
        End With
        
        '增加对字体的支持20081219日添加
        Set stf = New StdFont
        stf.Bold = (local_webdw.text(id).font.weight > 500)
        stf.italic = (local_webdw.text(id).font.italic > 0)
        stf.underline = (local_webdw.text(id).font.underline > 0)
        stf.strikethrough = (local_webdw.text(id).font.strikethrough > 0)
        stf.Name = local_webdw.text(id).font.face
        stf.Size = local_webdw.text(id).font.height * -1 * convertRate / 4 '考虑转换比例，将字体size做调整
        stf.weight = local_webdw.text(id).font.weight
            
        Set obj.font = stf
        obj.Visible = True
    
continueNext:
    Next
End Function

'画文本框的方法
'lineNum        行号，从1开始，文本框只在detail区域绘制，不考虑其他区域
'leftpos        左偏移量，对象向左偏移leftpos<0
Public Function DrawColumn(lineNum As Long, Optional leftPos As Long = 0) As Long
    
    Dim id As Long
    Dim sname As String
    Dim obj As Control
    Dim top As Long
    Dim iborder As Long
    Dim svalue As String
    Dim stf As StdFont
    Dim beginRowid As Long
    Dim convertRate As Double
    Dim rowstate As String
    Dim iret As Long
    
    beginRowid = VScroll_Line.value + 1
    convertRate = GF_GetConvertRate(targetControls)
    rowstate = webdwData.GetRowState(lineNum, iret)
    If iret = -1 Then
        DrawColumn = -1
        Exit Function
    End If
    
    For id = 1 To 100
        If local_webdw.column(id).Name = "" Then    '列名为空，退出本列的执行，继续循环
            GoTo continueNext
        End If
        
        If lineNum = 0 Then                     '控件不可在头部绘制，跳出循环
            GoTo continueNext
        End If
        
        '先计算标签的top值，以此来判断是否需要继续创建对象并绘制之
         top = Int(local_webdw.column(id).Y * convertRate) _
                + Int(local_webdw.header.height * convertRate) _
                + Int(local_webdw.detail.height * convertRate) * (lineNum - beginRowid)
        
        If top <= 0 Or top > targetPict.height Then
            GoTo continueNext
        End If
        
        If top >= 0 And top <= local_webdw.header.height * convertRate And local_webdw.column(id).band <> "header" Then
            GoTo continueNext
        End If
        
        '判断对象的偏移，看是否要创建
        If (local_webdw.column(id).X + local_webdw.column(id).width) * convertRate + leftPos < 0 Or _
            local_webdw.column(id).X * convertRate + leftPos > targetPict.width Then
            GoTo continueNext
        End If
        
        controlSeg = controlSeg + 1
        sname = targetPict.Name & "__" & lineNum _
                    & "__" & local_webdw.column(id).Name
        
        svalue = webdwData.GetItemString(lineNum, id)      '得到原始信息数据
        
        Set obj = targetControls.Add("VB.TextBox", sname, targetPict)
        Set myControls(controlSeg) = obj                    '存储对于控件的引用
        
        iborder = GF_IF_Long(local_webdw.column(id).border > 0, 1, 0)        '是否有边框
         
        With obj
            .top = top
            .Left = local_webdw.column(id).X * convertRate + leftPos         '加上偏移量
            .width = local_webdw.column(id).width * convertRate
            .height = local_webdw.column(id).height * convertRate
            .BorderStyle = iborder
            .alignment = local_webdw.column(id).alignment
            .text = svalue
            If local_webdw.column(id).format <> "[general]" And IsNumeric(svalue) Then
                .text = displayformate.GetFormateDecimal(svalue, local_webdw.column(id).format) '显示当前数据的未格式化内容
            End If
            
            
            '.Enabled = False
            '颜色的支持20081219日完成
            If local_webdw.column(id).background_mode = 2 Then  '不是透明模式，取本控件背景色
               .BackColor = GF_GetVBColor( _
                   local_webdw.column(id).background_color, 256# * 256 * 256 - 1)
            Else                                                '透明模式，取数据窗口背景色
                .BackColor = GF_GetVBColor( _
                    local_webdw.datawindow.color, 256# * 256 * 256 - 1)
            End If
            .ForeColor = GF_GetVBColor( _
                   local_webdw.column(id).color, 256# * 256 * 256 - 1)
        End With
        
        '增加对字体的支持20081219日添加
        Set stf = New StdFont
        stf.Bold = (local_webdw.column(id).font.weight > 500)
        stf.italic = (local_webdw.column(id).font.italic > 0)
        stf.underline = (local_webdw.column(id).font.underline > 0)
        stf.strikethrough = (local_webdw.column(id).font.strikethrough > 0)
        stf.Name = local_webdw.column(id).font.face
        stf.Size = local_webdw.column(id).font.height * -1 * convertRate / 4
        stf.weight = local_webdw.column(id).font.weight
            
        Set obj.font = stf
        
        '对tabsequence属性的支持add by liujunsong2009-2-6
        '如果tabsequence是32766，那么设置这个对象为锁定状态，不可修改，新行不锁定
        If local_webdw.column(id).tabsequence = 32766 And rowstate <> "new" Then
            obj.Locked = True
        End If
        obj.Visible = True
        
        'Add by Liujunsong 2009-1-23 增加对Edit Style的支持
        '如果这一列指定了显示格式，那么在界面上将数据进行格式化输出
        '如果这一列指定需要将编码转换成名称，那么就在显示时进行转换
        '先考虑增加列表转换的支持
        
        '增加单选按钮的支持20090123
        Dim valuestring As String
        valuestring = local_webdw.table.Columns(id).values   '得到values表示
        
        '--------------------------单选框编辑风格支持开始-----------------------------
        Dim radioobj As Control
        Dim frameObj As Control       '单选按钮的容器Frame对象
        Dim value() As String
        Dim radioid As Long         'radio序号
        Dim radioValue As String    'radio值
        Dim radioDisplay As String  'radio显示
        Dim tabpos As Long
        
        If valuestring > "" And _
             local_webdw.column(id).radiobuttons.Columns > 0 Then  '是单选按钮编辑风格
                '如果是单选钮风格，需要先创建一个包含它的容器出来
                sname = targetPict.Name & "__" & lineNum & "__" _
                            & local_webdw.column(id).Name & "__" & "Frame"
                Set frameObj = targetControls.Add("VB.Frame", sname, targetPict)
                controlSeg = controlSeg + 1
                Set myControls(controlSeg) = frameObj
                frameObj.Left = obj.Left
                frameObj.top = obj.top
                frameObj.width = obj.width - 10 * convertRate
                frameObj.height = obj.height
                frameObj.BackColor = obj.BackColor
                frameObj.Visible = True
                
                '然后再在这个容器的基础上来创建选择按钮
                value = Split(valuestring, "/")
                For radioid = 0 To UBound(value)
                    If value(radioid) = "" Then
                        Exit For
                    End If
                    
                    tabpos = InStr(1, value(radioid), Chr(9))       'value中Tab键的位置
                    If tabpos > 0 Then
                        radioDisplay = Left(value(radioid), tabpos - 1)
                        radioValue = Mid(value(radioid), tabpos + 1, Len(value(radioid)) - tabpos)
                    Else
                        radioDisplay = ""
                        radioValue = ""
                        Exit For        '数据格式错误，跳过这个列的显示
                    End If
                    
                    sname = targetPict.Name & "__" & lineNum & "__" _
                            & local_webdw.column(id).Name & "__" & radioValue
                            
                    Set radioobj = targetControls.Add("VB.OptionButton", sname, frameObj)
                    controlSeg = controlSeg + 1
                    Set myControls(controlSeg) = radioobj
                    
                    radioobj.Caption = radioDisplay
                    radioobj.Left = 10 * convertRate
                    radioobj.top = (30 + 60 * radioid) * convertRate
                    radioobj.width = obj.width - 40 * convertRate
                    radioobj.height = 50 * convertRate
                    radioobj.tag = radioValue                   '把对应值放在tag属性里面
                    radioobj.BackColor = obj.BackColor          '按钮本身的背景色定义
                    radioobj.ForeColor = obj.ForeColor          '文本本身的前景色定义
                    radioobj.Visible = True
                    
                    '根据当前字段的数据，与radioobj代表的数据比较，如果相同，就设置选中状态
                    radioobj.value = (radioValue = svalue)
                    
                    '增加对tabsequence的支持20090206
                    If local_webdw.column(id).tabsequence = 32766 And rowstate <> "new" Then
                        radioobj.Enabled = False
                    End If
                    
                    obj.Visible = False                  '原来创建的文本框控件为不可见
                Next '循环判断radio的结束
        End If '如果是单选框编辑风格定义的结束
        '------------------------单选框编辑风格结束----------------------------------------
        
        '------------------------选择框编辑风格开始----------------------------------------
        Dim myCheckBox As checkbox
        If valuestring > "" And local_webdw.column(id).checkbox.text > "" Then
            sname = targetPict.Name & "__" & lineNum & "__" & local_webdw.column(id).Name & "__CheckBox"
            '对象名之所以重新定义一个，是因为和obj重名了
            Set myCheckBox = targetControls.Add("VB.CheckBox", sname, targetPict)
            
            controlSeg = controlSeg + 1
            Set myControls(controlSeg) = myCheckBox     '存储对于控件的指针
            
            myCheckBox.top = obj.top
            myCheckBox.Left = obj.Left
            myCheckBox.width = obj.width
            myCheckBox.height = obj.height
            myCheckBox.Caption = local_webdw.column(id).checkbox.text
            myCheckBox.value = GF_IF_Long(local_webdw.column(id).checkbox.on = svalue, 1, 0)
            myCheckBox.ForeColor = obj.ForeColor
            myCheckBox.BackColor = obj.BackColor
            '增加对tabsequence的支持
            If local_webdw.column(id).tabsequence = 32766 And rowstate <> "new" Then
                myCheckBox.Enabled = False
            End If
            
            myCheckBox.Visible = True
            obj.Visible = False
        End If  '复选框的编辑风格结束
        '------------------------选择框编辑风格结束----------------------------------------
        
        '------------------------下拉列表框编辑风格结束----------------------------------------
        Dim myComboBox As combobox
        Dim combovalues() As String
        Dim combostring As String
        Dim combotabpos As Long
        Dim combo_display As String
        Dim combo_value As String
        Dim combo_id As Long
        
        If valuestring > "" And local_webdw.column(id).combobox.allowedit > "" Then
            sname = targetPict.Name & "__" & lineNum & "__" & local_webdw.column(id).Name & "__ComboBox"
            '对象名重定义，是因为和obj有重名的问题
            Set myComboBox = targetControls.Add("VB.ComboBox", sname, targetPict)
            
            controlSeg = controlSeg + 1
            Set myControls(controlSeg) = myComboBox
        
            myComboBox.Left = obj.Left
            myComboBox.top = obj.top
            myComboBox.width = obj.width
            myComboBox.ForeColor = obj.ForeColor
            myComboBox.BackColor = obj.BackColor
            'myComboBox.height = obj.height     '系统下拉框的属性是只读的
            
            combovalues = Split(valuestring, "/")
            For combo_id = 0 To UBound(combovalues)
                If combovalues(combo_id) = "" Then
                    Exit For
                End If
                
                combotabpos = InStr(1, combovalues(combo_id), Chr(9))
                If combotabpos > 0 Then
                    combo_display = Mid(combovalues(combo_id), 1, combotabpos - 1)
                    combo_value = Mid(combovalues(combo_id), combotabpos + 1)
                    myComboBox.AddItem combo_display, combo_id
                    
                    If combo_value = svalue Then            '如果数值相同，则设置ListIndex
                        myComboBox.ListIndex = combo_id
                    End If
                End If
            Next
            
            '增加对tabsequence的支持20090206
            If local_webdw.column(id).tabsequence = 32766 And rowstate <> "new" Then
                myComboBox.Locked = False
            End If
            
            myComboBox.Visible = True
            obj.Visible = False
        End If
        '------------------------下拉列表框编辑风格结束----------------------------------------
        
        '------------------------下拉数据窗口编辑风格的支持------------------------------------
        If local_webdw.column(id).dddw.Name > "" And local_webdw.column(id).dddw.DataColumn > "" _
          And local_webdw.column(id).dddw.DisplayColumn > "" And local_webdw.column_dddw_data(id) > "" _
          And local_webdw.column_dddw_data(id) > "" Then
            '在下拉数据窗口中，按照制定的列进行检索，如果找到此值，设置其界面显示
            childDW.webdwData.InitData local_webdw.column_dddw_data(id)
            
            Dim rowid As Long
            Dim sourcecolid As Long
            Dim displayColId As Long
            
            sourcecolid = childDW.webdwData.GetColIdByName(local_webdw.column(id).dddw.DataColumn)
            displayColId = childDW.webdwData.GetColIdByName(local_webdw.column(id).dddw.DisplayColumn)
            
            If sourcecolid > 0 And displayColId > 0 Then
                For rowid = 1 To childDW.DW_RowCount
                    If childDW.webdwData.GetItemString(rowid, sourcecolid) = svalue Then
                        obj.text = childDW.webdwData.GetItemString(rowid, displayColId)
                        Exit For
                    End If
                Next
            End If
        End If
        '------------------------下拉数据窗口编辑风格的支持结束---------------------------------
        
continueNext:
    Next
End Function
'类的初始化方法
Private Sub Class_Initialize()
    '初始化时设置controlSeg值
    controlSeg = 0
    Set webdw = New CWebDW                              '设置webdw的语法对象
    Set webdwData = New CWebDWData                      '设置webdw的数据对象
    Set sqlca = New CWebDWTransaction                   '事务管理对象
    gridLineColor = QBColor(8)                          '默认为灰色线条
    Set langsupport = New CMultiLang                    '多语言支持对象类定义
    Set displayformate = New CWebDWDisplayFormat        '数据显示格式化对象
    
    '初始化界面元素指针为空
    initAllObjectPoint
End Sub

'功能描述：初始化所有指向界面元素的对象指针为Nothing
'如果调用SetDataObject失败，则初始化所有对象指针
'在类初始化时也调用这一方法
Private Function initAllObjectPoint() As Long
    '初始化各个界面对象的指针指向为Nothing
    Set targetControls = Nothing
    Set targetPict = Nothing
    Set VScroll_Line = Nothing
    Set VScroll_Page = Nothing
    Set HScroll_Page = Nothing
    Set ImagePoint = Nothing
End Function

'设置dataobject对象，dataobject对象用一个字符串来描述
'这是一个新实现的方法，这个方法中不再传递vscroll,hscroll这些对象
'而是通过其名称来进行访问
'childflag 是否检索子数据窗口的标志位 true 检索 false 不检索子窗口
Public Function DW_SetDataObject(targetControlsArg As Variant, targetPictArg As PictureBox, _
                             sUIDesc As String, Optional childFlag As Boolean = True) As Long
    
    Dim convertRate As Double
    'step1: 设置对象的连接
    '首先把对象和界面上的控件连接起来
    '确保这些对象是实际存在的
    '为了简化程序的结构，目前暂不考虑动态生成这些所有控件
    
    'step1.设置targetControls和targetPict这两个变量
    If targetControlsArg Is Nothing Then
        errString = "Cannot set targetControls"
        GoTo SETDATAOBJECTERROR
    End If
    
    If targetPictArg Is Nothing Then
        errString = "Cannot set targetPict"
        GoTo SETDATAOBJECTERROR
    End If
    
    Set targetControls = targetControlsArg
    Set targetPict = targetPictArg
    
    'step1.2 set vscroll_page
    Set VScroll_Page = GF_GetObjectByName(targetControls, targetPict.Name & "_Vscroll_Page")
    If VScroll_Page Is Nothing Then
        errString = "Cannot find Vscroll_Page"
        GoTo SETDATAOBJECTERROR
    End If
    
    'step1.3 set vscroll_line
    Set VScroll_Line = GF_GetObjectByName(targetControls, targetPict.Name & "_Vscroll_Line")
    If VScroll_Line Is Nothing Then
        errString = "Cannot find Vscroll_Line"
        GoTo SETDATAOBJECTERROR
    End If
    
    'step1.4 set hscroll_page
    Set HScroll_Page = GF_GetObjectByName(targetControls, targetPict.Name & "_HScroll_Page")
    If HScroll_Page Is Nothing Then
        errString = "Cannot find HScroll_Page"
        GoTo SETDATAOBJECTERROR
    End If
    
    'step1.5 set ImagePoint，代表当前行标示的图标
    Set ImagePoint = GF_GetObjectByName(targetControls, targetPict.Name & "_ImagePoint")
    If ImagePoint Is Nothing Then
        errString = "Cannot find ImagePoint"
        GoTo SETDATAOBJECTERROR
    End If
    
    'step1.6 set ChildPict，代表子数据窗口
    Set childPict = GF_GetObjectByName(targetControls, "PictureChild")
    If childPict Is Nothing Then
        errString = "Cannot find PictureChild"
        GoTo SETDATAOBJECTERROR
    End If
    
   
    'step1.7 得到界面定义文件和界面元素之间的转换比例定义
    convertRate = GF_GetConvertRate(targetControls)
    
    'step2:初始化界面表示,初始化完毕以后，界面信息存储在g_webdw里面了
    Dim iret As Long
    Dim columnString As String
    iret = webdw.Create(sUIDesc)
    
    If iret = -1 Then                   '如果发生错误，截获错误，抛出错误（异常?）
        errString = webdw.errString
        GoTo SETDATAOBJECTERROR
    End If
    
    
    '如果初始化成功，那么需要通过公用变量GG_webdw来进行数据传输
    webdw.GetLocalWebDW          '设置gg_webdw的数值
    SetLocalWebDW                '设置本地g_webdw的数值
    
    '调用方法，如果存在下拉式数据窗口，配置读取信息
    If childFlag Then
        retrieveChildDW         '检索所有的子窗口
    End If
    'step3:初始化数据存储，初始化完毕后，实际数据存储在webdwData里面了，可以通过方法来访问
    columnString = webdw.GetColumnDefineString
    iret = webdwData.InitData(columnString)       '用列字符串来进行初始化,否则插入时不能成功
    
    If iret = -1 Then                   '如果发生错误，截获错误，抛出错误（异常?）
        errString = webdwData.errString
        GoTo SETDATAOBJECTERROR
    End If
    
    'step4:设置VscrollBar,HscrollBar
    VScroll_Line.Max = 0
    VScroll_Line.Min = 0
    VScroll_Line.value = 0
    VScroll_Line.Visible = True
    
    VScroll_Page.Max = 0
    VScroll_Page.Min = 0
    VScroll_Page.value = 0
    VScroll_Page.Visible = False
    
    
    '根据最大宽度来设置hscroll的属性
    Dim maxwidth As Long
    maxwidth = webdw.getMaxWidth() * convertRate
    If maxwidth <= targetPict.width Then
        HScroll_Page.Min = 0
        HScroll_Page.Max = 0
        HScroll_Page.value = 0
        HScroll_Page.Enabled = False
    Else
        HScroll_Page.Min = 0
        HScroll_Page.Max = (maxwidth - targetPict.width) * 2 / targetPict.width + 1
        HScroll_Page.SmallChange = 1
        HScroll_Page.largechange = 2
        'targetPict.width = maxwidth
        HScroll_Page.Enabled = True
    End If
    
    'step 5绘制图形出来
    currentRow = 0
    DrawDW                  '从第一行开始绘制
    
    DW_SetDataObject = 0    '正常退出
    Exit Function
    
SETDATAOBJECTERROR:         '错误处理代码
    initAllObjectPoint      '初始化所有对象指针为Nothing
    DW_SetDataObject = -1   '发生错误

End Function

'一个新增加的接口,功能和DW_SetDataObject类似
'区别在于一个传入的是一个字符串
'一个传入的是数据窗口的名字，从后台直接检索这个文件再进行初始化调用
Public Function DW_SetDataObjectByName(targetControlsArg As Variant, targetPictArg As PictureBox, _
                             sdwName As String) As Long
    Dim sUIDefine As String
    sUIDefine = GetDWSyntaxByName(sdwName)
    
    If sUIDefine = "" Then
        DW_SetDataObjectByName = -1
        errString = "Cannot find DW Deine:" & sdwName
        Exit Function
    End If
    
    DW_SetDataObjectByName = DW_SetDataObject(targetControlsArg, targetPictArg, sUIDefine)
                                 
End Function
'给定一个数据窗口的名称
'从后台检索它的定义
'返回""代表没有找到
Public Function GetDWSyntaxByName(dwname As String) As String
    Dim iret As Long
    Dim strdefine As String
    
    strdefine = sqlca.GetDWDefine(dwname, iret) '检索对象定义,对象名称作为参数传入
    If iret = -1 Then
        errString = sqlca.errString
        GetDWSyntaxByName = ""
    Else
        GetDWSyntaxByName = strdefine
    End If
End Function

'绘制DW的方法,begId代表开始绘制的一行.begId>0
'targetControls: 目标控件的集合 输入
'targetPict:    要绘制的目标图片框 输入
Public Function DrawDW() As Long

    '先判断是否成功调用了SetDataObject方法
    If targetControls Is Nothing _
        Or targetPict Is Nothing _
        Or VScroll_Line Is Nothing Then
        DrawDW = -1
        errString = "Please Call SetDataObject First"
        Exit Function
    End If


    Dim rowid As Long
    Dim iret As Long
    Dim i As Long
    Dim childid As Long
    Dim linetop As Long
    Dim beginRowid As Long          '开始行数
    Dim convertRate As Double       '转换比例
    Dim leftPos As Long             '左偏移量，根据vscrollbar来计算
   
    'step1 从界面上读取横向滚动条和纵向滚动条
    beginRowid = VScroll_Line.value + 1             '开始点是当前的Value+1
    convertRate = GF_GetConvertRate(targetControls) '从界面上得到转换比例
    leftPos = HScroll_Page.value * targetPict.width * -0.5  '左偏移量
    
    'step2 删除所有控件
    For i = 10000 To 1 Step -1
        If Not (myControls(i) Is Nothing) Then            '这个判断是一个安全性判断，以避免异常情况发生
            targetControls.Remove (myControls(i).Name)
            Set myControls(i) = Nothing
        End If
    Next
    controlSeg = 0                                         '复位序列对象
    
    'step3绘制表头
        iret = DrawLabel(0, leftPos)
        iret = DrawColumn(0, leftPos)
        iret = DrawLine(0, leftPos)
    
    'step4 重新绘制表体
    For rowid = beginRowid To webdwData.GetRowCount()
        linetop = local_webdw.header.height + local_webdw.detail.height * (rowid - beginRowid)
        If linetop * convertRate > targetPict.height Then   '如果行的开头已经超过了targetPict，停止绘制
            Exit For
        End If
        
        iret = DrawLabel(rowid, leftPos) '绘制这一行的Label
        iret = DrawColumn(rowid, leftPos) '绘制这以行的Column
        iret = DrawLine(rowid, leftPos) '绘制这一行的Line
    Next rowid
    
    'step5.绘制targetPict的底色
    targetPict.BackColor = GF_GetVBColor( _
                    local_webdw.datawindow.color, 256# * 256 * 256 - 1)
                    
    'step6.根据当前行，在前面设置一个图标
    DrawDW_ImageOnly
    
    'step7.如果是grid风格，则执行绘制表格线的方法
    DrawGridLine
End Function

'绘制图形的方法，只不过这个方法只绘制当前行指示符号而已
Public Function DrawDW_ImageOnly() As Long
    Dim convertRate As Double
    convertRate = GF_GetConvertRate(targetControls)
    'step6.根据当前行，在前面设置一个图标
    If currentRow > 0 Then
        If currentRow > VScroll_Line.value Then
            ImagePoint.top = (local_webdw.header.height _
            + local_webdw.detail.height * (currentRow - VScroll_Line.value - 1)) * convertRate
            ImagePoint.Visible = True
        Else
            ImagePoint.top = (local_webdw.header.height _
            + local_webdw.detail.height * (currentRow - VScroll_Line.value - 1)) * convertRate
            ImagePoint.Visible = False
        End If
        
        '根据当前数据窗口的高度，来判断是否要覆盖显示
        If local_webdw.detail.height > 200 Then '可能是单行显示，待完善
            ImagePoint.width = 100
        Else
            ImagePoint.width = targetPict.width '多行显示的情况
        End If
    
    Else
        ImagePoint.Visible = False
    End If
    
    DrawGridLine    '重画网格线
    DrawDW_ImageOnly = 1
End Function

'当当前界面是Grid风格的时候，绘制一个网格线出来
'绘制算法：先绘制表头的两根横线
'再绘制每行绘制一根横线
'再绘制每个框的左面一条竖线
Public Function DrawGridLine() As Long
    Dim maxwidth As Long
    Dim leftPos As Long
    Dim beginRowid As Long
    Dim convertRate As Double
    Dim rowid As Long
    Dim colid As Long
    Dim iheight As Long
    Dim ileft As Long
    Dim linecolor As Long
    
    
    beginRowid = VScroll_Line.value + 1
    convertRate = GF_GetConvertRate(targetControls)
    leftPos = HScroll_Page.value * targetPict.width * -0.5  '左偏移量
    maxwidth = webdw.getMaxWidth() * convertRate + 10
    linecolor = gridLineColor
    
    '先把所有绘制的线擦掉
    targetPict.Cls
    
    If local_webdw.datawindow.grid_lines = "0" Then   '如果需要绘制网格线
        iheight = local_webdw.header.height * convertRate      'iheight现在代表头部的高度

        targetPict.Line (10 + leftPos, 10)-(maxwidth + leftPos, 10), linecolor '表头的一条线
        targetPict.Line (10 + leftPos, iheight)-(maxwidth + leftPos, iheight), linecolor '表头的底线
        
        
        For rowid = beginRowid To DW_RowCount()
            iheight = local_webdw.header.height * convertRate      'iheight现在代表头部的高度
            iheight = iheight + (rowid - beginRowid + 1) * Int(local_webdw.detail.height * convertRate)
1
            targetPict.Line (10 + leftPos, iheight)-(maxwidth + leftPos, iheight), linecolor '一行画一条横线
        Next
        'iheight现在代表数据窗口的最大高度
        
        '对于网格形状的数据窗口，画竖线出来
        For colid = 1 To 100
            If local_webdw.column(colid).Name <> "" Then
                ileft = (local_webdw.column(colid).X * convertRate) - 20 + leftPos
                targetPict.Line (ileft, 10)-(ileft, iheight), linecolor
            End If
        Next
        
        targetPict.Line (maxwidth + leftPos, 10)-(maxwidth + leftPos, iheight), linecolor '画最右面一条竖线
        
    End If
End Function

'在界面上画线的方法
'通过这个方法支持在界面上进行画线
'leftpos 左偏移量 leftpos<=0
Public Function DrawLine(lineNum As Long, Optional leftPos As Long = 0) As Long
    Dim id As Long
    Dim sname As String
    Dim obj As Control
    Dim top As Long
    Dim beginRowid As Long
    Dim convertRate As Double
    
    beginRowid = VScroll_Line.value + 1
    convertRate = GF_GetConvertRate(targetControls)
    
    For id = 1 To 100
        If local_webdw.lineinfo(id).Name = "" Then
            DrawLine = 0
            Exit Function
        End If
        
        If lineNum = 0 And local_webdw.lineinfo(id).band <> "header" Then    '绘制头部，band不为header,退出
            GoTo continueNext
        End If
        
        If lineNum > 0 And local_webdw.lineinfo(id).band <> "detail" Then   '绘制细节，band不为detail,退出
            GoTo continueNext
        End If
        
        '先计算标签的top值，以此来判断是否需要继续创建对象并绘制之
        If local_webdw.lineinfo(id).band = "header" Then top = local_webdw.lineinfo(id).y1
        If local_webdw.lineinfo(id).band = "detail" Then
            top = local_webdw.lineinfo(id).y1 _
                        + local_webdw.header.height _
                        + local_webdw.detail.height * (lineNum - beginRowid)
        End If
                    
        '根据top值进行判断，如果这个值超过了targetPict的范围，就跳出本次循环
        If top <= 0 Or top * convertRate > targetPict.height Then
            GoTo continueNext
        End If
        
        If top >= 0 And top <= local_webdw.header.height And local_webdw.lineinfo(id).band <> "header" Then
            GoTo continueNext
        End If
        
        '根据x1,x2判断是否要划线出来
        If local_webdw.lineinfo(id).x1 * convertRate + leftPos < 0 And _
            local_webdw.lineinfo(id).x2 * convertRate + leftPos < 0 Then
            GoTo continueNext
        End If
        
        If local_webdw.lineinfo(id).x1 * convertRate + leftPos > targetPict.width And _
            local_webdw.lineinfo(id).x2 * convertRate + leftPos > targetPict.width Then
            GoTo continueNext
        End If
        
        sname = targetPict.Name & "_" & lineNum _
                    & "_" & local_webdw.lineinfo(id).Name
        controlSeg = controlSeg + 1
        Set obj = targetControls.Add("VB.Line", sname, targetPict)
        Set myControls(controlSeg) = obj                    '存储对于控件的引用
        
        With obj
            .y1 = top * convertRate
            .x1 = local_webdw.lineinfo(id).x1 * convertRate + leftPos    '加上偏移量
            .x2 = local_webdw.lineinfo(id).x2 * convertRate + leftPos     '加上偏移量
            .y2 = (local_webdw.lineinfo(id).y2 + top - local_webdw.lineinfo(id).y1) * convertRate
        End With
        obj.Visible = True
    
continueNext:
    Next

End Function


'数据窗口的检索功能，等价功能dw.Retrieve()
'前提条件是已经设置了datawindow对象
'args是检索调用的参数，各个参数之间用TAB键分割
'20090116对参数进行修改，targetControls和targetPict不再需要外部传入
Public Function DW_Retrieve(Optional args As String = "") As Long
    
    '先判断targetControls和targetPict已经正常赋值
    If targetControls Is Nothing Or targetPict Is Nothing Then
        DW_Retrieve = -1
        errString = "Please Call SetDataObject First."
        Exit Function
    End If
    
    Dim strsql As String
    Dim sdata As String
    Dim argArray As Variant
    Dim arg As Variant
    Dim sarg As String
    Dim argid As Long
    Dim iret As Long
    
      
    
    'strsql = webdwReader.GetRetrieveSQL()           '得到检索用的SQL语句
    strsql = DW_GetSQLSelect()
    
    '替换各个自定义变量
    argArray = Split(args, "" & Chr(9))
    argid = 1
    For Each arg In argArray
        sarg = arg
        strsql = Replace(strsql, ":arg" & argid, sarg)
        argid = argid + 1
    Next
    
    sqlca.opertype = 1
    sqlca.beginPos = 0
    sqlca.readNum = 1000
    sqlca.command = strsql
    sdata = sqlca.ExecuteSelect(iret)              '执行sql,得到数据结果
    
    If iret = -1 Then
        DW_Retrieve = -1
        errString = sqlca.errString
        Exit Function
    End If
    '利用新数据，初始化数据窗口
     SetData sdata
     DrawDW
    
End Function

'利用给定的数据，来初始化数据存储
'targetControls 控件的集合
'pictTarget     要绘图的控件
'indata         重新设置的数据
'datastate      可选项,数据的状态,默认为"normal"
Public Function SetData(indata As String, _
                        Optional datastate As String = "normal") As Long
    Dim iret As Long
    Dim convertRate As Double
    Dim largechange As Long
    
    '增加判断，如果没有初始化，则不执行
    If targetControls Is Nothing Then
        SetData = -1
        errString = "Please Call SetDataObject() first!"
        Exit Function
    End If
    
    convertRate = GF_GetConvertRate(targetControls)                  '得到转换比例
    
    iret = webdwData.InitData(indata, datastate)
    
    If iret = -1 Then
        MsgBox webdwData.errString
        Exit Function
    End If
    
    If webdwData.GetRowCount() > 0 Then
        VScroll_Line.Max = webdwData.GetRowCount() - 1
        VScroll_Line.Min = 0
        VScroll_Line.SmallChange = 1
        largechange = (targetPict.height - local_webdw.header.height * convertRate _
                                    - local_webdw.footer.height * convertRate) / (local_webdw.detail.height * convertRate)
        If largechange < 1 Then
            VScroll_Line.largechange = 1
        Else
            VScroll_Line.largechange = largechange
        End If
        VScroll_Line.Enabled = True
    Else
        VScroll_Line.Max = 0
        VScroll_Line.Min = 0
        VScroll_Line.value = 0
        VScroll_Line.Enabled = False
    End If
    
    If webdwData.GetRowCount() > 0 And currentRow = 0 Then
        currentRow = 1
    End If
    
    If webdwData.GetRowCount() = 0 Then
        currentRow = 0
    End If
    
End Function
'功能描述：删除当前行
'返回0 成功
'返回-1 发生错误
Public Function DW_DeleteRow(rowid As Long) As Long
    '逻辑判断，调用前先初始化数据窗口控件
    If targetControls Is Nothing Or targetPict Is Nothing Then
        DW_DeleteRow = -1
        errString = "Please Call SetDataObject First."
        Exit Function
    End If

    '如果传入参数小于等于0，直接退出
    If rowid <= 0 Then
        DW_DeleteRow = 0
        Exit Function
    End If
    
    Dim iret As Long
    iret = webdwData.DeleteRow(rowid)
    
    '删除数据时发生错误，退出
    If iret = -1 Then
        DW_DeleteRow = -1
        errString = webdwData.errString
        Exit Function
    End If
    
    '设置滚动条的最大值
    If VScroll_Line.Max > 0 Then
        VScroll_Line.Max = VScroll_Line.Max - 1
    End If
    
    '如果界面的当前行已经溢出，重新设置，如果数据为空，当前行为0
    If currentRow > webdwData.GetRowCount Then
        currentRow = webdwData.GetRowCount
    End If
    
    DrawDW                             '刷新数据
    
End Function
'功能描述：得到当前行
'要得到当前行，需要传入当前所在对象的ID号
Public Function DW_GetRow() As Long
    '先判断targetControls和targetPict已经正常赋值
    If targetControls Is Nothing Or targetPict Is Nothing Then
        DW_GetRow = -1
        errString = "Please Call SetDataObject First."
        Exit Function
    End If
    
    DW_GetRow = currentRow
End Function
'设置当前行
Public Function DW_SetRow(rowid As Long) As Long
    If rowid > 0 And rowid <= DW_RowCount() Then
        currentRow = rowid
        DW_SetRow = 1           '返回1代表成功
    Else
        DW_SetRow = -1          '返回-1代表失败
    End If
End Function

'根据给定的当前控件的名字，判断当前所在列的序号
'返回-1代表失败，>=0代表序号
Public Function GetRowIdColumnId(currentControlName As String, _
                                    ByRef rowid As Long, ByRef colid As Long) As Long
    If currentControlName = "" Then
        GetRowIdColumnId = -1
        Exit Function
    End If
    
    Dim pos1 As Long
    Dim pos2 As Long
    Dim pos3 As Long
    pos1 = InStr(1, currentControlName, "__")                    '第一个双下划线的位置
    If pos1 <= 0 Then
        GetRowIdColumnId = -1
        Exit Function
    End If
        
    pos2 = InStr(pos1 + 1, currentControlName, "__")             '第二个双下划线的位置
    If pos2 <= 0 Then
        GetRowIdColumnId = -1
        Exit Function
    End If
    
    pos3 = InStr(pos2 + 1, currentControlName, "__")              '第三个双下划线的位置（可能没有)
    
    rowid = Mid(currentControlName, pos1 + 2, pos2 - pos1 - 2)  '得到行号
    
    Dim columnName As String
    If pos3 > 0 Then
        columnName = Mid(currentControlName, pos2 + 2, pos3 - pos2 - 2) '得到列名
    Else
        columnName = Mid(currentControlName, pos2 + 2)             '得到列名
    End If
        
    colid = webdw.GetColumnIdByColumnName(columnName)                 '得到列号
    GetRowIdColumnId = 0
End Function

'设置数据,只能设置PrimaryBuffer的数据
Public Function DW_SetItem(rowid As Long, colid As Long, sdata As String) As Long
    Dim iret As Long
    Dim strinfo As String
    Dim coltype As String
    Dim stemp As String
    Dim sCNinfo As String
    Dim sENinfo As String
    Dim ColLength As Long
    Dim ipos As Long
    Dim ipos2 As Long
    
    '此处增加输入数据的校验功能，以确保要设置的数据符合原始的定义要求
    '只有在输入数据满足这些要求的情况下，才真正设置数据，否则不进行数据的设置
    
    'step1:输入字段长度的校验问题
    '增加一个字段长度的判断
    '如果输入的长度已经超过了数据库可以容纳的长度，那么就提示错误信息
    '让用户有机会自己来修正错误
    If local_webdw.column(colid).edit_limit > 0 Then    '如果存在输入限制
        If GF_GetDBlength(sdata) > local_webdw.column(colid).edit_limit Then
                sCNinfo = "输入项超过数据库许可:" & sdata & "\r\n" _
                                        & "最大长度:" & local_webdw.column(colid).edit_limit & "\r\n" _
                                        & "当前长度:" & GF_GetDBlength(sdata)
                sENinfo = "Item too large for Database store:" & sdata & "\r\n" _
                                        & "Max length:" & local_webdw.column(colid).edit_limit & "\r\n" _
                                        & "Current length:" & GF_GetDBlength(sdata)
                strinfo = langsupport.SumAllLang(sCNinfo, sENinfo)
                strinfo = langsupport.GetCurrent(strinfo)
                
                MsgBox strinfo, vbExclamation, "WebDW Error"
                DW_SetItem = -1
                Exit Function
        End If
    Else
        '如果输入的限制为0,那么要判断是否是字符型,如果是字符型,取其数据类型中定义的长度来进行长度限制判断
        coltype = local_webdw.table.Columns(colid).type '得到数据类型
        If InStr(coltype, "char") > 0 Then
            ipos = InStr(coltype, "(")
            If ipos > 0 Then
                ColLength = Mid(coltype, ipos + 1, Len(coltype) - ipos - 1) '字符串的宽度定义,同数据库中的长度定义,pb自动生成维护
                If GF_GetDBlength(sdata) > ColLength Then
                    sCNinfo = "输入项超过数据库许可:" & sdata & "\r\n" _
                                        & "最大长度:" & ColLength & "\r\n" _
                                        & "当前长度:" & GF_GetDBlength(sdata)
                    sENinfo = "Item too large for Database store:" & sdata & "\r\n" _
                                        & "Max length:" & ColLength & "\r\n" _
                                        & "Current length:" & GF_GetDBlength(sdata)
                    strinfo = langsupport.SumAllLang(sCNinfo, sENinfo)
                    strinfo = langsupport.GetCurrent(strinfo)
                
                    MsgBox strinfo, vbExclamation, "WebDW Error"
                    DW_SetItem = -1
                    Exit Function
                End If
            End If
        End If
    End If
    
    'step2:输入数据的数据类型校验问题
    '如果数据类型是数值型，检查输入的数据是否是数值型
    coltype = local_webdw.table.Columns(colid).type     '数据类型
    '如果数据类型是数值型
    If InStr(coltype, "number") > 0 Or InStr(coltype, "int") > 0 Or InStr(coltype, "long") > 0 _
         Or InStr(coltype, "decimal") > 0 Then
        If Not IsNumeric(sdata) Then
            sCNinfo = "数据类型不匹配:" & sdata & "\r\n" & "所需数据类型:" & coltype
            sENinfo = "Item not match data type:" & sdata & "\r\n" & "Require DataType:" & coltype
            
            strinfo = langsupport.SumAllLang(sCNinfo, sENinfo)
            strinfo = langsupport.GetCurrent(strinfo)
            MsgBox strinfo, vbExclamation, "WebDW Error"
            DW_SetItem = -1
            Exit Function
        End If
    End If
    
    '如果数据类型是long型,而输入数据带有小数点后的数字,则提示不支持小数位
    If coltype = "long" Or coltype = "int" Or coltype = "integer" Or coltype = "smallint" Then
        ipos = InStr(sdata, ".")
        If ipos > 0 Then
            stemp = Mid(sdata, ipos + 1)
            stemp = Trim(stemp)
            If stemp <> "" Then
                sCNinfo = "数据类型不匹配:" & sdata & "\r\n" & "所定义数据类型不支持小数位:" & coltype
                sENinfo = "DataType mismatch:" & sdata & "\r\n" & "long datatype requied:" & coltype
                
                strinfo = langsupport.SumAllLang(sCNinfo, sENinfo)
                strinfo = langsupport.GetCurrent(strinfo)
                
                MsgBox strinfo, vbExclamation, "WebDW Error"
                DW_SetItem = -1
                Exit Function
            End If
        End If
    End If
        
    Dim datatype_jingdu As Long '数据类型定义精度
    Dim data_jingdu As Long     '输入数据精度
    '输入数据类型是decimal型,输入数据带有小数位,而且小数点后数据精度超过了定义,则给出提示,但不直接退出
    If InStr(coltype, "decimal") > 0 Then
        ipos = InStr(coltype, "(")
        ipos2 = InStr(coltype, ")")
        If ipos > 0 And ipos2 > 0 Then
            datatype_jingdu = Mid(coltype, ipos + 1, ipos2 - ipos - 1)
            ipos = InStr(sdata, ".")
            If ipos > 0 Then
                stemp = Mid(sdata, ipos + 1)
                stemp = Trim(stemp)
                data_jingdu = Len(stemp)
                
                If data_jingdu > datatype_jingdu Then
                    sCNinfo = "数据精度溢出:" & sdata & "\r\n数据库精度: " & datatype_jingdu _
                                & "\r\n数据精度: " & data_jingdu
                    sENinfo = "data decimal over:" & sdata & "\r\n db need:" & datatype_jingdu _
                                & "\r\n input data decimal:" & data_jingdu
                    
                    strinfo = langsupport.SumAllLang(sCNinfo, sENinfo)
                    strinfo = langsupport.GetCurrent(strinfo)
                    
                    MsgBox strinfo, vbExclamation, "WebDW Warning:"
                End If
            End If
        End If
    End If
    
    
    iret = webdwData.SetItemString(rowid, colid, sdata)
    If iret = -1 Then
        errString = webdwData.errString
    End If
    
    DW_SetItem = iret
End Function

'得到最近要提交到后台的更新数据库的命令集合
'多条命令之间用chr(13)chr(10)来分隔
'目前仅支持单表的更新操作所需要的SQL命令
Public Function DW_GetSQLPreview(ByRef iret As Long) As String
        
    'step1 检查是否进行了初始化
    '先判断targetControls和targetPict已经正常赋值
    If targetControls Is Nothing Or targetPict Is Nothing Then
        DW_GetSQLPreview = ""
        iret = -1
        errString = "Please Call SetDataObject First."
        Exit Function
    End If
    
        
    Dim stable As String    '数据表名称
    
    If local_webdw.table.retrieve.pbselect.table(2) <> "" Then  '目前仅支持单表，如果是多表，退出
        iret = 0
        DW_GetSQLPreview = ""
        Exit Function
    End If
    
    If local_webdw.table.retrieve.pbselect.table(1) = "" Then   '如果第一个表名为空，退出
        iret = -1
        DW_GetSQLPreview = ""
        errString = "ERROR: no table define"
        Exit Function
    End If
    
    stable = local_webdw.table.retrieve.pbselect.table(1)
    stable = Replace(stable, "~" & """", "")                '得到表名，替换掉其中的~"
    
    DW_GetSQLPreview = webdwData.GetUpdateSql(stable, iret)
       
End Function

'执行Dw的Update方法,更新数据
'返回0代表调用成功
'返回-1代表调用发生错误
'将targetControls,targetPict都从参数中去掉
Public Function DW_Update() As Long
    
    'step1 判断是否初始化
    If targetControls Is Nothing Or targetPict Is Nothing Then
        DW_Update = -1
        errString = "Please Call SetDataObject First."
        Exit Function
    End If

    Dim strsql As String
    Dim sdata As String
    Dim iret As Long
    
    'step1 得到UpdateSQL
    strsql = DW_GetSQLPreview(iret)
    
    If iret = -1 Then
        DW_Update = -1
        Exit Function
    End If
    
    'step2 提交SQL命令
    '此处需要进行修正，数据窗口不可直接提交
    '必须通过sqlca的commit方法提交，
    
    
    sqlca.opertype = 2      '执行update方法
    sqlca.beginPos = 0
    sqlca.readNum = 1000
    sqlca.command = Replace(strsql, "" & Chr(13) & Chr(10), "----------")
    sdata = sqlca.ExecuteUpdate(iret)              '执行sql,得到数据结果
    
    If iret = -1 Or sqlca.errString > "" Then
        iret = -1
        DW_Update = -1
        errString = sqlca.errString
        Exit Function
    End If
    
    '更新数据库成功以后，应当把数据的状态改掉
    '调用webdwdata中的方法
    '目前下面的流程都走不到，需要进行修改
    webdwData.AfterUpdate
    
    DW_Update = 0   '正常退出
    
End Function

'得到当前DataWindow内的记录总数
'返回-1代表失败
'正常情况返回值>=0
Public Function DW_RowCount() As Long
    'step1 判断是否初始化
    If targetControls Is Nothing Or targetPict Is Nothing Then
        DW_RowCount = -1
        errString = "Please Call SetDataObject First."
        Exit Function
    End If
    
    DW_RowCount = webdwData.GetRowCount
End Function

'在数据窗口中插入一条记录，返回这条记录的当前行号，如果出错，返回-1
'rowid代表要插入的行号，如果为0代表在最后插入
Public Function DW_InsertRow(rowid As Long) As Long
    'step1 判断是否初始化
    If targetControls Is Nothing Or targetPict Is Nothing Then
        DW_InsertRow = -1
        errString = "Please Call SetDataObject First."
        Exit Function
    End If

    Dim emptystring As String
    Dim colid  As Long
    Dim colNum As Long
    colNum = webdwData.GetColumnNumber
    emptystring = ""
    For colid = 1 To colNum
        If emptystring = "" Then
            emptystring = " "
        Else
            emptystring = emptystring & Chr(9) & ""
        End If
    Next
    
    Dim iret As Long
    iret = webdwData.InsertRow(rowid, emptystring)
    
    If iret = -1 Then
        errString = webdwData.errString
    Else
        VScroll_Line.Max = VScroll_Line.Max + 1
    End If
    
    DW_InsertRow = iret
    
    DrawDW
End Function

'设置当前的文本框对象，以使之可以响应外部事件
Public Function SetTextBox(textArg As TextBox) As Long
    Dim iret As Long
    Dim rowid As Long
    Dim colid As Long
    
    iret = GetRowIdColumnId(textArg.Name, rowid, colid)
    If iret = 0 Then
        If rowid <> currentRow Then
            currentRow = rowid
            DrawDW_ImageOnly
        End If
    End If

    Set myTextBox = textArg
    'myTextBox_Click
End Function

'设置子数据窗口的TextBox对象
Public Function SetChildTextBox(textArg As TextBox) As Long
    SetChildTextBox = childDW.SetTextBox(textArg)
End Function

'设置当前的单选框对象，以使之可以响应外部事件
Public Function SetOptionButton(OptionButtonArg As OptionButton) As Long
    Dim iret As Long
    Dim rowid As Long
    Dim colid As Long
    
    iret = GetRowIdColumnId(OptionButtonArg.Name, rowid, colid)
    If iret = 0 Then
        If rowid <> currentRow Then
            currentRow = rowid
            DrawDW_ImageOnly
        End If
    End If

    Set myOptionButton = OptionButtonArg
End Function

'设置当前的复选框对象，使之可以响应外部事件
Public Function SetCheckBox(checkArg As checkbox) As Long
    Dim iret As Long
    Dim rowid As Long
    Dim colid As Long
    
    iret = GetRowIdColumnId(checkArg.Name, rowid, colid)
    If iret = 0 Then
        If rowid <> currentRow Then
            currentRow = rowid
            DrawDW_ImageOnly
        End If
    End If

    Set myCheckBox = checkArg
End Function

'设置当前的下拉框对象，使之可以响应外部事件
Public Function SetComboBox(comboArg As combobox) As Long
    Dim iret As Long
    Dim rowid As Long
    Dim colid As Long
    
    iret = GetRowIdColumnId(comboArg.Name, rowid, colid)
    If iret = 0 Then
        If rowid <> currentRow Then
            currentRow = rowid
            DrawDW_ImageOnly
        End If
    End If

    Set myComboBox = comboArg
End Function


'单击选择框按钮的操作
Private Sub myCheckBox_Click()
    'MsgBox "change", , myTextBox.name
    Dim iret As Long
    Dim rowid As Long
    Dim colid As Long
    
    iret = GetRowIdColumnId(myCheckBox.Name, rowid, colid)      '得到行号和列号
    If iret = 0 Then
        If myCheckBox.value = 1 Then    '选中状态
            DW_SetItem rowid, colid, local_webdw.column(colid).checkbox.on
        Else                            '未选中状态
            DW_SetItem rowid, colid, local_webdw.column(colid).checkbox.off
        End If
    End If
End Sub

'当点击选择框时，更新相应字段内容
Private Sub myComboBox_Click()
    Dim iret As Long
    Dim rowid As Long
    Dim colid As Long
    Dim svalue As String    '这个控件代表的属性值
    Dim pos1 As Long
    Dim pos2 As Long
    Dim pos3 As Long
    Dim allData() As String

    iret = GetRowIdColumnId(myComboBox.Name, rowid, colid)
    If iret = 0 Then
    
        allData = Split(local_webdw.table.Columns(colid).values, "/")
            
        If myComboBox.ListIndex >= 0 Then
            svalue = allData(myComboBox.ListIndex)
            pos1 = InStr(1, svalue, Chr(9))
            If pos1 > 0 Then
                DW_SetItem rowid, colid, Mid(svalue, pos1 + 1)
            End If
        Else
        
        End If
    End If
End Sub



'单击单选按钮的操作
Private Sub myOptionButton_Click()
    Dim iret As Long
    Dim rowid As Long
    Dim colid As Long
    
    iret = GetRowIdColumnId(myOptionButton.Name, rowid, colid)      '得到行号和列号
    If iret = 0 Then
        DW_SetItem rowid, colid, myOptionButton.tag              '从tag里面取出值，设置变量
    End If
End Sub

'当文本框数据改变时，将当前数据设置到后面的数据存储去
Private Sub myTextBox_Change()
    Dim iret As Long
    Dim rowid As Long
    Dim colid As Long
    Dim strinfo As String
    Dim coltype As String
    
    '为避免重复进行无效功能调用，如果tag="reenter"，就啥也不干
    If myTextBox.tag = "reenter" Then
        myTextBox.tag = ""
        Exit Sub
    End If
    
    iret = GetRowIdColumnId(myTextBox.Name, rowid, colid)       '得到当前行，当前列
    If iret = 0 Then
        iret = DW_SetItem(rowid, colid, myTextBox.text)         '设置数据
        If iret = -1 Then
            'myTextBox.tag = "reenter"                           '设置重入标志
            'myTextBox.text = DW_GetItemString(rowid, colid)
            'myTextBox.tag = ""
        End If
    End If
    
End Sub

Public Sub myTextBox_GotFocus()
    '如果当前的数据类型是数值型，而且设定了显示风格
    '那么在得到焦点的时候，应当用后台的原始数据，来替换界面上已经被格式化的数据
    '这样在编辑的时候，传给后台的就是原始数据，而不是编辑后的数据
'    Dim sdata As String
'    Dim iret As Long
'    Dim rowid As Long
'    Dim colid As Long
'    Dim strinfo As String
'    Dim coltype As String
'
'    iret = GetRowIdColumnId(myTextBox.Name, rowid, colid)
'    If iret = -1 Then
'        Exit Sub
'    End If
'
'    sdata = DW_GetItemString(rowid, colid)
'    If local_webdw.column(colid).format <> "[general]" And IsNumeric(sdata) Then
'        myTextBox.tag = "reenter"
'        myTextBox.text = sdata              '显示当前数据的未格式化内容
'    End If
End Sub

'功能描述：如果本文本框设置了显示的掩码支持，那么在失去焦点时，利用指定的显示掩码来格式化原始数据
'并显示在文本框中，此时文本框已经失去焦点，应该不会再循环调用change事件了。
Private Sub myTextBox_LostFocus()
    Dim sorgdata As String
    Dim iret As Long
    Dim rowid As Long
    Dim colid As Long
    Dim strinfo As String
    Dim coltype As String
        
    iret = GetRowIdColumnId(myTextBox.Name, rowid, colid)   '得到当前行，当前列
    If iret = 0 Then
        sorgdata = DW_GetItemString(rowid, colid)
        If local_webdw.column(colid).format <> "[general]" And IsNumeric(myTextBox.text) Then    '设置了特殊的显示格式
            '利用自定义的显示格式对原始数据进行格式化，并输出之。
            myTextBox.tag = "reenter"
            myTextBox.text = displayformate.GetFormateDecimal(sorgdata, local_webdw.column(colid).format)
            myTextBox.tag = ""
        End If
    End If
    
End Sub



'当在文本框上单击时，设置当前行
'未来根据元素定义的编辑风格来进行弹出控件设置
Private Sub myTextBox_Click()
    Dim iret As Long
    Dim rowid As Long
    Dim colid As Long
    Dim sdata As String
        
    iret = GetRowIdColumnId(myTextBox.Name, rowid, colid)
    If iret = 0 Then
        If rowid <> currentRow Then
            currentRow = rowid
        End If
    End If
    
    sdata = DW_GetItemString(rowid, colid)
    If local_webdw.column(colid).format <> "[general]" And IsNumeric(sdata) Then
        myTextBox.tag = "reenter"
        myTextBox.text = sdata              '显示当前数据的未格式化内容
        myTextBox.tag = ""
    End If

    
    
    '如果当前列设定的编辑风格是弹出数据窗口
    If local_webdw.column(colid).dddw.Name > "" And local_webdw.column(colid).dddw.DataColumn > "" _
       And local_webdw.column(colid).dddw.DisplayColumn > "" And local_webdw.column_dddw_syntax(colid) > "" _
       And local_webdw.column_dddw_data(colid) > "" Then
       
       '此时不再检索子数据窗口的数据
       childDW.DW_SetDataObject targetControls, childPict, local_webdw.column_dddw_syntax(colid), False
       childDW.SetData local_webdw.column_dddw_data(colid)
       
       childDW.parentControlName = myTextBox.Name                      '设置父窗口的控件名称
       childDW.dataColumnName = local_webdw.column(colid).dddw.DataColumn   '设置数据列名称
       
       childPict.Left = myTextBox.Left
       childPict.top = myTextBox.top + myTextBox.height
       childPict.Visible = True
       childPict.tag = myTextBox.Name   '在childpict的tag字段暂时存储父窗口的当前控件名
       childDW.DrawDW
       
       Dim obj As vscrollbar
       Set obj = GF_GetObjectByName(targetControls, "PictureChild_VScroll_Line")
       If Not obj Is Nothing Then
            obj.Left = childPict.Left + childPict.width
            obj.top = childPict.top
        End If
       
       'myTextBox.Enabled = False
    End If
    
    
End Sub

'输入:g_webdw
'输出:g_webdw
'处理：如果存在子数据窗口，检索每个子窗口的定义和数据，填充g_webdw
Private Function retrieveChildDW() As Long
    Dim colid As Long
    Dim childDWDefine As String
    Dim childDWData As String
    Dim iret As Long
    
    '暂时先不考虑子数据窗口的嵌套问题，目前只检索一层子数据窗口
    For colid = 1 To 100
        childDWDefine = ""
        childDWData = ""
        If local_webdw.column(colid).dddw.Name > "" Then
            childDWDefine = sqlca.GetDWDefine(local_webdw.column(colid).dddw.Name, iret) '检索对象定义
            
            If iret = 0 Then '检索对象定义成功
                childDWData = GF_RetrieveBySyntax(childDWDefine)
                local_webdw.column_dddw_syntax(colid) = childDWDefine   '存储子窗口语法定义
                local_webdw.column_dddw_data(colid) = childDWData       '存储子窗口数据定义
            End If
        End If
    Next
    
End Function

'调用子数据窗口的刷新方法
Public Function DrawChildDW() As Long
    If Not (childDW Is Nothing) Then
        childDW.DrawDW
    End If
    
End Function

'设置列定义字符串的方法
'这个列定义字符串表示了列名称和数据类型和长度定义
'webdwdata用这个字符串来初始化存储结构
Public Function SetColumnDefString(sColDefString As String) As Long
    SetColumnDefString = webdw.SetColumnDefineString(sColDefString)
End Function


'得到当前的Select语句定义
'先判断根目录下的SelectSql变量
'如果为空，取webdwdata返回的SQL命令
Public Function DW_GetSQLSelect() As String
    Dim strsql As String
    
    If local_webdw.SelectSQL = "" Then
        strsql = webdw.GetRetrieveSQL()
    Else
        strsql = local_webdw.SelectSQL
    End If
    
    DW_GetSQLSelect = strsql
End Function

'设置数据窗口检索用的Select语句
Public Function DW_SetSQLSelect(strsql As String) As Long
    local_webdw.SelectSQL = strsql
    DW_SetSQLSelect = 0
End Function

'根据给定dw语法进行转换，如果转换成功，设置本地的g_webdw数据
'如果转换失败，返回-1
Public Function DW_Create(dwSyntax As String) As Long
    Dim iret As Long
    iret = webdw.Create(dwSyntax)
    
    If iret = -1 Then
        errString = webdw.errString
        local_webdw = GG_empty_webdw
        DW_Create = -1
    Else
        webdw.GetLocalWebDW
        SetLocalWebDW
        DW_Create = 0
    End If
    
End Function

'得到数据窗口的语法表示
'返回iret 0 代表成功 -1 代表失败
Public Function DW_GetSyntax(ByRef iret As Long) As String
    DW_GetSyntax = webdw.GetSyntaxString(iret)
    If iret = -1 Then
        errString = webdw.errString
    End If
End Function

'根据给定的SQL语句，以及对应的数据窗口类型
'设置到g_webdw中去
'从而再转换，得到一个对应的数据窗口对象出来。
'iret返回值，0 正常 -1 失败
'错误信息存放在errstring中
'这个方法是一个Select语句的小型解析器
Public Function DW_SyntaxFromSQL(strsql As String, stype As String, ByRef iret As Long) As String
    DW_SyntaxFromSQL = webdw.SyntaxFromSQL(strsql, stype, iret)
    If iret = -1 Then
        errString = webdw.errString
    End If
End Function

'功能描述：得到当前界面的网格线竖线描述
'数据来源:local_webdw
'数据输出：将所有竖线的X值组合起来，用逗号分割，返回
'仅用于Grid风格和Tabular风格的数据窗口，其他风格的返回""
Public Function GetGridLineInfo() As String
    Dim convertRate As Double
    Dim leftPos As Long
    Dim colid As Long
    Dim sret As String
    Dim ileft As Long
    Dim imaxwidth As Long
    
    On Error GoTo errorHandle
    convertRate = GF_GetConvertRate(targetControls)
    leftPos = HScroll_Page.value * targetPict.width * -0.5  '左偏移量
    
    sret = ""
    
    If local_webdw.datawindow.grid_lines <> "0" Then    '目前仅处理Grid类型的数据
        GetGridLineInfo = ""
        Exit Function
    End If
    
    '对于网格形状的数据窗口，画竖线出来,此处不画线，而是存储其数值
    For colid = 1 To 100
        If local_webdw.column(colid).Name <> "" Then
            ileft = (local_webdw.column(colid).X * convertRate) - 20 + leftPos
            If sret = "" Then
                sret = sret & ileft
            Else
                sret = sret & "," & ileft
            End If
        End If
    Next
    imaxwidth = webdw.getMaxWidth() * convertRate + leftPos
    
    If sret = "" Then
        sret = sret & imaxwidth
    Else
        sret = sret & "," & imaxwidth
    End If
        
    GetGridLineInfo = sret
    Exit Function
errorHandle:
    GetGridLineInfo = ""
End Function

'重新设置修改网格表示的字段列宽度
'newX 新的字段X值
'oldX 旧的字段X值
'修改local_webdw的数值
Public Function SetGridWidth(newx As Long, oldx As Long) As Long
    If local_webdw.datawindow.grid_lines <> "0" Then    '目前仅处理Grid类型的数据
        SetGridWidth = ""
        Exit Function
    End If
    
    
    '修改规则：对于所有X > oldX的，增加偏移量
    '对于x+width = oldx的，增加width
    Dim colid As Long
    Dim convertRate As Double
    Dim leftPos As Long
    Dim maxwidth As Long
    
    convertRate = GF_GetConvertRate(targetControls)
    leftPos = HScroll_Page.value * targetPict.width * -0.5  '左偏移量
    
    For colid = 1 To 100
        If local_webdw.column(colid).Name <> "" Then
            If local_webdw.column(colid).X * convertRate + leftPos > oldx - 10 * convertRate Then
                local_webdw.column(colid).X = local_webdw.column(colid).X + (newx - oldx) / convertRate
            Else
                If (local_webdw.column(colid).X + local_webdw.column(colid).width) * convertRate + leftPos > oldx - 10 * convertRate Then
                    local_webdw.column(colid).width = local_webdw.column(colid).width + (newx - oldx) / convertRate
                    If local_webdw.column(colid).width < 0 Then
                        local_webdw.column(colid).width = 0
                    End If
                End If
            End If
        End If
        
        If local_webdw.text(colid).Name <> "" Then
            If local_webdw.text(colid).X * convertRate + leftPos > oldx - 10 * convertRate Then
                local_webdw.text(colid).X = local_webdw.text(colid).X + (newx - oldx) / convertRate
            Else
                If (local_webdw.text(colid).X + local_webdw.text(colid).width) * convertRate + leftPos > oldx - 10 * convertRate Then
                    local_webdw.text(colid).width = local_webdw.text(colid).width + (newx - oldx) / convertRate
                    If local_webdw.text(colid).width < 0 Then
                        local_webdw.text(colid).width = 0
                    End If
                End If
            End If
        End If
    Next
    GetLocalWebDW
    webdw.SetLocalWebDW
    maxwidth = webdw.getMaxWidth * convertRate
    If maxwidth <= targetPict.width Then
        HScroll_Page.Min = 0
        HScroll_Page.Max = 0
        HScroll_Page.value = 0
        HScroll_Page.Enabled = False
    Else
        HScroll_Page.Min = 0
        HScroll_Page.Max = (maxwidth - targetPict.width) * 2 / targetPict.width + 1
        HScroll_Page.SmallChange = 1
        HScroll_Page.largechange = 2
        HScroll_Page.Enabled = True
    End If
    
    DrawDW
End Function

'检索数据窗口中的当前数据
'rowid 行号
'colid 列号
'返回值：当前值
Public Function DW_GetItemString(rowid As Long, colid As Long) As String
    DW_GetItemString = webdwData.GetItemString(rowid, colid)
End Function

'-------------------------------这一部分代码从窗口中迁移过来---------------------------------
'-------------------------------为了简化从App到ActiveX的转换--------------------------------
'-------------------------------假设界面上有一个叫做LineAuto的线条--------------------------
Public Sub Picture_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Dim LineAuto As line
    Set LineAuto = GF_GetObjectByName(targetControls, "LineAuto")
    If LineAuto Is Nothing Then     'lineauto不存在，退出
        Exit Sub
    End If
    
    If LineAuto.Visible = True Then 'lineauto目前为可见，设置图片的状态
        targetPict.tag = "GridDrag"   '设置标志位为网格拖动
        targetPict.MousePointer = 9
    End If

End Sub

'鼠标移动，移动LineAuto，如果可以拖动的话
Public Sub Picture_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Dim LineAuto As line
    Set LineAuto = GF_GetObjectByName(targetControls, "LineAuto")
    If LineAuto Is Nothing Then     'lineauto不存在，退出
        Exit Sub
    End If

    '当鼠标在界面上移动之时，如果当前风格是网格型
    '而且移动到了标题栏的某条竖线上
    '那么将可移动的线显示在这条线上
    Dim scolinfo As String
    Dim linex() As String
    Dim id As Long
    
    If targetPict.tag = "GridDrag" Then
        LineAuto.x1 = X
        LineAuto.x2 = X
        
        GoTo showline
    End If
    
    scolinfo = GetGridLineInfo()
    If scolinfo > "" Then
        linex = Split(scolinfo, ",")
        For id = 0 To UBound(linex)
            If Abs(X - linex(id)) < 10 Then
                LineAuto.x1 = linex(id)
                LineAuto.x2 = linex(id)
                LineAuto.y1 = 0
                LineAuto.y2 = targetPict.height
                LineAuto.tag = linex(id)    '存储当前的所在X值
                LineAuto.Visible = True
                GoTo showline
            End If
        Next
    End If
    LineAuto.Visible = False
showline:

End Sub

'鼠标抬起，重新绘制界面（如果需要)
'当界面的风格是GridDrag，代表鼠标按下的时候是一个网格的拖动状态时
'根据当前的X值，命令重新绘制用户界面
Public Sub Picture_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Dim LineAuto As line
    Set LineAuto = GF_GetObjectByName(targetControls, "LineAuto")
    If LineAuto Is Nothing Then     'lineauto不存在，退出
        Exit Sub
    End If
    
    Dim newx As Long
    Dim oldx As Long
    If targetPict.tag = "GridDrag" Then '如果当前状态是在拖动状态
        '根据当前的X值，重新设置网格的坐标
        newx = X
        oldx = LineAuto.tag
        SetGridWidth newx, oldx
    End If
    LineAuto.Visible = False
    targetPict.MousePointer = 0
    targetPict.tag = ""
End Sub

'-----------------------------------------------------------------------------------------------
'---------------------------从界面上得到的代码迁移结束--------------------------------------------
'-----------------------------------------------------------------------------------------------

'设置网格线的颜色，调用VB的QBColor方法,可用颜色0-15
'传入其他参数，不予处理
Public Function DW_SetGridLineColor(color As Long) As Long
    If color >= 0 And color < 16 Then
        gridLineColor = QBColor(color)
        DW_SetGridLineColor = 0
    Else
        DW_SetGridLineColor = -1
        errString = "Wrong Argument"
    End If
End Function

'设置排序方式
Public Function DW_GetSorter() As String
    DW_GetSorter = webdwData.GetDataSorter()
End Function

'读取排序方式
Public Function DW_SetSorter(sorter As String) As Long
    DW_SetSorter = webdwData.SetDataSorter(sorter)
End Function

'数据排序
Public Function DW_Sort() As Long
    DW_Sort = webdwData.Sort()
    errString = webdwData.errString
End Function
