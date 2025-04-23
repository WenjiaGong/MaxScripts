rollout a "Realtime Spring" 
(
	edittext edt01 "name:"
	button btn01 "apply on Points" pos:[10,30] height:30 width:100
	
	spinner spn01 "From:" pos:[10,80] range:[0.01,0.60,0.3]
	button btn02 "Randomize Sel" pos:[10,100] height:20 width:100
	
	button btn03 "Bake" pos:[10,130] height:20 width:100
	button btn04 "UnBake" pos:[10,150] height:20 width:100
	
	on btn02 pressed do
	(
		Source = selection as array
		for i=1 to Source.count do
		(
			RANDO =  random spn01.value 0.6
			Source[i].modifiers[#Attribute_Holder].SpringCtrl.Tns = RANDO
			Source[i].modifiers[#Attribute_Holder].SpringCtrl.Dmp = RANDO*2
			
			reName = filterstring Source[i].name "_"
			Tous = execute("$"+reName[1]+"_P_Spring_*")
			for o=1 to Tous.count do
			(
				Tous[o].modifiers[#Attribute_Holder].SpringCtrl.Tns = RANDO
				Tous[o].modifiers[#Attribute_Holder].SpringCtrl.Dmp = RANDO*2
			)
		)
	)
	
	on btn01 pressed do
	(
		max create mode
		Source = selection as array
		Source.wirecolor = blue
		Source.box = false
		Source.Cross = true
		
		for i=1 to Source.count do --rename Sources
		(
			Source[i].name = (edt01.text+"_P_Base_"+i as string)
		)
		
		PTS = #()
		for i=2 to Source.count do
		(
			Source[2].parent = Source[1]
			
			PS = Point pos:[0,0,0] isSelected:off name:(edt01.text+"_P_Spring_"+i as string) box:on cross:off wirecolor:yellow size:Source[i].size
			PS.transform = Source[i].transform
			append PTS PS
		)
		
		
		
		(--create Bones
			BON = #()
			for i =1 to (Source.count-1) do
			(
				B = boneSys.createBone Source[i].pos Source[i+1].pos [0,0,1] 
				B.taper = 0
				B.taper = 0
				B.wirecolor = green
				B.name = edt01.text+"_B_Spring_"+i as string
				append BON B
			)
			
			for i =2 to (BON.count) do --parent Bones
			(
				BON[i].parent = BON[i-1]
			)
			BON[1].parent = Source[1]
			
			for i =1 to (BON.count) do --LookAt Bones
			(
				BON[i].rotation.controller = LookAt_Constraint ()
				BON[i].rotation.controller.appendTarget PTS[i] 100    --Assign the target
				BON[i].rotation.controller.viewline_length_abs = off
				BON[i].rotation.controller.lookat_vector_length = 0
				BON[i].rotation.controller.upnode_world = off
				BON[i].rotation.controller.pickUpNode = Source[i+1]
				BON[i].rotation.controller.StoUP_axis = 2
				BON[i].rotation.controller.upnode_axis = 2
			)
		)
		
		for i =3 to Source.count do --Parent SourcePoints
		(
			Source[i].parent = BON[i-2]
		)
		
		Source[1].size = Source[2].size*2
		Source[1].wirecolor = red
		Source[1].box = true
		Source[1].cross = true
		Source[1].name = (edt01.text+"_Ctrl_SpringMaster")
		
		select Source[1]
				modPanel.addModToSelection (EmptyModifier ()) ui:on
				ca=attributes SpringCtrl
				(
					 parameters NewSlider rollout: SpringCtrl
					(
						Tns type: #float ui:(spn01)
						Dmp type: #float ui:(spn02)
						ONOFF type:#boolean ui:(btn01)
					)	
					rollout SpringCtrl "Ctrl IK"
					(	
						checkbutton btn01 "ON" pos:[10,10] width:100 height:20 highlightColor:green
						spinner spn01 "Tension:"  pos:[10,40] width:100 range:[0.0,10.0,0.2] 
						spinner spn02 "Damping:"  pos:[10,70] width:100 range:[0.0,10.0,0.2]  		

						on spn01 changed state do
						(
							reName = filterString $.name "_"
							All = execute("$"+reName[1]+"_P_Spring_*")	
							for i=1 to All.count do
							(
								All[i].modifiers[#Attribute_Holder].SpringCtrl.Tns = state
							)
						)
						
						on spn02 changed state do
						(
							reName = filterString $.name "_"
							All = execute("$"+reName[1]+"_P_Spring_*")	
							for i=1 to All.count do
							(
								All[i].modifiers[#Attribute_Holder].SpringCtrl.Dmp = state
							)
						)
						
						on btn01 changed state do
						(
							if state==true then (btn01.text = "ON")
								else (btn01.text = "OFF")
						)
					

					
					)
				)
				custAttributes.add $.modifiers[1] ca
				clearSelection()
				Source[1].modifiers[#Attribute_Holder].SpringCtrl.Tns = 0.3
				Source[1].modifiers[#Attribute_Holder].SpringCtrl.Dmp = 0.6
				Source[1].modifiers[#Attribute_Holder].SpringCtrl.onOff = on
					
		
		for i =1 to PTS.count do
		(
			select PTS[i]
				modPanel.addModToSelection (EmptyModifier ()) ui:on
				ca=attributes SpringCtrl
				(
					 parameters NewSlider rollout: SpringCtrl
					(
						Tns type: #float ui:(spn01)
						Dmp type: #float ui:(spn02)
					)	
					rollout SpringCtrl "Ctrl IK"
					(	
						spinner spn01 "Tension:"  pos:[10,10] width:100 range:[0.0,10.0,0.2] 
						spinner spn02 "Damping:"  pos:[10,40] width:100 range:[0.0,10.0,0.2]  						
					)
				)
				custAttributes.add $.modifiers[1] ca
				clearSelection()
				PTS[i].modifiers[#Attribute_Holder].SpringCtrl.Tns = 0.3
				PTS[i].modifiers[#Attribute_Holder].SpringCtrl.Dmp = 0.6
			
			PO = PTS[i].pos				
				
			nodeStoreCA = attributes nodeStore attribID:#(0x5df52ec4, 0x76fcba8b)
			( parameters main 
				( 
					vPos type:#point3 default:[0, 0, 0] animatable:false
					vVel type:#point3 default:[0, 0, 0] animatable:false
					vTime type:#float default:0.0 animatable:false
				) 
			)
			sc = PTS[i].pos.controller = Position_Script()
			custAttributes.add sc nodeStoreCA 
			
			PTS[i].pos.controller.nodeStore.vPos = PO
			
			
			PTS[i].pos.controller.addObject "A" Source[i+1]
			PTS[i].pos.controller.addTarget "Tension" PTS[i].modifiers[#Attribute_Holder].SpringCtrl[#Tns]
			PTS[i].pos.controller.addTarget "Damping" PTS[i].modifiers[#Attribute_Holder].SpringCtrl[#Dmp]
			PTS[i].pos.controller.addTarget "ONOFF" Source[1].modifiers[#Attribute_Holder].SpringCtrl[#onOff]
			
			scr = "if ONOFF == true then
(
try (
tTime = timeStamp () / 25

diff = abs (tTime - this.vTime)

if diff >= 1 then (

this.vTime = tTime

tVec = (A.pos - this.vPos) * Tension
tPos = this.vPos + tVec + this.vVel

this.vPos = tPos

this.vVel = (tVec + this.vVel) * (1.0 - Damping)

tPos

)
else this.vPos
) catch [0, 0, 0]
)
else A.pos
"
			
			PTS[i].pos.controller.script = scr
			
			--PTS[i].rotation.controller = Orientation_Constraint ()
			--PTS[i].rotation.controller.appendTarget Source[i+1] 100    --Assign the target
		)
		
		
		
	)
	
	on btn03 pressed do
	(
		Source = execute("$*"+edt01.text+"_P_Spring_"+"*")

		PTS = #()

		for i=1 to Source.count do
		(
			P = Point pos:(Source[i].pos) isSelected:off size:0
			append PTS P
		)
			
		set animate on
			
		for t=animationRange.start to animationRange.end do
		(
			slidertime = t
			
			for i=1 to Source.count do
			(
				PTS[i].pos = Source[i].pos
			)
			
		)

		for i=1 to Source.count do
		(
			Source[i].pos.controller = position_XYZ()
			--deletemodifier Source[i] 1
		)



		for t=animationRange.start to animationRange.end do
		(
			slidertime = t
			

			for i=1 to Source.count do
			(
				 Source[i].pos = PTS[i].pos
			)
			
		)
		
		delete PTS
-- 		delete (execute("$*"+edt01.text+"_P_Base_"+"*"))
-- 		deletemodifier (execute("$"+edt01.text+"_Ctrl_SpringMaster")) 1
			
	)
	
	
	on btn04 pressed do
	(
		PTS = execute("$*"+edt01.text+"_P_Spring_"+"*")
		
		DAD = execute("$"+edt01.text+"_Ctrl_SpringMaster")
		
		
		
		for i=1 to PTS.count do
		(
			PO = PTS[i].pos				
				
			nodeStoreCA = attributes nodeStore attribID:#(0x5df52ec4, 0x76fcba8b)
			( parameters main 
				( 
					vPos type:#point3 default:[0, 0, 0] animatable:false
					vVel type:#point3 default:[0, 0, 0] animatable:false
					vTime type:#float default:0.0 animatable:false
				) 
			)
			sc = PTS[i].pos.controller = Position_Script()
			custAttributes.add sc nodeStoreCA 
			
			PTS[i].pos.controller.nodeStore.vPos = PO
			
			Source = (execute("$"+edt01.text+"_P_Base_"+((i+1) as string)))
			PTS[i].pos.controller.addObject "A" Source
			PTS[i].pos.controller.addTarget "Tension" PTS[i].modifiers[#Attribute_Holder].SpringCtrl[#Tns]
			PTS[i].pos.controller.addTarget "Damping" PTS[i].modifiers[#Attribute_Holder].SpringCtrl[#Dmp]
			PTS[i].pos.controller.addTarget "ONOFF" DAD.modifiers[#Attribute_Holder].SpringCtrl[#onOff]
			
			scr = "if ONOFF == true then
(
try (
tTime = timeStamp () / 25

diff = abs (tTime - this.vTime)

if diff >= 1 then (

this.vTime = tTime

tVec = (A.pos - this.vPos) * Tension
tPos = this.vPos + tVec + this.vVel

this.vPos = tPos

this.vVel = (tVec + this.vVel) * (1.0 - Damping)

tPos

)
else this.vPos
) catch [0, 0, 0]
)
else A.pos
"
			
			PTS[i].pos.controller.script = scr
		)

	)
	
	
)
createdialog a height:180 width:120