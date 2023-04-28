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
		b.taper = 0  
		b.sideFins = off  
		b.frontFin = off  
		b.backFin = off  
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
			top = point name:"top" wirecolor:red cross:true size:10  
			 
			-- 将获取到的位置赋值给辅助对象点      
			top.pos = pos  
			 
			-- 将该点的位置的 Z 坐标值增加 30      
			top.pos.z += 15  
			 
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
			top = point name:"top" wirecolor:red cross:true size:10  
			 
			rot = head.transform.rotation  
			top.rotation = rot  
			
			--pos = head.transform.pos      
			--top.pos = pos     
			 
			
			-- 将新创建的骨骼链接到Bip001骨骼上      
			top.parent = head  
		)  
	)  
	catch ()  
)



















-- 创建Rollout窗口
rollout test "创建挂点" width:140 height:90
(  
	-- 创建按钮      
	button 'btn1' "创建全部挂点" pos:  [26,18] width:90 height:24 align:#left  
	 
	-- "btn1"按钮的"on pressed"事件      
	on btn1 pressed do  
	(  
		CreateRoot()  -- 调用函数CreateRoot创建骨骼和挂点     
		 
		CreateTop()  -- 调用函数CreateTop创建辅助对象点     

		CreateRHand()   
	)  





	-- 创建 "Top" 按钮     
	button 'btn2' "Top" pos:  [26,48] width:90 height:24 align:#left  
	 
	-- "btn2"按钮的"on pressed"事件     
	on btn2 pressed do  
	(  
		CreateRHand()   
	)





)

-- 显示Rollout窗口
createdialog test