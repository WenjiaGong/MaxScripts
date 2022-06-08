--定义节点收集器
  global b1 =#() 
  global b2=#()
 fn gt_9_b1_count =
 (
 if (getCurrentSelection()).count  >0 then 
 (
  gt_bonename =#()
 for i in  (getCurrentSelection()) do 
 (
    append gt_bonename i.name
 ) 
 gt_bonename = sort gt_bonename

 for i in gt_bonename do 
 (
  if getNodeByName i != undefined then 
  (
   temp = getNodeByName i
   append b1 temp
   
  )else
  ( 
   messagebox "选择的节点删除。请从新选择。"
   return false 
  )
  
 )---end for i in gt_bonename do 

 )---end if (getCurrentSelection()).count  >0 then 
)---end gt_9_b1_count 

  
fn gt_2_b2_count =
(
 if (getCurrentSelection()).count  >0 then 
 (
  gt_bonename =#()
 for i in  (getCurrentSelection()) do 
 (
    append gt_bonename i.name
 ) 
 gt_bonename = sort gt_bonename
 for i in gt_bonename do 
 (
  if getNodeByName i != undefined then 
  (
   temp = getNodeByName i
   append b2 temp  
  )else
  (
   messagebox "选择的节点删除。请从新选择。"
   return false 
  )
 
 )---end for i in gt_bonename do 

 )---end if (getCurrentSelection()).count  >0 then 
 )---end gt_2_b2_count 

 ---定义储存节点信息收集器
 global v1=#(),v2=#(),v3=#(),v3_1=#(),v4=#(),v4_1=#(),fan_v1=#(),fan_v2=#(),fan_v3=#(),fan_v3_1=#(),fan_v4=#(),fan_v4_1=#(),v5=#(),y_bone=#()
 global fan_y_bone =#()
 fn gt_9_misscount =
 (
	 if b1.count != b2.count then 
		 (
		  messagebox "对称节点数不一样，操作失败。" title:"盖天编写" 
		  return false 
		 )
v1=#()  
v2=#()   
v3=#()  
v3_1=#() 
v4=#()   
v4_1=#() 
fan_v1=#()
fan_v2=#()
fan_v3=#()
fan_v3_1=#()
fan_v4=#()
fan_v4_1=#()
v5=#()
y_bone =#()
fan_y_bone =#()
		 
 for i in 1 to b1.count do
 (
  if  (try (classof  b1[i][3][2][1].controller!=bezier_float)catch( true))or 
      (try (classof  b2[i][3][2][1].controller!=bezier_float)catch( true))
  then 
	  (
	   messagebox "收集的所以骨骼有控制器不为标准控制器，请改成标准控制器（缺省控制器）。" title:"盖天编写"
	   return false 
	  )
 )----end for 		 
		 
	 for i in 1 to b1.count do
 (
  
  ---x 轴的操作。
  if (b1[i][3][2][1].controller.value +\
   b2[i][3][2][1].controller.value) <=181 and
   (b1[i][3][2][1].controller.value +\
   b2[i][3][2][1].controller.value) >=179
  then
   ( 
    append v3    ("$"+"'"+b1[i].name+"'"+"[3][2][1].controller.value")
    append fan_v3    ("$"+"'"+b2[i].name+"'"+"[3][2][1].controller.value")
    
   )----end if 180 的数组
   
  if (b1[i][3][2][1].controller.value +\
   b2[i][3][2][1].controller.value) <=-179 and 
   (b1[i][3][2][1].controller.value +\
   b2[i][3][2][1].controller.value) >=-181
  then
   ( 
    append v3_1    ("$"+"'"+b1[i].name+"'"+"[3][2][1].controller.value")
    append fan_v3_1    ("$"+"'"+b2[i].name+"'"+"[3][2][1].controller.value")
    
   )----end if 180 的数组
      
   if  (b1[i][3][2][1].controller.value )<1 and 
     (b2[i][3][2][1].controller.value)>-1
   then 
   ( 
    
    append v1   ("$"+"'"+b1[i].name+"'"+"[3][2][1].controller.value")
    append fan_v1   ("$"+"'"+b2[i].name+"'"+"[3][2][1].controller.value")
    
    
   )else                                                       
   ( 
    x_b1 =(b1[i][3][2][1].controller.value ) 
    x_b2 =(b2[i][3][2][1].controller.value ) 
    if (x_b1+x_b2)<=1 and (x_b1+x_b2)>=-1
    then
    (
     append  v1  ("$"+"'"+b1[i].name+"'"+"[3][2][1].controller.value")
     append fan_v1   ("$"+"'"+b2[i].name+"'"+"[3][2][1].controller.value")
     
    )---end 
    if ((x_b1+x_b2)<=179 or  (x_b1+x_b2)>=181)  and ((x_b1-x_b2)<=1 and (x_b1-x_b2)>=-1)    
    then
    (
     append v2  ("$"+"'"+b1[i].name+"'"+"[3][2][1].controller.value")
     append fan_v2  ("$"+"'"+b2[i].name+"'"+"[3][2][1].controller.value")
     
    )---end if 
      
   )---end else 
  -----相加为360 情况。
   
  if (b1[i][3][2][1].controller.value +\
   b2[i][3][2][1].controller.value) <=361 and 
   (b1[i][3][2][1].controller.value +\
   b2[i][3][2][1].controller.value) >=359
  then
   ( 
    append v4    ("$"+"'"+b1[i].name+"'"+"[3][2][1].controller.value")
    append fan_v4    ("$"+"'"+b2[i].name+"'"+"[3][2][1].controller.value")
    
   )----end if 360 的数组
   
        if (b1[i][3][2][1].controller.value +\
   b2[i][3][2][1].controller.value) <=-359 and 
   (b1[i][3][2][1].controller.value +\
   b2[i][3][2][1].controller.value) >=-361
  then
   ( 
    append v4_1    ("$"+"'"+b1[i].name+"'"+"[3][2][1].controller.value")
    append fan_v4_1    ("$"+"'"+b2[i].name+"'"+"[3][2][1].controller.value")
    
   )----end if 360 的数组   
             temp_b1 =(b1[i][3][2][1].controller.value ) 
    temp_b2 =(b2[i][3][2][1].controller.value )   
   if (temp_b1+temp_b2>181 or temp_b1+temp_b2<179  )    and
   (temp_b1+temp_b2 >-179 or temp_b1+temp_b2<-181 )  and
      (temp_b1+temp_b2 >1 or  temp_b1+temp_b2 <-1)      and
   (temp_b1-temp_b2 >1 or  temp_b1-temp_b2 <-1)      and
   (temp_b1+temp_b2 >361 or  temp_b1+temp_b2 <359)   and
   (temp_b1+temp_b2 >-359  or temp_b1+temp_b2<-361)
   then
   (
    append v5    ("$"+"'"+b1[i].name+"'"+"[3][2][1].controller.value")
    
   )
   if v5.count >0 then
   (
    messagebox ("起初的设置有不对称数组。请手动设置写\n
    要让设置的结构 +=180 or+=-180 or+=0 or-=0 or +=360
    +=-360. 该设置控制器为：\n"+("$"+"'"+b1[i].name+"'"+"[3][2][1].controller.value\n")+
     ("$"+"'"+b2[i].name+"'"+"[3][2][1].controller.value"))
     v5=#()
     return false 
   )
  ----////////////////////////////////////////////////////////////////////////////////
  --- 下面就是 y 轴的处理方法 和上面是一样的。 
   
  if (b1[i][3][2][2].controller.value +\
   b2[i][3][2][2].controller.value) <=181 and
   (b1[i][3][2][2].controller.value +\
   b2[i][3][2][2].controller.value) >=179
  then
   ( 
    append v3    ("$"+"'"+b1[i].name+"'"+"[3][2][2].controller.value")
    append fan_v3    ("$"+"'"+b2[i].name+"'"+"[3][2][2].controller.value")
    
   )----end if 180 的数组
  if (b1[i][3][2][2].controller.value +\
   b2[i][3][2][2].controller.value) <=-179 and 
   (b1[i][3][2][2].controller.value +\
   b2[i][3][2][2].controller.value) >=-181
  then
   ( 
    append v3_1    ("$"+"'"+b1[i].name+"'"+"[3][2][2].controller.value")
    append fan_v3_1    ("$"+"'"+b2[i].name+"'"+"[3][2][2].controller.value")
    
   )----end if 180 的数组
   
   if  ((b1[i][3][2][2].controller.value )<1 and (b1[i][3][2][2].controller.value )>-1) and
     ((b2[i][3][2][2].controller.value )<1 and (b2[i][3][2][2].controller.value )>-1) 
   then 
   (
    
    append y_bone   ("$"+"'"+b1[i].name+"'"+"[3][2][2].controller.value")
    append fan_y_bone   ("$"+"'"+b2[i].name+"'"+"[3][2][2].controller.value")
    
    
   )else                                
   ( 
    x_b1 =(b1[i][3][2][2].controller.value ) 
    x_b2 =(b2[i][3][2][2].controller.value ) 
    if (x_b1+x_b2)<=1 and (x_b1+x_b2)>=-1
    then
    (
     append v1   ("$"+"'"+b1[i].name+"'"+"[3][2][2].controller.value")
     append fan_v1   ("$"+"'"+b2[i].name+"'"+"[3][2][2].controller.value")
     
    )---end 
    if ((x_b1+x_b2)<=179 or  (x_b1+x_b2)>=181)  and ((x_b1-x_b2)<=1 and (x_b1-x_b2)>=-1)                                                      
    then
    (
     append v2  ("$"+"'"+b1[i].name+"'"+"[3][2][2].controller.value")
     append fan_v2  ("$"+"'"+b2[i].name+"'"+"[3][2][2].controller.value")
     
    )---end if 
      
   )---end else 
   
  if (b1[i][3][2][2].controller.value +\
   b2[i][3][2][2].controller.value) <=361 and 
   (b1[i][3][2][2].controller.value +\
   b2[i][3][2][2].controller.value) >=359
  then
   ( 
    append v4    ("$"+"'"+b1[i].name+"'"+"[3][2][2].controller.value")
    append fan_v4    ("$"+"'"+b2[i].name+"'"+"[3][2][2].controller.value")
    
   )----end if 360 的数组
   
        if (b1[i][3][2][2].controller.value +\
   b2[i][3][2][2].controller.value) <=-359 and 
   (b1[i][3][2][2].controller.value +\
   b2[i][3][2][2].controller.value) >=-361
  then
   ( 
    append v4_1    ("$"+"'"+b1[i].name+"'"+"[3][2][2].controller.value")
    append fan_v4_1    ("$"+"'"+b2[i].name+"'"+"[3][2][2].controller.value")
    
   )----end if 360 的数组   
             temp_b1 =(b1[i][3][2][2].controller.value ) 
    temp_b2 =(b2[i][3][2][2].controller.value )   
   if (temp_b1+temp_b2>181 or temp_b1+temp_b2<179  )    and
   (temp_b1+temp_b2 >-179 or temp_b1+temp_b2<-181 )  and
      (temp_b1+temp_b2 >1 or  temp_b1+temp_b2 <-1)      and
   (temp_b1-temp_b2 >1 or  temp_b1-temp_b2 <-1)      and
   (temp_b1+temp_b2 >361 or  temp_b1+temp_b2 <359)   and
   (temp_b1+temp_b2 >-359  or temp_b1+temp_b2<-361)
   then
   (
    append v5    ("$"+"'"+b1[i].name+"'"+"[3][2][2].controller.value")
    
   )
   if v5.count >0 then
   (
    messagebox ("起初的设置有不对称数组。请手动设置写\n
    要让设置的结构 +=180 or+=-180 or+=0 or-=0 or +=360
    +=-360. 该设置控制器为：\n"+("$"+"'"+b1[i].name+"'"+"[3][2][2].controller.value\n")+
     ("$"+"'"+b2[i].name+"'"+"[3][2][2].controller.value"))
     v5=#()
     return false 
   )
   
  ----////////////////////////////////////////////////////////////////////////////////
  --- 下面就是 z 轴的处理方法 和上面是一样的。 
   
  if (b1[i][3][2][3].controller.value +\
   b2[i][3][2][3].controller.value) <=181 and
   (b1[i][3][2][3].controller.value +\
   b2[i][3][2][3].controller.value) >=179
  then
   ( 
    append v3    ("$"+"'"+b1[i].name+"'"+"[3][2][3].controller.value")
    append fan_v3    ("$"+"'"+b2[i].name+"'"+"[3][2][3].controller.value")
    
   )----end if 180 的数组

  if (b1[i][3][2][3].controller.value +\
   b2[i][3][2][3].controller.value) <=-179 and 
   (b1[i][3][2][3].controller.value +\
   b2[i][3][2][3].controller.value) >=-181
  then
   ( 
	append v3_1    ("$"+"'"+b1[i].name+"'"+"[3][2][3].controller.value")
    append fan_v3_1    ("$"+"'"+b2[i].name+"'"+"[3][2][3].controller.value")
    
   )----end if 180 的数组
   
   if  (b1[i][3][2][3].controller.value )<1 and 
     (b2[i][3][2][3].controller.value)>-1
   then 
   ( 
    
    append v1   ("$"+"'"+b1[i].name+"'"+"[3][2][3].controller.value")
    append fan_v1   ("$"+"'"+b2[i].name+"'"+"[3][2][3].controller.value")
    
    
   )else    
   ( 
    x_b1 =(b1[i][3][2][3].controller.value ) 
    x_b2 =(b2[i][3][2][3].controller.value ) 
    if (x_b1+x_b2)<=1 and (x_b1+x_b2)>=-1
    then
    (
     append v1   ("$"+"'"+b1[i].name+"'"+"[3][2][3].controller.value")
     append fan_v1   ("$"+"'"+b2[i].name+"'"+"[3][2][3].controller.value")
     
    )---end 
    if ((x_b1+x_b2)<=179 or  (x_b1+x_b2)>=181)  and ((x_b1-x_b2)<=1 and (x_b1-x_b2)>=-1)    
    then
    (
     append v2  ("$"+"'"+b1[i].name+"'"+"[3][2][3].controller.value")
     append fan_v2  ("$"+"'"+b2[i].name+"'"+"[3][2][3].controller.value")
     
    )---end if 
      
   )---end else 
   
  if (b1[i][3][2][3].controller.value +\
   b2[i][3][2][3].controller.value) <=361 and 
   (b1[i][3][2][3].controller.value +\
   b2[i][3][2][3].controller.value) >=359
  then
   ( 
    append v4    ("$"+"'"+b1[i].name+"'"+"[3][2][3].controller.value")
    append fan_v4    ("$"+"'"+b2[i].name+"'"+"[3][2][3].controller.value")
    
   )----end if 360 的数组
   
        if (b1[i][3][2][3].controller.value +\
   b2[i][3][2][3].controller.value) <=-359 and 
   (b1[i][3][2][3].controller.value +\
   b2[i][3][2][3].controller.value) >=-361
  then
   ( 
    append v4_1    ("$"+"'"+b1[i].name+"'"+"[3][2][3].controller.value")
    append fan_v4_1    ("$"+"'"+b2[i].name+"'"+"[3][2][3].controller.value")
    
   )----end if 360 的数组   
             temp_b1 =(b1[i][3][2][3].controller.value ) 
    temp_b2 =(b2[i][3][2][3].controller.value )   
   if (temp_b1+temp_b2>181 or temp_b1+temp_b2<179  )    and
   (temp_b1+temp_b2 >-179 or temp_b1+temp_b2<-181 )  and
      (temp_b1+temp_b2 >1 or  temp_b1+temp_b2 <-1)      and
   (temp_b1-temp_b2 >1 or  temp_b1-temp_b2 <-1)      and
   (temp_b1+temp_b2 >361 or  temp_b1+temp_b2 <359)   and
   (temp_b1+temp_b2 >-359  or temp_b1+temp_b2<-361)
   then
   (
    append v5    ("$"+"'"+b1[i].name+"'"+"[3][2][3].controller.value")
    
   )  
   if v5.count >0 then
   (
    messagebox ("起初的设置有不对称数组。请手动设置写\n
    要让设置的结构 +=180 or+=-180 or+=0 or-=0 or +=360
    +=-360. 该设置控制器为：\n"+("$"+"'"+b1[i].name+"'"+"[3][2][3].controller.value\n")+
     ("$"+"'"+b2[i].name+"'"+"[3][2][3].controller.value"))
     v5=#()
     return false 
   )
  
  
 )----end for add v LEI Array 	 

 )---end gt_9_misscount
 fn gt_9_danBonePos =
