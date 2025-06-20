rollout test "Ò»¼ü³éÖ¡" width:140 height:60
(
	button 'btn1' "³éÖ¡" pos:[26,18] width:90 height:24 align:#left
	on btn1 pressed  do
	(
		try
		(		
			a = start + 1f
			b = end - 1f
			selectkeys selection[1].position.controller (interval a b)
			deletekeys selection[1].position.controller #selection
			selectkeys selection[1].scale.controller (interval a b)
			deletekeys selection[1].scale.controller #selection
			
		)catch()
		try(
			
				if classof selection[1].rotation.controller == tcb_rotation then 
				(
					selection[1].rotation.controller = Euler_XYZ ()
					ax = GetDeleteKeys selection[1].rotation.controller.x_rotation.controller
					ay = GetDeleteKeys selection[1].rotation.controller.y_rotation.controller
					az = GetDeleteKeys selection[1].rotation.controller.z_rotation.controller
					if ax != undefined do for j = ax.count to 1 by -1 do deletekey selection[1].rotation.controller.x_rotation.controller ax[j]
					if ay != undefined do for j = ay.count to 1 by -1 do deletekey selection[1].rotation.controller.y_rotation.controller ay[j]
					if az != undefined do for j = az.count to 1 by -1 do deletekey selection[1].rotation.controller.z_rotation.controller az[j]
					selection[1].rotation.controller = TCB_Rotation ()
				)
				else if classof selection[1].rotation.controller == Euler_XYZ then
				(
					ax = GetDeleteKeys selection[1].rotation.controller.x_rotation.controller
					ay = GetDeleteKeys selection[1].rotation.controller.y_rotation.controller
					az = GetDeleteKeys selection[1].rotation.controller.z_rotation.controller
					if ax != undefined do for j = ax.count to 1 by -1 do deletekey selection[1].rotation.controller.x_rotation.controller ax[j]
					if ay != undefined do for j = ay.count to 1 by -1 do deletekey selection[1].rotation.controller.y_rotation.controller ay[j]
					if az != undefined do for j = az.count to 1 by -1 do deletekey selection[1].rotation.controller.z_rotation.controller az[j]
				)
			)catch()
	)
)
createdialog test