rollout test "方块随机浮动练习" width:480 height:300
(
	button 'btn1' "开始浮动" pos:[120,100] width:252 height:87 align:#left
	on btn1 pressed  do
	for a = 0 to 300 by 15 do
		animate on
			at time a
			(
				
				for b in $box* do
	           (
					if b.pos [3]<100 then move b [0,0,random 20 80]
						else if b.pos [3]>100 then move b [0,0,random -80 -20]
							else move b [0,0,random 20 80]
		
			
	            )
			)
)
createdialog test