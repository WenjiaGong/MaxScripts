rollout tools "参考坐标系" width:162 height:385
(
	button 'btn14' "视图" pos:[18,35] width:126 height:35 align:#left
	button 'btn15' "局部" pos:[18,105] width:126 height:35 align:#left
	button 'btn16' "屏幕" pos:[18,175] width:126 height:35 align:#left
	button 'btn7' "全部" pos:[18,245] width:126 height:35 align:#left
	button 'btn8' "骨骼" pos:[18,315] width:126 height:35 align:#left
	label 'lbl1' "选择过滤：" pos:[8,222] width:90 height:16 align:#left
	label 'lbl2' "参考坐标系转换：" pos:[8,12] width:102 height:15 align:#left
	on btn14 pressed  do
		toolMode.coordsys #view
	on btn15 pressed  do
		toolMode.coordsys #local
	on btn16 pressed  do
		toolMode.coordsys #screen
	on btn7 pressed  do
		SetSelectFilter 1
	on btn8 pressed  do
		SetSelectFilter 8
)
createdialog tools