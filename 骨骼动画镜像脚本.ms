

if wando_mirror_tools != undefined then closeRolloutFloater wando_mirror_tools
wando_mirror_tools=newrolloutfloater "wando¹Ç÷À¾µÏñ¹¤¾ß" 160 125 95 80
rollout mirror_tools "wando¹Ç÷À¾µÏñ¹¤¾ß" width:162 height:120
(
Fn Fn_PosMirrorRot Fnp_Original Fnp_Target Fnp_AxisIndex = 
(
	local OriginalEuler,TargetController,TargetEuler
	OriginalEuler 	= Fnp_Original.Rotation.Controller.Value as EulerAngles
	TargetEuler 	= Copy OriginalEuler
	TargetEuler.X *= -1
	TargetEuler.Z *= -1
	TargetController = Fnp_Target.Rotation.Controller
	
	case Fnp_AxisIndex of
	(
		0:
		(
			
		)
		1:
		(
			TargetEuler.Z += 180.0
		)
		2:
		(
			
		)
		3:
		(
			TargetEuler.X *= -1
			TargetEuler.Z *= -1
			TargetEuler.Y += 180.0
			TargetEuler.Z += 180.0
		)
	)
	TargetController.Value = TargetEuler as quat
)
local  ChildrenObj
fn GetChildren Obj All_Children_Objs =
(
	if Obj.children.count != 0 then
	( 
		for i in 1 to Obj.children.count do
		(
			ChildrenObj = Obj.children[i]
			append All_Children_Objs ChildrenObj
			if ChildrenObj.children.count != 0 then (GetChildren ChildrenObj All_Children_Objs)
		)
	)
)
fn Get_Me_Children Obj All_Children_Objs =
(
	append All_Children_Objs Obj
	GetChildren Obj All_Children_Objs
)


	button btn1 "¾µÏñ¹Ç÷À" pos:[13,5] width:120 height:18 enabled:true
	button btn2 "¾µÏñ¶¯»­" pos:[13,25] width:120 height:18 enabled:true
	button btn3 "¾µÏñµ¥Ö¡pos" pos:[13,45] width:120 height:18 enabled:true
	button btn4 "ÔÚÏß°ïÖú" pos:[13,65] width:120 height:18 enabled:true
	on mirror_tools close do
	(
		shellLaunch "http://bbs.cgjoy.com" ""
	)
	on btn1 pressed do
	(
		mergebonesName = for i in selection collect i.name;
		holdMaxFile()
		myholdmaxfile = (GetDir #Autoback)+"\\"+"maxhold.mx"
		mergemaxfile myholdmaxfile mergebonesName #prompt #skipDups #alwaysReparent #mergeDups
		for i in selection do (i.name = uniqueName "Bone")
		mergedbones =  for i in selection collect i;
		OriginalArray  = #()
		TargetArray = #()
		newsle = #()
		select (execute ("$"+ mergebonesName[1]))
		append newsle selection[1]
		append newsle mergedbones[1]
		select newsle
		selection[2].pos.x = - selection[2].pos.x
		Get_Me_Children selection[1] OriginalArray 
		Get_Me_Children selection[2] TargetArray
		for  tbi = 1 to OriginalArray.Count do if tbi == 1 then Fn_PosMirrorRot OriginalArray[tbi] TargetArray[tbi]  1 else Fn_PosMirrorRot OriginalArray[tbi] TargetArray[tbi]  0

	)
	on btn2 pressed do
	(
		OriginalArray  = #()
		TargetArray = #()
		Get_Me_Children selection[1] OriginalArray 
		Get_Me_Children selection[2] TargetArray
		if selection[1].parent != undefined then (father_1 = selection[1].parent;selection[1].parent = undefined)
		if selection[2].parent != undefined then (father_2 = selection[2].parent;selection[2].parent = undefined)
		for i in animationrange.start to animationrange.end do
		(
			sliderTime = i 
			with animate on
				(
					for  tbi = 1 to OriginalArray.Count do if tbi == 1 then Fn_PosMirrorRot OriginalArray[tbi] TargetArray[tbi]  1 else Fn_PosMirrorRot OriginalArray[tbi] TargetArray[tbi]  0
				)
		)
		if father_1 != undefined then (selection[1].parent = father_1)
		if father_2 != undefined then (selection[2].parent = father_2)
	)
	on btn3 pressed do
	(
		OriginalArray  = #()
		TargetArray = #()
		Get_Me_Children selection[1] OriginalArray 
		Get_Me_Children selection[2] TargetArray
		for  tbi = 1 to OriginalArray.Count do if tbi == 1 then Fn_PosMirrorRot OriginalArray[tbi] TargetArray[tbi]  1 else Fn_PosMirrorRot OriginalArray[tbi] TargetArray[tbi]  0
	)
	on btn4 pressed do
	(
		shellLaunch "http://bbs.cgjoy.com/viewthread.php?tid=7723" ""
	)
)-----------------
---------------


---

---


--------------
addrollout mirror_tools wando_mirror_tools