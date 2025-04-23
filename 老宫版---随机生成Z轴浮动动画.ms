rollout test "生成选中物体动画" width:140 height:60
(
     button 'btn1' "生成" pos:[26,18] width:90 height:24 align:#left
	 on btn1 pressed  do
	(
         animate on 
	     for i = 0 to 300 by 15 do 
		 at time i 
		 (
			 for k in $ do
			 (
				if k.pos[3]<20 then move k [0,0,(random 0 20)]
				else if k.pos[3]>20 then move k [0,0,(random -20 0)] 
				else move k [0,0,(random 0 10)]
				
			 )
		 )
	)
)
createdialog test