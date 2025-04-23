/*
此脚本用于整体缩放带骨骼的角色场景，主要使用max自带的Rescale World Unites功能
但对于 MAX 普通 bone 的缩放不正常现象进行了修正

白严宾
2017.10

v1.0
- 首个可正常工作版本
*/


linkColor = (color 0 250 200)
try(DestroyDialog Rollout_StdToolsForBoneAndCS) catch()
Rollout Rollout_StdToolsForBoneAndCS "场景缩放 v1.0" width:175
(


	--label ScaleBipedAndCsInfo "选择要缩放的骨骼" align:#Left
	spinner spnScaleValue "设置缩放值" range:[0.002,10000,1.0] align:#Left
	button Resize_btn "执行" width:100 align:#Center
--     label b1 "-=" across:4 align:#Center
--     label byb "白严宾 2017.10" across:2 align:#Center
    hyperLink web "animbai.com" color:linkColor hoverColor:linkColor visitedColor:linkColor address:"http://animbai.com/zh/" align:#Center
--     label b2 "=-" across:3 align:#Center


	Fn rescaleScene scaleFactor = (
		undo "Create End" on (
			newEndBoneLst = #()
			boneChildren = #()
			boneObjs = #()

			bipParent = undefined


			-- Creat end bone for all regular bone to make sure they can scale properly 
			boneObjs = for obj in objects where ((ClassOf obj) as string) == "BoneGeometry" collect obj
			if boneObjs.count > 0 then ( -- pick all bone obj
				for obj in boneObjs do (
					boneChildren = for child in obj.children where ((ClassOf child) as string) == "BoneGeometry" collect child
					if boneChildren.count == 0 then ( -- do with none bone-child bone
						with Animate Off (  --with Animate Off bracket open
							local parentBone  = obj
							local parentTrans = parentBone.transform
							local parentPos   = parentTrans.translation
							local newbone


							newBone=BoneSys.createBone parentPos (parentPos+6) parentBone.dir
							newBone.transform = parentTrans
							in coordSys Local move newBone [parentBone.length,0,0]

							newBone.parent	= parentBone
							append newEndBoneLst newBone

							newBone.width	 = parentBone.width
							newBone.height	= parentBone.height
							newBone.taper	 = 90
							newBone.length	= (parentBone.width+parentBone.height)/2
							newBone.wirecolor = parentBone.wirecolor
						) -- with Animate Off bracket close
					)
				)
			)

			-- do scale
			rescaleWorldUnits scaleFactor

			-- restretch regular bones to fix skin issue
			for obj in objects where ((ClassOf obj) as string) == "BoneGeometry" do (
				obj.resetBoneStretch()
			)
			delete newEndBoneLst

			-- move CS bip01 horizontal position to match scale
			-- check if has cs bone, and record cs controller
			bipedBone = for obj in objects where classOf obj == Biped_Object collect obj
			biped_ctrl = undefined
			if bipedBone.count > 0 then (
			    for obj in bipedBone do (
			        try  -- in case twist bone will cause error
			        -- to find biped01
			        if (obj.transform.controller) as string == "Controller:Body" then (
			            -- get biped controller for operation
			            biped_ctrl = obj.transform.controller
			            -- get bip01 node
						biped_ctrl.moveAllMode = true
						bipNode = biped.getNode biped_ctrl #horizontal 
						-- in case of bip01 has parent that cannot move with moveAllMode
						bipParent = bipNode.parent
						if bipParent != undefined then (
							bipNode.parent = undefined
						)
						-- get original pos
						oriPos = biped.getTransform bipNode #pos
						-- newScaleFactor = 0.5 + 0.5*scaleFactor -- movement value in moveAllMode works in a  stupid relative way
						newPos = [oriPos[1]*scaleFactor,oriPos[2]*scaleFactor,oriPos[3]]

						-- move
						biped.setTransform bipNode #pos newPos false
						biped_ctrl.moveAllMode = false
						-- restore parent
						if bipParent != undefined then (
							bipNode.parent = bipParent
						)
			        )
			        catch()
			    )
			)
			clearSelection()
			redrawViews()

		)
	)
	on Resize_btn pressed do (
		currentSelection = #()
		for obj in selection do ( append currentSelection obj )
		rescaleScene spnScaleValue.value
		select currentSelection
	)
)


createDialog Rollout_StdToolsForBoneAndCS


-- code for extra process

-- linkObjs = for i in $Objects where classOf i.controller == Link_Constraint collect i

-- for obj in linkObjs do(
-- 	if iskindof obj BoneGeometry then(
-- 		obj.boneEnable = false
-- 	)
-- 	linkNode = ( obj.controller.getNode 1 )
-- 	obj.Transform.controller = prs()
-- 	obj.parent = linkNode
-- )