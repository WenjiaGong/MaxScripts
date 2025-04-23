-- 作者：东见云
-- v1
-- tested with max 2016
-- yun7928903@163.com


fn deleteIfExsit obj = (objA = getNodeByName(obj);if isvalidnode(objA) then (delete objA)) ---创建前删除用
function ConstrainDistance pointpp anchorpp distancepp =( return (normalize(pointpp - anchorpp) * distancepp) + anchorpp)

------重建骨骼
 function reconstructBones =
(	n = selection.count
	originalBones = for o in selection  collect o
	skinBones = #()
	for i=1 to n-1 do 
	(	
		skinBones [i] = boneSys.createBone originalBones [i].pos originalBones [i+1].pos [1,0,0]
		deleteIfExsit (originalBones[i].name+"_yunCBone")
		skinBones [i].name = (originalBones[i].name+"_yunCBone")
		skinBones [i].transform = originalBones[i].transform
		
		skinBones [i].pos.controller = Position_Constraint() 
		skinBones [i].pos.controller.appendTarget originalBones[i] 100
		
		skinBones [i].rotation.controller =LookAt_Constraint ()
		skinBones [i].rotation.controller.appendTarget originalBones[i+1] 100
		skinBones [i].rotation.controller.relative=true	
		getName = (originalBones [i].name+"_Rot")
		skinBones [i].rotation.controller.upnode_world = off
		skinBones [i].rotation.controller.pickUpNode = (getNodeByName getName)
	)
	skinbones.wirecolor = yellow
) 


