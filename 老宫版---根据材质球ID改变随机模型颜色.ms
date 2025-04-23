rollout test "改变选中物体颜色" width:140 height:60
(
    button 'btn1' "改变" pos:[26,18] width:90 height:24 align:#left
	on btn1 pressed  do
		 (
         for a in $ do a.material = meditMaterials[(random 1 6)]                     ---此处需要配置材质球颜色
		 )
)
createdialog test