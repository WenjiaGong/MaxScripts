if leftBone == undefined then global leftBone=#()
if rightBone == undefined then global rightBone=#()

try(destroydialog mirrorBoneAni)catch()
rollout mirrorBoneAni "镜像骨骼动画（仅对Bone有效）"
(
	HyperLink note1 "注意1：要使用本工具，骨骼必须进行Freeze Transform！" color:red enabled:false pos:[0,5]
	HyperLink note2 "注意2：请确定你在做Freeze Transform之前骨骼是对称的Pose！" color:red enabled:false pos:[0,20]
	button setLeftBone "指定为K帧骨骼" width:300 pos:[0,40] height:30
	pickbutton setRightBone "指定为镜像骨骼" width:300 pos:[300,40] height:30
	listBox leftBoneName "K帧的骨骼:" width:300 height:30 pos:[0,70]
	listBox rightBoneName "自动计算的骨骼:" width:300 height:30 pos:[300,70]
	button setmirror "关连" width:300 pos:[0,490] height:30
	button destroymirror "取消关连并转成关键帧动画" width:300 pos:[300,490] height:30

	on setLeftBone pressed do
	(
		if leftBone.count!=0 then
		(
			if (querybox "已经设置过镜像骨骼，重新指定将会丢失原来的镜像信息，要继续吗？")
			then
			(
				leftBone=#();rightBone=#()
				for i in selection do (append leftBone i.name;append rightBone "未指定")
				leftBoneName.items = leftBone;rightBoneName.items = rightBone
			)
		)
		else
		(
			leftBone=#();rightBone=#()
			for i in selection do (append leftBone i.name;append rightBone "未指定")
			leftBoneName.items = leftBone;rightBoneName.items = rightBone
		)
	)
	
	on setRightBone picked obj do
	(
		if leftBoneName.selection != 0
		then
		(
			rightBone[leftBoneName.selection] = obj.name
			rightBoneName.items = rightBone
		)
	)
	
	on leftBoneName selected value do (rightBoneName.selection = value;try(select (getnodebyname leftBone[value]))catch())
	on rightBoneName selected value do leftBoneName.selection = value
	
	on setmirror pressed do
	(
		persistent global leftBone;persistent global rightBone
		for i=1 to rightBone.count do
		(
			tempLeftNode = getnodebyname leftBone[i]
			tempRightNode = getnodebyname rightBone[i]
			if(tempLeftNode==undefined )
			then messagebox (leftBone[i] +" 这个骨骼没有找到！")
			else
			(
				if tempRightNode==undefined
				then messagebox (rightBone[i] +" 这个骨骼没有找到！")
				else
				(
					if( (classof tempLeftNode.rotation.controller) == rotation_list and tempLeftNode.rotation.controller.count ==2 and tempLeftNode.rotation.controller[2].name=="Zero Euler XYZ")
					then
					(
						tempRightNode.rotation.controller.Zero_Euler_XYZ.controller.xrotation.controller = float_script ()
						scriptText = stringStream ""
						format "dependsOn (mirrorNode = (getnodebyname \"%\"))\nif mirrorNode!=undefined then (degtorad -mirrorNode.rotation.controller.Zero_Euler_XYZ.controller.xrotation) else 0" leftBone[i] to:scriptText
						tempRightNode.rotation.controller.Zero_Euler_XYZ.controller.xrotation.controller.script = scriptText as string
						
						tempRightNode.rotation.controller.Zero_Euler_XYZ.controller.yrotation.controller = float_script ()
						scriptText = stringStream ""
						format "dependsOn (mirrorNode = (getnodebyname \"%\"))\nif mirrorNode!=undefined then (degtorad -mirrorNode.rotation.controller.Zero_Euler_XYZ.controller.yrotation) else 0" leftBone[i] to:scriptText
						tempRightNode.rotation.controller.Zero_Euler_XYZ.controller.yrotation.controller.script = scriptText as string
						
						tempRightNode.rotation.controller.Zero_Euler_XYZ.controller.zrotation.controller = float_script ()
						scriptText = stringStream ""
						format "dependsOn (mirrorNode = (getnodebyname \"%\"))\nif mirrorNode!=undefined then (degtorad mirrorNode.rotation.controller.Zero_Euler_XYZ.controller.zrotation) else 0" leftBone[i] to:scriptText
						tempRightNode.rotation.controller.Zero_Euler_XYZ.controller.zrotation.controller.script = scriptText as string
					)
					else messagebox (leftBone[i] +" 和 "+rightBone[i] + " 骨骼没有进行Freeze Transform！不能镜像动画！\n请先确保它们是对称的Pose，然后对骨骼Freeze Transform后再进行操作！")
				)
			)
		)
	)

	
	
	
	on destroymirror pressed do
	(
		for i=1 to rightBone.count do 
		(
			tempLeftNode = getnodebyname leftBone[i]
			tempRightNode = getnodebyname rightBone[i]
			
			if( (classof tempRightNode.rotation.controller) == rotation_list and tempRightNode.rotation.controller.count ==2 and tempRightNode.rotation.controller[2].name=="Zero Euler XYZ")
			then
			(
				tempRightNode.rotation.controller.Zero_Euler_XYZ.controller.xrotation.controller = bezier_float ()
				tempRightNode.rotation.controller.Zero_Euler_XYZ.controller.yrotation.controller = bezier_float ()
				tempRightNode.rotation.controller.Zero_Euler_XYZ.controller.zrotation.controller = bezier_float ()
			)
			else
			(
				tempRightNode.rotation.controller.xrotation.controller = bezier_float ()
				tempRightNode.rotation.controller.yrotation.controller = bezier_float ()
				tempRightNode.rotation.controller.zrotation.controller = bezier_float ()
			)
			
			for b in tempLeftNode.rotation.controller.Zero_Euler_XYZ.controller.xrotation.controller.keys do addnewkey tempRightNode.rotation.controller.Zero_Euler_XYZ.controller.xrotation.controller b.time
			for b in tempLeftNode.rotation.controller.Zero_Euler_XYZ.controller.yrotation.controller.keys do addnewkey tempRightNode.rotation.controller.Zero_Euler_XYZ.controller.yrotation.controller b.time
			for b in tempLeftNode.rotation.controller.Zero_Euler_XYZ.controller.zrotation.controller.keys do addnewkey tempRightNode.rotation.controller.Zero_Euler_XYZ.controller.zrotation.controller b.time
			
			animbuttonstate = true
			for b in tempLeftNode.rotation.controller.Zero_Euler_XYZ.controller.xrotation.controller.keys do at time b.time tempRightNode.rotation.controller.Zero_Euler_XYZ.controller.xrotation = -tempLeftNode.rotation.controller.Zero_Euler_XYZ.controller.xrotation
			for b in tempLeftNode.rotation.controller.Zero_Euler_XYZ.controller.yrotation.controller.keys do at time b.time tempRightNode.rotation.controller.Zero_Euler_XYZ.controller.yrotation = -tempLeftNode.rotation.controller.Zero_Euler_XYZ.controller.yrotation
			for b in tempLeftNode.rotation.controller.Zero_Euler_XYZ.controller.zrotation.controller.keys do at time b.time tempRightNode.rotation.controller.Zero_Euler_XYZ.controller.zrotation = tempLeftNode.rotation.controller.Zero_Euler_XYZ.controller.zrotation
			animbuttonstate = false
		)
	)
	
	on mirrorBoneAni open do(leftBoneName.items = leftBone;rightBoneName.items = rightBone)
	
)
createdialog mirrorBoneAni 600 520