-------------------------------------------------------
-------------------AnimationTool-----------------------
------------------Time:2018-06-07----------------------
-------------------Author:乔磊-------------------------
------------------QQ:409856476-------------------------
---------------------- by Joe--------------------------
------------------QQ: 738746223------------------------
-------------------------------------------------------

rollout Skin_Check "SkinCheck"
(
	
	button Skin_Check "检查蒙皮" pos:[13,7] tooltip:"选择需要检查的蒙皮"align:#left
	button Batch_Remove "批量移除" pos:[89,7] tooltip:"请注意，此功能可批量移除所有蒙皮骨骼"align:#right
	edittext BoneNumber "蒙皮骨骼数:"
	
	listbox 'lbx1' "无权重骨骼：" tooltip:"双击或者右击选择删除"
	button Quick_Remove "全部移除" tooltip:"移除列表中所有无权重骨骼"
	
	
	global un_id =#() ---无权重的骨骼ID
	global Un_BoneName =#() --无权重骨骼名字
	global objSkin
	local skin_num = 0 ---蒙皮骨骼数
	progressBar QR_bar  color:blue--进度条

	
	hyperlink lbl_help "帮助" address:"https://www.cgjoy.com/forum.php?mod=viewthread&tid=211812&page=1&extra=#pid9898326" align:#center offset:[0,10]
	
	

	fn UnSkinBoneId obj_Skin bone_count =
	(
		
		skin_index=#{1.. bone_count} --骨骼蒙皮ID列表
		
		numSkinVerts = #{1..(skinOps.getNumberVertices obj_Skin)} --获取参与蒙皮的点
		
		global SkinBoneID = #()  --有权重骨骼ID集合
		
		for n=1 to numSkinVerts.count do
		(
			numBoneWeights = skinOps.getVertexWeightCount obj_Skin n    --每个点有几根骨骼影响
			
            for b=1 to numBoneWeights do
			(
				boneID       = skinOps.getVertexWeightBoneID obj_Skin n b  --获取第n个点参与的第b个骨骼的ID
				append SkinBoneID boneID
	
			)

		)
		SkinBoneID=makeUniqueArray SkinBoneID ----去除数组中重复的元素
		SkinBoneID = sort SkinBoneID  ----数组排序
		skin_index = skin_index as array    ----位数组转数组
		
		struct bone_weight  ---绑定骨骼ID和骨骼名
		(
			n_ame,
			index
		)

		
		un_id =#() -- 无权重骨骼ID
		/*
		for i = SkinBoneID.count to 1 by -1 do	 --- num_id - SkinBoneID
		(
			un_id = deleteitem num_id SkinBoneID[i]
		)
		un_id
		*/
		for i =1 to skin_index.count  do    ---skin_index - SkinBoneID
		(
			if (findItem SkinBoneID (skin_index[i])) == 0 do
			(
				tem_bone = bone_weight()
				tem_bone.n_ame = skinOps.GetBoneName objSkin skin_index[i] 1
				tem_bone.index = i
				append un_id tem_bone
			)
		)
	
	)
----------------------------------------------------------------------------------------------------------------------------

	fn ChangeBoneName obj_Skin a_array = ---转换ID骨骼名
	(
		
		Un_BoneName =#()
		/*
		for i=1 to a_array.count do
		(	
			append Un_BoneName (skinOps.GetBoneName obj_Skin a_array[i] 1)
		) 
		Un_BoneName
		*/
		for i =1 to a_array.count do
		(
			local a_string = a_array[i].n_ame
			append Un_BoneName a_string
		)
		
	)
	

	
	
----------------------------------------------------------------------------------------------------------------------------
	
	
	
	
	fn ShowBone  =   ---显示
	(
		lbx1.items=Un_BoneName
		
		
	)
----------------------------------------------------------------------------------------------------------------------------
	
	fn Get_NumberBones = ---检查
	(
		if selection.count == 1 then	
		(
			max modify mode
			global objSkin  = $.modifiers[#Skin]
			skinOps.RemoveZeroWeights objSkin
			skin_num = skinOps.GetNumberBones objSkin
			
			--UnId = UnSkinBoneId objSkin skin_num			
			UnSkinBoneId objSkin skin_num

			ChangeBoneName objSkin un_id
	
			ShowBone()

		)
		else
		(
			messageBox "选择单个模型 "
			Un_BoneName =#()
			ShowBone()
			
		)
			BoneNumber.text= skin_num as string
			skin_num = 0
	
		
	)
	
----------------------------------------------------------------------------------------------------------------------------	
	
	on Skin_Check pressed do
	(

		Get_NumberBones ()
	
	)
----------------------------------------------------------------------------------------------------------------------------	
	on Batch_Remove pressed do  ----批量删除
	(
		if selection.count == 1 then	
		(
			max modify mode
			objSkin  = $.modifiers[#Skin]
			skinOps.RemoveZeroWeights objSkin
			skinOps.multiRemove objSkin

		)
		else
		(
			messageBox "选择单个模型 "
		)

		Get_NumberBones ()
		

	)
----------------------------------------------------------------------------------------------------------------------------	
	
	on lbx1 selected nameIndex do  ---选择
	(

		local a_index = (un_id[lbx1.selection]).index  ---获取骨骼ID
		skinOps.SelectBone objSkin a_index     ----选取ID骨骼
		
		
		/*
		--sel_bone_name = (getNodeByName lbx1.items[nameIndex]).name
	
		for i=1 to  un_id.count do
		(
			tem_name = skinOps.GetBoneName objSkin un_id[i] 1
			if sel_bone_name == tem_name then
			(
				skinOps.SelectBone objSkin  un_id[i]
			)	
		)
	*/

	)
	
----------------------------------------------------------------------------------------------------------------------------	
	
	on lbx1 doubleClicked sel do  ---双击删除
	(
		local a_index = (un_id[lbx1.selection]).index

		skinOps.removebone objSkin a_index
		
		temp = lbx1.items

		deleteItem temp sel

		lbx1.items = temp
		
		Get_NumberBones ()

	)
	
----------------------------------------------------------------------------------------------------------------------------	
		

	on lbx1 rightClick sel do  ---右击删除
	(
		local a_index = (un_id[lbx1.selection]).index

		skinOps.removebone objSkin a_index
		
		temp = lbx1.items

		deleteItem temp sel

		lbx1.items = temp
		
		Get_NumberBones ()
	)
	
----------------------------------------------------------------------------------------------------------------------------	
	
	on Quick_Remove pressed do  ---快速移除
	(
		
		max modify mode
		
		for i =un_id.count to 1 by -1 do
		(
			local a_id = un_id[i].index
			modPanel.setCurrentObject objSkin ---选择蒙皮层
			skinOps.removebone objSkin a_id
			QR_bar.value = 100-100.*i/un_id.count
		)
		Get_NumberBones () 
		QR_bar.value = 0
		
	)

	
	
)
	createdialog  Skin_Check
	