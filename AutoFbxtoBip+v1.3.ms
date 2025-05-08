try destroydialog AutoFbxtoBip catch()
try destroydialog rollout_title2 catch()
(
global fbone4=#()
global bone_all_name3=#()
rollout fbxtobip_zven "AutoFbxtoBip" width:170 height:185
(
	checkbox ck1 "替换名称" pos:[22,13] checked:true  align:#left
	checkbox ck2 "替换蒙皮" pos:[103,13] checked:true  align:#left
	checkbox ck3 "导入动画"  checked:false  align:#center offset:[10,0]
	button conversion2 "Fbx转Bone" width:96 height:33 toolTip:"请选择骨骼和模型" align:#center 
	button conversion "一键Fbx转Bip" width:98 height:37  align:#center 
	hyperLink lianjie "作者:子墨[z.ven]" address:"https://www.bilibili.com/video/av91815514" color:(color 7 254 254) hoverColor:(color 0 255 255) visitedColor:(color 7 254 254) width:110 height:16 align:#center offset:[12,0]
	hyperLink lianjie2 "QQ交流群:330875128" address:"https://jq.qq.com/?_wv=1027&k=0yXAQJqA" color:(color 7 254 254) hoverColor:(color 0 255 255) visitedColor:(color 7 254 254)  width:110 height:16 align:#center offset:[5,0]
	progressbar progBar  pos:[5,172] width:178 height:7 color:blue 

	fn Export_animtion nodes =
    (
		select nodes
		FBXExporterSetParam  "Animation" true
		FBXExporterSetParam "BakeAnimation" true
		makeDir (GetDir #maxroot + "\\Scripts\\AutofbxtoBip")
		global file_path=(GetDir #maxroot + "\\Scripts\\AutofbxtoBip\\"+"Autofbxtobip_ani.FBX")
		exportFile file_path  #noPrompt selectedOnly:true using:#FBXEXP
	)
	fn GetallChildren nodes =
    (
    	local nodeArray = #()
    	for i in nodes do append nodeArray i
		nodeArray
    )

	fn Re_Tpose Model_nub =
	(
		max modify mode
		local tpose_name=#()
		local tpose_pose=#()
		local root_pose
		local root_node
		local allChildren=#()
		for i=1 to Model_nub.count do(
			_skin=Model_nub[i].modifiers[#Skin]
			modPanel.setCurrentObject _skin
			skinbone_count=skinops.getnumberbones _skin
			for ii=1 to skinbone_count do(
				a=skinOps.GetBoneName  _skin ii 0
				index=finditem tpose_name a
				if index==0 do(
					append tpose_name a
					append tpose_pose (skinUtils.GetBoneBindTM Model_nub[i] (getNodeByName a))
					if (matchpattern a pattern:"*Bip*Pelvis*") do (
						root_pose=(skinUtils.GetBoneBindTM Model_nub[i] (getNodeByName a))
						try (
							root_node=(getNodeByName a).parent
							)catch (
							messagebox "缺少根骨骼"
							)
						)
				)
			)
		)
		if root_node !=undefined do(
			root_node.transform=root_pose
			rotate root_node (eulerangles 0 0 90)
			rotate root_node (eulerangles 90 0 0)
			allChildren= GetallChildren root_node 
			for i=1 to allChildren.count do (
				index=finditem tpose_name allChildren[i].name
				if index!=0 do(
					animate on
					at time 0(
					allChildren[i].transform=tpose_pose[index]
					)
				)
			)
		)
	)
	fn Re_Tpose2 Model_nub nod=
	(
		max modify mode
		local tpose_name=#()
		local tpose_pose=#()
		local root_pose
		local root_node
		local allChildren=#()
		for i=1 to Model_nub.count do(
			_skin=Model_nub[i].modifiers[#Skin]
			modPanel.setCurrentObject _skin
			skinbone_count=skinops.getnumberbones _skin
			for ii=1 to skinbone_count do(
				a=skinOps.GetBoneName  _skin ii 0
				index=finditem tpose_name a
				if index==0 do(
					append tpose_name a
					append tpose_pose (skinUtils.GetBoneBindTM Model_nub[i] (getNodeByName a))
				)
			)
		)
			for i=1 to nod.count do (
				index=finditem tpose_name nod[i].name
				if index!=0 do(
					animate on
					at time 0(
					nod[i].transform=tpose_pose[index]
					)
				)
			)
	)
	fn fbxtobip =
	(
		global Bip_nub=#()
		global Model_nub=#() 
		global Fbx_allbone=#() 
		global Fbx_allbone_name=#() 
		global Fbx_bip_ff=#() 
		global Fbx_bip_name_f=#() 
		global Fbx_bip=#()
		global Fbx_bip_name=#()
		global	Fbx_bip_pos=#() 
		global New_bip_f=#()
		global	New_bip_name_f=#() 
		global New_allbip=#() 
		global New_bip=#()
		global New_bip_name=#() 
		local  New_bip_pos=#() 
		local 	Must_bip=#(
					"*Bip*Pelvis*","*Bip*Spine*","*Bip*Neck*","*Bip*Head*",
					"*Bip*L*Clavicle*","*Bip*L*UpperArm*","*Bip*L*Forearm*","*Bip*L*Hand*",
					"*Bip*R*Clavicle*","*Bip*R*UpperArm*","*Bip*R*Forearm*","*Bip*R*Hand*",
					"*Bip*L*Thigh*","*Bip*L*Calf*","*Bip*L*Foot*",
					"*Bip*R*Thigh*","*Bip*R*Calf*","*Bip*R*Foot*"
					)
		local Sort_name=#("*Pelvis*","*Spine*","*Neck*","*head*","*L*Clavicle*","*L*UpperArm*","*L*Forearm*","*L*Hand*","*L*Finger*","*R*Clavicle*",\
							"*R*UpperArm*","*R*Forearm*","*R*Hand*","*R*Finger*","*L*Thigh*","*L*Calf*","*L*HorseLink*","*L*Foot*","*L*Toe*","*R*Thigh*",\
							"*R*Calf*","*R*HorseLink*","*R*Foot*","*R*Toe*","*Tail*","*prop*","*Twist*")
		local	Lack_bip=#()	
		local	figers_end_nod=0 
		local	toes_end_nod=0 
		local	neck_links=0
		local	hand_links=0 
		local	arms_bollean=true 
		local	spine_links=0
		local	leg_links=3
		local	figers=0
		local	finger_links=0
		local	toes=0
		local	toes_links=0 
		local	Tail=0
		local	prop=0
		local	prop1=false
		local	prop2=false
		local	prop3=false
		local	UpArmTwist=0
		local	ForeTwist=0
		local	ThighTwist=0
		local	CalfTwist=0
		local	HorseTwist=0							
		local 	Knuckles=false
		local 	shortThumb=true
		local	distance1=#()	
		local	distance2=#() 
		local 	x_scalevalue=#() 
		local	L_Finger_nub=0  
		local	R_Finger_nub=0  
		local	L_Toe_nub=0 
		local	R_Toe_nub=0	 
		
		animationRange = interval 0 animationRange.end 
		sliderTime = 0f
		a=objects 
		for i in a do(
			if matchpattern i.name pattern:"*Bip*Pelvis*" do (append Bip_nub i.parent) 
			)
		for i in a do(
		if (classof i==Editable_mesh or classof i==PolyMeshObject or classof i==Editable_Poly) and (i.modifiers[#Skin]!=undefined) do(
			append Model_nub i
			)
		)

		try(
		Fbx_allbone =GetallChildren Bip_nub[1]
		)catch(
			Lack_bip=Must_bip
		)
		for i in Fbx_allbone do append Fbx_allbone_name i.name
		for i in Fbx_allbone_name do (
			if matchpattern i pattern:"*bip*L*Finger*" do L_Finger_nub+=1
			if matchpattern i pattern:"*bip*R*Finger*" do R_Finger_nub+=1
			if matchpattern i pattern:"*L*Toe*" do L_Toe_nub+=1
			if matchpattern i pattern:"*R*Toe*" do R_Toe_nub+=1	
			)

		for i=1 to Must_bip.count do(
			unb=0
			for ii=1 to Fbx_allbone.count do(
			index=matchpattern Fbx_allbone[ii].name pattern:Must_bip[i]
			if index==false do(
				unb+=1
				)
			if unb==Fbx_allbone.count do(
				append Lack_bip Must_bip[i]
				)
			)
		)
		if (Lack_bip.count==0) and (L_Finger_nub==R_Finger_nub)and (L_Toe_nub==R_Toe_nub) and (Fbx_allbone.count!=0) then(
			if ck3.checked==true do(
	 		Export_animtion Fbx_allbone
			)
			if Model_nub.count!=0 do(
	 		Re_Tpose Model_nub
			)
			
			local lack_toes=0
			for i in Fbx_allbone_name where (matchpattern i pattern:"*bip*L*Toe*") do (lack_toes+=1)
			if lack_toes==0 do(	
				local toes_bone=#()
				local a
				local b
				local c
				for i in Fbx_allbone_name where matchpattern i pattern:"*Bip*L*Foot*" do (a=getnodebyname i)	
				for i in Fbx_allbone_name where matchpattern i pattern:"*Bip*L*Calf*" do (b=getnodebyname i)	
				c=distance a.pos b.pos
				toes_bone[1]=BoneSys.createBone a.pos (a.pos*1.1) [0,0,1]
				toes_bone[1].width =c/8
				toes_bone[1].height=c/8
				toes_bone[1].length=c/4
				toes_bone[1].transform=a.transform
				in coordsys local rotate toes_bone[1] (angleaxis 90 [0,0,1])
				toes_bone[1].parent=a
				toes_bone[1].name="Bip001_L_Toe0"
				in coordsys local move toes_bone[1] [(c/3),(-c/3),0]
					
				for i in Fbx_allbone_name where matchpattern i pattern:"*Bip*R*Foot*" do (a=getnodebyname i)	 
				toes_bone[2]=BoneSys.createBone a.pos (a.pos*1.1) [0,0,1]
				toes_bone[2].width =c/8
				toes_bone[2].height=c/8
				toes_bone[2].length=c/4
				toes_bone[2].transform=a.transform
				in coordsys local rotate toes_bone[2] (angleaxis 90 [0,0,1])
				toes_bone[2].parent=a
				toes_bone[2].name="Bip001_R_Toe0"
				in coordsys local move toes_bone[2] [(c/3),(-c/3),0]
				append Fbx_allbone toes_bone[1]
				append Fbx_allbone toes_bone[2]
				append Fbx_allbone_name toes_bone[1].name
				append Fbx_allbone_name toes_bone[2].name
			)
			
			fn pd i=
			(
				local a
				a=(matchpattern i pattern:"*bip*")and not(matchpattern i pattern:"*Nub*"or 
					matchpattern i pattern:"*Nub*"or matchpattern i pattern:"*马尾辫*"or 
					matchpattern i pattern:"*Ponytail*" or matchpattern i pattern:"*Xtra*"or matchpattern i pattern:"*Footsteps*"
					)
				return a
			)
			for i in Fbx_allbone_name where (pd i) do (append Fbx_bip_name_f i) 
			for i in Fbx_allbone_name where (matchpattern i pattern:"*bip*") do (append Fbx_bip_ff (getnodebyname i)) 
			append Fbx_bip_name Fbx_bip_name_f[1] 

			for i=1 to sort_name.count do (
					for ii=1 to Fbx_bip_name_f.count where matchpattern Fbx_bip_name_f[ii] pattern:sort_name[i] do (
						a=finditem  Fbx_bip_name Fbx_bip_name_f[ii] 
						if a!=0 then(
							deleteitem Fbx_bip_name a
							append Fbx_bip_name Fbx_bip_name_f[ii]
							)else(
							append Fbx_bip_name Fbx_bip_name_f[ii] 
							)
						)
					)
			for i in Fbx_bip_name do append Fbx_bip (getnodebyname i)
				
			progBar.value=30
					
			for i in Fbx_bip_name where matchpattern i pattern:"*Clavicle*" do (hand_links+=1)
			
			if hand_links>0 then(
				arms_bollean=true;hand_links=4
				)else(
				arms_bollean=false;hand_links=0
				)
			for i in Fbx_bip_name where matchpattern i pattern:"*Neck*" do (neck_links+=1)

			for i in Fbx_bip_name where matchpattern i pattern:"*Spine*" do (spine_links+=1)

			for i in Fbx_bip_name where matchpattern i pattern:"*L*HorseLink*" do (leg_links=4)


			for i in Fbx_bip_name where matchpattern i pattern:"*L*Hand*" do (
				a=(getnodebyname i).children
				for ii in a where matchpattern ii.name pattern:"*bip*L*Finger*" do figers+=1
				)

			for i in Fbx_bip_name where matchpattern i pattern:"*L*Finger*" do (finger_links+=1)
			if figers!=0 do(
				finger_links=finger_links/figers
				)

			if finger_links==4 do(
				Knuckles=true
				finger_links=3
				)
			if (not arms_bollean) do(
				figers=0;finger_links=0
				)
				

			for i in Fbx_bip_name where matchpattern i pattern:"*L*Foot*" do (
				a=(getnodebyname i).children
				for ii in a where matchpattern ii.name pattern:"*bip*L*Toe*" do toes+=1
				)	
				
			for i in Fbx_bip_name where matchpattern i pattern:"*L*Toe*" do (toes_links+=1)
				
			if toes!=0 do(
					toes_links=toes_links/toes
					)
			
			for i in Fbx_bip_name where matchpattern i pattern:"*Tail*" do (Tail+=1)
			
			for i in Fbx_bip_name where matchpattern i pattern:"*prop*" do (prop+=1)
			case prop of(
				1:(prop1=true)
				2:(prop1=true;prop2=true)
				3:(prop1=true;prop2=true;prop3=true)
				default:(prop1=false;prop2=false;prop3=false)
				)
			
			for i in Fbx_bip_name where matchpattern i pattern:"*UpArm*Twist*" do (UpArmTwist+=1) 
			for i in Fbx_bip_name where matchpattern i pattern:"*Fore*Twist*" do (ForeTwist+=1)
			for i in Fbx_bip_name where matchpattern i pattern:"*Thigh*Twist*" do (ThighTwist+=1)
			for i in Fbx_bip_name where matchpattern i pattern:"*Calf*Twist*" do (CalfTwist+=1)
			for i in Fbx_bip_name where matchpattern i pattern:"*Horse*Twist*" do (HorseTwist+=1)


			if ( (Bip_nub[1].rotation as eulerangles).z >-35) and((Bip_nub[1].rotation as eulerangles).z <35)  then(
				rotate Bip_nub[1] (angleaxis -90 [0,0,1])
				for i=1 to Fbx_bip.count do(
					Fbx_bip_pos[i]=Fbx_bip[i].transform.pos
					)
				rotate Bip_nub[1] (angleaxis 90 [0,0,1])
				)else(
				for i=1 to Fbx_bip.count do(
					Fbx_bip_pos[i]=Fbx_bip[i].transform.pos
					)
				)	
				

			for i=1 to (Fbx_bip_pos.count-1) do(
				distance1[i]=distance Fbx_bip_pos[i] Fbx_bip_pos[i+1]
				)
			progBar.value=40
				
			local bip_height=distance Fbx_bip_pos[1] Fbx_bip_pos[3+spine_links]  
			if figers==0 do (finger_links=1)
			newbip=biped.createNew (bip_height*3) -90 [0,0,0] arms:arms_bollean necklinks:neck_links \
			spineLinks:spine_links legLinks:leg_links  fingers:figers  fingerLinks:finger_links toes:toes toeLinks:toes_links  tailLinks:Tail\
			upperarmTwistLinks:(UpArmTwist/2) forearmTwistLinks:(ForeTwist/2)  thighTwistLinks:(ThighTwist/2)   calfTwistLinks:(CalfTwist/2)  horseTwistLinks:(HorseTwist/2)
			if figers==0 do (finger_links=0)
			biped_ctrl=newbip.controller 
			biped_ctrl.figureMode=true 
			biped_ctrl.bodyType=3
			biped_ctrl.prop1Exists=prop1
			biped_ctrl.prop2Exists=prop2
			biped_ctrl.prop3Exists=prop3 			
			biped_ctrl.knuckles=knuckles
			if Knuckles==true do(
				biped_ctrl.shortThumb=false
				finger_links=4
				)
			biped_ctrl.rootName="Bip008"
			
			New_allbip=GetallChildren newbip
			for i=1 to New_allbip.count where ((matchpattern New_allbip[i].name pattern:"*Nub*")==false) do append New_bip_f New_allbip[i]
			for i in New_bip_f do append New_bip_name_f i.name
			
			append New_bip_name New_bip_name_f[1] 
			sort New_bip_name_f 
			for i=1 to Sort_name.count do (
					for ii=1 to New_bip_name_f.count where matchpattern New_bip_name_f[ii] pattern:Sort_name[i] do (
						a=finditem  New_bip_name New_bip_name_f[ii] 
						if a!=0 then(
							deleteitem New_bip_name a
							append New_bip_name New_bip_name_f[ii]
							)else(
							append New_bip_name New_bip_name_f[ii] 
							)
						)
					)
			
			for i in New_bip_name do append New_bip (getnodebyname i)

			
			for i=1 to New_bip.count do(
				New_bip_pos[i]=New_bip[i].transform.pos
				)
			
			for i=1 to (New_bip_pos.count-1) do(
				distance2[i]=distance New_bip_pos[i] New_bip_pos[i+1]
				)
				
			for i=1 to distance2.count do(
				x_scalevalue[i]=distance1[i]/distance2[i]
				)
			progBar.value=50
				
			biped.setTransform newbip #pos (Fbx_bip[1].transform.pos) false
			biped.setTransform newbip #rotation (Fbx_bip[1].transform.rotation) false 	

			distance_z1=distance Fbx_bip[2] Fbx_bip[(4+spine_links+neck_links+(figers*finger_links*2)+(hand_links*2))]
			distance_z2=distance New_bip[2] New_bip[(4+spine_links+neck_links+(figers*finger_links*2)+(hand_links*2))]
			index=(spine_links+neck_links+(figers*finger_links*2)+4+(hand_links*2)) 	
			if (Fbx_bip[2].transform.pos.z-Fbx_bip[index].transform.pos.z)>0.01 then(
				a=Fbx_bip[(4+spine_links+neck_links+(figers*finger_links*2)+(hand_links*2))].transform.pos
				a.z=Fbx_bip[2].transform.pos.z
				b=distance Fbx_bip[2].pos a
				z_scalevalue=b/distance_z2	
				)else(
				z_scalevalue=distance_z1/distance_z2
				)
			if (x_scalevalue[2])>0.01 then(
				scale New_bip[2] [(x_scalevalue[2]),z_scalevalue,z_scalevalue]
			)else(
				scale New_bip[2] [z_scalevalue*0.7,z_scalevalue,z_scalevalue]
				)
			biped.setTransform New_bip[2] #rotation (Fbx_bip[2].transform.rotation) false 
	
			for i=3 to (2+spine_links) do(
				if i==(2+spine_links) and (spine_links!=1) then(
					scale New_bip[i] [(x_scalevalue[i]),(x_scalevalue[i-1]*1.2),(x_scalevalue[i-1]*1.2)]	
					)else(
					scale New_bip[i] [(x_scalevalue[i]),(x_scalevalue[i]),(x_scalevalue[i])]					
					)
				biped.setTransform New_bip[i] #rotation (Fbx_bip[i].transform.rotation) false 
				biped.setTransform New_bip[i] #pos (Fbx_bip[i].transform.pos) false
				)

			for i=(spine_links+3) to (2+spine_links+neck_links) do(
				scale New_bip[i] [(x_scalevalue[i]),(x_scalevalue[i]),(x_scalevalue[i])]
				biped.setTransform New_bip[i] #pos (Fbx_bip[i].transform.pos) false
				biped.setTransform New_bip[i] #rotation (Fbx_bip[i].transform.rotation) false 
				)	

			for i=(spine_links+neck_links+3) to (spine_links+neck_links+3) do(
				biped.setTransform New_bip[i] #pos (Fbx_bip[i].transform.pos) false
				scale New_bip[i] [z_scalevalue*0.8,z_scalevalue*0.8,z_scalevalue*0.8]
				biped.setTransform New_bip[i] #rotation (Fbx_bip[i].transform.rotation) false 
				)
			
			if arms_bollean do (
				for i=(spine_links+neck_links+4) to (spine_links+neck_links+3+hand_links) do(
					if i==(spine_links+neck_links+3+hand_links) then(
							case figers of(	
							0:(x_scalevalue[i-1]
								scale New_bip[i] [(x_scalevalue[i-1]),(x_scalevalue[i-1]),(x_scalevalue[i-1])] 
								)
							1:(	
								scale New_bip[i] [(x_scalevalue[i]),(x_scalevalue[i]),(x_scalevalue[i])] 
								)
							Default:(
								distance_hand1=distance Fbx_bip[i] Fbx_bip[(spine_links+neck_links+finger_links+4+hand_links)]
								distance_hand2=distance New_bip[i] New_bip[(spine_links+neck_links+finger_links+4+hand_links)]
								hand_scalevalue=distance_hand1/distance_hand2
								scale New_bip[i] [hand_scalevalue,hand_scalevalue,hand_scalevalue]
								)
							)
							biped.setTransform New_bip[i] #rotation (Fbx_bip[i].transform.rotation) false 
							biped.setTransform New_bip[i] #pos (Fbx_bip[i].transform.pos) false
						)else(
						biped.setTransform New_bip[i] #pos (Fbx_bip[i].transform.pos) false 
						scale New_bip[i] [(x_scalevalue[i]),(x_scalevalue[i]),(x_scalevalue[i])] 
						biped.setTransform New_bip[i] #rotation (Fbx_bip[i].transform.rotation) false
						rotate New_bip[i] (eulerangles 0 12 0) 
						)
					)
				
				if figers>0 do(	
				figers_end_nod=finger_links

				for i=(spine_links+neck_links+4+hand_links) to (spine_links+neck_links+3+(figers*finger_links)+hand_links) do(
						if (figers*finger_links)==1 then (
						
						scale New_bip[i] [(x_scalevalue[i-1]*4),(x_scalevalue[i-1]*4),(x_scalevalue[i-1]*6)]
						biped.setTransform New_bip[i] #rotation (Fbx_bip[i].transform.rotation) false 
						biped.setTransform New_bip[i] #pos (Fbx_bip[i].transform.pos) false 
						)else(
							if i==(spine_links+neck_links+3+figers_end_nod+hand_links)then(
							scale New_bip[i] [(x_scalevalue[i-1]),(x_scalevalue[i-1]),(x_scalevalue[i-1])]
							biped.setTransform New_bip[i] #rotation (Fbx_bip[i].transform.rotation) false 
							figers_end_nod+=finger_links
							)else(
							biped.setTransform New_bip[i] #pos (Fbx_bip[i].transform.pos) false 
							scale New_bip[i] [(x_scalevalue[i]),(x_scalevalue[i]),(x_scalevalue[i])]
							biped.setTransform New_bip[i] #rotation (Fbx_bip[i].transform.rotation) false 
							)
						)
					)
				)

				for i=(spine_links+neck_links+4+(figers*finger_links)+hand_links) to (spine_links+neck_links+3+(figers*finger_links)+(hand_links*2)) do(
					if i==(spine_links+neck_links+3+(figers*finger_links)+hand_links*2) then (
						case figers of(
							0:(
								scale New_bip[i] [(x_scalevalue[i-1]),(x_scalevalue[i-1]),(x_scalevalue[i-1])] 
								)
							1:(	
								scale New_bip[i] [(x_scalevalue[i]),(x_scalevalue[i]),(x_scalevalue[i])] 
								)
							Default:(
								distance_hand1=distance Fbx_bip[i] Fbx_bip[(spine_links+neck_links+4+(figers*finger_links)+hand_links*2+finger_links)]
								distance_hand2=distance New_bip[i] New_bip[(spine_links+neck_links+4+(figers*finger_links)+hand_links*2+finger_links)]
								hand_scalevalue=distance_hand1/distance_hand2
								scale New_bip[i] [hand_scalevalue,hand_scalevalue,hand_scalevalue]
								)
							)
							biped.setTransform New_bip[i] #rotation (Fbx_bip[i].transform.rotation) false 
							biped.setTransform New_bip[i] #pos (Fbx_bip[i].transform.pos) false							
						)else(
							biped.setTransform New_bip[i] #pos (Fbx_bip[i].transform.pos) false 
							scale New_bip[i] [(x_scalevalue[i]),(x_scalevalue[i]),(x_scalevalue[i])]
							biped.setTransform New_bip[i] #rotation (Fbx_bip[i].transform.rotation) false
							rotate New_bip[i] (eulerangles 0 -12 0) 
						)
					)

				if figers>0 do(
				figers_end_nod=finger_links	
				for i=(spine_links+neck_links+4+(figers*finger_links)+(hand_links*2)) to (spine_links+neck_links+3+(figers*finger_links*2)+(hand_links*2)) do(
						if (figers*finger_links)==1 then (
							scale New_bip[i] [(x_scalevalue[i-1]*4),(x_scalevalue[i-1]*4),(x_scalevalue[i-1]*6)]
							biped.setTransform New_bip[i] #rotation (Fbx_bip[i].transform.rotation) false 
							biped.setTransform New_bip[i] #pos (Fbx_bip[i].transform.pos) false 
							)else(
								if i==(spine_links+neck_links+3+(figers*finger_links)+figers_end_nod+(hand_links*2))then(
								scale New_bip[i] [(x_scalevalue[i-1]),(x_scalevalue[i-1]),(x_scalevalue[i-1])]
								biped.setTransform New_bip[i] #rotation (Fbx_bip[i].transform.rotation) false 
								figers_end_nod+=finger_links
								)else(
								biped.setTransform New_bip[i] #pos (Fbx_bip[i].transform.pos) false 
								scale New_bip[i] [(x_scalevalue[i]),(x_scalevalue[i]),(x_scalevalue[i])]
								biped.setTransform New_bip[i] #rotation (Fbx_bip[i].transform.rotation) false
								) 
							)
					)
				)
			)
			for i=(spine_links+neck_links+(figers*finger_links*2)+4+(hand_links*2)) to (spine_links+neck_links+(figers*finger_links*2)+3+leg_links+(hand_links*2)) do(
					if i==(spine_links+neck_links+(figers*finger_links*2)+3+leg_links+(hand_links*2))then( 
							case toes of(
								1:(
									distance_leg1=abs(Fbx_bip_pos[i].z-Fbx_bip_pos[i+1].z)
									distance_leg2=abs(New_bip_pos[i].z-New_bip_pos[i+1].z)
									leg_scalevalue_Z=distance_leg1/distance_leg2
									distance_leg1=abs(Fbx_bip_pos[i].y-Fbx_bip_pos[i+1].y)
									distance_leg2=abs(New_bip_pos[i].y-New_bip_pos[i+1].y)
									leg_scalevalue_Y=distance_leg1/distance_leg2
									)
								Default:(
									distance_leg1=abs(Fbx_bip_pos[i].z-Fbx_bip_pos[i+1+toes_links].z)
									distance_leg2=abs(New_bip_pos[i].z-New_bip_pos[i+1+toes_links].z)
									leg_scalevalue_Z=distance_leg1/distance_leg2
									distance_leg1=abs(Fbx_bip_pos[i].y-Fbx_bip_pos[i+1+toes_links].y)
									distance_leg2=abs(New_bip_pos[i].y-New_bip_pos[i+1+toes_links].y)
									leg_scalevalue_Y=distance_leg1/distance_leg2
									)
							)
							scale New_bip[i] [leg_scalevalue_Z,leg_scalevalue_Y,leg_scalevalue_Z*0.9]
							biped.setTransform New_bip[i] #rotation (Fbx_bip[i].transform.rotation) false 
						)else if i==(spine_links+neck_links+(figers*finger_links*2)+4+(hand_links*2)) then(
							if (Fbx_bip_pos[2].z-Fbx_bip_pos[i].z)>0.01 then(
								a=Fbx_bip_pos[i]
								a.z=Fbx_bip_pos[2].z
								b=distance a Fbx_bip_pos[i+1]
								c=b/distance2[i]
								scale New_bip[i] [c,c,c]
								)else(
								scale New_bip[i] [(x_scalevalue[i]),(x_scalevalue[i]),(x_scalevalue[i])]
								)
								biped.setTransform New_bip[i] #rotation (Fbx_bip[i].transform.rotation) false 	
						)else(
							scale New_bip[i] [(x_scalevalue[i]),(x_scalevalue[i]),(x_scalevalue[i])]
							biped.setTransform New_bip[i] #rotation (Fbx_bip[i].transform.rotation) false 
							)
				)

			toes_end_nod=toes_links
			for i=(spine_links+neck_links+(figers*finger_links*2)+4+leg_links+(hand_links*2))to (spine_links+neck_links+(figers*finger_links*2)+3+leg_links+(toes*toes_links)+(hand_links*2)) do(
					if (toes*toes_links)==1 then ( 
					scale New_bip[i] [(x_scalevalue[i-1]*4),(x_scalevalue[i-1]*4),(x_scalevalue[i-1]*6)]
					biped.setTransform New_bip[i] #rotation (Fbx_bip[i].transform.rotation) false
					biped.setTransform New_bip[i] #pos (Fbx_bip[i].transform.pos) false 
					)else(
						if i==(spine_links+neck_links+(figers*finger_links*2)+11+leg_links+toes_end_nod)then( 
						scale New_bip[i] [(x_scalevalue[i-1]),(x_scalevalue[i-1]),(x_scalevalue[i-1])]
						toes_end_nod+=toes_links
						)else(
						biped.setTransform New_bip[i] #pos (Fbx_bip[i].transform.pos) false 
						scale New_bip[i] [(x_scalevalue[i]),(x_scalevalue[i]),(x_scalevalue[i])]
						)
						biped.setTransform New_bip[i] #rotation (Fbx_bip[i].transform.rotation) false
					)			
				)

			for i=(spine_links+neck_links+(figers*finger_links*2)+4+leg_links+(toes*toes_links)+(hand_links*2)) to(spine_links+neck_links+(figers*finger_links*2)+3+(leg_links*2)+(toes*toes_links)+(hand_links*2)) do(
					if i==(spine_links+neck_links+(figers*finger_links*2)+3+(leg_links*2)+(toes*toes_links)+(hand_links*2))then( 
							case toes of(
								1:(
									distance_leg1=abs(Fbx_bip_pos[i].z-Fbx_bip_pos[i+1].z)
									distance_leg2=abs(New_bip_pos[i].z-New_bip_pos[i+1].z)
									leg_scalevalue_Z=distance_leg1/distance_leg2
									distance_leg1=abs(Fbx_bip_pos[i].y-Fbx_bip_pos[i+1].y)
									distance_leg2=abs(New_bip_pos[i].y-New_bip_pos[i+1].y)
									leg_scalevalue_Y=distance_leg1/distance_leg2
									)
								Default:(
									distance_leg1=abs(Fbx_bip_pos[i].z-Fbx_bip_pos[i+1+toes_links].z)
									distance_leg2=abs(New_bip_pos[i].z-New_bip_pos[i+1+toes_links].z)
									leg_scalevalue_Z=distance_leg1/distance_leg2
									distance_leg1=abs(Fbx_bip_pos[i].y-Fbx_bip_pos[i+1+toes_links].y)
									distance_leg2=abs(New_bip_pos[i].y-New_bip_pos[i+1+toes_links].y)
									leg_scalevalue_Y=distance_leg1/distance_leg2
									)
							)
							scale New_bip[i] [leg_scalevalue_Z,leg_scalevalue_Y,leg_scalevalue_Z*0.9]
							biped.setTransform New_bip[i] #rotation (Fbx_bip[i].transform.rotation) false 
						)else if i==(spine_links+neck_links+(figers*finger_links*2)+4+leg_links+(toes*toes_links)+(hand_links*2)) then(
							if (Fbx_bip_pos[2].z-Fbx_bip_pos[i].z)>0.01 then(
								a=Fbx_bip_pos[i]
								a.z=Fbx_bip_pos[2].z
								b=distance a Fbx_bip_pos[i+1]
								c=b/distance2[i]
								scale New_bip[i] [c,c,c]
								)else(
								scale New_bip[i] [(x_scalevalue[i]),(x_scalevalue[i]),(x_scalevalue[i])]
								)
								biped.setTransform New_bip[i] #rotation (Fbx_bip[i].transform.rotation) false 	
						)else(
						scale New_bip[i] [(x_scalevalue[i]),(x_scalevalue[i]),(x_scalevalue[i])]
						biped.setTransform New_bip[i] #rotation (Fbx_bip[i].transform.rotation) false 
						)
				)
			L_toes_links=spine_links+neck_links+(hand_links*2)+(figers*finger_links*2)+4+leg_links
			toes_end_nod=toes_links
			for i=(spine_links+neck_links+(figers*finger_links*2)+4+(leg_links*2)+(toes*toes_links)+(hand_links*2))to (spine_links+neck_links+(figers*finger_links*2)+3+(leg_links*2)+(toes*toes_links*2)+(hand_links*2)) do(
					if (toes*toes_links)==1 then (
						scale New_bip[i] [(x_scalevalue[i-1]*4),(x_scalevalue[i-1]*4),(x_scalevalue[i-1]*6)]
						biped.setTransform New_bip[i] #rotation (Fbx_bip[i].transform.rotation) false 
						biped.setTransform New_bip[i] #pos (Fbx_bip[i].transform.pos) false 
					)else(	
						if i==(spine_links+neck_links+(figers*finger_links*2)+3+(leg_links*2)+(toes*toes_links)+toes_end_nod+(hand_links*2))then(
						scale New_bip[i] [(x_scalevalue[L_toes_links-1]),(x_scalevalue[L_toes_links-1]),(x_scalevalue[L_toes_links-1])]
						toes_end_nod+=toes_links
						L_toes_links+=1
						)else(
						biped.setTransform New_bip[i] #pos (Fbx_bip[i].transform.pos) false 
						scale New_bip[i] [(x_scalevalue[L_toes_links]),(x_scalevalue[L_toes_links]),(x_scalevalue[L_toes_links])]
						L_toes_links+=1
						)
						biped.setTransform New_bip[i] #rotation (Fbx_bip[i].transform.rotation) false 
					)
				)

			if Tail >0 do(
			for i=(spine_links+neck_links+(figers*finger_links*2)+3+(leg_links*2)+(toes*toes_links*2)+(hand_links*2))to(spine_links+neck_links+(figers*finger_links*2)+3+(leg_links*2)+(toes*toes_links*2)+Tail+(hand_links*2))do(
					if i==(spine_links+neck_links+(figers*finger_links*2)+3+(leg_links*2)+(toes*toes_links*2)+Tail+(hand_links*2))then( 
					scale New_bip[i] [(x_scalevalue[i-1]),(x_scalevalue[i-1]),(x_scalevalue[i-1])]
					)else(
					biped.setTransform New_bip[i] #pos (Fbx_bip[i].transform.pos) false 
					scale New_bip[i] [(x_scalevalue[i]),(x_scalevalue[i]),(x_scalevalue[i])]
					)
					biped.setTransform New_bip[i] #rotation (Fbx_bip[i].transform.rotation) false 
				)	
			)

			if prop >0 do(
			for i=(spine_links+neck_links+(figers*finger_links*2)+4+(leg_links*2)+(toes*toes_links*2)+Tail+(hand_links*2))to(spine_links+neck_links+(figers*finger_links*2)+3+(leg_links*2)+(toes*toes_links*2)+Tail+prop+(hand_links*2))do(
					biped.setTransform New_bip[i] #pos (Fbx_bip[i].transform.pos) false 
					scale New_bip[i] [z_scalevalue,z_scalevalue,z_scalevalue*0.5]
					biped.setTransform New_bip[i] #rotation (Fbx_bip[i].transform.rotation) false 
				)
			)
			biped_ctrl.figureMode=false 
			
			progBar.value=80
			
			local children_array=#()
			local single_bone_chain_name=#()
			local bone_root_array=#() 
			global New_bone_name=#() 
			global New_bone=#()
			global Fbx_bone_name=#() 
			global Fbx_bone=#() 
			
			for i in Fbx_bip do(
				if (i.children.count!=0) do(
					for ii=1 to i.children.count do(
						append children_array i.children[ii]
						)
					)
				)
			for i=1 to children_array.count where (matchpattern (children_array[i].name) pattern:"*bip*"==false)or(matchpattern (children_array[i].name) pattern:"*Xtra*"==true)or
				(matchpattern (children_array[i].name) pattern:"*马尾辫*"==true)or(matchpattern (children_array[i].name) pattern:"*Ponytail*"==true) do (
				append bone_root_array children_array[i]
				) 
			
			for i=1 to bone_root_array.count do(
				local single_bone_chain=#() 
				local bonee=#() 
				local Fbx_bone_pos=#() 
				local relation_parent=#() 
				local relation_children=#() 
				
				bone_parent=bone_root_array[i].parent 
				a=finditem Fbx_bip_name bone_parent.name
				bone_parent=New_bip[a]
				single_bone_chain =GetallChildren bone_root_array[i]

				for ii=1 to single_bone_chain.count do(
					Fbx_bone_pos[ii]=single_bone_chain[ii].transform.pos
					)

				if Fbx_bone_pos.count >1 then(
					bone_size=(distance Fbx_bone_pos[1] Fbx_bone_pos[2])/4 
					if (bone_size<0.001) do( 
							bone_size=(distance1[2+neck_links+spine_links])/2.5
						)
					)else(
						bone_size=(distance1[2+neck_links+spine_links])/2.5  
					)
					bone_size2=bone_size
					
				if single_bone_chain.count==1 then(   
						if (matchpattern (single_bone_chain[1].name) pattern:"*Dummy*") then (
							bonee[1]=Dummy boxsize:([bone_size,bone_size,bone_size]*2.5)
							bonee[1].transform=single_bone_chain[1].transform
							bonee[1].parent=bone_parent
							bonee[1].name="F"+single_bone_chain[1].name 
							append New_bone_name bonee[1].name
							append New_bone bonee[1]
							append Fbx_bone_name single_bone_chain[1].name
							append Fbx_bone single_bone_chain[1]
							) else(
								bonee[1]=BoneSys.createBone Fbx_bone_pos[1] (Fbx_bone_pos[1]*1.1) [0,0,1]
								bonee[1].width = bone_size/3    
								bonee[1].height = bone_size/3
								bonee[1].length = bone_size
								bonee[1].transform=single_bone_chain[1].transform
								bonee[1].parent=bone_parent
								bonee[1].name="F"+single_bone_chain[1].name 
								append New_bone_name bonee[1].name
								append New_bone bonee[1]
								append Fbx_bone_name single_bone_chain[1].name
								append Fbx_bone single_bone_chain[1]
							)

					)else(  
						for ii=1 to single_bone_chain.count do (
							if (single_bone_chain[ii].children[1]!=undefined) then(  
								if (matchpattern (single_bone_chain[ii].name) pattern:"*Dummy*") then (
										bonee[ii]=Dummy boxsize:([bone_size2,bone_size2,bone_size2]*0.8)
										bonee[ii].transform=single_bone_chain[ii].transform
										bonee[ii].name="F"+single_bone_chain[ii].name 
										append New_bone_name bonee[ii].name
										append New_bone bonee[ii]
										append Fbx_bone_name single_bone_chain[ii].name
										append Fbx_bone single_bone_chain[ii]
										append relation_parent bonee[ii]
										append relation_children single_bone_chain[ii].children
									)else(
										if (distance Fbx_bone_pos[ii] Fbx_bone_pos[ii+1]>0.001) then( 
											bonee[ii]=BoneSys.createBone Fbx_bone_pos[ii] Fbx_bone_pos[ii+1] [0,0,1]
											)else(
											bonee[ii]=BoneSys.createBone Fbx_bone_pos[ii] (Fbx_bone_pos[ii]*1.1) [0,0,1]
											bonee[ii].length= bone_size	
											)
										bonee[ii].width = bone_size    
										bonee[ii].height = bone_size
										bonee[ii].transform=single_bone_chain[ii].transform
										bonee[ii].name="F"+single_bone_chain[ii].name --改名
										append New_bone_name bonee[ii].name
										append New_bone bonee[ii]
										append Fbx_bone_name single_bone_chain[ii].name
										append Fbx_bone single_bone_chain[ii]
										append relation_parent bonee[ii]
										append relation_children single_bone_chain[ii].children
									)

								)else( 
									if (matchpattern (single_bone_chain[ii].name) pattern:"*Dummy*") then (
										bonee[ii]=Dummy boxsize:([bone_size2,bone_size2,bone_size2]*0.8)
										bonee[ii].transform=single_bone_chain[ii].transform
										bonee[ii].name=single_bone_chain[ii].name
										bonee[ii].name="F"+single_bone_chain[ii].name 
										append New_bone_name bonee[ii].name
										append New_bone bonee[ii]
										append Fbx_bone_name single_bone_chain[ii].name
										append Fbx_bone single_bone_chain[ii]
										)else(
										bonee[ii]=BoneSys.createBone Fbx_bone_pos[ii] (Fbx_bone_pos[ii]*1.1) [0,0,1]
										bonee[ii].transform=single_bone_chain[ii].transform
										bonee[ii].width = bone_size	
										bonee[ii].height = bone_size
										bonee[ii].length= bonee[ii-1].length
										bonee[ii].name="F"+single_bone_chain[ii].name
										append New_bone_name bonee[ii].name
										--bonee[ii].taper= 90
										--bonee[ii].length= (bonee[ii].width+bonee[ii].height)/2
										append New_bone bonee[ii]
										append Fbx_bone_name single_bone_chain[ii].name
										append Fbx_bone single_bone_chain[ii]
										)

								)
									
							bonee[1].parent=bone_parent	
						)
							for ii=1 to relation_parent.count do(  
								for iii=1 to relation_children[ii].count do(
									a=finditem single_bone_chain relation_children[ii][iii]
									bonee[a].parent=relation_parent[ii]
									)
						)
					)				
			)
			progBar.value=100
			progBar.value=0	
		)else(
			if Lack_bip.count!=0 do(
				Lack_bip_name=""
				for i in Lack_bip do( Lack_bip_name+=(i+"\r"))
				Lack_bip_name="缺少骨骼："+"\r"+Lack_bip_name
				messagebox Lack_bip_name title:"缺少骨骼："
				)
			if L_Finger_nub!=R_Finger_nub do(
				messagebox "左边手指不等于右边手指数量"
				)
			if L_Toe_nub!=R_Toe_nub do(
				messagebox "左边脚趾不等于右边脚趾数量"
				)
		)
	)

	fn fbxtobone=
	(
		max create mode
		local 	bonee2=#()
		global Fbx_bone_nub=#() 
		global Model_nub2=#() 
		global New_bone2=#() 
		global New_bone2_name=#() 
		global Fbx_bone_name2=#()
		
		animationRange = interval 0 animationRange.end 
		sliderTime = 0f
		a= selection as array
		if a.count==0 then (
			messagebox "请选择模型和骨骼" 
			)else(
				for i=1 to a.count do(
					if (classof a[i]==BoneGeometry)or (  classof a[i]==Dummy )or (classof a[i]==Point)or(classof a[i]==Biped_Object) do(
						append  Fbx_bone_nub  a[i]
						)
					)
				
				for i=1 to a.count do(
					if (classof a[i]==Editable_mesh or classof a[i]==PolyMeshObject or classof a[i]==Editable_Poly) and (a[i].modifiers[#Skin]!=undefined)do(
						append Model_nub2 a[i]
						)
					)
				if ck3.checked==true do(
				Export_animtion Fbx_bone_nub
				)
				if Model_nub2.count!=0 do(
				Re_Tpose2 Model_nub2 Fbx_bone_nub
				)
			progBar.value=30
				
				bone_size=2
				for i=1 to Fbx_bone_nub.count do(
					if Fbx_bone_nub[i].children[1]==undefined and Fbx_bone_nub[i].parent==undefined then(  
						if (matchpattern (Fbx_bone_nub[i].name) pattern:"*Dummy*") then (
							bonee2[i]=Dummy boxsize:[bone_size,bone_size,bone_size]
							bonee2[i].transform=Fbx_bone_nub[i].transform
							append New_bone2 bonee2[i]
							append Fbx_bone_name2 Fbx_bone_nub[i].name
							)else if (matchpattern (Fbx_bone_nub[i].name) pattern:"*Point*") then(
							bonee2[i]=Point size:bone_size wirecolor:(color 14 254 2)
							bonee2[i].transform=Fbx_bone_nub[i].transform
							append New_bone2 bonee2[i]
							append Fbx_bone_name2 Fbx_bone_nub[i].name
							)else(
								bonee2[i]=BoneSys.createBone Fbx_bone_nub[i].transform.pos (Fbx_bone_nub[i].transform.pos*1.1) [0,0,1]
								bonee2[i].width = bone_size    
								bonee2[i].height = bone_size
								bonee2[i].length = bone_size*4
								bonee2[i].transform=Fbx_bone_nub[i].transform
								append New_bone2 bonee2[i]
								append Fbx_bone_name2 Fbx_bone_nub[i].name
							)
					)else(
							if not(Fbx_bone_nub[i].children[1]==undefined) then(  
								if (matchpattern (Fbx_bone_nub[i].name) pattern:"*Dummy*") then (
										if (distance Fbx_bone_nub[i].pos Fbx_bone_nub[i].children[1].pos)>0.001 and (bone_size>0.001)then(
											a=distance Fbx_bone_nub[i].transform.pos Fbx_bone_nub[i].children[1].transform.pos
											bonee2[i]=Dummy boxsize:([a,a,a]/2)
										)else(
											bonee2[i]=Dummy boxsize:([bone_size,bone_size,bone_size]*3)
											)
										bonee2[i].transform=Fbx_bone_nub[i].transform
										append New_bone2 bonee2[i]
										append Fbx_bone_name2 Fbx_bone_nub[i].name
									)else if (matchpattern (Fbx_bone_nub[i].name) pattern:"*Point*")then(
										if (distance Fbx_bone_nub[i].transform.pos Fbx_bone_nub[i].children[1].transform.pos)>0.001 and (bone_size>0.001) then(
											a=distance Fbx_bone_nub[i].transform.pos Fbx_bone_nub[i].children[1].transform.pos
											bonee2[i]=Point size:(a/4) wirecolor:(color 14 254 2)
										)else(
											bonee2[i]=Point size:(bone_size/2) wirecolor:(color 14 254 2)	
											)
										bonee2[i].transform=Fbx_bone_nub[i].transform
										append New_bone2 bonee2[i]
										append Fbx_bone_name2 Fbx_bone_nub[i].name
									)else(
										if (distance Fbx_bone_nub[i].transform.pos Fbx_bone_nub[i].children[1].transform.pos)>0.001 and (bone_size>0.001)then(
										bonee2[i]=BoneSys.createBone Fbx_bone_nub[i].transform.pos Fbx_bone_nub[i].children[1].transform.pos [0,0,1]
										bonee2[i].width = (distance Fbx_bone_nub[i].transform.pos Fbx_bone_nub[i].children[1].transform.pos)/4 
										bonee2[i].height =(distance Fbx_bone_nub[i].transform.pos Fbx_bone_nub[i].children[1].transform.pos)/4 
										)else(
											bonee2[i]=BoneSys.createBone Fbx_bone_nub[i].transform.pos ((Fbx_bone_nub[i].transform.pos)*1.1) [0,0,1]
											bonee2[i].width =2
											bonee2[i].height =2
											bonee2[i].length=2*4
											)
										bonee2[i].transform=Fbx_bone_nub[i].transform
										append New_bone2 bonee2[i]
										append Fbx_bone_name2 Fbx_bone_nub[i].name
									)

								)else(
									if (matchpattern (Fbx_bone_nub[i].name) pattern:"*Dummy*") then (
										bonee2[i]=Dummy boxsize:([bone_size,bone_size,bone_size]*3)
										bonee2[i].transform =Fbx_bone_nub[i].transform
										append New_bone2 bonee2[i]
										append Fbx_bone_name2 Fbx_bone_nub[i].name
										)else if (matchpattern (Fbx_bone_nub[i].name) pattern:"*Point*")then(
										bonee2[i]=Point size:(bone_size/2) wirecolor:(color 14 254 2)
										bonee2[i].transform =Fbx_bone_nub[i].transform
										append New_bone2 bonee2[i]
										append Fbx_bone_name2 Fbx_bone_nub[i].name
										)else(
											bonee2[i]=BoneSys.createBone Fbx_bone_nub[i].transform.pos ((Fbx_bone_nub[i].transform.pos)*1.1) [0,0,1]
											bonee2[i].transform =Fbx_bone_nub[i].transform
											if (distance Fbx_bone_nub[i].transform.pos Fbx_bone_nub[i].parent.transform.pos)>0.001 then(
											bonee2[i].width = (distance Fbx_bone_nub[i].transform.pos Fbx_bone_nub[i].parent.transform.pos)/4
											bonee2[i].height = (distance Fbx_bone_nub[i].transform.pos Fbx_bone_nub[i].parent.transform.pos)/4
											bonee2[i].length=(bonee2[i].width+bonee2[i].height)/2
											)else(
												bonee2[i].width =2
												bonee2[i].height = 2
												bonee2[i].length=2*4
												)
											bonee2[i].taper= 90
											append New_bone2 bonee2[i]
											append Fbx_bone_name2 Fbx_bone_nub[i].name
										)
								)
					)
					progBar.value=80
				)
				for i=1 to New_bone2.count do (New_bone2_name[i]=New_bone2[i].name)
				for i=1 to New_bone2.count do( 
					a=getNodeByName Fbx_bone_name2[i]
					if a.parent!=undefined do(
						b=finditem Fbx_bone_name2 a.parent.name
							if b!=0 do(
							New_bone2[i].parent=New_bone2[b]	
							)
						)
				)
			
				if New_bone2.count !=0 do(
				tt2 = layerManager.getLayerFromName"New_bone"  	
				if  tt2 ==undefined then (
				tc2=LayerManager.newLayerFromName "New_bone" 
				)else(
				tc2=LayerManager.getLayerFromName"New_bone"
				)
				for i in New_bone2 do tc2.addNode i	
				)
				tt3 = layerManager.getLayerFromName"Model"  	
				if  tt3 ==undefined then (
				tc3=LayerManager.newLayerFromName "Model" 
				)else(
				tc3=LayerManager.getLayerFromName"Model"
				)
				for i in objects where(classof i==Editable_mesh or classof i==PolyMeshObject or classof i==Editable_Poly) do tc3.addNode i

			)
			progBar.value=100
			progBar.value=0
	)

	fn TransferSkinBone Model_nub source target = (
		_skin=Model_nub.modifiers[#Skin]
		verts=Model_nub.vertices.count 
		for v=1 to verts do
		(
			local targetWeight = 0.0  
			local sourceWeight = 0.0
			local weightCount = skinOps.GetVertexWeightCount _skin v 
			for vb = 1 to weightCount do
			(
				index=skinOps.GetVertexWeightBoneID _skin v vb 
				index2=finditem source index
				if index2!=0 do(
					sourceWeight = skinOps.GetVertexWeight _skin v vb
					if sourceWeight > 0 then
					(
						skinOps.SetVertexWeights _skin v source[index2] 0.0   
						skinOps.SetVertexWeights _skin v target[index2] sourceWeight
					)
				)
			)
			
		)
	)

	fn replaceskin=(
		max modify mode
		for bb=1 to Model_nub.count do(
			local 	source_array=#()
			local 	target_array=#()
			
			_skin=Model_nub[bb].modifiers[#Skin]
			modPanel.setCurrentObject _skin 
			skinOps.closeWeightTool _skin  
			
			olde_skin_bone=#()	
			if fbone4.count !=0 then (
				olde_skin_bone=olde_skin_bone+bone_all_name3 
				olde_skin_bone=olde_skin_bone+fbone4  
			)else(
				olde_skin_bone=olde_skin_bone+Fbx_bone_name 
				olde_skin_bone=olde_skin_bone+Fbx_bip_name 
			)
				
			new_skin_bone=#()  
			new_skin_bone=new_skin_bone+New_bone_name 
			new_skin_bone=new_skin_bone+New_bip_name
				
			skin_bone_name = #() 
			for i = 1 to (skinOps.getNumberBones _skin) do  
			(
				index =skinOps.GetBoneName _skin i 1 
				append skin_bone_name index
			)
			
			for i=1 to skin_bone_name.count do( 
				a=finditem olde_skin_bone skin_bone_name[i]
				if a!=0 then (
					skinOps.addBone _skin (getnodebyname new_skin_bone[a]) 1  
					)
			)
			progBar.value =20	
			skin_bone_name = #() 
			for b = 1 to (skinOps.getNumberBones _skin) do  
			(
				index =skinOps.GetBoneName _skin b 1 
				append skin_bone_name index
			)
			
			for i=1 to olde_skin_bone.count do( 
					index = findItem skin_bone_name olde_skin_bone[i]
					if index!=0 do(
						append source_array index
						index2 = findItem skin_bone_name new_skin_bone[i]
						append target_array index2
					)
				)
			progBar.value =30
			TransferSkinBone Model_nub[bb] source_array target_array
				
			progBar.value =90	
			for i=1 to olde_skin_bone.count do(
					index=finditem skin_bone_name olde_skin_bone[i]
					if index!=0 do(
						skinOps.SelectBone _skin index
						skinOps.removebone _skin
						skinbone_count=skinops.getnumberbones _skin  
						skin_bone_name=#()
						for ii=1 to skinbone_count do (
							skin_bone_name[ii]=skinOps.GetBoneName  _skin ii 0 
							)
					)
				)
			progBar.value =100
			progBar.value =0
		)
		bone_all_name3=#()
		fbone4=#()
		clearSelection()
	)
	fn replaceskin2=(
		max modify mode
		for bb=1 to Model_nub2.count do(
			local 	source_array=#()
			local 	target_array=#()
			
			_skin=Model_nub2[bb].modifiers[#Skin]
			modPanel.setCurrentObject _skin 
			skinOps.closeWeightTool _skin  
			
			olde_skin_bone=#()		
			olde_skin_bone=olde_skin_bone+Fbx_bone_name2 
				
			new_skin_bone=#()  
			new_skin_bone=new_skin_bone+New_bone2_name 
				
			skin_bone_name = #() 
			for i = 1 to (skinOps.getNumberBones _skin) do  
			(
				index =skinOps.GetBoneName _skin i 1 
				append skin_bone_name index
			)
			
			for i=1 to skin_bone_name.count do( 
				a=finditem olde_skin_bone skin_bone_name[i]
				if a!=0 then (
					skinOps.addBone _skin (getnodebyname new_skin_bone[a]) 1  
					)
			)
			progBar.value =20	
			skin_bone_name = #() 
			for b = 1 to (skinOps.getNumberBones _skin) do  
			(
				index =skinOps.GetBoneName _skin b 1 
				append skin_bone_name index
			)
			
			for i=1 to olde_skin_bone.count do(  
					index = findItem skin_bone_name olde_skin_bone[i]
					if index!=0 do(
						append source_array index
						index2 = findItem skin_bone_name new_skin_bone[i]
						append target_array index2
					)
				)
			progBar.value =30
			TransferSkinBone Model_nub2[bb] source_array target_array
				
			progBar.value =90	
			for i=1 to olde_skin_bone.count do(
					index=finditem skin_bone_name olde_skin_bone[i]
					if index!=0 do(
						skinOps.SelectBone _skin index
						skinOps.removebone _skin
						skinbone_count=skinops.getnumberbones _skin  
						skin_bone_name=#()
						for ii=1 to skinbone_count do (
							skin_bone_name[ii]=skinOps.GetBoneName  _skin ii 0 
							)
					)
				)
			progBar.value =100
			progBar.value =0
		)
		bone_all_name3=#()
		fbone4=#()
		clearSelection()
	)
	fn replacename=(
		if New_bip.count!=0 do(
		for i=1 to New_bip.count do(
			New_bip[i].name=Fbx_bip_name[i]  
			)
		for i=1 to New_bone.count do(
			New_bone[i].name=Fbx_bone_name[i]  
			)
		)
	)
	fn replacename2=(
		for i=1 to New_bone2.count do(
			New_bone2[i].name=Fbx_bone_name2[i] 
			)
	)	

	fn new_Layer=(
		global tc1
		global tc2
		global tc3
		
		tt1 = layerManager.getLayerFromName"New_bip"  	
		if  tt1 ==undefined then (
		tc1=LayerManager.newLayerFromName "New_bip" 
		)else(
		tc1=LayerManager.getLayerFromName"New_bip"
		)
		for i in  New_allbip do tc1.addNode i
		New_allbip.boxMode=true	
		
		tt2 = layerManager.getLayerFromName"New_bone"  	
		if  tt2 ==undefined then (
		tc2=LayerManager.newLayerFromName "New_bone" 
		)else(
		tc2=LayerManager.getLayerFromName"New_bone"
		)
		for i in  New_bone do tc2.addNode i
			
		tt3 = layerManager.getLayerFromName"Model"  	
		if  tt3 ==undefined then (
		tc3=LayerManager.newLayerFromName "Model" 
		)else(
		tc3=LayerManager.getLayerFromName"Model"
		)
	--	for i in Model_nub  do tc3.addNode i
		for i in objects where(classof i==Editable_mesh or classof i==PolyMeshObject or classof i==Editable_Poly) do tc3.addNode i
	)
	fn Getpatent nodes =
	(
	local _parent=nodes
	local _parentf=nodes
	while true do (
		_parent=_parent.parent
		if _parent!=undefined do(
			_parentf=_parent
			)
		if _parent ==undefined  do(
			exit 
			)
		)
		_parentf
	)
	
	on ck3 changed theState do(
		ck1.checked=true
		)
	on ck1 changed theState do(
		if ck1.checked==false  do(
			ck3.checked=false 
			)
		)
	on conversion pressed do(
		fbxtobip()
		if ck2.checked==true do(s
			try (
				replaceskin()
				) catch(
				messagebox "替换蒙皮失败"
				)
		)
		if ck1.checked==true do(
			try (
				replacename()
				) catch(
				messagebox "替换名称失败"
				)
		)
		if ck3.checked==true do(
			delete (Fbx_bone+Fbx_bip_ff)
			FBXImporterSetParam "Animation" true
			FBXImporterSetParam  "Mode" #merge 
			importfile file_path #noPrompt using:FBXIMP
			clearSelection()
			--deleteFile file_path
		)
		try (
		new_Layer()
		)catch()
	)
	on conversion2 pressed do(
		fbxtobone()
		if ck2.checked==true do(
			try (
				replaceskin2()
				) catch(
				messagebox "替换蒙皮失败"
				)
		)
		if ck1.checked==true do(
			try (
				replacename2()
				) catch(
				messagebox "替换名称失败"
				)
		)
		if ck3.checked==true do(
			delete Fbx_bone_nub
			FBXImporterSetParam "Animation" true
			FBXImporterSetParam  "Mode" #merge 
			importfile file_path #noPrompt using:FBXIMP
			clearSelection()
			--deleteFile file_path
		)
	)
)

rollout Relocate_bone_size "重置Bone骨骼大小" width:170 height:100 
(		
	spinner spn "骨骼宽度"  width:80 height:16 range:[0.001,100,1] scale:0.01 toolTip:"Bone骨骼宽度" align:#center offset:[11,0]
	spinner spn2 "骨骼长度"  width:80 height:16 range:[0.001,100,3] scale:0.01 toolTip:"Bone骨骼长度" align:#center offset:[11,0]
	button but "重置宽度" width:65 height:32 toolTip:"重置骨骼宽度" align:#center across:2
	button but2 "重置长宽" width:65 height:32 toolTip:"重置骨骼宽度和长度" align:#center
	
	on spn entered  do (
		spn2.value=spn.value*3
		)
	
	on but pressed do(
		a=selection as array 
		for i=1 to a.count do(
			if classof a[i]==BoneGeometry do(
			a[i].width =spn.value
			a[i].height =spn.value
			if a[i].frontfin==true do(
			a[i].frontfin=true
			a[i].frontfinsize=spn.value/2
			)
			)
			if classof a[i]==Dummy do(
			a[i].boxsize=[spn.value,spn.value,spn.value]
			)
			if classof a[i]==Point do(
			a[i].size=spn.value
			)
		)
	)
	on but2 pressed do(
		a=selection as array 
		for i=1 to a.count do(
			if classof a[i]==BoneGeometry do(
			a[i].width =spn.value
			a[i].height =spn.value
			a[i].length=spn2.value
			if a[i].frontfin==true do(
			a[i].frontfin=true
			a[i].frontfinsize=spn.value/2
			)
			)
			if classof a[i]==Dummy do(
			a[i].boxsize=[spn.value,spn.value,spn2.value]
			)
			if classof a[i]==Point do(
			a[i].size=spn2.value
			)
		)
	)
)

rollout Findtext "筛选场景中的物体" width:170 height:70
(
	edittext edit1 "筛选名称"
	button but1 "筛选" width:100 height:32  align:#center 
	on but1 pressed do(
			if edit1.text !="" then (
				_name=#()
				for i=1 to objects .count do(
					a=findstring objects [i].name edit1.text 
					if a!=undefined do(
						append _name objects [i] 
					)
				)
				select _name
			)else(
			messagebox "请填写筛选名称"
			)
	)
)
rollout rollout_title2 "非Bip骨骼导出的Fbx" width:310
(
	subrollout sub_broken2 "" width:310 height:465 pos:[0,0]
	global add_bone_array=#()
	global add_bone_array2=#() 
)
rollout help_bone "生成bip辅助Bone" width:310
(
	label lab6 "说明:" align:#left
	label lab1 "1.先在场景中选择FBX的节点，再点击列表的对应位置" align:#left
	label lab2 "2.单击添加当前选择的节点，双击删除" align:#left
	label lab7 "Bip匹配列表:" align:#left
	dotNetControl biped_list "System.Windows.Forms.ListView" height:250
	spinner spn "Bone大小" width:80 height:16 range:[0.001,100,1] scale:0.01 align:#center  offset:[16,0] toolTip:"仅美观，对动画无影响"
	button Re_pose "重置蒙皮pose" width:80 height:25 align:#center  toolTip:"重置蒙皮pose" across:3
	button savename "保存匹配" width:80 height:25 align:#center 
	button loadname "加载匹配" width:80 height:25 align:#center  
	button but "确定" width:120 height:35  align:#center 
	checkbutton hide1 "隐藏" width:32 height:30  align:#center pos:[220,384] toolTip:"隐藏模型和虚拟体"
	fn Re_Tpose3 _Model _node=
	(
		max modify mode
		local tpose_name=#()
		local tpose_pose=#()
		local root_pose=#()
		local root_node=#()
		local allChildren=#()
		local bip_bool=false
		local complete_pose=#()
		unfreeze objects
		for i=1 to _Model.count do(
			_skin=_Model[i].modifiers[#Skin]
			modPanel.setCurrentObject _skin
			skinbone_count=skinops.getnumberbones _skin
			for ii=1 to skinbone_count do(
				a=skinOps.GetBoneName  _skin ii 0
				index=finditem tpose_name a
				if index==0 do(
					append tpose_name a
					append tpose_pose (skinUtils.GetBoneBindTM _Model[i] (getNodeByName a))
					if (matchpattern a pattern:"*Bip*Pelvis*") do (
						bip_bool=true
						append root_pose (skinUtils.GetBoneBindTM _Model[i] (getNodeByName a))
						try (
							append root_node (getNodeByName a).parent
							)catch (
							messagebox "bip骨架缺少根骨骼"
							)
						)
				)
			)
		)
		if bip_bool then(
			if root_node.count!=0 do(
				animate on
				at time 0(
					for i=1 to root_node.count do(
						root_node[i].transform=root_pose[i]
						in coordsys local rotate root_node[i] (eulerangles 0 0 90)
						in coordsys local	rotate root_node[i] (eulerangles 90 0 0)
						allChildren= GetallChildren root_node[i] 
						for ii=1 to allChildren.count do (
							index=finditem tpose_name allChildren[ii].name
							if index!=0 do(
								allChildren[ii].transform=tpose_pose[index]
								append complete_pose allChildren[ii].name
							)
						)
					)
				)
			)
			for i=1 to tpose_name.count do (
					index=finditem complete_pose tpose_name[i]
					if index==0 do( 
						re_parent=Getpatent (getNodeByName(tpose_name[i]))
						re_all= GetallChildren re_parent
						for ii=1 to re_all.count do(
							index2= finditem tpose_name  re_all[ii].name
							if index2 !=0 do(
								animate on
								at time 0(
								re_all[ii].transform=tpose_pose[index2]
								)
							)
						)
						exit
					)
				)
		)else(
			for i=1 to _node.count do (
				index=finditem tpose_name _node[i].name
				if index!=0 do(
					animate on
					at time 0(
					_node[i].transform=tpose_pose[index]
					)
				)
			)
		)
	)
	on help_bone open do
	(
		global bip_name=#(
		"Bip_root","Bip_Pelvis(必须有)","Bip_Spine(必须有)","Bip_Spine1","Bip_Spine2","Bip_Spine3","Bip_Spine4","Bip_Neck(必须有)","Bip_Neck1","Bip_Neck2","Bip_Neck3","Bip_Neck4",
		"Bip_Head(必须有)","Bip_L_Clavicle(必须有)","Bip_L_UpperArm(必须有)","Bip_L_Forearm(必须有)","Bip_L_Hand(必须有)","Bip_L_Finger1_1","Bip_L_Finger1_2","Bip_L_Finger1_3","Bip_L_Finger2_1",
		"Bip_L_Finger2_2","Bip_L_Finger2_3","Bip_L_Finger3_1","Bip_L_Finger3_2","Bip_L_Finger3_3","Bip_L_Finger4_1","Bip_L_Finger4_2","Bip_L_Finger4_3","Bip_L_Finger5_1",
		"Bip_L_Finger5_2","Bip_L_Finger5_3","Bip_R_Clavicle(必须有)","Bip_R_UpperArm(必须有)","Bip_R_Forearm(必须有)","Bip_R_Hand(必须有)","Bip_R_Finger1_1","Bip_R_Finger1_2","Bip_R_Finger1_3","Bip_R_Finger2_1",
		"Bip_R_Finger2_2","Bip_R_Finger2_3","Bip_R_Finger3_1","Bip_R_Finger3_2","Bip_R_Finger3_3","Bip_R_Finger4_1","Bip_R_Finger4_2","Bip_R_Finger4_3","Bip_R_Finger5_1","Bip_R_Finger5_2",
		"Bip_R_Finger5_3","Bip_L_Thigh(必须有)","Bip_L_Calf(必须有)","Bip_L_HorseLink","Bip_L_Foot(必须有)","Bip_L_Toe1_1","Bip_L_Toe1_2","Bip_L_Toe1_3","Bip_L_Toe2_1","Bip_L_Toe2_2","Bip_L_Toe2_3",
		"Bip_L_Toe3_1","Bip_L_Toe3_2","Bip_L_Toe3_3","Bip_L_Toe4_1","Bip_L_Toe4_2","Bip_L_Toe4_3","Bip_L_Toe5_1","Bip_L_Toe5_2","Bip_L_Toe5_3","Bip_R_Thigh(必须有)","Bip_R_Calf(必须有)","Bip_R_HorseLink","Bip_R_Foot(必须有)",
		"Bip_R_Toe1_1","Bip_R_Toe1_2","Bip_R_Toe1_3","Bip_R_Toe2_1","Bip_R_Toe2_2","Bip_R_Toe2_3","Bip_R_Toe3_1","Bip_R_Toe3_2","Bip_R_Toe3_3","Bip_R_Toe4_1","Bip_R_Toe4_2","Bip_R_Toe4_3","Bip_R_Toe5_1",
		"Bip_R_Toe5_2","Bip_R_Toe5_3","Bip_Tail","Bip_Tail1","Bip_Tail2","Bip_Tail3","Bip_Tail4","Bip_Tail5","Bip_Tail6","Bip_Tail7","Bip_Tail8","Bip_Tail9",
		"Bip_Prop1","Bip_Prop2","Bip_Prop3"
		)
		global bip_name2=#(
		"Bip001","Bip001 Pelvis","Bip001 Spine","Bip001 Spine1","Bip001 Spine2","Bip001 Spine3","Bip001 Spine4","Bip001 Neck","Bip001 Neck1","Bip001 Neck2","Bip001 Neck3","Bip001 Neck4",
		"Bip001 Head","Bip001 L Clavicle","Bip001 L UpperArm","Bip001 L Forearm","Bip001 L Hand","Bip001 L Finger0","Bip001 L Finger01","Bip001 L Finger02","Bip001 L Finger1",
		"Bip001 L Finger11","Bip001 L Finger12","Bip001 L Finger2","Bip001 L Finger21","Bip001 L Finger22","Bip001 L Finger3","Bip001 L Finger31","Bip001 L Finger32","Bip001 L Finger4",
		"Bip001 L Finger41","Bip001 L Finger42","Bip001 R Clavicle","Bip001 R UpperArm","Bip001 R Forearm","Bip001 R Hand","Bip001 R Finger0","Bip001 R Finger01","Bip001 R Finger02","Bip001 R Finger1",
		"Bip001 R Finger11","Bip001 R Finger12","Bip001 R Finger2","Bip001 R Finger21","Bip001 R Finger22","Bip001 R Finger3","Bip001 R Finger31","Bip001 R Finger32","Bip001 R Finger4","Bip001 R Finger41",
		"Bip001 R Finger42","Bip001 L Thigh","Bip001 L Calf","Bip001 L HorseLink","Bip001 L Foot","Bip001 L Toe0","Bip001 L Toe01","Bip001 L Toe02","Bip001 L Toe1","Bip001 L Toe11","Bip001 L Toe12","Bip001 L Toe2",
		"Bip001 L Toe21","Bip001 L Toe22","Bip001 L Toe3","Bip001 L Toe31","Bip001 L Toe32","Bip001 L Toe4","Bip001 L Toe41","Bip001 L Toe42","Bip001 R Thigh","Bip001 R Calf","Bip001 R HorseLink","Bip001 R Foot",
		"Bip001 R Toe0","Bip001 R Toe01","Bip001 R Toe02","Bip001 R Toe1","Bip001 R Toe11","Bip001 R Toe12","Bip001 R Toe2","Bip001 R Toe21","Bip001 R Toe22","Bip001 R Toe3","Bip001 R Toe31","Bip001 R Toe32",
		"Bip001 R Toe4","Bip001 R Toe41","Bip001 R Toe42","Bip001 Tail","Bip001 Tail1","Bip001 Tail2","Bip001 Tail3","Bip001 Tail4","Bip001 Tail5","Bip001 Tail6","Bip001 Tail7","Bip001 Tail8","Bip001 Tail9",
		"Bip001 Prop1","Bip001 Prop2","Bip001 Prop3"
		)
		
		biped_list.View = (dotNetClass "System.Windows.Forms.View").Details 
		biped_list.gridLines = true 
		biped_list.fullRowSelect = true  
		biped_list.MultiSelect = false  
		layout_def = #("Biped Name", "FBX Name")
		biped_list.Columns.add layout_def[1] 140  
		biped_list.Columns.add layout_def[2] 110  

		global theRange = #()
		for i=1 to bip_name.count do
		(
		li = dotNetObject "System.Windows.Forms.ListViewItem" bip_name[i]  
		li.SubItems.add ""
		append theRange li 
		)
		biped_list.Items.AddRange theRange  
	)
	
	rollout savefileDialog "保存匹配"  width:250 height:120
	(
		label lbl1 "文件名:"  height:15 align:#left offset:[0,10]
		editText filenname ""  width:220 height:20 align:#left
		button savebtn "确定"  width:100 height:30 offset:[0,10] across:2
		button cancelbtn "取消"  width:100 height:30 offset:[0,10]

		on savebtn pressed do(
			try(
			if(filenname.text!= "")then(
				makeDir (GetDir #maxroot + "\\Scripts\\AutofbxtoBip")
				io = createFile (GetDir #maxroot + "\\Scripts\\AutofbxtoBip/"+filenname.text+".btf")
				if(io != undefined)do(
					for i = 1 to theRange.count do(
						if(theRange[i].subitems.item[1].text == undefined)then(
							format "\n" to:io
						)else(
							format "%\n" theRange[i].subitems.item[1].text to:io
						)
					)
					close io
					DestroyDialog savefileDialog
				)
			)else(
				messagebox"请输入名称"
				)
			)catch()
		)
		on cancelbtn pressed do(
			DestroyDialog savefileDialog
		)
		
	)
	rollout loadfileDialog "加载匹配" width:250 height:120
	(
		dropDownList ddl1 "匹配模板" height:20 align:#left offset:[0,10]
		button loadbtn "加载" width:100 height:30 offset:[0,10] across:2
		button cancelbtn "取消"width:100 height:30 offset:[0,10]
		on loadfileDialog open do( 
				local templates = getFiles (GetDir #maxroot + "\\Scripts\\AutofbxtoBip\\*.btf") 
				local count = templates.count 
				for p = 1 to count do(
					string_text = templates[p] 										
					string_text = replace string_text (string_text.count-3) 4 ""	
					do (																		
					num = undefined																
					num = findString string_text "\\"											
						if num != undefined do (
					string_text = replace string_text num 1 "/"							
						)
					)While num != undefined													
					
				strings = filterString string_text "'/"											
				templates[p] = strings[strings.count]	
				)
				ddl1.items = templates
		)
		on loadbtn pressed do
		(
		local file = (GetDir #maxroot + "\\Scripts\\AutofbxtoBip/")
		file+=(ddl1.selected  + ".btf")
		local fileIO
		try(
		fileIO = openFile file
		)catch(
			messagebox "加载出错"
			return 0
		)		
		for i = 1 to theRange.count do(
			local name_Temp = readLine fileIO
			theRange[i].subitems.item[1].text=name_Temp
		)
		flush fileIO
		close fileIO
		DestroyDialog loadfileDialog
		)
		on cancelbtn pressed do
		(
				DestroyDialog loadfileDialog
		)
	)
		
	on hide1 changed state do
	(
		if state then
		(
			hide_obj=for i in objects where ((superclassof i==helper or classof i==Editable_mesh or classof i==PolyMeshObject or classof i==Editable_Poly)) collect i
			hide hide_obj
			hide1.text="显示"
		)
		else
		(
			hide_obj=for i in objects where ((superclassof i==helper or classof i==Editable_mesh or classof i==PolyMeshObject or classof i==Editable_Poly)) collect i
			unhide hide_obj
			hide1.text="隐藏"
		)
	)	
		
	on savename pressed do
	(
			createDialog savefileDialog width:250 height:120 style:#(#style_border,#style_titlebar)
		)
	on loadname pressed do
	(
			createDialog loadfileDialog width:250 height:120 style:#(#style_border,#style_titlebar)
		)

	on Re_pose pressed do(
	_model=#()
	_node=#()
	for i in objects where (classof i==Editable_mesh or classof i==PolyMeshObject or classof i==Editable_Poly) and (i.modifiers[#Skin]!=undefined) do append  _model i
	for i in objects where (classof i==Dummy or classof i==BoneGeometry) do append  _node i

	try (
		Re_Tpose3 _model _node
		animationRange = interval 0 animationRange.end 
		sliderTime = 0f
		)catch( messagebox "重置失败")
	)
	

	on biped_list MouseClick sel do
	(

		local control1 = dotNetObject "System.Windows.Forms.Control"
		local point1 = biped_list.PointToClient control1.MousePosition
		local item1 = biped_list.GetItemAt point1.x point1.y
		local index = item1.index + 1
		if selection[1] != undefined do(
		theRange[index].subitems.item[1].text = selection[1].name
		)
	)
	

	on biped_list MouseDoubleClick sel do
	(
		local control1 = dotNetObject "System.Windows.Forms.Control"
		local point1 = biped_list.PointToClient control1.MousePosition
		local item1 = biped_list.GetItemAt point1.x point1.y
		local index = item1.index + 1
		theRange[index].subitems.item[1].text = ""
	)
	
	global fbone3=#()
	global fbone4=#()
	global link_Target=#()
	

	fn node_number index_min index_max=
	(
		index=0
		for i=index_min to index_max do(
			fbone=getNodeByName theRange[i].subitems.item[1].text
			if fbone!=undefinde do(
			index+=1
			)
		)
		return index
	)
	
	fn creat_bone index_min index_max=
	(
		index=0
		for i=index_min to index_max do(
			fbone=getNodeByName theRange[i].subitems.item[1].text
			if fbone!=undefinde do(
			index+=1
			)
		)
		for i=index_min to index_min+index-1 do(
			fbone=getNodeByName theRange[i].subitems.item[1].text
			if i <index_min+index-1 then(
			fbone2=getNodeByName theRange[i+1].subitems.item[1].text
			append fbone3 (BoneSys.createBone fbone.transform.pos (fbone2.transform.pos) (fbone.dir))
			)else(
				fbone2=getNodeByName theRange[index_max+1].subitems.item[1].text
				append fbone3 (BoneSys.createBone fbone.transform.pos (fbone2.transform.pos) (fbone.dir))
				)
			append fbone4 fbone.name
			setInheritanceFlags fbone3[fbone3.count] #{1,2,3,7,8,9} 
			fbone3[fbone3.count].wirecolor = color 176 26 26
			fbone3[fbone3.count].boneEnable=false
			fbone3[fbone3.count].frontfin=true
			fbone3[fbone3.count].frontfinsize=spn.value/2
			fbone3[fbone3.count].width =spn.value
			fbone3[fbone3.count].height=spn.value
			fbone3[fbone3.count].name=bip_name2[i]	
			append link_Target fbone
			fbone3[fbone3.count].parent=fbone3[fbone3.count-1]
		)
	)

	fn creat_one_bone index=
	(
		fbone=getNodeByName theRange[index].subitems.item[1].text 
		append fbone3 (BoneSys.createBone fbone.transform.pos (fbone.transform.pos*1.1) (fbone.dir))
		append fbone4 fbone.name
		setInheritanceFlags fbone3[fbone3.count] #{1,2,3,7,8,9} 
		fbone3[fbone3.count].wirecolor = color 176 26 26
		fbone3[fbone3.count].transform =fbone.transform
		fbone3[fbone3.count].width =spn.value
		fbone3[fbone3.count].height=spn.value
		fbone3[fbone3.count].length=spn.value*4
		fbone3[fbone3.count].name=bip_name2[index]
		fbone3[fbone3.count].boneEnable=false
		fbone3[fbone3.count].frontfin=true
		fbone3[fbone3.count].frontfinsize=spn.value/2
		append link_Target fbone
		fbone3[fbone3.count].parent=fbone3[fbone3.count-1]	
		try(
		c = copy fbone3[fbone3.count].parent.transform
		c.pos = fbone3[fbone3.count].transform.position
		fbone3[fbone3.count].transform = c
		) catch()
	)
	

	on but pressed do(
		Lack_bone=#()
		L_Finger_nub=node_number 18 32
		R_Finger_nub=node_number 37 51
		L_Toe_nub=node_number 56 70
		R_Toe_nub=node_number 75 89
		link_Target=#()
		local a=#(2,3,8,13,14,15,16,17,33,34,35,36,52,53,55,71,72,74)
		for i in a do (
			if((getNodeByName theRange[i].subitems.item[1].text)==undefined)do(
				append Lack_bone bip_name[i]
				)
			)
			
		max create mode
	if 	(Lack_bone.count==0) and (L_Finger_nub==R_Finger_nub)and (L_Toe_nub==R_Toe_nub)then(
		--try (
			if ((getNodeByName theRange[1].subitems.item[1].text)==undefined) do(
			a=getNodeByName theRange[2].subitems.item[1].text
			b=BoneSys.createBone [0,0,0] [1,0,0] [0,0,1]
			rotate b (angleaxis -90 [0,0,1])
			b.width =spn.value
			b.height=spn.value
			b.length=spn.value*4
			b.pos=a.pos
			b.parent=a
			if (theRange[1].subitems.item[1].text=="")then(
				theRange[1].subitems.item[1].text=b.name
				)else(
				b.name=theRange[1].subitems.item[1].text
				)
			)
			actionMan.executeAction 0 "50002"
			toolMode.pivotCenter()
			toolMode.coordsys #local
			move0=getNodeByName theRange[1].subitems.item[1].text 
			move1=getNodeByName theRange[52].subitems.item[1].text 
			move2=getNodeByName theRange[71].subitems.item[1].text 
			--move1.pos.z=move0.pos.z
			move1.pos.y=move0.pos.y
			--move2.pos.z=move0.pos.z
			move2.pos.y=move0.pos.y
			
			ET=	ExposeTransform()
			PT=Point()
			fbone3=#()
			fbone4=#()
			fbone=getNodeByName theRange[1].subitems.item[1].text 
			append fbone3 (BoneSys.createBone fbone.transform.pos (fbone.transform.pos*1.1) (fbone.dir))
			append fbone4 fbone.name
			setInheritanceFlags fbone3[fbone3.count] #{1,2,3,7,8,9} 
			fbone3[fbone3.count].wirecolor = color 176 26 26
		--	fbone3[1].transform =fbone.transform
			fbone3[1].rotation=(eulerangles 0 0 90)
			fbone3[1].pos =fbone.pos	
			fbone3[1].width =spn.value
			fbone3[1].height=spn.value
			fbone3[1].length=spn.value*4
			fbone3[1].name=bip_name2[1]
			fbone3[1].boneEnable=false
			fbone3[1].frontfin=true
			fbone3[1].frontfinsize=spn.value/2
			append link_Target fbone
			creat_bone 2 2
			if fbone3[2].length<0.01 do(
				fbone3[2].length=spn.value*2
				)
			fbone3[2].transform=fbone3[1].transform
			in coordsys local rotate fbone3[2] (eulerangles -90 -90 0)
				
			creat_bone 3 7
				
			for i=3 to fbone3.count do(
			in coordsys local rotate fbone3[i] (eulerangles -(((fbone3[i].transform.rotation-fbone3[i].parent.transform.rotation)as eulerangles).z) 0 0)
			)

			bone_index=fbone3.count+1
			creat_bone 8 12
			
			for i=bone_index to fbone3.count do(
			in coordsys local rotate fbone3[i] (eulerangles -(((fbone3[i].transform.rotation-fbone3[i].parent.transform.rotation)as eulerangles).z) 0 0)
			)
			
-- 			bone_index=fbone3.count+1
-- 			creat_one_bone 13
-- 			fbone3[fbone3.count].length=fbone3[fbone3.count-1].length
			
			fbone=getNodeByName theRange[13].subitems.item[1].text 
			append fbone3 (BoneSys.createBone fbone.transform.pos (fbone.transform.pos*1.1) (fbone.dir))
			append fbone4 fbone.name
			setInheritanceFlags fbone3[fbone3.count] #{1,2,3,7,8,9} 
			fbone3[fbone3.count].wirecolor = color 176 26 26
			fbone3[fbone3.count].rotation =(eulerAngles 0 -90 180)
			fbone3[fbone3.count].pos =fbone.pos
			fbone3[fbone3.count].width =spn.value
			fbone3[fbone3.count].height=spn.value
			fbone3[fbone3.count].length=fbone3[fbone3.count-1].length
			fbone3[fbone3.count].name=bip_name2[13]
			fbone3[fbone3.count].boneEnable=false
			fbone3[fbone3.count].frontfin=true
			fbone3[fbone3.count].frontfinsize=spn.value/2
			append link_Target fbone
			fbone3[fbone3.count].parent=fbone3[fbone3.count-1]	
			
-- 			for i=bone_index to fbone3.count do(
-- 			in coordsys local rotate fbone3[i] (eulerangles  -(((fbone3[i].transform.rotation-fbone3[i].parent.transform.rotation)as eulerangles).z) 0 0)
-- 			)
			
			bone_index=fbone3.count+1
			creat_bone 14 16
			index=0
			for i=1 to 7 do(
				fbone=getNodeByName theRange[i].subitems.item[1].text
				if fbone!=undefinde do(
				index+=1
				)
			)

			fbone3[bone_index].parent=PT 
			ET.exposeNode=fbone3[bone_index]
				for ii=1 to 3 do(
					if (ET.localEulerX>=0 and ET.localEulerX<=30)or (ET.localEulerX<=0 and ET.localEulerX>=-30)then(
						exit
						)else(
						in coordsys local rotate fbone3[bone_index] (eulerangles  90 0 0)
						)
				)
			
			fbone3[fbone3.count-2].parent=fbone3[index] 
			
			for i=bone_index+1 to fbone3.count do(  
			ET.exposeNode=fbone3[i]
				for ii=1 to 3 do(
					if (ET.localEulerX>=0 and ET.localEulerX<=30)or (ET.localEulerX<=0 and ET.localEulerX>=-30)then(
						exit
						)else(
						in coordsys local rotate fbone3[i] (eulerangles  90 0 0)
						)
				)
			)
			
			creat_one_bone 17
			fbone3[fbone3.count].length=fbone3[fbone3.count-1].length/2
			L_finger_index=fbone3.count
			
			ET.exposeNode=fbone3[fbone3.count]
			for ii=1 to 3 do(
				if (ET.localEulerX<=-60 and ET.localEulerX>=-120)then(
					exit
					)else(
					in coordsys local rotate fbone3[fbone3.count] (eulerangles  90 0 0)
					)
			)
			
			bone_index=fbone3.count+1
			
			L_finger=#(18,19,21,22,24,25,27,28,30,31)
			L_finger2=#(20,23,26,29,32)
			L_finger3=#(18,19,20,21,22,23,24,25,26,27,28,29,30,31,32)
			ro_finger=#()
			for i in L_finger3 do(
				fbone=getNodeByName theRange[i].subitems.item[1].text
				if fbone!=undefinde do(  
					aa= finditem L_finger i 
					if aa != 0 then(
						fbone2=getNodeByName theRange[i+1].subitems.item[1].text
						if fbone2!=undefinde then( 
							append fbone3 (BoneSys.createBone fbone.transform.pos (fbone2.transform.pos) (fbone.dir))
							append fbone4 fbone.name
							setInheritanceFlags fbone3[fbone3.count] #{1,2,3,7,8,9} 
							fbone3[fbone3.count].wirecolor = color 176 26 26
							fbone3[fbone3.count].boneEnable=false
							fbone3[fbone3.count].frontfin=true
							fbone3[fbone3.count].width =spn.value/2
							fbone3[fbone3.count].height=spn.value/2
							fbone3[fbone3.count].frontfinsize=spn.value/4
							fbone3[fbone3.count].name=bip_name2[i]	
							append link_Target fbone
							if i==18 or i==19 do(
								append ro_finger fbone3[fbone3.count]
								)
							if i==18 or i==21 or i==24 or i==27 or i==30 then (
								fbone3[fbone3.count].parent=fbone3[L_finger_index]
								)else(
							fbone3[fbone3.count].parent=fbone3[fbone3.count-1]
							)
						)else(
							creat_one_bone i
							fbone3[fbone3.count].width =spn.value/2
							fbone3[fbone3.count].height=spn.value/2
							fbone3[fbone3.count].length=spn.value
							fbone3[fbone3.count].frontfinsize=spn.value/4
							)
					)else(
							creat_one_bone i
							fbone3[fbone3.count].width =spn.value/2
							fbone3[fbone3.count].height=spn.value/2
							fbone3[fbone3.count].length=spn.value
							fbone3[fbone3.count].frontfinsize=spn.value/4
							if i==20 do (
								fbone3[fbone3.count].parent=fbone3[L_finger_index+2]
								append ro_finger fbone3[fbone3.count]
								)
							if i==23 do (
								fbone3[fbone3.count].parent=fbone3[L_finger_index+5]
								)
							if i==26 do (
								fbone3[fbone3.count].parent=fbone3[L_finger_index+8]
								)
							if i==29 do (
								fbone3[fbone3.count].parent=fbone3[L_finger_index+11]
								)
							if i==32 do (
								fbone3[fbone3.count].parent=fbone3[L_finger_index+14]
								)
							try(
								c = copy fbone3[fbone3.count].parent.transform
								c.pos = fbone3[fbone3.count].transform.position
								fbone3[fbone3.count].transform = c
								) catch()
							)
				)
			)

			for i=bone_index to fbone3.count do(
			ET.exposeNode=fbone3[i]
				for ii=1 to 3 do(
					if (ET.localEulerX>=0 and ET.localEulerX<=30)or (ET.localEulerX<=0 and ET.localEulerX>=-30)then(
						exit
						)else(
						in coordsys local rotate fbone3[i] (eulerangles  90 0 0)
						)
				)
			)
			
			if (getNodeByName theRange[21].subitems.item[1].text)!=undefined do( 
				for i in ro_finger do (
					in coordsys local rotate i (eulerangles  90 0 0)
				)
			)
			
			bone_index=fbone3.count+1
			creat_bone 33 35
			index=0
			for i=1 to 7 do(
				fbone=getNodeByName theRange[i].subitems.item[1].text
				if fbone!=undefinde do(
				index+=1
				)
			)
			
			fbone3[bone_index].parent=PT 
			ET.exposeNode=fbone3[bone_index]
				for ii=1 to 3 do(
					if (ET.localEulerX>=150 and ET.localEulerX<=180)or (ET.localEulerX<=-150 and ET.localEulerX>=-180)then(
						exit
						)else(
						in coordsys local rotate fbone3[bone_index] (eulerangles  90 0 0)
						)
				)
			
			fbone3[fbone3.count-2].parent=fbone3[index]
				
			for i=bone_index+1 to fbone3.count do(  
			ET.exposeNode=fbone3[i]
				for ii=1 to 3 do(
					if (ET.localEulerX>=0 and ET.localEulerX<=30)or (ET.localEulerX<=0 and ET.localEulerX>=-30)then(
						exit
						)else(
						in coordsys local rotate fbone3[i] (eulerangles  90 0 0)
						)
				)
			)	
				
			creat_one_bone 36
			fbone3[fbone3.count].length=fbone3[fbone3.count-1].length/2
			R_finger_index=fbone3.count
			
			ET.exposeNode=fbone3[fbone3.count]
			for ii=1 to 3 do(
				if (ET.localEulerX<=120 and ET.localEulerX>=60)then(
					exit
					)else(
					in coordsys local rotate fbone3[fbone3.count] (eulerangles  90 0 0)
					)
			)

			bone_index=fbone3.count+1
			--creat_bone 37 51
			R_finger=#(37,38,40,41,43,44,46,47,49,50)
			R_finger2=#(39,42,45,48,51)
			R_finger3=#(37,38,39,40,41,42,43,44,45,46,47,48,49,50,51)
			ro_finger=#()
			for i in R_finger3 do(
				fbone=getNodeByName theRange[i].subitems.item[1].text
				if fbone!=undefinde do(  
					aa= finditem R_finger i  
					if aa != 0 then(
						fbone2=getNodeByName theRange[i+1].subitems.item[1].text 
						if fbone2!=undefinde then( 
							append fbone3 (BoneSys.createBone fbone.transform.pos (fbone2.transform.pos) (fbone.dir))
							append fbone4 fbone.name
							setInheritanceFlags fbone3[fbone3.count] #{1,2,3,7,8,9} 
							fbone3[fbone3.count].wirecolor = color 176 26 26
							fbone3[fbone3.count].boneEnable=false
							fbone3[fbone3.count].frontfin=true
							fbone3[fbone3.count].width =spn.value/2
							fbone3[fbone3.count].height=spn.value/2
							fbone3[fbone3.count].frontfinsize=spn.value/4
							fbone3[fbone3.count].name=bip_name2[i]	
							append link_Target fbone
							if i==37 or i==38 do(
								append ro_finger fbone3[fbone3.count]
								)
							if i==37 or i==40 or i==43 or i==46 or i==49 then (
								fbone3[fbone3.count].parent=fbone3[R_finger_index]
								)else(
							fbone3[fbone3.count].parent=fbone3[fbone3.count-1]
							)
						)else(
							creat_one_bone i
							fbone3[fbone3.count].width =spn.value/2
							fbone3[fbone3.count].height=spn.value/2
							fbone3[fbone3.count].length=spn.value
							fbone3[fbone3.count].frontfinsize=spn.value/4
							)
					)else(
							creat_one_bone i
							fbone3[fbone3.count].width =spn.value/2
							fbone3[fbone3.count].height=spn.value/2
							fbone3[fbone3.count].length=spn.value
							fbone3[fbone3.count].frontfinsize=spn.value/4
							if i==39 do (
								fbone3[fbone3.count].parent=fbone3[R_finger_index+2]
								append ro_finger fbone3[fbone3.count]
								)
							if i==42 do (
								fbone3[fbone3.count].parent=fbone3[R_finger_index+5]
								)
							if i==45 do (
								fbone3[fbone3.count].parent=fbone3[R_finger_index+8]
								)
							if i==48 do (
								fbone3[fbone3.count].parent=fbone3[R_finger_index+11]
								)
							if i==51 do (
								fbone3[fbone3.count].parent=fbone3[R_finger_index+14]
								)
							try(
							c = copy fbone3[fbone3.count].parent.transform
							c.pos = fbone3[fbone3.count].transform.position
							fbone3[fbone3.count].transform = c
							) catch()
							)
				)
			)

			for i=bone_index to fbone3.count do(
			ET.exposeNode=fbone3[i]
				for ii=1 to 3 do(
					if (ET.localEulerX>=0 and ET.localEulerX<=30)or (ET.localEulerX<=0 and ET.localEulerX>=-30)then(
						exit
						)else(
						in coordsys local rotate fbone3[i] (eulerangles  90 0 0)
						)
				)
			)
			
			if (getNodeByName theRange[40].subitems.item[1].text)!=undefined do( 
				for i in ro_finger do (
					in coordsys local rotate i (eulerangles  -90 0 0)
				)
			)
			
			bone_index=fbone3.count+1
			fbone=getNodeByName theRange[54].subitems.item[1].text
			if fbone==undefinde then(
				creat_bone 52 52
				fbone3[fbone3.count].parent=fbone3[2]
				fbone=getNodeByName theRange[53].subitems.item[1].text
				fbone2=getNodeByName theRange[55].subitems.item[1].text
				append fbone3 (BoneSys.createBone fbone.transform.pos (fbone2.transform.pos) (fbone.dir))
				append fbone4 fbone.name
				fbone3[fbone3.count].boneEnable=false
				setInheritanceFlags fbone3[fbone3.count] #{1,2,3,7,8,9} 
				fbone3[fbone3.count].wirecolor = color 176 26 26
				fbone3[fbone3.count].frontfin=true
				fbone3[fbone3.count].frontfinsize=spn.value/2
				fbone3[fbone3.count].width =spn.value
				fbone3[fbone3.count].height=spn.value
				fbone3[fbone3.count].name=bip_name2[53]
				append link_Target fbone
				fbone3[fbone3.count].parent=fbone3[fbone3.count-1]
				creat_one_bone 55
				fbone3[fbone3.count].length=fbone3[fbone3.count-1].length/2
				L_Foot_index=fbone3.count
				)else(
				creat_bone 52 54
				fbone3[fbone3.count-2].parent=fbone3[2]
				creat_one_bone 55
				fbone3[fbone3.count].length=fbone3[fbone3.count-1].length/4
				L_Foot_index=fbone3.count
				)
			
			ET.exposeNode=fbone3[bone_index]
			for i=1 to 3 do(
				if (ET.localEulerX>=160 and ET.localEulerX<=180) or (ET.localEulerX>=-180 and ET.localEulerX<=-160) then(
					exit
					)else(
					in coordsys local rotate fbone3[bone_index] (eulerangles  90 0 0)
					)
			)
			
			for i=bone_index+1 to fbone3.count do(
				ET.exposeNode=fbone3[i]
				for ii=1 to 3 do(
					if (ET.localEulerX>=0 and ET.localEulerX<=30)or (ET.localEulerX<=0 and ET.localEulerX>=-30)then(
						exit
						)else(
						in coordsys local rotate fbone3[i] (eulerangles  90 0 0)
						)
				)
			)	
			a=(fbone3[fbone3.count].transform.rotation as eulerangles).y-90
			rotate fbone3[fbone3.count] (angleaxis a [1,0,0])
-- 			for i=bone_index to fbone3.count do(
-- 			in coordsys local rotate fbone3[i] (eulerangles  -(((fbone3[i].transform.rotation-fbone3[i].parent.transform.rotation)as eulerangles).z) 0 0)
-- 			)
-- 			for i=bone_index+1 to fbone3.count do(
-- 			in coordsys local rotate fbone3[i] (eulerangles  (((fbone3[i].transform.rotation-fbone3[i].parent.transform.rotation)as eulerangles).z) 0 0)
-- 			)	
				
			
			bone_index=fbone3.count+1
			--creat_bone 56 70
			L_toe=#(56,57,59,60,62,63,65,66,68,69)
			L_toe2=#(58,61,64,67,70)
			L_toe3=#(56,57,58,59,60,61,62,63,64,65,66,67,68,69,70)
			for i in L_toe3 do(
				fbone=getNodeByName theRange[i].subitems.item[1].text
				if fbone!=undefinde do(  
					aa= finditem L_toe i  
					if aa != 0 then(
						fbone2=getNodeByName theRange[i+1].subitems.item[1].text
						if fbone2!=undefinde then(
							append fbone3 (BoneSys.createBone fbone.transform.pos (fbone2.transform.pos) (fbone.dir))
							append fbone4 fbone.name
							setInheritanceFlags fbone3[fbone3.count] #{1,2,3,7,8,9} 
							fbone3[fbone3.count].wirecolor = color 176 26 26
							fbone3[fbone3.count].boneEnable=false
							fbone3[fbone3.count].frontfin=true
							fbone3[fbone3.count].width =spn.value/2
							fbone3[fbone3.count].height=spn.value/2
							fbone3[fbone3.count].frontfinsize=spn.value/4
							fbone3[fbone3.count].name=bip_name2[i]	
							append link_Target fbone
							if i==56 or i==59 or i==62 or i==65 or i==68 then (
								fbone3[fbone3.count].parent=fbone3[L_Foot_index]
								)else(
							fbone3[fbone3.count].parent=fbone3[fbone3.count-1]
							)
						)else(
							creat_one_bone i
							fbone3[fbone3.count].width =spn.value/2
							fbone3[fbone3.count].height=spn.value/2
							fbone3[fbone3.count].length=spn.value
							fbone3[fbone3.count].frontfinsize=spn.value/4
							)
					)else(
							creat_one_bone i
							fbone3[fbone3.count].width =spn.value/2
							fbone3[fbone3.count].height=spn.value/2
							fbone3[fbone3.count].length=spn.value
							fbone3[fbone3.count].frontfinsize=spn.value/4
							if i==58 do (
								fbone3[fbone3.count].parent=fbone3[L_Foot_index+2]
								)
							if i==61 do (
								fbone3[fbone3.count].parent=fbone3[L_Foot_index+5]
								)
							if i==64 do (
								fbone3[fbone3.count].parent=fbone3[L_Foot_index+8]
								)
							if i==67 do (
								fbone3[fbone3.count].parent=fbone3[L_Foot_index+11]
								)
							if i==70 do (
								fbone3[fbone3.count].parent=fbone3[L_Foot_index+14]
								)
							try(
								c = copy fbone3[fbone3.count].parent.transform  
								c.pos = fbone3[fbone3.count].transform.position
								fbone3[fbone3.count].transform = c
								) catch()
							)
				)
			)
			for i=bone_index to fbone3.count do(
			in coordsys local rotate fbone3[i] (eulerangles 0 0 90)
			)
			
			bone_index=fbone3.count+1
			fbone=getNodeByName theRange[73].subitems.item[1].text
			if fbone==undefinde then(
				creat_bone 71 71
				fbone3[fbone3.count].parent=fbone3[2]
				fbone=getNodeByName theRange[72].subitems.item[1].text
				fbone2=getNodeByName theRange[74].subitems.item[1].text
				append fbone3 (BoneSys.createBone fbone.transform.pos (fbone2.transform.pos) (fbone.dir))
				append fbone4 fbone.name
				setInheritanceFlags fbone3[fbone3.count] #{1,2,3,7,8,9} 
				fbone3[fbone3.count].wirecolor = color 176 26 26
				fbone3[fbone3.count].boneEnable=false
				fbone3[fbone3.count].frontfin=true
				fbone3[fbone3.count].frontfinsize=spn.value/2
				fbone3[fbone3.count].width =spn.value
				fbone3[fbone3.count].height=spn.value
				fbone3[fbone3.count].name=bip_name2[72]	
				append link_Target fbone
				fbone3[fbone3.count].parent=fbone3[fbone3.count-1]
				creat_one_bone 74
				fbone3[fbone3.count].length=fbone3[fbone3.count-1].length/2
				R_Foot_index=fbone3.count
				)else(
				creat_bone 71 73
				fbone3[fbone3.count-2].parent=fbone3[2]
				creat_one_bone 74
				fbone3[fbone3.count].length=fbone3[fbone3.count-1].length/4
				R_Foot_index=fbone3.count
				)
				
			ET.exposeNode=fbone3[bone_index]
			for i=1 to 3 do(
				if (ET.localEulerX>=160 and ET.localEulerX<=180)or (ET.localEulerX>=-180 and ET.localEulerX<=-160)then(
					exit
					)else(
					in coordsys local rotate fbone3[bone_index] (eulerangles  90 0 0)
					)
			)
			for i=bone_index+1 to fbone3.count do(
				ET.exposeNode=fbone3[i]
				for ii=1 to 3 do(
					if (ET.localEulerX>=0 and ET.localEulerX<=30)or (ET.localEulerX<=0 and ET.localEulerX>=-30)then(
						exit
						)else(
						in coordsys local rotate fbone3[i] (eulerangles  90 0 0)
						)
				)
			)	
			a=(fbone3[fbone3.count].transform.rotation as eulerangles).y-90
			rotate fbone3[fbone3.count] (angleaxis a [1,0,0])
-- 			for i=bone_index to bone_index do(
-- 			in coordsys local rotate fbone3[i] (eulerangles  -(((fbone3[i].transform.rotation-fbone3[i].parent.transform.rotation)as eulerangles).z) 0 0)
-- 			)
-- 			for i=bone_index+1 to fbone3.count do(
-- 			in coordsys local rotate fbone3[i] (eulerangles  (((fbone3[i].transform.rotation-fbone3[i].parent.transform.rotation)as eulerangles).z) 0 0)
-- 			)
			
			bone_index=fbone3.count+1
			--creat_bone 75 89
			R_toe=#(75,76,78,79,81,82,84,85,87,88)
			R_toe2=#(77,80,83,86,89)
			R_toe3=#(75,76,77,78,79,80,81,82,83,84,85,86,87,88,89)	
			for i in R_toe3 do(
				fbone=getNodeByName theRange[i].subitems.item[1].text
				if fbone!=undefinde do( 
					aa= finditem R_toe i 
					if aa != 0 then(
						fbone2=getNodeByName theRange[i+1].subitems.item[1].text
						if fbone2!=undefinde then( 
							append fbone3 (BoneSys.createBone fbone.transform.pos (fbone2.transform.pos) (fbone.dir))
							append fbone4 fbone.name
							setInheritanceFlags fbone3[fbone3.count] #{1,2,3,7,8,9} 
							fbone3[fbone3.count].wirecolor = color 176 26 26
							fbone3[fbone3.count].boneEnable=false
							fbone3[fbone3.count].frontfin=true
							fbone3[fbone3.count].width =spn.value/2
							fbone3[fbone3.count].height=spn.value/2
							fbone3[fbone3.count].frontfinsize=spn.value/4
							fbone3[fbone3.count].name=bip_name2[i]	
							append link_Target fbone
							if i==75 or i==78 or i==81 or i==84 or i==87 then (
								fbone3[fbone3.count].parent=fbone3[R_Foot_index]
								)else(
								fbone3[fbone3.count].parent=fbone3[fbone3.count-1]
							)
						)else(
							creat_one_bone i
							fbone3[fbone3.count].width =spn.value/2
							fbone3[fbone3.count].height=spn.value/2
							fbone3[fbone3.count].length=spn.value
							fbone3[fbone3.count].frontfinsize=spn.value/4
							)
					)else(
							creat_one_bone i
							fbone3[fbone3.count].width =spn.value/2
							fbone3[fbone3.count].height=spn.value/2
							fbone3[fbone3.count].length=spn.value
							fbone3[fbone3.count].frontfinsize=spn.value/4
							if i==77 do (
								fbone3[fbone3.count].parent=fbone3[R_Foot_index+2]
								)
							if i==80 do (
								fbone3[fbone3.count].parent=fbone3[R_Foot_index+5]
								)
							if i==83 do (
								fbone3[fbone3.count].parent=fbone3[R_Foot_index+8]
								)
							if i==86 do (
								fbone3[fbone3.count].parent=fbone3[R_Foot_index+11]
								)
							if i==89 do (
								fbone3[fbone3.count].parent=fbone3[R_Foot_index+14]
								)
							try(
								c = copy fbone3[fbone3.count].parent.transform  
								c.pos = fbone3[fbone3.count].transform.position
								fbone3[fbone3.count].transform = c
								) catch()
							)
				)
			)
			for i=bone_index to fbone3.count do(
			in coordsys local rotate fbone3[i] (eulerangles 0 0 90)
			)
			for i=1 to link_Target.count do (
				setInheritanceFlags fbone3[i] #{1,2,3,4,5,6,7,8,9}	
			)
			for i=1 to link_Target.count do (
				a=fbone3[i].parent
				fbone3[i].parent=undefined
				fbone3[i].transform.controller=link_constraint() 
				fbone3[i].transform.controller.addTarget link_Target[i] 0
				if a!=undefined do(
					fbone3[i].parent=a
					)
				)
				
			delete ET
			delete PT
			
			global tc4
			tc4 = layerManager.getLayerFromName"Help_bip"  	
			if  tc4 ==undefined then (
			tc4=LayerManager.newLayerFromName "Help_bip" 
			)else(
			tc4=LayerManager.getLayerFromName"Help_bip"
			)
			for n in fbone3 do tc4.addNode n
		--) catch(messagebox"生成骨骼出错")
	)else(
		if Lack_bone.count!=0 do(
			Lack_bone_name=""
			for i in Lack_bone do(Lack_bone_name+=(i+"\r"))
			Lack_bone_name="缺少骨骼："+"\r"+Lack_bone_name
			messagebox Lack_bone_name title:"缺少骨骼："
			)
		if L_Finger_nub!=R_Finger_nub do(
			messagebox "左边手指不等于右边手指数量"
			)
		if L_Toe_nub!=R_Toe_nub do(
			messagebox "左边脚趾不等于右边脚趾数量"
			)	
		)
	)
)
rollout help_bone2 "生成飘带辅助Bone" width:310
(
	label lab4 "说明:" align:#left
	label lab5 "1.先选择bone的节点，再点添加" align:#left
	label lab3 "Bone列表:" align:#left
	listbox bone_list height:10
	button add_bone "   添加   " height:25 across:3
	button delete_bone "   删除   " height:25
	button deleteall_bone " 删除全部 "	height:25
	spinner spn "Bone大小" width:80 height:16 range:[0.001,100,1] scale:0.01 align:#center  offset:[16,0] toolTip:"仅美观，对动画无影响"
	button but2 "确定" width:120 height:32  align:#center
	
	on add_bone pressed do 
	(
		for i in selection do (
			a=finditem add_bone_array i.name
			if a==0 do(
				append add_bone_array i.name
				append add_bone_array2 i
				)
			)
		bone_list.items = add_bone_array
		if ( bone_list.items.count > 0 or bone_list.selection == 0 ) do bone_list.selection = bone_list.items.count
	)
	
	on delete_bone pressed do 
	(
		if add_bone_array.count !=0 do(
		b_index=bone_list.selection
		deleteItem add_bone_array b_index
		deleteItem add_bone_array2 b_index
		)
		bone_list.items = add_bone_array
		if ( bone_list.items.count > 0 or bone_list.selection == 0 ) do bone_list.selection = bone_list.items.count
	)
	
	on deleteall_bone pressed do 
	(
		add_bone_array=#()
		add_bone_array2=#()
		bone_list.items = add_bone_array
	)
	
	fn replacebone2=(
		global bone_all2=#() 
		global bone_all2_name=#() 
		global bone_all_name3=#()
		global objs2_f=#() 
		global objs2=#() 
		global bone_all2_end=#() 
		new_bone2=#() 
		count=0
		objs2_f= add_bone_array2 as array
		for i=1 to objs2_f.count do(
			if (classof objs2_f[i]==BoneGeometry)or (  classof objs2_f[i]==Dummy )or (classof objs2_f[i]==Point)or(classof objs2_f[i]==Biped_Object) do(
				append  objs2  objs2_f[i]
				count+=1
				)
			)

		bone_size=spn.value
		for i=1 to count do(
			if objs2[i].children[1]==undefined and objs2[i].parent==undefined then( 
				if (matchpattern (objs2[i].name) pattern:"*Dummy*") then (
					new_bone2[i]=Dummy boxsize:[bone_size,bone_size,bone_size]
					new_bone2[i].transform=objs2[i].transform
					new_bone2[i].transform.controller=link_constraint() 
					new_bone2[i].transform.controller.addTarget  objs2[i] 0
					append bone_all2 new_bone2[i]
					append bone_all2_name new_bone2[i].name
					append bone_all_name3 objs2[i].name
					)else if (matchpattern (objs2[i].name) pattern:"*Point*") then(
					new_bone2[i]=Point size:bone_size wirecolor:(color 14 254 2)
					new_bone2[i].transform=objs2[i].transform
					new_bone2[i].transform.controller=link_constraint() 
					new_bone2[i].transform.controller.addTarget  objs2[i] 0
					append bone_all2 new_bone2[i]
					append bone_all2_name new_bone2[i].name
					append bone_all_name3 objs2[i].name
					)else(
						new_bone2[i]=BoneSys.createBone objs2[i].transform.pos (objs2[i].transform.pos*1.1) (objs2[i].dir)
						new_bone2[i].width = bone_size    
						new_bone2[i].height = bone_size
						new_bone2[i].length = bone_size*4
						new_bone2[i].transform=objs2[i].transform
						new_bone2[i].boneEnable=false
						new_bone2[i].frontfin=true
						new_bone2[i].frontfinsize=spn.value/2
						new_bone2[i].transform.controller=link_constraint() 
						new_bone2[i].transform.controller.addTarget  objs2[i] 0
						append bone_all2 new_bone2[i]
						append bone_all2_name new_bone2[i].name
						append bone_all_name3 objs2[i].name
					)
			)else( 
					if not(objs2[i].children[1]==undefined) then(
						if (matchpattern (objs2[i].name) pattern:"*Dummy*") then (
								if (distance objs2[i].pos objs2[i].children[1].pos)>0.001 and (bone_size>0.001)then(
									a=distance objs2[i].transform.pos objs2[i].children[1].transform.pos
								new_bone2[i]=Dummy boxsize:([a,a,a]/2)
								)else(
									new_bone2[i]=Dummy boxsize:([spn.value,spn.value,spn.value]*3)
									)
								new_bone2[i].transform=objs2[i].transform
								new_bone2[i].transform.controller=link_constraint() 
								new_bone2[i].transform.controller.addTarget  objs2[i] 0
								append bone_all2 new_bone2[i]
								append bone_all2_name new_bone2[i].name
								append bone_all_name3 objs2[i].name
							)else if (matchpattern (objs2[i].name) pattern:"*Point*")then(
								if (distance objs2[i].transform.pos objs2[i].children[1].transform.pos)>0.001 and (bone_size>0.001) then(
									a=distance objs2[i].transform.pos objs2[i].children[1].transform.pos
								new_bone2[i]=Point size:(a/4) wirecolor:(color 14 254 2)
								)else(
								new_bone2[i]=Point size:(spn.value/2) wirecolor:(color 14 254 2)	
									)
								new_bone2[i].transform=objs2[i].transform
								new_bone2[i].transform.controller=link_constraint() 
								new_bone2[i].transform.controller.addTarget  objs2[i] 0	
								append bone_all2 new_bone2[i]
								append bone_all2_name new_bone2[i].name
								append bone_all_name3 objs2[i].name
							)else(
								if (distance objs2[i].transform.pos objs2[i].children[1].transform.pos)>0.001 and (bone_size>0.001)then(
								new_bone2[i]=BoneSys.createBone objs2[i].transform.pos (objs2[i].children[1].transform.pos) (objs2[i].dir)
								new_bone2[i].width = (distance objs2[i].transform.pos objs2[i].children[1].transform.pos)/4 
								new_bone2[i].height =(distance objs2[i].transform.pos objs2[i].children[1].transform.pos)/4 
								)else(
									new_bone2[i]=BoneSys.createBone objs2[i].transform.pos ((objs2[i].transform.pos)*1.1) (objs2[i].dir)
									new_bone2[i].width =spn.value
									new_bone2[i].height =spn.value
									new_bone2[i].length=spn.value*4
									)
								new_bone2[i].boneEnable=false
								new_bone2[i].frontfin=true
								new_bone2[i].frontfinsize=spn.value/2
								new_bone2[i].transform.controller=link_constraint() 
								new_bone2[i].transform.controller.addTarget  objs2[i] 0
									
								append bone_all2 new_bone2[i]
								append bone_all2_name new_bone2[i].name
								append bone_all_name3 objs2[i].name
							)

						)else(  
							a=objs2[i].parent.name
							b=finditem add_bone_array a
							if (b==0)then(
								if (matchpattern (objs2[i].name) pattern:"*Dummy*") then (
								new_bone2[i]=Dummy boxsize:([spn.value,spn.value,spn.value]*3)
								new_bone2[i].transform =objs2[i].transform
								new_bone2[i].transform.controller=link_constraint() 
								new_bone2[i].transform.controller.addTarget  objs2[i] 0
								append bone_all2 new_bone2[i]
								append bone_all2_name new_bone2[i].name
								append bone_all_name3 objs2[i].name
								)else if (matchpattern (objs2[i].name) pattern:"*Point*")then(
								new_bone2[i]=Point size:(spn.value/2) wirecolor:(color 14 254 2)
								new_bone2[i].transform =objs2[i].transform
								new_bone2[i].transform.controller=link_constraint() 
								new_bone2[i].transform.controller.addTarget  objs2[i] 0
								append bone_all2 new_bone2[i]
								append bone_all2_name new_bone2[i].name
								append bone_all_name3 objs2[i].name
								)else(
									new_bone2[i]=BoneSys.createBone objs2[i].transform.pos ((objs2[i].transform.pos)*1.1) (objs2[i].dir)
									new_bone2[i].transform =objs2[i].transform
									if (distance objs2[i].transform.pos objs2[i].parent.transform.pos)>0.001 then(
									new_bone2[i].width = (distance objs2[i].transform.pos objs2[i].parent.transform.pos)/4
									new_bone2[i].height = (distance objs2[i].transform.pos objs2[i].parent.transform.pos)/4
									new_bone2[i].length=(new_bone2[i].width+new_bone2[i].height)/2
									)else(
										new_bone2[i].width =spn.value
										new_bone2[i].height = spn.value
										new_bone2[i].length=spn.value*4
										)
									new_bone2[i].taper= 90
										
									new_bone2[i].frontfin=true
									new_bone2[i].frontfinsize=spn.value/2
									new_bone2[i].boneEnable=false
									new_bone2[i].transform.controller=link_constraint() 
									new_bone2[i].transform.controller.addTarget  objs2[i] 0											
									append bone_all2 new_bone2[i]
									append bone_all2_name new_bone2[i].name
									append bone_all_name3 objs2[i].name
									)
								)else( --骨骼链末端
									if (matchpattern (objs2[i].name) pattern:"*Dummy*") then (
										new_bone2[i]=Dummy boxsize:([spn.value,spn.value,spn.value]*3)
										new_bone2[i].transform =objs2[i].transform
										new_bone2[i].transform.controller=link_constraint() 
										new_bone2[i].transform.controller.addTarget  objs2[i] 0
										append bone_all2 new_bone2[i]
										append bone_all2_name new_bone2[i].name
										append bone_all_name3 objs2[i].name
										)else if (matchpattern (objs2[i].name) pattern:"*Point*")then(
										new_bone2[i]=Point size:(spn.value/2) wirecolor:(color 14 254 2)
										new_bone2[i].transform =objs2[i].transform
										new_bone2[i].transform.controller=link_constraint() 
										new_bone2[i].transform.controller.addTarget  objs2[i] 0
										append bone_all2 new_bone2[i]
										append bone_all2_name new_bone2[i].name
										append bone_all_name3 objs2[i].name
										)else(
											new_bone2[i]=BoneSys.createBone objs2[i].transform.pos ((objs2[i].transform.pos)*1.1) (objs2[i].dir)
											new_bone2[i].transform =objs2[i].transform
											if (distance objs2[i].transform.pos objs2[i].parent.transform.pos)>0.001 then(
											new_bone2[i].width = (distance objs2[i].transform.pos objs2[i].parent.transform.pos)/4
											new_bone2[i].height = (distance objs2[i].transform.pos objs2[i].parent.transform.pos)/4
											new_bone2[i].length=(new_bone2[i].width+new_bone2[i].height)/2
											)else(
												new_bone2[i].width =spn.value
												new_bone2[i].height = spn.value
												new_bone2[i].length=spn.value*4
												)
											new_bone2[i].taper= 90
												
											new_bone2[i].frontfin=true
											new_bone2[i].frontfinsize=spn.value/2
											new_bone2[i].boneEnable=false
											new_bone2[i].transform.controller=link_constraint() 
											new_bone2[i].transform.controller.addTarget  objs2[i] 0	
											append bone_all2_end new_bone2[i]											
											append bone_all2 new_bone2[i]
											append bone_all2_name new_bone2[i].name
											append bone_all_name3 objs2[i].name
										)
								)
						)
			)
		)
		for i=1 to bone_all2.count do(
			a=getNodeByName bone_all_name3[i]
			if a.parent!=undefined do(
				b=finditem bone_all_name3 a.parent.name
					if b!=0 then(
					bone_all2[i].parent=bone_all2[b]	
					)else(
						try(
							b2=finditem fbone4 a.parent.name	
							if b2!=0 do(
								bone_all2[i].parent=fbone3[b2]	
								)
							)catch()
					)
				)
		)
		for i=1 to bone_all2_end.count do(
			try(
			c = copy bone_all2_end[i].parent.transform
			c.pos = bone_all2_end[i].transform.position
			bone_all2_end[i].transform = c
			) catch()
		)
		
		sort bone_all2_name
		bone_all2_f=#()
		bone_all_name3_f=#()
		for i=1 to bone_all2.count do(
			bone_all2_f[i]=bone_all2[i]
			)
		for i=1 to bone_all_name3.count do(
			bone_all_name3_f[i]=bone_all_name3[i]
			)
			
		for i=1 to bone_all2_name.count do(
			bone_all2[i] = getNodeByName bone_all2_name[i]
			a=finditem bone_all2_f bone_all2[i]
			bone_all_name3[i]=bone_all_name3_f[a]
			)
		
		for i=1 to bone_all2.count do(
			bone_all2[i].name=bone_all_name3[i]
			)

		global tc5
		tc5 = layerManager.getLayerFromName"Help_bone"  	
		if  tc5 ==undefined then (
		tc5=LayerManager.newLayerFromName "Help_bone" 
		)else(
		tc5=LayerManager.getLayerFromName"Help_bone"
		)
		for n in bone_all2 do tc5.addNode n
		
		clearSelection()
	)
	on but2 pressed do(
		actionMan.executeAction 0 "50002"
		toolMode.pivotCenter()
		max create mode
		replacebone2()
	)

)

rollout Help_bone_list "非Bip骨骼导出的Fbx" (
	button btn "匹配骨骼" width:98 height:32  align:#center
	on btn pressed do(
		try(destroydialog rollout_title2) catch()
		createDialog rollout_title2	fgcolor:(color 7 254 254) pos:((getdialogpos AutoFbxtoBip)+[202,0])
		AddSubRollout rollout_title2.sub_broken2 help_bone
		AddSubRollout rollout_title2.sub_broken2 help_bone2
		help_bone2.open=false
	)
)
local SubRollout = 1
local Tab01 = "FbxtoBip"
-- local Tab02 = "批量导出.bip"

ExportFbx_Rollouts = #(
    #(Tab01,#(fbxtobip_zven,Relocate_bone_size,findtext,help_bone_list))
--     #(Tab02,#(Exportbip))
    )
rollout AutoFbxtoBip "AutoFbxtoBip v1.3" width:200 height:315
(
    dotNetControl dn_tabs "System.Windows.Forms.TabControl" width:200 height:22  align:#center
    subRollout theSubRollout width:200 height:285 align:#center 

    on dn_tabs Selected itm do
	(
            if SubRollout != (itm.TabPageIndex+1) do 
            (
            for subroll in ExportFbx_Rollouts[SubRollout][2] do
            removeSubRollout theSubRollout subroll
            for subroll in ExportFbx_Rollouts[SubRollout = itm.TabPageIndex+1][2] do	(
            addSubRollout theSubRollout subroll
            )
        ) 
    )			
	
	on dn_tabs Selected itm do 
	(
		if SubRollout != (itm.TabPageIndex+1) do 
            (
            for subroll in ExportFbx_Rollouts[SubRollout][2] do
            removeSubRollout theSubRollout subroll
            for subroll in ExportFbx_Rollouts[SubRollout = itm.TabPageIndex+1][2] do	(
            addSubRollout theSubRollout subroll
			Relocate_bone_size.open=false
			Findtext.open=false
			Help_bone_list.open=false	
            )
        ) 
    )
	on AutoFbxtoBip moved pos do setDialogPos rollout_title2 (pos+[AutoFbxtoBip.width+2,0])
    on AutoFbxtoBip open do
    (
        for aTab in ExportFbx_Rollouts do
        (
        dn_tabs.TabPages.add aTab[1] 
        )
        for subroll in ExportFbx_Rollouts[1][2] do 
        (
        addSubRollout theSubRollout subroll	
        )  
		Relocate_bone_size.open=false
		Findtext.open=false
		Help_bone_list.open=false
    ) 	
)
createDialog AutoFbxtoBip fgcolor:(color 7 254 254)  
)