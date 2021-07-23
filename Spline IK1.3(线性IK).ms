try(destroydialog rollout_title) catch()

rollout rollout_title "Spline_IK  v1.3" width:190 height:310
(
	subrollout sub_broken "Spline_IK  v1.2" width:190 height:300 pos:[0,0]
)
 rollout rollout_SplineIK "Spline_IK" width:190 height:183
(
	label lbl8 "控制器颜色" pos:[26,16] width:64 height:22
	colorPicker cp2 "" pos:[98,13] width:50 height:18 enabled:true color:(color 14 254 2)
	label lbl7 "创建骨骼数量" pos:[19,41] width:73 height:20
	spinner spn2 "" pos:[101,40] width:57 height:16 range:[2,100,8] type:#integer scale:1	
	label lbl6 "骨骼大小" pos:[32,65] width:51 height:17
	spinner spn3 "" pos:[101,65] width:57 height:16 range:[0,100,5]
	label lbl4 "骨骼拉伸" pos:[20,89] width:51 height:17
	checkbox chk1 "Checkbox" pos:[75,90] width:14 height:12 checked:true
	label lbl5 "FK" pos:[80,112] width:12 height:17	toolTip:"龙蛇骨架建议勾选" align:#left
	checkbox chk2 "Checkbox" pos:[102,112] width:14 height:12 checked:false	toolTip:"龙蛇骨架建议勾选" align:#left
	
	label lbl9 "YZ轴旋转" pos:[101,90] width:48 height:18	toolTip:"勾选后曲线将不自动平滑，控制器可控制骨骼3个方向的旋转，龙蛇骨架可勾选，锁链不建议勾选" align:#left
	checkbox chk3 "Checkbox" pos:[157,90] width:14 height:12 	toolTip:"勾选后曲线将不自动平滑，控制器可控制骨骼3个方向的旋转，龙蛇骨架可勾选，锁链不建议勾选" align:#left
	
	button btn6 "确认" pos:[48,135] width:90 height:36  toolTip:"样条曲线点数即控制器个数" align:#left
	hyperLink lianjie "Author:z.ven" address:"https://www.cgjoy.com/thread-223735-1-1.html" color:(color 149 149 149) hoverColor:(color 0 255 255) visitedColor:(color 149 149 149)  pos:[61,180] width:70 height:19

	on btn6 pressed  do
	(
			a=selection as array
			if (superclassof a[1]!=Shape) then(
			messagebox"请选择样条曲线"
			)else(		
				fline=#()				
				xgq=#()		
				fxgq=#()	
				ctrl=#()	
				fctrl=#()	
				bonee=#()	
				bonee2=#()  
				xnt=#()		 
				fxnt=#() 	
				g=#()  		
				g2=#()     
				md=#()  	
				s=1			
			for i in selection do(
			ds=numknots i			
			kontArray = #{1..ds} as array
			setKnotSelection i 1 kontArray keep:true
			for ii = 1 to kontArray.count do setKnotType i 1 ii #smooth
			if  (chk3.checked==true) do(
			for ii = 1 to kontArray.count do setKnotType i 1 ii #bezier
				)
		--	for ii = 1 to kontArray.count do setKnotType i 1 ii #bezier
			updateshape $
			fline[s]=copy i pos:(i.pos) name:(i.name+"f")		
			in coordsys local move fline[s] [0,0,-spn3.value*4]
			addmodifier i (spline_ik_control()) 		  
			addmodifier fline[s](spline_ik_control())   
			i.spline_ik_control.createhelper(ds)		
			i.spline_ik_control.helper_size=spn3.value*4  			
			$Point*.wirecolor=cp2.color	
			i.spline_ik_control.helper_axistripod=true 		
			i.spline_ik_control.drawontop=false  	
			ctrl=$Point* as array				
			for j in $Point* do j.name=uniquename "Ctrl" 
				
				
			fline[s].spline_ik_control.createhelper(ds)		
			fline[s].spline_ik_control.helper_size=spn3.value*4  			
			fctrl=$Point* as array		
			for k in $Point* do k.name=uniquename "Ftrl" 
			i.spline_ik_control.nolinking()					
			fline[s].spline_ik_control.nolinking()
			for l=1 to ctrl.count do (				
			attachobjects ctrl[l] fctrl[l] move:false
			)	
			
			for s2=1.0 to spn2.value+1 do(				
			xnt[s2]=Dummy	boxsize:[spn3.value*0.75,spn3.value*0.75,spn3.value*0.75]		
			xnt[s2].position.controller = path_constraint()   
			xnt[s2].position.controller.path =i		
			bfb=(s2-1)/spn2.value*100
			xnt[s2].position.controller.percent = bfb	
			)
			for s3=1.0 to spn2.value+1 do(				
			fxnt[s3]=Dummy	boxsize:[spn3.value*0.75,spn3.value*0.75,spn3.value*0.75]		
			fxnt[s3].position.controller = path_constraint()  
			fxnt[s3].position.controller.path =fline[s]		
			bfb=(s3-1)/spn2.value*100
			fxnt[s3].position.controller.percent = bfb		
			)
			for s3=1 to spn2.value+1 do (						
				if s3<spn2.value+1 then(
				bonee[s3]=BoneSys.createBone xnt[s3].pos xnt[s3+1].pos [0,0,1]
				bonee[s3].width = spn3.value
				bonee[s3].height = spn3.value
					if s3==1 then(
						g[s]=bonee[s3]
						)
				)else(
				bonee[s3]=BoneSys.createBone xnt[s3].pos (xnt[s3].pos*1.1) bonee[spn2.value].dir  
				
				bonee[s3].transform =bonee[spn2.value].transform
				in coordSys Local move bonee[s3] [bonee[spn2.value].length,0,0]
					
				bonee[s3].width = spn3.value
				bonee[s3].height = spn3.value
				bonee[s3].taper= 90
				bonee[s3].length= (bonee[s3].width+bonee[s3].height)/2
			--	bonee[s3].name=uniquename "end"
				
				bonee[s3].rotation.controller=orientation_Constraint() 	
				bonee[s3].rotation.controller.appendTarget ctrl[ds] 50	
				bonee[s3].rotation.controller.relative=true    
				
				)
				if s3>1 then(						
				bonee[s3].parent=bonee[s3-1]
				)			
			)
			for s4=1 to spn2.value do (
				bonee[s4].rotation.controller = lookat_constraint()		   
				bonee[s4].rotation.controller.appendtarget xnt[s4+1] 50    		
				bonee[s4].rotation.controller.lookat_vector_length = 0      			
				bonee[s4].rotation.controller.upnode_world=false  
				bonee[s4].rotation.controller.upnode_ctrl = 0			
				bonee[s4].rotation.controller.pickUpNode=fxnt[s4]  
				bonee[s4].rotation.controller.StoUP_axis=1	
				bonee[s4].rotation.controller.relative=true 
			)

			if  (chk1.checked==true) do(
			    for s4=1 to spn2.value+1 do (
				bonee[s4].position.controller = position_constraint()     
				bonee[s4].position.controller.appendTarget xnt[s4] 50  
				bonee[s4].position.controller.relative=true 					
				)
			)
			r=Dummy pos:g[s].pos boxsize:[spn3.value*4,spn3.value*4,spn3.value*4]
  			r.name=uniquename"Root"
 			for i7 in ctrl do(
 			attachobjects r i7 move:false	
 			)
			if  (chk2.checked==true) do(
				for s3=1 to ctrl.count do (						
				if s3<ctrl.count then(
				bonee2[s3]=BoneSys.createBone ctrl[s3].pos ctrl[s3+1].pos [0,0,1]
				bonee2[s3].width = spn3.value*2.5
				bonee2[s3].height = spn3.value*2.5
				bonee2[s3].wirecolor = color 28 89 177
					if s3==1 then(
						g2[s]=bonee2[s3]
						)
				bonee2[s3].name=uniquename "FK"
				bonee2[s3].boxmode = on
				)else(
				bonee2[s3]=BoneSys.createBone ctrl[s3].pos (ctrl[s3].pos*1.1) bonee2[ctrl.count-1].dir   
				bonee2[s3].transform =bonee2[ctrl.count-1].transform
				in coordSys Local move bonee2[s3] [bonee2[ctrl.count-1].length,0,0]
					
				bonee2[s3].width = spn3.value*2.5
				bonee2[s3].height = spn3.value*2.5
				bonee2[s3].wirecolor = color 28 89 177
				bonee2[s3].taper= 90
				bonee2[s3].length= (bonee2[s3].width+bonee2[s3].height)/2
				bonee2[s3].name=uniquename "FK"
				bonee2[s3].boxmode = on
				)
				if s3>1 then(						
				bonee2[s3].parent=bonee2[s3-1]
				)	
				)
				g2[s].parent=r
				
				for s2=1 to bonee2.count do(
					bonee2[s2].setSkinPose()
				)
				
				 for i8=1 to ctrl.count do(
				attachobjects bonee2[i8] ctrl[i8] move:false	
				)
			)	
			g[s].parent=ctrl[1]
			
			r.setSkinPose()
			for s2=1 to ctrl.count do(
				ctrl[s2].setSkinPose()
			)			
			
 			Free ctrl					
			Free fctrl					
 							
			deletekeys $dummy* #allkeys   
			s+=1
			)
			global tc1
			global tc2
			global tc3
			global tc4
			global tc5
			tt1 = layerManager.getLayerFromName"Help"  	
			if  tt1 ==undefined then (
			tc1=LayerManager.newLayerFromName "Help" 
			)else(
			tc1=LayerManager.getLayerFromName"Help"
			)	
			tt2 = layerManager.getLayerFromName"Skinbone"  	
			if  tt2 ==undefined then (
			tc2=LayerManager.newLayerFromName "Skinbone" 
			)else(
			tc2=LayerManager.getLayerFromName"Skinbone"
			)			
			tt3 = layerManager.getLayerFromName"Line"  	
			if  tt3 ==undefined then (
			tc3=LayerManager.newLayerFromName "Line" 
			)else(
			tc3=LayerManager.getLayerFromName"Line"
			)			
			tt4 = layerManager.getLayerFromName"Ctrl"  	
			if  tt4 ==undefined then (
			tc4=LayerManager.newLayerFromName "Ctrl" 
			)else(
			tc4=LayerManager.getLayerFromName"Ctrl"
			)			
			if  (chk2.checked==true) do(				
				tt5 = layerManager.getLayerFromName"FK"
				if tt5==undefined then (
				tc5=LayerManager.newLayerFromName"FK"
				)else(
				tc5=LayerManager.getLayerFromName"FK"
				)
			)
			for n in $*Ftrl* do tc1.addNode n
			for n in $Dummy* do tc1.addNode n
			for n in $Line* do tc3.addNode n
			for n in $Line*f do tc1.addNode n			
			for n in $Bone* do tc2.addNode n
			for n in $Ctrl* do tc4.addNode n
			for n in $Root* do tc4.addNode n	
			if  (chk2.checked==true) do(
			for n in $FK* do tc5.addNode n
			)
			tc1.on = false
			clearSelection()
		)	
	)
)

rollout rollout_wzys "位置约束" width:181 height:54
(
	button btn6 "位置约束" pos:[40,12] width:101 height:29  toolTip:"依次选择，将中间的物体位置约束给两端的物体" align:#left
	on btn6 pressed  do
(
	yswt=selection as array
    global sl=yswt.count
	if (sl<3) then(
		messagebox"至少选择3个物体"
		)else(
			for i=1 to sl-1 do(
				if i>1 then(
				yslb=position_list ()
				yswt[i].pos.controller = yslb
				wzys =Position_Constraint() 	
				yswt[i].pos.controller.Available.controller= wzys
				wzys.appendTarget yswt[1] (100-(((i-1.0)/(sl-1.0))*100))
				wzys.appendTarget yswt[sl] (((i-1.0)/(sl-1.0))*100)
				wzys.relative=true		
				yswt[i].pos.controller.Available.controller = Position_XYZ ()
				yslb.setActive 3	
				)
			)
		)
	)
)
	
createdialog rollout_title
AddSubRollout rollout_title.sub_broken rollout_SplineIK
AddSubRollout rollout_title.sub_broken rollout_wzys