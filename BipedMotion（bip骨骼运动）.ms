
global bipmotion_roll
try ( destroydialog bipmotion_roll ) catch()
rollout bipmotion_roll "  Biped Motion"
(
	group "Copy"
	(
		checkbox collapsemotion_c "Collapse Bip Offset" checked:on align:#center -- across:2
        --button copy_it "OK" width:100 height:27 offset:[0,10]
        button copy_it "COPY" width:100 height:27 offset:[0,10] tooltip:"Copy bip animation"
	)
	group "Paste"
	(
		radiobuttons type_o "Offset Position :" labels:#("None", "Keep") offset:[-10,0]
		--checkbox collapsemotion_p "Collapse Bip Offset" align:#center --offset:[50,0]
		radiobuttons type_p "Motion Type :" labels:#("Replace", "Merge") offset:[0,17]
        button paste_it "PASTE" width:100 height:27 offset:[0,10] tooltip:"Paste bip animation"
		--checkbutton mrg_btn "v" width:25 height:27 offset:[75,-32] tooltip:"Merge Option"
	)
	group "Merge Option :"
	(
		checkbox timeslide "Time Slider as Start Point" align:#left checked:false enabled:false offset:[10,5]
		checkbox motiontrans "Motion Transition" align:#left checked:true enabled:false offset:[10,5]
		spinner transfr "Transition Frame : " type:#integer range:[1,20,5] align:#right enabled:false fieldwidth:43 offset:[-12,0]
		label fcslab "Focus :" across:2 align:#left offset:[17,5] enabled:false
		dropdownlist focus_dd "" width:105 height:20 align:#right offset:[-10,0] enabled:false items:#("Auto (Both Feet)","Center of Mass","Left Foot","Right Foot","Both Feet") -- default: "Auto (Both Feet)"
		spinner zrot "Angle : " type:#float range:[-360.0,360.0,0.0] align:#right enabled:false fieldwidth:43 offset:[-12,0]
		checkbox EnforceIK "Enforce Ik Constraints" align:#left checked:true enabled:false offset:[10,0]
		spinner conrange "Continuity Range :" type:#integer range:[0,100,6] align:#right enabled:false fieldwidth:43 offset:[-12,0]		
        --button paste_it "OK" width:100 height:27 offset:[0,10]		
	)
        button reset_btn "Reset" width:60 height:20 offset:[0,0] tooltip:"Reset Merge Option Setting" across:2 border:false--align:#left 
		button note_btn "About" width:60 height:20 offset:[0,0] tooltip:"About" border:false--align:#right
	
        --button reset_btn "R" width:28 height:18 offset:[0,0] tooltip:"Reset Merge Option Setting" across:2 --align:#left 
		--button note_btn "?" width:28 height:18 offset:[0,0] tooltip:"About" --align:#right
fn about_copasbipmotion =
(
		outside_string = "INFO :\n"
        outside_string += "Quick copy and paste Biped animation to another biped from one instance of \n"
        outside_string += "max and paste them into another.\n\n"
        outside_string += "USAGE :\n"
        outside_string += "Select the biped object, Click 'Copy' button...\n"
        outside_string += "then run the 'Paste' button into either the same file or you can load another \n"
        outside_string += "instance of max and 'paste' animation bip into another biped.\n\n"
	
		outside_string += "Copy/Paste Biped Animation V2.0\n"
		outside_string += "Written By Budi Gunawan ( 2D/3D CG Artist )\n"
        outside_string += "Start : Oct 2009.\n"
        outside_string += "Last Updated : 06\17\2011.\n"
		outside_string += "Rebuild in 3dsmax 2011\n\n"
		--outside_string += "but it should be running in max 7 and above (32 and 64 bit) Supported.\n\n"	
		outside_string += "hellocomred@gmail.com\n"		
		messagebox outside_string title: " NOTES : Copy / Paste Biped Animation" beep:off
)
	fn reset_merge_buttons = 
	(
			timeslide.checked = off
		
            motiontrans.checked = on
			transfr.enabled = not timeslide.checked
		    transfr.value = 5
			focus_dd.selection = 1 -- "Auto (Both Feet)"
			zrot.value = 0.0
			
            EnforceIK.checked = on
            conrange.value = 6
	) -- fn
on reset_btn pressed do reset_merge_buttons()
on note_btn pressed do about_copasbipmotion()
	
  fn copy_bip_motion_option allbips thestate =
  (
	  local Collapsebip = false
            mybip = (biped.getNode allbips[1] 13 )
			bipcopypastedir = getdir #autoback
	        bipcopypastefile = "\pasteBIPfile.bip"
	        bipcopypastestring = bipcopypastedir + bipcopypastefile
           if thestate == true then
		   ( 
			   actionMan.executeAction 972555510 "40133"  -- Biped: Move All - Collapse
               Collapsebip = true			   
		   ) else ()

		        undo off ( biped.SaveBipFile mybip.controller bipcopypastestring )
		        if Collapsebip == true then (max undo) else ()	-- back to undo the collapse
	            format "Save Bip File ... Done.\n"
  ) ---  End Execute
  fn poin_bip_pos mybip allbips bipcopypastestring state =
  (
	  
		    bipfootstep = ( biped.getNode allbips[1] 16 ) --i.transform.controller.footstepmode = true (append 16 #footprints Footsteps)
            bfoot = bipfootstep.transform
            ------------------------------------------------------------------------------------------------------
	               slidertime = animationrange.start
					undo "Paste Motion" on
					(
			          actionMan.executeAction 972555510 "40133"-- Biped: Move All - Collapse Initial
		              biped.LoadBipFile mybip.controller bipcopypastestring
					)
            ------------------------------------------------------------------------------------------------------
	        undo off 
	        (
              ptBIP = Point centermarker:off axistripod:off cross:on Box:on constantscreensize:off drawontop:off size:10 \
              pos:(bipfootstep.center) name:("POINT_Bip_Temp") wirecolor:red --isSelected:off
			  mybip.parent = ptBIP -- link
              ptBIP.transform = bfoot -- move
              delete ptBIP -- delete point
		      if state == true then ( actionMan.executeAction 972555510 "40133" )  else ()-- Biped: Move All - Collapse
		    )
  )
  
  fn paste_bip_motion allbips index state indexmerge =
    (  
      mybip = (biped.getNode allbips[1] 13 )
	  max motion mode
	  if mybip.controller.figureMode == true then ( messageBox "Please Exit Figure Mode." title:"Copy/Paste Bip Animation v0.1" )
	    else (
		 	     bipcopypastedir = getdir #autoback
	             bipcopypastefile = "\pasteBIPfile.bip"
	             bipcopypastestring = bipcopypastedir + bipcopypastefile
		         disablesceneredraw()
			    if index == 1 then
				------------------------------------------------------
				( 
		           slidertime = animationrange.start
					undo "Paste Motion" on
					(
				      actionMan.executeAction 972555510 "40133"-- Biped: Move All - Collapse Initial
		              biped.LoadBipFile mybip.controller bipcopypastestring
					  --if state == true then ( actionMan.executeAction 972555510 "40133" )  else ()-- Biped: Move All - Collapse
					)
				)
				else
		        ( poin_bip_pos mybip allbips bipcopypastestring state )
                ------------------------------------------------------
		         enablesceneredraw()
		         max views redraw
			     format "Load Bip File ... Done.\n"
		       ) -- else
	) ---  End Execute
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn item_focus state =
	(
		--Continuity_focus = #(#focusAuto, #focusCom, #focusLftFoot, #focusRgtFoot, #focusBthFeet)
		case state of
		(
			1:#focusAuto
			2:#focusCom
			3:#focusLftFoot
			4:#focusRgtFoot
			5:#focusBthFeet
		)
	)
	fn enabled_buttons state = 
	(
		local bool
		--if state == 1 then bool = true else bool = false
		case state of
		(
		   1:( bool = true ; bipmotion_roll.height=248 )
		   2:( bool = false ; bipmotion_roll.height=455 ) --435
		)	
		
			type_o.enabled = bool
            ------------------------------
			fcslab.enabled = not bool
            motiontrans.enabled = not bool
			timeslide.enabled = not bool
		    transfr.enabled = not bool
			focus_dd.enabled = not bool
			zrot.enabled = not bool
            EnforceIK.enabled = not bool
            conrange.enabled = not bool
	) -- fn
	fn delete_filemixer clip_string mixer_string =
	(
		deleteFile clip_string -- "CopypasteBIPfileClip.bip"
		deleteFile mixer_string -- "\CopypasteBIPfileMixer.bip"
	)
	-----------------------------------------------------------------------
fn merge_bip_motion allbips keep timeslider_destination transision TheFocus Zangle EnforceIkConst ContRange transfr_value=
( -- fn merge_bip_motion
	xbip = #()
    xbip = for i in allbips collect i.name
	local state = true
	 format "Please wait..!\n"
	
    mybip = (biped.getNode allbips[1] 13 )
    bipcont = mybip.transform.controller
    bipmix = bipcont.mixer
	-------------------------------------------------------------------------------------------------
			bipcopypastedir = getdir #autoback
	
	        bipcopypastefileini = "\CopypasteBIPfile.ini"
	        bipcopypasteinistring = bipcopypastedir + bipcopypastefileini
	
	        bipcopypastefilemixer = "\CopypasteBIPfileMixer.bip"
	        bipcopypastemixerstring = bipcopypastedir + bipcopypastefilemixer

	        bipcopypastefilemix = "\CopypasteBIPfileClip.bip"
	        bipcopypastemixstring = bipcopypastedir + bipcopypastefilemix
	        
	        bipcopypastefile = "\pasteBIPfile.bip"
	        bipcopypastestring = bipcopypastedir + bipcopypastefile
	  thetime = slidertime
	  setINISetting bipcopypasteinistring "CopyPasteBip" "Bipobjects" (xbip as string)
      setINISetting bipcopypasteinistring "CopyPasteBip" "Time" (thetime as string)
      tm = GetINISetting bipcopypasteinistring "CopyPasteBip" "Time"
      ontime = ( execute tm )
undo off
(
    holdMaxFile()
	-------------------------------------------------------------------------------------------------
	actionMan.executeAction 972555510 "40133"-- Biped: Move All - Collapse Initial
	biped.SaveBipFile mybip.controller bipcopypastemixstring 
	-------------------------------------------------------------------------------------------------
	bipcont.mixerMode=true 
    bipmix.mixType = #mixdown --: string (#mixdown | #rawmix)

   appendTrackgroup bipmix -- add track group on above
   numtg = bipmix.numTrackgroups
   trackone = getTrackgroup bipmix numtg
   -- trackone.name = "COPY_PASTE"

   gt = getTrack trackone 1 -- target track exploration

   if transision == true then gt.tracktype = #transtrack else gt.tracktype = #layertrack

timevalue = 0f -- interval animationRange.start animationRange.end
appendClip gt bipcopypastemixstring true timevalue -- insert clip one
appendClip gt bipcopypastestring true timevalue -- insert clip two
"-----------------------"
clipend = gt.numClips --: integer
transclipend = gt.numTransClips --: integer
myclip = getclip gt clipend
"-----------------------"
firstclip = getclip gt 1
"-----------------------"
--slidertime = animationrange.start
if transision == true then 
( 
	if timeslider_destination == true then 
	(
       firstclip_orgend = firstclip.orgend
	   mytime = thetime - myclip.globstart
       moveClip myclip mytime -- move clip to time slider
       if thetime == firstclip_orgend then 
         (
            format "Same..\n"
            try ( firstclip.transInpt = firstclip.orgend - 5f ) catch() -- start transition
            try ( myclip.prevTransOutpt = 5f ) catch() -- end transition
		 )
         else
           ( -- else
	        if thetime >= firstclip_orgend then
	           (
	              format "More..\n"
	              try ( firstclip.transInpt = firstclip.orgend ) catch() -- start transition
		          try ( myclip.prevTransOutpt = thetime - myclip.globstart ) catch() -- end transition
			   ) 
	           else
	            (
	              format "Less..\n"
                  try ( firstclip.transInpt = thetime ) catch()  -- start transition		
                  try ( myclip.prevTransOutpt = firstclip.orgend - thetime ) catch() -- end transition
			    )
           ) -- else
	)
	else
	(
      mcliplength = myclip.prevTransOutpt
      --moveClip myclip (mcliplength/2)
      mytransition = mcliplength - transfr_value --(transfr.value = 5f) or maximum 50f
      moveClip myclip mytransition
      firstclip.transInpt = myclip.globstart
      myclip.prevTransOutpt = firstclip.orgend-firstclip.transInpt
	)

) else 
(
	if timeslider_destination == true then
	(
        mytime = thetime - myclip.globstart
        moveClip myclip mytime -- move clip to time slider
	) else (moveClip myclip ((firstclip.orgend-myclip.globstart)+0f )) -- move clip to first clip end
)
"-----------------------"
      --scaleClip  myclip (50.0) -- min:0.0
      --myclip.globstart = slidertime
      try ( firstclip.transAngle = Zangle ) catch( format "Some error on transition Out clip.\n" )
      try ( firstclip.transFocus = TheFocus ) catch( format "Some error on transition Focus clip.\n" )
      --firstclip.transRolling = true
      try ( firstclip.transEasein = 0.5 ) catch( format "Some error on transition Ease in clip.\n" )
      try ( firstclip.transEaseout = 0.5 ) catch( format "Some error on transition Ease out clip.\n" )
      --myclip.prevTransRolling = true
"-----------------------"
bipcont.mixerMode=false
bipcont.mixerMode=true -- double mix for refreshing
--mixdown <mixer> <KeyPerFrame:boolean> <EnforceIkConstraints:boolean> <ContinuityRange:integer> <FilterHyperExtLegs:boolean> <MaxKneeAngle:float>
mixdown bipmix false EnforceIkConst ContRange true 166.158 -- Compute Mixdown
copyMixdownToBiped bipmix
"-----------------------"
bipcont.mixerMode=false
biped.SaveBipFile mybip.controller bipcopypastemixerstring
--------------------------------------------------------------------------
SetQuietMode true
fetchMaxFile true
SetQuietMode false
--------------------------------------------------------------------------
		objs=#()
		xbip = GetINISetting bipcopypasteinistring "CopyPasteBip" "Bipobjects"
		bipobjs = execute xbip 
		objs = for i in bipobjs collect getnodebyname i 
		mybip = (biped.getNode objs[1] 13 )
		bipfootstep = ( biped.getNode objs[1] 16 ) -- i.transform.controller.footstepmode = true (append 16 #footprints Footsteps)
        bfoot = bipfootstep.transform
		select objs
) -- undo off
    undo "Merge Motion" on 
	(   
		actionMan.executeAction 972555510 "40133"-- Biped: Move All - Collapse Initial
		biped.LoadBipFile mybip.controller bipcopypastemixerstring
	) -- undo on
	undo off
	(
		if keep == true then
		(
              ptBIP = Point centermarker:off axistripod:off cross:on Box:on constantscreensize:off drawontop:off size:10 \
              pos:(bipfootstep.center) name:("POINT_Bip_Temp") wirecolor:red -- isSelected:off
			  mybip.parent = ptBIP -- link
              ptBIP.transform = bfoot -- move
              delete ptBIP -- delete point
		      if state == true then ( actionMan.executeAction 972555510 "40133" )  else () -- Biped: Move All - Collapse
		) else ()
		try ( delete_filemixer bipcopypastemixstring bipcopypastemixerstring ) catch ()
		slidertime = ontime -- back to original time
	) -- undo off
	format "Load Bip File ... Done.\n"
) -- fn merge_bip_motion
	-----------------------------------------------------------------------
	on bipmotion_roll open do ()
	on type_o changed state do ()
	on type_p changed state do enabled_buttons state

	on timeslide changed state do (if motiontrans.checked == true then (transfr.enabled = not state) else())--if state == true then messagebox "Move the Time Slider to start point in time around the last Keys !"
	on motiontrans changed state do ( fcslab.enabled = state ; zrot.enabled = state ; focus_dd.enabled = state ; transfr.enabled = state)
	--on focus_dd selected i do format "You selected '%'! as item :% as target :%\n" focus_dd.items[i] focus_dd.selection (item_focus i)
	on EnforceIK changed state do conrange.enabled = state

    ----------------------------------------------------------------------------------------------------------- execute
	on copy_it pressed do 
	( 
		if (selection.count >= 1) and (classof (selection[1].baseobject) == biped_object) then
         copy_bip_motion_option selection collapsemotion_c.state
          else messagebox "Please, select a biped object !" title:"   Copy Bip Animation"		
	)
	on paste_it pressed do 
	(
	  if (selection.count >= 1) and (classof (selection[1].baseobject) == biped_object) then
	  (
		allbips = getcurrentselection()
		mybip = (biped.getNode allbips[1] 13 )
		case type_p.state of
		(
		  1:( paste_bip_motion allbips type_o.state true type_p.state )
		  2:(
               keep_pos = true
               timeslider_destination = timeslide.checked --false

               motion_transision = motiontrans.checked --true
		       transfr_value = transfr.value
               trans_Focus = (item_focus focus_dd.selection)  --: #focusAuto, #focusCom, #focusLftFoot, #focusRgtFoot, #focusBthFeet
               Z_angle = zrot.value --0.0 -- float

               Enforce_IkConstraints = EnforceIK.checked --true
               Continuity_Range = conrange.value --6

               max motion mode
               if mybip.controller.figureMode == true then ( messageBox "Please Exit Figure Mode." title:"Copy/Paste Bip Animation v1.5" ) else
				(
                  disablesceneredraw()
                  merge_bip_motion allbips keep_pos timeslider_destination motion_transision trans_Focus Z_angle Enforce_IkConstraints Continuity_Range transfr_value
                  enablesceneredraw()
                  max views redraw
				) -- else
		     )
	    )
	  ) else messagebox "Please, select a biped object !" title:"   Paste Bip Animation"
	) -- on
)
createdialog bipmotion_roll width:200 height:248 fgcolor:blue  style:#(#style_sysmenu, #style_toolwindow) --modal:true -- 200 435