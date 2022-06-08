rollout objectschecker "ObjectsChecker" 
(
	fn GetVectorsAngle v_1 v_2 = 
	(
	theAngle = acos(dot (normalize v_1) (normalize v_2))
	)
	--检查点
	GroupBox ocgv "Vertex" pos:[6,5] width:150 height:108
	label lblocvr "开放边阈值" pos:[15,22] width:75 height:18
	spinner spnocvr "" pos:[80,21] width:50 height:16 range:[0,180,180] type:#float
	label lblocvd "度" pos:[135,22] width:15 height:18
	button btnocvr "移除废点" pos:[10,40] width:142 height:23 toolTip:"移除物体上孤立点和无用点"
	label lblocvc "选中大于" pos:[15,68] width:60 height:18
	spinner spnocvc "" pos:[65,67] width:34 height:16 range:[0,99,6] type:#integer
	label lblocvn "条边的点" pos:[102,68] width:50 height:18
	button btnocvc "检查多边点" pos:[10,86] width:142 height:23 toolTip:"选中拥有超过规定边数的点"
	--检查面
	GroupBox pigp "Face" pos:[6,115] width:150 height:62 
	label lblocfc "选中大于" pos:[15,132] width:60 height:18
	spinner spnocfc "" pos:[65,131] width:34 height:16 range:[0,99,4] type:#integer
	label lblocfn "个点的面" pos:[102,132] width:50 height:18
	button btnocfc "检查多点面" pos:[10,150] width:142 height:23 toolTip:"选中拥有超过规定顶点数的面"
	label lbl10 "=========================" pos:[5,175] width:206 height:30
	label lbl11 "版本: ObjectsChecker v1.0\n版权: 艾雨 (QQ:109668208)" pos:[10,190] width:206 height:30
	label lbl12 "本插件仅供个人学习使用\n不得用于商业用途！" pos:[10,217] width:260 height:30

	--检查点
	on btnocvr pressed do 
	(
		selarray=selection as array
		if selarray.count==0 
		then messagebox "请选择物体！" title:"温馨提示"
		else 
		(
			for i=1 to selarray.count do
			(
				wrvarray=#()
				x=selarray[i]
				--移除孤立点
				x.EditablePoly.deleteIsoVerts ()
				--移除同属于两条边并且同属于两个面的废点
				for j = 1 to x.GetNumVertices() do 
				(
					x.EditablePoly.SetSelection #Vertex #{j}
					vbarray=x.EditablePoly.getSelection #Vertex
					varray=vbarray as array
					if ((x.GetVertexEdgeCount j)==2 and (x.GetVertexFaceCount j)==2)
					then append wrvarray varray[1]
				)
				x.EditablePoly.SetSelection #Vertex (wrvarray as bitarray)
				x.EditablePoly.Remove selLevel:#Vertex
				--移除开放边上的废点
				wvarray=#()
				for k=1 to x.GetNumVertices() do 
				(	
					x.EditablePoly.SetSelection #Vertex #{}
					if ((x.GetVertexEdgeCount k)==2 and (x.GetVertexFaceCount k)==1) then
					(
						x.EditablePoly.SetSelection #Vertex #{k}
						x.EditablePoly.ConvertSelection #Vertex #Edge
						eb=x.EditablePoly.getSelection #Edge
						ea=eb as array
						es=#()
						append es ea[1]
						x.EditablePoly.SetSelection #Edge (es as bitarray)
						x.EditablePoly.ConvertSelection #Edge #Vertex
						vb=x.EditablePoly.getSelection #Vertex
						va=vb as array
						if va[1]==k
						then v1=(x.getvertex va[2])-(x.getvertex k)
						else v1=(x.getvertex va[1])-(x.getvertex k)
						
						es=#()
						va=#()
						append es ea[2]
						x.EditablePoly.SetSelection #Edge (es as bitarray)
						x.EditablePoly.ConvertSelection #Edge #Vertex
						vb=x.EditablePoly.getSelection #Vertex
						va=vb as array
						if va[1]==k
						then v2=(x.getvertex va[2])-(x.getvertex k)
						else v2=(x.getvertex va[1])-(x.getvertex k)
						
						ang=GetVectorsAngle v1 v2
						if ang>=spnocvr.value
						then append wvarray k
					)
				)
				x.EditablePoly.SetSelection #Vertex (wvarray as bitarray)
				x.EditablePoly.Remove selLevel:#Vertex
			)
		)
	)
	on btnocvc pressed do
	(
		selarray=selection as array
		if selarray.count==0 
		then messagebox "请选择物体！" title:"温馨提示"
		else 
		(
			for i=1 to selarray.count do
			(
				wrvarray=#()
				x=selarray[i]
				--选中拥有超过规定边数的点
				for k = 1 to x.GetNumVertices() do 
				(
					x.EditablePoly.SetSelection #Vertex #{k}
					vbarray=x.EditablePoly.getSelection #Vertex
					varray=vbarray as array
					if ((x.GetVertexEdgeCount k)>=(spnocvc.value+1))
					then append wrvarray varray[1]
				)
				x.EditablePoly.SetSelection #Vertex (wrvarray as bitarray)
			)
		)
	)
	on btnocfc pressed do
	(
		selarray=selection as array
		if selarray.count==0 
		then messagebox "请选择物体！" title:"温馨提示"
		else 
		(
			for i=1 to selarray.count do
			(
				wrfarray=#()
				x=selarray[i]
				--选中大于规定顶点的面
				for i = 1 to x.GetNumFaces() do
				(
					x.EditablePoly.SetSelection #Face #{i}
					fbarray=x.EditablePoly.getSelection #Face 
					x.EditablePoly.ConvertSelection #Face #Vertex
					vbarray=x.EditablePoly.getSelection #Vertex
					x.EditablePoly.SetSelection #Vertex #{}
					varray=vbarray as array
					farray=fbarray as array
					if varray.count>spnocfc.value
					then append wrfarray farray[1]
				)
				x.EditablePoly.SetSelection #Face (wrfarray as bitarray)
			)
		)
	)
)
createdialog objectschecker