try DestroyDialog disturbSel catch()
rollout disturbSel "disturbSelectionObj" width:155 height:180
(
	spinner rt "rotation" 	  height:16 range:[0,360,180] scale:1
	spinner s_min "scaleMin" 	  height:16 range:[1,100,80]  scale:1 
	spinner s_max "scaleMax" 	  height:16 range:[100,1000,120] scale:1
	spinner mx "moveX" 			  height:16 range:[0,100000,0] scale:1
	spinner my "moveY" 			  height:16 range:[0,100000,0] scale:1
	spinner mz "moveZ" 			  height:16 range:[0,100000,0] scale:1
	button bt_go "go..." 		  width:150 height:42
	---------------------
	local ctrlSp=#(rt,s_min,s_max,mx,my,mz),
		  spIni =#(180,80,120,0,0,0)
	on bt_go pressed do undo on
	(
		sel=getCurrentSelection()
		for i=1 to sel.count do 
		(
			s=random (s_min.value/100) (s_max.value/100)
			r=random -rt.value rt.value
			trans=[random -mx.value mx.value , random -my.value my.value , random -mz.value mz.value]
			so=sel[i].scale
			if so.x==so.y and so.x==so.z and so.x>s_min.value/100 and so.x<s_max.value/100 then () else resetScale sel[i]
			--ResetTransform sel[i]
			in coordSys local sel[i].rotation.z_rotation=r
			sel[i].scale=[s,s,s]
			sel[i].pos=sel[i].pos+trans
		)--end for
		--DestroyDialog disturbSel
	)--end pressed
	on disturbSel open  do for i=1 to ctrlSp.count do (v=getIniSetting "$plugcfg/bqq_scripts.ini" "disturbSel" (ctrlSp[i] as string);ctrlSp[i].value=if v=="" then spIni[i] else v as float )
	on disturbSel close do for i=1 to ctrlSp.count do  setINISetting   "$plugcfg/bqq_scripts.ini" "disturbSel" (ctrlSp[i] as string) (ctrlSp[i].value as string)
)--end rollout
createdialog disturbSel pos:(mouse.screenPos-[50,175])