(  
 if v1.count > 0 then
 (
   for i in 1 to  v1.count  do 
   (
    op = execute(v1[i])

     op= 0-op
      execute (fan_v1[i]+"="+op as string) 
   )
  )

 if v2.count >0 then
 (
   for i in 1 to  v2.count  do 
   (
     op = execute(v2[i])
     op= 0+op
      execute (fan_v2[i]+"="+op as string) 
   )
  )

  if v3.count>0 then
 (
   for i in 1 to  v3.count  do 
   (
    op = execute(v3[i])
     op= 180-op
      execute (fan_v3[i]+"="+op as string)
   )
  )
  
  
    if v3_1.count>0 then
 (
   for i in 1 to  v3_1.count  do 
   (
       op = execute(v3_1[i])
     op= -180-op
      execute (fan_v3_1[i]+"="+op as string) 
   )
  )
 
    if v4.count >0 then
 (
   for i in 1 to  v4.count  do 
   (
        op = execute(v4[i])
     op= 360-op
      execute (fan_v4[i]+"="+op as string) 
   )
  )
 
  if v4_1.count >0 then
 (
   for i in 1 to  v4_1.count  do 
   (
        op = execute(v4_1[i])
     op= -360-op
      execute (fan_v4_1[i]+"="+op as string) 
   )
  )
    if y_bone.count >0 then
 (
   for i in 1 to  y_bone.count  do 
   (
        op = execute(y_bone[i])
      execute (fan_y_bone[i]+"="+op as string) 
   )
  )
  
 
  
) --end gt_9_danBonePos
---2011.8.15 雏形 ---主要在2011.8.13 -8.14 想 与制作。

rollout gt_9_BoneMIss "骨骼动作镜像工具" width:244 height:339
(
	groupBox grp1 "主动镜像" pos:[6,7] width:104 height:65
	groupBox grp2 "被动镜像" pos:[125,7] width:104 height:65
	button zhu_btn "没有定义" pos:[14,28] width:80 height:29
	button bie_btn "没有定义" pos:[134,28] width:80 height:29
	button fn_btn "映射镜像数据" pos:[4,84] width:228 height:29
	groupBox grp3 "以xyz为镜像轴向的方案" pos:[8,123] width:228 height:150
	button pos_btn "pos镜像" pos:[18,144] width:80 height:29
	button TA_Animation_btn "塌陷动画数据" pos:[108,145] width:113 height:29
	spinner start_spn "开始帧数：" pos:[100,184] width:120 height:16 range:[-99999999,99999999,0] type:#integer
	spinner end_spn "结束帧数：" pos:[100,204] width:120 height:16 range:[-99999999,999999999,100] type:#integer
	spinner CAIYAND_spn1 "采样：" pos:[118,224] width:102 height:16 range:[1,50,2] type:#integer
	 progressbar doit_prog  color:red
	
      local tm = 60
	label lab1 "注意：偶尔在镜像的时候数据不统一"pos:[7,218+tm]
	label lab2    " 请根据提示操作。"  pos:[7,238+tm]
	hyperLink help  "使用工具的方法连接"  pos:[60,258+tm]  color:(color 255 0 0)  hoverColor:(color 0 255 255) address:""

	
	groupBox grp4 "以z为镜像轴向的方案"  width:228 height:86 visible:false--
	
	button Zpps_btn "pos镜像" pos:[17,239] width:80 height:29 visible:false
	button Zpos_Animation_btn "塌陷动画数据" pos:[107,239] width:113 height:29 visible:false
	spinner CAIYAND_spn2 "采样：" pos:[115,279] width:102 height:16 range:[1,50,2] type:#integer visible:false
	


	
	
	local gt_9_contrl = #(grp2,bie_btn,fn_btn,grp3,pos_btn,TA_Animation_btn,CAIYAND_spn1,grp4,Zpps_btn,Zpos_Animation_btn,CAIYAND_spn2,start_spn,end_spn)
	on zhu_btn pressed do 
	(	
		try(
		b1 =#()
	    gt_9_b1_count()
			
			if b1.count >0 then
			(
			zhu_btn.text ="主动镜像启动"	
			gt_9_contrl[1].enabled =true 
			gt_9_contrl[2].enabled =true 
			)---end if b1.count >0 then
			
			
		)catch("遇到不知道的错误。")
		
	
    )---end on zhu_btn pressed do 
	on bie_btn pressed do
	(
		try(
		b2 =#()
		gt_2_b2_count()
		if b2.count >0 then
        (	
         bie_btn.text ="被动镜像启动"
			
		gt_9_contrl[3].enabled =true 
		)
			
		)catch("遇到不知道的错误。")
		
	)---end on bie_btn pressed do
	
	on fn_btn pressed do
	(
		try(
		gt_9_misscount()
			for i in 4 to gt_9_contrl.count do
			(
				gt_9_contrl[i].enabled =true 
				
			)
			
			
		)catch("遇到不知道的错误。")
		
	)---end on fn_btn pressed do
	on pos_btn pressed do
	(
		try(
		gt_9_danBonePos()
		)catch("遇到不知道的错误。")
		
	)---end on fn_btn pressed do
	on TA_Animation_btn  pressed do
	(
		try(
			if end_spn.value - start_spn.value <0 then
			(
				messagebox "结束帧数不能小于开始帧数，请从新调整。"title:"盖天编写"
				return false
			)else
			(
				if (end_spn.value - start_spn.value)/CAIYAND_spn1.value==0 then
				(
					messagebox "采样数比帧的范围要大，不成立，请重新调整参数。" title:"盖天编写"
					return false
				)
				
			)
			
			animationRange =(interval start_spn.value  end_spn.value)
			sliderTime =start_spn.value
			timep =(end_spn.value - start_spn.value)/CAIYAND_spn1.value 
			with animate on

			(  
				temp =start_spn.value
				for i in 1 to timep  do 
				(

			      at time (temp+=CAIYAND_spn1.value) gt_9_danBonePos()
                   doit_prog.value = 100.*i/timep
			   )

			)
 	
			doit_prog.value = 0
		)catch("遇到不知道的错误。")
		
	)---end on fn_btn pressed do
	
	on start_spn  entered do 
	(
		if start_spn.value >= end_spn.value then
		(
			end_spn.value =start_spn.value
		)
	)
	
	on gt_9_BoneMIss open do
	(
		
		for i in gt_9_contrl do
		(
			i.enabled =false
		)
		
	)----end  gt_9_BoneMIss open 
	
	

	
	
)
 try ( closeRolloutFloater gt_9_theNewFloater)catch()
 gt_9_theNewFloater = newRolloutFloater "盖天（动画镜像）工具" 250 370 

addRollout gt_9_BoneMIss gt_9_theNewFloater

