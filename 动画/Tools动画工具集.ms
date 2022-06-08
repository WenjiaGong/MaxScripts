(
try (	cui.unRegisterDialogBar Timerange)catch()
try (	destroydialog Timerange)catch()
try (	cui.unRegisterDialogBar maxduqu)catch()
try (	destroydialog maxduqu)catch()		
try (	cui.unRegisterDialogBar Timerange001)catch()
try (	destroydialog Timerange01)catch()
try (	cui.unRegisterDialogBar rendrollout1)catch()
try (	destroydialog rendrollout1)catch()
try (	cui.unRegisterDialogBar cptools)catch()
try (	destroydialog cptools)catch()
try (	cui.unRegisterDialogBar splineAnime)catch()
try (	destroydialog splineAnime)catch()
try (	cui.unRegisterDialogBar rol_copyPasteAni)catch()
try (	destroydialog rol_copyPasteAni)catch()
try (	cui.unRegisterDialogBar gt_9_BoneMIss)catch()
try (	destroydialog gt_9_BoneMIss)catch()
try (	cui.unRegisterDialogBar xiaogongju)catch()
try (	destroydialog xiaogongju)catch()
--------------------------------------------------------------------窗口的唯一性
global	Thepos=[0,0]
global mousedd=false
global Thepos12=[1300,230]

---------------------------------------------------------------------窗口移动事件变量
global	Thepos1=[0,0]
	global mousedd1=false
	Global DestinationPath_STR
	local allFiles = #()
	global lujing=""
	local last_path = ""
	local model_type_sel = 1
	
rollout Timerange "AnimationTimes v1.0.11" width:220 height:185
(
	GroupBox grp3 "" pos:[5,30] width:210 height:150
	button Clo_btn "x" pos:[205,0] width:15 height:15 toolTip:"关闭"
	spinner sp_start "开始 :" pos:[0,160] width:100 height:16 range:[-99999999,99999999,0]  type:#integer fieldwidth:50
	spinner sp_end "结束 :" pos:[100,160] width:100 height:16 range:[-99999999,99999999,100] type:#integer fieldwidth:50
	button fuzu "-" pos:[0,0] width:15 height:15 toolTip:"最小化/最大化"
	checkbutton R_Xf "隐藏显示模型" pos:[10,40] width:90 height:20  
  
	checkbutton Fz_Mdl "冻结解冻模型" pos:[110,40] width:90 height:20
	checkbutton UH_CS "隐藏显示CS" pos:[10,65] width:90 height:20
	checkbutton UH_BN "隐藏显示Bone" pos:[110,65] width:90 height:20
	checkbutton Dis_Box "Box" pos:[10,90] width:90 height:20
	checkbutton UH_GUGU "隐藏显示骨骼" pos:[110,90] width:90 height:20
	button btn12 "创建末端骨骼" pos:[10,115] width:90 height:20
	button btn13 "清除末端骨骼" pos:[110,115] width:90 height:20
	radiobuttons rdo1 "" pos:[2,140] width:219 height:16 labels:#("1/4x", "1/2x", "1x", "2x", "4x") default:3 columns:5
	button save_btn "存" pos:[20,0] width:16 height:16 toolTip:"保存为2011"
	button uiDel12 "R" pos:[40,0] width:16 height:16 toolTip:"刷新"
	checkbutton uiDel122 "读" pos:[60,0] width:16 height:16 toolTip:"max读取"
	checkbutton uiDel13 "帧" pos:[80,0] width:16 height:16 toolTip:"动画时间记录工具"
	checkbutton uiDel14 "蒙" pos:[100,0] width:16 height:16 toolTip:"蒙皮工具"
	checkbutton uiDel15 "拷" pos:[120,0] width:16 height:16 toolTip:"暴力帧拷贝粘贴"
	checkbutton uiDel16 "飘" pos:[140,0] width:16 height:16 toolTip:"飘带计算9.0"
	checkbutton uiDel17 "考" pos:[160,0] width:16 height:16 toolTip:"复制|粘帖 动画|POSE"
	checkbutton uiDel18 "镜" pos:[180,0] width:16 height:16 toolTip:"骨骼动作镜像工具"
	checkbutton uiDel19 "具" pos:[20,20] width:16 height:16 toolTip:"小工具"
	
	fn SetTimeRange = (
			stopAnimation()
			animationRange = interval sp_start.value sp_end.value
		)
fn updatesp_Values =(
		sp_start.value = (animationRange.start.frame as integer)   
		sp_end.value = (animationRange.end.frame as integer)
		)


fn load_range =
	(
		if ddl_range.selected != undefined do
		(
			rangeArray = filterString ddl_range.selected " "
			Start_range = rangeArray[(rangeArray.count)-1] as integer
			End_range = rangeArray[(rangeArray.count)] as integer
			if Start_range != undefined and End_range != undefined do
			animationRange = interval Start_range End_range
		)	
	)
	on Timerange open do
	(
		updatesp_Values()
		if classof Range_items == Array do ddl_range.items = Range_items

		if classof Range_selection == Integer do ddl_range.selection = Range_selection
	)
	
	on Timerange close do
	(
			unRegisterRedrawViewsCallback reload
		)
	on sp_start changed val do
	(
				if sp_start.value >= sp_end.value then sp_end.value = (sp_start.value)+1
				SetTimeRange()
			)
	on sp_end changed val do
	(
				if sp_end.value <= sp_start.value then sp_start.value = (sp_end.value)-1
				SetTimeRange()
			)
	
	on Timerange lbuttonup pos do
		mousedd=false

	on Timerange lbuttondown pos do
	(
	mousedd=true
	Thepos=pos
		)
	on Timerange mouseMove pos do
(
		if mousedd==true Then 
		(SetDialogPos Timerange  (mouse.screenpos-Thepos)
			
		Thepos12=mouse.screenpos-Thepos
			
			
			)
			
			
		)
	
	on Clo_btn pressed do
	(
		destroydialog Timerange
	
		)
	on fuzu pressed do
	(
		if Timerange.height == 15 then
	    (Timerange.height = 185
			Timerange.width=220)else 
	
		if Timerange.height==185 do 
		(
	
			Timerange.height=15
		Timerange.width=15	
			)
		
		
	)
		on save_btn pressed do(
		if maxfilename != "" then(
		a = maxVersion()
		if a[1] == 18000 do(
		saveMaxFile (maxfilepath+maxfilename) saveAsVersion:2013
		)
		if a[1] == 17000 do(
		saveMaxFile (maxfilepath+maxfilename) saveAsVersion:2012
		)
		if a[1] == 16000 do(
		saveMaxFile (maxfilepath+maxfilename) saveAsVersion:2011
		)
		if a[1] == 15000 do(
		saveMaxFile (maxfilepath+maxfilename) saveAsVersion:2010
		)
		
		print ("\n"+ (maxfilepath+maxfilename))
		)
		else
		
		MessageBox ("请先保存场景" ) title:"警告"
	)
	on R_Xf changed state do
	(
		if state then
		(   
	Mod_Arr=for i in objects where(classof i==Editable_Poly or classof i==Editable_mesh or classof i==PolyMeshObject)collect i
			Mod_Arr.showFrozenInGray = off
	hide  Mod_Arr
					)
		else
		(
		Mod_Arr=for i in objects where(classof i==Editable_Poly or classof i==Editable_mesh or classof i==PolyMeshObject)collect i
			Mod_Arr.showFrozenInGray = off
	
		unhide  Mod_Arr
	
					)
	
	)
	on Fz_Mdl changed state do
	(
		if state then
		(
			Mod_Arr=for i in objects where(classof i==Editable_Poly or classof i==Editable_mesh or classof i==PolyMeshObject)collect i
			Mod_Arr.showFrozenInGray = off
			freeze Mod_Arr
		)
		else
		(
			Mod_Arr=for i in objects where(classof i==Editable_Poly or classof i==Editable_mesh or classof i==PolyMeshObject)collect i
			unfreeze Mod_Arr
		)		
	)
	on UH_CS changed state do
	(
		if state then
		(
			CS_All=for i in objects where (classof i==Biped_Object or classof i == Dummy) collect i
			hide CS_All
		)
		else
		(
			CS_All=for i in objects where (classof i==Biped_Object or classof i == Dummy) collect i
			unhide CS_All
		)
	)
	on UH_BN changed state do
	(
		if state then
		(
			Bn_All=for i in objects where (classof i==BoneGeometry) collect i
			hide Bn_All
		)
		else
		(
			Bn_All=for i in objects where (classof i==BoneGeometry) collect i
			unhide Bn_All
		)
	)
	on Dis_Box changed state do
	(
		if state then
		(
			Bone_All=for i in objects where (classof i==Biped_Object or classof i == Dummy or classof i==BoneGeometry) collect i
			Bone_All.boxmode=on
		)
		else
		(
			Bone_All=for i in objects where (classof i==Biped_Object or classof i == Dummy or classof i==BoneGeometry) collect i
			Bone_All.boxmode=off
		)	
	)
	on UH_GUGU changed state do
	(
	if state then
		(
			Bn_All=for i in objects where (classof i==BoneGeometry) collect i
			hide Bn_All
		)
		else
		(
			Bn_All=for i in objects where (classof i==BoneGeometry) collect i
			unhide Bn_All
		)
		if state then
		(
			CS_All=for i in objects where (classof i==Biped_Object or classof i == Dummy) collect i
			hide CS_All
		)
		else
		(
			CS_All=for i in objects where (classof i==Biped_Object or classof i == Dummy) collect i
			unhide CS_All
		)
	)
	
	on btn12 pressed  do
	(   
		undo on
		(
			with Animate Off   --with Animate Off bracket open
			(   
				local endbones = #()
				for i in geometry do
				(
					if classof i == BoneGeometry and i.children.count == 0 then
					(
						append endbones i
					)
				)
				for i in endbones do
				(
					local parentBone  = i
					local parentTrans = parentBone.transform
					local parentPos   = parentTrans.translation
					local newbone
					with redraw off 					(
						newBone=BoneSys.createBone parentPos (parentPos+6) parentBone.dir
						newBone.transform = parentTrans
						in coordSys Local move newBone [parentBone.length,0,0]
		
						newBone.parent    = parentBone
						putChildIntoAssembly= newBone
		
						newBone.width     = parentBone.width
						newBone.height    = parentBone.height
						newBone.taper     = 90
						newBone.length    = (parentBone.width+parentBone.height)/2
						newBone.wirecolor = parentBone.wirecolor
		
						select newBone
					)
					redrawViews()
				)
			) -- with Animate Off bracket close
		)
	)
	--按钮12结束
	on btn13 pressed  do
	(
	undo on
		(
			with Animate Off   --with Animate Off bracket open
			(   
				local endbones = #()
				for i in geometry do
				(
					if classof i == BoneGeometry and i.children.count == 0 then
					(
						append endbones i
					)
				)
				for i in endbones do
				(
					with redraw off 
					(
						delete  i
					)
					redrawViews()
				)
			) -- with Animate Off bracket close
		)
	)
	--按钮13结束
	on rdo1 changed stat do
	(
							case stat of
				(
					1:
					(timeConfiguration.playbackSpeed=1)
					2:
					(timeConfiguration.playbackSpeed=2)
					3:
					(timeConfiguration.playbackSpeed=3)
					4:
					(timeConfiguration.playbackSpeed=4)
					5:
					(timeConfiguration.playbackSpeed=5)
			
				)
		
	)
	on uiDel122 changed state do
	(
		if state then
			
		( 
			TheposQ=(Thepos12+[-220,0])
	createdialog maxduqu pos:TheposQ bgcolor:(color 50 50 50)  fgcolor:(color 50 255 255)  style:#( #style_minimizebox)			
		)
		else
		(
			DestroyDialog maxduqu
		)
		)
		on uiDel13 changed state do
	(
		if state then
		( 	TheposQ=(Thepos12+[-220,0])
	createdialog Timerange01 pos:TheposQ bgcolor:(color 50 50 50)  fgcolor:(color 50 255 255)  style:#( #style_minimizebox)			
		)
		else
		(
			DestroyDialog Timerange01
		)
		)
		on uiDel14 changed state do
	(
		if state then
		( 	TheposQ=(Thepos12+[-220,0])
	createdialog rendrollout1 pos:TheposQ bgcolor:(color 50 50 50)  fgcolor:(color 50 255 255)  style:#( #style_minimizebox)			
		)
		else
		(
			DestroyDialog rendrollout1
		)
		)
		on uiDel15 changed state do
	(
		if state then
		( 	TheposQ=(Thepos12+[-220,0])
	createdialog cptools  pos:TheposQ bgcolor:(color 50 50 50)  fgcolor:(color 50 255 255)  style:#( #style_minimizebox)			
		)
		else
		(
			DestroyDialog cptools 
		)
		)
				on uiDel16 changed state do
	(
		if state then
		( 	TheposQ=(Thepos12+[-220,0])
	createdialog splineAnime  pos:TheposQ bgcolor:(color 50 50 50)  fgcolor:(color 50 255 255)  style:#( #style_minimizebox)			
		)
		else
		(
			DestroyDialog splineAnime
		)
		)
						on uiDel17 changed state do
	(
		if state then
		( 	TheposQ=(Thepos12+[-220,0])
	createdialog rol_copyPasteAni  pos:TheposQ bgcolor:(color 50 50 50)  fgcolor:(color 50 255 255)  style:#( #style_minimizebox)			
		)
		else
		(
			DestroyDialog rol_copyPasteAni
		)
		)
								on uiDel18 changed state do
	(
		if state then
		( 	TheposQ=(Thepos12+[-220,0])
	createdialog gt_9_BoneMIss  pos:TheposQ bgcolor:(color 50 50 50)  fgcolor:(color 50 255 255)  style:#( #style_minimizebox)			
		)
		else
		(
			DestroyDialog gt_9_BoneMIss
		)
		)
										on uiDel19 changed state do
	(
		if state then
		( 	TheposQ=(Thepos12+[-220,0])
	createdialog xiaogongju  pos:TheposQ bgcolor:(color 50 50 50)  fgcolor:(color 50 255 255)  style:#( #style_minimizebox)			
		)
		else
		(
			DestroyDialog xiaogongju
		)
		)
on uiDel12 pressed  do
(	
postest = getDialogpos Timerange
	    destroyDialog Timerange
createdialog Timerange   bgcolor:(color 50 50 50)  fgcolor:(color 50 255 255)  style:#( #style_minimizebox) pos:postest
)
)
	
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------

	
	rollout maxduqu "读取器1.0" width:220 height:185
	(
	button btnExport "存" pos:[5,5] width:20 height:20   toolTip: "左键单击：保存当前打开文件为2011             右击单击：批量保存打开路径文件为2011"
	button shuaxing "R" pos:[25,5] width:20 height:20 toolTip: "刷新列表"
	editText imp_path "" pos:[45,5] width:125 height:20 enabled:false  color:(color 50 50 50) 
	button btnImpPathBrowse "打开" pos:[175,5] width:40 height:20 toolTip: "文件路径"
	multiListBox mlb_files "" pos:[5,30] width:210 height:10
	label timerange "00" pos:[170,170] width:50 height:20 
	label timerange12 "打开路径包含max文件数为：" pos:[10,170] width:160 height:20
		on maxduqu lbuttondblclk g11 do
	(
		DestroyDialog maxduqu
		)
	on maxduqu lbuttonup pos1 do 
		mousedd1=false
	on maxduqu lbuttondown pos1 do
		(
		mousedd1=true
		Thepos1=pos1
			)
	on maxduqu mousemove pos1 do
	(	if mousedd1==true Then 
		(SetDialogPos maxduqu (mouse.screenpos-Thepos1))
		
		)
	on shuaxing pressed do
	(
				imp_path.text=maxfilepath
			
			lujing=imp_path.text
			DestinationPath_STR = lujing as string
		get_path = DestinationPath_STR + "\\"
		allFiles = getFiles (get_path+"*.max")
		mlb_files.items = for f in allFiles collect (filenameFromPath f)
		timeRange.text= allFiles.count as string
		mlb_files.selection = 1 
			
		)
	on maxduqu open do
		(
		
			imp_path.text=maxfilepath
			
			lujing=imp_path.text
			DestinationPath_STR = lujing as string
		get_path = DestinationPath_STR + "\\"
	allFiles = getFiles (get_path+"*.max")
		mlb_files.items = for f in allFiles collect (filenameFromPath f)
		timeRange.text= allFiles.count as string
		mlb_files.selection = 1 
			
	)
	on btnImpPathBrowse rightclick do
		(
		   getOpenFileName filename: imp_path.text 
			
		)

	on btnImpPathBrowse pressed do
	(
		local path = getSavePath caption:"" initialDir:last_path
		if path == undefined do
		(
			path = imp_path.text
		)
		last_path = path
		imp_path.text = path
		DestinationPath_STR = path as string
		get_path = DestinationPath_STR + "\\"
		allFiles = getFiles (get_path+"*.max")
	mlb_files.items = for f in allFiles collect (filenameFromPath f)
	timeRange.text= allFiles.count as string
		mlb_files.selection = 1 
		lujing=path
	)
	on mlb_files doubleClicked val do
	(	
	
	gc()	
	FileName = allFiles[val]
	
	loadMAXFile FileName
		
	
	)
	on btnExport pressed do(
		if maxfilename != "" then(
		a = maxVersion()
		if a[1] == 18000 do(
		saveMaxFile (maxfilepath+maxfilename) saveAsVersion:2013
		)
		if a[1] == 17000 do(
		saveMaxFile (maxfilepath+maxfilename) saveAsVersion:2012
		)
		if a[1] == 16000 do(
		saveMaxFile (maxfilepath+maxfilename) saveAsVersion:2011
		)
		if a[1] == 15000 do(
		saveMaxFile (maxfilepath+maxfilename) saveAsVersion:2010
		)
		
		print ("\n"+ (maxfilepath+maxfilename))
		)
		else
		
		MessageBox ("请先保存场景" ) title:"警告"
	)
	on btnExport rightclick do
	(
	
		
	files = getFiles (imp_path.text + "\\*.max")	
	for f in files do (loadMAXFile f;
	(
		if maxfilename != "" then(
		a = maxVersion()
		if a[1] == 18000 do(
		saveMaxFile (maxfilepath+maxfilename) saveAsVersion:2013
		)
		if a[1] == 17000 do(
		saveMaxFile (maxfilepath+maxfilename) saveAsVersion:2012
		)
		if a[1] == 16000 do(
		saveMaxFile (maxfilepath+maxfilename) saveAsVersion:2011
		)
		if a[1] == 15000 do(
		saveMaxFile (maxfilepath+maxfilename) saveAsVersion:2010
		)
		
		print ("\n"+ (maxfilepath+maxfilename))
		)
		else
		
		MessageBox ("请先保存场景" ) title:"警告"
	)
	print objects)
		
	)
	)

createdialog Timerange pos:Thepos12 bgcolor:(color 50 50 50)  fgcolor:(color 50 255 255)  style:#( #style_minimizebox)
--callbacks.addScript #animationRangeChange "Timerange.updatesp_Values()" id:#Sp_Values
-------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------	
try (	cui.unRegisterDialogBar AniTimes_Rol1)catch()
try (	destroydialog AniTimes_Rol1)catch()
global saveAllItemCount,uiMinMax,PLAYS,speed_14x,speed_12x,speed_1x,speed_2x,speed_4x,speed_rate,setFrameRate_rol
global ATkkk, uiAddLock, uiAddLockP, uiDelLock, uiDelLockP, uiEditLock, uiEditLockP, itemSeled, savetimeNum
global AT_DS
DOCKSAVEF = ((getdir #scripts)+"\OOX_ATs.ic")
if (doesFileExist DOCKSAVEF) then(
	FIL=openfile DOCKSAVEF
	format "%\n" (AT_DS=readvalue FIL)
	close FIL
)else(
	AT_DS=#cui_dock_bottom
)
ATkkk = getinisetting "$scripts\custom_prefs.ini" "AT" "k"
if (getINISetting "$scripts\custom_prefs.ini" "atsInterface" "AddLockD")=="" do setINISetting "$scripts\custom_prefs.ini" "atsInterface" "AddLockD" "0"
if (getINISetting "$scripts\custom_prefs.ini" "atsInterface" "DelLockD")=="" do setINISetting "$scripts\custom_prefs.ini" "atsInterface" "DelLockD" "0"
if (getINISetting "$scripts\custom_prefs.ini" "atsInterface" "EditLockD")=="" do setINISetting "$scripts\custom_prefs.ini" "atsInterface" "EditLockD" "0"
if maxfilepath == "" then(
	itemSeled = 1
)else(
	fileNam = filterString maxfilename "."
	itemSeled = (getinisetting (maxfilepath+fileNam[1]+"_AT.ini") "AniTimes" "itemSelected") as integer
)

uiAddLock = getINISetting "$scripts\custom_prefs.ini" "atsInterface" "AddLock"
uiDelLock = getINISetting "$scripts\custom_prefs.ini" "atsInterface" "DelLock"
uiEditLock = getINISetting "$scripts\custom_prefs.ini" "atsInterface" "EditLock"
if uiAddLock == "" or uiAddLock == "0" then(
	setINISetting "$scripts\custom_prefs.ini" "atsInterface" "AddLock" "0"
	--
)else(
	--
)
if uiDelLock == "" or uiDelLock == "0" then(
	setINISetting "$scripts\custom_prefs.ini" "atsInterface" "DelLock" "0"

)else(
	)
if uiEditLock == "" or uiEditLock == "0" then(
	setINISetting "$scripts\custom_prefs.ini" "atsInterface" "EditLock" "0"
	--uiEditLockP = (openBitMap "$ui\Icons\AT_ats_edittime.bmp")
)else(
	--uiEditLockP = (openBitMap "$ui\Icons\AT_ats_edittimelock.bmp")
)

setINISetting "$scripts\custom_prefs.ini" "atsInterface" "uiMinMax" "false"
setINISetting "$scripts\custom_prefs.ini" "atsInterface" "PLAYS" "false"
	global name_rol
	global timerange
	---------------------------------------------------------中英文切换
	global  a= "中" 
	global  b= "刷新"
	global  d="播放"
	global	 c="停止"
	global	 f="添加"
	global  g="锁定"
	global  h="删除" 
	global	 i="编辑"
	global  j="保存"
	global  k="读取"
	global  l="替换"
	global  m="开始 :"
	global  n="结束 :"
	global  q=3
	
	fn english = (
		a="E"
 		b="R"
		d=">"
		c="||"
		f="+"
		g="Lock"
		h="-" 
		i="#"
		j="Save"
		k="Read"
		l="~"
		m="statt :"
		n="end  :"
		
	)	
	fn china = (
		a= "中" 
		b= "刷新"
		d="播放"
		c="停止"
		f="添加"
		g="锁定"
		h="删除" 
		i="编辑"
		j="保存"
		k="读取"
		l="替换"
		m="开始 :"
		n="结束 :"
		
	)
		
			
	-----------------------------------------------------------------------------------------------
rollout timerange01 "AnimationTimes v1.0.11" width:220 height:160
(
	GroupBox grp3 "" pos:[5,-2] width:210 height:155
	button Clo_btn "x" pos:[230,8] width:15 height:15 toolTip:"关闭"
	--button SW_btn "s" pos:[990,13] width:12 height:11 tooltip:"保存窗口位置"
	edittext Name_edt "" pos:[10,35] width:200 height:20 bold:true
	dropdownList aniLise_ddl "" pos:[13,56] width:198 height:22 selection:1
	label uiNumA "" pos:[190,80] width:20 height:15
	button uiReload "刷新" pos:[15,8] width:30 height:20 toolTip:"刷新列表"
	checkbutton uiPlay "播放" pos:[14,126] width:50 height:24 toolTip:"播放\右键设置"
	button uiAddtime "添加" pos:[90,8] width:35 height:20 toolTip:"添加时间记录"
	button uiDeltime "删除" pos:[132,8] width:35 height:20 toolTip:"删除选中的时间记录"
	button uiEdittime "编辑" pos:[174,8] width:35 height:20 toolTip:"编辑选中的时间记录"
	button uiSave "保存" pos:[15,100] width:40 height:20 toolTip:"保存当前整组时间记录为模板"
	button uiLoad "读取" pos:[66,100] width:40 height:20 toolTip:"读取模板"
	button uiEdit "替换" pos:[116,100] width:40 height:20 toolTip:"替换模板"
	button uiDel "删除" pos:[168,100] width:40 height:20 toolTip:"删除模板"
	dropdownList saveAll_ddl "" pos:[70,126] width:140 height:5
		on timerange01 lbuttondblclk g11 do
	(
		DestroyDialog timerange01
		)
on timerange01 lbuttonup pos1 do 
		mousedd1=false
	on timerange01 lbuttondown pos1 do
		(
		mousedd1=true
		Thepos1=pos1
			)
	on timerange01 mousemove pos1 do
	(	if mousedd1==true Then 
		(SetDialogPos timerange01 (mouse.screenpos-Thepos1))
		
		)
fn load_range =
	(
		if ddl_range.selected != undefined do
		(
			rangeArray = filterString ddl_range.selected " "
			Start_range = rangeArray[(rangeArray.count)-1] as integer
			End_range = rangeArray[(rangeArray.count)] as integer
			if Start_range != undefined and End_range != undefined do
			animationRange = interval Start_range End_range
		)	
	)
	
	
	
	------------------------------------------------
		
	
	fn saveItemSel =(
		if maxfilepath != "" then(
		fileName = filterString maxfilename "."
		setinisetting (maxfilepath+fileName[1]+"_AT.ini") "AniTimes" "itemSelected" (aniLise_ddl.selection as string)
	))
	fn getAniNum num = (	--num要转为string
		
			if num == "0" then(
				
				
				
				uiNumA.text = "0"
				
				
				)else(
				
				
				num as  string
				
				
				uiNumA.text = num
				
				
				
				
				
			)
		
	)
	fn saveItems =(
		if maxfilepath != "" then(
			FileN = filterString maxfilename "."
			itemSeled = getinisetting (maxfilepath+FileN[1]+"_AT.ini") "AniTimes" "itemSelected"
			if itemSeled == "" then itemSeled = 1 else itemSeled = itemSeled as integer
			for i in 1 to aniLise_ddl.items.count do(
				setinisetting (maxfilepath+FileN[1]+"_AT.ini") "AniTimes" (i as string) aniLise_ddl.items[i]
			)
			setinisetting (maxfilepath+FileN[1]+"_AT.ini") "AniTimes" "itemsCount" (aniLise_ddl.items.count as string)
			getAniNum (aniLise_ddl.items.count as string)
			if aniLise_ddl.items.count > 0 then(
				if itemSeled <= aniLise_ddl.items.count then () else (itemSeled = aniLise_ddl.items.count
					aniLise_ddl.selection = itemSeled)
				Name_edt.text = aniLise_ddl.items[itemSeled]
			)
		)else(messagebox "请先保存场景或打开一个场景!" beep:false title:"AniTimes")
	)
	fn ReloadTemp =(
		saveAllItemCount = (getinisetting "$scripts\oox_saveAniTimeTmp.ini" "AniSave" "saveAllDllcount") as integer
		saveAllDllTmp = #()
		for si in 1 to saveAllItemCount do(
			saveAllItem = getinisetting "$scripts\oox_saveAniTimeTmp.ini" "AniSave" (si as string)
			append saveAllDllTmp saveAllItem
		)
		saveAll_ddl.items = saveAllDllTmp
	)
	fn reload =(
		if maxfilepath != "" then(
			FileN = filterString maxfilename "."
			itemCount = getinisetting (maxfilepath+FileN[1]+"_AT.ini") "AniTimes" "itemsCount"
			itemSeled = getinisetting (maxfilepath+FileN[1]+"_AT.ini") "AniTimes" "itemSelected"
			if itemSeled == "" then itemSeled = 1 else itemSeled = itemSeled as integer
			if itemCount != "" then(
				itemCount = itemCount as integer
				itemsArr = #()
				for i in 1 to itemCount do(
					itemTmp = getinisetting (maxfilepath+FileN[1]+"_AT.ini") "AniTimes" (i as string)
					append itemsArr itemTmp
				)
				aniLise_ddl.items = itemsArr
				if itemSeled <= itemsArr.count then
					aniLise_ddl.selection = itemSeled
				else
					aniLise_ddl.selection = 1
				getAniNum (itemCount as string)
			)else(
				aniLise_ddl.items = #()
				getAniNum "0"
			)
		)else(
			aniLise_ddl.items = #()
			getAniNum "0"
		)
	)
	fn EditATS =(
		uiEditLock = (getINISetting "$scripts\custom_prefs.ini" "atsInterface" "EditLock")
		if uiEditLock == "0" then(
		if Name_edt.text != "" then(
			if aniLise_ddl.selected != undefined then(
		if maxfilepath != "" then(
			fileN = filterString maxfilename "."
			itemSeled = getinisetting (maxfilepath+fileN[1]+"_AT.ini") "AniTimes" "itemSelected"
			if itemSeled == "" then itemSeled = 1 else itemSeled = itemSeled as integer
		)else(messagebox "请先保存场景或打开一个场景!" beep:false title:"AniTimes")
				frameC = filterString Name_edt.text "-( )/"
				frameS = filterString aniLise_ddl.selected "-( )/"
				if frameC[2] != undefined then(
					if frameC[2] == frameS[2] and frameC[3] == frameS[3] then(
						startTmp = animationRange.start as string
						endTmp = animationRange.end as string
					)else(
						startTmp = frameC[2]
						endTmp = frameC[3]
					)
				)else(
					startTmp = animationRange.start as string
					endTmp = animationRange.end as string
				)
				nameSTmp = filterString Name_edt.text "-"
				aniLise_ddl.selected = (nameSTmp[1]+"-("+startTmp+"/"+endTmp+")")
				saveItems()
			)
		)else(messagebox "编辑前请先选择记录！" beep:false title:"AniTimes")
		)
	)


	on timerange01 open do
	(

			reload()
			registerRedrawViewsCallback reload
			ReloadTemp()
			saveAllItemCount = getinisetting "$scripts\oox_saveAniTimeTmp.ini" "AniSave" "saveAllDllcount" as integer
			if saveAllItemCount>0 then(
				
				
			)else(
			
				
			)
		)
	on timerange01 close do
	(
			unRegisterRedrawViewsCallback reload
		)
	on Clo_btn pressed do
	(
			cui.unRegisterDialogBar timerange01
			destroydialog timerange01
		)
	on aniLise_ddl selected item do
	(
			Name_edt.text = aniLise_ddl.items[item]
			setINISetting "$scripts\custom_prefs.ini" "atsInterface" "PLAYS" "false"
	-- 		uiPlay.bitmap = (openBitMap "$ui\Icons\AT_ats_play.bmp")
			stopAnimation()
			saveItemSel()
			if maxfilepath != "" then(
				fileName = filterString maxfilename "."
				sTime = filterString (getinisetting (maxfilepath+fileName[1]+"_AT.ini") "AniTimes" (item as string)) "-()/"
				if sTime[2] != undefined do(
					startT = sTime[2]as integer
					endT = sTime[3]as integer
					animationRange = interval startT endT
				)
			)else(messagebox "请先保存场景或打开一个场景！" beep:false title:"AniTimes")
		)
	on uiReload pressed do
	(
			reload()
			if maxfilepath != "" then(
				fileN = filterString maxfilename "."
				itemSeled = getinisetting (maxfilepath+fileN[1]+"_AT.ini") "AniTimes" "itemSelected"
				if itemSeled == "" then itemSeled = 1 else itemSeled = itemSeled as integer
				if aniLise_ddl.items.count > 0 then(
					if itemSeled <= aniLise_ddl.items.count then () else (itemSeled = aniLise_ddl.items.count
						aniLise_ddl.selection = itemSeled)
					Name_edt.text = aniLise_ddl.items[itemSeled]
				)
			)else(messagebox "请先保存场景或打开一个场景!" beep:false title:"AniTimes")
		)
	on uiPlay changed state do
	(
		if state then
		(
			uiplay.text=c
			playAnimation()
		)
		else
		(
		    stopAnimation()
			
			uiplay.text=d
			
		)		
	)
	on uiPlay rightClick do
	(
			popupMenu SpeedCusmenu
		)
	on uiAddtime pressed do
	(
			uiAddLock = (getINISetting "$scripts\custom_prefs.ini" "atsInterface" "AddLock")
			if uiAddLock == "0" then(
				if maxfilepath != "" then(
					if Name_edt.text != "" then(
					cbxItem = aniLise_ddl.items
					selItem = aniLise_ddl.selection
					
					frameC = filterString Name_edt.text "-( )/"
					if frameC[2] != undefined then(
						startTmp = frameC[2]
						endTmp = frameC[3]
					)else(
						startTmp = animationRange.start as string
						endTmp = animationRange.end as string
					)
					nameSTmp = filterString Name_edt.text "-"
					insertItem (nameSTmp[1]+"-("+startTmp+"/"+endTmp+")") cbxItem (selItem+1)
					aniLise_ddl.items = cbxItem
					aniLise_ddl.selection = (selItem+1)
					saveItems()
					Name_edt.text = aniLise_ddl.selected
					)else(messagebox "请输入动作名称，自定帧范围请输入:（名称-0 10）帧数间用空格分开" beep:false title:"AniTimes")
				)else(messagebox "请先保存场景或打开一个场景!" beep:false title:"AniTimes")
			)
		)
	on uiAddtime rightClick do
	(
			uiMinMax = (getINISetting "$scripts\custom_prefs.ini" "atsInterface" "uiMinMax")
			uiAddLock = getINISetting "$scripts\custom_prefs.ini" "atsInterface" "AddLock"
			if uiAddLock != "1" then(
				uiAddtime.text =g
				setINISetting "$scripts\custom_prefs.ini" "atsInterface" "AddLock" "1"
				setINISetting "$scripts\custom_prefs.ini" "atsInterface" "AddLockD" "1"
			)else(
			if uiMinMax == "false" do(
				uiAddtime.text=f
				setINISetting "$scripts\custom_prefs.ini" "atsInterface" "AddLock" "0"
				setINISetting "$scripts\custom_prefs.ini" "atsInterface" "AddLockD" "0"
			))
		)
	on uiDeltime pressed do
	(
			uiDelLock = (getINISetting "$scripts\custom_prefs.ini" "atsInterface" "DelLock")
			if uiDelLock == "0" then(
			if maxfilepath != "" then(
				if aniLise_ddl.selection != 0 then(
					fileName = filterString maxfilename "."
					cbxItem = aniLise_ddl.items
					deleteitem cbxItem aniLise_ddl.selection
					aniLise_ddl.items = cbxItem
					itemCount = (getinisetting (maxfilepath+fileName[1]+"_AT.ini") "AniTimes" "itemsCount") as integer
					for i in 1 to itemCount do(
						delinisetting (maxfilepath+fileName[1]+"_AT.ini") "AniTimes" (i as string)
					)
					saveItems()
				)
			))
		)
	on uiDeltime rightClick do
	(
			uiMinMax = (getINISetting "$scripts\custom_prefs.ini" "atsInterface" "uiMinMax")
			uiDelLock = getINISetting "$scripts\custom_prefs.ini" "atsInterface" "DelLock"
			if uiDelLock != "1" then(
				uiDeltime.text=g
				setINISetting "$scripts\custom_prefs.ini" "atsInterface" "DelLock" "1"
				setINISetting "$scripts\custom_prefs.ini" "atsInterface" "DelLockD" "1"
			)else(
			if uiMinMax == "false" do(
				uiDeltime.text=h
				setINISetting "$scripts\custom_prefs.ini" "atsInterface" "DelLock" "0"
				setINISetting "$scripts\custom_prefs.ini" "atsInterface" "DelLockD" "0"
			))
		)
	on uiEdittime pressed do
	(
			EditATS()
		)
	on uiEdittime rightClick do
	(
			uiMinMax = (getINISetting "$scripts\custom_prefs.ini" "atsInterface" "uiMinMax")
			uiEditLock = getINISetting "$scripts\custom_prefs.ini" "atsInterface" "EditLock"
			if uiEditLock != "1" then(
				uiEdittime.text=g
				setINISetting "$scripts\custom_prefs.ini" "atsInterface" "EditLock" "1"
				setINISetting "$scripts\custom_prefs.ini" "atsInterface" "EditLockD" "1"
			)else(
			if uiMinMax == "false" do(
				uiEdittime.text=i
				setINISetting "$scripts\custom_prefs.ini" "atsInterface" "EditLock" "0"
				setINISetting "$scripts\custom_prefs.ini" "atsInterface" "EditLockD" "0"
			))
		)
	on uiSave pressed do
	(
				dllItemTmp = saveAll_ddl.items
			if (finditem dllItemTmp Name_edt.text) < 1 and findstring Name_edt.text "-" == undefined and Name_edt.text != "" and aniLise_ddl.items[1] != undefined then(
				mo = querybox "确定将现有的时间记录新建保存模板！" title:"新建模板"
				if mo == true then(
					allAniTmp = aniLise_ddl.items[1]
					for i in 2 to aniLise_ddl.items.count do(
						allAniTmp = allAniTmp+"@"+aniLise_ddl.items[i]
					)
					append dllItemTmp Name_edt.text
					saveAll_ddl.items = dllItemTmp
					saveAll_ddl.selection = saveAll_ddl.items.count
					setinisetting "$scripts\oox_saveAniTimeTmp.ini" "AniSave" (Name_edt.text as string) (allAniTmp as string)
					setinisetting "$scripts\oox_saveAniTimeTmp.ini" "AniSave" (saveAll_ddl.items.count as string) (Name_edt.text as string)
					setinisetting "$scripts\oox_saveAniTimeTmp.ini" "AniSave" "saveAllDllcount" (saveAll_ddl.items.count as string)
				)
			)else(messagebox "在上方输入要新建的模板名称，不能与原有模板重名，\n不能带有\"-\"字符，时间栏里最少要有一个记录！" title:"新建模板")
			saveAllItemCount = getinisetting "$scripts\oox_saveAniTimeTmp.ini" "AniSave" "saveAllDllcount" as integer
			
		)
	on uiLoad pressed do
	(
			if saveAll_ddl.selected != undefined then(
				mo = querybox ("确定读取模板：\""+saveAll_ddl.selected+"\" 替换当前所有的时间记录！") title:"读取模板"
				if mo == true then(
					moItemTmp = filterString (getinisetting "$scripts\oox_saveAniTimeTmp.ini" "AniSave" saveAll_ddl.selected) "@"
					aniLise_ddl.items = moItemTmp
					saveItems()
				)
			)
		)
	on uiEdit pressed do
	(
			saveAllItemCount = getinisetting "$scripts\oox_saveAniTimeTmp.ini" "AniSave" "saveAllDllcount" as integer
			if saveAllItemCount>0 then(
			if saveAll_ddl.selected != undefined and aniLise_ddl.items[1] != undefined then(
				mo=querybox ("确定将现有的时间记录替换掉模板：\""+saveAll_ddl.selected+"\"！") title:"替换模板"
				if mo == true then(
					allAniTmp = aniLise_ddl.items[1]
					for i in 2 to aniLise_ddl.items.count do(
						allAniTmp = allAniTmp+"@"+aniLise_ddl.items[i]
					)
					setinisetting "$scripts\oox_saveAniTimeTmp.ini" "AniSave" saveAll_ddl.selected (allAniTmp as string)
				)
			)else(messagebox "选择模板进行编辑\n时间记录不能是空的！" title:"编辑模板")
			)
		)
	on uiDel pressed do
	(
			if saveAll_ddl.selected != undefined then(
				mo = querybox ("确定要删除模板：\""+saveAll_ddl.selected+"\"！") title:"删除模板"
				if mo == true then(
					dllItemTmp = saveAll_ddl.items
					delinisetting "$scripts\oox_saveAniTimeTmp.ini" "AniSave" saveAll_ddl.selected
					for i in 1 to dllItemTmp.count do(
						delinisetting "$scripts\oox_saveAniTimeTmp.ini" "AniSave" (i as string)
					)
					deleteitem dllItemTmp saveAll_ddl.selection
					saveAll_ddl.items = dllItemTmp
					saveAll_ddl.selection = saveAll_ddl.items.count
					for i in 1 to dllItemTmp.count do(
						setinisetting "$scripts\oox_saveAniTimeTmp.ini" "AniSave" (i as string) (dllItemTmp[i] as string)
					)
					setinisetting "$scripts\oox_saveAniTimeTmp.ini" "AniSave" "saveAllDllcount" (dllItemTmp.count as string)
				)
			)
			saveAllItemCount = getinisetting "$scripts\oox_saveAniTimeTmp.ini" "AniSave" "saveAllDllcount" as integer
			if saveAllItemCount>0 then(
			
			)else(
				
			)
		)
)
---------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------


rollout rendrollout1 "The skin tool panel" width:183 height:230
(
	GroupBox grp14 "权重分配" pos:[6,6] width:166 height:220
	button btn2 "0.1" pos:[14,25] width:26 height:18
	button btn3 "0.2" pos:[46,25] width:26 height:18
	button btn4 "0.3" pos:[77,25] width:26 height:18
	button btn5 "0.4" pos:[108,25] width:26 height:18
	button btn6 "0.5" pos:[139,25] width:26 height:18
	button btn7 "0.6" pos:[14,49] width:26 height:18
	button btn8 "0.7" pos:[46,49] width:26 height:18
	button btn9 "0.8" pos:[77,49] width:26 height:18
	button btn10 "0.9" pos:[108,49] width:26 height:18
	button btn11 "1.0" pos:[139,49] width:26 height:18
	button btn12 "0.05" pos:[14,72] width:26 height:18
	button btn13 "0.15" pos:[46,72] width:26 height:18
	button btn14 "0.25" pos:[77,72] width:26 height:18
	button btn15 "0.35" pos:[108,72] width:26 height:18
	button btn16 "0.45" pos:[139,72] width:26 height:18
	button btn17 "0.55" pos:[14,96] width:26 height:18
	button btn18 "0.65" pos:[46,96] width:26 height:18
	button btn19 "0.75" pos:[77,96] width:26 height:18
	button btn20 "0.85" pos:[108,96] width:26 height:18
	button btn21 "0.95" pos:[139,96] width:26 height:18
	button btn22 "0" pos:[14,123] width:34 height:16
	button btn23 "移除零权重" pos:[14,143] width:151 height:22
	spinner spn6 "" pos:[53,123] width:62 height:16 range:[0,1,0]
	button btn142 "确定" pos:[121,123] width:45 height:16
	button btn166 "收缩" pos:[14,175] width:70 height:20
	button btn167 "扩大" pos:[95,175] width:70 height:20
	button btn168 "环形" pos:[14,201] width:70 height:20
	button btn169 "循环" pos:[95,201] width:70 height:20
	button Clo_btn "x" pos:[170,0] width:15 height:15 toolTip:"关闭"
				on rendrollout1 lbuttondblclk g11 do
	(
		DestroyDialog rendrollout1
		)
	on rendrollout1 lbuttonup pos1 do 
		mousedd1=false
	on rendrollout1 lbuttondown pos1 do
		(
		mousedd1=true
		Thepos1=pos1
			)
	on rendrollout1 mousemove pos1 do
	(	if mousedd1==true Then 
		(SetDialogPos rendrollout1 (mouse.screenpos-Thepos1))
		
		)

	on rendrollout open do
	(
	
		)
	on btn2 pressed do
		(		animate off   		try			(		skinOps.setWeight $.modifiers[#Skin] 0.1		)			catch			(				)
	)
	on btn3 pressed do
		(      animate off  		try  		(  		skinOps.setWeight $.modifiers[#Skin] 0.2   		)  			catch  		(  				)
	)
	on btn4 pressed do
		(      animate off  		try  		(  		skinOps.setWeight $.modifiers[#Skin] 0.3   		)  			catch  		(  		)
	)
	on btn5 pressed do
		(      animate off  		try  		(  		skinOps.setWeight $.modifiers[#Skin] 0.4   		)  			catch  		(  	 		)
	)
	on btn6 pressed do
		(      animate off  		try  		(  		skinOps.setWeight $.modifiers[#Skin] 0.5   		)  			catch  		(  	 		)
	)
	on btn7 pressed do
		(      animate off  		try  		(  		skinOps.setWeight $.modifiers[#Skin] 0.6   		)  			catch  		(  				)
	)
	on btn8 pressed do
		(      animate off  		try  		(  		skinOps.setWeight $.modifiers[#Skin] 0.7   		)  			catch  		(  				)
	)
	on btn9 pressed do
		(      animate off  		try  		(  		skinOps.setWeight $.modifiers[#Skin] 0.8   		)  			catch  		(  			)
	)
	on btn10 pressed do
		(      animate off  		try  		(  		skinOps.setWeight $.modifiers[#Skin] 0.9   		)  			catch  		(  			)
	)
	on btn11 pressed do
		(      animate off  		try  		(  		skinOps.setWeight $.modifiers[#Skin] 1.0   		)  			catch  		(  		)
	)
	on btn12 pressed do
		(      animate off  		try  		(  		skinOps.setWeight $.modifiers[#Skin] 0.05   		)  			catch  		(  	  		)
	)
	on btn13 pressed do
		(      animate off  		try  		(  		skinOps.setWeight $.modifiers[#Skin] 0.15   		)  			catch  		(  			)
	)
	on btn14 pressed do
		(      animate off  		try  		(  		skinOps.setWeight $.modifiers[#Skin] 0.25   		)  			catch  		(  				)
	)
	on btn15 pressed do
		(      animate off  		try  		(  		skinOps.setWeight $.modifiers[#Skin] 0.35   		)  			catch  		(  			)
	)
	on btn16 pressed do
		(      animate off  		try  		(  		skinOps.setWeight $.modifiers[#Skin] 0.45   		)  			catch  		(  				)
	)
	on btn17 pressed do
		(      animate off  		try  		(  		skinOps.setWeight $.modifiers[#Skin] 0.55   		)  			catch  		(  			)
	)
	on btn18 pressed do
		(      animate off  		try  		(  		skinOps.setWeight $.modifiers[#Skin] 0.65   		)  			catch  		(  	 		)
	)
	on btn19 pressed do
		(      animate off  		try  		(  		skinOps.setWeight $.modifiers[#Skin] 0.75   		)  			catch  		(  			)
	)
	on btn20 pressed do
		(      animate off  		try  		(  		skinOps.setWeight $.modifiers[#Skin] 0.85   		)  			catch  		(  			)
	)
	on btn21 pressed do
		(      animate off  		try  		(  		skinOps.setWeight $.modifiers[#Skin] 0.95   		)  			catch  		(  			)
	)
	on btn22 pressed do
		(      animate off  		try  		(  		skinOps.setWeight $.modifiers[#Skin] 0   		)  			catch  		(  		)
	)
	on btn23 pressed do
		(      animate off  		try  		(  		skinOps.RemoveZeroWeights $.modifiers[#Skin]   		)  			catch  		(  		)
	)
	on btn142 pressed do
		(      animate off  		try  		(  		skinOps.setWeight $.modifiers[#Skin] (spn6.value)   		)  			catch  		(  			)
	)
	on btn166 pressed do
		(      animate off  		try  		(  		skinOps.shrinkSelection $.modifiers[#Skin]   		)  			catch  		(  		 		)
	)
	on btn167 pressed do
		(      animate off  		try  		(  		skinOps.growSelection $.modifiers[#Skin]  		)  			catch  		(  			)
	)
	on btn168 pressed do
		(      animate off  		try  		(  		skinOps.loopSelection $.modifiers[#Skin]  		)  			catch  		(  		)
	)
	on btn169 pressed do
		(      animate off  		try  		(  		skinOps.ringSelection $.modifiers[#Skin]  		)  			catch  		(  			)
	)
	on Clo_btn pressed do
	(
		destroydialog rendrollout1
		)

)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- 暴力帧拷贝粘贴脚本
-- By 吇鱼 (cgwayne.com)
-- v 1.19
-- Created On: 01/20/2016
-- Modified On: 03/09/2016
-- tested using Max 2012
------------------------------------------------------------------------------

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

rollout cptools name_lag   width:200 height:210
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
		on cptools lbuttondblclk g11 do
	(
		DestroyDialog cptools
		)
	on cptools lbuttonup pos1 do 
		mousedd1=false
	on cptools lbuttondown pos1 do
		(
		mousedd1=true
		Thepos1=pos1
			)
	on cptools mousemove pos1 do
	(	if mousedd1==true Then 
		(SetDialogPos cptools (mouse.screenpos-Thepos1))
		
		)

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
createdialog cptools   bgcolor:(color 50 50 50)  fgcolor:(color 50 255 255)  style:#( #style_minimizebox) pos:postest
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
createdialog cptools   bgcolor:(color 50 50 50)  fgcolor:(color 50 255 255)  style:#( #style_minimizebox) pos:postest
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
------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
vposCA = attributes vipos
(
	parameters main 
	(
	 	vpos 		type:#point3Tab tabSizeVariable:true animatable:false
	)	

)

sprboneCA = attributes sprbTM
(
	parameters main
	(
		boneTM	type:#matrix3
	)	

)

tool movevertex
(



)
rollout splineAnime "Spring Magic V0.9" width:210 height:310
(
	spinner delaysp "Spring" type:#float scale:0.05 range:[0.01,1,0.3] align:#left height:20 width:60
	spinner loops "Loops" type:#integer range:[0,100,0] align:#right height:20 width:50 offset:[5,-25] 
	spinner subs "Subs" type:#integer range:[0,10,0] align:#left height:20 width:60
	spinner upspring "XSpring" type:#float scale:0.05 range:[0.1,1,0.3] align:#right height:20 width:70 offset:[5,-25] 
	spinner bnum "Bones num" type:#integer range:[0,1000,20] align:#left height:20 width:60

	group "Spline Pose"
	(
	button resetspRp "Paste" toolTip:"Select spline" align:#left height:20 width:50
	button setspRp "Set" toolTip:"Select spline" align:#left height:20 width:50 offset:[55,-25] 
	)
	group "Bone Pose"
	(
	button resetRp "Paste" toolTip:"Select first bone" align:#left height:20 width:50
	button setRp "Set" toolTip:"Select first bone" align:#left height:20 width:50 offset:[55,-25] 
	button stretch "straight" align:#left height:20 width:50 offset:[110,-25] 
	)
	group "KeyRange"
	(
	radiobuttons a1 labels:#("Active", "Custom") align:#left width:80 height:20 --offset:[0,20]
	spinner aframestart type:#integer align:#left width:40 height:20 range:[-10000,100000,1] --offset:[105,-10] 
	spinner aframend "To" type:#integer align:#left width:50 height:20 offset:[45,-25] range:[0,100000,10]

	)

	group "Apply"
	(
	button applyline "Spline" toolTip:"Select spline" align:#left height:20 width:40
	button applybone "Bone" toolTip:"Select first bone" align:#left height:20 width:40 offset:[45,-25] 
	--checkbutton realt "Realtime" align:#left height:20 width:60 offset:[90,-25] 
	)
			on splineAnime lbuttondblclk g11 do
	(
		DestroyDialog splineAnime
		)
on splineAnime lbuttonup pos1 do 
		mousedd1=false
	on splineAnime lbuttondown pos1 do
		(
		mousedd1=true
		Thepos1=pos1
			)
	on splineAnime mousemove pos1 do
	(	if mousedd1==true Then 
		(SetDialogPos splineAnime (mouse.screenpos-Thepos1))
		
		)

	on resetspRp pressed do (

		if selection.count == 0 do return root
		for shapes in selection do (
			if not isShapeObject shapes do return root
			if not isProperty shapes "vpos" do return root
			if shapes.parent == undefined do ( messageBox (((shapes.name as string)+" has no parent!")) ; continue)
			local num = 1
			print shapes as string
			for  i in 1 to (numSplines shapes) do (
				for j in 1 to (numKnots shapes i) do (
					local vertexctrl = getPointController shapes i ((j*3)-1)
					print vertexctrl as string
					deleteKeys vertexctrl #allKeys
					if shapes.vpos[num] != undefined do (
						 
						addnewkey vertexctrl slidertime
						vertexctrl.keys[1].value = shapes.vpos[num]*(shapes.parent.transform)*(inverse shapes.transform)-shapes.objectOffsetPos
						setKnotPoint shapes i j (shapes.vpos[num]*shapes.parent.transform-shapes.objectOffsetPos)
						--updateShape shapes
						--deleteKeys vertexctrl #allKeys
					)
					num += 1
				)
			)
		updateShape shapes
		)
	)

	on setspRp pressed do (
	if selection.count == 0 do return root
	for shapes in selection do (	
		if not isShapeObject shapes do continue
		if shapes.parent == undefined do ( messageBox (((shapes.name as string)+" has no parent!")) ; continue)
		if not isProperty shapes "vpos" then custAttributes.add shapes vposCA
		num = 1
		vertnum = 2
		for i in 1 to (numSplines shapes) do (	
			vn = 2	
			for j in 1 to (numKnots shapes i) do (
				animateVertex shapes vertnum			
				shapes.vpos[num] = (getKnotPoint shapes i j)*(inverse shapes.parent.transform)
				num += 1
				vn += 3
				vertnum +=3
			)
		)----end for i 
	)----end for shapes

	)

	on applyline pressed do (
	if selection.count == 0 do return root
	
	local setvpos = false
	local framestart,framend
	if a1.state == 1 then (
		framestart = animationRange.start
		framend = animationRange.end
	) else (
		framestart = aframestart.value as time
		framend = aframend.value as time
	)
	for shapes in selection do (	
		if not isShapeObject shapes do continue
		if shapes.parent == undefined do ( messageBox (((shapes.name as string)+" has no parent!")) ; continue)
		if not isProperty shapes "vpos" then
			(custAttributes.add shapes vposCA;setvpos=true)

		local delay = delaysp.value
		slidertime = framestart

		local pTM = shapes.parent.transform
		local shape_vertex_pos= #()
		local shape_vertex_TM= #()
		local preTimevertex_TM= #()
		local shape_splinenum = numSplines shapes
		dum = #()
		num = 1
		for i in 1 to shape_splinenum do (
			vertpos = #()
			vertTM = #()
			temp_TM = #()
			for j in 1 to (numKnots shapes i) do (
				append temp_TM  (matrix3 pTM.row1 pTM.row2 pTM.row3 (getKnotPoint shapes i j))
				if setvpos then (
				
					--append vertpos ((getKnotPoint shapes i j)*(inverse shapes.parent.transform))
					append vertpos (getKnotPoint shapes i j)
					append vertTM (matrix3 pTM.row1 pTM.row2 pTM.row3 ((getKnotPoint shapes i j)*(inverse shapes.parent.transform)) )
					shapes.vpos[num] = (getKnotPoint shapes i j)*(inverse shapes.parent.transform)
					num += 1
				)
				else (
					append vertpos (shapes.vpos[num]*shapes.parent.transform)
					append vertTM (matrix3 pTM.row1 pTM.row2 pTM.row3 (shapes.vpos[num]*shapes.parent.transform))
					--append vertpos (getKnotPoint shapes i j)
					--append vertTM (matrix3 pTM.row1 pTM.row2 pTM.row3 (getKnotPoint shapes i j))
					--dum[j] = dummy transform:(matrix3 pTM.row1 pTM.row2 pTM.row3 (getKnotPoint shapes i j))
					--dum[j].parent = chooseit.object
					--shapes.vpos[num] = getKnotPoint shapes i j
					num += 1
				)	
			)
			append shape_vertex_pos vertpos
			append shape_vertex_TM vertTM
			append preTimevertex_TM temp_TM
		)
		--preTimevertex_TM = deepcopy shape_vertex_TM

		-----create vertex controller and delete all keys
		vertexctrl = #()
		vertnum = 2
		for i in 1 to shape_splinenum do (
			vctrl = #()
			vn = 2
			for j in 1 to (numKnots shapes i) do (				
				animateVertex shapes vertnum
				vertctrl = getPointController shapes i vn

				--if numKeys vertctrl >0 then deleteKeys vertctrl #allKeys 
				/*
				for t = animationRange.start to animationRange.end do (
					index = getKeyIndex vertctrl t
					deleteKey vertctrl index
				)
				*/
				selectKeys vertctrl (interval framestart framend)
				deleteKeys vertctrl #selection
				append vctrl vertctrl
				vn += 3
				vertnum +=3
			--	execute ("shapes.Spline_"+(i as string)+"___Vertex_"+(j as string)+".controller=a")
			)
			append vertexctrl vctrl
		)
		
		--------start to calculate

		preTimeTM = pTM
		subframe = 1.0/(subs.value+1)
		for L = 0 to loops.value do (

		for t = framestart to framend by subframe do (
			if keyboard.escPressed then exit
			tf = ceil (t as float/TicksPerFrame)
			slidertime = tf
					
			for  i in 1 to shape_splinenum do (
				currentPTM = shapes.parent.transform
				
				--Point transform:currentPTM axistripod:on size:6.0 name:"aacurrentPTM"	
				vTM = pTM
				for j in 1 to (numKnots shapes i) do (
					vertTM = matrix3 vTM.row1 vTM.row2 vTM.row3 shape_vertex_pos[i][j]
					targetvertTM = vertTM*(inverse vTM)*currentPTM
					currentvertTM = preTimevertex_TM[i][j]
					tvector = normalize (targetvertTM.row4 - currentPTM.row4)
					cvector = normalize (currentvertTM.row4 - currentPTM.row4)
					v1 = normalize (cross cvector tvector)
					angel = acos(dot (normalize cvector) (normalize tvector))
					if j > 1 then angel = angel*(1.0-delay)
					else angel = 0

					aacurrentPTM = copy currentPTM
					transPTM = rotate currentPTM (quat angel v1) 
					transPTM.pos = currentPTM.pos = aacurrentPTM.pos
					transvertTM = vertTM*(inverse vTM)*transPTM
	
					if L == loops.value then (
						addnewkey vertexctrl[i][j] tf
						vertexctrl[i][j].keys[vertexctrl[i][j].keys.count].value = (transvertTM*(inverse shapes.transform)).position-shapes.objectOffsetPos
					)
					else
						--setKnotPoint shapes i j (transvertTM*(inverse shapes.transform)).position
						setKnotPoint shapes i j transvertTM.position
						
					if j<=(numKnots shapes i) do (
						vTM = matrix3 pTM.row1 pTM.row2 pTM.row3 shape_vertex_pos[i][j]
						currentPTM = transvertTM
						preTimevertex_TM[i][j] = transvertTM
						
					)
				)	
			)----end for i
			updateShape shapes
		)----end for t
		)----end for Loops
	)-----end for spobj
	completeRedraw()
	)-----end on 


	on applybone pressed do with undo on (
		
	local bones=#()
	if selection.count == 0 do return root
	local framestart,framend
	if a1.state == 1 then (
		framestart = animationRange.start
		framend = animationRange.end
	) else (
		framestart = aframestart.value as time
		framend = aframend.value as time
	)

	local bone_TM = #()
	local preTimebone_TM = #()
	bonectrl_x = #()
	bonectrl_y = #()
	bonectrl_z = #()
	bipctrl = #()
	posctrller = #()
	scaletrller = #()
	delay = delaysp.value

	for bone in selection do (
		local bonechain = #()
		local bonetype = classof bone
		local num = 1
		slidertime = framestart
		if superClassOf bone == shape do continue --or (bonetype != BoneGeometry and bonetype != Biped_Object) do continue
		if bone.parent == undefined do ( messageBox (((bone.name as string)+"must have parent!")) ; continue)

		local parnode = bone.parent
		while bone!=undefined do (
			bonechain[num] = bone
			childfind = false
			if bone.children.count == 0 or num>bnum.value then exit
			else (
				for c in bone.children do
					if  classof c == bonetype or classof c == Dummy then (bone = c;num += 1 ;childfind = true;exit)
					else continue
				if childfind == false do bone = undefined
			)
		)----end while
		--print bonechain as string
		append bones bonechain

		local pTM = parnode.transform
		local preTM = #()
		local bTM = #()

		for j in 1 to bonechain.count do (
		--	preTimebone_TM[j] = bonechain[j].transform
			append preTM bonechain[j].transform
			if not isProperty bonechain[j] "boneTM" then (
				CustAttributes.add bonechain[j] sprboneCA
				bonechain[j].boneTM = bonechain[j].transform*(inverse bonechain[j].parent.transform)
			)
			append bTM bonechain[j].boneTM
		)
		append preTimebone_TM preTM
		append bone_TM bTM
		
		-----get bone rotate controller and delete keys
		bipc = #()
		
		if bonetype == Biped_Object do (
			for j in 1 to bonechain.count do 	
				append bipc bonechain[j].controller
		 	append bipctrl bipc		
		)


	)----end for bone
	
	if bones.count ==0 do return root

-----------------------start to calculate---------------

		subframe = 1.0/(subs.value+1)
		for L = 0 to loops.value do (
		
		for t = framestart to framend by subframe do (
			if keyboard.escPressed then exit
			tf = ceil (t as float/TicksPerFrame)
			slidertime = tf
		
		for i in 1 to bones.count do (
			currentPTM = at time (t as float/TicksPerFrame) bones[i][1].parent.transform
			
			for j in 1 to (bones[i].count-1) do (
			
				targetboneTM = bone_TM[i][j]*currentPTM
				currentboneTM = preTimebone_TM[i][j]
				currentboneTM.pos  = preTimebone_TM[i][j+1].pos

				----------Roll spring-------------
				ang1 = acos(dot (normalize preTimebone_TM[i][j].row1) (normalize targetboneTM[1]))
				newTM = copy preTimebone_TM[i][j]
				newTM1 = copy preTimebone_TM[i][j]
				tpos = targetboneTM.pos
				vt1 = normalize (cross preTimebone_TM[i][j].row1 targetboneTM[1])
					
				if abs ang1 >0.001 do rotate newTM1 (quat ang1 -vt1) 
			
				newTM.pos = tpos
				newTM1.pos = tpos

				angY1 = acos(dot (normalize newTM1[2]) (normalize targetboneTM[2]))	
				ssvt = cross (normalize newTM1[2]) (normalize targetboneTM[2])

				xaxisdelay = (upspring.value + ((bones[i].count-1.0-j)/(bones[i].count-1.0)*(1.0-upspring.value)) )
				angY1 = angY1 * xaxisdelay
				if dot ssvt targetboneTM[1] >0 do angY1 = -angY1
				if abs angY1 >0.001 do rotate newTM1 (quat angY1 targetboneTM[1]) 
				newTM1.pos = tpos
				targetboneTM = copy newTM1

				---------------------------------------				
				tvector = normalize targetboneTM[1]
				cvector = normalize (currentboneTM.pos - targetboneTM.pos)
				vt = normalize (cross cvector tvector)
				angel = acos(dot (normalize cvector) (normalize tvector))

				--if j < 5 do angel = subFrameCheck j bones bonetype bone_TM preTimebone_TM (t-1f) angel vt
				
				angel = angel*(1.0-delay)
				
				aacurrentPTM = copy targetboneTM
				transPTM = rotate targetboneTM (quat angel vt) 
				transPTM.pos = targetboneTM.pos = aacurrentPTM.pos
				
				animate on
				(
					if classof bones[i][j] == Biped_Object then 
						biped.setTransform bones[i][j] #rotation transPTM.rotation true
					else if classof bones[i][j] == CATBone then
						bones[i][j].transform = copy transPTM
					else bones[i][j].rotation.controller.value = transPTM.rotation *(inverse currentPTM.rotation)
					
					if L == loops.value then
						if classof bones[i][j] == Biped_Object and mod (t as float/TicksPerFrame) 1 == 0 do
							biped.setTransform bones[i][j] #rotation transPTM.rotation true

				)-----end animate on


				currentPTM = preTimebone_TM[i][j] = transPTM

				if j == (bones[i].count-1) do (
				preTimebone_TM[i][j+1].pos =  bone_TM[i][j+1].pos*transPTM
				--bonelength = length bone_TM[i][j+1].pos
				--preTimebone_TM[i][j+1].pos =  transPTM.pos + ((normalize transPTM[1])*bonelength)		
				)

			)-----end for j	
		)----end for bones
		)----end for t
		)----end for Loops

	)
	on resetRp pressed do (

--	if selection.count == 0 do return root

	for bone in selection do (
		local bonetype = classof bone
		if superClassOf bone == shape do continue
		--if bonetype != Biped_Object do return root
		if bone.parent == undefined do return root
		local bones=#()
		local num = 1
		while bone!=undefined do (
			bones[num] = bone
			childfind = false
			if bone.children.count == 0 then exit
			else (
				for c in bone.children do
					if  classof c == bonetype or classof c == Dummy then (bone = c;num += 1 ;childfind = true;exit)
					else continue
				if childfind == false do bone = undefined
			)
		)----end while
		
		for b in bones do 
			if isProperty b "boneTM" do (
				animate on
				(
					if classof b == CATBone then (
						--posctrller = copy b.position.controller
						--scaletrller = copy b.scale.controller
						b.transform = b.boneTM*b.parent.transform
						--b.position.controller = posctrller
						--b.scale.controller = scaletrller
					) else if classof b == Biped_Object then biped.setTransform b #rotation (b.boneTM*b.parent.transform).rotation true
					else b.rotation.controller.value = b.boneTM.rotation
				)
			)
	)----end for bone
	)

	on setRp pressed do (
	
	for bone in selection do (

		local bonetype = classof bone
		if superClassOf bone == shape do continue
		--if bonetype != BoneGeometry and bonetype != Biped_Object do return root
		if bone.parent == undefined do return root
		local bones=#()
		local num = 1
		while bone.children.count > 0 do (
			
			for c in bone.children do 
				if  classof c == bonetype or classof c == Dummy then (
					if num == 1 then append bones bone
					append bones c
					bone = c
					num +=1
					exit
				)	else continue
		)

		for b in bones do (
			if not isProperty b "boneTM" then CustAttributes.add b sprboneCA
				b.boneTM = b.transform*(inverse b.parent.transform)
		)
		
	)
	
	)
	on stretch pressed do with undo on (
		
	for bone in selection do (
		if bone.children.count == 0 do return root
		bone = bone.children[1]
		bonetype = classof bone
		if superClassOf bone == shape do continue
		--if bonetype != BoneGeometry and bonetype != Biped_Object do return root
		if bone.parent == undefined do return root
		local bones=#()
		local num = 1
		while bone!=undefined do (
			bones[num] = bone
			childfind = false
			if bone.children.count == 0 then exit
			else (
				for c in bone.children do
					if  classof c == bonetype or classof c == Dummy then (bone = c;num += 1 ;childfind = true;exit)
					else continue
				if childfind == false do bone = undefined
			)
		)----end while
		for b in bones do (
			if bonetype == Biped_Object then 
				biped.setTransform b #rotation b.parent.transform.rotation true
			else (
				c = copy b.parent.transform
				c.pos = b.transform.position
				b.transform = c
			)
		)
	)---end for bone
	)
	
	on realt changed state do with undo on (
	if state == true then startTool movevertex prompt:"Hello!"
	else stopTool movevertex

	)
	on splineAnime open do (
		aframestart.value = animationRange.start
		aframend.value = animationRange.end
	)
)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------
try(destroyDialog rol_copyPasteAni;)
catch()

--		物体姿势信息结构定义：物体名称，父物体名称，物体类型，世界坐标信息，相对父物体的位移，相对父物体的旋转，相对父物体的缩放。
struct 	objPoseInfo (nameIs,parentName,bipObj,trans,localPos,localRotation,localScale);
--		物体动画信息结构定义。
struct 	objAnimInfo (nameIs,classIs,bipParent,localTransform,subAnimName,subVisibility,subSpaceWarps,subTransform,subObject,subMaterial,subImage,subMotion);
--		子动画信息结构定义。
struct 	subAnimInfo (subName,ctrlClass,propName,propValue,keyTime,keyInfo);
--		关键帧信息结构定义。
struct 	subKeysInfo (k_propName,k_propValue);

rollout rol_copyPasteAni "复制|粘帖 动画|POSE" width:200 height:130
(
	---		脚本名称。
	local 	CopyPasteAni_Name = "CopyPasteAni";
	--		脚本版本。
	local 	CopyPasteAni_Version = "1.00";
	--		脚本内部序号。
	local 	CopyPasteAni_ID = "In-Company";
	--		脚本创建信息。
	local 	CopyPasteAni_BuildInfo = "3dsMax 8. 2008-3-3, at Company.";
	--		Script Data Folder
	local 	CopyPasteAni_FilePath = (GetDir #maxRoot) + "Coo!ToolsData\\AnimatorTools\\" + CopyPasteAni_Name + "\\";
	--		脚本配置文件。
	local 	CopyPasteAniIni_name = CopyPasteAni_FilePath + CopyPasteAni_Name + ".ini";
	--	
	local 	rol = rol_copyPasteAni;
	--		
	local 	history_str = "";
	--		已复制的POSE。
	local 	copyedPose_ary = #();
	--		已复制的动画。
	local 	copyedAnim_ary = #();
	
	/*创建按钮图标的遮罩。*/
	Function fn_invertMaskBitmap bitmapFileName_str bk_color =
	(
		try
		(
			local i_bitmap = openBitMap bitmapFileName_str;
			local invertBitmap = bitmap i_bitmap.width i_bitmap.height;
			
			for y in 0 to (i_bitmap.height - 1) do
			(
				for x in 0 to (i_bitmap.width - 1) do
				(
					local i_color = (getPixels i_bitmap [x,y] 1)[1];
					
					i_color = color (i_color.r as integer) (i_color.g as integer) (i_color.b as integer);
					if i_color == bk_color then setPixels invertBitmap [x,y] #(white);
					else setPixels invertBitmap [x,y] #(BLACK);
				)
			)
			return invertBitmap;
		)
		catch()
	)
	
	/*从图片中获取图标。*/
	Function fn_getIconFromBitmap bitmap_str bitmapIconCount_int getIconIndex_int filter_col=
	(
		try
		(
			local icon;
			local bmp = openBitMap bitmap_str;
			
			icon = bitmap (bmp.width / bitmapIconCount_int) bmp.height color:white;
			for y in 0 to bmp.height - 1 do
			(
				local temp = getPixels bmp [(getIconIndex_int * icon.width) - icon.width,y] icon.width;
				for n in 1 to temp.count do
				(
					local i_color = color (temp[n].r as integer) (temp[n].g as integer) (temp[n].b as integer);
					if i_color == filter_col do temp[n] = white;
				)
				setPixels icon [0,y] temp;
			)
			return icon;
		)
		catch()
	)
	
	/*显示按钮图标。*/
	Function fn_ctrlBitmap =
	(
		try
		(
			local bmp,mask;
			local icon_bmp,mask_bmp;
			--	建立 数据文件夹。
			if not(doesFileExist CopyPasteAni_FilePath) do
			(
			--	DOSCommand ("md " + CopyPasteAni_FilePath);
			)
			if not(doesFileExist CopyPasteAni_FilePath) do
			(
				local newDir_ary = filterString CopyPasteAni_FilePath "\\";
				local newDir_str = newDir_ary[1];
				
				for n in 2 to newDir_ary.count do
				(
					newDir_str = newDir_str + "\\" + newDir_ary[n];
					if not(doesFileExist newDir_str) do makeDir newDir_str;
				)
			)
			if not(doesFileExist CopyPasteAni_FilePath) do (messageBox ("创建文件夹失败：\n" + CopyPasteAni_FilePath + "\n需要手动创建该文件夹。") title:"Make Dir";)
			--	建立 INI文件。
			if not(doesFileExist CopyPasteAniIni_name) do
			(
				local iniFile = createFile CopyPasteAniIni_name;
				format "[SaveHistory]\n" to:iniFile;
				format "History=\"\"\n" to:iniFile;
				close iniFile;
			)
			--	建立按钮图标。
			if not(doesFileExist (CopyPasteAni_FilePath + "CopyPasteAni_Icon.bmp")) do
			(
				local bmp_str = "";
				local icon_ary = #();
				
				if doesFileExist ((GetDir #ui) + "\\Icons\\bip_copycol_i.bmp") do
				(
					local index_bAry = #{1..6,9,10,13..16};
					bmp_str = (GetDir #ui) + "\\Icons\\bip_copycol_i.bmp";
					for n in index_bAry do append icon_ary (fn_getIconFromBitmap bmp_str 16 n (color 191 191 191));
				)
				if doesFileExist ((GetDir #ui) + "\\Icons\\bip_mflscript_i.bmp") do
				(
					local index_bAry = #{13..16};
					bmp_str = (GetDir #ui) + "\\Icons\\bip_mflscript_i.bmp";
					for n in index_bAry do append icon_ary (fn_getIconFromBitmap bmp_str 22 n (color 191 191 191));
				)
				if doesFileExist ((GetDir #ui) + "\\Icons\\bip_comtrack_i.bmp") do
				(
					local index_bAry = #{7..12};
					bmp_str = (GetDir #ui) + "\\Icons\\bip_comtrack_i.bmp";
					for n in index_bAry do append icon_ary (fn_getIconFromBitmap bmp_str 12 n (color 191 191 191));
				)
				if doesFileExist ((GetDir #ui) + "\\Icons\\ReactionManager_i.bmp") do
				(
					local index_bAry = #{5,16};
					bmp_str = (GetDir #ui) + "\\Icons\\ReactionManager_i.bmp";
					for n in index_bAry do append icon_ary (fn_getIconFromBitmap bmp_str 22 n (color 197 197 197));
				)
				if doesFileExist ((GetDir #ui) + "\\Icons\\Classic_16i.bmp") do
				(
					local index_bAry = #{21..26};
					bmp_str = (GetDir #ui) + "\\Icons\\Classic_16i.bmp";
					for n in index_bAry do append icon_ary (fn_getIconFromBitmap bmp_str 78 n (color 192 192 192));
				)
				if doesFileExist ((GetDir #ui) + "\\Icons\\MeditImages_i.bmp") do
				(
					local index_bAry = #{33,34};
					bmp_str = (GetDir #ui) + "\\Icons\\MeditImages_i.bmp";
					for n in index_bAry do append icon_ary (fn_getIconFromBitmap bmp_str 37 n (color 188 188 188));
				)
				
				icon_bmp = bitmap (icon_ary.count * 16) 15 fileName:(CopyPasteAni_FilePath + "CopyPasteAni_icon.bmp") color:white;
				for n in 1 to icon_ary.count do
				(
					for y in 0 to 14 do
					(
						local offset_x = 0;
						local offset_y = 0;
						local temp = getPixels icon_ary[n] [0,y] icon_ary[n].width;
						if icon_ary[n].width < 16 do offset_x = (16 - icon_ary[n].width) / 2;
						if icon_ary[n].height < 15 do offset_y = (15 - icon_ary[n].height) / 2;
						setPixels icon_bmp [((n - 1) *16 + offset_x),(y + offset_y)] temp;
					)
				)
				save icon_bmp;
			)
			
			if doesFileExist (CopyPasteAni_FilePath + "CopyPasteAni_Icon.bmp") do
			(
				local icon_bmp = openBitMap (CopyPasteAni_FilePath + "CopyPasteAni_Icon.bmp");
				local n = icon_bmp.width / 16;
				
				mask_bmp = fn_invertMaskBitmap (CopyPasteAni_FilePath + "CopyPasteAni_icon.bmp") white;
				rol.btn_new.images = #(icon_bmp,mask_bmp,n,1,1,2,2);
				rol.btn_open.images = #(icon_bmp,mask_bmp,n,3,3,4,4);
				rol.btn_save.images = #(icon_bmp,mask_bmp,n,7,7,8,8);
				rol.btn_del.images = #(icon_bmp,mask_bmp,n,9,9,10,10);
				rol.btn_delAll.images = #(icon_bmp,mask_bmp,n,11,11,12,12);
				rol.btn_copy.images = #(icon_bmp,mask_bmp,n,13,13,14,14);
				rol.btn_paste.images = #(icon_bmp,mask_bmp,n,15,15,16,16);
				rol.ckb_pasteOther.images = #(icon_bmp,mask_bmp,n,23,23,24,24);
				rol.ckb_pasteMove.images = #(icon_bmp,mask_bmp,n,25,25,26,26);
				rol.ckb_pasteRotate.images = #(icon_bmp,mask_bmp,n,27,27,28,28);
				rol.ckb_pasteScale.images = #(icon_bmp,mask_bmp,n,29,29,30,30);
			)
			freeSceneBitmaps();
		)
		catch()
	)
	
	/*按钮状态*/
	Function fn_ctrlState =
	(
		try
		(
			--	屏蔽所有按钮。
			for ctrl in rol.controls do ctrl.enabled = false;
			--	创建新的复制。
			rol.btn_new.enabled = true;
			--	打开存盘动画文件。
			rol.btn_open.enabled = true;
			--	保存复制的动画。
			if rol.rdo_copyType.state == 1 then rol.btn_save.enabled = (rol.ddl_listAni.items.count != 0);
			else rol.btn_save.enabled = (rol.ddl_listPose.items.count != 0);
			--	复制 动画/POSE。
			rol.btn_copy.enabled = true;
			--	粘帖 动画/POSE。
			if rol.rdo_copyType.state == 1 then rol.btn_paste.enabled = (selection.count != 0 and rol.ddl_listAni.items.count != 0);
			else rol.btn_paste.enabled = (selection.count != 0 and rol.ddl_listPose.items.count != 0);
			--	删除 当前复制的动画/POSE。
			if rol.rdo_copyType.state == 1 then rol.btn_del.enabled = (rol.ddl_listAni.items.count != 0);
			else rol.btn_del.enabled = (rol.ddl_listPose.items.count != 0);
			--	删除 所有已复制的动画/POSE。
			if rol.rdo_copyType.state == 1 then rol.btn_delAll.enabled = (rol.ddl_listAni.items.count != 0);
			else rol.btn_delAll.enabled = (rol.ddl_listPose.items.count != 0);
			--	复制所选物体的：动画 姿势。
			rol.lbl_copyType.enabled = true;
			--	复制所选物体的：动画 姿势。
			rol.rdo_copyType.enabled = true;
			--	已复制的动画。
			rol.ddl_listAni.enabled = (selection.count != 0 and rol.ddl_listAni.items.count != 0);
			if rol.rdo_copyType.state == 1 then rol.ddl_listAni.pos.y = 80;
			else rol.ddl_listAni.pos.y = -80;
			rol.ddl_listAni.items =  rol.ddl_listAni.items;
			--	已复制的姿势。
			rol.ddl_listPose.enabled = (selection.count != 0 and rol.ddl_listPose.items.count != 0);
			if rol.rdo_copyType.state == 2 then rol.ddl_listPose.pos.y = 80;
			else rol.ddl_listPose.pos.y = -80;
			rol.ddl_listPose.items =  rol.ddl_listPose.items;
			--	粘帖动画/POSE。
			if rol.rdo_copyType.state == 1 then rol.lbl_paste.enabled = (rol.ddl_listAni.items.count != 0);
			else rol.lbl_paste.enabled = (rol.ddl_listPose.items.count != 0);
			--	粘帖物体上其他的动画。
			rol.ckb_pasteOther.enabled = true
			rol.ckb_pasteMove.enabled = true
			rol.ckb_pasteRotate.enabled = true
			rol.ckb_pasteScale.enabled = true
			--if rol.rdo_copyType.state == 1 then
			(
			
			--	rol.ckb_pasteOther.enabled = (rol.ddl_listAni.items.count != 0);
			)
			--else
			(
			--	rol.ckb_pasteOther.enabled = false;
			--	rol.ckb_pasteOther.state = false;
			)
			--	仅粘帖位移动画。
			--if rol.rdo_copyType.state == 1 then
			(
			--	rol.ckb_pasteMove.enabled = (rol.ddl_listAni.items.count != 0);
			)
			--else
			(
			--	rol.ckb_pasteMove.enabled = false;
			--	rol.ckb_pasteMove.state = (rol.ddl_listPose.items.count != 0);
			)
			--	仅粘贴旋转动画。
			--if rol.rdo_copyType.state == 1 then
			(
			--	rol.ckb_pasteRotate.enabled = (rol.ddl_listAni.items.count != 0);
			)
			--else
			(
			--	rol.ckb_pasteRotate.enabled = false;
			--	rol.ckb_pasteRotate.state = (rol.ddl_listPose.items.count != 0);
			)
			--	仅粘贴缩放动画。
			--if rol.rdo_copyType.state == 1 then
			(
			--	rol.ckb_pasteScale.enabled = (rol.ddl_listAni.items.count != 0);
			)
			--else
			(
			--	if rol.ddl_listPose.items.count != 0 do
				(
			--		rol.ckb_pasteScale.enabled = true--false;
			--		rol.ckb_pasteScale.state = (rol.ddl_listPose.items.count != 0)
					--rol.ckb_pasteScale.state = (rol.ddl_listPose.items.count != 0);

				)
			)
		)
		catch()
	)
	
	/*复制所选物体的POSE*/
	Function copyObjPose =
	(
		try
		(
			local poseSaveIni;
			--	创建帮助物体。
			local i_help = point name:"CopyAnimtedObj_helper";
			--	复制物体信息数组。
			local pose_ary = #();
			
			/*依次从当前选择的物体中收集信息。*/
			for n in 1 to selection.count do
			(
				--	初始化单个物体的信息。
				local info = objPoseInfo nameIs:selection[n].name trans:selection[n].transform;
				
				--	判断是否为BIP所属物体。
				try
				(
					info.bipObj = ((biped.getNode selection[n] #vertical link:1) != undefined);
				)
				catch
				(
					info.bipObj = false;
				)
				--	将帮助物体移动到物体相同坐标。
				try
				(
					i_help.scale = selection[n].scale;
					i_help.rotation = selection[n].rotation;
					i_help.pos = selection[n].pos;
				)
				catch(i_help.transform = selection[n].transform;)
				--	被收集物体有 父物体，收集：父物体名称，相对父物体的位移，相对父物体的旋转，相对父物体的缩放。
				if selection[n].parent != undefined then
				(
					info.parentName 	= selection[n].parent.name;
					info.localPos 		= in coordsys selection[n].parent i_help.pos;
					info.localRotation 	= in coordsys selection[n].parent i_help.rotation;
					info.localScale 		= in coordsys selection[n].parent i_help.scale;
				)
				--	将收集好的信息添加到 复制物体信息数组 中。
				append pose_ary info;
			)
			--	收集完毕，删除帮助物体。
			delete i_help;
			return pose_ary;
		)
		catch()
	)
	
	/*粘帖所选物体的POSE*/
	Function pasteObjPose pose_ary =
	(
		try
		(
			--	创建帮助物体。
			local i_help = point name:"CopyAnimtedObj_helper";
			--	已复制POSE物体的名称数组。
			local savedObjName_ary = for info in pose_ary collect info.nameIs;
			--	按名称过滤已选择的物体 并 添加到需要粘帖POSE物体数组中。
			local pasteObj_ary = for obj in selection where findItem savedObjName_ary obj.name != 0 collect obj;
			--	盆骨和脊柱骨记录数组。
			local spines_ary = #();
			
			/*检查需要粘帖POSE物体中是否存在BIP物体，对BIP物体，取出盆骨和脊柱骨存入记录数组。。*/
			for obj in pasteObj_ary where classOf obj == Biped_Object do
			(
				for n in 1 to 4 where (biped.getNode obj #spine link:n) != undefined do
				(
					if findItem spines_ary (biped.getNode obj #spine link:n) == 0 do append spines_ary (biped.getNode obj #spine link:n);
				)
				--	添加盆骨到数组中。
				if findItem spines_ary (biped.getNode obj #pelvis link:1) == 0 do append spines_ary (biped.getNode obj #pelvis link:1);
			)
			/*将没有父物体的物体先进行处理，处理后将该物体从粘贴数组中去除。*/
			for obj in pasteObj_ary do
			(
				local n = findItem savedObjName_ary obj.name;
				
				if pose_ary[n].parentName == undefined do
				(
					obj.transform = pose_ary[n].trans;
					deleteItem pasteObj_ary (findItem pasteObj_ary obj);
				)
			)
			/*对粘帖物体数组中剩下有父物体的物体进行处理：处理时须从链接的根物体开始，*/
			while pasteObj_ary.count != 0 do
			(
				--	判断物体是否是BIP物体。
				local isBipObj_bol = false;
				--	物体记录：首先取出剩余物体中的第一个。
				local obj = pasteObj_ary[1];
				--	记录该物体的父物体。
				local parent = obj.parent;
				--	记录该物体在复制信息数组中的位置。
				local n = findItem savedObjName_ary obj.name;
				
				/*当物体的父物体存在时，向上追溯物体的根。*/
				while parent != undefined do
				(
					--	如果物体的父物体存在于 需要粘帖POSE物体数组中，改变物体记录为它的父物体。
					if findItem pasteObj_ary parent != 0 do
					(
						obj = parent;
						n = findItem savedObjName_ary obj.name;
					)
					parent = parent.parent;
				)
				--	移帮助动物体到物体复制记录的坐标。
				if parent == undefined then
				(
					i_help.transform = pose_ary[n].trans;
				)
				else
				(
					if rol.ckb_pasteScale.state == true do
					(
						in coordsys obj.parent i_help.scale = pose_ary[n].localScale;
					)
					in coordsys obj.parent i_help.rotation = pose_ary[n].localRotation;
					in coordsys obj.parent i_help.pos = pose_ary[n].localPos;
				)
				--	判断物体是否是Bip物体。
				try
				(
					isBipObj_bol = ((biped.getNode obj #vertical link:1) != undefined);
				)
				catch
				(
					isBipObj_bol = false;
				)
				--	Bip物体。
				if isBipObj_bol then
				(
					--	非盆骨和脊柱骨物体。
					if findItem spines_ary obj == 0 then
					(
						biped.setTransform obj #rotation i_help.transform.rotation false;
					)
					--	盆骨和脊柱骨物体。
					else
					(
						rotate obj -obj.transform.rotation;
						rotate obj i_help.rotation;
					)
				)
				--	一般物体。
				else
				(
					if obj.parent == undefined then
					(
						obj.transform = pose_ary[n].trans;
					)
					else
					(
						if rol.ckb_pasteScale.state == true do(
							in coordsys obj.parent obj.scale = pose_ary[n].localScale;							
						)
						in coordsys obj.parent obj.rotation = pose_ary[n].localRotation;
						in coordsys obj.parent obj.pos = pose_ary[n].localPos;
					)
				)
				--	处理后将该物体从粘贴数组中去除。
				deleteItem pasteObj_ary (findItem pasteObj_ary obj);
			)
			delete i_help;
		)
		catch()
	)
	
	/*复制所选物体的动画*/
	Function copyObjAniTracks =
	(
		try
		(
			--	收集完成的信息数组，返回值。
			local copyedInfo = #();
			--	复制动画的物体，不含Biped物体。
			local copyObj_ary = #();
			--	选择物体中 非BIPED 的物体数组。
			local notBipObj_ary = #();
			--	记录用户当前帧位置。
			local currentFrame = sliderTime;
			--	用户当前时间调设置。
			local userAnimRange = animationRange;
			
			animationRange = interval 0 animationRange.end;
			sliderTime = -1000;
			/*过滤选择的物体，排除掉BIPED物体。*/
			for obj in selection do
			(
				try	(biped.getNode obj #horizontal link:1;)
				catch(append notBipObj_ary obj;)
			)
			/*判断物体是否有动画存在，将有动画的物体存入数组copyObj_ary中，这里不能使用：<property>.isAnimated，它对顶点动画该参数无效。*/
			for obj in notBipObj_ary do
			(
				local ani_bol = false;
				local ani_ary=#();
				
				--	找出该物体所有的subAnim。
				for n in 1 to obj.numSubs do
				(
					append ani_ary obj[n];
					for sub in ani_ary do
					(
						for m in 1 to sub.numSubs do append ani_ary (getSubAnim sub m);
					)
				)
				--	检查subAnim中是否有动画。
				for sub in ani_ary do
				(
					try
					(
						if sub.isAnimated do
						(
							append copyObj_ary obj;
							exit;
						)
					)
					catch()
				)
			)
			/*对选择集中有动画的物体，逐个收集动画轨道控制器、参数设置、关键帧、关键帧参数等等......*/
			for obj in copyObj_ary do
			(
				local bipLink;
				local sub_index = #{};
				--	struct objAnimInfo (nameIs,classIs,bipParent,subAnimName,subVisibility,subSpaceWarps,subTransform,subObject,subMaterial,subImage,subMotion);
				local objInfo = objAnimInfo nameIs:obj.name classIs:(classOf obj);
				
				--	父物体是否为Biped物体，如果是，需要先断开链接。
				if obj.parent != undefined do
				(
					try
					(
						if (biped.getNode obj.parent #horizontal link:1) != undefined do bipLink = obj.parent;
					)
					catch(bipLink = undefined;)
					if bipLink != undefined then
					(
						objInfo.localTransform = #();
						objInfo.localTransform[1] = in coordsys obj.parent obj.pos;
						objInfo.localTransform[2] = in coordsys obj.parent obj.rotation;
						objInfo.localTransform[3] = in coordsys obj.parent obj.scale;
						obj.parent = undefined;
						objInfo.bipParent = true;
					)
				)
				--	收集物体上有动画的subAnimName。
				objInfo.subAnimName = #();
				for n in 1 to obj.numSubs do
				(
					local aniSub_bol = false;
					local ani_ary = #(obj[n]);
					
					--	找出该物体所有的subAnim。
					for sub in ani_ary do
					(
						for m in 1 to sub.numSubs do
						(
							append ani_ary (getSubAnim sub m);
						)
					)
					--	检查subAnim中是否有动画。
					for sub in ani_ary do
					(
						try
						(
							if sub.isAnimated do
							(
								append sub_index n;
								append objInfo.subAnimName (getSubAnimName obj n);
								case n of
								(
									1 : objInfo.subVisibility = #();
									2 : objInfo.subSpaceWarps = #();
									3 : objInfo.subTransform = #();
									4 : objInfo.subObject = #();
									5 : objInfo.subMaterial = #();
									6 : objInfo.subImage = #();
									7 : objInfo.subMotion = #();
									defaule : ();
								)
								exit;
							)
						)
						catch()
					)
				)
				--	
				for n in sub_index do
				(
					local subAnim_ary = #(obj[n]);
					local subAnimName_ary = #(("$" + obj.name + "[" + n as string + "]"));
					
					--	收集子动画。
					for sub in subAnim_ary do
					(
						local index = findItem subAnim_ary sub;
						local sub_str = subAnimName_ary[index];
						
						for m in 1 to sub.numSubs do
						(
							append subAnim_ary sub[m];
							append subAnimName_ary (sub_str + "[" + m as string + "]");
						)
					)
					--	过滤子动画。
					for sub in subAnim_ary do
					(
						local noClass_bol,noProp_bol,del_bol;
						local class_str = (classOf sub.controller) as string;
						
						--	子动画控制器类型为：undefinedClass 或 DummyClass等等。
						del_bol = (findString class_str "Class" != undefined);
						--	子动画无参数设置 或 参数为0。
						if ((getPropNames sub) != undefined and (getPropNames sub).count > 0) do del_bol = false;
						if del_bol do
						(
							while (findItem subAnim_ary sub) != 0 do
							(
								deleteItem subAnimName_ary (findItem subAnim_ary sub);
								deleteItem subAnim_ary (findItem subAnim_ary sub);
							)
						)
					)
					--	
					for m in 1 to subAnim_ary.count do
					(
						--	struct subAnimInfo (subName,ctrlClass,propName,propValue,keyTime,keyInfo);
						local subInfo = subAnimInfo subName:subAnimName_ary[m] ctrlClass:(classOf subAnim_ary[m].controller);
						
						if (getPropNames subAnim_ary[m]) != undefined and (getPropNames subAnim_ary[m]).count != 0 do
						(
							subInfo.propName = getPropNames subAnim_ary[m];
							subInfo.propValue = for name in subInfo.propName collect getProperty subAnim_ary[m] name;
						)
						if subAnim_ary[m].controller != undefined and subAnim_ary[m].controller.supportsKeys and numKeys subAnim_ary[m].controller > 0 do
						(
							subInfo.keyTime = for keys in subAnim_ary[m].keys collect keys.time;
							subInfo.keyInfo = #();
							for t in 1 to subInfo.keyTime.count do
							(
								--	struct subKeysInfo (k_propName,k_propValue);
								local subKey = subKeysInfo k_propName:#() k_propValue:#();
								
								subKey.k_propName = getPropNames subAnim_ary[m].keys[t];
								subKey.k_propValue = for name in subKey.k_propName collect (getProperty subAnim_ary[m].keys[t] name);
								append subInfo.keyInfo subKey;
							)
						)
						case n of
						(
							1 : append objInfo.subVisibility subInfo;
							2 : append objInfo.subSpaceWarps subInfo;
							3 : append objInfo.subTransform subInfo;
							4 : append objInfo.subObject subInfo;
							5 : append objInfo.subMaterial subInfo;
							6 : append objInfo.subImage subInfo;
							7 : append objInfo.subMotion subInfo;
							defaule : ();
						)
					)
				)
				append copyedInfo objInfo;
				--	还原父链接。
				if bipLink != undefined do obj.parent = bipLink;
			)
			animationRange = userAnimRange;
			sliderTime = currentFrame;
			return copyedInfo;
		)
		catch()
	)
	
	/*粘帖所选物体的动画*/
	Function pasteObjAniTracks savedObj_ary filter_ary =
	(

		try
		(
			--	存盘文件中记录的动画物体名字数组。
			local copyedObjName_ary = for objInfo in savedObj_ary collect objInfo.nameIs;
			--	存盘文件中记录的动画物体类型数组。
			local copyedObjClass_ary = for objInfo in savedObj_ary collect objInfo.classIs;
			--	需要粘帖动画的物体数组。
			local pasteObj_ary = #()
			--	需要粘帖动画的物体名称数组。
			local pasteObjInfo_ary = #();
			--	记录用户当前帧位置。
			local currentFrame = sliderTime;
			--	用户当前时间调设置。
			local userAnimRange = animationRange;
			
			animationRange = interval 0 animationRange.end;
			sliderTime = -1000;
			for obj in selection do
			(
				local n = findItem copyedObjName_ary obj.name;
				
				if n != 0 do
				(
					append pasteObj_ary obj;
					append pasteObjInfo_ary savedObj_ary[n];
				)
			)
			sliderTime = animationRange.start;
			for n in 1 to pasteObj_ary.count do
			(
				--	当前物体的复制物。
				local i_helper;
				--	当前的物体。
				local obj = pasteObj_ary[n];
				--	当前物体的复制信息。
				local objInfo = pasteObjInfo_ary[n];
				--	但却物体复制信息中的子动画名词数组。
				local pasteSubAnimName_ary = objInfo.subAnimName;
				--	物体当前的父链接。
				local currentParent;
				
				--	物体当前有父链接 并且 在复制信息中 它的父链接是biped物体：先断开链接。
				if objInfo.bipParent == true do
				(
					currentParent = obj.parent;
					obj.parent = undefined;
				)
				
				for m in 1 to obj.numsubs do
				(
					local subAnim_ary;
					local subName = getSubAnimName obj m;
					
					case m of
					(
						1 : subAnim_ary = objInfo.subVisibility;
						2 : subAnim_ary = objInfo.subSpaceWarps;
						3 : subAnim_ary = objInfo.subTransform;
						4 : subAnim_ary = objInfo.subObject;
						5 : subAnim_ary = objInfo.subMaterial;
						6 : subAnim_ary = objInfo.subImage;
						7 : subAnim_ary = objInfo.subMotion;
						default : ()
					)
					if classOf obj != copyedObjClass_ary[n] do
					(
						if m == 2 or m == 4 do subAnim_ary = undefined;
					)
					--	 参数限定：过滤非位移、旋转、放缩的动画。
					if m != 3 and filter_ary[1] == false do subAnim_ary = undefined;
					
					if subAnim_ary != undefined and findItem pasteSubAnimName_ary subName != undefined do
					(
						--	还原控制器类型和初始参数
						for w in 1 to subAnim_ary.count do
						(
							local ignore_bol = true;
							local class_str = (subAnim_ary[w].ctrlClass as string) + "()";
							local i_propName = subAnim_ary[w].propName;
							local i_propValue = subAnim_ary[w].propValue;
							local i_subName = subAnim_ary[w].subName;
							
							if m == 3 do
							(
								if filter_ary[2] == false and findString i_subName ("$" + obj.name + "[3][1]") != undefined do ignore_bol = false;
								if filter_ary[3] == false and findString i_subName ("$" + obj.name + "[3][2]") != undefined do ignore_bol = false;
								if filter_ary[4] == false and findString i_subName ("$" + obj.name + "[3][3]") != undefined do ignore_bol = false;
							)
							
							--	还原控制器类型。
							if findString class_str "Class" == undefined do
							(
								try	(if ignore_bol do execute (subAnim_ary[w].subName + ".controller = " + class_str);)
								catch()
							)
							--	还原控制器参数。
							if i_propName != undefined and i_propValue != undefined do
							(
								for v in 1 to i_propName.count do
								(
									local i_sub = execute subAnim_ary[w].subName;
									
									try	(if ignore_bol do setProperty i_sub i_propName[v] i_propValue[v];)
									catch()
								)
							)
						)
						
						--	通过i_helper帮助物体重整当前物体的Controller。
						i_helper = copy obj;
						i_helper.name = "AnimCtrlRepObj";
						for sub in subAnim_ary do
						(
							try
							(
								local ctrl = execute (sub.subName + ".controller");
								local indexs = replace sub.subName 1 (obj.name.count + 1) "";
								
								if ctrl != undefined do
								(
									execute (sub.subName + ".controller = copy ($AnimCtrlRepObj" +  indexs + ".controller)");
								)
							)
							catch()
						)
						delete i_helper;
						--	控制器上关键帧的设置
						for w in 1 to subAnim_ary.count where subAnim_ary[w].keyTime != undefined and subAnim_ary[w].keyInfo != undefined do
						(
							local ignore_bol = true;
							local i_sub = execute subAnim_ary[w].subName;
							local i_time = subAnim_ary[w].keytime;
							local i_keyInfo = subAnim_ary[w].keyInfo;
							local i_subName = subAnim_ary[w].subName;
							
							if m == 3 do
							(
								if filter_ary[2] == false and findString i_subName ("$" + obj.name + "[3][1]") != undefined do ignore_bol = false;
								if filter_ary[3] == false and findString i_subName ("$" + obj.name + "[3][2]") != undefined do ignore_bol = false;
								if filter_ary[4] == false and findString i_subName ("$" + obj.name + "[3][3]") != undefined do ignore_bol = false;
							)
							if ignore_bol do
							(
								try
								(
									--	删除现在的关键帧。
									deleteKeys i_sub.controller #allKeys;
									for t in 1 to i_time.count do
									(
										local p_name = i_keyInfo[t].k_propName;
										local p_value = i_keyInfo[t].k_propValue;
										
										--	还原关键帧的时间位置。
										addNewKey i_sub.controller i_time[t];
										--	还原关键帧参数。
										if findItem p_name "#x_locked" != 0 do setProperty i_sub.keys[t] #x_locked false;
										if findItem p_name "#y_locked" != 0 do setProperty i_sub.keys[t] #y_locked false;
										if findItem p_name "#z_locked" != 0 do setProperty i_sub.keys[t] #z_locked false;
										for x in 1 to p_name.count do
										(
											try
											(
												setProperty i_sub.keys[t] p_name[x] p_value[x];
											)
											catch()
										)
									)
								)
								catch()
							)
						)
					)
				)
				--	还原父链接。
				if currentParent != undefined do 
				(
					obj.Parent = currentParent;
					in coordsys obj.parent obj.scale = objInfo.localTransform[3];
					in coordsys obj.parent obj.rotation = objInfo.localTransform[2];
					in coordsys obj.parent obj.pos = objInfo.localTransform[1];
				)
			)
			animationRange = userAnimRange;
			sliderTime = currentFrame;
		)
		catch()
	)
	
	/*保存复制信息到文件*/
	Function saveObjPose file_str =
	(
		try
		(
			local i_file,file_txt;
			
			/*保存姿势信息到文件中。*/
			file_txt = "[ObjectPoseCopy]\n";
			file_txt += "Count=" + copyedPose_ary.count as string + "\n\n";
			for n in 1 to copyedPose_ary.count do
			(
				file_txt += "[CopyPose_" + n as string + "]\n";
				file_txt += "Name=" + rol.ddl_listPose.items[n] + "\n";
				file_txt += "Count=" + copyedPose_ary[n].count as string + "\n";
				for m in 1 to copyedPose_ary[n].count do
				(
					file_txt += "[CopyPose_" + n as string + "_" + m as string + "]\n";
					file_txt += "nameIs=\"" + copyedPose_ary[n][m].nameIs + "\"\n";
					if copyedPose_ary[n][m].parentName != undefined do file_txt += "parentName=\"" + copyedPose_ary[n][m].parentName + "\"\n";
					file_txt += "bipObj=" + copyedPose_ary[n][m].bipObj as string + "\n";
					file_txt += "Trans=" + copyedPose_ary[n][m].Trans as string + "\n";
					if copyedPose_ary[n][m].localPos != undefined do file_txt += "localPos=" + copyedPose_ary[n][m].localPos as string + "\n";
					if copyedPose_ary[n][m].localRotation != undefined do file_txt += "localRotation=" + copyedPose_ary[n][m].localRotation as string + "\n";
					if copyedPose_ary[n][m].localScale != undefined do file_txt += "localScale=" + copyedPose_ary[n][m].localScale as string + "\n";
				)
			)
			file_txt += "-----------------------\n\n";
			/*保存动画信息到文件中。*/
			file_txt += "[ObjectAnimCopy]\n";
			file_txt += "Count=" + copyedAnim_ary.count as string + "\n\n";
			for n in 1 to copyedAnim_ary.count do
			(
				file_txt += "[CopyAnim_" + n as string + "]\n";
				file_txt += "Name=" + rol.ddl_listAni.items[n] + "\n";
				file_txt += "Count=" + copyedAnim_ary[n].count as string + "\n";
				for m in 1 to copyedAnim_ary[n].count do
				(
					local i_struct;
					
					--	struct objAnimInfo (nameIs,classIs,bipParent,subAnimName,subVisibility,subSpaceWarps,subTransform,subObject,subMaterial,subImage,subMotion);
					file_txt += "[CopyAnim_" + n as string + "_" + m as string + "]\n";
					--	nameIs
					file_txt += "nameIs=\"" + copyedAnim_ary[n][m].nameIs + "\"\n";
					--	classIs
					file_txt += "classIs=" + copyedAnim_ary[n][m].classIs as string + "\n";
					--	bipParent
					file_txt += "bipParent=" + copyedAnim_ary[n][m].bipParent as string  + "\n";
					--	subAnimName
					file_txt += "subAnimName=" + copyedAnim_ary[n][m].subAnimName as string + "\n";
					
					for name in copyedAnim_ary[n][m].subAnimName do
					(
						local index = findItem (getSubAnimNames (execute ("$" + copyedAnim_ary[n][m].nameIs))) name;
						
						--	subVisibility,subSpaceWarps,subTransform,subObject,subMaterial,subImage,subMotion
						case index of
						(
							1 : i_struct = copyedAnim_ary[n][m].subVisibility;
							2 : i_struct = copyedAnim_ary[n][m].subSpaceWarps;
							3 : i_struct = copyedAnim_ary[n][m].subTransform;
							4 : i_struct = copyedAnim_ary[n][m].subObject;
							5 : i_struct = copyedAnim_ary[n][m].subMaterial;
							6 : i_struct = copyedAnim_ary[n][m].subImage;
							7 : i_struct = copyedAnim_ary[n][m].subMotion;
							default : ()
						)
						if i_struct != undefined do
						(
							file_txt += "[CopyAnim_" + n as string + "_" + m as string + "_" + index as string + "]\n";
							file_txt += "Count=" + i_struct.count as string + "\n";
							for w in 1 to i_struct.count do
							(
								file_txt += "[CopyAnim_" + n as string + "_" + m as string + "_" + index as string + "_" + w as string + "]\n";
								--	subAnimInfo (subName,ctrlClass,propName,propValue,keyTime,keyInfo);
								file_txt += "subName=\"" + i_struct[w].subName as string + "\"\n";
								file_txt += "ctrlClass=" + i_struct[w].ctrlClass as string + "\n";
								if  i_struct[w].propName != undefined do
								(
									file_txt += "propName=" + i_struct[w].propName as string + "\n";
								)
								if i_struct[w].propValue != undefined do
								(
									file_txt += "propValue=" + i_struct[w].propValue as string + "\n";
								)
								if i_struct[w].keyTime != undefined do
								(
									file_txt += "keyTime=" + i_struct[w].keyTime as string + "\n";
								)
								if i_struct[w].keyInfo != undefined do
								(
									for t in 1 to i_struct[w].keyInfo.count do
									(
										file_txt += "k_propName_" + t as string + "=" + i_struct[w].keyInfo[t].k_propName as string + "\n";
										file_txt += "k_propValue_" + t as string + "=" + i_struct[w].keyInfo[t].k_propValue as string + "\n";
									)
								)
							)
						)
					)/*
					--	subVisibility
					if copyedAnim_ary[n][m].subVisibility != undefined do
					(
						file_txt += "[CopyAnim_" + n as string + "_" + m as string + "_1]\n";
						file_txt += "Count=" + copyedAnim_ary[n][m].subVisibility.count as string + "\n";
					)
					--	subSpaceWarps
					file_txt += "subSpaceWarps=" + copyedAnim_ary[n][m].subSpaceWarps as string + "\n";
					--	subTransform
					if copyedAnim_ary[n][m].subTransform != undefined do
					(
						file_txt += "[CopyAnim_" + n as string + "_" + m as string + "_3]\n";
						file_txt += "Count=" + copyedAnim_ary[n][m].subTransform.count as string + "\n";
						for w in 1 to copyedAnim_ary[n][m].subTransform.count do
						(
							file_txt += "[CopyAnim_" + n as string + "_" + m as string + "_3_" + w as string + "]\n";
							--	subAnimInfo (subName,ctrlClass,propName,propValue,keyTime,keyInfo);
							file_txt += "subName=\"" + copyedAnim_ary[n][m].subTransform[w].subName as string + "\"\n";
							file_txt += "ctrlClass=" + copyedAnim_ary[n][m].subTransform[w].ctrlClass as string + "\n";
							if  copyedAnim_ary[n][m].subTransform[w].propName != undefined do
							(
								file_txt += "propName=" + copyedAnim_ary[n][m].subTransform[w].propName as string + "\n";
							)
							if copyedAnim_ary[n][m].subTransform[w].propValue != undefined do
							(
								file_txt += "propValue=" + copyedAnim_ary[n][m].subTransform[w].propValue as string + "\n";
							)
							if copyedAnim_ary[n][m].subTransform[w].keyTime != undefined do
							(
								file_txt += "keyTime=" + copyedAnim_ary[n][m].subTransform[w].keyTime as string + "\n";
							)
							if copyedAnim_ary[n][m].subTransform[w].keyInfo != undefined do
							(
								for t in 1 to copyedAnim_ary[n][m].subTransform[w].keyInfo.count do
								(
									file_txt += "k_propName_" + t as string + "=" + copyedAnim_ary[n][m].subTransform[w].keyInfo[t].k_propName as string + "\n";
									file_txt += "k_propValue_" + t as string + "=" + copyedAnim_ary[n][m].subTransform[w].keyInfo[t].k_propValue as string + "\n";
								)
							)
						)
					)
					--	subObject
					file_txt += "subObject=" + copyedAnim_ary[n][m].subObject as string + "\n";
					--	subMaterial
					file_txt += "subMaterial=" + copyedAnim_ary[n][m].subMaterial as string + "\n";
					--	subImage
					file_txt += "subImage=" + copyedAnim_ary[n][m].subImage as string + "\n";
					--	subMotion
					file_txt += "subMotion=" + copyedAnim_ary[n][m].subMotion as string + "\n";*/
				)
				file_txt += "\n";
			)
			/*写文件*/
			if doesFileExist file_str then i_file = openFile file_str mode:"w";
			else i_file = createFile file_str;
			format file_txt to:i_file;
			close i_file;
			return true;
		)
		catch()
	)
	
	/*读取文件*/
	Function loadSavedFile file_str =
	(
		try
		(
			local count;
			
			/*读取姿势信息*/
			count = (getINISetting file_str "ObjectPoseCopy" "Count") as integer;
			if count > 0 do
			(
				rol.ddl_listPose.items = #();
				copyedPose_ary = #();
			)
			for n in 1 to count do
			(
				local info_ary = #();
				local i_name = getINISetting file_str ("CopyPose_" + n as string) "Name";
				local i_count = execute (getINISetting file_str ("CopyPose_" + n as string) "Count");
				
				if i_count > 0 do
				(
					for m in 1 to i_count do
					(
						local i_getString = "";
						--	struct objPoseInfo (nameIs,parentName,bipObj,trans,localPos,localRotation,localScale);
						local i_PoseInfo = objPoseInfo nameIs:"";
						
						i_PoseInfo.nameIs = getINISetting file_str ("CopyPose_" + n as string + "_" + m as string) "nameIs";
						i_PoseInfo.parentName = getINISetting file_str ("CopyPose_" + n as string + "_" + m as string) "parentName";
						i_PoseInfo.bipObj = execute (getINISetting file_str ("CopyPose_" + n as string + "_" + m as string) "bipObj");
						i_PoseInfo.trans = execute (getINISetting file_str ("CopyPose_" + n as string + "_" + m as string) "trans");
						
						i_getString = getINISetting file_str ("CopyPose_" + n as string + "_" + m as string) "localPos";
						if i_getString != undefined and i_getString != OK and i_getString.count > 0 do i_PoseInfo.localPos = execute i_getString;
						
						i_getString = getINISetting file_str ("CopyPose_" + n as string + "_" + m as string) "localRotation";
						if i_getString != undefined and i_getString != OK and i_getString.count > 0 do i_PoseInfo.localRotation = execute i_getString;
						
						i_getString = getINISetting file_str ("CopyPose_" + n as string + "_" + m as string) "localScale"
						if i_getString != undefined and i_getString != OK and i_getString.count > 0 do i_PoseInfo.localScale = execute i_getString;
						
						append info_ary i_PoseInfo;
					)
				)
				
				append rol.ddl_listPose.items i_name;
				append copyedPose_ary info_ary;
			)
			count = 0;
			/*读取动画信息*/
			count = (getINISetting file_str "ObjectAnimCopy" "Count") as integer;
			if count > 0 do
			(
				rol.ddl_listAni.items = #();
				copyedAnim_ary = #();
			)
			for n in 1 to count do
			(
				local info_ary = #();
				local i_name = getINISetting file_str ("CopyAnim_" + n as string) "Name";
				local i_count = execute (getINISetting file_str ("CopyAnim_" + n as string) "count");
				
				for m in 1 to i_count do
				(
					--	struct objAnimInfo (nameIs,classIs,bipParent,subAnimName,subVisibility,subSpaceWarps,subTransform,subObject,subMaterial,subImage,subMotion);
					local i_info = objAnimInfo nameIs:"";
					
					i_info.nameIs = getINISetting file_str ("CopyAnim_" + n as string + "_" + m as string) "nameIs";
					i_info.classIs = execute (getINISetting file_str ("CopyAnim_" + n as string + "_" + m as string) "classIs");
					i_info.bipParent = execute (getINISetting file_str ("CopyAnim_" + n as string + "_" + m as string) "bipParent");
					i_info.subAnimName = execute (getINISetting file_str ("CopyAnim_" + n as string + "_" + m as string) "subAnimName");
					
					for w in 1 to 7 do
					(
						local subInfo_count = (getINISetting file_str ("CopyAnim_" + n as string + "_" + m as string + "_" + w as string) "Count") as integer;
						
						if subInfo_count != undefined do
						(
							case w of
							(
								1 : i_info.subVisibility = #();
								2 : i_info.subSpaceWarps = #();
								3 : i_info.subTransform = #();
								4 : i_info.subObject = #();
								5 : i_info.subMaterial = #();
								6 : i_info.subImage = #();
								7 : i_info.subMotion = #();
								default : ()
							)
							for s in 1 to subInfo_count do
							(
								local i_getString = "";
								--	struct subAnimInfo (subName,ctrlClass,propName,propValue,keyTime,keyInfo);
								local i_subInfo = subAnimInfo subName:"";
								
								i_subInfo.subName = getINISetting file_str ("CopyAnim_" + n as string + "_" + m as string + "_" + w as string + "_" + s as string) "subName";
								i_subInfo.ctrlClass = execute (getINISetting file_str ("CopyAnim_" + n as string + "_" + m as string + "_" + w as string + "_" + s as string) "ctrlClass");
								
								i_getString = getINISetting file_str ("CopyAnim_" + n as string + "_" + m as string + "_" + w as string + "_" + s as string) "propName";
								if i_getString != undefined and i_getString != OK and i_getString.count > 0 do i_subInfo.propName = execute i_getString;
								
								i_getString = getINISetting file_str ("CopyAnim_" + n as string + "_" + m as string + "_" + w as string + "_" + s as string) "propValue";
								if i_getString != undefined and i_getString != OK and i_getString.count > 0 do i_subInfo.propValue = execute i_getString;
								
								i_getString = getINISetting file_str ("CopyAnim_" + n as string + "_" + m as string + "_" + w as string + "_" + s as string) "keyTime";
								if i_getString != undefined and i_getString != OK and i_getString.count > 0 do i_subInfo.keyTime = execute i_getString;
								
								if i_subInfo.keyTime != undefined do
								(
									i_subInfo.keyInfo = #();
									for t in 1 to i_subInfo.keyTime.count do
									(
										--	struct subKeysInfo (k_propName,k_propValue);
										local i_subKey = subKeysInfo k_propName:undefined;
										
										i_getString = getINISetting file_str ("CopyAnim_" + n as string + "_" + m as string + "_" + w as string + "_" + s as string) ("k_propName_" + t as string);
										if i_getString != undefined and i_getString != OK and i_getString.count > 0 do i_subKey.k_propName = execute i_getString;
										
										i_getString = getINISetting file_str ("CopyAnim_" + n as string + "_" + m as string + "_" + w as string + "_" + s as string) ("k_propValue_" + t as string);
										if i_getString != undefined and i_getString != OK and i_getString.count > 0 do i_subKey.k_propValue = execute i_getString;
										append i_subInfo.keyInfo i_subKey;
									)
								)
								case w of
								(
									1 : append i_info.subVisibility i_subInfo;
									2 : append i_info.subSpaceWarps i_subInfo;
									3 : append i_info.subTransform i_subInfo;
									4 : append i_info.subObject i_subInfo;
									5 : append i_info.subMaterial i_subInfo;
									6 : append i_info.subImage i_subInfo;
									7 : append i_info.subMotion i_subInfo;
									default : ()
								)
							)
						)
					)
					
					append info_ary i_info;
				)
				
				append rol.ddl_listAni.items i_name;
				append copyedAnim_ary info_ary;
			)
			fn_ctrlState();
		)
		catch()
	)
	
	/*	注销函数：注销变量，还原设置。	*/
	Function fn_CopyPasteAniUndefined =
	(
		try
		(
			objPoseInfo = undefined;
			objAnimInfo = undefined;
			subAnimInfo = undefined;
			subKeysInfo = undefined;
			close CopyPasteAni_ini;
			rol_copyPasteAni = undefined;
		)
		catch()
	)
	
	button 		btn_new "N" pos:[8,8] width:23 height:23 tooltip:"创建新的复制"
	button 		btn_open "O" pos:[31,8] width:23 height:23 tooltip:"打开存盘动画文件"
	button 		btn_save "S" pos:[54,8] width:23 height:23 tooltip:"保存复制的动画"
	button 		btn_copy "C" pos:[88,8] width:23 height:23 tooltip:"复制 动画/POSE"
	button 		btn_paste "P" pos:[111,8] width:23 height:23 tooltip:"粘帖 动画/POSE"
	button 		btn_del "D" pos:[146,8] width:23 height:23 tooltip:"删除 当前复制的动画/POSE"
	button 		btn_delAll "D+" pos:[169,8] width:23 height:23 tooltip:"删除 所有已复制的动画/POSE"
	label 		lbl_copyType "复制所选物体的:" pos:[8,40] width:88 height:20
	radioButtons 	rdo_copyType "" pos:[100,40] width:88 height:20 labels:#("动画", "姿势") default:2 columns:2
	dropDownList 	ddl_listAni "已复制的动画：（非CS物体）" pos:[8,64] width:186 height:41 items:#()
	dropDownList 	ddl_listPose "已复制的姿势：" pos:[8,-64] width:186 height:41 items:#()
	label 		lbl_paste "动画粘帖过滤:" pos:[8,110] width:120 height:16
	checkButton 	ckb_pasteOther "A" pos:[96,106] width:20 height:20 tooltip:"粘帖物体上其他的动画"
	checkButton 	ckb_pasteMove "M" pos:[124,106] width:20 height:20 checked:true tooltip:"仅粘帖位移动画"
	checkButton 	ckb_pasteRotate "R" pos:[148,106] width:20 height:20 checked:true tooltip:"仅粘贴旋转动画"
	checkButton 	ckb_pasteScale "S" pos:[172,106] width:20 height:20 checked:true tooltip:"仅粘贴缩放动画"
			on rol_copyPasteAni lbuttondblclk g11 do
	(
		DestroyDialog rol_copyPasteAni
		)
	on rol_copyPasteAni lbuttonup pos1 do 
		mousedd1=false
	on rol_copyPasteAni lbuttondown pos1 do
		(
		mousedd1=true
		Thepos1=pos1
			)
	on rol_copyPasteAni mousemove pos1 do
	(	if mousedd1==true Then 
		(SetDialogPos rol_copyPasteAni (mouse.screenpos-Thepos1))
		
		)
	-------------------------------------
	on rol_copyPasteAni open do
	(
		fn_ctrlBitmap();
		fn_ctrlState();
		history_str = getINISetting CopyPasteAniIni_name "SaveHistory" "History";
	)
	on rol_copyPasteAni close do
	(
		fn_CopyPasteAniUndefined();
	)
	on btn_new pressed do
	(
		copyedAnim_ary = #();
		copyedPose_ary = #();
		ddl_listAni.items = #();
		ddl_listPose.items = #();
		fn_ctrlState();
	)
	on btn_open pressed do
	(
		local openfile_str;
		
		openfile_str = getOpenFileName caption:"Open File" filename:history_str types:"Pose&Animation Copy File(*.pac)|*.pac|All|*.*|";
		if openfile_str != undefined and doesFileExist openfile_str do
		(
			loadSavedFile openfile_str;
		)
	)
	on btn_save pressed do
	(
		local saveFile_str;
		
		saveFile_str = getSaveFileName caption:"Save File" filename:history_str types:"Pose&Animation Copy File(*.pac)|*.pac|All|*.*|";
		if saveFile_str != undefined and saveFile_str.count != 0 do
		(
			saveObjPose saveFile_str;
			setINISetting CopyPasteAniIni_name "SaveHistory" "History" saveFile_str;
		)
	)
	on btn_copy pressed do
	(
		local item_str = "";
		
		if rdo_copyType.state == 1 then
		(
			local copyedAnim = copyObjAniTracks();
			
			if copyedAnim.count != 0 do
			(
				if copyedAnim.count == 1 then item_str = copyedAnim[1].nameIs;
				else item_str = copyedAnim[copyedAnim.count].nameIs + " → " + copyedAnim[1].nameIs;
				insertItem copyedAnim copyedAnim_ary 1;
				insertItem ("Anim_" + copyedAnim_ary.count as string + ":" + item_str) ddl_listAni.items 1;
				ddl_listAni.selection = 1;
			)
		)
		else
		(
			local copyedPose = copyObjPose();
			
			if copyedPose.count != 0 do
			(
				if copyedPose.count == 1 then item_str = copyedPose[1].nameIs;
				else item_str = copyedPose[copyedPose.count].nameIs + " → " + copyedPose[1].nameIs;
				insertItem copyedPose copyedPose_ary 1;
				insertItem ("Pose_" + copyedPose_ary.count as string + ":" + item_str) ddl_listPose.items 1;
				ddl_listPose.selection = 1;
			)
		)
		fn_ctrlState();
	)
	on btn_paste pressed do
	(
		undo on
		(
			if rdo_copyType.state == 1 then
			(
				pasteObjAniTracks copyedAnim_ary[ddl_listAni.selection] #(ckb_pasteOther.state,ckb_pasteMove.state,ckb_pasteRotate.state,ckb_pasteScale.state);
				pasteObjAniTracks copyedAnim_ary[ddl_listAni.selection] #(ckb_pasteOther.state,ckb_pasteMove.state,ckb_pasteRotate.state,ckb_pasteScale.state);
			)
			else
			(
				pasteObjPose copyedPose_ary[ddl_listPose.selection];
			)
		)
	)
	on btn_del pressed do
	(
		if rdo_copyType.state == 1 then
		(
			deleteItem copyedAnim_ary ddl_listAni.selection;
			deleteItem ddl_listAni.items ddl_listAni.selection;
			if ddl_listAni.selection == 0 do ddl_listAni.selection = ddl_listAni.items.count;
		)
		else
		(
			deleteItem copyedPose_ary ddl_listPose.selection;
			deleteItem ddl_listPose.items ddl_listPose.selection;
			if ddl_listPose.selection == 0 do ddl_listPose.selection = ddl_listPose.items.count;
		)
		fn_ctrlState();
	)
	on btn_delAll pressed do
	(
		if rdo_copyType.state == 1 then
		(
			copyedAnim_ary = #();
			ddl_listAni.items = #();
		)
		else
		(
			copyedPose_ary = #();
			ddl_listPose.items = #();
		)
		fn_ctrlState();
	)
	on rdo_copyType changed state do
	(
		fn_ctrlState();
	)
)
--------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------


---------------------------------------------------------------------骨骼镜像
--定义节点收集器
  global b1 =#() 
  global b2=#()
 fn gt_9_b1_count =
 (
 if (getCurrentSelection()).count  >0 then 
 (
  gt_bonename =#()
 for i in  (getCurrentSelection()) do 
 (
    append gt_bonename i.name
 ) 
 gt_bonename = sort gt_bonename

 for i in gt_bonename do 
 (
  if getNodeByName i != undefined then 
  (
   temp = getNodeByName i
   append b1 temp
   
  )else
  ( 
   messagebox "选择的节点删除。请从新选择。"
   return false 
  )
  
 )---end for i in gt_bonename do 

 )---end if (getCurrentSelection()).count  >0 then 
)---end gt_9_b1_count 

  
fn gt_2_b2_count =
(
 if (getCurrentSelection()).count  >0 then 
 (
  gt_bonename =#()
 for i in  (getCurrentSelection()) do 
 (
    append gt_bonename i.name
 ) 
 gt_bonename = sort gt_bonename
 for i in gt_bonename do 
 (
  if getNodeByName i != undefined then 
  (
   temp = getNodeByName i
   append b2 temp  
  )else
  (
   messagebox "选择的节点删除。请从新选择。"
   return false 
  )
 
 )---end for i in gt_bonename do 

 )---end if (getCurrentSelection()).count  >0 then 
 )---end gt_2_b2_count 

 ---定义储存节点信息收集器
 global v1=#(),v2=#(),v3=#(),v3_1=#(),v4=#(),v4_1=#(),fan_v1=#(),fan_v2=#(),fan_v3=#(),fan_v3_1=#(),fan_v4=#(),fan_v4_1=#(),v5=#(),y_bone=#()
 global fan_y_bone =#()
 fn gt_9_misscount =
 (
	 if b1.count != b2.count then 
		 (
		  messagebox "对称节点数不一样，操作失败。" title:"盖天编写" 
		  return false 
		 )
v1=#()  
v2=#()   
v3=#()  
v3_1=#() 
v4=#()   
v4_1=#() 
fan_v1=#()
fan_v2=#()
fan_v3=#()
fan_v3_1=#()
fan_v4=#()
fan_v4_1=#()
v5=#()
y_bone =#()
fan_y_bone =#()
		 
 for i in 1 to b1.count do
 (
  if  (try (classof  b1[i][3][2][1].controller!=bezier_float)catch( true))or 
      (try (classof  b2[i][3][2][1].controller!=bezier_float)catch( true))
  then 
	  (
	   messagebox "收集的所以骨骼有控制器不为标准控制器，请改成标准控制器（缺省控制器）。" title:"盖天编写"
	   return false 
	  )
 )----end for 		 
		 
	 for i in 1 to b1.count do
 (
  
  ---x 轴的操作。
  if (b1[i][3][2][1].controller.value +\
   b2[i][3][2][1].controller.value) <=181 and
   (b1[i][3][2][1].controller.value +\
   b2[i][3][2][1].controller.value) >=179
  then
   ( 
    append v3    ("$"+"'"+b1[i].name+"'"+"[3][2][1].controller.value")
    append fan_v3    ("$"+"'"+b2[i].name+"'"+"[3][2][1].controller.value")
    
   )----end if 180 的数组
   
  if (b1[i][3][2][1].controller.value +\
   b2[i][3][2][1].controller.value) <=-179 and 
   (b1[i][3][2][1].controller.value +\
   b2[i][3][2][1].controller.value) >=-181
  then
   ( 
    append v3_1    ("$"+"'"+b1[i].name+"'"+"[3][2][1].controller.value")
    append fan_v3_1    ("$"+"'"+b2[i].name+"'"+"[3][2][1].controller.value")
    
   )----end if 180 的数组
      
   if  (b1[i][3][2][1].controller.value )<1 and 
     (b2[i][3][2][1].controller.value)>-1
   then 
   ( 
    
    append v1   ("$"+"'"+b1[i].name+"'"+"[3][2][1].controller.value")
    append fan_v1   ("$"+"'"+b2[i].name+"'"+"[3][2][1].controller.value")
    
    
   )else                                                       
   ( 
    x_b1 =(b1[i][3][2][1].controller.value ) 
    x_b2 =(b2[i][3][2][1].controller.value ) 
    if (x_b1+x_b2)<=1 and (x_b1+x_b2)>=-1
    then
    (
     append  v1  ("$"+"'"+b1[i].name+"'"+"[3][2][1].controller.value")
     append fan_v1   ("$"+"'"+b2[i].name+"'"+"[3][2][1].controller.value")
     
    )---end 
    if ((x_b1+x_b2)<=179 or  (x_b1+x_b2)>=181)  and ((x_b1-x_b2)<=1 and (x_b1-x_b2)>=-1)    
    then
    (
     append v2  ("$"+"'"+b1[i].name+"'"+"[3][2][1].controller.value")
     append fan_v2  ("$"+"'"+b2[i].name+"'"+"[3][2][1].controller.value")
     
    )---end if 
      
   )---end else 
  -----相加为360 情况。
   
  if (b1[i][3][2][1].controller.value +\
   b2[i][3][2][1].controller.value) <=361 and 
   (b1[i][3][2][1].controller.value +\
   b2[i][3][2][1].controller.value) >=359
  then
   ( 
    append v4    ("$"+"'"+b1[i].name+"'"+"[3][2][1].controller.value")
    append fan_v4    ("$"+"'"+b2[i].name+"'"+"[3][2][1].controller.value")
    
   )----end if 360 的数组
   
        if (b1[i][3][2][1].controller.value +\
   b2[i][3][2][1].controller.value) <=-359 and 
   (b1[i][3][2][1].controller.value +\
   b2[i][3][2][1].controller.value) >=-361
  then
   ( 
    append v4_1    ("$"+"'"+b1[i].name+"'"+"[3][2][1].controller.value")
    append fan_v4_1    ("$"+"'"+b2[i].name+"'"+"[3][2][1].controller.value")
    
   )----end if 360 的数组   
             temp_b1 =(b1[i][3][2][1].controller.value ) 
    temp_b2 =(b2[i][3][2][1].controller.value )   
   if (temp_b1+temp_b2>181 or temp_b1+temp_b2<179  )    and
   (temp_b1+temp_b2 >-179 or temp_b1+temp_b2<-181 )  and
      (temp_b1+temp_b2 >1 or  temp_b1+temp_b2 <-1)      and
   (temp_b1-temp_b2 >1 or  temp_b1-temp_b2 <-1)      and
   (temp_b1+temp_b2 >361 or  temp_b1+temp_b2 <359)   and
   (temp_b1+temp_b2 >-359  or temp_b1+temp_b2<-361)
   then
   (
    append v5    ("$"+"'"+b1[i].name+"'"+"[3][2][1].controller.value")
    
   )
   if v5.count >0 then
   (
    messagebox ("起初的设置有不对称数组。请手动设置写\n
    要让设置的结构 +=180 or+=-180 or+=0 or-=0 or +=360
    +=-360. 该设置控制器为：\n"+("$"+"'"+b1[i].name+"'"+"[3][2][1].controller.value\n")+
     ("$"+"'"+b2[i].name+"'"+"[3][2][1].controller.value"))
     v5=#()
     return false 
   )
  ----////////////////////////////////////////////////////////////////////////////////
  --- 下面就是 y 轴的处理方法 和上面是一样的。 
   
  if (b1[i][3][2][2].controller.value +\
   b2[i][3][2][2].controller.value) <=181 and
   (b1[i][3][2][2].controller.value +\
   b2[i][3][2][2].controller.value) >=179
  then
   ( 
    append v3    ("$"+"'"+b1[i].name+"'"+"[3][2][2].controller.value")
    append fan_v3    ("$"+"'"+b2[i].name+"'"+"[3][2][2].controller.value")
    
   )----end if 180 的数组
  if (b1[i][3][2][2].controller.value +\
   b2[i][3][2][2].controller.value) <=-179 and 
   (b1[i][3][2][2].controller.value +\
   b2[i][3][2][2].controller.value) >=-181
  then
   ( 
    append v3_1    ("$"+"'"+b1[i].name+"'"+"[3][2][2].controller.value")
    append fan_v3_1    ("$"+"'"+b2[i].name+"'"+"[3][2][2].controller.value")
    
   )----end if 180 的数组
   
   if  ((b1[i][3][2][2].controller.value )<1 and (b1[i][3][2][2].controller.value )>-1) and
     ((b2[i][3][2][2].controller.value )<1 and (b2[i][3][2][2].controller.value )>-1) 
   then 
   (
    
    append y_bone   ("$"+"'"+b1[i].name+"'"+"[3][2][2].controller.value")
    append fan_y_bone   ("$"+"'"+b2[i].name+"'"+"[3][2][2].controller.value")
    
    
   )else                                
   ( 
    x_b1 =(b1[i][3][2][2].controller.value ) 
    x_b2 =(b2[i][3][2][2].controller.value ) 
    if (x_b1+x_b2)<=1 and (x_b1+x_b2)>=-1
    then
    (
     append v1   ("$"+"'"+b1[i].name+"'"+"[3][2][2].controller.value")
     append fan_v1   ("$"+"'"+b2[i].name+"'"+"[3][2][2].controller.value")
     
    )---end 
    if ((x_b1+x_b2)<=179 or  (x_b1+x_b2)>=181)  and ((x_b1-x_b2)<=1 and (x_b1-x_b2)>=-1)                                                      
    then
    (
     append v2  ("$"+"'"+b1[i].name+"'"+"[3][2][2].controller.value")
     append fan_v2  ("$"+"'"+b2[i].name+"'"+"[3][2][2].controller.value")
     
    )---end if 
      
   )---end else 
   
  if (b1[i][3][2][2].controller.value +\
   b2[i][3][2][2].controller.value) <=361 and 
   (b1[i][3][2][2].controller.value +\
   b2[i][3][2][2].controller.value) >=359
  then
   ( 
    append v4    ("$"+"'"+b1[i].name+"'"+"[3][2][2].controller.value")
    append fan_v4    ("$"+"'"+b2[i].name+"'"+"[3][2][2].controller.value")
    
   )----end if 360 的数组
   
        if (b1[i][3][2][2].controller.value +\
   b2[i][3][2][2].controller.value) <=-359 and 
   (b1[i][3][2][2].controller.value +\
   b2[i][3][2][2].controller.value) >=-361
  then
   ( 
    append v4_1    ("$"+"'"+b1[i].name+"'"+"[3][2][2].controller.value")
    append fan_v4_1    ("$"+"'"+b2[i].name+"'"+"[3][2][2].controller.value")
    
   )----end if 360 的数组   
             temp_b1 =(b1[i][3][2][2].controller.value ) 
    temp_b2 =(b2[i][3][2][2].controller.value )   
   if (temp_b1+temp_b2>181 or temp_b1+temp_b2<179  )    and
   (temp_b1+temp_b2 >-179 or temp_b1+temp_b2<-181 )  and
      (temp_b1+temp_b2 >1 or  temp_b1+temp_b2 <-1)      and
   (temp_b1-temp_b2 >1 or  temp_b1-temp_b2 <-1)      and
   (temp_b1+temp_b2 >361 or  temp_b1+temp_b2 <359)   and
   (temp_b1+temp_b2 >-359  or temp_b1+temp_b2<-361)
   then
   (
    append v5    ("$"+"'"+b1[i].name+"'"+"[3][2][2].controller.value")
    
   )
   if v5.count >0 then
   (
    messagebox ("起初的设置有不对称数组。请手动设置写\n
    要让设置的结构 +=180 or+=-180 or+=0 or-=0 or +=360
    +=-360. 该设置控制器为：\n"+("$"+"'"+b1[i].name+"'"+"[3][2][2].controller.value\n")+
     ("$"+"'"+b2[i].name+"'"+"[3][2][2].controller.value"))
     v5=#()
     return false 
   )
   
  ----////////////////////////////////////////////////////////////////////////////////
  --- 下面就是 z 轴的处理方法 和上面是一样的。 
   
  if (b1[i][3][2][3].controller.value +\
   b2[i][3][2][3].controller.value) <=181 and
   (b1[i][3][2][3].controller.value +\
   b2[i][3][2][3].controller.value) >=179
  then
   ( 
    append v3    ("$"+"'"+b1[i].name+"'"+"[3][2][3].controller.value")
    append fan_v3    ("$"+"'"+b2[i].name+"'"+"[3][2][3].controller.value")
    
   )----end if 180 的数组

  if (b1[i][3][2][3].controller.value +\
   b2[i][3][2][3].controller.value) <=-179 and 
   (b1[i][3][2][3].controller.value +\
   b2[i][3][2][3].controller.value) >=-181
  then
   ( 
	append v3_1    ("$"+"'"+b1[i].name+"'"+"[3][2][3].controller.value")
    append fan_v3_1    ("$"+"'"+b2[i].name+"'"+"[3][2][3].controller.value")
    
   )----end if 180 的数组
   
   if  (b1[i][3][2][3].controller.value )<1 and 
     (b2[i][3][2][3].controller.value)>-1
   then 
   ( 
    
    append v1   ("$"+"'"+b1[i].name+"'"+"[3][2][3].controller.value")
    append fan_v1   ("$"+"'"+b2[i].name+"'"+"[3][2][3].controller.value")
    
    
   )else    
   ( 
    x_b1 =(b1[i][3][2][3].controller.value ) 
    x_b2 =(b2[i][3][2][3].controller.value ) 
    if (x_b1+x_b2)<=1 and (x_b1+x_b2)>=-1
    then
    (
     append v1   ("$"+"'"+b1[i].name+"'"+"[3][2][3].controller.value")
     append fan_v1   ("$"+"'"+b2[i].name+"'"+"[3][2][3].controller.value")
     
    )---end 
    if ((x_b1+x_b2)<=179 or  (x_b1+x_b2)>=181)  and ((x_b1-x_b2)<=1 and (x_b1-x_b2)>=-1)    
    then
    (
     append v2  ("$"+"'"+b1[i].name+"'"+"[3][2][3].controller.value")
     append fan_v2  ("$"+"'"+b2[i].name+"'"+"[3][2][3].controller.value")
     
    )---end if 
      
   )---end else 
   
  if (b1[i][3][2][3].controller.value +\
   b2[i][3][2][3].controller.value) <=361 and 
   (b1[i][3][2][3].controller.value +\
   b2[i][3][2][3].controller.value) >=359
  then
   ( 
    append v4    ("$"+"'"+b1[i].name+"'"+"[3][2][3].controller.value")
    append fan_v4    ("$"+"'"+b2[i].name+"'"+"[3][2][3].controller.value")
    
   )----end if 360 的数组
   
        if (b1[i][3][2][3].controller.value +\
   b2[i][3][2][3].controller.value) <=-359 and 
   (b1[i][3][2][3].controller.value +\
   b2[i][3][2][3].controller.value) >=-361
  then
   ( 
    append v4_1    ("$"+"'"+b1[i].name+"'"+"[3][2][3].controller.value")
    append fan_v4_1    ("$"+"'"+b2[i].name+"'"+"[3][2][3].controller.value")
    
   )----end if 360 的数组   
             temp_b1 =(b1[i][3][2][3].controller.value ) 
    temp_b2 =(b2[i][3][2][3].controller.value )   
   if (temp_b1+temp_b2>181 or temp_b1+temp_b2<179  )    and
   (temp_b1+temp_b2 >-179 or temp_b1+temp_b2<-181 )  and
      (temp_b1+temp_b2 >1 or  temp_b1+temp_b2 <-1)      and
   (temp_b1-temp_b2 >1 or  temp_b1-temp_b2 <-1)      and
   (temp_b1+temp_b2 >361 or  temp_b1+temp_b2 <359)   and
   (temp_b1+temp_b2 >-359  or temp_b1+temp_b2<-361)
   then
   (
    append v5    ("$"+"'"+b1[i].name+"'"+"[3][2][3].controller.value")
    
   )  
   if v5.count >0 then
   (
    messagebox ("起初的设置有不对称数组。请手动设置写\n
    要让设置的结构 +=180 or+=-180 or+=0 or-=0 or +=360
    +=-360. 该设置控制器为：\n"+("$"+"'"+b1[i].name+"'"+"[3][2][3].controller.value\n")+
     ("$"+"'"+b2[i].name+"'"+"[3][2][3].controller.value"))
     v5=#()
     return false 
   )
  
  
 )----end for add v LEI Array 	 

 )---end gt_9_misscount
 fn gt_9_danBonePos =
(  
 if v1.count > 0 then
 (
   for i in 1 to  v1.count  do 
   (
    op = execute(v1[i])

     op= 0-op
      execute (fan_v1[i]+"="+op as string) 
   )
  )

 if v2.count >0 then
 (
   for i in 1 to  v2.count  do 
   (
     op = execute(v2[i])
     op= 0+op
      execute (fan_v2[i]+"="+op as string) 
   )
  )

  if v3.count>0 then
 (
   for i in 1 to  v3.count  do 
   (
    op = execute(v3[i])
     op= 180-op
      execute (fan_v3[i]+"="+op as string)
   )
  )
  
  
    if v3_1.count>0 then
 (
   for i in 1 to  v3_1.count  do 
   (
       op = execute(v3_1[i])
     op= -180-op
      execute (fan_v3_1[i]+"="+op as string) 
   )
  )
 
    if v4.count >0 then
 (
   for i in 1 to  v4.count  do 
   (
        op = execute(v4[i])
     op= 360-op
      execute (fan_v4[i]+"="+op as string) 
   )
  )
 
  if v4_1.count >0 then
 (
   for i in 1 to  v4_1.count  do 
   (
        op = execute(v4_1[i])
     op= -360-op
      execute (fan_v4_1[i]+"="+op as string) 
   )
  )
    if y_bone.count >0 then
 (
   for i in 1 to  y_bone.count  do 
   (
        op = execute(y_bone[i])
      execute (fan_y_bone[i]+"="+op as string) 
   )
  )
  
 
  
) --end gt_9_danBonePos
---2011.8.15 雏形 ---主要在2011.8.13 -8.14 想 与制作。

rollout gt_9_BoneMIss "骨骼动作镜像工具" width:244 height:339
(
	groupBox grp1 "主动镜像" pos:[6,7] width:104 height:65
	groupBox grp2 "被动镜像" pos:[125,7] width:104 height:65
	button zhu_btn "没有定义" pos:[14,28] width:80 height:29
	button bie_btn "没有定义" pos:[134,28] width:80 height:29
	button fn_btn "映射镜像数据" pos:[4,84] width:228 height:29
	groupBox grp3 "以xyz为镜像轴向的方案" pos:[8,123] width:228 height:150
	button pos_btn "pos镜像" pos:[18,144] width:80 height:29
	button TA_Animation_btn "塌陷动画数据" pos:[108,145] width:113 height:29
	spinner start_spn "开始帧数：" pos:[100,184] width:120 height:16 range:[-99999999,99999999,0] type:#integer
	spinner end_spn "结束帧数：" pos:[100,204] width:120 height:16 range:[-99999999,999999999,100] type:#integer
	spinner CAIYAND_spn1 "采样：" pos:[118,224] width:102 height:16 range:[1,50,2] type:#integer
	 progressbar doit_prog  color:red
	
      local tm = 60
	label lab1 "注意：偶尔在镜像的时候数据不统一"pos:[7,218+tm]
	label lab2    " 请根据提示操作。"  pos:[7,238+tm]
	hyperLink help  "使用工具的方法连接"  pos:[60,258+tm]  color:(color 255 0 0)  hoverColor:(color 0 255 255) address:""

	
	groupBox grp4 "以z为镜像轴向的方案"  width:228 height:86 visible:false--
	
	button Zpps_btn "pos镜像" pos:[17,239] width:80 height:29 visible:false
	button Zpos_Animation_btn "塌陷动画数据" pos:[107,239] width:113 height:29 visible:false
	spinner CAIYAND_spn2 "采样：" pos:[115,279] width:102 height:16 range:[1,50,2] type:#integer visible:false
			on gt_9_BoneMIss lbuttondblclk g11 do
	(
		DestroyDialog gt_9_BoneMIss
		)
	on gt_9_BoneMIss lbuttonup pos1 do 
		mousedd1=false
	on gt_9_BoneMIss lbuttondown pos1 do
		(
		mousedd1=true
		Thepos1=pos1
			)
	on gt_9_BoneMIss mousemove pos1 do
	(	if mousedd1==true Then 
		(SetDialogPos gt_9_BoneMIss (mouse.screenpos-Thepos1))
		
		)


	
	
	local gt_9_contrl = #(grp2,bie_btn,fn_btn,grp3,pos_btn,TA_Animation_btn,CAIYAND_spn1,grp4,Zpps_btn,Zpos_Animation_btn,CAIYAND_spn2,start_spn,end_spn)
	on zhu_btn pressed do 
	(	
		try(
		b1 =#()
	    gt_9_b1_count()
			
			if b1.count >0 then
			(
			zhu_btn.text ="主动镜像启动"	
			gt_9_contrl[1].enabled =true 
			gt_9_contrl[2].enabled =true 
			)---end if b1.count >0 then
			
			
		)catch("遇到不知道的错误。")
		
	
    )---end on zhu_btn pressed do 
	on bie_btn pressed do
	(
		try(
		b2 =#()
		gt_2_b2_count()
		if b2.count >0 then
        (	
         bie_btn.text ="被动镜像启动"
			
		gt_9_contrl[3].enabled =true 
		)
			
		)catch("遇到不知道的错误。")
		
	)---end on bie_btn pressed do
	
	on fn_btn pressed do
	(
		try(
		gt_9_misscount()
			for i in 4 to gt_9_contrl.count do
			(
				gt_9_contrl[i].enabled =true 
				
			)
			
			
		)catch("遇到不知道的错误。")
		
	)---end on fn_btn pressed do
	on pos_btn pressed do
	(
		try(
		gt_9_danBonePos()
		)catch("遇到不知道的错误。")
		
	)---end on fn_btn pressed do
	on TA_Animation_btn  pressed do
	(
		try(
			if end_spn.value - start_spn.value <0 then
			(
				messagebox "结束帧数不能小于开始帧数，请从新调整。"title:"盖天编写"
				return false
			)else
			(
				if (end_spn.value - start_spn.value)/CAIYAND_spn1.value==0 then
				(
					messagebox "采样数比帧的范围要大，不成立，请重新调整参数。" title:"盖天编写"
					return false
				)
				
			)
			
			animationRange =(interval start_spn.value  end_spn.value)
			sliderTime =start_spn.value
			timep =(end_spn.value - start_spn.value)/CAIYAND_spn1.value 
			with animate on

			(  
				temp =start_spn.value
				for i in 1 to timep  do 
				(

			      at time (temp+=CAIYAND_spn1.value) gt_9_danBonePos()
                   doit_prog.value = 100.*i/timep
			   )

			)
 	
			doit_prog.value = 0
		)catch("遇到不知道的错误。")
		
	)---end on fn_btn pressed do
	
	on start_spn  entered do 
	(
		if start_spn.value >= end_spn.value then
		(
			end_spn.value =start_spn.value
		)
	)
	
	on gt_9_BoneMIss open do
	(
		
		for i in gt_9_contrl do
		(
			i.enabled =false
		)
		
	)----end  gt_9_BoneMIss open 
	
	

	
	
)
-----------------------------------------------------------------------------------------------------------------------------




-----------------------------------------------------------------小工具

try(destroyDialog xiaogongju)catch()
local mousedd = false
local ThePos = [0,0]
rollout xiaogongju "小工具" width:162 height:300
(
	groupBox grp1 ""     pos:[6,6] width:150 height:288
	button guanbi1 "x" pos:[150,-3] width:15 height:15
	button btn1 "按贴图命名材质" pos:[10,20] width:140 height:20
	button btn2 "重命名骨骼" pos:[10,40] width:140 height:20 tooltip:"重命名骨骼，把骨骼名称中的空格换成下划线"
	button btn3 "Button" pos:[10,60] width:140 height:20
	button btn4 "Button" pos:[10,80] width:140 height:20
	button btn5 "Button" pos:[10,100] width:140 height:20
	button btn6 "Button" pos:[10,120] width:140 height:20
	button btn7 "Button" pos:[10,140] width:140 height:20
	button btn8 "Button" pos:[10,160] width:140 height:20
	button btn9 "Button" pos:[10,180] width:140 height:20
	button btn10 "Button" pos:[10,200] width:140 height:20
		on xiaogongju lbuttondblclk g11 do
	(
		DestroyDialog xiaogongju
		)
	--on btn1 pressed do
	on xiaogongju lbuttonup pos do
		mousedd = false ;
	on xiaogongju lbuttondown pos do
		(mousedd = true ; ThePos = pos)
	on xiaogongju mouseMove pos do
		if mousedd do SetDialogPos   xiaogongju  (mouse.screenpos - thePos)
	
	 on btn1 pressed do ( 
 fn renameMats objs = if objs.count != 0 do
    (
        local matClasses = #(Arch___Design__mi, Standard, VRayMtl,  Multimaterial,Shell_Material)
        local selMats = #()

        for c in matClasses do
        (
            for o in objs where o.mat != null do (join selMats (getClassInstances c target:o))
        )

        if selMats.count != 0 do
        (
            for m in selMats do
            (
                case of
                (
                    (isProperty m #diff_color_map): if isKindOf (map = getProperty m #diff_color_map) textureMap do m.name = map.name
                    (isProperty m #diffuseMap): if isKindOf (map = getProperty m #diffuseMap) textureMap do m.name = map.name
                    (isProperty m #texmap_diffuse): if isKindOf (map = getProperty m #texmap_diffuse) textureMap do m.name = map.name
                )
            )
        )
        free selMats
    )
 
 
 for b in getClassInstances bitmaptex do try(b.name = getFilenameFile b.filename)catch()
		renameMats selection
		 )
	 on btn2 pressed do (TempMode = getCommandPanelTaskMode();
max create mode;
for i in $bip* do
(
	tempnames = filterstring i.name " "
	case of
	(
		(tempnames.count == 1) : i.name = tempnames[1]
		(tempnames.count == 2) : i.name = tempnames[1] + "_" + tempnames[2]
		(tempnames.count == 3) : i.name = tempnames[1] + "_" + tempnames[2] + "_" + tempnames[3]
	)
)
setCommandpanelTaskMode TempMode
		 )
		
		on guanbi1 pressed do
			(destroydialog xiaogongju)
	
	
	
	
	
	
	
	
	
	
	
)












)	


	
	

		
