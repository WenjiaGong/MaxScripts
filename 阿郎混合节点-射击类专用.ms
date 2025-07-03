try (DestroyDialog yelangqiu) catch ()

global 展开变量 = 0
global 已点击清理修复 = false  -- 新增全局变量，记录是否点击过清理修复按钮

-- 规范根骨骼工具配置
struct 配置设置 (
    root角度Y = 90,
	rootWidth = 5.0,  -- 新增宽度默认值
    rootHeight = 5.0  -- 新增高度默认值
)
global 全局_配置设置 = 配置设置()

-- 核心规范函数
fn 规范根骨骼 = (
    try (
        local 旧根节点 = getNodeByName "root" exact:true
        
        -- 创建新根节点
        local 旋转角度 = EulerAngles -全局_配置设置.root角度Y 0 0
        local 新根节点 = BoneSys.createBone [0,0,0] [0,0,20] [0,0,1]
        新根节点.name = "root"
        新根节点.rotation = 旋转角度
        新根节点.width = 全局_配置设置.rootWidth  -- 使用配置宽度
        新根节点.height = 全局_配置设置.rootHeight  -- 使用配置高度
        
        -- 处理旧根节点
        if 旧根节点 != undefined and isValidNode 旧根节点 then (
            -- 替换现有root
            local 原始父级 = 旧根节点.parent
            local 子节点集合 = 旧根节点.children
            
            if 原始父级 != undefined do 新根节点.parent = 原始父级
            for 子项 in 子节点集合 do 子项.parent = 新根节点
            
            delete 旧根节点
            format "[操作] 替换现有root骨骼\n"
            return true
        ) else (
            -- 创建新的root骨骼 - 优先挂在bip001下
            local bip001节点 = getNodeByName "Bip001" exact:true
            
            if bip001节点 != undefined and isValidNode bip001节点 then (
                -- 挂在bip001下面
                bip001节点.parent = 新根节点
                format "[操作] 创建新root骨骼 (作为Bip001的子级)\n"
            ) else (
                -- 没有bip001，单独创建在原点
                format "[操作] 创建新root骨骼 (世界原点)\n"
            )
            return true
        )
        
        redrawViews()
        true
    ) catch (
        format "[错误] %\n" (getCurrentException())
        false
    )
)

-- 清除half_body节点的函数
fn 清除half_body节点 = (
    for obj in objects where matchPattern obj.name pattern:"half_body*" do
    (
        if classOf obj == Dummy do
        (
            delete obj
        )
    )
)

