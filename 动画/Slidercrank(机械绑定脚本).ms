try destroyDialog ::crankSetup catch()
rollout crankSetup "Crank Setup" width:125
(
	fn filterHelpers obj = isKindOf obj Helper

	group "Objects"
	(
		pickButton pbMaster "Pick Master" width:100 filter:filterHelpers autoDisplay:true
		pickButton pbCrank "Pick Crank" width:100 filter:filterHelpers autoDisplay:true
		pickButton pbCrankPin "Pick Crank Pin" width:100 filter:filterHelpers autoDisplay:true
		pickButton pbPistonPin "Pick Piston Pin" width:100 filter:filterHelpers autoDisplay:true
	)
	button btnSetup "Setup" width:100 height:25 offset:[0,5]

	on btnSetup pressed do with undo "Crank Setup" on
	(
		if NOT isValidNode (local master = pbMaster.object) do
			return messageBox "Pick Master Object first."
		if NOT isValidNode (local crank = pbCrank.object) do
			return messageBox "Pick Crank Object first."
		if NOT isValidNode (local crankPin = pbCrankPin.object) do
			return messageBox "Pick Crank Pin Object first."
		if NOT isValidNode (local pistonPin = pbPistonPin.object) do
			return messageBox "Pick Piston Pin Object first."

		crank.parent = master
		crankPin.parent = crank
		pistonPin.parent = master

		local pistonPinCtrl = float_script()
		pistonPinCtrl.addConstant #l (distance crankPin pistonPin)
		pistonPinCtrl.addConstant #r (distance crank crankPin)
		pistonPinCtrl.addObject #master (NodeTransformMonitor node:master)
		pistonPinCtrl.addObject #'crankPin' (NodeTransformMonitor node:crankPin)
		pistonPinCtrl.script = "pinVec = normalize (crankPin.pos * inverse master.transform)\n" +
			"cosAng = dot pinVec x_axis\n" +
			"(l^2 - r^2 + (r * cosAng)^2)^.5 + r * cosAng"

		pistonPin.pos = crank.pos
		pistonPin.pos.controller = position_list()
		pistonPin.pos.available.controller = position_xyz()
		pistonPin.pos.controller[2][1].controller = pistonPinCtrl

		local lookAtCtrl = lookAt_constraint()
		lookAtCtrl.appendTarget crankPin 100
		lookAtCtrl.target_axis = 0
		lookAtCtrl.upnode_world = false
		lookAtCtrl.pickUpNode = master
		pistonPin.rotation.controller = lookAtCtrl
	)
)
createDialog crankSetup