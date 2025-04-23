
(
	rollout hidden "过滤工具V3.0" width:176 height:230
(
	GroupBox '显示列表' "显示列表：" pos:[6,3] width:163 height:220 align:#left
 
	button 'Btn_skeleton' "骨骼物体" pos:[13,21] width:75 height:20 toolTip:"隐藏或显示骨骼物体 " align:#left
	label 'lbl1' "未隐藏" pos:[105,25] width:40 height:15 enabled:false align:#left
 
	button 'Btn_Helpers' "虚拟物体" pos:[13,41] width:75 height:20 toolTip:"隐藏或显示虚拟物体" align:#left
	label 'lbl2' "未隐藏" pos:[105,45] width:40 height:15 enabled:false align:#left
	
	button 'Btn_Selected' "当前选择" pos:[13,61] width:75 height:20 toolTip:"隐藏或显示被选择的物体" align:#left
	label 'lbl3' "未隐藏" pos:[105,65] width:40 height:15 enabled:false align:#left
	
	button 'Btn_Allobjects' "全部物体" pos:[13,81] width:75 height:20 toolTip:"隐藏或显示场景中的物体" align:#left
	label 'LBL4' "未隐藏" pos:[105,85] width:40 height:15 enabled:false align:#left
	
	--button 'Btn_Freeze' "冻结模型" pos:[13,101] width:75 height:20 toolTip:"只针对poly和mesh" align:#left
	--label 'LBL5' "" pos:[105,105] width:40 height:15 enabled:false align:#left
	checkbutton 'Fz_Mdl' "冻结模型" pos:[13,101] width:75 height:20 toolTip:"只针对poly和mesh" align:#left
	label 'LBL6' "冻结开关" pos:[101,105] width:56 height:15 align:#left
	
	checkbutton 'Hide_Bone' "Bone" pos:[13,121] width:75 height:20 toolTip:"隐藏或显示Bone骨骼 " align:#left
	label 'LBL7' "单独隐藏" pos:[100,125] width:54 height:15 align:#left
	
	checkbutton 'Hide_Biped' "Biped" pos:[13,141] width:75 height:20 toolTip:"隐藏或显示Biped骨骼 " align:#left
	label 'LBL8' "单独隐藏" pos:[101,145] width:55 height:15 align:#left
--	checkbutton 'Hide_Dummy' "Dummy" pos:[13,161] width:75 height:20 toolTip:"隐藏或显示虚拟体 " align:#left
	
	checkbutton 'Hide_Mob' "Mob" pos:[13,161] width:75 height:20 toolTip:"隐藏或显示模型 " align:#left
	label 'LBL9' "当前模型" pos:[101,165] width:53 height:15 align:#left
	
	button 'hide_Boneend' "隐藏末端" pos:[13,181] width:75 height:20 toolTip:"  隐藏所有Bone骨骼的末端骨骼" across:2 align:#left
	label 'LBL5' "Bone骨骼" pos:[101,185] width:53 height:15 align:#left
	
	button 'Hide_Nub' "Nub" pos:[13,201] width:75 height:20 toolTip:"隐藏或显示Nub" align:#left
	label 'lbl10' "未隐藏" pos:[105,205] width:40 height:15 enabled:false align:#left

	/*
	on Btn_Freeze pressed do 
	(
		objFreeze=#()
		for i in objects do 
		if classof i == Editable_mesh or classof i == Editable_Poly do append objFreeze i
		if objFreeze.count > 0 do
		if objFreeze[1].isfrozen == true then Unfreeze objFreeze (LBL5.text="未冻结") else freeze objFreeze (LBL5.text="已冻结")
	)*/

fn check_hide_scene =
(
	for i in objects do
	(
		if Hide_Bone.state == true then(if classof i == BoneGeometry do(hide i))else(if classof i == BoneGeometry do(unhide i))
		if Hide_Biped.state == true then(if classof i == Biped_Object do(hide i))else(if classof i == Biped_Object do(unhide i))
--		if Hide_Dummy.state == true then(if classof i == Point or classof i == Dummy do(hide i))else(if classof i == Point or classof i == Dummy do(unhide i))
		if Hide_Mob.state == true then(if classof i == editable_mesh or classof i == editable_poly or classof i == PolyMeshObject or classof i == Plane do(hide i))else(if classof i == editable_mesh or classof i == editable_poly or classof i == PolyMeshObject or classof i == Plane do(unhide i))
	)
)
/*
on Hide_Dummy changed thestate do
	(
	if hideByCategory.helpers == true then(hideByCategory.helpers = false)else()
	check_hide_scene()
	)
*/
	fn findEnds arr = ---选择末端
	(
		ends = for i in arr where (i.children.count == 0) collect i
		return ends
	)
	
	

	on Btn_skeleton pressed do
	(
		biparray=#()
		for i in helpers do
		if classof i.controller == BipSlave_Control do i.ishidden = on
		for i in objects do 
		if classof i==biped_object or classof i == BoneGeometry do append biparray i
		if biparray.count >0 do 
		if biparray[1].isHidden == true then unhide biparray (LBL1.text="未隐藏") else hide biparray (LBL1.text="已隐藏")
	)
	on Btn_Helpers pressed do
	(
	if helpers.count > 0  do
	if Helpers[1].isHidden == true then unHide Helpers (LBL2.text="未隐藏") else Hide Helpers (LBL2.text="已隐藏")
	)
	on Btn_Selected pressed do
	(
		(
		if selection.count > 0  do
		if $selection[1].isHidden == true then unHide $selection (LBL3.text="未隐藏") else Hide $selection (LBL3.text="已隐藏")				
		)
	)
	on Btn_Allobjects pressed do
	(
	if objects.count > 0  do
	if objects[1].isHidden == true then unHide objects (LBL4.text="未隐藏")(LBL3.text="未隐藏")(LBL2.text="未隐藏")(LBL1.text="未隐藏") else Hide objects (LBL4.text="已隐藏")(LBL3.text="已隐藏")(LBL2.text="已隐藏")(LBL1.text="已隐藏")
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
	on Hide_Bone changed thestate do
	(
	if hideByCategory.bones == true then(hideByCategory.bones = false)else()
	check_hide_scene()
	)
	on Hide_Biped changed thestate do
	(
	if hideByCategory.bones == true then(hideByCategory.bones = false)else()
	check_hide_scene()
	)
	on Hide_Mob changed thestate do
	(
	if hideByCategory.geometry == true then(hideByCategory.geometry = false)else()
	check_hide_scene()
	
	)
	on hide_Boneend pressed do
	(		undo on
		(
			clearSelection()--清除当前场景节点选择。
			for x in objects do
			(
				if (classOf x.baseObject) == boneGeometry do
				(
					selectMore x --将指定的节点添加到当前选择项。
				)
				if (classOf  x == XRefObject)  and (classof x.actualBaseObject  == BoneGeometry) then
				(
					selectMore x
				)
			)
		)	
		ends = findEnds selection
		hide ends
	)
	on Hide_Nub pressed do
	(
	if helpers.count > 0  do
	if $*Nub*[1].isHidden == true then unHide $*Nub* (LBL10.text="未隐藏") else Hide $*Nub* (LBL10.text="已隐藏")
	)
)

	rollout About_other "关于" width:162 height:150
	(
		label 'aboutTool' "关于工具:" pos:[3,1] width:78 height:39 enabled:false align:#left
		
		label 'b' "2020-05-15" pos:[60,37] width:70 height:17 enabled:false align:#left
		label 'c' "如对功能不了解，可将鼠标悬停在按钮上，查看功能说明。" pos:[20,56] width:150 height:51 enabled:false align:#left
		label 'd' "如有建议和想法可联系作者。" pos:[20,81] width:146 height:33 enabled:false align:#left
		
		HyperLink 'link_a' "作者:柳公子" pos:[55,114] width:110 height:16 address:"(右键点击复制qq:276147115)" color:(color 209 154 95) hovercolor:(color 0 222 255) visitedcolor:(color 0 0 192) align:#left
		
		on link_a rightClick do
		(
		setClipBoardText "276147115")
	)

AllRollout = newRolloutFloater "AnimationTool" 200 285	
addRollout hidden AllRollout
addRollout About_other AllRollout

hidden.open =true
About_other.open = false

	)



