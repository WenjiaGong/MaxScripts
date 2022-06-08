rollout tools "参考坐标系" width:162 height:251
(
	button 'btn14' "视图" pos:[18,35] width:126 height:35 align:#left
	button 'btn15' "局部" pos:[18,105] width:126 height:35 align:#left
	button 'btn16' "屏幕" pos:[19,175] width:126 height:35 align:#left
	on btn14 pressed  do
		toolMode.coordsys #view
	on btn15 pressed  do
		toolMode.coordsys #local
	on btn16 pressed  do
		toolMode.coordsys #screen
)
createdialog tools