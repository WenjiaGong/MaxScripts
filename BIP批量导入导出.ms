
try(DestroyDialog aaa)catch()


		

	
	
	
	

rollout aaa "BIP批量导出导入_by_队长别开枪" width:540 height:645
(
	button 'btn3' "确定好路径一键导出BIP！" pos:[203,244] width:116 height:39 align:#left
	editText 'edt5' "" pos:[180,74] width:262 height:41 align:#left
	button 'btn4' "导入BIP保存为MAX文件" pos:[194,560] width:116 height:39 align:#left
	label 'lbl1' "要导出BIP的MAX文件放哪" pos:[14,78] width:144 height:22 align:#left
	editText 'edt6' "" pos:[179,131] width:261 height:41 align:#left
	
	editText 'skinLujing'  pos:[40,398  ]width:261 height:22 align:#left
	button 'skinLujingBtn' "选择SKIN文件" pos:[300,398] width:116 height:19 align:#left
	
	label 'lbl2' "导出的BIP存在哪" pos:[12,134] width:113 height:22 align:#left
	editText 'edt7' "" pos:[192,421] width:261 height:41 align:#left
	editText 'edt8' "" pos:[193,491] width:261 height:41 align:#left
	label 'lbl3' "要导的BIP文件放在哪" pos:[12,450] width:127 height:22 align:#left
	label 'lbl4' "导好BIP的MAX文件放哪" pos:[30,510] width:127 height:22 align:#left
	label 'lbl5' "导出BIP" pos:[274,33] width:58 height:34 align:#left
	label 'lbl6' "导入BIP" pos:[258,357] width:58 height:34 align:#left
	button 'btn5' "浏览" pos:[454,83] width:43 height:24 toolTip:"" align:#left
	button 'btn6' "浏览" pos:[456,141] width:41 height:26 align:#left
	button 'btn7' "浏览" pos:[467,428] width:34 height:26 align:#left
	button 'btn8' "浏览" pos:[466,499] width:36 height:25 align:#left


    on btn5 pressed do

    (
		filepath = (getSavePath caption:"Choose Directory for Scripts")
		if filepath!=undefined then (
		aaa.edt5.text = filepath 	)
		
	)

	
	
	on btn6 pressed do

    (
		filepath_bipsave = (getSavePath caption:"Choose Directory for Scripts")
		if filepath_bipsave!=undefined then (
		aaa.edt6.text = filepath_bipsave 	)
		
	)
	
	
	on btn3 pressed do(
		
		
	
	
	files = getFiles (aaa.edt5.text +"\\*.max") 

 for f=1 to files.count do (
	
	loadMaxFile files[f]  useFileUnit:true quiet:true
	if  $Bip001==undefined then (messagebox "请检查CS骨架系统是以Bip001命名的！") 
	else
	(
	biped_ctrl=$Bip001.controller
	buffer=filterstring files[f] "."
	filename=buffer[1]+".bip"	
	
	maxFileName
	buffer=filterstring maxFileName "."
	filename=aaa.edt6.text+"\\"+buffer[1]+".bip"	
	biped.saveBipFile  biped_ctrl filename 
		
	)		
	
		)	
						)	
	
	
	
	
	on btn7 pressed do

    (
		filepath_skin = (getSavePath caption:"Choose Directory for Scripts")
		
		if filepath_skin != undefined then(
			
	
		aaa.edt7.text = filepath_skin 	)
		
	)
	
	
	on btn8 pressed do

    (
		filepath_maxsave = (getSavePath caption:"Choose Directory for Scripts")
		
		if  filepath_maxsave != undefined then(
		aaa.edt8.text = filepath_maxsave)	
		
	)
	

	on skinLujingBtn pressed do
	(
		
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
aaa.skinLujing.text = theFilenames[1]
	)	
		
		
		
		
		loadMaxFile aaa.skinLujing.text  useFileUnit:true quiet:true
		
		
		
	)
	
	
	
	
	
	
	on btn4 pressed do
	
(
	

	files_bip = getFiles (aaa.edt7.text +"\\*.bip")

	if  files_bip.count==0 then (messagebox "请确定文件路径里有BIP文件")
	else
	(
		for f=1 to files_bip.count do (	
			loadMaxFile(aaa.skinLujing.text)  useFileUnit:true quiet:true
			if  $Bip001==undefined then (messagebox "请检查CS骨架系统是以Bip001命名的！")			
			else
			(
				biped_ctrl=$Bip001.controller
				biped.loadBipFile  biped_ctrl files_bip[f]  
			)
			buffer=filterstring files_bip[f] "."
			buffer2=filterstring buffer[1] "\\"			
			filename=aaa.edt8.text+"\\"+buffer2[buffer2.count]+".max"
			saveMaxFile filename	
		)	
	)

)



	
	)

createdialog aaa
