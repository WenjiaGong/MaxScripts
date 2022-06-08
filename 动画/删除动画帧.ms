
rollout dr "Animat" 
(

	group "Bone_Del_Keys" 
	(
	checkbox 'Pos_chk' "位移" pos:[13,26] width:66 height:15 toolTip:"删除Bone移动帧" align:#left
	checkbox 'Rot_chk' "旋转" pos:[13,46] width:66 height:15 toolTip:"删除Bone旋转帧" align:#left
	checkbox 'Scale_chk' "缩放" pos:[13,66] width:66 height:15 toolTip:"删除Bone缩放帧" align:#left
	checkbox 'Sel_chk' "所选帧" pos:[13,86] width:66 height:15 toolTip:"删除Bone所选帧上的以上参数" align:#left
	button 'OK_btn' "删除" pos:[90,24] width:34 height:78 toolTip:"删除所选中的参数" align:#left
	)
		
	fn delRot a =
	(
		deselectKeys a
		selectKeys a.rotation.controller 
		deleteKeys a #selection 
	)
		
	fn delPos b =
	(
		deselectKeys b
		selectKeys b.pos.controller 
		deleteKeys b #selection 
	)
		
	fn delScale c =
	(
		deselectKeys c
		selectKeys c.scale.controller 
		deleteKeys c #selection 
	)
		
	
	on OK_btn pressed do
	(
		objKeys = selection as array
		undo on
		(
			if Sel_chk.checked then
			(
				if Rot_chk.checked  do			
				(
				for f = 1 to objKeys.count do (deleteKeys objKeys[f].rotation.controller #selection)
				)
					
				if Pos_chk.checked  do
				(
				for g = 1 to objKeys.count do (deleteKeys objKeys[g].pos.controller #selection)
				)
					
				if Scale_chk.checked  do
				(
				for h = 1 to objKeys.count do (deleteKeys objKeys[h].scale.controller #selection)
				)
			)
			else
			(
				if Rot_chk.checked  do			
				(
				for j = 1 to objKeys.count do delRot objKeys[j]
				)
					
				if Pos_chk.checked  do
				(
				for k = 1 to objKeys.count do delPos objKeys[k]
				)
					
				if Scale_chk.checked  do
				(
				for l = 1 to objKeys.count do delScale objKeys[l]
				)
			)
		)
	)
)
createDialog dr