-- Speed Circular Array.ms
-- A simple script to speed up circular arrays.
-- Written By Martin Skinner http://www.3dlang.com , 21/03/2007

if ((SCA_Roll != undefined) and (SCA_Roll.isdisplayed)) do
	(destroyDialog SCA_Roll)
	
-- Destroys the rollout if one exists already

rollout SCA_Roll "Speed Circular Array" -- rollout title
(
	pickbutton pbt_pickObj "Pick Object" width:150 autoDisplay: true
	
	pickbutton pbt_pickRev "Array Around" width:150 autoDisplay:true enabled:false 
	spinner spn_NoOf "No of clones:" type:#integer range:[2,360,3] align:#left width:155 offset:[0,10] enabled:false
	radiobuttons rdi_CloneType labels:#("Cop","Inst","Ref") columns:1 align:#left offset:[0,5] default:2 enabled:false
	spinner spn_TAngle "Around Angle:" type:#float range:[5.0,360.0,270.0] align:#left width:150 offset:[0,10] enabled:false
	radiobuttons rdi_ArrayAxis labels:#("X","Y","Z") columns:1 align:#right offset:[-5,-80] default:3 enabled:false 
	Angle ang1 "" diameter:50 align:#center range:[0,360,spn_TAngle.value] startdegrees:90 dir:#ccw color:blue offset:[0,-50]
	
	button but_SCArray "SPEED CIRCLE ARRAY!" align:#center width:150 height:30 offset:[0,32] enabled:false
	
	label lab_1 "Speed Circular Array 1.0" offset:[0,5]
	label lab_2 "Copyright: 2008  M.Skinner" offset:[0,-5]
	label lab_3 "www.martinskinner.co.uk" offset:[0,-5]
	
-- DEFINE LOCAL VARIABLES TO BE USED LATER
	local a
	local b
	

	on pbt_pickObj picked AObj do -- On picking the object to array do
	(
		select AObj -- Select picked object
		a = $	-- assign it to a
		pbt_pickRev.enabled = true -- enable to the other pick button
	)-- end action
	
	on pbt_pickRev picked BObj do -- On picking the object to array around do
	(
		b = BObj -- assign the picked object to variable b
		spn_NoOf.enabled = true
		rdi_CloneType.enabled = true
		spn_TAngle.enabled = true
		rdi_ArrayAxis.enabled = true
		but_SCArray.enabled = true -- enable to rest of interface
	)-- end action
	
	on spn_TAngle changed value do -- On Angle Spinner change do
	(
		ang1.degrees = spn_TAngle.value -- update the visual angle display to match
	)-- end action
	
	on rdi_ArrayAxis changed state do -- On changing the radio button axis for the array to occure in change the diagram color to match RGB, XYZ.
	(
		if (rdi_ArrayAxis.state == 1) do
		(
			ang1.color = red
		)-- end if
		if (rdi_ArrayAxis.state == 2) do
		(
			ang1.color = green
		)-- end if
		if (rdi_ArrayAxis.state == 3) do
		(
			ang1.color = blue
		)-- end if
	)-- end action
	
	on but_SCArray pressed do -- On pressing run the array as follows
	(
		AobjNumber = (spn_NoOf.value) as float -- the number of objects to be arrayed
		Aangle = ((spn_TAngle.value) / (AobjNumber)) -- the individual angle to be used in the array of each object
		
		if (rdi_CloneType.state == 1) do -- checks clone state, in this case if copy
		(
			if (rdi_ArrayAxis.state == 1) do -- checks axis state for rotation, in this case x
			(
				for i = 1 to AobjNumber do -- runs a loop to the number of clones expected
				(
					c = copy a -- copies a
					in coordsys world about b rotate c (quat (i*Aangle) x_axis) -- rotates the copy (c) in the world coords around the array obj by the required angle
				)-- end loop
				
				if spn_TAngle.value == 360 do -- if we're arraying 360 degrees we'll end up with two objects ontop of one eachother
				(
				  delete a -- so let's delete the original object (might cause a problem if the script is run twice in a row, but unlikely situation for intended use)
				)--end if
			)--end if
			
			if (rdi_ArrayAxis.state == 2) do  -- checks axis state for rotation, in this case y
			(
				for i = 1 to AobjNumber do
				(
					c = copy a
					in coordsys world about b rotate c (quat (i*Aangle) y_axis)
				)-- end loop
				
				if spn_TAngle.value == 360 do
				(
				  delete a
				)--end if
			)--end if
			
			if (rdi_ArrayAxis.state == 3) do  -- checks axis state for rotation, in this case z
			(
				for i = 1 to AobjNumber do
				(
					c = copy a
					in coordsys world about b rotate c (quat (i*Aangle) z_axis)
				)-- end loop
				
				if spn_TAngle.value == 360 do
				(
				  delete a
				)--end if
			)--end if
		)--end main if
		
		
		if (rdi_CloneType.state == 2) do -- checks clone state, in this case if instance
		(
			if (rdi_ArrayAxis.state == 1) do -- checks axis state for rotation, in this case x
			(
				for i = 1 to AobjNumber do
				(
					c = instance a
					in coordsys world about b rotate c (quat (i*Aangle) x_axis)
				)--end loop
				
				if spn_TAngle.value == 360 do
				(
				  delete a
				)--end if
			)--end if
			
			if (rdi_ArrayAxis.state == 2) do -- checks axis state for rotation, in this case y
			(
				for i = 1 to AobjNumber do
				(
					c = instance a
					in coordsys world about b rotate c (quat (i*Aangle) y_axis)
				)--end loop
				
				if spn_TAngle.value == 360 do
				(
				  delete a
				)--end if
			)--end if
			
			if (rdi_ArrayAxis.state == 3) do -- checks axis state for rotation, in this case z
			(
				for i = 1 to AobjNumber do
				(
					c = instance a
					in coordsys world about b rotate c (quat (i*Aangle) z_axis)
				)--end loop
				
				if spn_TAngle.value == 360 do
				(
				  delete a
				)--end if
			)--end if
		)--end main if
		
		
		if (rdi_CloneType.state == 3) do  -- checks clone state, in this case if reference
		(
			if (rdi_ArrayAxis.state == 1) do -- checks axis state for rotation, in this case x
			(
				for i = 1 to AobjNumber do
				(
					c = reference a
					in coordsys world about b rotate c (quat (i*Aangle) x_axis)
				)--end loop
				
				if spn_TAngle.value == 360 do
				(
				  delete a
				)--end if
			)--end if
			
			if (rdi_ArrayAxis.state == 2) do  -- checks axis state for rotation, in this case y
			(
				for i = 1 to AobjNumber do
				(
					c = reference a
					in coordsys world about b rotate c (quat (i*Aangle) y_axis)
				)--end loop
				
				if spn_TAngle.value == 360 do
				(
				  delete a
				)--end if
			)--end if
			
			if (rdi_ArrayAxis.state == 3) do  -- checks axis state for rotation, in this case z
			(
				for i = 1 to AobjNumber do
				(
					c = reference a
					in coordsys world about b rotate c (quat (i*Aangle) z_axis)
				)--end loop
				
				if spn_TAngle.value == 360 do
				(
				  delete a
				)--end if
			)--end if
		)--end main if
	)-- end action
)-- end rollout

createDialog SCA_Roll 170 275

-- That's all folks!!
-- Written by Martin Skinner www.3dlang.com for use whilst at Sprunt Media, http://www.3dlang.com
-- Finished 21/03/2007