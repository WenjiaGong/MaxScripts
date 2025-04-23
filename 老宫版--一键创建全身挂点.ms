-- 定义Root函数
fn CreateRoot =
(  
	try  
	(  
		-- 创建骨骼      
		startPos=[0,0,0]  
		endPos=[5,0,0]  
		b = boneSys.createBone startPos endPos [0,0,1]  
		b.width = 5  
		b.height = 5  
		b.taper = 90  
		b.sideFins = off  
		b.frontFin = off  
		b.backFin = off
        b.boneEnable=false		
		b.name = "Root"  
		 
		-- 将骨骼进行旋转      
		r = eulerangles 90 0 0  
		rotate b r  
		 
		-- 查找名为Bip001的骨骼      
		bip = getNodeByName "Bip001"  
		if bip != undefined do  
		(  
			-- 将新创建的骨骼链接到Bip001骨骼上      
			bip.parent = b  
			 
			-- 创建挂点      
			attachment = attach bip #Bone b  
			attachment.name = "Head_Attachment"  
		)  
	)  
	catch ()  
)


-- 定义Top函数
fn CreateTop =
(  
	try  
	(  
		-- 通过名称查找骨骼      
		head = getNodeByName "Bip001 Head"  
		 
		-- 如果找到骨骼，则获取其位置并创建辅助对象点      
		if head != undefined do  
		(  
			pos = head.transform.pos  
			 
			-- 创建辅助对象点      
			top = point name:"T_Top" wirecolor:red cross:true size:10  
			 
			-- 将获取到的位置赋值给辅助对象点      
			top.pos = pos  
			 
			-- 将该点的位置的 Z 坐标值增加 30      
			top.pos.z += 30  
			 
			-- 将新创建的骨骼链接到Bip001骨骼上      
			top.parent = head  
		)  
	)  
	catch ()  
)


-- 定义右手挂点函数
fn CreateRHand =
(  
	try  
	(  
		-- 通过名称查找骨骼      
		head = getNodeByName "Bip001 R Hand"  
		 
		-- 如果找到骨骼，则获取其位置并创建辅助对象点      
		if head != undefined do  
		(  
			-- 创建辅助对象点    
			top = point name:"T_RHand" wirecolor:red cross:true size:10  
			 
			rot = head.transform
			top.transform = rot  

			-- 将新创建的骨骼链接到Bip001骨骼上      
			top.parent = head  
		)  
	)  
	catch ()  
)


-- 定义左手挂点函数
fn CreateLHand =
(  
	try  
	(  
		-- 通过名称查找骨骼      
		head = getNodeByName "Bip001 L Hand"  
		 
		-- 如果找到骨骼，则获取其位置并创建辅助对象点      
		if head != undefined do  
		(  
			-- 创建辅助对象点    
			top = point name:"T_LHand" wirecolor:red cross:true size:10  
			 
			rot = head.transform
			top.transform = rot  

			-- 将新创建的骨骼链接到Bip001骨骼上      
			top.parent = head  
		)  
	)  
	catch ()  
)

-- 定义左手挂点函数
fn CreateSpine =
(  
	try  
	(  
		-- 通过名称查找骨骼      
		spine = getNodeByName "Bip001 Spine2"  
		 
		-- 如果找到骨骼，则获取其位置并创建辅助对象点      
		if spine != undefined do  
		(  
			-- 创建辅助对象点    
			top = point name:"T_Spine" wirecolor:red cross:true size:10  
			 
			rot = spine.transform
			top.transform = rot  

			-- 将新创建的骨骼链接到Bip001骨骼上      
			top.parent = spine  
		)  
	)  
	catch ()  
)


  
-- 创建Rollout窗口  
rollout test "创建挂点" width:140 height:200 -- 增加高度以适应更多控件  
(  
    -- 创建复选框  
    checkbox chkRoot "创建Root挂点" pos:[20, 30] width:120 checked:true
    checkbox chkTop "创建顶部挂点" pos:[20, 50] width:120 checked:true
    checkbox chkRHand "创建右手挂点" pos:[20, 70] width:120 checked:true
    checkbox chkLHand "创建左手挂点" pos:[20, 90] width:120 checked:true
	checkbox chkSpine "创建脊椎挂点" pos:[20, 110] width:120 checked:true
      
    -- 创建按钮  
    button btn1 "创建全部挂点" pos:[26, 150] width:90 height:24 align:#left  
      
    -- "btn1"按钮的"on pressed"事件  
    on btn1 pressed do  
    (  
        if chkRoot.state then CreateRoot() -- 如果复选框被选中，则调用函数  
        if chkTop.state then CreateTop()   -- 如果复选框被选中，则调用函数  
        if chkRHand.state then CreateRHand() -- 如果复选框被选中，则调用函数  
        if chkLHand.state then CreateLHand() -- 如果复选框被选中，则调用函数
		if chkSpine.state then CreateSpine() -- 如果复选框被选中，则调用函数
		  
    )  
)  
  
-- 显示Rollout窗口  
--test.open()
-- 显示Rollout窗口
createdialog test