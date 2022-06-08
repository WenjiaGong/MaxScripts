rollout test "一键创建挂点" width:140 height:60
(
	button 'btn1' "创建" pos:[26,18] width:90 height:24 align:#left
	on btn1 pressed  do
		(
				
		----------创建bone骨骼----------	
		startPos=[0,0,0]                                         
		endPos=[10,0,0]                                           
		b = boneSys.createBone startPos endPos [0,0,1]         
		b.width = 10
		b.height = 10
		b.taper = 90
		b.sideFins = off
		b.frontFin = off
		b.backFin = off
		b.name = "Root"
		
		---------将骨骼进行旋转----------
		r = eulerangles 90 0 0
		rotate b r	
			
		)
)
createdialog test