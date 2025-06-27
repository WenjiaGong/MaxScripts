-------------------------------------------------------
-------------------AnimationTool-----------------------
------------------Time:2025-03-04----------------------
-------------------Author:一方狂三-------------------------
------------------QQ:1256604813-------------------------
-------------------------------------------------------
global g_IKHelpers = #()  -- 存储所有IK控制器
global g_FKChain = #()    -- 存储所有FK骨骼
global g_IKBone = #()  
global g_pts = #()

try DestroyDialog IKFK链条生成 catch()

rollout IKFK链条生成 "IKFK链条生成v4.6" width:231 height:500
(
    
    
	GroupBox '样条线创建' "样条线创建" pos:[9,12] width:212 height:131 align:#left
	radiobuttons 'rdoMode' "生成模式：" pos:[15,36] width:211 height:30 labels:#("自动骨骼链", "手动选择骨骼") default:1 columns:2 align:#left
	button 'btnCreate' "创建样条线" pos:[55,70] width:120 height:30 align:#left
	button 'btnHelp' "使用说明" pos:[128,114] width:80 height:20 align:#left
	label 'lblInfo' "状态：等待操作" pos:[16,119] width:77 height:13 align:#left
    
	GroupBox 'IKFK链创建' "IKFK链创建" pos:[9,152] width:212 height:67 align:#left
	button 'chuangjianIK' "创建IK" pos:[36,172] width:58 height:30 align:#left toolTip:"选中SkinBone，创建IK骨骼链条，记得都设置下蒙皮姿势"
	button 'chuangjianFK' "创建FK" pos:[126,172] width:58 height:30 align:#left toolTip:"选中SkinBone，创建FK骨骼"
    
	GroupBox 'IKFK对齐' "IKFK对齐" pos:[9,228] width:212 height:67 align:#left
	button 'btn9' "创建切换属性" pos:[23,250] width:77 height:30 align:#left toolTip:"点击按钮自动生成IKFK切换"
	button 'btn10' "创建对齐属性" pos:[120,250] width:77 height:30 align:#left toolTip:"这个按钮是单独分离开的，可以用在其他文件里面，点击前请确保物体是有在属性承载器的，然后会报错"

	GroupBox '大小修改' "大小修改" pos:[9,304] width:212 height:172 align:#left
	label '虚拟点' "虚拟点" pos:[26,326] width:54 height:17 align:#left
	label 'lbl8' "Bone骨骼" pos:[143,326] width:54 height:17 align:#left
	checkbox 'chk1' "Center Marker" pos:[22,346] width:93 height:21 align:#left
	checkbox 'chk2' "Axis Tripod" pos:[22,371] width:78 height:21 align:#left
	checkbox 'chk3' "Cross" pos:[23,396] width:72 height:21 align:#left
	checkbox 'chk4' "Box" pos:[22,420] width:72 height:21 align:#left
	spinner 'pSize' "" pos:[57,447] width:71 height:16 range:[0,100,6] align:#left
	label 'lbl14' "大小：" pos:[20,448] width:32 height:16 range:[0,100,4] align:#left
	label 'lbl15' "宽度" pos:[153,350] width:32 height:16 range:[0,100,4] align:#left
	spinner 'Bkuandu' "" pos:[135,374] width:76 height:16 range:[0,100,4] align:#left
	label 'lbl16' "高度" pos:[153,400] width:32 height:16 range:[0,100,6] align:#left
	spinner 'Bgaodu' "" pos:[135,424] width:76 height:16 range:[0,100,4] align:#left
	label 'lbl4' "by：一方狂三" pos:[13,480] width:101 height:15 align:#left  
  
	--变量定义-----
	local splineObj  -- 存储创建的样条线对象
	local originalBones = #()  -- 新增：存储原始骨骼引用（所有按钮可访问）
    local clonedBonesArray   = #()  -- 可选：存储克隆骨骼引用
	local IKCTR = #()
	local FKBONE = #()

	
	

    -- 函数定义 --
    fn createAutoSpline = (
        if selection.count == 0 do (messageBox "请先选择根骨骼！"; return undefined)
        rootBone = selection[1]
        if classOf rootBone != BoneGeometry do (messageBox "所选对象不是Bone骨骼！"; return undefined )
        
        boneChain = #()
        currentBone = rootBone
        while currentBone != undefined do (
            append boneChain currentBone
            currentBone = if currentBone.children.count > 0 then currentBone.children[1] else undefined
        )
        
        if boneChain.count < 2 do (messageBox "骨骼链需要至少两个骨骼！"; return undefined)
        return boneChain
    )
    
    fn createManualSpline = (
        if selection.count < 2 do (messageBox "请至少选择两个骨骼！"; return undefined)
        validBones = for obj in selection where classOf obj == BoneGeometry collect obj
        if validBones.count < 2 do (messageBox "需要至少选择两个有效骨骼！"; return undefined)
        return validBones
    )

    fn createOptimizedSpline ptArray = (
        local spline = SplineShape()
        spline.name = uniqueName "BoneSpline_"
        spline.steps = 12
        
        addNewSpline spline
        for pos in ptArray do (
            addKnot spline 1 #smooth #curve pos
        )
        
        updateShape spline
        convertToSplineShape spline
        
        spline.wirecolor = color 255 128 0
        spline.render_displayRenderMesh = false
        spline.render_thickness = 0.0
        spline.xray = true
        
        spline
    )

    fn AddPoints = (
		global g_pts = #()
		local pts = #()
        for obj in selection do (
            local pt = point size:4 centermarker:false axistripod:false cross:false box:true wirecolor:[84,255,0]
            pt.name = uniqueName "PT_FZ_"  -- 关键命名规则
			pt.transform = obj.transform
            append g_pts pt
			append pts pt
        )
        
        for i = 1 to selection.count do (
            local obj = selection[i]
            local posCon = position_constraint()
            obj.pos.controller = posCon
            posCon.appendTarget pts[i] 100
            
            if i < selection.count do (
                local lookAtCon = LookAt_constraint()
                obj.rotation.controller = lookAtCon
                lookAtCon.appendTarget pts[i+1] 100
                lookAtCon.lookAt_vector_length = 0
                lookAtCon.upnode_world = false
                lookAtCon.pickupNode = pts[i]
            )
        )
		
        pts  -- 返回创建的虚拟点数组
    )
	
	
	fn AddSPoints = 
	(
		tempSPoints = #()
		boneLengths = #()
		
		-- 第一遍循环：创建Points并计算骨骼长度
		for obj in selection where classOf obj == BoneGeometry do 
		(
			local boneWidth = try(obj.width)catch(5.0)
			local newPoint = Point name:(uniqueName "SPoint_") size:boneWidth
			newPoint.transform = obj.transform
			newPoint.Box = off
			newPoint.cross = on
			newPoint.AxisTripod = off
			newPoint.centermarker = off
			append tempSPoints newPoint
			
			-- 计算骨骼长度（末端骨骼返回undefined）
			local boneLength = if obj.children.count > 0 then (
				distance obj obj.children[1]
			) else (
				undefined -- 标记为末端骨骼
			)
			append boneLengths boneLength
		)
		
		-- 第二遍循环：添加约束和表达式
		for i = 1 to selection.count where classOf selection[i] == BoneGeometry do 
		(
			try (
				local bone = selection[i]
				local point1 = tempSPoints[i]
				local point2 = if i < tempSPoints.count then tempSPoints[i+1] else point1
				
				-- 标准方法关闭X轴向继承
				local currentFlags = getInheritanceFlags bone
				setInheritanceFlags bone (currentFlags - #{7}) keepPos:true
				
				-- 位置和旋转约束（所有骨骼都需要）
				bone.pos.controller = Position_Constraint()
				bone.pos.controller.appendTarget point1 100.0
				bone.rotation.controller = Orientation_Constraint()
				bone.rotation.controller.appendTarget point1 100.0
				
				-- 仅对非末端骨骼添加缩放表达式
				if boneLengths[i] != undefined do 
				(
					bone.scale.controller = ScaleXYZ()
					bone.scale.controller.X_Scale.controller = Float_Expression()
					local exprCtrl = bone.scale.controller.X_Scale.controller
					
					try(exprCtrl.DeleteAllTargets())catch()
					exprCtrl.AddVectorTarget "a" point1.pos.controller
					exprCtrl.AddVectorTarget "b" point2.pos.controller
					exprCtrl.SetExpression ("length(a-b)/" + boneLengths[i] as string)
					
				)
				
				-- 调试输出
				format "骨骼[%] % 设置完成:\n" i bone.name
				format "  末端骨骼: %\n" (boneLengths[i] == undefined)
				format "  继承标志: %\n" (getInheritanceFlags bone)
				if boneLengths[i] != undefined do (
					format "  表达式: %\n" (bone.scale.controller.X_Scale.controller.GetExpression())
					format "  初始长度: %\n" boneLengths[i]
				)
				
			) catch (
				format "!! 处理骨骼 % 时出错: %\n" bone.name (getCurrentException())
			)
		)
		
		#(tempSPoints, boneLengths)
	)

    
	-- 按钮事件 ----------

	
	on btnCreate pressed do
	(
	        local bonesArray, spline
	        
	        case rdoMode.state of (
	            1: (bonesArray = createAutoSpline())
	            2: (bonesArray = createManualSpline())
	        )
	        
	        if bonesArray == undefined then (
	            lblInfo.text = "状态：创建失败"
	            return false
	        )
	        
	        try 
			(
	            positions = for bone in bonesArray collect bone.pos
	            spline = createOptimizedSpline positions
	            IKFK链条生成.splineObj = spline  -- 存储样条线引用
	            select spline
	            max zoomext sel
	            lblInfo.text = "状态：创建成功 - " + spline.name
	        )
	        catch (
	            messageBox ("错误: " + getCurrentException())
	            lblInfo.text = "状态：发生错误"
	        )
	    )
	on btnHelp pressed do
	(
	    helpText = "使用说明：\n\n"
	    helpText += "【自动模式】\n"
	    helpText += "1. 选择骨骼链的根骨骼\n"
	    helpText += "2. 点击创建按钮\n"
	    helpText += "3. 自动沿子骨骼层级创建样条线\n\n"
	    helpText += "【手动模式】\n"
	    helpText += "1. 按顺序选择至少2个骨骼\n"
	    helpText += "2. 点击创建按钮\n"
	    helpText += "3. 按选择顺序创建样条线\n\n"
	    helpText += "★ 高级功能：\n"
	    helpText += "- 自动平滑曲线（steps=12）\n"
	    helpText += "- 橙色Xray显示\n"
	    helpText += "- 关闭视口渲染网格\n"
	    helpText += "- 自动命名和聚焦"
	    
	    messageBox helpText title:"帮助信息" width:300
	)
	on chuangjianIK pressed do
	(
	    if IKFK链条生成.splineObj == undefined do (
	        messageBox "请先创建样条线！"
	        return undefined
	    )
	    $.boneFreezeLength=false
		 IKFK链条生成.originalBones = for obj in selection where isValidNode obj collect obj
	        format "已存储IK原始骨骼：%\n" originalBones
	    
	    if originalBones.count < 2 do (
	        messageBox "需要至少选择两个骨骼！" title:"错误"
	        return undefined
	    )
	    
	    maxOps.cloneNodes $ cloneType:#copy newNodes:&nnl
	    g_IKBone = nnl
	    g_IKBone.wireColor = color 252 252 0
	    g_IKBone.sidefins=true

	   
	    for a = 1 to g_IKBone.count do
		(
			g_IKBone[a].name = uniqueName "IK_"
		)
           
		format "已存储g_IKBone: %\n" g_IKBone
	    -- 为原始骨骼添加约束到克隆骨骼
		
		-- 一次性为原始骨骼创建虚拟点系统
		select originalBones
		result = AddSPoints()
		local virtualPoints = result[1]  -- 获取创建的虚拟点数组
	    
		for i = 1 to virtualPoints.count do 
	    (
	        try 
	        (
				virtualPoints[i].pos.controller = Position_Constraint()
	            virtualPoints[i].pos.controller.appendTarget g_IKBone[i] 100.0
	            
	            virtualPoints[i].rotation.controller = Orientation_Constraint()
	            virtualPoints[i].rotation.controller.appendTarget g_IKBone[i] 100.0
	        ) 
	        catch 
	        (
	            format "第 % 根骨骼约束失败: %\n" i (getCurrentException())
	        )
	    )
	    
	    if g_IKBone.count >= 2 then (
	        select g_IKBone
	        local pts = AddPoints()
	        local myline = IKFK链条生成.splineObj
	        
	        -- 添加Spline IK Control修改器
	        addModifier myline (Spline_IK_Control())
	        local splineIKMod = myline.modifiers[#Spline_IK_Control]
	        
	        -- 正确设置初始链接模式（使用文档定义的linkTypes属性）
			splineIKMod.linkTypes = 2  -- 0=Link All In Hierarchy, 1=Link All to Root, 2=No Linking
	        
	        --- 创建Helpers（使用正确方法签名）
			local knotCount = g_IKBone.count
			if not (splineIKMod.createHelper knotCount) do (
	        messageBox "控制器创建失败！"
	        return false
			)

	        -- 正确获取Helpers的方法（通过helper_list属性）
			g_IKHelpers = splineIKMod.helper_list  -- 官方定义的数组参数
			format "已存储Helpers: %\n" g_IKHelpers
			
			-- 验证Helpers数量
			if g_IKHelpers.count != g_IKBone.count do (
	        messageBox "控制器数量不匹配！\n实际创建：" + g_IKHelpers.count as string + "个\n需要：" + g_IKBone.count as string
	        return false
			)
	        
	        -- 对齐控制器方向（使用矩阵变换）
			for i = 1 to g_IKHelpers.count do (
				boneTM = g_IKBone[i].transform
				in coordsys world (
	            g_IKHelpers[i].transform = boneTM
	            g_IKHelpers[i].rotation = inverse boneTM.rotationPart
				)
			)
	        
	        -- 设置最终链接模式（使用专用方法）
			splineIKMod.linkToRoot()  -- 等效于linkTypes = 1
	        
	        -- 应用路径约束
	        with animate off (
				for i = 1 to pts.count do (
					-- 新增：创建位置列表控制器 --
					pts[i].position.controller = position_list()
					
					-- 保留原始路径约束逻辑（修改为添加到可用控制器）--
					pc = Path_Constraint()
					pts[i].pos.controller.Available.controller = pc  -- 修改此处
					pc.appendTarget myline 100.0
					pc.percent = 100.0 * (i-1)/(pts.count-1)
				)
			)
			-- 修改删除动画关键帧的代码 --
			try (
				-- 保存当前选择 --
				oldSel = selection as array
				
				-- 选择所有路径点 --
				select pts
				
				-- 运行删除动画命令 --
				macros.run "Animation Tools" "DeleteSelectedAnimation"
				
				-- 恢复原始选择 --
				select oldSel
				

			) catch (
				messageBox ("删除动画失败: " + getCurrentException())
			)
	        
			-- 修改绑定后的部分 --
			for i=1 to pts.count do (
				if isValidNode g_IKHelpers[i] do (
					pts[i].parent = g_IKHelpers[i]
					pts[i].pos.controller.value = pts[i].pos
					
					-- 新增：添加位置XYZ控制器 --
					pts[i].pos.controller.Available.controller = Position_XYZ()
					
					-- 激活到最后添加的位置XYZ --
					try (
						pts[i].pos.controller.active = 3  -- 可能需要根据实际层级调整索引
						
					) catch (
						format "控制器激活失败: %\n" (getCurrentException())
					)
				)
			)	
			select originalBones
			
	    )
	    else (
	        messageBox "请至少选择两个skin骨骼。" title:"错误"
	    )
	)
	on chuangjianFK pressed do
	(
		try (
		
			if selection.count == 0 do throw "请先选择骨骼"
			
		local virtualPoints = for obj in objects where (matchPattern obj.name pattern:"SPoint_*") collect obj
		if virtualPoints.count == 0 do (
			messageBox "未找到虚拟点！请先创建IK系统。" title:"错误"
			return undefined
		)
		
			-- 保存原始骨骼引用
		IKFK链条生成.originalBones = for obj in selection where isValidNode obj collect obj
	    format "已存储FK原始骨骼：%\n" originalBones
		
		maxOps.cloneNodes $ cloneType:#copy newNodes:&nnl
		clonedBones = nnl
		
		
		select clonedBones
		clonedBones.wireColor = color 0 252 252
		$.boneFreezeLength=false
		$.frontfin = on	
		$.backfin = on
		

		
		for b = 1 to clonedBones.count do 
		(
			clonedBones[b].name = uniqueName "FK_"
		)
		g_FKChain = clonedBones
		format "已存储全局FK骨骼: %\n" g_FKChain
		
		 -- 记录克隆骨骼的初始变换信息（关键步骤）
	    initialTransforms = for bone in clonedBones collect bone.transform
	    initialPositions = for bone in clonedBones collect bone.pos
	    initialRotations = for bone in clonedBones collect bone.rotation
		
		-- 清除克隆骨骼的约束（关键步骤）
		for bone in clonedBones do
	    (
	        -- 重置位置控制器
	        if classOf bone.pos.controller != Position_XYZ do
	            bone.pos.controller = Position_XYZ()
	        
	        -- 重置旋转控制器
	        if classOf bone.rotation.controller != Euler_XYZ do
	            bone.rotation.controller = Euler_XYZ()
			
			 -- 重置缩放控制器
	        if classOf bone.scale.controller != tcb_scale do
	            bone.scale.controller = tcb_scale()

	    )
		
		 -- 清除约束并恢复位置（关键修改）
	    for i = 1 to clonedBones.count do
	    (
	        bone = clonedBones[i]
	        
	        -- 保存初始状态
	        originalTM = initialTransforms[i]
	        originalPos = initialPositions[i]
	        originalRot = initialRotations[i]
	        
	        -- 重置控制器前冻结变换
	        with animate off
	        (
	            -- 重置位置控制器
	            if classOf bone.pos.controller != Bezier_Position do
	            (
	                bone.pos.controller = Bezier_Position()
	                bone.pos.controller.value = originalPos  -- 直接赋值位置
	            )
	            
	            -- 重置旋转控制器
	            if classOf bone.rotation.controller != Euler_XYZ do
	            (
	                bone.rotation.controller = Euler_XYZ()
	                bone.rotation.controller.value = originalRot  -- 直接赋值旋转
	            )
	            
	            -- 强制更新变换
	            bone.transform = originalTM
	        )
	    )
		
		 -- 为原始骨骼添加约束到FK骨骼（权重0）
	    for i = 1 to virtualPoints.count do
	    (
	        try (
	            -- 位置约束
	            posConstr = Position_Constraint()
	            virtualPoints[i].pos.controller = posConstr
	            posConstr.appendTarget clonedBones[i] 0.0  -- 初始权重0
	            
	            -- 方向约束
	            rotConstr = Orientation_Constraint()
	            virtualPoints[i].rotation.controller = rotConstr
	            rotConstr.appendTarget clonedBones[i] 0.0  -- 初始权重0
	        ) catch (
	            format "第 % 根骨骼约束失败: %\n" i (getCurrentException())
	        )
	    )
	    
	    -- 保持FK骨骼的选择状态
	    select clonedBones
		messageBox "记得设置路径约束的point蒙皮姿势" title:"提示"
		)
		catch
		(
			 messageBox "请至少选择两个skin骨骼。" title:"错误"
		)
	)
	on btn9 pressed do
	(
	
		local virtualPoints = for obj in objects where (matchPattern obj.name pattern:"SPoint_*") collect obj
		if virtualPoints.count == 0 do (
			messageBox "未找到虚拟点！请先创建IK系统。" title:"错误"
			return undefined
		)

		-- 保持原有文本创建逻辑
		local Mytext = text text:"IK_FK" size:10 kerning:0 leading:0 transform:(matrix3 [1,0,0] [0,-1.62921e-07,1] [0,-1,-1.62921e-07] [0,0,0]) isSelected:on
			
		try (
			-- 添加空修改器
			modPanel.addModToSelection (EmptyModifier()) ui:on
	    
			-- 获取最新添加的修改器
			local attrMod = $.modifiers[1]
			attrMod.name = "IKFK_Switch"  -- 命名修改器
	    
			-- 根据正确示例重构属性定义
			local ca = attributes "IKFK切换"
			(
				parameters main rollout:params (
	            IK_FK type:#float animatable:true default:0.0 ui:spnIKFK  -- 添加animatable支持
	        )
	        
	        rollout params "IKFK切换" width:162 height:48 
			(
	            spinner spnIKFK "IK_FK:" range:[0,100,0] type:#float scale:1
	        )
			)
	    
	    -- 直接添加属性（参考正确代码的简洁方式）
	    custAttributes.add attrMod ca
	    
	    -- 初始化参数值
	    attrMod.IK_FK = 0.0
	    
	    -- 刷新界面
	    modPanel.setCurrentObject attrMod
			
	
		for i = 1 to virtualPoints.count do
		(
			paramWire.connect Mytext.modifiers[#IKFK_Switch].IKFK切换[#IK_FK] virtualPoints[i].pos.controller[#Position_Weight_0] "100-IK_FK"
			paramWire.connect Mytext.modifiers[#IKFK_Switch].IKFK切换[#IK_FK] virtualPoints[i].pos.controller[#Position_Weight_1] "IK_FK"
		
			paramWire.connect Mytext.modifiers[#IKFK_Switch].IKFK切换[#IK_FK] virtualPoints[i].rotation.controller[#Orientation_Weight_0] "100-IK_FK"
			paramWire.connect Mytext.modifiers[#IKFK_Switch].IKFK切换[#IK_FK] virtualPoints[i].rotation.controller[#Orientation_Weight_1] "IK_FK"
	
		)
	    
	    messageBox ("成功链接" + (originalBones as string) + "个约束参数") title:"操作成功"
		)
		catch 
		(
			messageBox ("操作失败: " + getCurrentException()) title:"错误"
		)
	)
	
	
	
	on btn10 pressed do
	(
		-- 定义动态属性名称（唯一） --
		local attrName = "IKFAKMatch_" + (random 1 99999) as string
		-- 定义持久化属性 --
		ca = attributes "attrName" version:3
		(
			parameters main 
			(
				fk_bones type:#stringTab tabSizeVariable:true
				ik_bones type:#stringTab tabSizeVariable:true
				helpers type:#stringTab tabSizeVariable:true
				pts_names type:#stringTab tabSizeVariable:true  -- 存储虚拟点名称
			)
			
			rollout params "IK/FK 对齐控制" 
			(
				button btn_fk2ik "FK→IK对齐" width:100 height:30
				button btn_ik2fk "IK→FK对齐" width:100 height:30
				
				on btn_fk2ik pressed do
				(
					undo "FK→IK对齐" on  -- 添加撤销标签
					(
						local mod = $.modifiers[1]
						
						
						 for i=1 to mod.fk_bones.count do
						(
							local fkBone = getNodeByName mod.fk_bones[i]
							local ikBone = getNodeByName mod.ik_bones[i]
							if isValidNode fkBone and isValidNode ikBone do
								fkBone.transform = ikBone.transform
						)
					)
					
				)
				
				on btn_ik2fk pressed do
				(
					undo "IK→FK对齐" on -- 添加撤销标签 
					(
						local mod = $.modifiers[1]
						
							local pts = for name in mod.pts_names where (getNodeByName name) != undefined collect (getNodeByName name )
							
							for i=1 to mod.helpers.count do
							(
								local helper = getNodeByName mod.helpers[i]
								local fkBone = getNodeByName mod.fk_bones[i]
								local currentPts = for pt in pts where isValidNode pt collect pt
								if isValidNode helper and isValidNode fkBone do
									helper.transform = fkBone.transform
									select pts
									macros.run "Characters" "AssumeSkinPose"

							)
							
							
							
							
			
							
							completeRedraw()
						)
					)
					
			)
				
		)
		

		-- 应用属性到当前对象 --
		if selection.count == 1 then
		(
			local obj = $
			
			-- 自动收集数据 --
			local fkChain = for o in g_FKChain where isValidNode o and matchPattern o.name pattern:"FK_*" collect o.name
			local ikChain = for o in g_IKBone where isValidNode o and matchPattern o.name pattern:"IK_*" collect o.name
			 -- 关键修改：实时获取Helpers列表 --
			local helperNames = for h in g_IKHelpers where isValidNode h collect h.name  -- 直接引用当前IK控制器
			-- 关键修复4：验证数据有效性 --
			 
			-- 收集当前虚拟点名称 --
			local ptsNames = for pt in g_pts where isValidNode pt collect pt.name
			
			-- 验证数据有效性 --
			if fkChain.count == 0 or ikChain.count == 0 or helperNames.count == 0 do 
			(
				messageBox "数据收集失败，请确保已正确创建IK和FK链！"
				return false
			)
			
			-- 添加/更新属性 --
			local attrMod = obj.modifiers[1]
			attrMod.name =  attrName  -- 唯一修改器名称
				
			custAttributes.add attrMod ca
			attrMod.fk_bones = deepCopy fkChain
			attrMod.ik_bones = deepCopy ikChain
			attrMod.helpers = deepCopy helperNames
			attrMod.pts_names = deepCopy ptsNames  -- 关键：存储名称而非引用
			
			-- 清空全局变量（关键！） --
			g_IKHelpers = #()
			g_FKChain = #()
			g_IKBone = #()
			g_pts = #()
			messageBox "对齐数据已持久化存储！"
			
			
			-- 修正后的字符串拼接 --
			local msg = "对齐数据已捕获！\n"
			msg += "FK骨骼：" + (fkChain.count as string) + "个\n"
			msg += "IK骨骼：" + (ikChain.count as string) + "个\n" 
			msg += "IK控制器：" + (helperNames.count as string) + "个"
			messageBox msg
			
			select obj
		)
		else
		(
			messageBox "请选择承载属性的对象！" title:"提示"
		)
	)
	
		
	on chk1 changed state do
	(
		for obj in selection do
		(
			 try (obj.centermarker = state)
			catch (format "错误：% 无此属性\n" obj.name)
		)

	)
	on chk2 changed state do
	(
		for obj in selection do
		(
			 try (obj.axistripod = state)
			catch (format "错误：% 无此属性\n" obj.name)
		)
	)
	on chk3 changed state do
	(
		for obj in selection do
		(
			 try (obj.cross = state)
			catch (format "错误：% 无此属性\n" obj.name)
		)
	)
	on chk4 changed state do
	(
		for obj in selection do
		(
			 try (obj.Box = state)
			catch (format "错误：% 无此属性\n" obj.name)
		)
	)
	on pSize changed val do
	(
		for obj in selection do
		(
			 try (obj.size = val)
			catch (format "错误：% 无此属性\n" obj.name)
		)
	)
	on Bkuandu changed val do
	(
		for obj in selection do
		(
			 try (obj.width = val)
			catch (format "错误：% 无此属性\n" obj.name)
		)
	)
	on Bgaodu changed val do
	(
		for obj in selection do
		(
			 try (obj.height = val)
			catch (format "错误：% 无此属性\n" obj.name)
		)
	)
	
)
createDialog IKFK链条生成