Global Rt_Ht=115
rollout Tools01 "选择插件" width:225 height:207
(

	button Sel_Bip "全选Biped" pos:[15,10] width:90 height:20
	button Sel_Bone "全选Bone" pos:[120,10] width:90 height:20
	button Sel_BoneBip "全选骨骼" pos:[15,36] width:90 height:20
	--button DEL03_BN "删除缩放" pos:[120,36] width:90 height:20
	
	on Sel_BIP pressed do
	(
		Bip_All=for i in objects where (classof i==Biped_Object) collect i
		select Bip_All
	 )
	
	on Sel_Bone pressed do
	(
		Bone_All=for i in objects where (classof i==BoneGeometry) collect i
		select Bone_All
	)
	
		
	on Sel_BoneBip pressed do
	(
		BoneBip_All=for i in objects where (classof i==Biped_Object or classof i==BoneGeometry) collect i
		select BoneBip_All
	 )
	
	on DEL03_BN pressed do
	(
	    for b in selection do deleteKeys b.scale.controller 
	)
        
	
	
)
--createdialog Tools01
Rig_Tl=newrolloutfloater "选择插件" 256 Rt_Ht 
addrollout Tools01 Rig_Tl