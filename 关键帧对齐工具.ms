(

struct av_kfAlign
--define struct to hold my global values
(
	keyAlign = #(),
	tObj,
	sObj
)

--Init my structure
av_kf = av_kfAlign()

--check if rollout exists
try(destroydialog alignRoll)catch()

--define my rollout
rollout alignRoll "Key Frame Align" width:160 height:372
(
	--define ui --
	local startDef = animationrange.start 
	local endDef = animationrange.end
	pickbutton objOne "选择" pos:[36,20] width:90 height:31
	pickbutton Obj2 "选择" pos:[36,81] width:90 height:31
	--button doBtn "Do It!" pos:[32,125] width:100 height:20
	spinner startSpn "开始帧" pos:[22,196] width:100 height:16 range:[-999999,999999,0] type:#integer
	spinner endSpn "结束帧" pos:[22,218] width:100 height:16 range:[-999999,999999,30] type:#integer
	spinner stepSpn "子步" pos:[22,243] width:100 height:16 range:[1,60,1] type:#integer
	button bakeBtn "执行" pos:[30,311] width:100 height:30
	checkbox chkPos "位移" pos:[8,168-27] width:44 height:20 checked:true
	GroupBox grp1 "需要对齐物体" pos:[2,4] width:156 height:54
	GroupBox grp2 "参照对齐物体" pos:[2,62] width:156 height:56
	checkbox chkRot "旋转" pos:[56,168-27] width:44 height:20 checked:true
	checkbox chkSca "缩放" pos:[104,168-27] width:44 height:20 checked:false
	GroupBox grp3 "坐标变换" pos:[2,125] width:156 height:41
	GroupBox grp4 "时间范围" pos:[2,174] width:156 height:120
	progressBar pb1 "ProgressBar" pos:[6,356] width:146 height:8 color:(color 63 181 47)
	checkbox timeCk "当前时间范围" pos:[18,264] width:107 height:16 checked:true
	
	--Define Functions--
	
	fn rotControl rotObj kfArray =
	/*This function finds the keys on the rotation controller*/
	(
		local rotKeyControl = #()
		If classof rotObj.rotation.controller == Rotation_List then
		(
			For i =1 to rotObj.rotation.controller.count do -- iterates through each pos controller to find keys
			(
				If numkeys rotObj.rotation.controller[i].rotation.controller > 1 then -- this line finds if a particular controller has keys 
				(	
					append rotKeyControl  (rotObj.rotation.controller[i].rotation.controller) --adds controller to an array
				)
			)
		)
		Else
		(
			rotKeyControl[1] = rotObj.rotation.controller --if its a regular transform controller it assigns that to the variable
		)
		If 	rotKeyControl.count >= 1 then
		(
			for i = 1 to rotKeyControl.count do
			(
				local keyNum = numKeys rotKeyControl[i]
				for j = 1 to keyNum do
				(
					append kfArray (getKeyTime rotKeyControl[i] j)
				)
			)
		)
		Else
		(
			local rotkeyNum = numKeys rotKeyControl[1]
			for t = 1 to rotkeyNum do
			(
				append kfArray (getKeyTime rotKeyControl[1] t)
			)
		)
	)
	
	fn posControl posObj kfArray =
	/*This function finds the keys on the rotation controller*/
	(
		local posKeyControl = #()
		If classof posObj.position.controller == Rotation_List then
		(
			For i =1 to posObj.position.controller.count do -- iterates through each pos controller to find keys
			(
				If numkeys posObj.position.controller[i].position.controller > 1 then -- this line finds if a particular controller has keys 
				(	
					append posKeyControl  (posObj.position.controller[i].position.controller) --adds controller to an array
				)
			)
		)
		Else
		(
			posKeyControl[1] = posObj.position.controller --if its a regular transform controller it assigns that to the variable
		)
		If posKeyControl.count >= 1 then
		(
			for i = 1 to posKeyControl.count do
			(
				local keyNum = numKeys posKeyControl[i]
				for j = 1 to keyNum do
				(
					append kfArray (getKeyTime posKeyControl[i] j)
				)
			)
		)
		Else
		(
			local poskeyNum = numKeys posKeyControl[1]
			for t = 1 to poskeyNum do
			(
				append kfArray (getKeyTime posKeyControl[1] t)
			)
		)
	)
	
	fn bipControl bipOb kfArray= 
	/*This function finds the biped key and addes them to the array*/
	(
		bKey = numkeys bipOb.controller
		for j = 1 to bKey do 
		(
			append kfArray (getKeyTime bipOb.controller j)
		)
	)
	
	/*-------------------------------------------------- Main Body ------------------------------------------------------------*/
	on objOne picked obj do --object to be aligned
	(
		av_kf.sobj = obj
		objOne.text = obj.name
	)
	
	on Obj2 picked obj do -- pick object and populate an array with the keyframes to align
	(
		av_kf.Tobj = obj
		Obj2.text = obj.name
		If IsKindOf av_kf.Tobj.baseobject Biped_Object then
		(
			bipControl(av_kf.tObj)(av_kf.keyAlign)
		)
		Else
		(
			posControl(av_kf.tObj) (av_kf.keyAlign)
			rotControl(av_kf.tObj) (av_kf.keyAlign)
		)
	)
	
	on doBtn pressed do
	(
		sort av_kf.keyAlign
		--print av_kf.keyAlign
		undo on 
		(
			for i = 1 to av_kf.keyAlign.count do --iterates through the keyframes
			(	
				animButtonState = true --turns animate on
				slidertime = av_kf.keyAlign[i] --moves the timeslider to the proper keyframe
				--print keyArray[i]
				pb1.value = 100.*i/av_kf.keyAlign.count --progress bar
				if IsKindOf av_kf.Tobj.baseobject Biped_Object then
				(
					If chkSca.checked == true do --allows for scale alignment to  biped
					(
						av_kf.sobj.Scale = av_kf.tobj.transform.scale
					)				
					If chkRot.checked == true do --allows for rot alignment to biped
					(
						av_kf.sobj.rotation = av_kf.Tobj.transform.rotation
					)
					If chkPos.checked == true do --allows for pos alignment to biped
					(
						av_kf.sobj.position = av_kf.Tobj.transform.position
					)
				)
				Else
				(
					if IsKindOf av_kf.sobj.baseobject Biped_Object then
					(
						If chkPos.checked == true do
						(	
							biped.setTransform av_kf.sobj #pos av_kf.tobj.transform.position true
						)
						If chkRot.checked == true do
						(
							biped.setTransform av_kf.sobj #rotation av_kf.tobj.transform.rotation true
						)
					)
					Else
					(
						If chkSca.checked == true do --allows for scale alignment
						(
							av_kf.sobj.Scale = av_kf.tobj.Scale
						)
						If chkRot.checked == true do --allows for rot alignment
						(
							av_kf.sobj.rotation = av_kf.tobj.rotation
						)
						If chkPos.checked == true do --allows for pos alignment
						(
							av_kf.sobj.position = av_kf.tobj.position
						)
					)
				)
			)
		)
		pb1.value = 0
		gc light:true
	)

	on bakeBtn pressed do
	(
		undo on
		(
			if timeCk.checked == true do 
			(
				startSpn.value = animationrange.start
				endSpn.value = animationrange.end
			)
			If startSpn.value > endSpn.value then --checks to make sure animation ranges are valid
			(
				Messagebox "Start Range is > End Range. Please fix"
			)
			Else
			(
				disableSceneRedraw() -- disables scene redraw for speed
				for t = startSpn.value to endSpn.value by stepSpn.value do
				(
				pb1.value = 100.*t/endSpn.value				
				animButtonState = true --turns animate on
				slidertime = t --moves the timeslider to the proper keyframe
				if IsKindOf av_kf.Tobj.baseobject Biped_Object then
				(
					If chkSca.checked == true do --allows for scale alignment to  biped
					(
						av_kf.sobj.Scale = av_kf.tobj.transform.scale
					)
					If chkRot.checked == true do --allows for rot alignment to biped
					(
						av_kf.sobj.rotation = av_kf.tobj.transform.rotation
					)
					If chkPos.checked == true do --allows for pos alignment to biped
					(
						av_kf.sobj.position = av_kf.tobj.transform.position
					)
				)
				Else
				(
					if IsKindOf av_kf.sobj.baseobject Biped_Object then --allows biped to be baked but tracks seperated
					(
						If chkPos.checked == true do
						(	
							biped.setTransform av_kf.sobj #pos av_kf.tobj.transform.position true
						)
						If chkRot.checked == true do
						(
							biped.setTransform av_kf.sobj #rotation av_kf.tobj.transform.rotation true
						)
					)
					Else
					(
						If chkSca.checked == true do --allows for scale alignment
						(
							av_kf.sobj.Scale = av_kf.tobj.Scale
						)
						If chkRot.checked == true do --allows for rot alignment
						(
							av_kf.sobj.rotation = av_kf.tobj.rotation
						)
						If chkPos.checked == true do --allows for pos alignment
						(
							av_kf.sobj.position = av_kf.tobj.position
						)
					)
				)
				)
				pb1.value = 0 --resets progressbar 
				enableSceneRedraw() -- enables scene redraw
			)
		)
		gc light:true
	)
	
)
CreateDialog alignRoll 160 372
)