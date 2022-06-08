
global n_Spring
global n_Scale_Motion
global n_Subs
global n_XSpring
global n_Bones_num
global n_Loops
global n_Paste
global n_set
global n_straight
global n_Active
global n_Custom
global n_to
global n_Bake
global n_Position
global n_Scale
global n_Rotation
global n_Del_Keys
global n_Del_Emp_Layer
global n_Del_Outrange_Keys
global n_All_Sce
global n_LoopStart
global n_Euler_Filter
global n_Sel_Bon
global n_Sel_Bip
global n_Sel_F_Bon
global n_Fn_Lan_a
global n_Fn_Lan_b

fn china = (
n_Spring				= "硬度"
n_Scale_Motion 			= "首节幅度"
n_Subs 					= "子步"
n_XSpring 				= "X弹簧"
n_Bones_num 			= "骨骼数量"
n_Loops 				= "循环"
n_Paste 				= "粘贴帧"
n_set 					= "设置帧"
n_straight 				= "打直"
n_KeyRange 				= "帧数范围"
n_Active 				= "当前"
n_Custom 				= "自定"
n_to 					= "到"
n_Bake 					= "烘焙"
n_Position 				= "位移"
n_Scale 				= "缩放"
n_Rotation 				= "旋转"
n_Del_Keys 				= "删除所选"
n_Del_Emp_Layer 		= "清理空层"
n_Del_Outrange_Keys 	= "一键清除无限帧"
n_All_Sce 				= "场景所有"
n_LoopStart 			= "首尾循环"
n_Euler_Filter 			= "欧拉过滤"
n_Sel_Bon 				= "选择所有Bone"
n_Sel_Bip 				= "选择所有CS"
n_Sel_F_Bon 			= "选择首节骨骼"
n_Fn_Lan_a				= "中"
n_Fn_Lan_b 				= "当前语言:中文"
)

fn english = (
n_Spring				= "Spring"
n_Scale_Motion 			= "Scale Motion"
n_Subs 					= "Subs"
n_XSpring 				= "XSpring"
n_Bones_num 			= "Bones num"
n_Loops 				= "Loops"
n_Paste 				= "Paste"
n_Set 					= "Set"
n_Straight 				= "Straight"
n_KeyRange 				= "KeyRange"
n_Active 				= "Active"
n_Custom 				= "Custom"
n_to 					= "to"
n_Bake 					= "Bake"
n_Position 				= "Position"
n_Scale 				= "Scale"
n_Rotation 				= "Rotation"
n_Del_Keys 				= "Del Keys"
n_Del_Emp_Layer 		= "Del Empty Layer"
n_Del_Outrange_Keys 	= "Del Outrange Keys"
n_All_Sce 				= "All in Scene"
n_LoopStart 			= "LoopStart"
n_Euler_Filter 			= "Euler Filter"
n_Sel_Bon 				= "Select All Bones"
n_Sel_Bip 				= "Select All Biped"
n_Sel_F_Bon 			= "Select first bone"
n_Fn_Lan_a				= "En"
n_Fn_Lan_b 				= "Current Language：English"
)


