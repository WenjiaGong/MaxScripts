
try(destroydialog Poly_push) catch()
rollout Poly_push "Poly_Push 3d狼设计网"
(
	spinner spi_1 "Distance:" fieldwidth:50 range:[-100000,100000,0] type:#worldunits  across:2  Offset:[40,0]
	button btn_ok  "OK" width:20 height:18  Offset:[25,-2]
	checkbutton ckbtn_1  "手动Push" width:130 
	
local RappaTools_Push,mouseStart,vertIDs,vertWeights,vertLocs,vertNormals
	
fn AppPosNom = (	
	if (polyop.getVDataChannelSupport $ 1 == true) then (
		--vertIDs = for i in 1 to $.numverts where (polyop.getVdataValue $ 1 i != 0) collect i
		vertIDs = for i in 1 to polyop.getNumVerts $ where (polyop.getVdataValue $ 1 i != 0) collect i
		vertWeights = for i in vertIDs collect (polyop.getVdataValue $ 1 i) 
	) else (
		vertIDs = (polyop.getVertSelection $) as array
		vertWeights = for i in vertIDs collect 1
	)
	vertLocs = for i in vertIDs collect polyop.getVert $ i
	vertNormals = #()
	for i in vertIDs do (
		vertFaces = (polyop.getFacesUsingVert $ i) as array
		faceNormals = for j in vertFaces collect (polyop.getfaceNormal $ j)
		sumNormals = [0,0,0]
		for j in faceNormals do sumNormals += j
		append vertNormals (normalize (sumNormals/faceNormals.count))
	)
)	
fn Pushfunc = (
	tool RappaTools_Push (
		on start do AppPosNom()
		on mousePoint clicks do (
			case clicks of (
				1: (mouseStart = viewPoint)
				2: (#stop)
				default: (#stop)
			)
		)
		on mousemove clicks do (
			disablesceneredraw ()
			for i in 1 to vertIDs.count do (
				if not keyboard.controlpressed then (
					polyop.setvert $ vertIDs[i] (VertLocs[i] + (viewPoint.x - mouseStart.x)/1 * vertNormals[i] * (pow VertWeights[i] (1 + (viewPoint.y - mouseStart.y)/1) ))
					spi_1.value = (viewPoint.x - mouseStart.x)
				) else (
					polyop.setvert $ vertIDs[i] (VertLocs[i] + (viewPoint.x - mouseStart.x)/.05 * vertNormals[i] * (pow VertWeights[i] (1 + (viewPoint.y - mouseStart.y)/.5) ))
					spi_1.value = (viewPoint.x - mouseStart.x)/.05
				)
			)
			enablesceneredraw ()
			update $
		)
		on stop do ckbtn_1.checked = false
	)
)
on btn_ok pressed do undo on (
	if classOf $ == Editable_Poly then	(
		if (subobjectLevel == 4 or subobjectLevel == 5) and (((polyop.getFaceSelection $)as array).count > 0) then (
			$.ConvertSelection #Face #Vertex
		)
		if (subobjectLevel == 2 or subobjectLevel == 3) and (((polyop.getEdgeSelection $)as array).count > 0) then (
			$.ConvertSelection #Edge #Vertex
		)	
		if (((polyop.getVertSelection $)as array).count > 0) then(
			AppPosNom();val = spi_1.value
			for i in 1 to vertIDs.count do (
				polyop.setvert $ vertIDs[i] (VertLocs[i] + val/1 * vertNormals[i])
				update $
			)
		)		
	)
)
on ckbtn_1 changed state do undo on (
	if classOf $ == Editable_Poly then	(
		if (subobjectLevel == 4 or subobjectLevel == 5) and (((polyop.getFaceSelection $)as array).count > 0) then (
			$.ConvertSelection #Face #Vertex
		)
		if (subobjectLevel == 2 or subobjectLevel == 3) and (((polyop.getEdgeSelection $)as array).count > 0) then (
			$.ConvertSelection #Edge #Vertex
		)	
		if (((polyop.getVertSelection $)as array).count > 0) then (Pushfunc() ; starttool RappaTools_Push)
	)
)

)
createDialog Poly_push 170 55 

