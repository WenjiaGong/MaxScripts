rollout a "Distance Constraint" 
(
	local Source = undefined
	pickbutton btn01 "pick Constrainer" pos:[10,10] height:25 width:120
	
	button btn02 "On Chain" pos:[10,40] height:40
	checkbox chk02 "Bones" pos:[80,45]
	checkbox chk01 "Collide" pos:[80,65]
	
	spinner spn01 "size" pos:[10,95] range:[0.1,1000000.0,20.0]
	
	
	on btn01 picked o do
	(
		
		
			DistCnstr = attributes Dist
			(
				parameters main
					(
						vPos type:#point3 default:[0, 0, 0] animatable:false
						vDist type:#float default:20.0
						vPairNode type:#node
						initPos type:#point3 default:[0, 0, 0] animatable:false
						initOnOff type:#boolean animatable:false
					)
			)

			SP = $.pos
			sc = $.pos.controller = Position_Script()

			custAttributes.add sc DistCnstr
			
			dista = distance $.pos o.pos 
			$.pos.controller.Dist.vDist = dista
			$.pos.controller.Dist.vPos = SP

			$.pos.controller.addObject "TP" o
			$.pos.controller.script = 
"try (

if (normTime 0 == currentTime and this.Dist.initOnOff == true)

then (tPos = (this.Dist.initPos + this.Dist.vPairNode.transform.pos);this.Dist.vDist = length this.Dist.initPos)

else (tPos = ((normalize (this.Dist.vPos - TP.transform.pos)) * this.Dist.vDist) + TP.transform.pos)

this.Dist.vPos = tPos

tPos

) catch this.vPos"
		

		if chk02.checked == true then
		(
				B = boneSys.createBone o.pos $.pos  [0,0,1] 
				B.taper = 0
				B.wirecolor = green
				B.name = "B_Spring"
				B.rotation.controller = LookAt_Constraint ()
				B.rotation.controller.appendTarget $ 100    --Assign the target
				B.rotation.controller.viewline_length_abs = off
				B.rotation.controller.lookat_vector_length = 0
				B.rotation.controller.upnode_world = off
				B.rotation.controller.pickUpNode = o
				B.rotation.controller.StoUP_axis = 0
				B.rotation.controller.upnode_axis = 0
			
				B.position.controller = Position_Constraint()
				B.position.controller .appendTarget o 100    --Assign the target
		)
		
		select o
	)
	
	on spn01 changed state do
	(
		for i=2 to Source.count do
		(
			Source[i].size = state
		)
	)
	
	on btn02 pressed do
	(
		Source = selection as array
		for i=2 to Source.count do
		(
			Source[i].name = "P_Dist_"+ i as string
			Source[i].size = spn01.value
		)
		Source[1].name = "Ctrl_DistMaster"
		
			DistCnstr = attributes Dist
			(
				parameters main
					(
						vPos type:#point3 default:[0, 0, 0] animatable:false
						vDist type:#float default:20.0
						vPairNode type:#node
						initPos type:#point3 default:[0, 0, 0] animatable:false
						initOnOff type:#boolean animatable:false
						ALL type:#nodetab tabSizeVariable:true

					)
			)
			
			for i=2 to Source.count do
			(
				SP = Source[i].pos
				sc = Source[i].pos.controller = Position_Script()

				custAttributes.add sc DistCnstr
				
				dista = distance Source[i].pos Source[i-1].pos 
				Source[i].pos.controller.Dist.vDist = dista
				Source[i].pos.controller.Dist.vPos = SP
			)
		
			for i=2 to Source.count do
			(
				if chk01.checked==true then
				(
					TOUT = #()
					for o=2 to i do
					(
						if Source[o] != Source[i] then
						( append TOUT  Source[o] )
					)
					
					Source[i].pos.controller.Dist.ALL  = TOUT
				)
			)

		
		
		for i=2 to Source.count do
		(

			Source[i].pos.controller.addObject "TP" Source[i-1]
			
			scr = 
"try (

if (normTime 0 == currentTime and this.Dist.initOnOff == true)

then (tPos = (this.Dist.initPos + this.Dist.vPairNode.transform.pos);this.Dist.vDist = length this.Dist.initPos)

else 
("
			
if chk01.checked == true then 
(	scr +=
"			
	LIST = this.Dist.ALL
	for i=1 to LIST.count do
	(	
	
		--tPosB = ((normalize (this.Dist.vPos - LIST[i].transform.pos)) * 50) - LIST[i].transform.pos	
			
 		distB = distance this.Dist.vPos LIST[i].transform.pos
			
-- 		vecB = normalize (   LIST[i].transform.pos - this.Dist.vPos )
-- 		PO3 = if distB <20 then (LIST[i].transform.pos-(vecB*(distB-20 ) )) else LIST[i].transform.pos
-- 								
-- 		LIST[i].transform.pos = 	PO3
								
		vecC = normalize (   this.Dist.vPos - LIST[i].transform.pos )
		PO4 = if distB <(LIST[i].size/2) then (this.Dist.vPos-(vecC*(distB-(LIST[i].size/2) ) )) else this.Dist.vPos
								
		this.Dist.vPos = 	PO4
		
	)
"
)

scr +=
"	
	tPos = ((normalize (this.Dist.vPos - TP.transform.pos)) * this.Dist.vDist) + TP.transform.pos	
)


this.Dist.vPos = tPos 
tPos 

) catch this.vPos"



			Source[i].pos.controller.script = scr
		)
			
		Source[1].wirecolor = red
		Source[1].size = Source[1].size*2
		select Source[1]
		
		(--Create Bones
			if chk02.checked==true then
			(
				BON = #()
				for i =1 to (Source.count-1) do
				(
					B = boneSys.createBone Source[i].pos Source[i+1].pos [0,0,1] 
					B.taper = 0
					B.wirecolor = green
					B.name = "B_Spring_"+i as string
					append BON B
				)
				
				for i =2 to (BON.count) do --parent Bones
				(
					BON[i].parent = BON[i-1]
					BON[1].parent = Source[1]
				)
				
				for i =1 to (BON.count) do --LookAt Bones
				(
					BON[i].rotation.controller = LookAt_Constraint ()
					BON[i].rotation.controller.appendTarget Source[i+1] 100    --Assign the target
					BON[i].rotation.controller.viewline_length_abs = off
					BON[i].rotation.controller.lookat_vector_length = 0
					BON[i].rotation.controller.upnode_world = off
					BON[i].rotation.controller.pickUpNode = Source[i]
					BON[i].rotation.controller.StoUP_axis = 0
					BON[i].rotation.controller.upnode_axis = 0
					
					BON[i].position.controller = Position_Constraint()
					BON[i].position.controller .appendTarget Source[i] 100    --Assign the target
				)
			)
		)
	)
	
	
	
)
createdialog a height:120 width:150