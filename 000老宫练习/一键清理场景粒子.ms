rollout tools "一键清理场景粒子" width:240 height:100
(
	button 'btn3' "一键清理粒子" pos:[48,23] width:140 height:36 align:#left
	label 'lbl1' "by：老宫 QQ:738255988" pos:[55,71] width:136 height:16 align:#left
	on btn3 pressed  do
    (
		delete $'particle view *'
		delete $'粒子视图 *'
		Messagebox "清理完成        "
	)
	
)
createdialog tools