(
---------------------------------------------------------------------------------------------打开文件加载
tempdata = ((GetDir #scripts)+"\\"+"SpringMagic_Lan.ini")-----指定文件
testPath = doesFileExist tempdata------检测文件是否存在
if testPath == true then (
open_tempdata   = openFile tempdata------打开temp文件
skip_tmepdata   = skiptostring open_tempdata "Language = "
if skip_tmepdata ==ok then (
	read_tempdata = readLine open_tempdata 
	en_ch = read_tempdata as booleanClass
	if en_ch  == true then (english()) else (china())
	) else (china())
close open_tempdata
)else (china())
-----------------------------------------------------------------------------------------------------------------
)

--------------------------Ver.  1.1     Author : Si-Chung Yuan 2017.9 --------------------------------------------------------------
global springMagic_rol
try (destroyDialog springMagic_rol) catch()
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
local framestart, frameEnd
local simbones = #(), bone_TM = #(), preTimebone_TM = #(), prePos = #(), bcnt = #()
rollout springMagic_rol "Spring Magic V1.13 Integration" width:230
(
	spinner delaysp n_Spring type:#float scale:0.01 range:[0.01,1,0.3] align:#left height:20 width:60
	spinner scaleMotion n_Scale_Motion type:#float scale:0.01 range:[0,999,1] align:#right height:20 width:75 offset:[5,-25] 
	spinner subs n_Subs type:#integer range:[1,30,1] align:#left height:20 width:60
	spinner upspring n_XSpring type:#float scale:0.01 range:[0.1,1,0.3] align:#right height:20 width:70 offset:[5,-25] 
	spinner bnum n_Bones_num  type:#integer range:[0,1000,50] align:#left height:20 width:60
	checkBox loops n_Loops type:#integer range:[0,100,0] align:#right height:20 width:50 offset:[5,-25]
	

	group "Bone Pose , Fn Language"
	(
		button pasteRp n_Paste toolTip:n_Sel_F_Bon align:#left height:20 width:55
		button setRp n_Set toolTip:n_Sel_F_Bon align:#left height:20 width:55 offset:[60,-25] 
		button stretch n_Straight align:#left height:20 width:55 offset:[120,-25] 
		button btn_language "" align:#left width:25 height:20 offset:[185,-25] toolTip:n_Fn_Lan_b 
	)
	group "Key Range"
	(
		radiobuttons a1 labels:#(n_Active, n_Custom) align:#left width:80 height:20 offset:[-5,0]
		spinner aframeStart type:#integer align:#left width:40 height:20 range:[-10000,100000,1] offset:[110,-25] 
		spinner aframeEnd n_to type:#integer align:#left width:45 height:20 range:[0,100000,10] offset:[155,-25] 
	)

	group "Apply"
	(
		button applybone n_Bake toolTip:n_Sel_F_Bon align:#left height:20 width:60 offset:[0,-0] 
		progressbar doit_prog color:red align:#left height:15 width:120 offset:[80,-20] 
	)
	group "Del Select Bone Transform"
	(
		checkbox chePos n_Position checked:true offset:[0,-0]
		checkbox cheSca n_Scale checked:true offset:[75,-20]
		checkbox cheRot n_Rotation checked:false offset:[135,-20]
		button btnDelKeys n_Del_Keys width:100 height:20 offset:[-55,0]
		button btn_CleanEmptyLayer n_Del_Emp_Layer width:100 height:20 offset:[55,-25]
	)
	group "Del Outrange Keys"
	(
		button btnDelOutKeys n_Del_Outrange_Keys width:120 height:20 offset:[-45,0]
		checkbox cheALL n_All_Sce checked:false offset:[132,-20]
	)
	group "Tools"
	(
		button btn_LoopStart n_LoopStart width:100 height:20 offset:[-55,-0]
		button btn_EulerFilter n_Euler_Filter width:100 height:20 offset:[55,-25]
		button btn_SelectAllBones n_Sel_Bon width:100 height:20 offset:[-55,0]
		button btn_SelectAllBiped n_Sel_Bip width:100 height:20 offset:[55,-25]
	)
	label lab_aut "Author:Si-Chung Yuan  |  Adapter:Crazyone" align:#left
	label lab_aut2 "Adapter-Translator:Bullet.S" align:#right
	
	fn setStartEndFrame = (
		if a1.state == 1 then (
			framestart = animationRange.start-1f
			frameEnd = animationRange.end-1f
		) else (
			framestart = aframeStart.value-1f as time
			frameEnd = aframeEnd.value-1f as time
		)
	)
	fn setStartEndFrameDeleteKey = (
		if a1.state == 1 then (
			framestart = animationRange.start
			frameEnd = animationRange.end
		) else (
			framestart = aframeStart.value as time
			frameEnd = aframeEnd.value as time
		)
	)

	fn getBoneChain bone = (
		
		local bonechain = #()
		local bonetype = classof bone
		local num = 1

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
		--format "bonechain = %\n" bonechain
		append simBones bonechain

		local pTM = parnode.transform
		local preTM = #()
		local bTM = #()

		for j in 1 to bonechain.count do (
			if classof bonechain[j] == Dummy and classof bonechain[j].controller == BipSlave_Control then(
				for i = 1 to (custAttributes.count bonechain[j]) do (
					a = CustAttributes.get bonechain[j] i
					if isProperty a "boneTM" do (
						CustAttributes.delete bonechain[j] i
						isDelete  = true
					)
				)
			)else
				if not isProperty bonechain[j] "boneTM" then 
				(
					CustAttributes.add bonechain[j] sprboneCA
					bonechain[j].boneTM = bonechain[j].transform * inverse bonechain[j].parent.transform
				)
			
			if isProperty bonechain[j] "boneTM" then
				append bTM bonechain[j].boneTM
			else
				append bTM (bonechain[j].transform * inverse bonechain[j].parent.transform)
			
			append preTM bonechain[j].transform
			
		)	
		if bonechain.count > 1 then
			append prePos bonechain[2].transform.pos
		else (
			bbox = nodeGetBoundingBox bonechain[1] bonechain[1].transform
			append prePos (bonechain[1].transform.pos + bonechain[1].transform.row1 * bbox[2].x)
		)
		
		-------------- 	Add End  -----------------------------------------------------------------------------------------
		if bnum.value >= bonechain.count do (
			if bonechain.count > 1 then (
				ltm = copy bTM[bTM.count]
				append bTM ltm
			)else (
				ltm = matrix3 1
				bbox = nodeGetBoundingBox bonechain[1] bonechain[1].transform
				ltm.pos = [bbox[2].x, 0 ,0]
				append bTM ltm
			)
			tm = ltm * bonechain[preTM.count].transform
			append preTM tm
		)
		
		if classof bonechain[bonechain.count] == Dummy and \
			classof bonechain[bonechain.count].controller == BipSlave_Control do
			bonechain.count = bonechain.count - 1
		if bonechain.count > bnum.value do bonechain.count = bnum.value

		append bcnt bTM.count
		----------------------------------------------------------------------------------------------------------
		
		append preTimebone_TM preTM
		append bone_TM bTM
	format "bTM.count=% preTM.count=% bonechain.count=%\n" bTM.count preTM.count bonechain.count	
	)
	
	
	fn sortArrayByHeirarchy objectArray =
	( 
		local sortedArray = #()
		local listArray = #()
		local parentArray = #()
		local childArray = #()
		
		for obj in objectArray do
		(
			if (finditem objectArray obj.parent) == 0 
			then append parentArray obj
			else append childArray obj  
		)
		while childArray.count > 0  do
		(
			i=1
			while i <= childArray.count do
			(
				parentIdx = finditem parentArray childArray[i].parent
				if parentIdx != 0 then
				(
					insertItem childArray[i] parentArray (parentIdx+1) 
					deleteItem childArray i
				) 
				else(i += 1)
			)
		)
		
		local a = 1
		
		for l=1 to parentArray.count do
		(
			if (finditem parentArray (parentArray[l].children)[1]) != 0 then
			(
				append listArray parentArray[l]
			) 
			else
			(
				append listArray parentArray[l]
				sortedArray[a] = listArray
				listArray = #()
				a += 1
			)
		)
		sortedArray
	)

	fn BoneLoopStart objectArray=
	(
		firstbonerot = #()
		lastbonerot = #()
		bonesub = #()
		bonelistsub = #()
		
		startFrame=(animationrange.start as string) as integer
		endFrame=(animationrange.end as string) as integer
		cycleFrame=30
		if (endFrame-startframe)<30 then cycleFrame=(endFrame-startframe)
		
		for i = 1 to objectArray.count do
		(
			slidertime=animationrange.start
			for j = 1 to objectArray[i].count do
			(
				append firstbonerot objectArray[i][j].transform.rotation
			)
			slidertime=animationrange.end
			for j = 1 to objectArray[i].count do
			(
				append lastbonerot objectArray[i][j].transform.rotation
			)
			for j = 1 to objectArray[i].count do
			(
			append bonesub (quattoeuler (firstbonerot[j]-lastbonerot[j]))
			)
			append bonelistsub bonesub
			firstbonerot = #()
			lastbonerot = #()
			bonesub = #()
		)	
		set animate on
		for f = 0 to cycleframe do
		(
			slidertime = endFrame - f;
			per=(float)(cycleFrame-f)/cycleFrame
			
			for a = 1 to objectArray.count do
			(
				for b = 1 to objectArray[a].count do
				(
					r = bonelistsub[a][b];
					if b > 1 then(r=quattoeuler  (bonelistsub[a][b] as quat - bonelistsub[a][b-1] as quat))
					rot = (eulerangles (r.x*per) (r.y*per) (r.z*per))
					rotate objectArray[a][b] rot
				)
			)
		)
		set animate off
		slidertime=startframe
	)
	
	fn deleteKeysRange start end pos sca rot= 
	(
		for b in selection do --where(classof b == boneobj)do
		(
			-- Position keys
			if pos then 
			(
				for i=start to end do 
				(
					selectKeys b.pos.controller i
					deleteKeys b.pos.controller #selection 
				)
			)
			-- Rotation keys
			if rot then 
			(
				for i=start to end do 
				(
					selectKeys b.rotation.controller i
					deleteKeys b.rotation.controller #selection 
				)
			)
			-- Scale keys
			if sca then 
			(
				for i=start to end do 
				(
					selectKeys b.scale.controller i
					deleteKeys b.scale.controller #selection 
				)
			)

		)
	)

	Fn CleanOutRangeKeys inputObject start end= 
(
    for i = 1 to inputObject.numSubs do
    (
        tempSubAnim = GetSubAnim inputObject i
        tempController = tempSubAnim.Controller
        
        if tempController != undefined do
        (
            tempKeyList = tempController.Keys
            
            outEndKeysIndex = for i = 1 to tempKeyList.Count where tempKeyList[i].Time > end collect i
            if outEndKeysIndex.Count > 0 do for i = 1 to outEndKeysIndex.Count do DeleteKey tempKeyList tempKeyList.count
            
            outStartKeysIndex = for i = 1 to tempKeyList.Count where  tempKeyList[i].Time < start collect i
            for i = 1 to outStartKeysIndex.Count do DeleteKey tempKeyList 1
        )
        if tempSubAnim.numSubs > 0 do CleanOutRangeKeys tempSubAnim start end
    )
)

	Fn CleanEmptyLayer =
(
	-- for i = 0 to layerManager.count-1 do
	-- (
	--   ilayer = layerManager.getLayer i
	--   layerName = ilayer.name
	--   layer = ILayerManager.getLayerObject i
	--   layerNodes = refs.dependents layer
	--   format "Layer: %; nodes: %\n" layerName layerNodes
	-- )
	---------------------------------------------------------------
	--a = #()
	-- i = LayerManager.count  --当前场景所有层计数
	-- LayerManager.current
	-- a = (LayerManager.getLayer 0).name --当前层名称
	-- a = LayerManager.getLayer 0  --当前层所有属性
	-- a.name
	-- a.current --当前层是否被激活
	-- a.current = true    --设置当前层是为激活
	-- a.nodes &theNodes   --Nodes加入到theNodes集合
	-- theNodes  --返回当前层内所有的Nodes。值为集合#()
	-- LayerManager.deleteLayerByName
	-- LayerManager.deleteLayerByName a
	-------------------------------------------------------------------
	LayerZero = LayerManager.getLayer 0
	LayerZero.current = true
	DL = #()   /*DL = DeleteLayers*/

	for i = 0 to LayerManager.count-1 do
	(	
	-- 	print i
		layerC = LayerManager.getLayer i
		layerC.nodes &theNodes
		layerName = layerC.name
	-- 	theNodes.count
	-- 	NodesCount = theNodes.count
	-- 	print layerName	
	-- 	print theNodes.count
		  if theNodes.count == 0 then 
			(
				append DL layerName
				--print DL.count
				--print DL
				--try (print layerName) catch()
				--try (LayerManager.deleteLayerByName layerName) catch()	
			)
	)

	for d in DL do LayerManager.deleteLayerByName d
)
	
	on applybone pressed do with undo on (
		
	simbones=#()

	setStartEndFrame()

	-------------- Clear  array
	simBones = #()
	bone_TM = #()
	preTimebone_TM = #()
	prePos = #()
	bcnt = #()
	
	delay = delaysp.value

	for object in selection do 
		if superClassOf object == GeometryClass do 
			at time frameStart getBoneChain object
	
	
-----------------------Start  to  calculate---------------
	loopsv = if loops.checked then 2 else 1 
	subframe = 1f/subs.value
	
	pv = 100.0/ loopsv / (frameEnd - framestart + 1)
	doit_prog.value = 0.0
	totalVal = 0
	
	for L = 1 to loopsv do (
		
		for t = framestart to frameEnd do (
			if keyboard.escPressed then exit
			--slidertime = tf			------Play
			currtTime = t

			for sf in 1 to subs.value do (
				currtTime += subframe

				for i in 1 to simbones.count do (
					currentPTM = at time currtTime simbones[i][1].parent.transform
					
					for j in 1 to simbones[i].count do (
						
						targetboneTM = bone_TM[i][j] * currentPTM
						currentPos  = if j==1 then prePos[i] else preTimebone_TM[i][j+1].pos
						tpos = targetboneTM.pos
							
						----------Twist X -------------
						angX = acos(dot (normalize preTimebone_TM[i][j].row1) (normalize targetboneTM.row1))
						newTM1 = copy preTimebone_TM[i][j]
						
						vt1 = normalize (cross preTimebone_TM[i][j].row1 targetboneTM.row1)
							
						if angX >0.001 do rotate newTM1 (quat angX -vt1) 
					
						newTM1.pos = tpos

						angY1 = acos(dot (normalize newTM1[2]) (normalize targetboneTM.row2))	
						ssvt = cross (normalize newTM1[2]) (normalize targetboneTM.row2)

						xaxisdelay = (upspring.value + ((simbones[i].count-j)/(simbones[i].count)*(1.0-upspring.value)) )
						angY1 = angY1 * xaxisdelay
						if dot ssvt targetboneTM.row1 >0 do angY1 = -angY1
						if abs angY1 >0.001 do rotate newTM1 (quat angY1 targetboneTM.row1) 
						newTM1.pos = tpos
						targetboneTM = copy newTM1
						-----------------------------------------------------------------------------------------------------------------------------------------	
						
						tvector = normalize targetboneTM.row1
						cvector = normalize (currentPos - tpos)
						vt = normalize (cross cvector tvector)
						angel = acos(dot (normalize cvector) (normalize tvector))
						
						angel *= (1.0-delay)
						sangel = angel 
						if j == 1 do angel *= scaleMotion.value
						ttm = copy targetboneTM
						
						rotate targetboneTM (quat angel vt)
						if j == 1 do rotate ttm (quat sangel vt)
						targetboneTM.pos = ttm.pos = tpos

						if L == loopsv and sf == subs.value do (

							animate on at time (t + 1f)
							(
								if classof simbones[i][j].controller == BipSlave_Control and classof simbones[i][j] != Dummy then
									biped.setTransform simbones[i][j] #rotation targetboneTM.rotation true
								else if classof simbones[i][j] == CATBone then
									simbones[i][j].transform = copy targetboneTM
								else 
									simbones[i][j].rotation.controller.value = targetboneTM.rotation * inverse currentPTM.rotation
							)
						)

						currentPTM = copy targetboneTM
						preTimebone_TM[i][j] = copy targetboneTM
						
						if j == 1 do 
							prePos[i] = bone_TM[i][j+1].pos * ttm


						preTimebone_TM[i][j+1].pos = bone_TM[i][j+1].pos * targetboneTM	
						

					)-----end for j	
				)----end for bones
			)
			totalVal += pv
			if totalVal >= 20.0 do (
				doit_prog.value += totalVal
				totalVal = 0.0
			)
		)----end for t
	)----end for Loops
	doit_prog.value = 100.0
	)
	on pasteRp pressed do (

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

							b.transform = b.boneTM * b.parent.transform

						) else if classof b == Biped_Object then biped.setTransform b #rotation (b.boneTM*b.parent.transform).rotation true
						else if classof b.controller != BipSlave_Control
							do b.rotation.controller.value = b.boneTM.rotation
					)
				)
		)----end for bone
	)

	on setRp pressed do (
	
		for obj in selection do (

			local objtype = classof obj
			if superClassOf obj != GeometryClass do continue
			if obj.parent == undefined do return root
			local bones=#()
			append bones obj
			
			while obj != undefined do (
				if keyboard.escPressed then exit
				isfind = false
				for c in obj.children do 
					if  classof c == objtype or classof c == Dummy then (
						append bones c
						obj = c
						isfind = true
						exit
					)else continue
				if not isfind do 
					obj = undefined
			)

			for b in bones do
				if classof b == objtype do (
					if not isProperty b "boneTM" do 
						CustAttributes.add b sprboneCA
				
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
	on springMagic_rol open do (
		aframestart.value = animationRange.start
		aframeEnd.value = animationRange.end
	)
	
	on btnDelKeys pressed do with undo on
	(
		setStartEndFrameDeleteKey()
		slidertime = framestart
		deleteKeysRange framestart frameEnd chePos.checked cheSca.checked cheRot.checked
	)
	
	on btnDelOutKeys pressed do with undo on
	(
		setStartEndFrameDeleteKey()
		--slidertime = framestart
		if cheAll.checked then for tempObject in Objects as Array do CleanOutRangeKeys tempObject framestart frameEnd
		else for tempObject in selection as Array do CleanOutRangeKeys tempObject framestart frameEnd
	)
	
	on btn_LoopStart pressed do with undo on
	(
		aBState = animButtonState
		animButtonState  = false
		sortedArr = sortArrayByHeirarchy (selection as array)
		boneLoopStart sortedArr
		animButtonState = aBState
	)
	
	on btn_EulerFilter pressed do	
   (
	   sel = (selection as array)
	   for i=1 to sel.count where(classof sel[i] == boneobj )do
	        (
	         sel[i].Rotation.Controller =  TCB_Rotation ()
	         sel[i].Rotation.Controller =  Euler_XYZ ()
			)
   )
   	on btn_SelectAllBones pressed do	
   (
	   allBones = for b in objects where(classOf b == boneobj and b.isHidden==false) collect b
	   select allBones
   )
    on btn_SelectAllBiped pressed do
    (
    	allBiped = for p in objects where(classOf p == Biped_Object and p.isHidden==false) collect p
	    select allBiped
    )
    on btn_CleanEmptyLayer pressed do
    (
    	CleanEmptyLayer ()
    )
    on btn_language pressed  do 
	(
	if btn_language.text =="En"  then 
	(
		china()
		btn_language.text = n_Fn_Lan_a
		postest = getDialogpos springMagic_rol
		destroyDialog springMagic_rol
		createdialog springMagic_rol  pos:postest
	)else(
		english()
		btn_language.text = n_Fn_Lan_a
		postest = getDialogpos springMagic_rol
		destroyDialog springMagic_rol
		createdialog springMagic_rol  pos:postest
	)	
	)
	on springMagic_rol open do
	(
	btn_language.text = n_Fn_Lan_a
	---------------------------------------------------------------------------------------------打开文件加载
	tempdata = ((GetDir #scripts)+"\\"+"SpringMagic_Lan.ini")-----指定文件
	testPath = doesFileExist tempdata------检测文件是否存在
	if testPath == true then (
	open_tempdata   = openFile tempdata------打开temp文件
	skip_tmepdata   = skiptostring open_tempdata "Language = "
	if skip_tmepdata ==ok then (
		read_tempdata = readLine open_tempdata 
		en_ch = read_tempdata as booleanClass
	if en_ch  == true then (english()) else (china())
		) else (china())
	close open_tempdata
	)else (china())
	)
	on springMagic_rol close do
	(
	tempdata = ((GetDir #scripts)+"\\"+"SpringMagic_Lan.ini")
	create_tempdata = createfile tempdata
	if btn_language.text  == "En" then forlagdata = "Language = true" else  forlagdata = "Language = false"
	format  "%\n" forlagdata to:create_tempdata 
	close create_tempdata
	)
)
createDialog springMagic_rol pos:[1100,150]
)