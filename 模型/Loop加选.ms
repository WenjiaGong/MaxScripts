--cust_attrib = attributes "aLoop_attrib" attribID:#(1423709993, 1827259049)
(
	rollout aLoop "Min angle loop" category:1
	(
		local end1
		local end2
		local obj
		local tabSel = #{}
		local tabSelFirst = #{}

		button but "Loop" width:92
		spinner anglet "Angle threshold: " type:#float range:[0.0,180.0,20.0] width:122 pos:[32,33]
		
		on but pressed do
		(
			try
			(
				obj = $
				
				tabSel = #{}
				tabSelFirst = (polyop.getEdgeSelection obj) as array
				
				for rEdge in 1 to tabSelFirst.count do
				(
					local rootEdge = tabSelFirst[rEdge]
					local aEdge = rootEdge
					
					if (findItem tabSel rootEdge) == 0 then
					(
						tabSel += #{tabSelFirst[rEdge]}
						for kierunek in 1 to 2 do
						(
							local end_vi = (polyop.getEdgeVerts obj rootEdge)[1]
							if kierunek == 2 then end_vi = (polyop.getEdgeVerts obj rootEdge)[2]
							
							local start_vi = (polyop.getEdgeVerts obj rootEdge)[2]
							if kierunek == 2 then start_vi = (polyop.getEdgeVerts obj rootEdge)[1]
							
							local aWekt = normalize ((polyop.getVert obj end_vi) - (polyop.getVert obj start_vi))
							local jestEdge = true
							
							while jestEdge do
							(
								local vEdges =  (polyop.getEdgesUsingVert obj end_vi) as array
								
								local whichFirst = 1
								if vEdges[1] == aEdge then whichFirst = 2
									
								local bestEdge = vEdges[whichFirst]
								
								local bestEdgeVerts = polyop.getEdgeVerts obj bestEdge
								local bestNVert = bestEdgeVerts[1]
								if bestNVert == end_vi then bestNVert = bestEdgeVerts[2]
								local wektBestEdge = (polyop.getVert obj bestNVert) - (polyop.getVert obj end_vi)
								
								
								for ed in vEdges do
								(
									if ed != aEdge then
									(
										local edgeVerts = polyop.getEdgeVerts obj ed
										local nVert = edgeVerts[1]
										if nVert == end_vi then nVert = edgeVerts[2]
											
										local wektTMPEdge = (polyop.getVert obj nVert) - (polyop.getVert obj end_vi)
										local aDot = (dot (normalize aWekt) (normalize wektTMPEdge))
										
										if aDot > (dot (normalize aWekt) (normalize wektBestEdge)) then
										(
											bestEdge = ed
											bestEdgeVerts = polyop.getEdgeVerts obj bestEdge
											bestNVert = bestEdgeVerts[1]
											if bestNVert == end_vi then bestNVert = bestEdgeVerts[2]
											wektBestEdge = (polyop.getVert obj bestNVert) - (polyop.getVert obj end_vi)
										)
									)
								)
								
								local samDot = (dot (normalize aWekt) (normalize wektBestEdge))
								local kat = acos samDot
								--dodalem, bo zwracalo czasami -1.#IND
								if samDot >= 0.99999 then kat = 0.0
								if samDot <= -0.99999 then kat = 180.0

								if kat < anglet.value and (findItem tabSel bestEdge) == 0 then
								(
									tabSel += #{bestEdge}
									start_vi = end_vi
									end_vi = bestNVert
									aEdge = bestEdge
									aWekt = normalize ((polyop.getVert obj end_vi) - (polyop.getVert obj start_vi))
								)
								else jestEdge = false
								
								/*polyop.setEdgeSelection obj (tabSel+(tabSelFirst as bitarray))
								redrawViews()
								sleep 0.001*/
							)
							aEdge = rootEdge
						)
					)
				)
				polyop.setEdgeSelection obj tabSel
				completeRedraw()
			)
			catch(MessageBox "Something went wrong..." title:"Min angle loop")
		)
	)
	createdialog aLoop

)
fn classIDCompare a b =
(
	if (a[1] == b[1]) and (a[2] == b[2]) then return true else return false
)

fn callbackFn ev nd =
(
	--disableSceneredraw()
	for n in nd do
	(
		local obj = GetAnimByHandle n
		if (obj.baseObject as string == "Editable Poly") then
		(
			CustAttributes.add obj cust_attrib BaseObject:true
		)
		else
		(
			local cnt = CustAttributes.count obj
			for i in 1 to cnt do
			(
				local cA = CustAttributes.get $ i
				if (classIDCompare (cA.classid) (#(1423709993, 1827259049)) == TRUE) then
				(
					CustAttributes.delete obj i baseObject:true
					i = i-1
				)
			)
		)
	)
	--enableSceneredraw()
)

--callbackItem = NodeEventCallback delay:500 modelStructured:callbackFn