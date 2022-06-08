rollout yunOfsWin "对冲工具" width:267 height:280
(
	groupBox 'grp1' "对冲对象设定" pos:[10,10] width:245 height:106 align:#left
	groupBox 'grp2' "轴向设定" pos:[10,138] width:245 height:56 align:#left
	checkbox 'yunOfsAxis_Z' "yunOfsAxis_Z" pos:[216,163] width:8 height:13 align:#left
	checkbox 'yunOfsAxis_Y' "yunOfsAxis_Y" pos:[141,163] width:13 height:13 align:#left
	checkbox 'yunOfsAxis_X' "yunOfsAxis_X" pos:[66,163] width:13 height:13 align:#left
	label 'lbl2' "X" pos:[51,162] width:16 height:11 align:#left checked:true 
	label 'lbl3' "Y" pos:[126,162] width:16 height:11 align:#left
	label 'lbl4' "Z" pos:[201,162] width:16 height:11 align:#left
	spinner 'yunOfsRotValue' "" pos:[27,229] width:90 height:16 enabled:true range:[-10,10,5] type:#float scale:0.1 align:#left
	groupBox 'grp4' "执行" pos:[10,202] width:245 height:64 align:#left
	button 'yunOfsGetObjA' "获取A" pos:[27,77] width:90 height:24 align:#left
	button 'yunOfsGetObjB' "获取B" pos:[145,77] width:90 height:24 enabled:true toolTip:"" align:#left
	editText 'yunOfsObjA' "" pos:[27,37] width:90 height:24 align:#left
	editText 'yunOfsObjB' "" pos:[145,37] width:90 height:24 align:#left
	button 'yunOfsRotDo' "旋转" pos:[145,218] width:90 height:42 align:#left

	on yunOfsWin open do 
	(if selection != undefined then (yunOfsWin.yunOfsObjA.text = 	selection[1].name	) )
	
	on yunOfsGetObjA pressed  do
		(if selection != undefined then (yunOfsWin.yunOfsObjA.text = 	selection[1].name	))
	on yunOfsGetObjB pressed  do
		(if selection != undefined then (yunOfsWin.yunOfsObjB.text = 	selection[1].name	))
	
	on yunOfsRotDo pressed  do 
		(
		
			objA = getNodeByName yunOfsWin.yunOfsObjA.text
			objB = getNodeByName yunOfsWin.yunOfsObjB.text
			rotValue = yunOfsWin.yunOfsRotValue.range[3]
			if yunOfsWin.yunOfsAxis_X.checked then
			(
			in coordsys world rotate objA (EulerAngles -rotValue 0 0)
			in coordsys world rotate  objB (EulerAngles (2*rotValue) 0 0)
			)
			if yunOfsWin.yunOfsAxis_Y.checked then
			(
			in coordsys world rotate objA (EulerAngles 0 -rotValue  0)
			in coordsys world rotate  objB (EulerAngles 0 (2*rotValue)  0)
			)
			if yunOfsWin.yunOfsAxis_Z.checked then
			(
			in coordsys world rotate objA (EulerAngles 0 0 -rotValue )
			in coordsys world rotate  objB (EulerAngles 0 0 (2*rotValue) )
			)

		)
)

createdialog yunOfsWin pos:[150,150]