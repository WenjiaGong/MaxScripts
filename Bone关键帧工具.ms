Global Rt_Ht=115
rollout Tools01 "Bone插件" width:225 height:207
(

	button Sel_BN "全选Bone" pos:[15,10] width:90 height:20
	button DEL01_BN "删除位移" pos:[120,10] width:90 height:20
	button DEL02_BN "删除旋转" pos:[15,36] width:90 height:20
	button DEL03_BN "删除缩放" pos:[120,36] width:90 height:20
	
	on Sel_Bn pressed do
	(
		Bn_All=for i in objects where (classof i==BoneGeometry) collect i
		select Bn_All
	)
	
	on DEL01_BN pressed do
	(
	    for b in selection do deleteKeys b.pos.controller 
	 )
	
	on DEL02_BN pressed do
	(
	    for b in selection do deleteKeys b.rotation.controller 
	 )
	
	on DEL03_BN pressed do
	(
	    for b in selection do deleteKeys b.scale.controller 
	)
        
	button ha "Version 1.0" pos:[65,65] width:102 height:17
	on ha pressed do
				(
					messagebox "---.com---"
				)
	
)
--createdialog Tools01
Rig_Tl=newrolloutfloater "Bones Keys" 256 Rt_Ht 
addrollout Tools01 Rig_Tl