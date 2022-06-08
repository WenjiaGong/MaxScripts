try(DestroyDialog clearRedundancyKeys)catch()
rollout clearRedundancyKeys "清理冗余关键帧" width:162 height:100
(
	radioButtons rdo_clearType "清理对象" pos:[12,5] width:141 height:30 labels:#("全部","选择的") columns:2
	button btn_clearRedundancyKeys "清理冗余关键帧" pos:[7,45] width:150 height:30
	HyperLink Hyperlink_author ">>灰烬正义<<   2015.8.19 " pos:[10,80] width:280 height:15 address:"QQ:278080503" color:(color 255 127.50 0) across:2

	fn subDltRedundancyKey theCont =
	(
		theKeys = theCont.keys
		theRedKeys = #()
		theKNub = theKeys.count
		for k = 1 to theKeys.count do
		(
			case k of
			(
				1:
				(
					try
					(
						k1 = theKeys[k].value
						k2 = theKeys[k+1].value
						if k1 == k2 then
						(
							append theRedKeys k
						)
					)
					catch()
				)
				theKNub:
				(
					try
					(
						k1 = theKeys[k-1].value
						k2 = theKeys[k].value
						if k1 == k2 then
						(
							append theRedKeys k
						)
					)
					catch()
				)
				default:
				(
					try
					(
						k1 = theKeys[k-1].value
						k2 = theKeys[k].value
						k3 = theKeys[k+1].value
						if k1 == k2 and k2 == k3 then
						(
							append theRedKeys k
						)
					)
					catch()
				)	
			)
		)
		for k = theRedKeys.count to 1 by - 1 do
		(
			deleteKey theCont theRedKeys[k]
		)
	)
	fn deleteRedundancyKeys theObj =
	(
		--位移
		xPosCont = theObj.pos.x_position.controller
		yPosCont = theObj.pos.y_position.controller
		zPosCont = theObj.pos.z_position.controller
		--旋转
		xRotCont = theObj.rotation.x_rotation.controller
		yRotCont = theObj.rotation.y_rotation.controller
		zRotCont = theObj.rotation.z_rotation.controller
		--缩放
		ScaCont = theObj.Scale.controller
		
		subDltRedundancyKey xPosCont
		subDltRedundancyKey yPosCont
		subDltRedundancyKey zPosCont
		
		subDltRedundancyKey xRotCont
		subDltRedundancyKey yRotCont
		subDltRedundancyKey zRotCont
		
		subDltRedundancyKey ScaCont
	)
	
	on btn_clearRedundancyKeys pressed do
	(
		boneObjAry = #()
		case rdo_clearType.state of
		(
			1:
			(
				boneObjAry = for i in geometry where classof i == BoneGeometry collect i
			)
			2:
			(
				boneObjAry = for i in selection where classof i == BoneGeometry collect i
			)
		)
		undo on
		(
			for i in boneObjAry do
			(
				deleteRedundancyKeys i
			)
		)
		messagebox "清理完成!" title:"提示：" beep:false
	)
)
createdialog clearRedundancyKeys 
