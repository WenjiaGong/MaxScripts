rollout m2u "in2Unity3D" width:200 height:176
(
	button btn1 "Start" pos:[8,112] width:184 height:24
	progressBar pb3 "Skining" pos:[8,144] width:184 height:8 color:(color 0 200 180)
 	fn pppp obj =	superclassof obj == GeometryClass --PolyMeshObject
	pickbutton btn3 "Pick Animated Object" pos:[8,80] width:184 height:24 filter:pppp
	spinner spn1 "" pos:[96,8] width:96 height:16 range:[-1e+006,1e+006,0] type:#integer scale:1
	spinner spn2 "" pos:[96,32] width:96 height:16 enabled:true range:[-1e+006,1e+006,0] type:#integer scale:1
	label lbl3 "Step: " pos:[8,56] width:88 height:16 enabled:true
	spinner spn3 "" pos:[96,56] width:96 height:16 enabled:true range:[1,1e+006,2] type:#integer scale:1
	label lbl1 "From: " pos:[8,8] width:88 height:16
	label lbl2 "To: " pos:[8,32] width:88 height:16 enabled:true
	hyperLink hplink "v1.5.1 by Artyom Abgaryan" pos:[66,160] width:144 height:16 color:green hoverColor:red address:"mailto:artyomabgaryan@gmail.com"
	
	global myo
	global clone
	global points = #()
	global pr_value
	global added_EPoly = false
	local animStart
	local animEnd
	local myStep
	
	local enabled = true
	
	on m2u open do
	(
		pr_value = 0.0
		added_EPoly = false
		btn1.enabled = false
		animStart = animationRange.start
		animEnd = animationRange.end
		spn1.value = animStart
		spn2.value = animEnd
		myStep = spn3.value
		
		if enabled != true then
		(
			animEnd = animStart + 15
			spn2.value = animEnd
		)
	)
	
	on btn1 pressed do
	(
		-- Pick Button
		pb3.value = 0
		
		if classof myo != PolyMeshObject then
		(
			if added_EPoly != true then 
			(
				addModifier myo (Edit_Poly())
				added_EPoly = true
			)
		)
		
		for i = 1 to polyOp.getnumVerts myo do
		(
			vt = polyop.getVert myo i
			points[i] = Point pos: [vt.x, vt.y, vt.z] name: ("s_v_" + (i as string)) size: 2.0
				
			-- ProgressBar
			pr_value =pr_value + 20 * i / (polyOp.getnumVerts myo)
			pb3.value = pr_value
		)
		
		-- Animate
		
		--sliderTime = animStart
		
		delta = animEnd - animStart
		--Set Animate On
		--vLevel = viewport.GetRenderLevel()
		--viewport.SetRenderLevel #wireFrame
		--maxOps.setKeyMode = true
		stepIndex = 0
		
		for i=animStart to animEnd by myStep do
		(
			stepIndex = stepIndex + 1
			print stepIndex
			for j=1 to myo.numverts do
			(
				-- Get J-th Vertex
				vt = at time i polyop.getvert myo j
				
				-- Cache Vert's Pos
				
				addnewkey points[j].position.controller i
				
				points[j].position.x_position.controller.keys[stepIndex].value = vt.x
				points[j].position.y_position.controller.keys[stepIndex].value = vt.y
				points[j].position.z_position.controller.keys[stepIndex].value = vt.z
			)
			--stepIndex +=spn3.value as integer
			--sliderTime +=1
			--sliderTime +=1
			--pr_value =
			--pb3.value = (stepIndex as float) / (delta as float)
			--print (delta as float)
		)
		--maxOps.setKeyMode = false
		--Set Animate Off
		--viewport.SetRenderLevel vLevel
		
		--sliderTime = animStart
		
		--Animate
		
		maxOps.CloneNodes myo newNodes:&kk
		clone = kk[1]
		
		convertTo clone Editable_Mesh
		
		addModifier clone (Skin())
		select clone
		modPanel.setCurrentObject clone.modifiers[#Skin]
		
		sk = clone.modifiers[1]

		for i = 1 to polyOp.getnumVerts myo do
		(
			print i
			--Add Each Point As Bone
			skinOps.addBone sk points[i] 0
		)
		
		for i = 1 to ((clone.numVerts) - 1 )  do
		(
			--Setup Vertex Weights For Each Bone
			skinOps.SetVertexWeights  sk i i 1.0
		)
		
		jjj = clone.numVerts
		
		for i = 1 to (jjj)  do
		(
			skinOps.SetVertexWeights  sk i i 1.0
		)
		
		if added_EPoly then
		(
			deleteModifier myo 1
			added_EPoly = false
		)
		hide myo
	)
	on btn3 picked obj do
	(
		if obj != undefined then
		(
			btn1.enabled = true
			btn3.text = obj.name
			myo = obj
		)
		else
		(
			btn1.enabled = false
		)
	)
	on spn1 changed val do
	(
		animStart = val
		
		if enabled != true then
		(
			animEnd = animStart + 15
			spn2.value = animEnd
		)
	)
	on spn2 changed val do
	(
		animEnd = val
		
		if enabled != true then
		(
			animEnd = animStart + 15
			spn2.value = animEnd
		)
	)
	on spn3 changed val do
	(
		myStep = val
	)
	on btn5 pressed do
	(
		
	)
)

createdialog m2u