-------------------------------------------------------
-------------------AnimationTool-----------------------
------------------Time:2025-03-26----------------------
-------------------Author:一方狂三-------------------------
------------------QQ:1256604813-------------------------
-------------------------------------------------------

try(DestroyDialog YJSCNQB)catch()
rollout YJSCNQB "一键生成内嵌Bone" width:171 height:110
(
	button 'btn1' "全部生成内嵌Bone" pos:[25,14] width:121 height:29 align:#left toolTip:"选中质心后再点击按钮一键生成"
	button 'btn2' "局部选定生成内嵌Bone" pos:[25,53] width:121 height:29 align:#left toolTip:"单独选中bip骨骼后再点击按钮一键生成"
	label 'lbl5' "by:一方狂三" pos:[9,90] width:77 height:14 align:#left

-----------------函数部分-------------------------------------------------------
-----------------全部生成内嵌Bone-----------------------------------------------	
	fn Create_Counter_Bone = 
	(
		if selection.count == 0 then 
		(
            messageBox "请选中一个Biped骨骼的质心对象" title:"提示"
            return false
        )

		local selObj = selection[1]
        if not (isKindOf selObj Biped_Object) do
        (
            messageBox "选中的对象不是Biped骨骼！" title:"错误" beep:false
            return false
        )	
		local bipNamePattern = @"^Bip\d{3}$"  -- 名称必须严格为 Bip + 3位数字
		local regex = dotNetObject "System.Text.RegularExpressions.Regex" bipNamePattern

		if not (regex.IsMatch selObj.name) do
		(
			messageBox "选中的Biped骨骼不是质心（名称不符合 Bip### 格式）！" title:"错误" beep:false
			return false
		)

		-- 收集骨骼 ---- 精准过滤Footsteps --
		local bipPrefix = selObj.name
		local bipedBones = for obj in objects where 
		isKindOf obj Biped_Object and 
		matchPattern obj.name pattern:(bipPrefix + " *") and 
		obj != selObj and 
		not (matchPattern obj.name pattern:"*Footsteps*") and  -- 过滤Footsteps
		not (isProperty obj #footstep) collect obj  -- 双重过滤
		
		-- 第二部分：安全结构体定义 --
		local structName = uniqueName "BoneStruct_"
		execute ("struct " + structName + " (srcBiped, boneNode, parentName)")
		
		-- 第三部分：骨骼创建函数 --
		fn createBoneFromBiped bipedBone boneStructType = 
		(
			-- 安全位置计算 --
			local startPos = bipedBone.transform.translation
			local endPos = if bipedBone.children.count > 0 then 
				bipedBone.children[1].transform.translation 
			else 
				startPos + (bipedBone.transform.row3 * 15)  -- 默认延长
			
			-- 创建骨骼 --
			local newBone = BoneSys.createBone startPos endPos [0,1,0]
			newBone.name = "Bone_" + bipedBone.name
			try(newBone.width = bipedBone.width)catch(newBone.width = 5)
			try(newBone.height = bipedBone.height)catch(newBone.height = 5)
			newBone.transform = bipedBone.transform
			
			-- 返回结构体实例 --
			boneStructType srcBiped:bipedBone boneNode:newBone parentName:(if bipedBone.parent != undefined then bipedBone.parent.name else "")
		)
	
		-- 第四部分：主处理流程 --
		local boneDataArray = #()
		
		for b in bipedBones do
		(
			try (
				-- 创建结构体实例（使用动态类型）--
				local boneData = createBoneFromBiped b (execute structName)
				append boneDataArray boneData
			) catch (
				format "[ERROR] 无法处理骨骼 %：%\n" b.name (getCurrentException())
			)
		)
		
		-- 建立层级关系 --
		for data in boneDataArray do
		(
			if data.parentName != "" do
			(
				local parentBoneName = "Bone_" + data.parentName
				local parentBone = getNodeByName parentBoneName
				if parentBone != undefined do data.boneNode.parent = parentBone
			)
		)
		
		-- 第五部分：新增约束系统 --
		if boneDataArray.count > 0 do
		(
			-- 约束计数器
			local constraintSuccess = 0
			
			for data in boneDataArray do
			(
				try (
					local targetBiped = data.srcBiped
					local boneNode = data.boneNode
					
					----------------------------
					-- 位置约束配置 --
					----------------------------
					-- 检查现有控制器类型
					if classOf boneNode.pos.controller != Position_Constraint do
					(
						-- 备份原始控制器
						local originalPosController = boneNode.pos.controller
						
						-- 创建位置约束
						posConstraint = Position_Constraint()
						posConstraint.relative = off  -- 使用绝对位置
						posConstraint.appendTarget targetBiped 100.0
						
						-- 应用约束并保留原始变换
						boneNode.pos.controller = posConstraint
						boneNode.pos += originalPosController.value  -- 保持当前位置
						
						format "[位置约束] % → %\n" boneNode.name targetBiped.name
					)
					
					----------------------------
					-- 方向约束配置 --
					----------------------------
					if classOf boneNode.rotation.controller != Orientation_Constraint do
					(
						-- 备份原始控制器
						local originalRotController = boneNode.rotation.controller
						
						-- 创建方向约束
						rotConstraint = Orientation_Constraint()
						rotConstraint.appendTarget targetBiped 100.0
						
						-- 应用约束并保留原始旋转
						boneNode.rotation.controller = rotConstraint
						boneNode.rotation += originalRotController.value
						
						format "[方向约束] % → %\n" boneNode.name targetBiped.name
					)
					
					constraintSuccess += 1
					
				) catch (
					format "[约束错误] %：%\n" boneNode.name (getCurrentException())
				)
			)
		)
		
		-- 第六部分：最终处理 --
		if boneDataArray.count > 0 then
		(
			select (for d in boneDataArray collect d.boneNode)
			messageBox ("成功创建,约束完成：成功添加" + boneDataArray.count as string + " 个Bone骨骼") title:"完成"
			
		)
		else
		(
			messageBox "未创建任何骨骼，请检查过滤条件！" title:"警告"
		)
	)
-------------------局部选定生成内嵌Bone--------------------------------------
	fn Create_Local_Bone = 
	(
			-- 第一步：增强类型检查 --
		fn isBipedBone obj = 
		(
			isKindOf obj Biped_Object and 
			not matchPattern obj.name pattern:"*Footsteps*" and
			classOf obj.controller == BipSlave_Control
		)

		-- 第二步：选择验证 --
		if selection.count == 0 then 
		(
			messageBox "请选中一个Biped骨骼对象" title:"提示"
			return #()
		)

		local selBipeds = #()
		for obj in selection do 
		(
			if isBipedBone obj then 
			(
				append selBipeds obj
			) 
			else
			(
				messageBox ("选中的对象 '" + obj.name + "' 不是有效Biped骨骼！") title:"错误"
				return #()
			)
		)

		-- 第三步：安全创建骨骼 --
		struct BoneInfo (biped, bone)
		local boneDataArr = #()

		with redraw off undo off 
		(
			for biped in selBipeds do 
			(
				try 
				(
					-- 获取Biped变换矩阵 --
					local bipedTM = biped.transform
					local startPos = bipedTM.translation
					local zAxis = bipedTM.row3
					
					-- 智能计算末端位置 --
					local endPos = startPos + zAxis * 10  -- 默认长度10单位
					if biped.children.count > 0 and isBipedBone biped.children[1] do 
					(
						endPos = biped.children[1].transform.translation
					)
					
					-- 创建骨骼并匹配属性 --
					local newBone = BoneSys.createBone startPos endPos [0,1,0]
					newBone.name = "Bone_" + biped.name
					newBone.transform = bipedTM
					newBone.parent = biped
					-- 尺寸适配 --
					try(newBone.width = biped.controller.width)catch(newBone.width = 5.0)
					try(newBone.height = biped.controller.height)catch(newBone.height = 5.0)
					
					append boneDataArr (BoneInfo biped:biped bone:newBone)
				)
				catch 
				(
					format "[创建错误] %：%\n" biped.name (getCurrentException())
				)
			)
		)

		-- 第四步：安全添加约束 --
		if boneDataArr.count > 0 do 
		(
			for data in boneDataArr do 
			(
				try 
				(
					-- 位置约束 --
					if classOf data.bone.pos.controller != Position_Constraint do 
					(
						data.bone.pos.controller = Position_Constraint()
						data.bone.pos.controller.appendTarget data.biped 100.0
					)
					
					-- 方向约束 --
					if classOf data.bone.rotation.controller != Orientation_Constraint do 
					(
						data.bone.rotation.controller = Orientation_Constraint()
						data.bone.rotation.controller.appendTarget data.biped 100.0
					)
				) 
				catch 
				(
					format "[约束错误] %：%\n" data.bone.name (getCurrentException())
				)
			)
		)

		-- 完成处理 --
		enableSceneRedraw()
		resumeEditing()

		if boneDataArr.count > 0 then 
		(
			select (for d in boneDataArr collect d.bone)
			messageBox ("成功生成 " + boneDataArr.count as string + " 个Bone骨骼") title:"完成"
		) 
		else 
		(
			messageBox "没有生成任何骨骼！" title:"警告"
		)

		gc()

	)		
----------------层集分类-----------------------------------------------------------------	
	fn autoSortBipedBone = 
	(
		-- 自动收集所有符合名称规则的物体
		local targetObjs = for o in objects where matchPattern o.name pattern:"*Bone_Bip*" collect o
		
		-- 创建/更新层
		local layer = LayerManager.getLayerFromName "Bone_Bip"
		if layer == undefined then 
		(
			layer = LayerManager.newLayerFromName "Bone_Bip"
		   
		)
		layer.addNodes targetObjs -- 自动添加物体
		
		-- 创建/覆盖选择集
		selectionSets["Bone_Bip"] = targetObjs
		
		redrawViews()
		format "已分类 % 个Face_ExPoint物体\n" targetObjs.count
		true
	)
	
-----------------按钮事件---------------------------------------------------------
	on btn1 pressed  do
	(
		undo on
		(
			Create_Counter_Bone()
			autoSortBipedBone()
		)
	)
	on btn2 pressed  do
	(
		undo on
		(
			Create_Local_Bone()
			autoSortBipedBone()
		)
	)
)
Createdialog YJSCNQB