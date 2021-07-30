
(
	global rol_StretchSpline
	try(destroyDialog rol_StretchSpline)catch()
	rollout rol_StretchSpline "Stretch Spline"
	(
		radiobuttons rb_splineOrSegm "Stretch:" labels:#("Spline","Segments") pos:[5,5] default:1 columns:1
		radiobuttons rb_strechAxis "Along axis:" labels:#("X", "Y", "Z") pos:[95,5] default:3 columns:1
		checkBox chkbox_selStrechSpline "sel new spline" pos:[5,55] checked:true
		button btn_strech "Stretch Spline"
		
		function DrawStrechedSpline knots =
		(
			ss = SplineShape pos:[0,0,0]
			addNewSpline ss
			addKnot ss 1 #corner #line [0,0,0]
			for i = 1 to knots.count do
			(
				addKnot ss 1 #corner #line knots[i]
			)
			updateShape ss
			ss
		)
		function GetSegmentLength selSpline =
		(
			--	get selected segment for all splines
			local splineNum = numSplines selSpline
			local splSegmLengArr = #()
			if splineNum != 0 then
			(
				for s=1 to splineNum do
				(	
					--	get selected segments
					selSegm01 = getSegSelection selSpline s									
					for i in selSegm01 do
					(
						local lengthArray = #()
						local segmentArray = #()
						local segmentArray = getSegLengths selSpline s
						local segNum = numSegments selSpline s
						--	get the length for all segments
						for j = (segNum+1) to (segmentArray.count-1) do
						(
							append lengthArray segmentArray[j]
						)
						--	get curent segment length
						append splSegmLengArr lengthArray[i]
					)
				)
			)
			splSegmLengArr
		)		
		
		on btn_strech pressed do
		(
			local curSpline = $
			local firstKnot = undefined
			if (superClassOf curSpline) == Shape do
			(
				local arrSegLeng = #()
				if (classOf curSpline) == SplineShape then
				(
					if rb_splineOrSegm.state == 1 do
					(
						subobjectlevel = 2
						max select all
					)
					firstKnot = getKnotPoint curSpline 1 1
					arrSegLeng = GetSegmentLength curSpline
				)
				else
				(
					with redraw off
					(
						local selSplineOrig = curSpline					
						local selSpline = copy selSplineOrig
						convertToSplineShape selSpline
						select selSpline	
						max modify mode
						subobjectlevel = 2
						max select all
						firstKnot = getKnotPoint selSpline 1 1
						arrSegLeng = GetSegmentLength selSpline						
						delete selSpline
						select selSplineOrig
					)
					redrawViews()
				)
				local knotPoints = #()
				local cnt = 0									
				for p in arrSegLeng do
				(
					cnt += p
					case rb_strechAxis.state of
					(
						1: (append knotPoints [cnt,0,0])
						2: (append knotPoints [0,cnt,0])
						3: (append knotPoints [0,0,cnt])
					)					
				)
				strechedSpline = DrawStrechedSpline knotPoints
				strechedSpline.pos = firstKnot
				if chkbox_selStrechSpline.state == true do select strechedSpline
			)
		)
	)
	createdialog rol_StretchSpline width:150
)