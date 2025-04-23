try (destroydialog skin_tooll) catch()
rollout skin_tooll "蒙皮处理工具v1.1" width:168 height:130
(
	button btn1 "蒙皮合并" pos:[8,16] width:72 height:26 toolTip:"请在Tpose下使用:\r依次选择要被“要被合并的模型”和“主模型”" align:#left
	button btn2 "蒙皮分离" pos:[88,16] width:72 height:26 toolTip:"请在Tpose下使用:\r先进入模型编辑，选择要分离的模型元素" align:#left
	button btn3 "权重替换" pos:[47,52] width:72 height:26 toolTip:"请在Tpose下使用:\r依次选择：“用来替换的骨骼”，“要被替换的骨骼”，“模型”" align:#left
	button btn4 "V" pos:[125,55] width:22 height:22 toolTip:"选择影响的点"
	hyperLink lianjie "作者:子墨[z.ven]" address:"https://www.bilibili.com/video/av82906714" color:(color 7 254 254) hoverColor:(color 0 255 255) visitedColor:(color 7 254 254)  pos:[40,85] width:95 height:16 
	hyperLink lianjie2 "QQ交流群:330875128" address:"(右键点击复制群号)" color:(color 7 254 254) hoverColor:(color 0 255 255) visitedColor:(color 7 254 254)  pos:[33,102] width:110 height:16 

	progressbar progBar pos:[8,117] width:150 height:7 color:blue  
	
	fn attachh =(
				weight=#()
				combo1=#()		
				combo2=#()		
				combo3=#()		
				combo4=#()		
				combo5=#()		
				combo6=#()		
				effectbone_name=#()  
				effectbone_id=#()  
				weight=#()
				objects_array=#()
				skin1bone_name=#()
				skin2bone_name=#()
				addbone_name=#()
				skin2bone_name_f=#()
				skin2bone_systemid=#()
		
				objects_array=selection as array
		
				max modify mode 
				
				skin_1=objects_array[1].modifiers[#Skin]		
				skin_2=objects_array[2].modifiers[#Skin]
				
				modPanel.setCurrentObject skin_1
				skinOps.closeWeightTool skin_1
				vertex_count1=objects_array[1].vertices.count 
				for i=1 to vertex_count1 do(
					bone_count=skinOps.GetVertexWeightCount skin_1 i  
					for ii=1 to bone_count do(
					weight[ii]=skinOps.GetVertexWeight skin_1 i ii
					bone_SystemID=skinOps.GetVertexWeightBoneID skin_1 i ii
					effectbone_name[ii]=skinOps.GetBoneName  skin_1 bone_SystemID 0  
					)	
					combo2[i]=weight
					combo1[i]=effectbone_name
					weight=#() 		
					effectbone_name=#()  
				)
				progBar.value = 20
				skin1bone_count=skinops.getnumberbones skin_1  
				for i=1 to skin1bone_count do (
					skin1bone_name[i]=skinOps.GetBoneName  skin_1 i 0 
					)
				
				modPanel.setCurrentObject skin_2
				skinOps.closeWeightTool skin_2
				vertex_count2=objects_array[2].vertices.count 
				for i=1 to vertex_count2 do(
					bone_count=skinOps.GetVertexWeightCount skin_2 i  
					for ii=1 to bone_count do(
					weight[ii]=skinOps.GetVertexWeight skin_2 i ii 
					bone_SystemID=skinOps.GetVertexWeightBoneID skin_2 i ii 
					effectbone_name[ii]=skinOps.GetBoneName  skin_2 bone_SystemID 0  
					)	
					combo5[i]=weight
					combo4[i]=effectbone_name
					weight=#() 		
					effectbone_name=#()  
				)
				progBar.value = 30
				skin2bone_count=skinops.getnumberbones skin_2  
				for i=1 to skin2bone_count do (
					skin2bone_name[i]=skinOps.GetBoneName  skin_2 i 0 
					)
					
				for i=1 to skin1bone_count do (						
					a=finditem skin2bone_name skin1bone_name[i]
					if a==0 do (
						b=getNodeByName skin1bone_name[i]  
						append addbone_name b			
						)
					)
					
				for i=1 to addbone_name.count do(	
					skinOps.addBone skin_2 addbone_name[i] 1  
					)	
				if 	classof objects_array[2]==PolyMeshObject then (
				objects_array[2].EditablePoly.attach objects_array[1] objects_array[2]
				)else(
					attach objects_array[2] objects_array[1] 
				)

				skin2bone_count_f=skinops.getnumberbones skin_2  
						
				for i=1 to skin2bone_count_f do (
				skin2bone_systemid[i]=skinOps.GetBoneIDByListID skin_2 i  
				)

				for i=1 to skin2bone_count_f do (
					skin2bone_name_f[i]=skinOps.GetBoneName  skin_2 skin2bone_systemid[i] 1 
					)
					
				progBar.value = 40	

				for i=1 to vertex_count1 do(
					for ii=1 to combo1[i].count do (						
						a=finditem skin2bone_name_f combo1[i][ii]
						effectbone_id[ii]=skin2bone_systemid[a]
					)	
					combo3[i]=effectbone_id
					effectbone_id=#()
				)
				progBar.value = 50

				for i=1 to vertex_count2 do(
					for ii=1 to combo4[i].count do (						
						a=finditem skin2bone_name_f combo4[i][ii]
						effectbone_id[ii]=skin2bone_systemid[a]
					)	
					combo6[i]=effectbone_id
					effectbone_id=#()
				)
				progBar.value = 60
				modPanel.setCurrentObject skin_2
				skinOps.closeWeightTool skin_2
				
				for i=1 to vertex_count1 do(
				skinOps.ReplaceVertexWeights (skin_2) (vertex_count2+i) (combo3[i]) (combo2[i])    
				) 
				progBar.value = 80
				for i=1 to vertex_count2 do(
				skinOps.ReplaceVertexWeights (skin_2) (i) (combo6[i]) (combo5[i])    
				) 
				progBar.value = 100
				progBar.value = 0
				clearListener() 
		)
	on btn1 pressed do(
			if selection.count==2 and (classof selection[1]==PolyMeshObject or classof selection[1]==Editable_mesh or selection[1]==Editable_Poly) then(
				try(	
				attachh()
				)catch()	
			)else(
				MessageBox "请选择2个带蒙皮的模型"
			)
		)	
	fn detach =(		
		facelist=#() 
		effect_vertex=#() 
		effectbone_name=#() 
		bone_SystemID2=#()  
		combo1=#()		
		combo2=#()		
		combo3=#()		
		skinbone_name=#()  
		skinbone_name_id=#() 
		weight=#()
		skin2bone_systemid=#()  

		if classof selection[1]==PolyMeshObject or classof selection[1]==Editable_Poly then(
			facelist= polyop.getFaceSelection selection[1]	
			polyop.detachFaces selection[1] facelist asNode:false 
			facelist= polyop.getFaceSelection selection[1]
			for i in facelist do(
				a=polyop.getFaceVerts selection[1] i  
				for ii in a do(
				num=finditem effect_vertex ii
					if num==0 do(
						append  effect_vertex ii
						)
				)	
			)
		)else(
			facelist = getFaceSelection selection[1]
			meshop.detachFaces selection[1] facelist delete:true 
			update selection[1] 
			facelist = getFaceSelection selection[1]
			effect_vertex=(meshop.getVertsUsingFace selection[1] facelist)as array
			)
		progBar.value = 20
		sort effect_vertex 
		subobjectLevel = 0
		
		skin_1=selection[1].modifiers[#Skin]		
		modPanel.setCurrentObject skin_1	
		skinOps.closeWeightTool skin_1

		for i=1 to effect_vertex.count do(
			bone_count=skinOps.GetVertexWeightCount skin_1 effect_vertex[i] 
			for ii=1 to bone_count do(
			weight[ii]=skinOps.GetVertexWeight skin_1 effect_vertex[i] ii 
			bone_SystemID1=skinOps.GetVertexWeightBoneID skin_1 effect_vertex[i] ii
			effectbone_name[ii]=skinOps.GetBoneName  skin_1 bone_SystemID1 0 
					
				nub=finditem skinbone_name effectbone_name[ii]
				if nub==0 do(
					append  skinbone_name effectbone_name[ii]
				)  
			)	
			combo2[i]=weight
			combo1[i]=effectbone_name
			weight=#() 		
			effectbone_name=#()  			
		)
		progBar.value = 40
		sort skinbone_name 
		
		if classof selection[1]==PolyMeshObject or classof selection[1]==Editable_Poly then(
			polyop.detachFaces selection[1] facelist asNode:true name:"xx01"
			a=$xx01 
			a.name=uniquename "Object"
		)else(
			newMesh = meshop.detachFaces selection[1] facelist delete:true asMesh:true
			update selection[1] 
			a = Editable_mesh pos:selection[1].pos
			a.mesh = newMesh 
			update a 

			mater_name=selection[1].mat 
			mater_int=finditem meditmaterials mater_name
			a.material = meditMaterials[mater_int]
			a.wirecolor=selection[1].wirecolor
			)
		select a
		
		addmodifier selection[1] (skin())
		skin_2=selection[1].modifiers[#Skin]		
				
		for i=1 to skinbone_name.count do(
			b=getNodeByName skinbone_name[i] 
			append skinbone_name_id b			
		)
		progBar.value = 50
		for i in skinbone_name_id do(	
			skinOps.addBone skin_2 i 1  
		)	
			
		for i=1 to skinbone_name.count do (
			skin2bone_systemid[i]=skinOps.GetBoneIDByListID skin_2 i  
		)
		
		for i=1 to combo1.count do(
			for ii=1 to combo1[i].count do (						
				c=finditem skinbone_name combo1[i][ii]
				bone_SystemID2[ii]=skin2bone_systemid[c]
				)	
				combo3[i]=bone_SystemID2
				bone_SystemID2=#()
		)
		progBar.value = 70
		modPanel.setCurrentObject skin_2	
		skinOps.closeWeightTool skin_2
		for i=1 to combo1.count do(
			skinOps.ReplaceVertexWeights (skin_2) i (combo3[i]) (combo2[i])    
		) 
		progBar.value = 100
		progBar.value = 0
		clearListener() 
		)
	on btn2 pressed do(	
				if classof selection[1]==Editable_Poly  or classof selection[1]==Editable_mesh  or classof selection[1]==PolyMeshObject then(
					try(
					detach()
					)catch()						
					)else (
						messagebox "请先选择要分离的面"
					)
		)
	fn replacee=(
		skinbone_name=#() 
		skinbone_systemid=#() 
		effectbone_systemid=#()
		weight=#()	
		combo1=#()	
		combo2=#()  
		combo3=#()  
		vertex_id=#() 
		vertex_id2=#() 
		vertex_id3=#() 
		objects_array=#() 
		effectbone_name=#() 
		
		objects_array=selection as array
		skin_1=objects_array[3].modifiers[#Skin]
		max modify mode 
		
		modPanel.setCurrentObject skin_1
		skinOps.closeWeightTool skin_1
		skinbone_count=skinops.getnumberbones skin_1  
		for i=1 to skinbone_count do (
			skinbone_name[i]=skinOps.GetBoneName  skin_1 i 0 
			)
		progBar.value = 10			
			a=finditem skinbone_name objects_array[1].name
			if a==0 then (
				skinOps.addBone skin_1 objects_array[1] 1  
				)else()	
			vertex_count=objects_array[3].vertices.count 

			for i=1 to vertex_count do(
				bone_count=skinOps.GetVertexWeightCount skin_1 i  
				for ii=1 to bone_count do(
				weight[ii]=skinOps.GetVertexWeight skin_1 i ii 
				bone_SystemID=skinOps.GetVertexWeightBoneID skin_1 i ii 
				effectbone_name[ii]=skinOps.GetBoneName  skin_1 bone_SystemID 0  	
				)
				combo2[i]=weight
				combo1[i]=effectbone_name
				weight=#() 		
				effectbone_name=#()  
			)
		progBar.value = 70	
			skinbone_count=skinops.getnumberbones skin_1  
			for i=1 to skinbone_count do (
				skinbone_systemid[i]=skinOps.GetBoneIDByListID skin_1 i  
				)
		
			for i=1 to skinbone_count do (
				skinbone_name[i]=skinOps.GetBoneName  skin_1 skinbone_systemid[i] 0 
				)
							
			c=finditem skinbone_name objects_array[1].name
			replaceebone_systemid1=skinbone_systemid[c]
			c=finditem skinbone_name objects_array[2].name
			replaceebone_systemid2=skinbone_systemid[c]

			for i=1 to vertex_count do(
				for ii=1 to combo1[i].count do (						
					c=finditem skinbone_name combo1[i][ii]
					effectbone_systemid[ii]=skinbone_systemid[c]
					if skinbone_systemid[c]==replaceebone_systemid2 do(
						effectbone_systemid[ii]=replaceebone_systemid1
						)
					if skinbone_systemid[c]==replaceebone_systemid1 do(
						effectbone_systemid[ii]=replaceebone_systemid2
						)
					)	
					combo3[i]=effectbone_systemid
					effectbone_systemid=#()
			)
			progBar.value = 80		

			for i=1 to vertex_count do(
				skinOps.ReplaceVertexWeights (skin_1) (i) (combo3[i]) (combo2[i])   
				)
			progBar.value = 100
			progBar.value = 0
			clearListener() 
		)
	on btn3 pressed do(
		if selection.count==3 and (classof selection[3]==PolyMeshObject or classof selection[3]==Editable_mesh or classof selection[3]==Editable_Poly) then(
			try(
			replacee()
			)catch()
		)else(
			messagebox "依次选择：“用来替换的骨骼”，“要被替换的骨骼”，“模型”"
		)
	)
	fn SelectVerticess=(
		weight=#() 
		effectbone_name=#() 
		vertex_id=#()  
		
		bone_id=skinOps.GetSelectedBone selection[1].modifiers[#Skin]
		skin_1=selection[1].modifiers[#Skin]
		
		vertex_count=selection[1].vertices.count 
		for i=1 to vertex_count do(
			bone_count=skinOps.GetVertexWeightCount skin_1 i  
			for ii=1 to bone_count do(
			weight[ii]=skinOps.GetVertexWeight skin_1 i ii 
			bone_SystemID=skinOps.GetVertexWeightBoneID skin_1 i ii 	
				if bone_SystemID==bone_id do(
					append	vertex_id  i
					)
			progBar.value = 100*(i/vertex_count)
			)
			weight=#() 		
			effectbone_name=#()  	
		)
		
		skinOps.SelectVertices selection[1].modifiers[#Skin] vertex_id
		progBar.value = 0
		clearListener() 
		)
	on btn4 pressed do(
		if selection.count==1 and (classof selection[1]==PolyMeshObject or selection[1]==Editable_mesh or classof selection[3]==Editable_Poly ) then(
			try(
			SelectVerticess()
			)catch()
		)else(
			messagebox "请先进入蒙皮选择封套"
			)
	)
	on lianjie2 rightClick do(
	setClipBoardText "330875128"
	)
)

createDialog skin_tooll 
