try(destroyDialog mmmmm)catch()
rollout mmmmm "中文" width:79 height:104
(

	button btn1 "设置对称" pos:[3,32] width:72 height:24

	checkbutton ckb1 "基于自身" pos:[5,5] width:69 height:23 checked:false

	label lbl1 " 青年大叔 690089735   @qq.com" pos:[11,61] width:58 height:43 enabled:false

	on btn1 pressed do
	(
		if classof $ == Biped_Object then
		(
			r = biped.getTransform $ #rotation
			r = r as eulerAngles
			r.x =- r.x
			r.z = -r.z-180
			r = r as quat
			biped.setTransform $ #rotation r on
			if ckb1.checked==false then
			(			
				p = biped.getTransform $ #pos
				p.x = -p.x
				biped.setTransform $ #pos p on
			)
		)
		else
		(
			$.rotation.y_rotation = -$.rotation.y_rotation
			$.rotation.z_rotation = -$.rotation.z_rotation
			if ckb1.checked==false then
			(
				$.pos.x = -$.pos.x
			)
		)
		
	)
)
createDialog mmmmm  pos:[0,180]