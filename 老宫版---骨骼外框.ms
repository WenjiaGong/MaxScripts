rollout tools "骨骼/外框转换  by:老宫QQ738255988" width:162 height:127
(
	button 'btn1' "显示骨骼" pos:[26,21] width:107 height:31 align:#left
	button 'btn2' "显示外框" pos:[26,74] width:107 height:31 align:#left
	on btn1 pressed  do
		$.boxmode = off
	on btn2 pressed  do
		$.boxmode = on
)
createdialog tools