try(destroydialog yunFixGround) catch()
rollout yunFixGround "" width:200
(
	checkbutton pick_nodes_bt "选骨链(右键结束)" width:195
	button yunFixGround_addEnd "加末端" width:195
	edittext prefix_txt "" width:180 height: 100 labelOnTop:true
	button yunFixGround_CreateSet "创建" width:195
	spinner  yunFixGround_height "离地高度："range:[-10000,10000,30] type:#float value:30  width:150
	button yunFixGround_Do "修穿插" width:195
	button yunFixGround_DedeteSets "清除所有" width:195
	local nodes = #()
	on pick_nodes_bt changed state do
	(
		if state do
		(
			prefix_txt.text= ""
			pick_nodes_bt.enabled = off
			pickNodes = #()
			while isvalidnode (obj = pickObject select:true) do 
			(
				appendifunique pickNodes obj				
				prefix_txt.text=prefix_txt.text+obj.name+"↓"+"\n"
			)				
			pick_nodes_bt.enabled = on
			pick_nodes_bt.checked = off
		)
	)
	on yunFixGround_addEnd pressed do
	(
		yunGroundFixHeight = yunFixGround.yunFixGround_height.range[3]
		mystring = yunFixGround.prefix_txt.text
		bufferArray = FilterString mystring "\n"
		bufferString = ""
		for i in bufferArray do (bufferString = bufferString+i)
		finalName = FilterString bufferString "↓"		
		ropeBone = #()	
		for i in finalName do(	if isvalidnode(getNodeByName i) do (append ropeBone (getNodeByName i))  )	
		if isvalidnode(ropeBone[ropeBone.count].children[1]) do (prefix_txt.text=prefix_txt.text+ropeBone[ropeBone.count].children[1].name+"↓"+"\n"  )
			
	)
	
	on yunFixGround_DedeteSets pressed do
	(
	-- 删除多余
	clearSelection()
	CheckA = (LayerManager.getLayerFromName  "yunCBoneHide")	
	if CheckA!= undefined then (CheckA.select on;CheckA.select on)
	CheckB = (LayerManager.getLayerFromName  "yunCtrloneHide")		
	if CheckB!= undefined then (CheckB.select on;CheckB.select on)
	selObj = #()
	selObj = for node in GetCurrentSelection() where isvalidnode node collect node 
	delete selObj
	Completeredraw()	
	-- macros.run "Scene Explorer" "SEDelete"
	if CheckA != undefined then (LayerManager.deleteLayerByName  "yunCBoneHide")
	if CheckB != undefined then (LayerManager.deleteLayerByName  "yunCtrloneHide")
	)
	
	on yunFixGround_CreateSet pressed do
	(
	animate off
	(		
		---------------------------------------创建计算用替身部分--------------------------------------------
		mystring = yunFixGround.prefix_txt.text
		bufferArray = FilterString mystring "\n"
		bufferString = ""
		for i in bufferArray do (bufferString = bufferString+i)
		finalName = FilterString bufferString "↓"		
		ropeBone = #()	
		for i in finalName do(	if isvalidnode(getNodeByName i) do (append ropeBone (getNodeByName i))  )
			
		-- ropeBone =  #($wb01, $wb02, $wb03, $wb04, $wb05, $wb06, $wb07q,$Bone026)   --只有此行需要设定
		rope = #()
		for i in ropeBone do 
		(
			ppp = Point  isSelected:off	
			deleteIfExsit (i.name+"PP")
			ppp.name = (i.name+"PP")
			ppp.transform = i.transform
			ppp.size = 100
			ppp.wirecolor = yellow
			ppp.cross = on
			ppp.Box = off
			append rope  (getNodeByName (i.name+"PP"))
		)-----创建虚拟点儿组
		for i=1 to rope.count-1 do 
		(
				rope[i].rotation.controller =LookAt_Constraint ()
				rope[i].rotation.controller.appendTarget 	rope[i+1] 100
				rope[i].rotation.controller.relative=true		
		)
		-----创建上方向控制虚拟点儿组
		ropeRot = #()
		for i in rope do 
		(
			ppp = Point  isSelected:off
			
			deleteIfExsit (i.name+"_Rot")
			ppp.name = (i.name+"_Rot")
			ppp.transform = i.transform
			ppp.size = 30
			ppp.Box = on
			ppp.cross = off	
			ppp.wirecolor = red
			append ropeRot  ppp	
			in coordsys i move ppp [0,0,100]
			ppp.pivot = i.pos
			ppp.parent = i
		)
		--end

		for i=1 to rope.count-1 do 
			(
			clearSelection()
			select rope[i]
			selectMore rope[i+1]
			reconstructBones()
			)-----创建虚拟点儿组的虚拟骨骼

		max create mode
		clearSelection()
		for i=1 to rope.count-1 do
			(
			getName = (rope[i].name+"_yunCBone")
			selectMore (getNodeByName getName)
			)
		if (LayerManager.getLayerFromName ("yunCBoneHide")) == undefined then (yunLayer = layerManager.newLayerFromName "yunCBoneHide")
		else (yunLayer = LayerManager.getLayerFromName ("yunCBoneHide"))
		for n in (selection as array) do yunLayer.addnode n
		yunLayer.on = false
		clearSelection()
		selectMore rope
		if (LayerManager.getLayerFromName ("yunCtrloneHide")) == undefined then (yunCtrlLayer = layerManager.newLayerFromName "yunCtrloneHide")
		else (yunCtrlLayer = LayerManager.getLayerFromName ("yunCtrloneHide"))
		for n in (selection as array) do yunCtrlLayer.addnode n
		clearSelection()
		for i=1 to rope.count do (getName = (rope[i].name+"_Rot");selectMore (getNodeByName getName))
		for n in (selection as array) do yunCtrlLayer.addnode n
		-- 加层管理
		
	)
	)
	on yunFixGround_Do pressed do
	(
	animate on
	(
		-- 重新得到控制点的数组
		yunGroundFixHeight = yunFixGround.yunFixGround_height.range[3]
		mystring = yunFixGround.prefix_txt.text
		bufferArray = FilterString mystring "\n"
		bufferString = ""
		for i in bufferArray do (bufferString = bufferString+i)
		finalName = FilterString bufferString "↓"		
		ropeBone = #()	
		for i in finalName do(	if isvalidnode(getNodeByName i) do (append ropeBone (getNodeByName i))  )
		-- ropeBone =  #($wb01, $wb02, $wb03, $wb04, $wb05, $wb06, $wb07q,$Bone026)    --只有此行需要设定
			
		rope = #()
		for i in ropeBone do (append rope  (getNodeByName (i.name+"PP")))--end
		-----记录距离
		distancepp = #(1000)	
		for i = 2 to rope.count do (append distancepp (abs (length(rope[i-1].pos-rope[i].pos)))	)---end
		for i = 1 to rope.count do (rope[i].rotation.controller = Euler_XYZ () )
		tStart = (animationRange.start as string) as integer
		tEnd = (animationRange.end as string) as integer
		tNow = (currentTime as string) as integer
		TimeLength = (tEnd - tStart) + 1		
		frames = #()
		for i = tStart to tEnd do append frames i
		for vT in frames do 
		(
		sliderTime=vT
		---------------------------------------部分--------------------------------------------
		for i in ropeBone do (ppp = getNodeByName (i.name+"PP");ppp.transform = i.transform)
			for i = 2 to rope.count do
			(	
			-- Pull the next segment to the previous one  顺拉开始带自定义
			rope[i].pos = ConstrainDistance  rope[i].pos rope[i-1].pos distancepp[i]
			)
			-- 	mousePos = rope[1].pos
			for i in rope.count to 2 by -1 do	 ---倒拉自定义到开始
			(
			rope[i-1].pos = ConstrainDistance  rope[i-1].pos rope[i].pos distancepp[i]
			)	
			for i in rope do 	(if i.pos.z <yunGroundFixHeight do (i.pos.z = yunGroundFixHeight)	)------高度锁定	

				for i=1 to rope.count-1 do 
			(
				boneName =  #()
				boneName = FilterString rope[i].name "PP"
				yunCBoneName = rope[i].name+"_yunCBone"
				boneNameObj = getNodeByName boneName[1]
				yunCBoneObj = getNodeByName yunCBoneName
		-- 		print yunCBoneObj
				boneNameObj.transform = yunCBoneObj.transform	
			)
		)
		
	)
	)
		
	
)

createdialog yunFixGround


