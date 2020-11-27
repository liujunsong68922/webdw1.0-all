Attribute VB_Name = "Module3WebDWDefine"
Rem -------------------------------------------------
Rem WebDW用到的数据结构定义
Rem 所有的数据结构都以WebDW开头
Rem 具体字段的含义请参见PBDW的导出文件格式
Rem CopyRight Mr.Liu Junsong 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------

'datawindow属性定义
Public Type WebDW_DataWindow
    unit As String
    timer_interval As String
    color As Long
    processiong As String
    HTMLDW As String
    print_documentname As String
    print_orientation As Long
    print_margin_left As Long
    print_margin_right As Long
    print_margin_top As Long
    print_margin_bottom As Long
    print_paper_source As Long
    print_paper_size As Long
    print_prompt As String
    print_buttons As String
    print_preview_buttons As String
    grid_lines As String
End Type

'header属性定义
Public Type WebDW_Header
    height As Long
    color As Long
End Type

'summary属性定义
Public Type WebDW_Summary
    height As Long
    color As Long
End Type

'footer属性定义
Public Type WebDW_Footer
    height As Long
    color As Long
End Type

'detail属性定义
Public Type WebDW_Detail
    height As Long
    color As Long
End Type

'table内嵌的column属性定义
Public Type WebDW_Table_Column
    type As String                  '数据类型
    update As String                '是否可以更新yes/no
    updatewhereclause As String     '是否是更新时的where条件yes/no
    key As String                   '是否是主键
    Name As String                  '字段名
    dbname As String                '数据库字段名
    values As String                '附加值，用来存储编辑风格时的信息
    validations As String           '编辑的校验字符串
End Type

'表的连接定义
Public Type WebDW_Table_Retrieve_PBSelect_Join
    join_left As String
    join_op As String
    join_right As String
End Type

'表检索的where条件定义
Public Type WebDW_Table_Retrieve_PBSelect_Where
    exp1 As String
    op As String
    exp2 As String
    logic As String
End Type

'数据表检索的OrderBy条件定义
Public Type WebDW_Table_Retrieve_PBSelect_Order
    Name As String      '排序的列名称
    Asc As String       '是否是升序yes/no
End Type

'table的retrieve的pbselect元素属性定义
'这一部分可能会根据需要来进行后续增加
'会随着对于DW文件格式的理解深入而扩展
Public Type WebDW_Table_Retrive_PBSelect
    version As String
    table(1 To 10) As String                        '表名，最多容许10个表
    column(1 To 100) As String                      '列名，最多容许100个列
    join(1 To 10) As WebDW_Table_Retrieve_PBSelect_Join   '表连接定义，最多10个连接
    where(1 To 10) As WebDW_Table_Retrieve_PBSelect_Where 'where条件定义，最多10个where条件
    order(1 To 10) As WebDW_Table_Retrieve_PBSelect_Order 'order条件定义，最多10个排序字段
End Type

'table.retrieve元素定义，其中只有一个pbselect元素
Public Type WebDW_Table_Retrieve
    pbselect As WebDW_Table_Retrive_PBSelect
End Type
'table属性定义
Public Type WebDW_table
    Columns(1 To 100) As WebDW_Table_Column          '最多100列
    'retrieve As String                              '数据检索的定义,暂时保留，长期应该不用这个变量了
    retrieve As WebDW_Table_Retrieve                '重新定义retrieve参数，定义成一个结构
    update As String
    updatewhere As String
    updatekeyinplace As String
    
End Type

'WebDW用到的内部Font定义，
'这个Font属性对text和column有效
'20081225日增加

Public Type WebDW_Font
    face As String
    height As Long
    weight As Long
    family As Long
    pitch As Long
    charset As Long
    italic As Long
    underline As Long
    strikethrough As Long
End Type



'数据列对单选按钮组的支持定义，这是Column的一个属性
Public Type WebDW_Column_RadioButtons
    Columns As Long                     '单选纽显示列的数量
End Type

'数据列对选择框的支持定义，这是Column的一个属性
Public Type WebDW_Column_CheckBox
    text As String                      '显示在界面上的字符串
    on As String                        '选中时的数据值
    off As String                       '未选中时的数据值
    scale1 As String                     '含义不明,scale是vb保留字，改名
    threed As String                    '3D显示风格
