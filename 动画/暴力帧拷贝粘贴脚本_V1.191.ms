-------------------------------------------------------------------------------
-- 暴力帧拷贝粘贴脚本
-- By 吇鱼 (cgwayne.com)
-- v 1.19
-- Created On: 01/20/2016
-- Modified On: 03/09/2016
-- tested using Max 2012
-------------------------------------------------------------------------------
(

--for f in getFiles ((GetDir #export+ @"\")+"*.bps") do deleteFile f

global stime           = animationrange.start
global etime           = animationrange.end
global start_frame     = animationrange.start
global end_frame       = animationrange.end
global selectundefined = 0

global name_lag             
global removeFromList_lag  
global rloading_lag         
global rb_sel_a_lag        
global rb_sel_b_lag         
global ac_lag              
global addToList_lag       
global pastepose_lag        
global ABbutton_lag        
global  obj_r_lag          
global  obj_xyz_lag        
global  obj_tcb_lag        
global  paste_offset_lag    
global paste_offset_b_lag   
global lnk1_lag             
global wayneCheckBox_lag    
global ac_tooltip_a_lag     
global ac_tooltip_b_lag    
global ABbutton_tooltip_a_lag 
global ABbutton_tooltip_b_lag
global messagebox_a_lag   
global messagebox_b_lag    
global messagebox_c_lag     
global messagebox_d_lag     
global messagebox_e_lag     
global messagebox_f_lag     
global messagebox_a_title_lag
global format_a_lag         
global format_b_lag       
global format_c_lag        
global Accuracy_offset_lag 
global Accuracy_offset_b_lag 
global obj_r_b_lag           
global wcb_lag            
global rfl_lag             
global language_a_lag     
global language_b_lag      

--global frame_options   = false
fn china = (
 name_lag             = "暴力帧拷贝粘贴V1.19" 
 removeFromList_lag   = "删除当前集：点击删除当前列表中的选择集合"
 rloading_lag         = "更新列表：将列表内容更新至最新"
 rb_sel_a_lag         ="姿态"
 rb_sel_b_lag         ="动作"
 ac_lag               ="帧数范围：开始到结束"
 addToList_lag        = "拷贝帧"
 pastepose_lag        =  "粘贴帧" 
 ABbutton_lag         = "逐帧拷贝：在此模式下拷贝帧将以逐帧方式进行拷贝操作"
  obj_r_lag           = "重置变换：把变换重置为XYZ属性，重置后将无法保留原始动画信息"
  obj_xyz_lag         ="转换XYZ：把选择对象转换为XYZ属性"
  obj_tcb_lag         ="转换TCB：把选择对象转换为TCB属性"
  paste_offset_lag    =  "偏移 " 
 paste_offset_b_lag   ="偏移粘贴：输入帧数，粘贴帧将于（开始帧数+偏移帧数）往下粘贴动作"
 lnk1_lag             = "开发者:@吇鱼 " 
 wayneCheckBox_lag    = "保留拷贝：勾选该项，下次开启将保留本次拷贝的姿态和动作"
 ac_tooltip_a_lag     = "帧数范围：开始到结束"
 ac_tooltip_b_lag     = "帧数范围：自定义开始结束"
 ABbutton_tooltip_a_lag ="关键帧拷贝：在此模式下拷贝帧将以选中所有对象在时间条中有帧的位置进行拷贝操作"
 ABbutton_tooltip_b_lag ="逐帧拷贝：在此模式下拷贝帧将以逐帧方式进行拷贝操作" 
 messagebox_a_lag     = "请选择至少一个物体"
 messagebox_b_lag     = "时间范围错误"
 messagebox_c_lag     ="未找到选择Pose，请更新列表"
 messagebox_d_lag     = "未找到选择Animation，请更新列表"
 messagebox_e_lag     = "场景中无物体在姿态集中"
 messagebox_f_lag     = "选择中有部分未被记录姿态"
 messagebox_a_title_lag = "提示"
 format_a_lag         = "已取消\n"
 format_b_lag         = "完成\n"
 format_c_lag         = "进度"
 Accuracy_offset_lag  = "精度"
 Accuracy_offset_b_lag  = "精度：通过精度数值进行重复粘贴以达到最准确的效果（数值越大用时越长）"
 obj_r_b_lag            = "П"
 wcb_lag              = "ü"
 rfl_lag              = "×"
 language_a_lag       = "中"
 language_b_lag       = "语言:当前是中文"
)
fn english = (
 name_lag             = "CopyPasteKey V1.19" 
 removeFromList_lag   = "Delete the selection sets: click to delete the current selection in the list of collection"
 rloading_lag         = "Update list: update to the latest list"
 rb_sel_a_lag         = "Pose"
 rb_sel_b_lag         = "Motion"
 ac_lag               = "Range of frames: start to finish"
 addToList_lag        = "Copy"
 pastepose_lag        = "Paste" 
 ABbutton_lag         = "Frame by frame copy: in this mode copy frame will copy operation on the basis of frame by frame"
  obj_r_lag           = "Reset to reset the transformation: the transformation XYZ properties, after the reset will not be able to retain the original animation information"
  obj_xyz_lag         = "Convert XYZ: convert a selection object to XYZ properties"
  obj_tcb_lag         = "Convert TCB: convert a selection object to TCB properties"
  paste_offset_lag    = "Offset " 
 paste_offset_b_lag   = "Offset paste: input frames, paste the frame will be (start frames + offset frames) to paste action"
 lnk1_lag             = "@John Wayne" 
 wayneCheckBox_lag    = "Keep a copy: check the, the next time will keep the copy of gestures and movements"
 ac_tooltip_a_lag     = "Range of frames: start to end"
 ac_tooltip_b_lag     = "Range of frames: custom start end"
 ABbutton_tooltip_a_lag ="key by key copy: in this mode will copy the frame to select all objects in the time of the frame position for copy operation"
 ABbutton_tooltip_b_lag ="Frame by frame copy: in this mode copy frame will copy operation on the basis of frame by frame" 
 messagebox_a_lag     = "Please select at least one object"
 messagebox_b_lag     = "Time range error"
 messagebox_c_lag     = "Choose the Pose is not found, please update the list"
 messagebox_d_lag     = "Choose the Animation is not found, please update the list"
 messagebox_e_lag     = "Concentration in attitude no object in the scene"
 messagebox_f_lag     = "Choose some have not been recorded in posture"
 messagebox_a_title_lag = "Prompt"
 format_a_lag         = "cancel\n"
 format_b_lag         = "finish\n"
 format_c_lag         = "Schedule"
 Accuracy_offset_lag  = " Acc "
 Accuracy_offset_b_lag  = "Accuracy: through repeated precision numerical paste in order to achieve the most accurate results (the larger the value when the long)"
 obj_r_b_lag          = "Res"
 wcb_lag              = "U"
 rfl_lag              = "X"
 language_a_lag       = "En"
 language_b_lag       = "Language: the current is in English"
)


(
---------------------------------------------------------------------------------------------打开文件加载
makeDir  ((GetDir #export)+ "\\cptools_data\\")------创建路径
tempdata = ((GetDir #export)+"\\cptools_data\\"+"temp.ini")-----指定文件
testPath = doesFileExist tempdata------检测文件是否存在
if testPath == true then (
open_tempdata   = openFile tempdata------打开temp文件
skip_tmepdata   = skiptostring open_tempdata "Language = "
if skip_tmepdata ==ok then (
	read_tempdata = readLine open_tempdata 
	en_ch = read_tempdata as booleanClass
	if en_ch  == true then (english()) else (china())
	) else (china())
close open_tempdata
)else (china())
-----------------------------------------------------------------------------------------------------------------
)

rollout cptools name_lag 
(
Group "Main" 
(
dropdownlist testList items:#() tooltip:"select pose"  across: 3 width:135 enabled:true visible:true
button removeFromList ""  height:20 width:20 offset:[59,0] toolTip:removeFromList_lag
button rloading       " R" height:20 width:20 offset:[22,0] toolTip:rloading_lag
radioButtons rb_sel "" width:88 height:15 labels:#(rb_sel_a_lag ,rb_sel_b_lag ) offset:[-45,0] 
button ac "A" width:18 height:16 offset:[18,-20] enabled:false toolTip:ac_lag
spinner Accuracy_offset "         " range:[1,10, 1] type:#integer  width:40 offset:[40,-19]  toolTip: Accuracy_offset_b_lag enabled:true
spinner spn_start  "" range:[-99999,99999, stime]     fieldwidth:37 across: 2 offset:[-40,0] type:#integer  enabled:false
spinner spn_end "To " range:[-99999,99999, etime]  fieldwidth:37	 offset:[-60,0] type:#integer  enabled:false
button addToList "" width:92 offset:[-19,0]
button pastepose "" width:58 height:42 offset:[61,-47]
button ABbutton   "S" width:20   offset:[-77,-26] toolTip:ABbutton_lag  enabled:false

)
Group "Setting" 
(
button obj_r   ""    width:32 height:18 offset:[-4,0] across:4  toolTip:obj_r_lag
button obj_xyz "XYZ"  width:32 height:18 offset:[-9,0]   toolTip:obj_xyz_lag
button obj_tcb "TCB"  width:32 height:18 offset:[-21,0] toolTip:obj_tcb_lag

spinner paste_offset  "           " range:[-99999,99999, 0] type:#integer  width:90 offset:[-18,1]  toolTip:paste_offset_b_lag  enabled:false align:#center
)	

HyperLink lnk1 "                        " align:#center color:(color 150 150 150) hovercolor:(color 100 100 100) visitedcolor:(color 150 150 150) address:"http://www.cgwayne.com/" 
dropdownlist testListAni items:#() tooltip:"select pose" width:135 enabled:true visible:false offset:[0,-171] 
checkbox wayneCheckBox "" offset:[-5,120] toolTip:wayneCheckBox_lag
button language_btn ""  offset:[85,-18]  width:20 height:15 toolTip:language_b_lag
progressbar    doit_prog  offset:[-9,0]    width:190 height:8    color:red 	

on language_btn pressed  do 
(
	if language_btn.text =="En"  then 
	(
		china()
		language_btn.text = language_a_lag
		----------------------------------------------记录状态
        hold_CB = wayneCheckBox.checked
		hold_RB = rb_sel.state
		hold_ST = spn_start.value
		hold_ED = spn_end.value
		hold_AC = ac.text
		hold_AO = Accuracy_offset.value
		hold_AB = ABbutton.text
		hold_PO = paste_offset.value
		hold_SE = spn_start.enabled    
		hold_EE = spn_end.enabled       	
		hold_AE = ac.enabled
		hold_BE = ABbutton.enabled
		hold_PA = paste_offset.enabled
		hold_TP = testList.visible
		hold_TA = testListAni.visible 
		
		wayneCheckBox.checked = true
		postest = getDialogpos cptools
	    destroyDialog cptools
        createDialog cptools  200 210 pos:postest
		-----------------------------------------------恢复状态		
		wayneCheckBox.checked  = hold_CB
		rb_sel.state           = hold_RB
		spn_start.value        = hold_ST
		spn_end.value          = hold_ED
		ac.text                = hold_AC
		Accuracy_offset.value  = hold_AO 
		ABbutton.text          = hold_AB
		paste_offset.value	   = hold_PO
        spn_start.enabled      = hold_SE 
        spn_end.enabled        = hold_EE
        ac.enabled 		       = hold_AE
        ABbutton.enabled   	   = hold_BE
		paste_offset.enabled   = hold_PA 
		testList.visible       = hold_TP
        testListAni.visible    = hold_TA 
		
	)else(
		english()
		language_btn.text = language_a_lag
		----------------------------------------------记录状态
        hold_CB = wayneCheckBox.checked
		hold_RB = rb_sel.state
		hold_ST = spn_start.value
		hold_ED = spn_end.value
		hold_AC = ac.text
		hold_AO = Accuracy_offset.value
		hold_AB = ABbutton.text
		hold_PO = paste_offset.value			
		hold_SE = spn_start.enabled    
		hold_EE = spn_end.enabled       	
		hold_AE = ac.enabled
		hold_BE = ABbutton.enabled
		hold_PA = paste_offset.enabled
		hold_TP = testList.visible
		hold_TA = testListAni.visible 
		
		wayneCheckBox.checked = true
		postest = getDialogpos cptools
	    destroyDialog cptools
        createDialog cptools  200 210 pos:postest
        -----------------------------------------------恢复状态		
		wayneCheckBox.checked  = hold_CB
		rb_sel.state           = hold_RB
		spn_start.value        = hold_ST
		spn_end.value          = hold_ED
		ac.text                = hold_AC
		Accuracy_offset.value  = hold_AO 
		ABbutton.text          = hold_AB
		paste_offset.value	   = hold_PO
        spn_start.enabled      = hold_SE 
        spn_end.enabled        = hold_EE
        ac.enabled 		       = hold_AE
        ABbutton.enabled   	   = hold_BE
		paste_offset.enabled   = hold_PA 
		testList.visible       = hold_TP
        testListAni.visible    = hold_TA 
	)	
)

on cptools open do 
(
removeFromList.text  = rfl_lag
Accuracy_offset.text = Accuracy_offset_lag
addToList.text       = addToList_lag
pastepose.text       = pastepose_lag
obj_r.text           = obj_r_b_lag
paste_offset.text    = paste_offset_lag
wayneCheckBox.text   = wcb_lag
language_btn.text    = language_a_lag
lnk1.text            = lnk1_lag
---------------------------------------------------------------------------------------------打开文件加载

makeDir  ((GetDir #export)+ "\\cptools_data\\")------创建路径
tempdata = ((GetDir #export)+"\\cptools_data\\"+"temp.ini")-----指定文件
testPath = doesFileExist tempdata------检测文件是否存在
if testPath == true do (
open_tempdata   = openFile tempdata------打开temp文件
skiptostring open_tempdata "wayneCheckBox.checked ="
	readChar open_tempdata
read_tmepdata   = readLine open_tempdata 
if read_tmepdata != undefined do wayneCheckBox.checked = read_tmepdata as booleanClass
close open_tempdata
)
----------------------------------------------------------------------------------------------------------
---------------------------------------获得文件列表
file_name_array = getFiles ((GetDir #export)+"\\cptools_data\\"+"pose*.bps")

for Fe in file_name_array do
(
Bip_FilesName=getFilenameFile Fe
testList.items = append testList.items (Bip_FilesName as string)
)

file_name_array = getFiles ((GetDir #export)+"\\cptools_data\\"+"animation*.bps")

for Fe in file_name_array do
(
Bip_FilesName=getFilenameFile Fe
testListAni.items = append testListAni.items (Bip_FilesName as string)
)	
)	

on rloading pressed do 
(
if testList.items.count > 0 and testList.selection > 0 then 
(
testList.items = #() 
)
	
if testListAni.items.count > 0 and testListAni.selection > 0 then
(
testListAni.items = #()
)

file_name_array = getFiles ((GetDir #export)+"\\cptools_data\\"+"pose*.bps")

for Fe in file_name_array do
(
Bip_FilesName=getFilenameFile Fe
testList.items = append testList.items (Bip_FilesName as string)
testList.selection = testList.items.count
)

file_name_array = getFiles ((GetDir #export)+"\\cptools_data\\"+"animation*.bps")

for Fe in file_name_array do
(
Bip_FilesName=getFilenameFile Fe
testListAni.items = append testListAni.items (Bip_FilesName as string)
testListAni.selection = testListAni.items.count
)	
)


on cptools close do 
(
if wayneCheckBox.checked == false then(for f in getFiles ((GetDir #export)+ "\\cptools_data\\"+"*.bps") do deleteFile f)
---------------------------------------------------------------------------------------------退出文件加载
makeDir  ((GetDir #export)+ "\\cptools_data\\")------创建路径
tempdata = ((GetDir #export)+"\\cptools_data\\"+"temp.ini")-----指定文件
create_tempdata = createfile tempdata
if wayneCheckBox.checked == true then formatdata = "wayneCheckBox.checked = true" else formatdata = "wayneCheckBox.checked = false"
if language_btn.text  == "En" then forlagdata = "Language = true" else  forlagdata = "Language = false" 
format  "%\n" formatdata to:create_tempdata 
format  "%\n" forlagdata to:create_tempdata 
close create_tempdata
----------------------------------------------------------------------------------------------------------
)	
	
	
on ac pressed do 
(
	if ac.text =="C"  then 
	(
		ac.text = "A"
		spn_start.enabled       = false
		spn_end.enabled         = false
		ac.tooltip              = ac_tooltip_a_lag
	)else(
		ac.text                 = "C"
		spn_start.enabled       = true
        spn_end.enabled         = true
		ac.tooltip              = ac_tooltip_b_lag
	)	
)

on rb_sel changed stat do
			(
							case stat of
				(
					1:
					(
						testList.visible        = true
						testListAni.visible     = false
						----------------------------------
                        ac.enabled              = false
                        spn_start.enabled       = false
                        spn_end.enabled         = false
                        paste_offset.enabled    = false
						ABbutton.enabled        = false
                        ----------------------------------
					)
					2:
					(
						testList.visible        = false
						testListAni.visible     = true
						----------------------------------
                        ac.enabled              = true
                        paste_offset.enabled    = true
                        ----------------------------------
						ABbutton.enabled        = true
						----------------------------------
						if ac.text =="C" then ( spn_start.enabled = true; spn_end.enabled = true)else (spn_start.enabled = false; spn_end.enabled = false)
					)
				)
		
			)

on ABbutton pressed do 
(
	if ABbutton.text =="S"  then (ABbutton.text = "K" ;ABbutton.tooltip = ABbutton_tooltip_a_lag )else(ABbutton.text = "S" ;ABbutton.tooltip =ABbutton_tooltip_b_lag)	
)

	
on addToList pressed do
(
with undo "addList" on (
if(rb_sel.state==1)then(
	
if(selection.count == 0 )then(messagebox messagebox_a_lag   title:messagebox_a_title_lag beep:false )else(	

testList.items = append testList.items ("Pose "+ (testList.items.count+1) as string +" ("+ ((currentTime as integer)/TicksPerFrame)  as string +")")
testList.selection = testList.items.count

---------------------------------------------------------------------------------------
tabtxt   = testList.selection		
out_name = ((GetDir #export)+"\\cptools_data\\pose "+ tabtxt as string +" ("+ ((currentTime as integer)/TicksPerFrame) as string +")"+".bps")
out_file = createfile out_name

-------------------------------------将选择重新排序
sort_array =#()
temp_sort_file = selection as array
sort_file = sort(for i in temp_sort_file collect i.name)

for i=1 to sort_file.count do 
(
format "%|" sort_file[i] to: out_file -- 添加一个选择集
)
format "\n"  to:out_file

for i =1 to sort_file.count do 
(
obj =getnodebyname sort_file[i] 
append sort_array obj
)
select sort_array
-----------------------------------------
k=1
for o in selection do
(
	if keyboard.escPressed do 
	(
		format format_a_lag
		exit
	)
doit_prog.value = 100.*k/selection.count
if selection.count !=0 then 
(
	format "$'%'.transform = %\n" o.name o.transform to:out_file
)
k=k+1
format (format_c_lag + ":(%/100)  \n")  doit_prog.value
if doit_prog.value == 100 do (format format_b_lag )
)
doit_prog.value = 0

close out_file

--format "You selected '%'!\n" testList.selection
)	
		
)else(

if(selection.count == 0 )then(messagebox messagebox_a_lag title:messagebox_a_title_lag beep:false )else(

if (end_frame<=start_frame)then(messagebox messagebox_b_lag title:messagebox_a_title_lag beep:false )else(

if ac.text =="C" then ( start_frame = spn_start.value;end_frame = spn_end.value)else (start_frame = animationrange.start;end_frame = animationrange.end)	
	
testListAni.items = append testListAni.items ("Animation "+ (testListAni.items.count+1) as string +"-"+(ABbutton.text) as string +" ("+ (start_frame) as string + "-" + (end_frame) as string+")" )
testListAni.selection = testListAni.items.count
---------------------------------------------------------------------------------------
tabtxt   = testListAni.selection		
out_name = ((GetDir #export)+"\\cptools_data\\animation "+ tabtxt as string +"-"+(ABbutton.text) as string +" ("+ (start_frame) as string + "-" + (end_frame) as string+")"+".bps")
out_file = createfile out_name

tempstime = animationrange.start
tempetime = animationrange.end

animationRange = interval start_frame end_frame--time


-------------------------------------将选择重新排序
sort_array =#()
temp_sort_file = selection as array
sort_file = sort(for i in temp_sort_file collect i.name)

for i=1 to sort_file.count do 
(
format "%|" sort_file[i] to: out_file -- 添加一个选择集
)
format "\n"  to:out_file

for i =1 to sort_file.count do 
(
obj =getnodebyname sort_file[i] 
append sort_array obj
)
select sort_array

----------------------------------------

if ABbutton.text =="S" then (
for i=animationrange.start to animationrange.end do
(
		if keyboard.escPressed do 
	(
		format format_a_lag
		exit
	)
	doit_prog.value = 100.*i/animationrange.end
	slidertime = i

for o in selection do
(
if selection.count !=0 then 
(
	format  "<%>|%| = %\n" i o.name o.transform to:out_file
   )

)
format  (format_c_lag + ":(%/100)  \n")   doit_prog.value
if doit_prog.value == 100 do (format format_b_lag)
)
doit_prog.value = 0

)else(


slidertime = animationrange.start

a = slidertime

frame_data = #()



seek out_file #eof

orgFilePos = filePos out_file

format "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n"  to:out_file

---------------------------------------------------------------关键帧对象位置信息写入
do

(
	if keyboard.escPressed do 
	(
		format format_a_lag
		exit
	)
	append frame_data a
	
    a_lost = a
	
	for o in selection do
(
	if selection.count !=0 then 
   (
	format  "<%>|%| = %\n" a o.name o.transform to:out_file
   )
)
	a = trackbar.getnextkeytime()

	doit_prog.value = 100.*a_lost/(animationrange.end-animationrange.start)

if a!=undefined and a > animationrange.start and  a <= animationrange.end  then (
	
	slidertime = a
	
	)else (  Exit  )
	
format  (format_c_lag + ":(%/100)  \n")   doit_prog.value
	
if doit_prog.value == 100 do (format format_b_lag)	
)

while a > animationrange.start	and a > a_lost 
----------------------------------------------------------------关键帧对象位置信息写入  End
doit_prog.value = 100

format format_b_lag

doit_prog.value = 0

seek out_file orgFilePos 

--------------------------------------------------------------关键帧写入文件
format "frame:" to: out_file

for i=1 to frame_data .count do 
(
format "%|" frame_data [i] to: out_file -- 添加一个帧的选择集

)
format "\n"  to:out_file

--------------------------------------------------------------关键帧写入文件 End

)

close out_file

animationRange = interval tempstime tempetime

)

)
)
)
)


on removeFromList pressed do
(
	
if(rb_sel.state==1)then(
if testList.items.count > 0 and testList.selection > 0 then(
		
tabtxt       = testList.selected
delete_name  = ((GetDir #export)+"\\cptools_data\\"+ tabtxt as string +".bps")

delete_file  = deleteFile delete_name 
if delete_file == undefined do ( messagebox messagebox_c_lag  beep:false Title:messagebox_a_title_lag  Return 0 )
--print tabtxt	
--print delete_name 
--print delete_file

testList.items = deleteItem testList.items testList.selection
testList.selection = testList.items.count
)
)else(
if testListAni.items.count > 0 and testListAni.selection > 0 then(

tabtxt       = testListAni.selected
--print tabtxt	
delete_name = ((GetDir #export)+"\\cptools_data\\"+ tabtxt as string +".bps")
delete_file = deletefile delete_name
if delete_file == undefined do ( messagebox messagebox_d_lag  beep:false Title:messagebox_a_title_lag Return 0 )
--print delete_name 
--print delete_file 
testListAni.items = deleteItem testListAni.items testListAni.selection
testListAni.selection = testListAni.items.count
)
)

)
----------------------------------------------选择pose中添加物体
on testList selected i do
(
tabtxt = testList.items[i]
in_sel = ((GetDir #export)+"\\cptools_data\\"+ tabtxt as string +".bps")
in_file = openFile in_sel
if in_file == undefined do  ( messagebox messagebox_c_lag beep:false Title:messagebox_a_title_lag Return 0 )

seek in_file 0
ss = readLine in_file
tokens = filterString ss "|"
arrayl=#()

for i =1 to tokens.count do 
(
obj =getnodebyname tokens[i] 
if obj != undefined do append arrayl obj
)
if arrayl.count !=0 then select arrayl else  ( messagebox messagebox_e_lag beep:false Title:messagebox_a_title_lag )
close in_file
)

------------------
on testListAni selected i do
(
tabtxt = testListAni.items[i]
in_sel = ((GetDir #export)+"\\cptools_data\\"+ tabtxt as string +".bps")
in_file = openFile in_sel
if in_file == undefined do ( messagebox messagebox_d_lag beep:false Title:messagebox_a_title_lag Return 0 )

seek in_file 0

ss = readLine in_file

tokens = filterString ss "|"

arrayl=#()

for i =1 to tokens.count do 
(
obj =getnodebyname tokens[i] 
if obj != undefined do append arrayl obj
)
if arrayl.count !=0 then select arrayl else  ( messagebox messagebox_e_lag beep:false Title:messagebox_a_title_lag )
close in_file
)



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on pastepose pressed do 
(
	
-------------------------------------将选择重新排序
sort_array =#()
temp_sort_file = selection as array
sort_file = sort(for i in temp_sort_file collect i.name)
for i =1 to sort_file.count do 
(
obj =getnodebyname sort_file[i] 
append sort_array obj
)
select sort_array

----------------------------------------
	
selectundefined = 0

with undo "pasteList" on (
	
	for sec = 1 to Accuracy_offset.value do (
	
if(rb_sel.state==1)then(
	
if testList.items.count > 0 and testList.selection > 0 then(
	
tabtxt  = testList.selected	
in_name =  ((GetDir #export)+"\\cptools_data\\"+ tabtxt as string +".bps")
in_file = openFile in_name
if in_file == undefined  do  ( messagebox messagebox_c_lag  beep:false Title:messagebox_a_title_lag  Return 0 )
--with animate on
--( 	
seek in_file 0

skipToNextLine in_file

orgFilePos = filePos in_file

for i=1 to selection.count do --takes every selected object and...
(
	--print i
	if keyboard.escPressed do 
	(
		format format_a_lag
		exit
	)
doit_prog.value = 100.*i/selection.count	

o=selection[i]

seek in_file orgFilePos 

--ast =filePos in_file 	
--skiptostring in_file "="	
a= skiptostring in_file ((o.name)+"'.transform")	
	
if a==undefined then ( selectundefined =selectundefined+1 )else(

skiptostring in_file "="

ss = readLine in_file ---as stringStream

ex_tran = "$"+"'"+o.name+"'"+".transform="+ ss
	
execute ex_tran
	
format (format_c_lag + ":(%/100)  \n")   doit_prog.value
if doit_prog.value == 100 do (format format_b_lag)	
)
)
doit_prog.value = 0
--)
close in_file

)if selectundefined != 0 then(
--strmessage = "选择中有"+ selectundefined as string +"个对象未记录Pose" 
strmessage = messagebox_f_lag
messagebox strmessage   title:messagebox_a_title_lag beep:false
)
)else(
if testListAni.items.count > 0 and testListAni.selection > 0 then(
	
if(selection.count == 0 )then(messagebox messagebox_a_lag  title:messagebox_a_title_lag beep:false )else(
	
if ac.text =="C" then ( start_frame = spn_start.value+ paste_offset.value;end_frame = spn_end.value+ paste_offset.value)else (start_frame = animationrange.start+ paste_offset.value;end_frame = animationrange.end+ paste_offset.value)

if (start_frame>=end_frame)then(messagebox messagebox_b_lag title:messagebox_a_title_lag beep:false )else(    --time
	
tabtxt  = testListAni.selected
in_name =  ((GetDir #export)+"\\cptools_data\\"+ tabtxt as string +".bps")
in_file = openFile in_name
if in_file == undefined do (messagebox messagebox_d_lag beep:false Title:messagebox_a_title_lag Return 0 )

tempstime = animationrange.start
tempetime = animationrange.end

animationRange = interval (start_frame) (end_frame)--time

------------判断S还是K

s_or_k =  filterstring tabtxt "S"

with animate on
( 
if s_or_k.count != 1 then (	
for m=animationrange.start to animationrange.end do
(
	if keyboard.escPressed do 
	(
		format format_a_lag
		exit
	)
	doit_prog.value = 100.*m/animationrange.end
	sliderTime = m
	
	seek in_file 0 
	
    skipToNextLine in_file	
	
	skiptostring in_file ("<"+((m-paste_offset.value) as String)+">")
	
	orgFilePos = filePos in_file

for i=1 to selection.count do --takes every selected object and...
(
	if keyboard.escPressed do 
	(
		format format_a_lag
		exit
	)
	--seek in_file 0 
--skiptostring in_file ((m) as string)

o=selection[i]

seek in_file orgFilePos 
	
a = skiptostring in_file ("|"+(o.name)+"|")

if a==undefined then ( selectundefined =selectundefined+1 )else(	

skiptostring in_file "="

ss = readLine in_file ---as stringStream

ex_tran = "$"+"'"+o.name+"'"+".transform="+ ss
	
execute ex_tran
	
--readDelimitedString in_file "end"
)
)
format (format_c_lag + ":(%/100)  \n")  doit_prog.value
if doit_prog.value == 100 do (format format_b_lag )
)
doit_prog.value = 0
)else(
----------------------------------------------------------------------------------------------------------------------------粘贴关键帧代码
seek in_file 0

skipToNextLine in_file

skiptostring in_file "frame:"

ss  = readLine in_file

frame_array_filter = filterString ss "|"

frame_arrayl =#()
-----筛选

for k =1 to frame_array_filter.count do 
(
	if frame_array_filter[k] as time >= animationrange.start-paste_offset.value and  frame_array_filter[k] as time <= animationrange.end-paste_offset.value do
	(
		append frame_arrayl frame_array_filter[k] 
		--sort frame_arrayl
	)
)

for m=1 to frame_arrayl.count do
(
	if keyboard.escPressed do 
	(
		format format_a_lag
		exit
	)
	doit_prog.value = 100.*m/frame_arrayl.count
	sliderTime = frame_arrayl[m] as time + paste_offset.value
	
	seek in_file 0 
	
    skipToNextLine in_file	
	
	skipToNextLine in_file	
	
	skiptostring in_file ("<"+( frame_arrayl[m] as String)+">")
	
	orgFilePos = filePos in_file

for i=1 to selection.count do --takes every selected object and...
(
	if keyboard.escPressed do 
	(
		format format_a_lag
		exit
	)
--seek in_file 0 
--skiptostring in_file ((m) as string)

o=selection[i]

seek in_file orgFilePos 
	
a = skiptostring in_file ("|"+(o.name)+"|")

if a==undefined then ( selectundefined =selectundefined+1 )else(	

skiptostring in_file "="

ss = readLine in_file ---as stringStream

ex_tran = "$"+"'"+o.name+"'"+".transform="+ ss
	
execute ex_tran
	
--readDelimitedString in_file "end"
)
)
format (format_c_lag + ":(%/100)  \n")   doit_prog.value
if doit_prog.value == 100 do (format format_b_lag)
)
doit_prog.value = 0

)
)
close in_file

animationRange = interval tempstime tempetime

if selectundefined != 0 then(
selectundefined = selectundefined/(spn_end.value-spn_start.value)
--strmessage = "选择中有"+ selectundefined as string +"个对象未记录Pose" 
strmessage = messagebox_f_lag
messagebox strmessage   title:messagebox_a_title_lag beep:false
selectundefined = 0
)
)
)
)	
)
sec = sec + 1
	sec = sec + 1
)
)
)
---------------------------------------------------------------------------------------
on obj_r pressed do 
(
for o in selection do
(
o.controller = transform_script ()   
o.controller = prs()
)
)
on obj_xyz pressed do 
(
for o in selection do
(
o.position.controller =Position_XYZ()
o.rotation.controller =Euler_XYZ()
)
)
on obj_tcb pressed do 
(
for o in selection do
(
o.position.controller =TCB_Position()
o.rotation.controller =TCB_Rotation()
)
)


)
createDialog cptools 200 210
--bgcolor:[0,0,0] 
)