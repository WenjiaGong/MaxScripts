
fn FBX_animation =
(
		
	FBXExporterSetParam "Animation" True 				--动画
	FBXExporterSetParam "ASCII" False
  --FBXExporterSetParam "AxisConversionMethod" None 	--轴向
	FBXExporterSetParam "Cameras" False					--摄像机
	FBXExporterSetParam "CAT2HIK" False						
	FBXExporterSetParam "ColladaTriangulate" False		--三角算法
	FBXExporterSetParam "Convert2Tiff" False 			--关于 材质贴图
	FBXExporterSetParam "EmbedTextures" False  			--关于 材质贴图
	FBXExporterSetParam "FilterKeyReducer" False 		--关于 动画压缩
	FBXExporterSetParam "GeomAsBone" False 				--关于 物体转化为骨骼
	FBXExporterSetParam "GenerateLog" False 			--关于
	FBXExporterSetParam "Lights" False 					--关于 灯光
	FBXExporterSetParam "NormalsPerPoly" False 			--关于 法线
	FBXExporterSetParam "PointCache" False 				--关于 点缓存
	FBXExporterSetParam "Removesinglekeys" False 		--移除单帧动画
	FBXExporterSetParam "Skin" False 					--关于蒙皮
	FBXExporterSetParam "ShowWarnings" False 			--显示警告
	FBXExporterSetParam "SmoothingGroups" False 		--光滑组
	FBXExporterSetParam "SmoothMeshExport" False 		--光滑组
	FBXExporterSetParam "UseSceneName" False 			--使用场景名
	FBXExporterSetParam "BakeAnimation" true            --烘焙
)

    rollout menu "一键导出FBX  by:老宫QQ738255988" width:472 height:656
(
	button 'maxfilePathbtn' "Max存放路径" pos:[27,40] width:136 height:42 align:#left          --MAX存放路径按钮
	editText 'maxfilepath' "" pos:[179,48] width:270 height:22 align:#left                    --MAX存放路径显示框
	editText 'openMAXfile' "" pos:[179,128] width:270 height:22 align:#left
	button 'btn8' "打开MAX文件" pos:[27,120] width:136 height:42 align:#left
	button 'btn9' "选择导出的骨骼" pos:[27,210] width:136 height:42 align:#left
	listBox 'controler' "已选中" pos:[179,192] width:270 height:22 align:#left
	editText 'fbxexportPath' "" pos:[179,528] width:270 height:22 align:#left
	button 'btn11' "FBX导出的路径" pos:[19,520] width:136 height:42 align:#left
	button 'btn10' "清除全部选择" pos:[27,290] width:136 height:42 align:#left
	button 'btn12' "开始导出FBX" pos:[179,584] width:136 height:42 align:#left
	
	on maxfilePathbtn pressed do
		(
		filepath = (getSavePath caption:"Choose Directory for Scripts")
		if filepath!=undefined then (menu.maxfilepath.text = filepath)
		)
    
    on btn11 pressed do
		(
		filepath = (getSavePath caption:"Choose Directory for Scripts")
		if filepath!=undefined then (menu.fbxexportPath.text = filepath)
	
		)

    on btn8 pressed do
(		
	    theDialog = dotNetObject "System.Windows.Forms.OpenFileDialog"     --创建OpenFileDialog
        theDialog.title = "请选择SKIN文件"                                  --设置对话框的标题
        theDialog.Multiselect = true                                       --设置可以多选
        theDialog.Filter = "Max文件(*.max)|*.max|All Files (*.*)|*.*"       --过滤文件的类型
        theDialog.FilterIndex = 1                                           --设置默认的文件过滤下拉列表是"*.max"
        result = theDialog.showDialog()                                     --显示对话框 将选中结果赋值给变量result
        result.ToString()                                                   --关闭对话框后 将result转换成字符串
        result.Equals result.OK                                             --当按下OK 返回true
        result.Equals result.Cancel                                         --当按下Cancel 返回true
        theFilenames = theDialog.fileNames                                  --文件名最后以数组的方式返回

		if theFilenames[1]!=undefined then
		(
        menu.openMAXfile.text = theFilenames[1]
		)	
	
    loadMaxFile menu.openMAXfile.text  useFileUnit:true quiet:true

	
)		



on btn9 pressed do
(
	if selection.count ==0 then (messagebox "请选择要导出动画的控制器")
	else
	( 
		if selection.count != 0 then
		(
			for i in selection do
			(
				controler.items = append controler.items (i.name as string)
			)
		)
	)
	
)
					

on btn10 pressed do 
(
	
	controler.items = #()
	
)



on btn12 pressed do
(

	files = getFiles (menu.maxfilepath.text +"\\*.max") 

		sceneName = menu.fbxexportPath.text 
	
		for f =1 to files.count do
		(
			
			loadmaxfile files[f] quiet:true
			--layer = layermanager.getLayerFromName "_outPut"
			--layer.select true

			shuchuwutiji = #() 
							
							shiquwutiji = controler.items  
							
							if shiquwutiji.count >0 then
							(
								for rr=1 to shiquwutiji.count do
								(
									ls_huoquwuti = getnodebyname shiquwutiji[rr]
									if ls_huoquwuti != undefined then
									(
										append shuchuwutiji ls_huoquwuti 
									)
								)
							)
			
			

			
			select shuchuwutiji
			
			
			FBX_animation()
			Xrscenename = getFilenameFile maxFileName
			FileName = (sceneName as string)+"\\"+(Xrscenename as string)+".FBX"
			exportfile FileName   #noprompt selectedOnly:true using:FBXEXP

		)

			


	
)

)
createdialog menu