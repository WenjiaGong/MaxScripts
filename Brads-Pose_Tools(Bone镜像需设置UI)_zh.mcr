macroScript Pose_Tools
category:"Brads"
tooltip:"Copy/Paste Transforms"
Icon:#("Systems",3)
/*
To do:
- XYZ radio buttons could be checkboxes.
- Issues with bones.
*/
(
local PoseToolsRO
local copyPaste
local pasteOptions
local bufferTM = #()
try (destroyDialog PoseToolsRO) catch()
buttonW = 150
buttonH = 30

fn mirrorMatrixFn \
axis:"x" 				/*(Axis to mirror over)*/
flip:"x" 				/*(Axis to flip)*/
tm:(matrix3 1) 			/*(Matrix to mirror)*/
pivotTm:(matrix3 1) 	/*(Matrix to mirror around)*/
=						/*By Mike Biddlecombe and Paul Neale.  I'm just ripping it off!*/
(
	fn FetchReflection a =
	(
		case a of
		(
			"x": [-1,1,1]  -- reflect in YZ plane
			"y": [1,-1,1]  --         in ZX plane
			"z": [1,1,-1]  --         in XY plane
			"xy": [-1,-1,1]
			"yz": [1,-1,-1]
			"xz": [-1,1,-1]
			"xyz": [-1,-1,-1]
		)
	)

	aReflection = scalematrix (FetchReflection axis)
	fReflection = scalematrix (FetchReflection flip)

	fReflection * (tm * (inverse pivotTm)) * aReflection * pivotTm
)

rollout PoseToolsRO "Bone镜像工具" width:188 height:100
(
	subrollout PoseSubRO "Pose Tools" width:180 height:313 pos:[4,4]
	on PoseToolsRO close do bufferTM = #()
)

rollout copyPaste "复制/粘贴"
(
	button copyPose "复制姿势" width:buttonW height:buttonH
	button pastePose "粘贴姿势" width:buttonW height:buttonH offset:[1,0] tooltip:"Note: Pasting is based on order of selection" enabled:false
	
	on copyPose pressed do
	(
		bufferTM = #()
		if selection.count > 0 then
		(
			pastePose.enabled = true
			if (pasteOptions.posOptions.state == 2 or pasteOptions.rotOptions.state == 2) then flipChosen = true else flipChosen = false
			pasteOptions.affectPos.enabled 		= pastePose.enabled
			if pasteOptions.affectPos.checked then pasteOptions.posOptions.enabled = pastePose.enabled
			pasteOptions.affectRot.enabled 		= pastePose.enabled
			if pasteOptions.affectRot.checked then pasteOptions.rotOptions.enabled = pastePose.enabled
			pasteOptions.flipWorld.enabled 		= flipChosen
			if not pasteOptions.flipWorld.checked then pasteOptions.flipObj.enabled = flipChosen
			pasteOptions.flipAxisRadio.enabled 	= flipChosen
			pasteOptions.upAxisCheck.enabled 	= flipChosen
			if pasteOptions.upAxisCheck.checked then pasteOptions.upAxisRadio.enabled = flipChosen
			for i in selection do
			(
				append bufferTM i.transform
			)
		)
	)
	
	on pastePose pressed do
	(
		if (pasteOptions.affectPos.checked or pasteOptions.affectRot.checked) then
		(
			if not (pasteOptions.flipWorld.checked) and not (isvalidnode pasteOptions.flipObj.object) then
			(
				messagebox "Please pick an object to flip around." title:"Error:"
			)
			else
			(
				selArray = selection as array
				if bufferTM.count != selArray.count then
				(
					if bufferTM.count == 1
					then (errorText = "The transform of 1 object is in the clipboard.\n\n")
					else (errorText = "The transforms of " + bufferTM.count as string + " objects are in the clipboard.\n\n")
					
					if selArray.count == 1
					then (errorText += "         You have 1 object selected.")
					else (errorText += "         You have " + selArray.count as string + " objects selected.")
					
					messagebox errorText title:"Selection mismatch:"
					selArray = #()
				)
				else
				(
					undo "Paste transform" on
					(
						for i = 1 to selArray.count do
						(
							pastePosition = selArray[i].pos
							parentInArray = false
							posLocked = false
							for j = 1 to selArray.count do -- run through selection array and find if an object within it is the object's parent
							(
								if selArray[i].parent == selArray[j] then parentInArray = true
							)
							if ((getTransformLockFlags selArray[i])[1]) or ((getTransformLockFlags selArray[i])[2]) or ((getTransformLockFlags selArray[i])[3]) then posLocked = true
							if pasteOptions.posOptions.state == 1 then posFlip = false else posFlip = true
							if pasteOptions.rotOptions.state == 1 then rotFlip = false else rotFlip = true
							if pasteOptions.affectPos.checked and (not parentInArray) and (not posLocked) then
							(
								if posFlip then
								(
									if pasteOptions.flipWorld.checked then
									(
										case pasteOptions.flipAxisRadio.state of
										(
											1: (pastePosition = [ -bufferTM[i].translation[1],  bufferTM[i].translation[2],  bufferTM[i].translation[3] ])
											2: (pastePosition = [  bufferTM[i].translation[1], -bufferTM[i].translation[2],  bufferTM[i].translation[3] ])
											3: (pastePosition = [  bufferTM[i].translation[1],  bufferTM[i].translation[2], -bufferTM[i].translation[3] ])
										)
									)
									else
									(
										case pasteOptions.flipAxisRadio.state of
										(
											1: mirrorTM = (mirrorMatrixFn axis:"x" flip:"x" tm:bufferTM[i] pivottm:pasteOptions.flipObj.object.transform)
											2: mirrorTM = (mirrorMatrixFn axis:"y" flip:"y" tm:bufferTM[i] pivottm:pasteOptions.flipObj.object.transform)
											3: mirrorTM = (mirrorMatrixFn axis:"z" flip:"z" tm:bufferTM[i] pivottm:pasteOptions.flipObj.object.transform)
										)
										pastePosition = mirrorTM.translation
									)
								)
								else pastePosition = bufferTM[i].translation
							)
							if pasteOptions.affectRot.checked then -- if affect rotation is on
							(
								if rotFlip then
								(
									case pasteOptions.flipAxisRadio.state of
									(
										1: flipAxis = "x"
										2: flipAxis = "y"
										3: flipAxis = "z"
									)
									case pasteOptions.upAxisRadio.state of
									(
										1: upAxis = "x"
										2: upAxis = "y"
										3: upAxis = "z"
									)
									if pasteOptions.flipWorld.checked then
									(							
										selArray[i].transform = (mirrorMatrixFn axis:flipAxis flip:upAxis tm:bufferTM[i] pivottm:(matrix3 1))
									)
									else
									(							
										selArray[i].transform = (mirrorMatrixFn axis:flipAxis flip:upAxis tm:bufferTM[i] pivottm:pasteOptions.flipObj.object.transform)
									)
									if not posFlip then selArray[i].pos = pastePosition
								)
								else
								(
									selArray[i].transform = (matrix3 (bufferTM[i].row1) (bufferTM[i].row2) (bufferTM[i].row3) pastePosition)
								)
							)
							else selArray[i].pos = pastePosition
						)
					)
				)
			)
		)
	)
	
	on copyPaste rolledUp state do
	(
		if state == true then
		(
			PoseToolsRO.height += 82
			PoseToolsRO.PoseSubRO.height += 82
		)
		else
		(
			PoseToolsRO.height -=82
			PoseToolsRO.PoseSubRO.height -=82
		)
	)
)

rollout pasteOptions "粘贴选项" width:400
(
	checkbox affectPos "位置设置" checked:true align:#left enabled:false
	radiobuttons posOptions labels:#("克隆", "镜像") align:#right enabled:false
	checkbox affectRot "旋转设置" checked:true enabled:false
	radiobuttons rotOptions labels:#("克隆", "镜像") align:#right enabled:false
	group "翻转:"
	(
		checkbox flipWorld "世界坐标" align:#left offset:[0,0] checked:true enabled:false
		pickbutton flipObj "拾取对象" width:90 offset:[-15,2] enabled:false autodisplay:true
		label AxisLabel "翻转轴:" align:#left offset:[15,2]
		radiobuttons flipAxisRadio labels:#("X","Y","Z") columns:3 align:#left offset:[59,-18] default:1 enabled:false
		checkbox upAxisCheck "参考轴:" align:#left offset:[0,2] enabled:false
		radiobuttons upAxisRadio labels:#("X","Y","Z") columns:3 align:#left offset:[59,-18] default:1 enabled:false
	)
	
	on affectPos changed state do (posOptions.enabled = affectPos.checked)
	
	on posOptions changed state do
	(
		if (posOptions.state == 2 or rotOptions.state == 2) then flipChosen = true else flipChosen = false
		flipWorld.enabled 		= flipChosen
		if not flipWorld.checked then flipObj.enabled = flipChosen
		flipAxisRadio.enabled 	= flipChosen
		upAxisCheck.enabled 	= flipChosen
		if upAxisCheck.checked then pasteOptions.upAxisRadio.enabled = flipChosen
	)

	on affectRot changed state do (rotOptions.enabled = affectRot.checked)

	on rotOptions changed state do
	(
		if (posOptions.state == 2 or rotOptions.state == 2) then flipChosen = true else flipChosen = false
		flipWorld.enabled 		= flipChosen
		if not flipWorld.checked then flipObj.enabled = flipChosen
		flipAxisRadio.enabled 	= flipChosen
		upAxisCheck.enabled 	= flipChosen
		if upAxisCheck.checked then pasteOptions.upAxisRadio.enabled = flipChosen
	)

	on flipWorld changed state do (flipObj.enabled = not flipWorld.checked)

	on flipAxisRadio changed state do
	(
		if not upAxisCheck.checked then	upAxisRadio.state = flipAxisRadio.state
	)
	
	on upAxisCheck changed state do
	(
		if state == off then upAxisRadio.state = flipAxisRadio.state
		upAxisRadio.enabled = upAxisCheck.checked
	)
	
	on flipObj picked obj do
	(
		if obj != undefined then flipWorld.checked = false
	)
	
	on pasteOptions rolledUp state do
	(
		if state == true then
		(
			PoseToolsRO.height += 184
			PoseToolsRO.PoseSubRO.height += 184
		)
		else
		(
			PoseToolsRO.height -= 184
			PoseToolsRO.PoseSubRO.height -= 184
		)
	)
)
	
createdialog PoseToolsRO
addsubrollout PoseToolsRO.PoseSubRO copyPaste
addsubrollout PoseToolsRO.PoseSubRO pasteOptions
)