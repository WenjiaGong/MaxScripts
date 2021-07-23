rollout AnimationTools "动画工具"
 (
   groupBox grp3 "按类型隐藏" pos:[5,5]  width:105 height:190
   checkbox chk7 "Bones" pos:[20,22] width:62 height:16
   checkbox chk8 "CS骨骼" pos:[20,42]  width:65 height:16
   checkbox chk9 "虚拟体" pos:[20,62]
   checkbox chk10 "模型"  pos:[20,82]
   checkbox chk11 "像机"  pos:[20,102]
   button btn20 "隐藏物体" pos:[20,125] width:70 height:19
   button btn21 "显示物体" pos:[20,149] width:70 height:19
   checkbox btn9 "骨骼框显" pos:[15,172]
	
   groupBox grp1 "轨迹" pos:[115,5] width:135 height:190
   groupBox grp52 "Bone骨骼" pos:[120,22] width:125 height:85
   checkbox chk2 "轨迹" pos:[130,45]
   button btn34 "曲线编辑器" pos:[125,75] width:100 height:19
   groupbox grp53 "CS骨骼" pos:[120,120] width:125 height:40
   checkbox chk1 "轨迹" pos:[130,140] width:49 height:16 enable:true checkbox:false
   ColorPicker colorB "骨骼颜色" pos:[130,170] color:[255,0,0] 
	
   groupBox grp11 "冻结/锁定" pos:[5,225] width:105 height:150
   button btn12 "冻结物体" pos:[20,260] width:70 height:19
   button btn13 "解冻物体" pos:[20,285] width:70 height:19
   button btn11 "锁定物体" pos:[20,310] width:70 height:19
   button btn15 "解锁物体" pos:[20,335] width:70 height:19
   
   Groupbox grp6 "时间范围/播放控制" pos:[115,225] width:135 height:150
   label lbl2 "开始时间：" pos:[125,250] width:60 height:15 
   spinner spn7 "" pos:[185,250] width: 60 height:15 range:[-100000,100000,0] type:#integer
   label lbl3 "结束时间：" pos:[125,275] width:60 height:15
   spinner spn8 "" pos:[185,275] width:60 height:15  enabled:true range:[-100000,100000,0] type:#integer
   
   checkbox chk35 "循环" pos:[125,295] width:52 height:15
   groupbox speedG "播放速度" pos:[118,315] width:128 height:50
   radiobuttons speed_buttons pos:[120,330] labels:#("1/4x","1/2x","1x","2x","4x") columns:3
   
   on speed_buttons changed val do 
	( timeConfiguration.playbackSpeed = val) 
   
   on AnimationTools open do 
    (
     spn7.value =animationRange.start
	 spn8.value =animationRange.end
    )
   
   on btn12 pressed do (for i in selection do Freeze i) 
   on btn13 pressed do (for i in Objects do UnFreeze i)
   on chk1 changed state do 
	 ( max motion mode
	   for i in selection where(classOf i==Biped_Object) do 
	   i.controller.rootnode.controller.displayTrajectories =chk1.checked 
	 )
   on chk2 changed state do 
    (
	  for i in selection do i.showTrajectory =chk2.checked
    )
   on btn20 pressed do (for i in selection do i.isHidden=true)
   on btn21 pressed do
    (
	   for i in objects do 
	     i.isHidden =false;
		 /*chk7.checked=false;chk10.checked =false;chk11.checked=false;
	     chk8.checked=false;chk9.checked =false*/
     )
   on btn34 pressed do (macros.run "Track View" "LaunchFCurveEditor")
   
   on chk35 changed state do(timeConfiguration.playbackLoop =chk35.checked)
   on spn7 changed val do
	 ( if spn7.value<animationRange.end then animationRange=interval spn7.value  animationRange.end 
	   else 
	   messagebox "请输入正确的数值!";
       spn7.value =animationRange.start
	  )
   on spn8 changed val do
     (
	  if spn8.value >animationRange.start then animationRange =interval animationRange.start spn8.value
	  else
	  messagebox "请输入正确的数值";
	  spn8.value =animationRange.end
     )
	
   on btn11 pressed do( for i in selection do setTransformLockFlags i #all)
   
   on chk7 changed state do
     (
	   hideByCategory.bones =false
   
     for i in Objects where(classof i ==BoneGeometry) do i.isHidden =chk7.checked
     )
   on chk8 changed state do 
	(
	   hideByCategory.bones =false   
	   for i in objects where(classof i ==Biped_Object) do i.isHidden =chk8.checked
     )
   on chk9 changed state do 
	   (
		 hideByCategory.Helpers =chk9.checked
		 --for i in helpers do i.isHidden =chk9.checked
	    )
   
   on chk10 changed state do
	(
	    hideByCategory.geometry =chk10.checked
	  --for i in geometry where ((classof i!=Biped_Object)and (classof i!=BoneGeometry)) do i.isHidden =chk10.checked   
     )
   
   on chk11 changed state do
     (
	   hideByCategory.cameras=chk11.checked
	   --for i in cameras do i.isHidden =chk11.checked   
      )
   on btn15 pressed do
     (
	   for i in selection do setTransformLockFlags  i #none
      )
   on btn9 changed state do
    (
	  if(state ==on) then
	  (
		 for i in selection do i.boxmode =on  
	  )
	  else
         for i in selection do i.boxmode =off
     )
   
   on colorB changed new_col do selection.wirecolor=new_col

   on AnimationTools resized val do (format "A:%\n" val)
   
  )



  rollout EulerToTCB "Euler与TCB转换"
  (
    groupbox EulerToTCBbd "骨骼Euler与TCB模式互换" pos:[5,10] width:245 height:60
    button theButton "EulerToTCB" pos:[8,35] tooltip:"将所选骨骼从Euler模式转换为TCB模式"
    button theButton2 "TCB To Euler" pos:[88,35] tooltip:"将所选骨骼从TCB模式转换到Euler模式"
    button theButton3 "Euler去翻转" pos:[168,35]
    button clothB "飘带解算" pos:[5,75] tooltip:"进行飘带解算" width:245 height:20
	
    on clothB pressed do
    (
      layerfile="\Spring Magic v1.13 自用修改与汉化.mse"
       filein layerfile	 
	 )
  --Euler To TCBE
   on theButton pressed do 
    (
	  sel = selection as array
	  for s in sel do
	  (
	 	s.position.controller=position_XYZ()
		s.rotation.controller=TCB_Rotation()
	  )
     )
   on theButton2 pressed do
    (
	  sel =selection as array
	  for s in sel do 
	  (
		s.position.controller =position_XYZ() 
		s.rotation.controller =euler_XYZ()
	  )
    )
    on theButton3 pressed do 
     (
	   sel =selection as array 
	   for s in sel do 
	  (
		s.position.controller=position_XYZ()
		s.rotation.controller=TCB_Rotation()
		s.position.controller =position_XYZ() 
	    s.rotation.controller =euler_XYZ()
	  )
     )
    
	 on EulerToTCB resized val do (format "B:%\n" val) 	
  )


   rollout DuiQiA "快速对齐工具"
    (

	
	button DuiQ "快速对齐" pos:[5,10] tooltip:"快速对齐工具" width:245 height:20
	
	 on DuiQ pressed do
       (
	    layerfileD="E:\插件\MAX\DuiQi.ms"
        filein layerfileD 
	   )
     )

  rollout TaXianG "塌陷动画层工具"
    (

	
	 button TaXian "塌陷动画层" pos:[5,10] tooltip:"塌陷动画层工具" width:245 height:20
	
	 on TaXian pressed do
     (
	   layerfileD="E:\插件\MAX\TaXian.ms"
       filein layerfileD 
      )
    )



Shortcut_Animation = newrolloutfloater "宫的动画工具集" 265 660

addrollout AnimationTools shortcut_Animation

addrollout EulerToTCB shortcut_Animation

addrollout DuiQiA  shortcut_Animation

addrollout TaXianG  shortcut_Animation


