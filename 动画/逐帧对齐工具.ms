rollout duiqigongju "对齐工具" width:162 height:110
(
	spinner kaishifanwei "" pos:[11,6] width:60 height:16 enabled:true range:[0,1000,0] type:#integer
	spinner jieshufanwei "到" pos:[83,6] width:65 height:16 enabled:true range:[0,1000,100] type:#integer
	radiobuttons duiqifanweizhen "" pos:[13,26] width:65 height:32 enabled:true labels:#("全部帧", "范围帧") default:1 columns:1
	pickbutton btn17 "对齐" pos:[79,31] width:71 height:26
	
	label lbl1 "1、选择无动画的物体。      2、点击对齐按钮。            3、选择有动画的物体。" pos:[6,61] width:155 height:45
	
	
	
	on duiqigongju open  do
	(
		kaishifanwei.range=[0,1000,animationrange.start]
	    jieshufanwei.range=[0,1000,animationrange.end]
	)
	on btn17 picked obj do
	(
		undo on
	   (
		    beishiqu=obj
		    if selection.count ==0 then 
		    (
		    	messagebox "选择一个要对齐的物体" beep:false
		    )
	    	else
	    	(
				if duiqifanweizhen.state == 1 then
				(
					start_time= animationrange.start
					end_time = animationrange.end
				)else 
					(
						start_time= kaishifanwei.value
						end_time = jieshufanwei.value
					)
				for xuanzewuti in selection do
			 	(
	    	    	for t=start_time to end_time  do
	    	    	(
	    	    		animate on
	    	    		at time t
	    	    		(
		        			for i in selection do
		        			(
			        			i.transform =beishiqu.transform
		        			)
		    	    	)
	  	        	)  
			    )                
		    )
		)
	)
)
createdialog duiqigongju