rollout yelangqiu "阿郎混合节点-射击类专用" width:160 height:320
(
    label yetest1 "本插件只针对biped骨骼" width:140 height:15 align:#center offset:[5,5]
	button btnAction "自动优化层级+挂点" width:140 height:30 align:#center offset:[0,5]
    button btnBatch "处理路径下的max文件" width:140 height:30 align:#center offset:[0,5]
    progressBar pbProgress "" width:140 height:15 color:green align:#center offset:[0,5]
    label lblStatus "就绪" width:140 height:15 align:#center offset:[0,5]
	label yetest3 "======================" width:140 height:15 align:#center offset:[5,10]
	button btnBatch2 "批量导出当前选择" width:140 height:30 align:#center offset:[0,5]
	button 界面控制 "填写骨骼名称>>" width:140 height:30 align:#center offset:[0,10]
	label yetest4 "感谢阎同学提供节点思路" width:140 height:15 align:#center offset:[0,10]

    -- 右侧骨骼名称区域
	button btnStandardRoot "清理挂点/优化root" pos:[180,10] width:110 height:20  -- 更新按钮文本
	
	label lblInput1 "根骨骼:root" pos:[180,35]
	edittext edtInput "" pos:[180,55] width:100 height:20 

	label lblInput2 "质心:Bip001" pos:[180,85] 
	edittext edtInput2 "" pos:[180,105] width:100 height:20
	
	label lblInput3 "脊椎:Bip001 Spine" pos:[180,135] 
	edittext edtInput3 "" pos:[180,155] width:100 height:20 
	
	label lblInput4 "左腿:Bip001 L Thigh" pos:[180,185] 
	edittext edtInput4 "" pos:[180,205] width:100 height:20 
	
	label lblInput5 "右腿:Bip001 R Thigh" pos:[180,235] 
	edittext edtInput5 "" pos:[180,255] width:100 height:20 
    
    button btnRedetect "恢复默认" pos:[180,285] width:100 height:20
    
    -- 规范区域
    groupBox grpStandard "规范root设置" pos:[300,5] width:140 height:310 
    
    groupBox grpAngle "角度设置" pos:[310,30] width:120 height:80
    
	spinner spn角度 "Y轴旋转:" range:[-180,180,90] type:#float fieldwidth:40 pos:[300,50] width:110
	button btn重置 "重置角度" width:70 height:25 pos:[325,70]
    
    
    groupBox grpActions "操作" pos:[310,120] width:120 height:110
    
	button btn执行 "替换成完美ROOT" width:110 height:30 pos:[315,140]
	spinner spnWidth "宽度:" range:[0.1,100,5.0] type:#float fieldwidth:40 pos:[315,180] width:110  -- 新增宽度调节器
	spinner spnHeight "高度:" range:[0.1,100,5.0] type:#float fieldwidth:40 pos:[315,200] width:110  -- 新增高度调节器
	
    
    
    label lbl状态 "" pos:[310,245] width:120 height:80
	
	label yetest5 "感谢李同学提供引擎反馈" pos:[310,290] width:140 height:15 
    
    fn createHalfBodyDummy = 
    (
        -- 检查是否已存在half_body节点
        local existingDummy = undefined
        for obj in objects where matchPattern obj.name pattern:"half_body*" do
        (
            if classOf obj == Dummy and obj.parent != undefined and obj.children != undefined and obj.children.count > 0 do
            (
                existingDummy = obj
                exit
            )
        )
        
        if existingDummy != undefined do
        (
            lblStatus.text = "节点已存在，跳过创建"
            return "skipped"  -- 返回特殊值表示跳过
        )
        
        -- 删除所有名为"half_body"或类似名称的虚拟体（只删除不在层级中的）
        for obj in objects where matchPattern obj.name pattern:"half_body*" do
        (
            if classOf obj == Dummy and obj.parent == undefined and obj.children == undefined do
            (
                delete obj
            )
        )
        
        -- 创建新的虚拟体
        newDummy = Dummy name:"half_body"
        newDummy.boxsize = [15,15,15]
        newDummy.wirecolor = green
        
        -- 获取用户定义的骨骼名称
        local rootName = if edtInput.text != "" then edtInput.text else "root"
        local bip001Name = if edtInput2.text != "" then edtInput2.text else "Bip001"
        local spineName = if edtInput3.text != "" then edtInput3.text else "Bip001 Spine"
        local thighLName = if edtInput4.text != "" then edtInput4.text else "Bip001 L Thigh"
        local thighRName = if edtInput5.text != "" then edtInput5.text else "Bip001 R Thigh"
        
        -- 将虚拟体位置约束到质心
        bip001 = getNodeByName bip001Name
        if bip001 != undefined then
        (
            -- 创建位置约束
            posConstraint = Position_Constraint()
            newDummy.position.controller = posConstraint
            posConstraint.constraints.appendTarget bip001 100.0
        )
        else
        (
            lblStatus.text = "错误: 未填写质心!"
			delete newDummy
            return false
        )
        
        -- 将虚拟体方向约束到根骨骼
        rootObj = getNodeByName rootName
        if rootObj != undefined then
        (
            -- 创建方向约束
            orientConstraint = Orientation_Constraint()
            newDummy.rotation.controller = orientConstraint
            orientConstraint.constraints.appendTarget rootObj 100.0
        )
        else
        (
            lblStatus.text = "错误: 未填写根骨骼!"
			delete newDummy
            return false
        )
        
        -- 将虚拟体链接到脊椎
        spineBone = getNodeByName spineName
        if spineBone != undefined then
        (
            newDummy.parent = spineBone
        )
        else
        (
            lblStatus.text = "错误: 未填写脊椎!"
			delete newDummy
			return false
        )
        
        -- 将大腿骨骼链接到虚拟体
        thighL = getNodeByName thighLName
        thighR = getNodeByName thighRName
        
        -- 链接左大腿
        if thighL != undefined then
        (
            thighL.parent = newDummy
        )
        else
        (
            lblStatus.text = " 错误: 未填写左大腿!"
			delete newDummy
			return false
        )
        
        -- 链接右大腿
        if thighR != undefined then
        (
            thighR.parent = newDummy
        )
        else
        (
            lblStatus.text = " 错误: 未右大腿!"
			delete newDummy
			return false
        )
        
        return true
    )
    
    on btnAction pressed do
    (
        local result = createHalfBodyDummy()
        if result == true then
        (
            lblStatus.text = "half_body创建成功!"
        )
        else if result == "skipped" then
        (
            -- 已由函数内部设置状态文本
        )
     
    )
    
    on btnBatch pressed do
    (
        -- 选择要处理的文件夹
        folderPath = getSavePath caption:"选择要处理的文件夹"
        if folderPath == undefined do return false
        
        -- 获取所有.max文件
        maxFiles = getFiles (folderPath + "\\*.max")
        fileCount = maxFiles.count
        
        if fileCount == 0 then
        (
            lblStatus.text = "未找到.max文件!"
            return false
        )
        
        -- 保存当前场景
        currentFile = maxFilePath + maxFileName
        if currentFile != "" do saveMaxFile currentFile
        
        -- 初始化进度条
        pbProgress.value = 0
        pbProgress.color = green
        lblStatus.text = "开始批量处理..."
        
        successCount = 0
        skipCount = 0
        errorCount = 0
        errorFiles = #()
        skipFiles = #()
        
        -- 处理每个文件
        for i = 1 to fileCount do
        (
            -- 更新进度条
            progressPercent = (i as float / fileCount * 100)
            pbProgress.value = progressPercent
            
            -- 更新状态文本
            lblStatus.text = ("正在处理 " + i as string + "/" + fileCount as string + " (" + (progressPercent as integer) as string + "%)")
            
            try
            (
                filePath = maxFiles[i]
                
                -- 重置场景
                resetMaxFile #noPrompt
                
                -- 加载文件
                loadMaxFile filePath quiet:true
                
                -- 如果已点击清理修复，先执行清理和生成完美root
                if 已点击清理修复 do
                (
                    -- 清除half_body节点
                    清除half_body节点()
                    
                    -- 生成完美root
                    local 结果 = 规范根骨骼()
                    
                    if not 结果 do
                    (
                        append errorFiles (filenameFromPath filePath + " (清理修复失败)")
                        continue
                    )
                )
                
                -- 使用当前输入框中的骨骼名称
                local rootName = yelangqiu.edtInput.text
                local bip001Name = yelangqiu.edtInput2.text
                local spineName = yelangqiu.edtInput3.text
                local thighLName = yelangqiu.edtInput4.text
                local thighRName = yelangqiu.edtInput5.text
                
                -- 创建挂点
                local result = createHalfBodyDummy()
                if result == true then
                (
                    -- 保存文件
                    saveMaxFile filePath
                    successCount += 1
                )
                else if result == "skipped" then
                (
                    -- 记录跳过
                    skipCount += 1
                    append skipFiles (filenameFromPath filePath)
                    pbProgress.color = orange -- 跳过时进度条变橙
                )
                else
                (
                    -- 记录错误
                    errorCount += 1
                    append errorFiles (filenameFromPath filePath)
                    pbProgress.color = red -- 出错时进度条变红
                )
            )
            catch
            (
                -- 捕获异常错误
                errorCount += 1
                format "处理文件 % 时出错: %\n" filePath (getCurrentException())
                append errorFiles (filenameFromPath filePath)
                pbProgress.color = red -- 出错时进度条变红
            )
            
            -- 处理事件队列，保持UI响应
            sleep 0.1
            windows.processPostedMessages()
        )
        
        -- 恢复原始场景
        if currentFile != "" do loadMaxFile currentFile
        
        -- 完成进度条
        pbProgress.value = 100
        pbProgress.color = green
        
        -- 显示结果
        resultMsg = "批量处理完成! "
        resultMsg += "成功: " + successCount as string + " 个文件, "
        resultMsg += "跳过: " + skipCount as string + " 个文件, "
        resultMsg += "失败: " + errorCount as string + " 个文件"
        
        if skipFiles.count > 0 then
        (
            resultMsg += "\n跳过文件: " + (skipFiles as string)
        )
        
        if errorFiles.count > 0 then
        (
            resultMsg += "\n失败文件: " + (errorFiles as string)
        )
        
        lblStatus.text = resultMsg
        messageBox resultMsg
    )
    
    -- 批量导出当前选择的功能
    on btnBatch2 pressed do
    (
        -- 检查是否有选中对象
        if selection.count == 0 do
        (
            messageBox "请先选择要导出的对象!"
            return false
        )
        
        -- 记录当前选中的对象名称
        local selectedNames = for obj in selection collect obj.name
        
        -- 选择包含max文件的源文件夹
        sourceFolder = getSavePath caption:"选择包含MAX文件的文件夹"
        if sourceFolder == undefined do return false
        
        -- 选择导出FBX的目标文件夹
        exportFolder = getSavePath caption:"选择导出FBX的文件夹"
        if exportFolder == undefined do return false
        
        -- 获取所有.max文件
        maxFiles = getFiles (sourceFolder + "\\*.max")
        fileCount = maxFiles.count
        
        if fileCount == 0 then
        (
            lblStatus.text = "未找到.max文件!"
            return false
        )
        
        -- 保存当前场景
        currentFile = maxFilePath + maxFileName
        if currentFile != "" do saveMaxFile currentFile
        
        -- 初始化进度条
        pbProgress.value = 0
        pbProgress.color = green
        lblStatus.text = "开始批量导出..."
        
        successCount = 0
        errorFiles = #()
        
        -- 处理每个文件
        for i = 1 to fileCount do
        (
            -- 更新进度条
            progressPercent = (i as float / fileCount * 100)
            pbProgress.value = progressPercent
            
            -- 更新状态文本
            lblStatus.text = ("正在导出 " + i as string + "/" + fileCount as string + " (" + (progressPercent as integer) as string + "%)")
            
            try
            (
                filePath = maxFiles[i]
                
                -- 重置场景
                resetMaxFile #noPrompt
                
                -- 加载文件
                loadMaxFile filePath quiet:true
                
                -- 如果已点击清理修复，先执行清理和生成完美root
                if 已点击清理修复 do
                (
                    -- 清除half_body节点
                    清除half_body节点()
                    
                    -- 生成完美root
                    local 结果 = 规范根骨骼()
                    
                    if not 结果 do
                    (
                        append errorFiles (filenameFromPath filePath + " (清理修复失败)")
                        continue
                    )
                )
                
                -- 根据名称选择对象
                local exportObjects = #()
                for name in selectedNames do
                (
                    local obj = getNodeByName name
                    if obj != undefined do append exportObjects obj
                )
                
                if exportObjects.count == 0 then
                (
                    append errorFiles ("无选中对象: " + filenameFromPath filePath)
                    continue
                )
                
                select exportObjects
                
                -- 设置导出路径
                local fbxFile = exportFolder + "\\" + (getFilenameFile filePath) + ".fbx"
                
                -- 设置FBX导出选项 - 禁用平滑组
                FBXExporterSetParam "SmoothingGroups" false
                FBXExporterSetParam "NormalsPerPoly" false
                FBXExporterSetParam "Animation" true
                FBXExporterSetParam "BakeAnimation" true
                FBXExporterSetParam "UseSceneName" false
                FBXExporterSetParam "GeomAsBone" false
                FBXExporterSetParam "Cameras" false
                FBXExporterSetParam "Lights" false
                FBXExporterSetParam "Shape" false
                FBXExporterSetParam "Skin" true
                FBXExporterSetParam "AxisConversion" true
                FBXExporterSetParam "UpAxis" "Y"
                
                -- 导出FBX
                exportFile fbxFile #noPrompt selectedOnly:true using:FBXEXP
                
                successCount += 1
            )
            catch
            (
                format "导出文件 % 时出错: %\n" filePath (getCurrentException())
                append errorFiles (filenameFromPath filePath)
                pbProgress.color = red -- 出错时进度条变红
            )
            
            -- 处理事件队列，保持UI响应
            sleep 0.1
            windows.processPostedMessages()
        )
        
        -- 恢复原始场景
        if currentFile != "" do loadMaxFile currentFile
        
        -- 完成进度条
        pbProgress.value = 100
        pbProgress.color = green
        
        -- 显示结果
        resultMsg = "批量导出完成! "
        resultMsg += "成功: " + successCount as string + " 个文件, "
        resultMsg += "失败: " + (fileCount - successCount) as string + " 个文件"
        
        if errorFiles.count > 0 then
        (
            resultMsg += "\n失败文件: " + (errorFiles as string)
        )
        
        lblStatus.text = resultMsg
        messageBox resultMsg
    )
	
	-- 骨骼名称检测函数
	fn detectBoneNames =
	(
		-- 默认骨骼名称列表
		local defaultBones = #("root", "Bip001", "Bip001 Spine", "Bip001 L Thigh", "Bip001 R Thigh")
		local editBoxes = #(edtInput, edtInput2, edtInput3, edtInput4, edtInput5)
		local boneFound = false
		
		for i = 1 to defaultBones.count do
		(
			local boneName = defaultBones[i]
			local bone = getNodeByName boneName
			
			if bone != undefined then
			(
				editBoxes[i].text = boneName
				editBoxes[i].enabled = false  -- 灰化输入框
				boneFound = true
			)
			else
			(
				editBoxes[i].text = ""
				editBoxes[i].enabled = true  -- 保持可编辑
				editBoxes[i].tooltip = "未找到默认骨骼，请手动输入"
			)
		)
		
		return boneFound
	)
    
    -- 重新检测骨骼按钮
    on btnRedetect pressed do
    (
      detectBoneNames()
    )
	
	-- 面板控制逻辑
	fn 展开函数 判定ID =
	(
		if 判定ID == 1 then
		(
			yelangqiu.width = 160
			展开变量 = 0
			界面控制.text = "填写骨骼名称>>"
            grpStandard.visible = false
		)
		else
		(
			yelangqiu.width = 300
			展开变量 = 1
			界面控制.text = "<<对应骨骼名称"
            grpStandard.visible = false
		)
	)
	
	on 界面控制 pressed do  
	(
		展开函数 展开变量
	)
    
    -- 一键规范root按钮事件
    on btnStandardRoot pressed do
    (
		------------------------
		-- 确认提示
        local 确认结果 = queryBox "点击后会重置之前操作！\n确认继续执行吗？" title:"警告"
        if not 确认结果 do return false
		----------------------------
		
		
        -- 清除half_body节点
        清除half_body节点()
        
        -- 设置已点击清理修复标志
        已点击清理修复 = true
        
        -- 如果骨骼名称区域未展开，先展开
        if 展开变量 == 0 do
        (
            展开变量 = 1
            yelangqiu.width = 450  -- 同时显示骨骼名称区域和规范区域
            界面控制.text = "<<对应骨骼名称"
        )
        
        -- 显示规范区域
        grpStandard.visible = true
        
        -- 调整UI布局
        yelangqiu.width = 450
		
		-- 初始化规范工具
        spn角度.value = 全局_配置设置.root角度Y
        spnWidth.value = 全局_配置设置.rootWidth  -- 初始化宽度
        spnHeight.value = 全局_配置设置.rootHeight  -- 初始化高度
        
        -- 更新状态
        if (getNodeByName "root" exact:true) != undefined then
            lbl状态.text = "不要使用虚拟体root\n若是建议立即替换！"
		lblStatus.text = "挂点被清除,请重新生成"
    )
    
    -- 规范根骨骼工具事件处理
    on spn角度 changed val do
    (
        全局_配置设置.root角度Y = val
    )
    
    on btn执行 pressed do
    (
        
        
        -- 执行规范
        local 结果 = 规范根骨骼()
        
        -- 更新状态
        if 结果 then
        (
            lbl状态.text = "操作成功！\n已生成完美root骨骼"
        )
        else
        (
            lbl状态.text = "操作失败\n请检查错误日志"
        )
    )
    
    on btn重置 pressed do
    (
        全局_配置设置.root角度Y = 90
        spn角度.value = 90
        lbl状态.text = "角度设置重置为90度"
    )
	
	-- 在规范根骨骼工具事件处理中添加尺寸控件的事件处理
	on spnWidth changed val do
	(
		全局_配置设置.rootWidth = val
	)

	on spnHeight changed val do
	(
		全局_配置设置.rootHeight = val
	)
)

-- 创建对话框并立即执行骨骼名称检测
CreateDialog yelangqiu
if (yelangqiu.detectBoneNames()) then
(
    yelangqiu.lblStatus.text = "已找到默认骨骼并锁定"
)
else
(
    yelangqiu.lblStatus.text = "未找到默认骨骼请填写"
)