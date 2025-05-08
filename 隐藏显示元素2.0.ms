rollout testddl_rollout "元素隐藏2.0"
(
	
global list=#()
	global polyname=#()
	global facelist=#()
	global hideface=#()
listbox lb  items:list height:6
button xianshi "显示"  pos:[15,90]
button yincang "隐藏"  pos:[110,90]
	edittext name1 "名称:"  text:"未命名" width:100  pos:[15,138]
	button adddata "增加"  pos:[119,138]
button del "删除"  pos:[15,115]
	button delall "清空"  pos:[110,115]
	 HyperLink lbl9 "使用方法" pos:[60,115] width:80  color:(color 255 127.5 0) address:"https://www.pylblog.com/post/204.html"
	
	Fn optxt tabtxt=(
		
		
		
	in_sel = ((GetDir #export)+"\\hide_data\\"+ tabtxt as string +".gamesh")
	in_file = openFile in_sel
	if in_file == undefined do  ( messagebox messagebox_c_lag beep:false Title:messagebox_a_title_lag Return 0 )

	seek in_file 0
	ss = readLine in_file
	tokens = filterString ss "|"
	arrayl=#{}

	for i =1 to tokens.count do 
	(
	arrdat=tokens[i] as Integer
		--format "sss----------------------------%\n"arrdat
	if tokens[i] != undefined do append arrayl arrdat
	)
	
	close in_file
		
	return arrayl	
		
		
		)
		
		
		
		

		

		
		
		
		
		
		
		
		
		
		
	
	on testddl_rollout open do 
(
	---------------------------------------------------------------------------------------------打开文件加载
		file_name_array = getFiles ((GetDir #export)+"\\hide_data\\"+"*.gamesh")
	if file_name_array == undefined do  ( messagebox messagebox_c_lag beep:false Title:messagebox_a_title_lag Return 0 )
for Fe in file_name_array do
(
	global my_array= #{}
Bip_FilesName=getFilenameFile Fe
	filenam=Bip_FilesName as string

append list (filenam)
	
	
	my_array=optxt filenam
	
	lb.items = list
	
	append facelist(my_array)
	
	 format "xxl----------------------------%\n"facelist
	
	
)

----------------------------------------------------------------------------------------------------------
	)
	
	
	
	
	on adddata pressed do (
	if  $==undefined then (MessageBox "请先选择一个物体" return 0)		
		global my_array= #{} --define an empty bitarray
 b = bit.Set 0 1 true --set the first bit to true
--now call the function and supply the empty array as
--In parameter by reference and the flag bit to filter out
$.getFacesByFlag&my_array b
--Now look at the content of the bitarray:
--it will contain the edges that have their first flag bit set
--(bit 1 stands for selected, so it will contain the edge selection)
		
	if my_array.count==0 then (MessageBox "请先选择需要隐藏的元素" return 0)
name2=name1.text+"$"+$.name
	
if polyname.count !=0 then(		 
for i = 1 to polyname.count do

(
		if polyname[i]==  name2 then (MessageBox "命名重复" return 0)
	
	
)
	)	
		
	 format "xxl----------------------------%\n"my_array
	 append list(name1.text+"$"+$.name)
	
	
	lb.items = list
	
	append facelist(my_array)
	
	append polyname(name2)
	
	
	
	
	-----------------------------------------手动输入----------------------------------------------


	---------------------------------------------------------------------------------------
	
	out_name = ((GetDir #export)+"\\hide_data\\"+ name1.text as string +"$"+$.name+".gamesh")
	out_file = createfile out_name
sort_file=my_array as array
for i=1 to sort_file.count do 
	(
	format "%|" sort_file[i] to: out_file -- 添加一个选择集
	)
	format "\n"  to:out_file

	close out_file

	--format "You selected '%'!\n" testList.selection
		
		
	
	)
	
	
	
	
	
	on del pressed do (
		
		
		
	  if lb.items.count > 0 and lb.selection > 0 then(
    
		  
		  format "lb.selection----------------------------%\n"lb.selection
		  
		  tabtxt       = lb.selected
delete_name  = ((GetDir #export)+"\\hide_data\\"+ tabtxt as string +".gamesh")

delete_file  = deleteFile delete_name 
if delete_file == undefined do ( messagebox messagebox_c_lag  beep:false Title:messagebox_a_title_lag  Return 0 )

deleteItem facelist lb.selection
			--face=facelist[lb.selection]
		for i = 1 to hideface.count do(
			if hideface[i]==lb.selection then(
				deleteItem hideface i
				
				
		)  
		
		  
	  )
	
	  
format "hideface----------------------------%\n"hideface
		 list = deleteItem list lb.selection
	  lb.items = list
		lb.selection = lb.items.count))
	
	
	
	
	
	
	on delall pressed do (
		
				file_name_array = getFiles ((GetDir #export)+"\\hide_data\\"+"*.gamesh")
	if file_name_array == undefined do  ( messagebox messagebox_c_lag beep:false Title:messagebox_a_title_lag Return 0 )
for Fe in file_name_array do
(deleteFile Fe
	
format "hideface----------------------------%\n"Fe

)

global polyname=#()
	global facelist=#()
	global hideface=#()
list=#()
lb.items = list
)
	
	
	
	
	
	
	
	
	on xianshi pressed do (	
	if lb.items.count==0 and lb.selection !=undefined then (MessageBox "选择为空" return 0)

	
	tokenss1 = filterString lb.selected "$"
	
	arrdat1=tokenss1[2] 
		 
for i = 1 to objects.count do

(
		if objects[i].name== arrdat1 then select $objects[i] 
	
	
)
	
	if  $==undefined then (MessageBox "请先选择或添加需要隐藏的元素" return 0)
	
	

		--face=facelist[lb.selection]
		for i = 1 to hideface.count do(
			if hideface[i]==lb.selection then(
				deleteItem hideface i
				
		))
	--print face
	--polyop.setFaceSelection $ face
$.EditablePoly.UnHideAll #Face
			format "hideface----------------------------%\n" hideface
	for i = 1 to hideface.count do(
		xa=facelist[hideface[i]]
		format "xa----------------------------%\n" xa
		if  xa==undefined then (MessageBox "kong" return 0)
	--polyop.setFaceSelection $ xa
	
$.EditablePoly.SetSelection #Face xa
		$.EditablePoly.Hide #Face
	)
)
on yincang pressed do (
		

		
		
		
if lb.items.count==0 and lb.selection !=undefined then (MessageBox "选择为空" return 0)

	
	tokenss = filterString lb.selected "$"
	
	arrdat=tokenss[2] 
		 
for i = 1 to objects.count do

(
		if objects[i].name== arrdat then select $objects[i] 
	--format "x----------------------------%\n" objects[i].name
	
)
	
	if  $==undefined then (MessageBox "请先选择或添加需要隐藏的元素" return 0)
	
	
	
	
	 
	
	
	
	

	
	if findItem hideface lb.selection == 0  then(append hideface(lb.selection))
		
		
		
	face=facelist[lb.selection]
	--print face
	polyop.setFaceSelection $ face
	$.EditablePoly.Hide #Face
	
	 	format "hideface----------------------------%\n" hideface

	)
)
createDialog testddl_rollout