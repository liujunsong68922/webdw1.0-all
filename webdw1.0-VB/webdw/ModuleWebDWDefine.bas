Attribute VB_Name = "Module3WebDWDefine"
Rem -------------------------------------------------
Rem WebDW�õ������ݽṹ����
Rem ���е����ݽṹ����WebDW��ͷ
Rem �����ֶεĺ�����μ�PBDW�ĵ����ļ���ʽ
Rem CopyRight Mr.Liu Junsong 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------

'datawindow���Զ���
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

'header���Զ���
Public Type WebDW_Header
    height As Long
    color As Long
End Type

'summary���Զ���
Public Type WebDW_Summary
    height As Long
    color As Long
End Type

'footer���Զ���
Public Type WebDW_Footer
    height As Long
    color As Long
End Type

'detail���Զ���
Public Type WebDW_Detail
    height As Long
    color As Long
End Type

'table��Ƕ��column���Զ���
Public Type WebDW_Table_Column
    type As String                  '��������
    update As String                '�Ƿ���Ը���yes/no
    updatewhereclause As String     '�Ƿ��Ǹ���ʱ��where����yes/no
    key As String                   '�Ƿ�������
    Name As String                  '�ֶ���
    dbname As String                '���ݿ��ֶ���
    values As String                '����ֵ�������洢�༭���ʱ����Ϣ
    validations As String           '�༭��У���ַ���
End Type

'������Ӷ���
Public Type WebDW_Table_Retrieve_PBSelect_Join
    join_left As String
    join_op As String
    join_right As String
End Type

'�������where��������
Public Type WebDW_Table_Retrieve_PBSelect_Where
    exp1 As String
    op As String
    exp2 As String
    logic As String
End Type

'���ݱ������OrderBy��������
Public Type WebDW_Table_Retrieve_PBSelect_Order
    Name As String      '�����������
    Asc As String       '�Ƿ�������yes/no
End Type

'table��retrieve��pbselectԪ�����Զ���
'��һ���ֿ��ܻ������Ҫ�����к�������
'�����Ŷ���DW�ļ���ʽ������������չ
Public Type WebDW_Table_Retrive_PBSelect
    version As String
    table(1 To 10) As String                        '�������������10����
    column(1 To 100) As String                      '�������������100����
    join(1 To 10) As WebDW_Table_Retrieve_PBSelect_Join   '�����Ӷ��壬���10������
    where(1 To 10) As WebDW_Table_Retrieve_PBSelect_Where 'where�������壬���10��where����
    order(1 To 10) As WebDW_Table_Retrieve_PBSelect_Order 'order�������壬���10�������ֶ�
End Type

'table.retrieveԪ�ض��壬����ֻ��һ��pbselectԪ��
Public Type WebDW_Table_Retrieve
    pbselect As WebDW_Table_Retrive_PBSelect
End Type
'table���Զ���
Public Type WebDW_table
    Columns(1 To 100) As WebDW_Table_Column          '���100��
    'retrieve As String                              '���ݼ����Ķ���,��ʱ����������Ӧ�ò������������
    retrieve As WebDW_Table_Retrieve                '���¶���retrieve�����������һ���ṹ
    update As String
    updatewhere As String
    updatekeyinplace As String
    
End Type

'WebDW�õ����ڲ�Font���壬
'���Font���Զ�text��column��Ч
'20081225������

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



'�����жԵ�ѡ��ť���֧�ֶ��壬����Column��һ������
Public Type WebDW_Column_RadioButtons
    Columns As Long                     '��ѡŦ��ʾ�е�����
End Type

'�����ж�ѡ����֧�ֶ��壬����Column��һ������
Public Type WebDW_Column_CheckBox
    text As String                      '��ʾ�ڽ����ϵ��ַ���
    on As String                        'ѡ��ʱ������ֵ
    off As String                       'δѡ��ʱ������ֵ
    scale1 As String                     '���岻��,scale��vb�����֣�����
    threed As String                    '3D��ʾ���
End Type

'�����ж�����ѡ����֧�ֶ��壬����Column��һ������
Public Type WebDW_Column_ComboBox
    limit As Long                       '���ƣ����岻��
    allowedit As String                 '�Ƿ���Ա༭ yes /no
    case As String                      '��Сд
    useasborder As String               '�Ƿ���ʾ��ͷ yes/no
    
End Type

'�����ж��������ݴ��ڵ�֧�֣�����Column��һ������
'20090125�մ�����ʮ�����
Public Type WebDW_Column_DDDW
    Name As String                      '���ݴ��ڵ����֣�δ��������ַ��������������ݴ���
    DisplayColumn As String             '��ʾ�е����֣���һ���������ݴ�����
    DataColumn As String                '�����е����֣�����һ��������ԭ���ݴ���
    PercentWidth As Long                '�ٷֱȱ�ʾ����ʾ���
    Lines As Long
    limit As Long
    allowedit As String
    useasborder As String
    case As String
    vscrollbar As String                '�Ƿ���ʾ��������
End Type

'
'column��֧�����Զ��壬
'�������ļ��ж��뵽����ṹ��
'��������ṹ����ͼ��ʾ
'���������������ļ��ж������ͬ,����ؼ�����һ��
'������ȫ��Сд
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
    
    font As WebDW_Font          '���¶���Font�ṹ��ʹ������ṹ��ʹ��
    
    background_mode As Long
    background_color As Long
    
    radiobuttons As WebDW_Column_RadioButtons   '��ѡ��ť��֧�ֶ���20090124
    checkbox As WebDW_Column_CheckBox           'ѡ��ť��֧�ֶ���20090124
    combobox As WebDW_Column_ComboBox           '�����б���֧�ֶ���20090124
    dddw As WebDW_Column_DDDW                   '�������ݴ��ڵ�֧�ֶ���20090125
End Type


'text��֧�����Զ���
'�������ļ��ж��뵽����ṹ��
'��������ṹ����ͼ��ʾ
'���������������ļ��ж������ͬ������ؼ�����һ��
'������ȫ��Сд
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
    
    font As WebDW_Font          '�¶����font����
    
    background_mode As Long
    background_color As Long
End Type

'���������ݶ�������
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


'webdw��������Զ���
'����������Զ����Ժ�
'�����ļ�����һ�α����ص�һ�����Լ�����
'�Ժ�ֻҪ����������ԾͿ��Եõ�����Ҫ���κ�������
'������Ҫһ��һ���������ַ�����
'�ѽ����ַ����ķ�����ȫ�����˳���
'��������˼���Ǻ�PB7.0��DW�ļ��ṹ��ȫ����
'�����Ӳ���Ҫ������,��Ҫ��������,�����������¿�ʼ��Ʊ�д
'ֱ�ӽ�����е������ɹ������п���
'liujunsong
'2008-12-17����ʶ������ǳ���,�ǳ����صĵ���
'WebDWSyntax������ʾDW�Ķ����﷨�ṹ���������ļ����Ӧ
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
    
    column_dddw_syntax(1 To 100) As String  '�����ݴ��ڵ��﷨����(�Զ�����չ)
    column_dddw_data(1 To 100) As String    '�����ݴ��ڵ���������(�Զ�����չ)
    
    'Ϊ��̬����SQL����ṩ֧��
    SelectSQL As String                     'Ĭ��Ϊ�գ����Զ�̬����(�Զ�����չ)
End Type

Public GG_webdw As WebDWSyntax        'GG_webdw����ȫ���Ե�һ������,�����ʱ����������������
