-- 作者：东见云
-- v1
-- 测试版本: max 2016
-- bug反馈:yun7928903@163.com

-----------界面开始
try destroydialog yunRotLock catch()
rollout yunRotLock "旋转助手" width:160  (
	
global time_changeCheck  = false
global youRotLock_A_date = undefined
global youRotLock_A_obj = undefined

global youRotLock_B_date = undefined
global youRotLock_B_obj = undefined
global youRotLock_C_date = undefined
global youRotLock_C_obj= undefined
	
fn dotQuat q q_prev =
( 
   (q.w * q_prev.w + q.x * q_prev.x + q.y * q_prev.y + q.z * q_prev.z) < 0 
)
------bip和bone双支持
fn yun_rotation_biporBone rot_input obj =( 	
	if obj!=undefined do (
	if classof obj==Biped_Object then (
		try (biped.setTransform  obj #rotation rot_input true) catch()
	)
	else (obj.rotation = rot_input)
	)
)
------bip和bone双支持设置位移
fn yun_position_biporBone pos_input obj =( 	
	if obj!=undefined do (
	if classof obj==Biped_Object then (
		try (biped.setTransform  obj #pos pos_input true) catch()
	)
	else (obj.position = pos_input)
	)
)
------获取旋转
fn yun_rotation_biporBone_get  obj =( 	
	rotationDate = undefined
	if obj!=undefined do (
	if classof obj==Biped_Object then (
		rotationDate =  biped.getTransform  obj #rotation  
	)
	else (rotationDate =   obj.rotation)
	)
	rotationDate
)
---排序数组
fn sortArrayByHeirarchy objectArray =( 
  sortedArray=#()
  childArray=#()
  -- first find roots and put them at left
  for obj in objectArray do(
	if (finditem objectArray obj.parent) == 0 
	  then append sortedArray obj
	  else append childArray obj  
  )
  -- now insert children on immediate right of their parents
  -- repeat scan until child array is empty
  while childArray.count > 0  do(
	i=1
	while i <= childArray.count do(
	  parentIdx = finditem sortedArray childArray[i].parent
	  if parentIdx != 0 then(
		insertItem childArray[i] sortedArray (parentIdx+1) 
		deleteItem childArray i
	 ) 
	  else(
		 i += 1  
	  )
	)
  )
  sortedArray
)	
--------锁定旋转用的功能函数
fn youRotLock_A_exc = (
	if time_changeCheck==false then (
	with undo off(		  
		if youRotLock_A_obj!=undefined then  (
			yun_rotation_biporBone youRotLock_A_date youRotLock_A_obj
		)
	))
	time_changeCheck  = false
)
fn youRotLock_B_exc = (
	if time_changeCheck==false then (
	with undo off(		  
		if youRotLock_B_obj!=undefined then  (	
			yun_rotation_biporBone youRotLock_B_date youRotLock_B_obj	
		)
	))
	time_changeCheck  = false
)

----时间检查，多套一层是为了方便修改
fn timeCheck = (time_changeCheck  = true)
fn  timeFn  = timeCheck()


----------注销视图条件的旋转回调
fn unregisterYunLockCallbacks = (
	yunRotLock.yunRL_A.text = "##############"
-- 	yunRotLock.yunRL_B.text = "##############"
	try(unRegisterRedrawViewsCallback youRotLock_A_exc)catch()
	try(unRegisterRedrawViewsCallback youRotLock_B_exc)catch()
)



------------------------------------------------------------------------------------------------------------------------
	groupBox 'bipRotLock' "____旋转锁定工具____" pos:[3,8] width:152 height:80 align:#left
	button yunRL_A "##############" align: #left checked:false  pos:[15,28] width:130 tooltip:"右键或者拖时间轴都可以取消锁定（○｀ 3′○）"
-- 	button yunRL_B "##############" align: #left checked:false  pos:[15,58] width:130	tooltip:"右键或者拖时间轴都可以取消锁定（○｀ 3′○）"
	button yunRL_setUp "↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑" align: #left checked:false  pos:[15,58] width:130	tooltip:"右键或者拖时间轴都可以取消锁定（○｀ 3′○）"

	groupBox 'bonChainRotLock' "_______顺滑骨链______" pos:[3,100] width:152 height:70 align:#left
	button yunRL_boneChainSmooth_A "顺" align: #left checked:false  pos:[15,125] height:35 width:60
	button yunRL_boneChainSmooth_B "逆" align: #left checked:false  pos:[85,125] height:35 width:60


	on yunRotLock open do (
		try(unRegisterTimeCallback timeFn)catch()
		registerTimeCallback timeFn
	)



	on yunRL_A pressed do (
		yunRL_A.text = selection[1].name
		youRotLock_A_obj = getNodeByName yunRotLock.yunRL_A.text	
		youRotLock_A_date = biped.getTransform  youRotLock_A_obj #rotation 
		----锁定旋转的回调	
		try(unRegisterRedrawViewsCallback youRotLock_A_exc)catch()
		registerRedrawViewsCallback youRotLock_A_exc
		-----拖之间轴自动关闭锁定回吊
		try(unRegisterTimeCallback unregisterYunLockCallbacks)catch()
		registerTimeCallback unregisterYunLockCallbacks		
	)	
-- 	on yunRL_B pressed do (
-- 		yunRL_B.text = selection[1].name
-- 		youRotLock_B_obj = getNodeByName yunRotLock.yunRL_B.text	
-- 		youRotLock_B_date = biped.getTransform  youRotLock_B_obj #rotation 
-- 		----锁定旋转的回调	
-- 		try(unRegisterRedrawViewsCallback youRotLock_B_exc)catch()
-- 		registerRedrawViewsCallback youRotLock_B_exc
-- 		-----拖之间轴自动关闭锁定回吊
-- 		try(unRegisterTimeCallback unregisterYunLockCallbacks)catch()
-- 		registerTimeCallback unregisterYunLockCallbacks
-- 	)
	on yunRL_setUp pressed do (
		chrildrenGet = selection[1].children
		if chrildrenGet[1]!= undefined then (
			yunRL_A.text = chrildrenGet[1].name
			youRotLock_A_obj = getNodeByName yunRotLock.yunRL_A.text	
			youRotLock_A_date = biped.getTransform  youRotLock_A_obj #rotation 
			----锁定旋转的回调	
			try(unRegisterRedrawViewsCallback youRotLock_A_exc)catch()
			registerRedrawViewsCallback youRotLock_A_exc
			-----拖之间轴自动关闭锁定回吊
			try(unRegisterTimeCallback unregisterYunLockCallbacks)catch()
			registerTimeCallback unregisterYunLockCallbacks			
		)
	)

	on yunRL_A rightclick do (
		yunRL_A.text = "##############"
		
		youRotLock_A_date = undefined
		youRotLock_A_obj = undefined	
		unregisterYunLockCallbacks()
	)
-- 	on yunRL_B rightclick do (
-- 		youRotLock_B_date = undefined
-- 		youRotLock_B_obj = undefined	
-- 					
-- 		unregisterYunLockCallbacks()	
-- 	)
	
	on yunRL_setUp rightclick do (
		yunRL_A.text = "##############"
		
		youRotLock_A_date = undefined
		youRotLock_A_obj = undefined	
		unregisterYunLockCallbacks()
	)
		
	
	on yunRL_boneChainSmooth_A pressed do (	 
		----正常排序
		heirAr = #()
		heirAr =  sortArrayByHeirarchy (selection as array)
		rot_first =  heirAr[1].transform.rotationpart
		rot_last = heirAr[heirAr.count].transform.rotationpart
		if (dotQuat rot_first rot_last) do rot_first *=-1
		with undo on(	
		for i=2 to  (heirAr.count-1) do (
			rr = slerp rot_first rot_last ((1.0/(heirAr.count-1))*(i-1))
			pos = heirAr[i].transform.pos ---记录当前位置
			rot_next = yun_rotation_biporBone_get heirAr[i+1]	
			yun_rotation_biporBone  rr heirAr[i]
			yun_position_biporBone pos  heirAr[i]
			pos_next = heirAr[i+1].transform.pos 			---恢复当前位置之后，再次记录下一层位置
			yun_rotation_biporBone rot_next heirAr[i+1]
			yun_position_biporBone pos_next heirAr[i+1] 
		)		
		)
		
	)
	
		on yunRL_boneChainSmooth_B pressed do (			
		----正常排序
		heirAr = #()
		heirAr =  sortArrayByHeirarchy (selection as array)
		rot_first = yun_rotation_biporBone_get heirAr[1]
		rot_last =  yun_rotation_biporBone_get heirAr[heirAr.count]	
		with undo on(	
		for i=2 to  (heirAr.count-1) do (
			rr = slerp rot_first rot_last ((1.0/(heirAr.count-1))*(i-1))
			pos = heirAr[i].transform.pos ---记录当前位置
			rot_next = yun_rotation_biporBone_get heirAr[i+1]	
			yun_rotation_biporBone  rr heirAr[i]
			yun_position_biporBone pos  heirAr[i]
			pos_next = heirAr[i+1].transform.pos 			---恢复当前位置之后，再次记录下一层位置
			yun_rotation_biporBone rot_next heirAr[i+1]
			yun_position_biporBone pos_next heirAr[i+1] 
		)		
		)
		
	)		
	
	
	
	
	
	
	
	
	
	
	
	on yunRotLock close do (
		unregisterYunLockCallbacks()
		try(unRegisterTimeCallback timeFn)catch()
		try(unRegisterTimeCallback unregisterYunLockCallbacks)catch()
	)
)
createdialog yunRotLock   style:#(#style_sysmenu, #style_toolwindow)  
-- createdialog yunRotLock  pos:[325,150] style:#(#style_sysmenu, #style_toolwindow)  