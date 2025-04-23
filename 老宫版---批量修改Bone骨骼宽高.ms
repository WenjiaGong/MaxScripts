rollout test "批量修改Bone骨骼宽高，尺寸进代码修改" width:140 height:60
(
    button 'btn1' "改变" pos:[26,18] width:90 height:24 align:#left
	on btn1 pressed  do
		 (
         $.width = 15    --手动修改此处数值
         $.height = 15   --手动修改此处数值
		 )
)
createdialog test