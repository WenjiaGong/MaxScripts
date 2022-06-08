--================================================================================

--================================================================================
try (	cui.unRegisterDialogBar ScriptManage)catch()
try (	destroydialog ScriptManage)catch()
rcmenu SpeedCusmenu1_jiaoben
(	menuItem mi_Speed_3 "保存配置文件"
	menuItem mi_Speed_4 "加载配置文件"
	menuItem mi_Speed_5 "打开C盘配置目录"
	menuItem mi_Speed_6 "打开宏文件夹"
	menuItem mi_Speed_7 "打开脚本文件夹"
		on mi_Speed_8 picked do		
(
	try (fileIn "$scripts\DTools\Scripts\primary.mse") 
	catch (print "加载出错...")
	setINISetting "$scripts\DTools\peizhi.ini" "chuangkoumoshi" "dakai""$scripts\DTools\Scripts\primary.mse"
)
		on mi_Speed_5 picked do
		(shellLaunch  (GetDir #maxData) "")
		on mi_Speed_6 picked do
		(ShellLaunch ( GetDir #usermacros)"")
		on mi_Speed_7 picked do
		(ShellLaunch ( GetDir #scripts)"")
		on mi_Speed_3 picked do
		(copy"$scripts\\DTools\jiaobengguanlishezhi.ini")
		on mi_Speed_4 picked do
		(ShellLaunch ( GetDir #scripts)"")
	
)
rollout ScriptManage "脚本管理" width:174 height:390
(
	button BtnScript01 "" pos:[7,80] width:160 height:20
	button BtnScript02 "" pos:[7,100] width:160 height:20
	button BtnScript03 "" pos:[7,120] width:160 height:20
	button BtnScript04 "" pos:[7,140] width:160 height:20
	button BtnScript05 "" pos:[7,160] width:160 height:20
	button BtnScript06 "" pos:[7,180] width:160 height:20
	button BtnScript07 "" pos:[7,200] width:160 height:20
	button BtnScript08 "" pos:[7,220] width:160 height:20
	button BtnScript09 "" pos:[7,240] width:160 height:20
	button BtnScript10 "" pos:[7,260] width:160 height:20
	button BtnScript11 "" pos:[7,280] width:160 height:20
	button BtnScript12 "" pos:[7,300] width:160 height:20
	button BtnScript13 "" pos:[7,320] width:160 height:20
	button BtnScript14 "" pos:[7,340] width:160 height:20
	button BtnScript15 "" pos:[7,360] width:160 height:20
	dropdownList edt11 "" pos:[6,39] width:162 height:22
	edittext edt1 "" pos:[3,18] width:164 height:20
	button Btn_tianjia "添加" pos:[7,60] width:40 height:20
	button Btn_shanchu "删除" pos:[87,60] width:40 height:20
	button btn_bianji "编辑" pos:[47,60] width:40 height:20
	button btn_shezhi "设置" pos:[127,60] width:40 height:20
	GroupBox grp1 "脚本管理器" pos:[3,1] width:167 height:383
	button btn_guanbi "x" pos:[152,1] width:15 height:15
	
	-----------变量-------------
	local ScriptPath= "C:\\script"
	local CurentNum1 = #()
	local CurentNum =1
	local Files_lei
	local 	files=#("","","","","","","","","","","","","","","")
	local	Thepos1=[0,0]
	local mousedd1=false
	-----------函数-------------
	fn FixButtonCaption idx =
	(		
		try
		(
				if idx ==01 do BtnScript=BtnScript01.text
				if idx ==02 do BtnScript=BtnScript02.text
				if idx ==03 do BtnScript=BtnScript03.text
				if idx ==04 do BtnScript=BtnScript04.text
				if idx ==05 do BtnScript=BtnScript05.text
				if idx ==06 do BtnScript=BtnScript06.text
				if idx ==07 do BtnScript=BtnScript07.text
				if idx ==08 do BtnScript=BtnScript08.text
				if idx ==09 do BtnScript=BtnScript09.text
				if idx ==10 do BtnScript=BtnScript10.text
				if idx ==11 do BtnScript=BtnScript11.text
				if idx ==12 do BtnScript=BtnScript12.text
				if idx ==13 do BtnScript=BtnScript13.text
				if idx ==14 do BtnScript=BtnScript14.text
				if idx ==15 do BtnScript=BtnScript15.text
			
			
			
			if BtnScript ==""then 
		(
			CopyScript = getOpenFileName caption:"" types:"All Files (*.*)|*.ms*|"
			if CopyScript !=undefined do
			(
				files[idx]=CopyScript as string 
				btnCaption =getFilenameFile files[idx])
				if idx ==01 do BtnScript01.text = btnCaption
				if idx ==02 do BtnScript02.text = btnCaption
				if idx ==03 do BtnScript03.text = btnCaption
				if idx ==04 do BtnScript04.text = btnCaption
				if idx ==05 do BtnScript05.text = btnCaption
				if idx ==06 do BtnScript06.text = btnCaption
				if idx ==07 do BtnScript07.text = btnCaption
				if idx ==08 do BtnScript08.text = btnCaption
				if idx ==09 do BtnScript09.text = btnCaption
				if idx ==10 do BtnScript10.text = btnCaption
				if idx ==11 do BtnScript11.text = btnCaption
				if idx ==12 do BtnScript12.text = btnCaption
				if idx ==13 do BtnScript13.text = btnCaption
				if idx ==14 do BtnScript14.text = btnCaption
				if idx ==15 do BtnScript15.text = btnCaption
				makeDir  ((GetDir #scripts)+"\\DTools\\")
				
				setINISetting "$scripts\\DTools\jiaobengguanlishezhi.ini" ("jiaoben_"+(CurentNum as string) ) ("shezhi_"+ (idx as string)) files[idx]
			
			)
			else 
			(
			filein files[idx] 
			)
			
			CurentNum1=append CurentNum1  files
		)
		catch()
		)

	fn DelIt idx =
	(
		try
		(delIniSetting "$scripts\\DTools\jiaobengguanlishezhi.ini" ("jiaoben_"+(CurentNum as string) ) ("shezhi_"+ (idx as string))
				files[idx]=""
				if idx ==01 do BtnScript01.text =""
				if idx ==02 do BtnScript02.text =""
				if idx ==03 do BtnScript03.text =""
				if idx ==04 do BtnScript04.text =""
				if idx ==05 do BtnScript05.text =""
				if idx ==06 do BtnScript06.text =""
				if idx ==07 do BtnScript07.text =""
				if idx ==08 do BtnScript08.text =""
				if idx ==09 do BtnScript09.text =""
				if idx ==10 do BtnScript10.text =""
				if idx ==11 do BtnScript11.text =""
				if idx ==12 do BtnScript12.text =""
				if idx ==13 do BtnScript13.text =""
				if idx ==14 do BtnScript14.text =""
				if idx ==15 do BtnScript15.text =""
			
		)
		catch() 
	)
	
	Timer tmr1 "Timer" pos:[68,374] width:24 height:24    
		
			
	on ScriptManage open do
	(
		
		makeDir  ((GetDir #scripts)+"\\DTools\\")
		Files_lei=getINISetting "$scripts\\DTools\jiaobengguanlishezhi.ini" "tiaomu_mingzhi"  ("tiaomu_"+ (CurentNum as string)) 
		if Files_lei ==""  then 
		 (	
		edt11.items=append edt11.items"新脚本"
		setINISetting "$scripts\\DTools\jiaobengguanlishezhi.ini" "tiaomu_mingzhi"  ("tiaomu_1") "新脚本"
		setINISetting "$scripts\\DTools\jiaobengguanlishezhi.ini" "tiaomu_shu"  ("tiaomu_shu") "1" 
		 )
		 else (
		shu_he = (getINISetting "$scripts\\DTools\jiaobengguanlishezhi.ini" "tiaomu_shu"  ("tiaomu_shu") )as integer
		for n in 1 to shu_he do (
			Files_lei= getINISetting "$scripts\\DTools\jiaobengguanlishezhi.ini" "tiaomu_mingzhi"  ("tiaomu_"+ (n) as string)
			edt11.items=append edt11.items(Files_lei)
			)
			for idx in 1 to 15 do (
		
			files[idx]=getINISetting "$scripts\\DTools\jiaobengguanlishezhi.ini" ("jiaoben_"+(CurentNum as string) ) ("shezhi_"+ (idx as string)) 
				
				if files[idx]!="" do 
				(
					btnCaption =getFilenameFile(files[idx])
					if idx ==01 do BtnScript01.text = btnCaption
					if idx ==02 do BtnScript02.text = btnCaption
					if idx ==03 do BtnScript03.text = btnCaption
					if idx ==04 do BtnScript04.text = btnCaption
					if idx ==05 do BtnScript05.text = btnCaption
					if idx ==06 do BtnScript06.text = btnCaption
					if idx ==07 do BtnScript07.text = btnCaption
					if idx ==08 do BtnScript08.text = btnCaption
					if idx ==09 do BtnScript09.text = btnCaption
					if idx ==10 do BtnScript10.text = btnCaption
					if idx ==11 do BtnScript11.text = btnCaption
					if idx ==12 do BtnScript12.text = btnCaption
					if idx ==13 do BtnScript13.text = btnCaption
					if idx ==14 do BtnScript14.text = btnCaption
					if idx ==15 do BtnScript15.text = btnCaption
				)					
		
			)		
			
		)
		edt11.selection = 1
	)
	on ScriptManage lbuttondblclk g11 do
	(
		DestroyDialog ScriptManage
		)
	on ScriptManage lbuttonup pos1 do
	(
		ScriptManage_weizhi=(mouse.screenpos-Thepos1)
		makeDir  ((GetDir #scripts)+"\\DTools\\")
		setINISetting "$scripts\\DTools\jiaoben_weizhi.ini" "ScriptManage" "ScriptManage_weizhi" (ScriptManage_weizhi as string )
		mousedd1=false
	)
	on ScriptManage lbuttondown pos1 do
	(
	mousedd1=true
	Thepos1=pos1
		)
	on ScriptManage mouseMove pos1 do
	(	
		if mousedd1==true Then 
		(
		SetDialogPos ScriptManage (mouse.screenpos-Thepos1)
		)
	)
	on btn_shezhi pressed do
	(
		popupMenu SpeedCusmenu1_jiaoben
	)
	on btn_shezhi rightClick do
	(
		popupMenu SpeedCusmenu1_jiaoben
	)
	on BtnScript01 pressed do
	(
		FixButtonCaption 01
	)
	on BtnScript01 rightClick do
	(
		try
		(
			DelIt 01
		)
		catch()
	)
	on BtnScript02 pressed do
	(
		try
		(
			FixButtonCaption 02
		)
		catch()
	)
	on BtnScript02 rightClick do
	(
		try
		(
			DelIt 2
		)
		catch()
	)
	on BtnScript03 pressed do
	(
		try
		(
			FixButtonCaption 03
		)
		catch()
	)
	on BtnScript03 rightClick do
	(
		try
		(
			DelIt 3
		
		)
		catch()
	)
	on BtnScript04 pressed do
	(
		try
		(
			FixButtonCaption 04
		)
		catch()
	)
	on BtnScript04 rightClick do
	(
		try
		(
			DelIt 4
		
		)
		catch()
	)
	on BtnScript05 pressed do
	(
		try
		(
		FixButtonCaption 05
	
		)
		catch()
	)
	on BtnScript05 rightClick do
	(
		try
		(
			DelIt 5
	
		)
		catch()
	)
	on BtnScript06 pressed do
	(
		try
		(
			FixButtonCaption 6
	
		)
		catch()
	)
	on BtnScript06 rightClick do
	(
		try
		(
			DelIt 6
	
		)
		catch()
	)
	on BtnScript07 pressed do
	(
		try
		(
			FixButtonCaption 7
	
		)
		catch()
	)
	on BtnScript07 rightClick do
	(
		try
		(
			DelIt 7
	
		)
		catch()
	)
	on BtnScript08 pressed do
	(
		try
		(
			FixButtonCaption 8
	
		)
		catch()
	)
	on BtnScript08 rightClick do
	(
		try
		(
			DelIt 8
	
		)
		catch()
	)
	on BtnScript09 pressed do
	(
		try
		(
			FixButtonCaption 9
	
		)
		catch()
	)
	on BtnScript09 rightClick do
	(
		try
		(
			DelIt 9
	
		)
		catch()
	)
	on BtnScript10 pressed do
	(
		try
		(
			FixButtonCaption 10
	
		)
		catch()
	)
	on BtnScript10 rightClick do
	(
		try
		(
			DelIt 10
	
		)
		catch()
	)
	on BtnScript11 pressed do
	(
		try
		(
			FixButtonCaption 11
		)
		catch()
	)
	on BtnScript11 rightClick do
	(
		try
		(
			DelIt 11
		)
		catch()
	)
	on BtnScript12 pressed do
	(
		try
		(
			FixButtonCaption 12
	
		)
		catch()
	)
	on BtnScript12 rightClick do
	(
		try
		(
			DelIt 12
	
		)
		catch()
	)
	on BtnScript13 pressed do
	(
		try
		(
			FixButtonCaption 13
	
		)
		catch()
	)
	on BtnScript13 rightClick do
	(
		try
		(
			DelIt 13
	
		)
		catch()
	)
	on BtnScript14 pressed do
	(
		try
		(
			FixButtonCaption 14
	
		)
		catch()
	)
	on BtnScript14 rightClick do
	(
		try
		(
			DelIt 14
	
		)
		catch()
	)
	on BtnScript15 pressed do
	(
		try
		(
			FixButtonCaption  15
	
		)
		catch()
	)
	on BtnScript15 rightClick do
	(
		try
		(
			DelIt 15
	
		)
		catch()
	)
	on edt11 selected i  do
	(
		CurentNum=i
				for idx in 1 to 15 do (
		
				files[idx]=getINISetting "$scripts\\DTools\jiaobengguanlishezhi.ini" ("jiaoben_"+(CurentNum as string) ) ("shezhi_"+ (idx as string)) 
				btnCaption =getFilenameFile(files[idx])
				if idx ==01 do BtnScript01.text = btnCaption
				if idx ==02 do BtnScript02.text = btnCaption
				if idx ==03 do BtnScript03.text = btnCaption
				if idx ==04 do BtnScript04.text = btnCaption
				if idx ==05 do BtnScript05.text = btnCaption
				if idx ==06 do BtnScript06.text = btnCaption
				if idx ==07 do BtnScript07.text = btnCaption
				if idx ==08 do BtnScript08.text = btnCaption
				if idx ==09 do BtnScript09.text = btnCaption
				if idx ==10 do BtnScript10.text = btnCaption
				if idx ==11 do BtnScript11.text = btnCaption
				if idx ==12 do BtnScript12.text = btnCaption
				if idx ==13 do BtnScript13.text = btnCaption
				if idx ==14 do BtnScript14.text = btnCaption
				if idx ==15 do BtnScript15.text = btnCaption	
		
	)
			
	)
	on Btn_tianjia pressed do
	( 
		if edt1.text!="" then (
	
		Files_lei = edt1.text as string 
		makeDir  ((GetDir #scripts)+"\\DTools\\")
		setINISetting "$scripts\\DTools\jiaobengguanlishezhi.ini" "tiaomu_mingzhi"  ("tiaomu_"+ ((edt11.items.count+1) as string)) Files_lei
		edt11.items=append edt11.items(Files_lei)
		edt11.selection = edt11.items.count
		CurentNum=edt11.items.count
		setINISetting "$scripts\\DTools\jiaobengguanlishezhi.ini" "tiaomu_shu"  ("tiaomu_shu") (CurentNum as string) 
		edt1.text=""
		local files=#("","","","","","","","","","","","","","","")
		BtnScript01.text =""
		BtnScript02.text =""
		BtnScript03.text =""
		BtnScript04.text =""
		BtnScript05.text =""
		BtnScript06.text =""
		BtnScript07.text =""
		BtnScript08.text =""
		BtnScript09.text =""
		BtnScript10.text =""
		BtnScript11.text =""
		BtnScript12.text =""
		BtnScript13.text =""
		BtnScript14.text =""
		BtnScript15.text =""
		
			
		)
		else 
		( messagebox "请输入一个名字")
	)
	on Btn_shanchu rightClick do
	( if edt11.items.count>1 do(
	edt11.items = deleteItem edt11.items edt11.selection
	for idx in 1 to 15 do (
	delIniSetting "$scripts\\DTools\jiaobengguanlishezhi.ini" ("jiaoben_"+(CurentNum as string)) ("shezhi_"+ (idx as string))
	setINISetting "$scripts\\DTools\jiaobengguanlishezhi.ini" "tiaomu_shu"  ("tiaomu_shu") (edt11.items.count as string ) 
	delIniSetting "$scripts\\DTools\jiaobengguanlishezhi.ini" "tiaomu_mingzhi"("tiaomu_"+ (edt11.selection as string))	
	)
	edt11.selection = edt11.items.count
	CurentNum=edt11.selection
	
		for idx in 1 to 15 do (
		
				files[idx]=getINISetting "$scripts\\DTools\jiaobengguanlishezhi.ini" ("jiaoben_"+(CurentNum as string) ) ("shezhi_"+ (idx as string)) 
				btnCaption =getFilenameFile(files[idx])
				if idx ==01 do BtnScript01.text = btnCaption
				if idx ==02 do BtnScript02.text = btnCaption
				if idx ==03 do BtnScript03.text = btnCaption
				if idx ==04 do BtnScript04.text = btnCaption
				if idx ==05 do BtnScript05.text = btnCaption
				if idx ==06 do BtnScript06.text = btnCaption
				if idx ==07 do BtnScript07.text = btnCaption
				if idx ==08 do BtnScript08.text = btnCaption
				if idx ==09 do BtnScript09.text = btnCaption
				if idx ==10 do BtnScript10.text = btnCaption
				if idx ==11 do BtnScript11.text = btnCaption
				if idx ==12 do BtnScript12.text = btnCaption
				if idx ==13 do BtnScript13.text = btnCaption
				if idx ==14 do BtnScript14.text = btnCaption
				if idx ==15 do BtnScript15.text = btnCaption
				)
	)
	)
	on btn_bianji pressed do
	(
		if edt1.text!="" then 
		(
		edt11.selected=edt1.text
		setINISetting"$scripts\\DTools\jiaobengguanlishezhi.ini" "tiaomu_mingzhi"  ("tiaomu_"+ (edt11.selection as string)) (edt1.text as string )
			edt1.text=""
		
		)
		else
		(messagebox "请输入一个名字")
	)
	on btn_shezhi pressed do
		(
	
	)
	on btn_guanbi pressed do
		(DestroyDialog ScriptManage)

)
ScriptManage_weizhi=[500,500]
makeDir  ((GetDir #scripts)+"\\DTools\\")
ss=(getINISetting "$scripts\\DTools\jiaoben_weizhi.ini" "ScriptManage" "ScriptManage_weizhi") 
if ss !="" do ScriptManage_weizhi=execute ss
createDialog  ScriptManage pos:ScriptManage_weizhi style:#(#style_maximizebox)