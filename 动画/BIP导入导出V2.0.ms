/**************************************************************************************************************************************************************************************
Author:		         吇鱼 JohnWayne
Name:                BIP导入导出
Script Version:	    V2.00
**************************************************************************************************************************************************************************************/
global cg_bip_tool 
global script_sel = false
global max_bip_export_tool 
global file_name_array = #()
global judgment = undefined

rollout rollA "BIP导入"
(
	button    btn_bip_import "执行导入 BIP"   width:178 height:30 color:red      
	group "设置"
	(
	 checkBox  cbox_hand_bip         "多角色手动选择加载 Bip"  width:150 height:18    checked:false	
     checkBox  cbox_add_maxobjects   "加载骨骼附带MaxObject"  width:150 height:18    checked:false
	)

		on btn_bip_import pressed do 
	(  
				SelBiparray=#()
				for i in objects do
				(
					if classof i == Biped_Object do append selBiparray i
				)
					if SelBiparray.count > 0 then 
					(
	                   if cbox_hand_bip.state == true then
						(
                             if  ($ == undefined or classof $ != Biped_Object)  do (messagebox "需要选择一根 BIP 骨骼！" beep:false Title:"提示" Return 0)
						)
	                local newPath = getOpenFileName caption:"Load Biped File" filename:(getDir #renderPresets + @"\") types:"3ds Max Biped (*.bip)|*.bip"  historyCategory:"RTTObjectPresets"
	                if newPath != undefined then
					   (	
						        if cbox_hand_bip.state == true then
									(
										Bip01 = $
										if( Bip01 == undefined or classof Bip01 != Biped_Object ) then (messagebox "需要选择一根 BIP 骨骼！" beep:false Title:"提示") else
										(
										    Sel_Biped_Object_Bip01 = Bip01.controller
										)
									)else (
								        Sel_Biped_Object_Bip01=SelBiparray[1].controller
								        if Sel_Biped_Object_Bip01.figureMode==true do Sel_Biped_Object_Bip01.figureMode=false
								     )
								Bip_FilesLink=getFilenamePath  newPath 
								Bip_FilesName=getFilenameFile  newPath

								Bip_LinkBipName=Bip_FilesLink+Bip_FilesName + ".bip"	---定义读取Bip的路径
								animationRange = interval 0 1
								if cbox_add_maxobjects.state ==true then
								(
									biped.loadbipfile Sel_Biped_Object_Bip01 Bip_LinkBipName #LoadMaxObjects
                                    
								)--end if
								else
								(
									biped.loadbipfile Sel_Biped_Object_Bip01 Bip_LinkBipName

								)								
					     )--end if				
				    )else(messagebox "场景中没有 BIP 骨骼！" beep:false Title:"提示")
	)
	------------------------------------------------------------------	
		on rollA rolledUp state do
	(
	if (state) then
	cg_bip_tool.size.y += rollA.height
	else
	cg_bip_tool.size.y -= rollA.height
    )
	------------------------------------------------------------------	
	
)

rollout rollB "BIP导出"
(
	button  btn_bip_export "执行导出 BIP"   width:178 height:30 color:red    
	group "设置"
	(
		
	 checkBox  cb_a   "询问保存路径"  width:150 height:18    checked:false	
	 checkBox  cb_b   "多角色手动选择保存 Bip"  width:150 height:18    checked:false	
     checkBox  cb_c   "保存骨骼附带MaxObject"  width:200 height:18    checked:false
	 checkBox  cb_d   "渲染avi预览视频"  width:150 height:18    checked:false	
	editText  ShowPath_Tx   "" width:170 height:20 abled:false  offset:[-6,0] text:"\automodel\dex_rig.max" enabled:false
	button    btn_main "使用场景模型"   width:80 height:21 color:red     offset:[-42,0] enabled:false
    button    btn_file "使用其他模型"   width:80 height:21 color:red     offset:[44,-26] enabled:false		
			
	)
		on cb_d changed stat do
		(
	            if cb_d.checked  == true then 
				     (
					ShowPath_Tx.enabled = true
					btn_file.enabled  = true
					btn_main.enabled  = true	
				     )else(
						ShowPath_Tx.enabled = false
						btn_file.enabled  = false
						btn_main.enabled  = false
					)						
		)
		
        on btn_main pressed do
		(
			ShowPath_Tx.text = maxFilePath + maxFileName
            script_sel = false			
		)
		
		on btn_file pressed do
		(
			local curpath = ShowPath_Tx.text	
	        local newPath = getOpenFileName caption:"Load Max File" filename:(getDir #renderPresets + @"\") types:"3ds Max File (*.max)|*.max"  historyCategory:"RTTObjectPresets"
	        if newPath != undefined then
		   (
			     ShowPath_Tx.text = newpath
			     script_sel = true
		   )
		)			
				
		on btn_bip_export pressed do
	    (
		local Max_LinkBipName
		local Max_FilesPath
		local Max_FilesName
		local Sel_Biped_Object_Bip01
		local save_maxobjects 
		local path_avi = false
		local SelBiparray = #()  
	
		if cb_a.state == true then (Max_LinkBipName = getSaveFileName caption:"Save Biped File" filename:(getDir #renderPresets + @"\") types:"3ds Max Biped (*.bip)|*.bip"  historyCategory:"RTTObjectPresets" if Max_LinkBipName == undefined then Return 0)else
									(Max_FilesPath = maxFilePath + maxFileName ;Max_FilesName=getFilenameFile Max_FilesPath ;Max_LinkBipName = maxFilePath + Max_FilesName +".bip")
		
		if cb_b.state == true then ( if($ == undefined or classof $ != Biped_Object )then(messagebox "需要选择一根 BIP 骨骼！" beep:false Title:"提示"  Return 0)else Sel_Biped_Object_Bip01 = $.controller )else
									( for i in objects do ( if classof i == Biped_Object do append SelBiparray i )if SelBiparray.count > 0 then (Sel_Biped_Object_Bip01=SelBiparray[1].controller))
		
										
		if cb_c.state == true then (
				biped.saveBipFile Sel_Biped_Object_Bip01 Max_LinkBipName #SaveMaxObjects
		) else (
			    biped.saveBipFile Sel_Biped_Object_Bip01 Max_LinkBipName

			)
		
		if cb_d.state == true then (

			if load_maxfile == false then messagebox messagebox_title beep:false Title:"提示" else (
                       if ( script_sel == false ) then (
						  
						 load_path = ShowPath_Tx.text
						 load_maxfile =loadMAXFile load_path Quiet:true  useFileUnits:true
						 messagebox_title = "渲染avi预览视频使用的max文件路径不存在，请确认后重试。\n" + load_path
						   
						 local render_start = animationRange.start
                         local render_end = animationRange.end	
						   
						 local get_path = getFilenamePath Max_LinkBipName
						 local	get_name = getFilenameFile Max_LinkBipName
						   
		                 local	view = "_view"
						 local d = get_path + get_name + view + ".avi"
						try
						(
					     local tempvfb = render outputfile:d  fromframe:render_start toframe:render_end nthframe:rendNThFrame outputwidth:renderwidth outputheight:renderheight renderer:#production progressbar:true	
						 undisplay tempvfb
						)
	                     catch(messagebox"渲染出错了可能是文件有问题，或是没有Camera01\n 建立一个Camera并改名为Camera01")   
					)else(
						
						 max hold 
						
						 load_path = ShowPath_Tx.text
						 load_maxfile =loadMAXFile load_path Quiet:true  useFileUnits:true
						 messagebox_title = "渲染avi预览视频使用的max文件路径不存在，请确认后重试。\n" + load_path
						     
						 local render_start = animationRange.start
                         local render_end = animationRange.end	
						   
						 local get_path = getFilenamePath Max_LinkBipName
						 local	get_name = getFilenameFile Max_LinkBipName
						   
		                 local	view = "_view"
						 local d = get_path + get_name + view + ".avi"
						
						 animationRange = interval 0 1
						
						 max zoomext sel all
						 
						 SelBiparray = #()---重置
			
						 for i in objects do ( if classof i == Biped_Object do append SelBiparray i )if SelBiparray.count > 0 then (Sel_Biped_Object_Bip01=SelBiparray[1].controller)

						if cb_c.state == true then (		        
							    biped.loadBipFile Sel_Biped_Object_Bip01 Max_LinkBipName #SaveMaxObjects
						)else(
							    biped.loadBipFile Sel_Biped_Object_Bip01 Max_LinkBipName
						)
						 try
						       (
					                local tempvfb = render outputfile:d  fromframe:render_start toframe:render_end nthframe:rendNThFrame outputwidth:200 outputheight:200 renderer:#production progressbar:true	
						             undisplay tempvfb
								)catch(
								     messagebox"渲染出错了可能是文件有问题，或是没有Camera01\n 建立一个Camera并改名为Camera01"
								        )   

						 fetchMaxFile quiet:true
						)
				)
			)
		messageok = "BIP保存成功 \n位置：" +  Max_LinkBipName
        messagebox messageok beep:false Title:"恭喜"	
        )
	------------------------------------------------------------------	
		on rollB rolledUp state do
	(
	if (state) then
	cg_bip_tool.size.y += rollB.height
	else
	cg_bip_tool.size.y -= rollB.height
    )
	------------------------------------------------------------------
)

rollout rollC "快速导入导出"
(
	
	button btn_bipex "BIP导出"  width:83 height:30 across: 2 offset:[-6,0]
	button btn_bipim "BIP导入"  width:83 height:30 across: 2 offset:[6,0]
	group "设置" (
	checkBox  cb_cache   "保存在缓存中"  width:150 height:18    checked:true
	)
	
	
	on btn_bipex pressed do
		(
			if cb_cache.state == true then 
				(
					file_pathname = "C:\\Windows\\temp\\3dsmaxBipedAnimationCache.bip" 
				)else(
					Max_FilesPath = maxFilePath + maxFileName ;Max_FilesName=getFilenameFile Max_FilesPath ;file_pathname = maxFilePath + Max_FilesName +".bip"					
				)
			if ($ == undefined or classof $ != Biped_Object) then
				(
					messagebox "需要选择一根 BIP 骨骼！" beep:false Title:"提示"
				)else(
					biped.saveBipFile $.controller file_pathname 
				)
			)
	
		
	on btn_bipim pressed do
		(
			if cb_cache.state == true then 
				(
					file_pathname = "C:\\Windows\\temp\\3dsmaxBipedAnimationCache.bip" 
					yesorno = doesFileExist file_pathname 
					if yesorno == false then (
						messagebox "没有找到保存的BIP文件，请先保存！" beep:false Title:"提示" Return 0 
						)
				)else(
					Max_FilesPath = maxFilePath + maxFileName ;Max_FilesName=getFilenameFile Max_FilesPath ;file_pathname = maxFilePath + Max_FilesName +".bip"
					yesorno = doesFileExist file_pathname 
                    if yesorno == false then (
						messagebox "没有找到保存的BIP文件，请先保存！" beep:false Title:"提示" Return 0 
						)						
				)
			if ($ == undefined or classof $ != Biped_Object) then
				(
					messagebox "需要选择一根 BIP 骨骼！" beep:false Title:"提示"
				)else(
					biped.loadBipFile $.controller file_pathname 
				)
			)
	
	------------------------------------------------------------------		
	on rollC rolledUp state do
	(
	if (state) then
	    cg_bip_tool.size.y += rollC.height
	else
	    cg_bip_tool.size.y -= rollC.height
	)
	------------------------------------------------------------------	
)

rollout rollD "批量转换"
(
		group "存储内容"
	(
		radioButtons btn_savefile "" width:88 height:20 labels:#("MAX-> BIP", "BIP-> MAX") offset:[-35,0]
	)
	group "文件路径"
	(
		editText  ShowPath_Tx   "" width:170 height:20 abled:false  offset:[-6,0]  
		button    btn_file "文件"   width:70 height:24 color:red     offset:[-47,0]
		button    btn_folder "文件夹"   width:70 height:24 color:red     offset:[48,-29] 
	)			
	group "设置"
	(
        checkBox  MaxObjectsControl   "保存和加载 MaxObjects"  width:150 height:18    checked:false
	)
	
	button btn_save "保存Bip文件" width:180 height:35 color:red	
	-------------------------------------------------------------------------------------------------

		  -------------------------------------保存类型判断
	on btn_savefile changed stat do
			(
							case stat of
				(
					1:
					(
						 btn_save.text = "保存Bip文件"
						 ShowPath_Tx.text = ""
						 file_name_array =#()
						 judgment = false
					)
					2:
					(
						 btn_save.text = "保存Max文件"
						 ShowPath_Tx.text = ""
						 file_name_array =#()
						 judgment = false
					)
				)
		
			)
			
		  -------------------------------------保存文件			
	on btn_file pressed do 
	(   
		if(btn_savefile.state==2)then(
	
	    local curpath = ShowPath_Tx.text	
	    local newPath = getOpenFileName caption:"Load Biped File" filename:(getDir #renderPresets + @"\") types:"3ds Max Biped (*.bip)|*.bip"  historyCategory:"RTTObjectPresets"
	    if newPath != undefined then
		   (
			     file_name_array =#()
			     append file_name_array newpath
			     ShowPath_Tx.text = newpath
			     judgment = true
		   )	
		   print file_name_array
	   )else(
		local curpath = ShowPath_Tx.text	
	    local newPath = getOpenFileName caption:"Load Max File" filename:(getDir #renderPresets + @"\") types:"3ds Max File (*.max)|*.max"  historyCategory:"RTTObjectPresets"
	    if newPath != undefined then
		   (
			     file_name_array =#()
			     append file_name_array newpath
			     ShowPath_Tx.text = newpath
			     judgment = true
		   )	
		   print file_name_array
	   )
	)
		  -------------------------------------保存文件夹
  	on btn_folder pressed do
	(
	     if(btn_savefile.state==2)then(
		local curpath = ShowPath_Tx.text
		local newPath = getSavePath   caption:"请指定相应路径到一个bip文件夹，您可以在下方文件夹框中粘贴路径。" 
		if newPath != undefined then
			(
				 ShowPath_Tx.text = newpath
				 judgment = true
				 file_name_array =#()
		         for f in getFiles (newPath + "\\*.bip") do
			         (
				         append file_name_array f
			          ) 
			)
				print file_name_array
		)else(
		local curpath = ShowPath_Tx.text
		local newPath = getSavePath   caption:"请指定相应路径到一个max文件夹，您可以在下方文件夹框中粘贴路径。" 
		if newPath != undefined then
			(
				 ShowPath_Tx.text = newpath
				 judgment = true
				 file_name_array =#()
		         for f in getFiles (newPath + "\\*.max") do
			         (
				         append file_name_array f
			          ) 
			)
				print file_name_array
		)			
	)
	
	on btn_save pressed do
	(
	 if(judgment == true) then(
		 
		if (btn_savefile.state==1)then(
					Save_FilePath=getSavePath caption:"Save File"--------------------------选择储存目录
					if Save_FilePath != undefined then
					(
						Save_FilePath_Box = QueryBox "在这个目录下储存bip文件吗？"Title:""
						
						if Save_FilePath_Box do
						(
							for Fe in file_name_array do
							(
								global Max_LinkBipName,MaxFiles
								loadMAXFile Fe Quiet:true -----------------------------------打开max文件
								Max_FilesName=getFilenameFile Fe ---------------------------提取列表中的文件名称
								Max_LinkBipName=Save_FilePath+"\\"+Max_FilesName+".bip"	-----*输出路径*
								print Max_LinkBipName-----------------------------------------打印输出路径
								SelBiparray=#()
								for i in objects do
								(
									if classof i == Biped_Object do append selBiparray i
								)
								for Fe=1 to Max_LinkBipName.count  do
								(
									if SelBiparray.count == 0 do continue;
									(					
										Sel_Biped_Object_Bip01=SelBiparray[1].controller
										if Sel_Biped_Object_Bip01.figureMode==true do Sel_Biped_Object_Bip01.figureMode=false
										if MaxObjectsControl.state ==true then
										(
											biped.saveBipFile Sel_Biped_Object_Bip01 Max_LinkBipName  #SaveMaxObjects
										)
										else
										(
											biped.saveBipFile Sel_Biped_Object_Bip01 Max_LinkBipName 
										)
									)
								)
							)
							resetMaxFile #noPrompt   -- File: New Scene
						)
					)
			)else(
	
				SelBiparray=#()
				for i in objects do
				(
					if classof i == Biped_Object do append selBiparray i
				)
					if SelBiparray.count > 0 then (
					Load_FilePath=getSavePath caption:"Save File"
					if Load_FilePath !=undefined then
					(
						Save_Max_FilePath_Box = QueryBox "在这个目录下储存max文件吗？"Title:""
						if Save_Max_FilePath_Box do
						(
							for Fe in file_name_array do
							(
								Sel_Biped_Object_Bip01=SelBiparray[1].controller
								if Sel_Biped_Object_Bip01.figureMode==true do Sel_Biped_Object_Bip01.figureMode=false
								Bip_FilesLink=getFilenamePath  Fe 
								Bip_FilesName=getFilenameFile  Fe
								Max_LinkBipName=Load_FilePath+"\\"+Bip_FilesName + ".max"	---定义max名字
								Bip_LinkBipName=Bip_FilesLink+Bip_FilesName + ".bip"	---定义读取Bip的路径
								animationRange = interval 0 1
								if MaxObjectsControl.state ==true then
								(
									biped.loadbipfile Sel_Biped_Object_Bip01 Bip_LinkBipName #LoadMaxObjects
									savemaxfile Max_LinkBipName useNewFile:true quiet:true 
								)--end if
								else
								(
									biped.loadbipfile Sel_Biped_Object_Bip01 Bip_LinkBipName
									savemaxfile Max_LinkBipName useNewFile:true quiet:true
								)
							)--end for
							resetMaxFile #noPrompt
						)
					)--end if				
				)else(messagebox "          需要一个保存动画的max文件！" beep:false Title:"提示")
			)
		
		)else(messagebox "          请先选择文件路径！" beep:false Title:"提示")
		
	)
	
	------------------------------------------------------------------	
		on rollD rolledUp state do
	(
	if (state) then
        cg_bip_tool.size.y += rollD.height
	else
        cg_bip_tool.size.y -= rollD.height
    )
	------------------------------------------------------------------	
)	

rollout rollE "关于 @吇鱼"
(
	HyperLink namescript "- BIP导入导出 -"  address:"http://www.cgwayne.com/" color:yellow hovercolor:blue visitedcolor:yellow align:#center offset:[0,14]
	Label LabelVersion "Version 2.00 - 2015" align:#center
	Label LabelAuthor "Created  by John Wayne" align:#center offset:[0,5]
	HyperLink website "cgwayne.com"  address:"http://www.cgwayne.com/" color:red hovercolor:blue visitedcolor:red align:#center
	------------------------------------------------------------------		
	on rollE rolledUp state do
	(
	if (state) then
	cg_bip_tool.size.y += rollE.height
	else
	cg_bip_tool.size.y -= rollE.height
	)
	------------------------------------------------------------------	
)

if (cg_bip_tool != undefined) then CloseRolloutFloater cg_bip_tool
cg_bip_tool = newRolloutFloater "BIP导入导出 v2.0" 200 100 

addRollout rollC cg_bip_tool
addRollout rollA cg_bip_tool
addRollout rollB cg_bip_tool
addRollout rollD cg_bip_tool
addRollout rollE cg_bip_tool


rollA.open = true
rollB.open = false
rollC.open = false 
rollD.open = false 
rollE.open = false 

cg_bip_tool.size.x = 200
cg_bip_tool.size.y = 230

rollA.open = true
rollB.open = false
rollC.open = false 
rollD.open = false 
rollE.open = false 