End Type

'数据列对下拉选择框的支持定义，这是Column的一个属性
Public Type WebDW_Column_ComboBox
    limit As Long                       '限制，含义不明
    allowedit As String                 '是否可以编辑 yes /no
    case As String                      '大小写
    useasborder As String               '是否显示箭头 yes/no
    
End Type

'数据列对下拉数据窗口的支持，这是Column的一个属性
'20090125日大年三十日添加
Public Type WebDW_Column_DDDW
    Name As String                      '数据窗口的名字，未来用这个字符串来检索此数据窗口
    DisplayColumn As String             '显示列的名字，这一列在子数据窗口中
    DataColumn As String                '数据列的名字，用这一列来设置原数据窗口
    PercentWidth As Long                '百分比表示的显示宽度
    Lines As Long
    limit As Long
    allowedit As String
    useasborder As String
    case As String
    vscrollbar As String                '是否显示竖滚动条
End Type

'
'column的支持属性定义，
'从配置文件中读入到这个结构中
'再用这个结构来绘图显示
'属性名称与属性文件中定义的相同,不与控件本身一致
'属性名全用小写
Public Type WebDW_Column
    band As String
    id As Long
    alignment As Long
    tabsequence As Long
    border As Long
    color As Long
    X As Long
    Y As Long
    height As Long
    width As Long
    format As String
    Name As String
    tag As String
    edit_limit As Long
    edit_case As String
    edit_focusrectangle As String
    edit_autoselect As String
    edit_autohscroll As String
    
    font As WebDW_Font          '重新定义Font结构并使用这个结构来使用
    
    background_mode As Long
    background_color As Long
    
    radiobuttons As WebDW_Column_RadioButtons   '单选按钮的支持定义20090124
    checkbox As WebDW_Column_CheckBox           '选择按钮的支持定义20090124
    combobox As WebDW_Column_ComboBox           '下拉列表框的支持定义20090124
    dddw As WebDW_Column_DDDW                   '下拉数据窗口的支持定义20090125
End Type


'text的支持属性定义
'从配置文件中读入到这个结构中
'再用这个结构来绘图显示
'属性名称与属性文件中定义的相同，不与控件本身一致
'属性名全用小写
Public Type WebDW_Text
    band As String
    alignment As Long
    text As String
    border As Long
    color As Long
    X  As Long
    Y As Long
    height As Long
    width As Long
    Name As String
    
    font As WebDW_Font          '新定义的font属性
    
    background_mode As Long
    background_color As Long
End Type

'线条的数据定义类型
Public Type WebDW_Line
    band As String
    x1 As Long
    y1 As Long
    x2 As Long
    y2 As Long
    Name As String
    pen_style As String
    pen_width As String
    pen_color As String
    background_mode As String
    background_color As String
End Type


'webdw整体的属性定义
'有了这个属性定义以后
'整个文件可以一次被加载到一个属性集合中
'以后只要访问这个属性就可以得到所需要的任何属性了
'而不需要一次一次来解析字符串了
'把解析字符串的方法完全独立了出来
'总体的设计思想是和PB7.0的DW文件结构完全兼容
'不增加不必要的属性,不要画蛇添足,自作聪明重新开始设计编写
'直接借鉴现有的文明成果来进行开发
'liujunsong
'2008-12-17日认识到这个非常简单,非常朴素的道理
'WebDWSyntax用来表示DW的定义语法结构，和数据文件相对应
Public Type WebDWSyntax
    datawindow As WebDW_DataWindow
    header As WebDW_Header
    summary As WebDW_Summary
    footer As WebDW_Footer
    detail As WebDW_Detail
    table As WebDW_table
    text(1 To 100) As WebDW_Text
    column(1 To 100) As WebDW_Column
    lineinfo(1 To 100) As WebDW_Line
    
    column_dddw_syntax(1 To 100) As String  '子数据窗口的语法定义(自定义扩展)
    column_dddw_data(1 To 100) As String    '子数据窗口的数据内容(自定义扩展)
    
    '为动态生成SQL语句提供支持
    SelectSQL As String                     '默认为空，可以动态设置(自定义扩展)
End Type

Public GG_webdw As WebDWSyntax        'GG_webdw代表全局性的一个变量,这个临时变量用来传递数据
