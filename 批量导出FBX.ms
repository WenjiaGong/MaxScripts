


try(DestroyDialog bbb)catch()


fn FBX_animation =
(
		
	FBXExporterSetParam "Animation" True 				--动画
	FBXExporterSetParam "ASCII" False
	--FBXExporterSetParam "AxisConversionMethod" None 	--轴向
	FBXExporterSetParam "Cameras" False					--摄像机
	FBXExporterSetParam "CAT2HIK" False						
	FBXExporterSetParam "ColladaTriangulate" False		--三角算法
	FBXExporterSetParam "Convert2Tiff" False 			--关于材质贴图
	FBXExporterSetParam "EmbedTextures" False  			--关于材质贴图
	FBXExporterSetParam "FilterKeyReducer" False 		--关于动画压缩
	FBXExporterSetParam "GeomAsBone" False 				--关于物体转化为骨骼
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
	FBXExporterSetParam "BakeAnimation" true --烘焙
	)


rollout bbb "批量导出FBX" width:444 height:546

(

	editText 'maxfilepath' "" pos:[153,40] width:187 height:18 align:#left
	label 'lbl7' "要导FBX的MAX文件放哪" pos:[8,41] width:116 height:20 align:#left
	editText 'openMAXfile' "" pos:[154,72] width:188 height:19 align:#left
	button 'btn8' "打开MAX文件" pos:[357,75] width:69 height:15 align:#left
	listBox 'controler' "要导出的控制器" pos:[162,102] width:175 height:19 align:#left
	button 'btn9' "确定选择这些控制器" pos:[357,154] width:68 height:52 align:#left
	button 'btn10' "清除重选" pos:[362,264] width:66 height:59 align:#left
	editText 'fbxexportPath' "" pos:[158,424] width:183 height:28 align:#left
	button 'btn11' "浏览" pos:[355,426] width:68 height:25 align:#left
	label 'lbl9' "导出的FBX放哪" pos:[56,430] width:77 height:23 align:#left
	label 'lbl10' "打开要批量导出的MAX文件" pos:[7,74] width:133 height:19 align:#left
	button 'btn12' "确定了，一键导出FBX" pos:[152,478] width:197 height:45 align:#left
	button 'maxfilePathbtn' "浏览" pos:[355,39] width:61 height:17 align:#left


on maxfilePathbtn pressed do(
	
	
				filepath = (getSavePath caption:"Choose Directory for Scripts")
					if filepath!=undefined then (
					bbb.maxfilepath.text = filepath 	)
	
					)


on btn11 pressed do(
	
	
				filepath = (getSavePath caption:"Choose Directory for Scripts")
					if filepath!=undefined then (
					bbb.fbxexportPath.text = filepath 	)
	
					)


on btn8 pressed do(		
	
	
theDialog = dotNetObject "System.Windows.Forms.OpenFileDialog" --create a OpenFileDialog
theDialog.title = "请选择SKIN文件" --set the title
theDialog.Multiselect = true --allow multiple files to be selected
theDialog.Filter = "HTML Files (*.html)|*.html|All Files (*.*)|*.*" --specify the filter
theDialog.FilterIndex = 2 --set the filter drop-down list to All Files
result = theDialog.showDialog() --display the dialog, get result into variable
result.ToString() --when closed, convert the result to string
result.Equals result.OK --returns TRUE if OK was pressed, FALSE otherwise
result.Equals result.Cancel --returns TRUE if Cancel was pressed, FALSE otherwise
theFilenames = theDialog.fileNames --the selected filenames will be returned as an array

if theFilenames[1]!=undefined then(
bbb.openMAXfile.text = theFilenames[1]
)	
	
loadMaxFile bbb.openMAXfile.text  useFileUnit:true quiet:true

	
)		



on btn9 pressed do(
	
	if selection.count ==0 then (messagebox "请选选择要导出动画的控制器")
	
	else
	( if selection.count != 0 then
			(
				for i in selection do
				(
					controler.items = append controler.items (i.name as string)
				)
			)
		)
	
	)
					


on btn10 pressed do (
	
	controler.items = #()
	
	)




on btn12 pressed do(

	
-- 	
-- 	
	files = getFiles (bbb.maxfilepath.text +"\\*.max") 


	
	
		
		sceneName = bbb.fbxexportPath.text 
	
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

 )createdialog bbb