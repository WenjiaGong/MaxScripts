(
vposCA = attributes vipos
(
	parameters main 
	(
	 	vpos 		type:#point3Tab tabSizeVariable:true animatable:false
	)	

)

sprboneCA = attributes sprbTM
(
	parameters main
	(
		boneTM	type:#matrix3
	)	

)

tool movevertex
(



)
rollout splineAnime "飘带解算 V0.9"
(
	spinner delaysp "硬度" type:#float scale:0.05 range:[0.01,1,0.3] align:#left height:20 width:60
	spinner loops "循环" type:#integer range:[0,100,0] align:#right height:20 width:50 offset:[5,-25] 
	spinner subs "子步" type:#integer range:[0,10,0] align:#left height:20 width:60
	spinner upspring "X弹簧" type:#float scale:0.05 range:[0.1,1,0.3] align:#right height:20 width:70 offset:[5,-25] 
	spinner bnum "骨骼数" type:#integer range:[0,1000,20] align:#left height:20 width:60

	group "样线条"
	(
	button resetspRp "粘贴" toolTip:"Select spline" align:#left height:20 width:50
	button setspRp "设置" toolTip:"Select spline" align:#left height:20 width:50 offset:[55,-25] 
	)
	group "骨骼"
	(
	button resetRp "粘贴" toolTip:"Select first bone" align:#left height:20 width:50
	button setRp "设置" toolTip:"Select first bone" align:#left height:20 width:50 offset:[55,-25] 
	button stretch "打直" align:#left height:20 width:50 offset:[110,-25] 
	)
	group "帧区域"
	(
	radiobuttons a1 labels:#("当前", "固定") align:#left width:80 height:20 --offset:[0,20]
	spinner aframestart type:#integer align:#left width:40 height:20 range:[-10000,100000,1] --offset:[105,-10] 
	spinner aframend "至" type:#integer align:#left width:50 height:20 offset:[45,-25] range:[0,100000,10]

	)

	group "应用"
	(
	button applyline "样线条" toolTip:"Select spline" align:#left height:20 width:40
	button applybone "骨骼" toolTip:"Select first bone" align:#left height:20 width:40 offset:[45,-25] 
	--checkbutton realt "Realtime" align:#left height:20 width:60 offset:[90,-25] 
	)

	on resetspRp pressed do (

		if selection.count == 0 do return root
		for shapes in selection do (
			if not isShapeObject shapes do return root
			if not isProperty shapes "vpos" do return root
			if shapes.parent == undefined do ( messageBox (((shapes.name as string)+" has no parent!")) ; continue)
			local num = 1
			print shapes as string
			for  i in 1 to (numSplines shapes) do (
				for j in 1 to (numKnots shapes i) do (
					local vertexctrl = getPointController shapes i ((j*3)-1)
					print vertexctrl as string
					deleteKeys vertexctrl #allKeys
					if shapes.vpos[num] != undefined do (
						 
						addnewkey vertexctrl slidertime
						vertexctrl.keys[1].value = shapes.vpos[num]*(shapes.parent.transform)*(inverse shapes.transform)-shapes.objectOffsetPos
						setKnotPoint shapes i j (shapes.vpos[num]*shapes.parent.transform-shapes.objectOffsetPos)
						--updateShape shapes
						--deleteKeys vertexctrl #allKeys
					)
					num += 1
				)
			)
		updateShape shapes
		)
	)

	on setspRp pressed do (
	if selection.count == 0 do return root
	for shapes in selection do (	
		if not isShapeObject shapes do continue
		if shapes.parent == undefined do ( messageBox (((shapes.name as string)+" has no parent!")) ; continue)
		if not isProperty shapes "vpos" then custAttributes.add shapes vposCA
		num = 1
		vertnum = 2
		for i in 1 to (numSplines shapes) do (	
			vn = 2	
			for j in 1 to (numKnots shapes i) do (
				animateVertex shapes vertnum			
				shapes.vpos[num] = (getKnotPoint shapes i j)*(inverse shapes.parent.transform)
				num += 1
				vn += 3
				vertnum +=3
			)
		)----end for i 
	)----end for shapes

	)

	on applyline pressed do (
	if selection.count == 0 do return root
	
	local setvpos = false
	local framestart,framend
	if a1.state == 1 then (
		framestart = animationRange.start
		framend = animationRange.end
	) else (
		framestart = aframestart.value as time
		framend = aframend.value as time
	)
	for shapes in selection do (	
		if not isShapeObject shapes do continue
		if shapes.parent == undefined do ( messageBox (((shapes.name as string)+" has no parent!")) ; continue)
		if not isProperty shapes "vpos" then
			(custAttributes.add shapes vposCA;setvpos=true)

		local delay = delaysp.value
		slidertime = framestart

		local pTM = shapes.parent.transform
		local shape_vertex_pos= #()
		local shape_vertex_TM= #()
		local preTimevertex_TM= #()
		local shape_splinenum = numSplines shapes
		dum = #()
		num = 1
		for i in 1 to shape_splinenum do (
			vertpos = #()
			vertTM = #()
			temp_TM = #()
			for j in 1 to (numKnots shapes i) do (
				append temp_TM  (matrix3 pTM.row1 pTM.row2 pTM.row3 (getKnotPoint shapes i j))
				if setvpos then (
				
					--append vertpos ((getKnotPoint shapes i j)*(inverse shapes.parent.transform))
					append vertpos (getKnotPoint shapes i j)
					append vertTM (matrix3 pTM.row1 pTM.row2 pTM.row3 ((getKnotPoint shapes i j)*(inverse shapes.parent.transform)) )
					shapes.vpos[num] = (getKnotPoint shapes i j)*(inverse shapes.parent.transform)
					num += 1
				)
				else (
					append vertpos (shapes.vpos[num]*shapes.parent.transform)
					append vertTM (matrix3 pTM.row1 pTM.row2 pTM.row3 (shapes.vpos[num]*shapes.parent.transform))
					--append vertpos (getKnotPoint shapes i j)
					--append vertTM (matrix3 pTM.row1 pTM.row2 pTM.row3 (getKnotPoint shapes i j))
					--dum[j] = dummy transform:(matrix3 pTM.row1 pTM.row2 pTM.row3 (getKnotPoint shapes i j))
					--dum[j].parent = chooseit.object
					--shapes.vpos[num] = getKnotPoint shapes i j
					num += 1
				)	
			)
			append shape_vertex_pos vertpos
			append shape_vertex_TM vertTM
			append preTimevertex_TM temp_TM
		)
		--preTimevertex_TM = deepcopy shape_vertex_TM

		-----create vertex controller and delete all keys
		vertexctrl = #()
		vertnum = 2
		for i in 1 to shape_splinenum do (
			vctrl = #()
			vn = 2
			for j in 1 to (numKnots shapes i) do (				
				animateVertex shapes vertnum
				vertctrl = getPointController shapes i vn

				--if numKeys vertctrl >0 then deleteKeys vertctrl #allKeys 
				/*
				for t = animationRange.start to animationRange.end do (
					index = getKeyIndex vertctrl t
					deleteKey vertctrl index
				)
				*/
				selectKeys vertctrl (interval framestart framend)
				deleteKeys vertctrl #selection
				append vctrl vertctrl
				vn += 3
				vertnum +=3
			--	execute ("shapes.Spline_"+(i as string)+"___Vertex_"+(j as string)+".controller=a")
			)
			append vertexctrl vctrl
		)
		
		--------start to calculate

		preTimeTM = pTM
		subframe = 1.0/(subs.value+1)
		for L = 0 to loops.value do (

		for t = framestart to framend by subframe do (
			if keyboard.escPressed then exit
			tf = ceil (t as float/TicksPerFrame)
			slidertime = tf
					
			for  i in 1 to shape_splinenum do (
				currentPTM = shapes.parent.transform
				
				--Point transform:currentPTM axistripod:on size:6.0 name:"aacurrentPTM"	
				vTM = pTM
				for j in 1 to (numKnots shapes i) do (
					vertTM = matrix3 vTM.row1 vTM.row2 vTM.row3 shape_vertex_pos[i][j]
					targetvertTM = vertTM*(inverse vTM)*currentPTM
					currentvertTM = preTimevertex_TM[i][j]
					tvector = normalize (targetvertTM.row4 - currentPTM.row4)
					cvector = normalize (currentvertTM.row4 - currentPTM.row4)
					v1 = normalize (cross cvector tvector)
					angel = acos(dot (normalize cvector) (normalize tvector))
					if j > 1 then angel = angel*(1.0-delay)
					else angel = 0

					aacurrentPTM = copy currentPTM
					transPTM = rotate currentPTM (quat angel v1) 
					transPTM.pos = currentPTM.pos = aacurrentPTM.pos
					transvertTM = vertTM*(inverse vTM)*transPTM
	
					if L == loops.value then (
						addnewkey vertexctrl[i][j] tf
						vertexctrl[i][j].keys[vertexctrl[i][j].keys.count].value = (transvertTM*(inverse shapes.transform)).position-shapes.objectOffsetPos
					)
					else
						--setKnotPoint shapes i j (transvertTM*(inverse shapes.transform)).position
						setKnotPoint shapes i j transvertTM.position
						
					if j<=(numKnots shapes i) do (
						vTM = matrix3 pTM.row1 pTM.row2 pTM.row3 shape_vertex_pos[i][j]
						currentPTM = transvertTM
						preTimevertex_TM[i][j] = transvertTM
						
					)
				)	
			)----end for i
			updateShape shapes
		)----end for t
		)----end for Loops
	)-----end for spobj
	completeRedraw()
	)-----end on 


	on applybone pressed do with undo on (
		
	local bones=#()
	if selection.count == 0 do return root
	local framestart,framend
	if a1.state == 1 then (
		framestart = animationRange.start
		framend = animationRange.end
	) else (
		framestart = aframestart.value as time
		framend = aframend.value as time
	)

	local bone_TM = #()
	local preTimebone_TM = #()
	bonectrl_x = #()
	bonectrl_y = #()
	bonectrl_z = #()
	bipctrl = #()
	posctrller = #()
	scaletrller = #()
	delay = delaysp.value

	for bone in selection do (
		local bonechain = #()
		local bonetype = classof bone
		local num = 1
		slidertime = framestart
		if superClassOf bone == shape do continue --or (bonetype != BoneGeometry and bonetype != Biped_Object) do continue
		if bone.parent == undefined do ( messageBox (((bone.name as string)+"must have parent!")) ; continue)

		local parnode = bone.parent
		while bone!=undefined do (
			bonechain[num] = bone
			childfind = false
			if bone.children.count == 0 or num>bnum.value then exit
			else (
				for c in bone.children do
					if  classof c == bonetype or classof c == Dummy then (bone = c;num += 1 ;childfind = true;exit)
					else continue
				if childfind == false do bone = undefined
			)
		)----end while
		--print bonechain as string
		append bones bonechain

		local pTM = parnode.transform
		local preTM = #()
		local bTM = #()

		for j in 1 to bonechain.count do (
		--	preTimebone_TM[j] = bonechain[j].transform
			append preTM bonechain[j].transform
			if not isProperty bonechain[j] "boneTM" then (
				CustAttributes.add bonechain[j] sprboneCA
				bonechain[j].boneTM = bonechain[j].transform*(inverse bonechain[j].parent.transform)
			)
			append bTM bonechain[j].boneTM
		)
		append preTimebone_TM preTM
		append bone_TM bTM
		
		-----get bone rotate controller and delete keys
		bipc = #()
		
		if bonetype == Biped_Object do (
			for j in 1 to bonechain.count do 	
				append bipc bonechain[j].controller
		 	append bipctrl bipc		
		)


	)----end for bone
	
	if bones.count ==0 do return root

-----------------------start to calculate---------------

		subframe = 1.0/(subs.value+1)
		for L = 0 to loops.value do (
		
		for t = framestart to framend by subframe do (
			if keyboard.escPressed then exit
			tf = ceil (t as float/TicksPerFrame)
			slidertime = tf
		
		for i in 1 to bones.count do (
			currentPTM = at time (t as float/TicksPerFrame) bones[i][1].parent.transform
			
			for j in 1 to (bones[i].count-1) do (
			
				targetboneTM = bone_TM[i][j]*currentPTM
				currentboneTM = preTimebone_TM[i][j]
				currentboneTM.pos  = preTimebone_TM[i][j+1].pos

				----------Roll spring-------------
				ang1 = acos(dot (normalize preTimebone_TM[i][j].row1) (normalize targetboneTM[1]))
				newTM = copy preTimebone_TM[i][j]
				newTM1 = copy preTimebone_TM[i][j]
				tpos = targetboneTM.pos
				vt1 = normalize (cross preTimebone_TM[i][j].row1 targetboneTM[1])
					
				if abs ang1 >0.001 do rotate newTM1 (quat ang1 -vt1) 
			
				newTM.pos = tpos
				newTM1.pos = tpos

				angY1 = acos(dot (normalize newTM1[2]) (normalize targetboneTM[2]))	
				ssvt = cross (normalize newTM1[2]) (normalize targetboneTM[2])

				xaxisdelay = (upspring.value + ((bones[i].count-1.0-j)/(bones[i].count-1.0)*(1.0-upspring.value)) )
				angY1 = angY1 * xaxisdelay
				if dot ssvt targetboneTM[1] >0 do angY1 = -angY1
				if abs angY1 >0.001 do rotate newTM1 (quat angY1 targetboneTM[1]) 
				newTM1.pos = tpos
				targetboneTM = copy newTM1

				---------------------------------------				
				tvector = normalize targetboneTM[1]
				cvector = normalize (currentboneTM.pos - targetboneTM.pos)
				vt = normalize (cross cvector tvector)
				angel = acos(dot (normalize cvector) (normalize tvector))

				--if j < 5 do angel = subFrameCheck j bones bonetype bone_TM preTimebone_TM (t-1f) angel vt
				
				angel = angel*(1.0-delay)
				
				aacurrentPTM = copy targetboneTM
				transPTM = rotate targetboneTM (quat angel vt) 
				transPTM.pos = targetboneTM.pos = aacurrentPTM.pos
				
				animate on
				(
					if classof bones[i][j] == Biped_Object then 
						biped.setTransform bones[i][j] #rotation transPTM.rotation true
					else if classof bones[i][j] == CATBone then
						bones[i][j].transform = copy transPTM
					else bones[i][j].rotation.controller.value = transPTM.rotation *(inverse currentPTM.rotation)
					
					if L == loops.value then
						if classof bones[i][j] == Biped_Object and mod (t as float/TicksPerFrame) 1 == 0 do
							biped.setTransform bones[i][j] #rotation transPTM.rotation true

				)-----end animate on


				currentPTM = preTimebone_TM[i][j] = transPTM

				if j == (bones[i].count-1) do (
				preTimebone_TM[i][j+1].pos =  bone_TM[i][j+1].pos*transPTM
				--bonelength = length bone_TM[i][j+1].pos
				--preTimebone_TM[i][j+1].pos =  transPTM.pos + ((normalize transPTM[1])*bonelength)		
				)

			)-----end for j	
		)----end for bones
		)----end for t
		)----end for Loops

	)
	on resetRp pressed do (

--	if selection.count == 0 do return root

	for bone in selection do (
		local bonetype = classof bone
		if superClassOf bone == shape do continue
		--if bonetype != Biped_Object do return root
		if bone.parent == undefined do return root
		local bones=#()
		local num = 1
		while bone!=undefined do (
			bones[num] = bone
			childfind = false
			if bone.children.count == 0 then exit
			else (
				for c in bone.children do
					if  classof c == bonetype or classof c == Dummy then (bone = c;num += 1 ;childfind = true;exit)
					else continue
				if childfind == false do bone = undefined
			)
		)----end while
		
		for b in bones do 
			if isProperty b "boneTM" do (
				animate on
				(
					if classof b == CATBone then (
						--posctrller = copy b.position.controller
						--scaletrller = copy b.scale.controller
						b.transform = b.boneTM*b.parent.transform
						--b.position.controller = posctrller
						--b.scale.controller = scaletrller
					) else if classof b == Biped_Object then biped.setTransform b #rotation (b.boneTM*b.parent.transform).rotation true
					else b.rotation.controller.value = b.boneTM.rotation
				)
			)
	)----end for bone
	)

	on setRp pressed do (
	
	for bone in selection do (

		local bonetype = classof bone
		if superClassOf bone == shape do continue
		--if bonetype != BoneGeometry and bonetype != Biped_Object do return root
		if bone.parent == undefined do return root
		local bones=#()
		local num = 1
		while bone.children.count > 0 do (
			
			for c in bone.children do 
				if  classof c == bonetype or classof c == Dummy then (
					if num == 1 then append bones bone
					append bones c
					bone = c
					num +=1
					exit
				)	else continue
		)

		for b in bones do (
			if not isProperty b "boneTM" then CustAttributes.add b sprboneCA
				b.boneTM = b.transform*(inverse b.parent.transform)
		)
		
	)
	
	)
	on stretch pressed do with undo on (
		
	for bone in selection do (
		if bone.children.count == 0 do return root
		bone = bone.children[1]
		bonetype = classof bone
		if superClassOf bone == shape do continue
		--if bonetype != BoneGeometry and bonetype != Biped_Object do return root
		if bone.parent == undefined do return root
		local bones=#()
		local num = 1
		while bone!=undefined do (
			bones[num] = bone
			childfind = false
			if bone.children.count == 0 then exit
			else (
				for c in bone.children do
					if  classof c == bonetype or classof c == Dummy then (bone = c;num += 1 ;childfind = true;exit)
					else continue
				if childfind == false do bone = undefined
			)
		)----end while
		for b in bones do (
			if bonetype == Biped_Object then 
				biped.setTransform b #rotation b.parent.transform.rotation true
			else (
				c = copy b.parent.transform
				c.pos = b.transform.position
				b.transform = c
			)
		)
	)---end for bone
	)
	
	on realt changed state do with undo on (
	if state == true then startTool movevertex prompt:"Hello!"
	else stopTool movevertex

	)
	on splineAnime open do (
		aframestart.value = animationRange.start
		aframend.value = animationRange.end
	)
)

theNewFloater = newRolloutFloater "Spring Magic V0.8" 210 350
addRollout splineAnime theNewFloater
)