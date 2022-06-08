try destroyDialog Roll_CreateBone	catch()



Rollout	Roll_CreateBone	""
(
	--Filter
	fn Hpr_filt	obj	= superclassof obj == helper
	
	checkbutton	btn_Create		"Create!!" width:90 height:35	offset:[0,3]
	checkbox			chk_Filter		"Use Filter"	align:#center	checked:true
	Group""(
	radiobuttons	rdo_Upnode	"Upnode"	labels:#("World", "Parent")	default:2
	spinner			spn_size			"Size"		range:[0.01,50,1]	width:70
	)
	
	on	btn_Create	changed	true	do(
		max select none
		if chk_Filter.state then (
			Start		=	pickObject filter:Hpr_filt)
		else (
			Start		=	pickObject())
		Repeat	=	true
		while	Repeat	do
		(
			try
			(
				if chk_Filter.state then (
					End		=	pickObject	rubberBand:Start.transform.pos filter:Hpr_filt)
				else (
					End		=	pickObject	rubberBand:Start.transform.pos )
				TempBone	=	BoneSys.createBone		Start.transform.pos	End.transform.pos	[0,0,1]
				TempBone.position.controller = Position_Constraint()
				TempBone.position.controller.AppendTarget	Start	50
				TempBone.rotation.controller =  LookAt_Constraint()
				TempBone.rotation.controller.appendTarget	End 50
				TempBone.rotation.controller.lookat_vector_length = 0
				TempBone.rotation.controller.StoUP_axis = 1
				TempBone.width		= spn_size.value
				TempBone.height	= spn_size.value
				
				if	rdo_Upnode.state	==	2	then
				(
				TempBone.rotation.controller.pickUpNode = Start
				TempBone.rotation.controller.upnode_world = false
				TempBone.boneFreezeLength	= false
				)
				
				if	ParentBone	!=	undefined	then (TempBone.parent	=	ParentBone)
				ParentBone	=	TempBone
			)
			catch	
			(
				if	ParentBone	!=	undefined	then
				(
					EndBone	=	BoneSys.createBone	Start.transform.pos	Start.transform.pos	[0,0,1]
					EndBone.position.controller = Position_Constraint()
					EndBone.position.controller.AppendTarget	Start	50
					EndBone.parent	=	ParentBone
					in coordsys parent EndBone.rotation	=	(quat 0 0 0 0)
					EndBone.width	= spn_size.value
					EndBone.height	= spn_size.value
					EndBone.length	= spn_size.value
				)
				Repeat	=	false
			)
			Start		=	End
		)
		btn_Create.checked	=	false
	)

)


createDialog	Roll_CreateBone	150 150