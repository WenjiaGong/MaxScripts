/*
* name：从bone骨骼拷贝动画到bip骨骼
* write by：戴剑峰 (singlerdjf@foxmail.com)
* last modify：2016-2-22
* note：也可以从任意骨骼/几何体/虚拟对象，拷贝到任意骨骼/几何体/虚拟对象
*/
ver="1.2"
savepath=(getfilenamepath (getThisScriptFilename()))
fileext=@"ini"
delimiter="|"

mstrchs=#(\
#(1,"bip动画转换",""),\
#(2,"A","获取当前动画帧范围"),\
#(3,"设置目标骨骼",""),\
#(4,"刷新",""),\
#(5,"选择源骨骼",""),\
#(6,"设置源骨骼",""),\
#(7,"<-✓->","添加关联"),\
#(8,"<-X->","删除关联"),\
#(9," ↓ ","关联并顺序移到下一对"),\
#(10,"同步选择场景节点","设置关联时，同步选择场景中的物体"),\
#(11,"拷贝根节点位置",""),\
#(12,"拷贝根节点旋转",""),\
#(13,"开始帧：",""),\
#(14,"结束帧：",""),\
#(15,"拷贝姿势",""),\
#(16,"拷贝动画",""),\
#(17,"关于...",""),\
#(18,"支持任意骨骼/几何体/虚拟对象之间的动画拷贝",""),\
#(19,"1、拷贝不要求源和目标结构完全对应，可以只搭一个大概的形式，可以只拷贝部分，比如只拷贝手部动画。如果骨骼不完全一致，动画会有变形。",""),\
#(20,"2、目标物体和源的局部坐标方向要一致。",""),\
#(21,"有问题可以邮件联系wels(singlerdjf@foxmail.com)",""),\
#(22,"请选择一个物体",""),\
#(23,"保存","保存对应关系到文件"),\
#(24,"读取","从文件读取对应关系"),\
#(25,"当前配置为空",""),\
#(26,"文件另存为",""),\
#(27,"读取配置文件",""),\
#(28,"配置文件",""),\
#(29,"源|目标","")\
)
mstren=#(\
#(1,"Copy Boneanimation to BiP",""),\
#(2,"A","get the current timeline range"),\
#(3,"setTarget",""),\
#(4,"Refresh", ""),\
#(5,"selectSource", ""),\
#(6,"setSource", ""),\
#(7,"<--->", "add a linkage"),\
#(8,"<-X->", "delete a linkage"),\
#(9," ↓ ", "add a linkage, and move the cursor to the next"),\
#(10,"synchronized selection", ""),\
#(11,"copy rootnode position", ""),\
#(12,"copy rootnode rotation", ""),\
#(13,"start frame", ""),\
#(14,"end frame  ", ""),\
#(15,"copy posture", ""),\
#(16,"copy animation", ""),\
#(17,"about...",""),\
#(18,"It supports animated copies between bones / geometrys / virtual objects",""),\
#(19,"1- does not require the source and target structure corresponds exactly, can take only a rough form, you can only copy parts, such as copy only hand animation. If the bone is not exactly the same, there will be animation deformation.",""),\
#(20,"2- Local coordinate direction of the target object and the source to be consistent.",""),\
#(21,"Problems can e-mail contact wels(singlerdjf@foxmail.com)",""),\
#(22,"must select one object",""),\
#(23,"Save","Save configure to file"),\
#(24,"Load","Load configure from file"),\
#(25,"No link configure",""),\
#(26,"Save for",""),\
#(27,"Load form a file",""),\
#(28,"configure file",""),\
#(29,"src|dst","")\
)

lang=sysinfo.getmaxlanguage()
mstr=mstren
try
(
	if lang[3]=="CHS"then mstr=mstrchs
		else mstr=mstren
)
catch(mstr=mstren)
	
Animtoolboxname=mstr[1][2]

try(destroydialog Anim_toolbox_rollout)catch()
try(destroydialog about_rollout)catch()

fn setBonepos dstBone pos=
(
	if classof dstBone == Biped_Object then
	(
		biped.setTransform dstBone #pos pos true
	)
	else
	(
		try
		(
			ttf=dstBone.transform
			ttf.pos=pos
			dstBone.transform=ttf
		)
		catch()		
	)
)

fn copyposerotate srcBone dstBone=
(
	local  srcBone,dstBone
	
	if classof dstBone == Biped_Object then
	(
		biped.setTransform dstBone #rotation srcBone.transform.rotation true
	)
	else
	(
		try
		(
			ttf=dstBone.transform
			ttf.rotation=srcBone.transform.rotation
			ttf.pos=dstBone.transform.pos
			dstBone.transform=ttf
		)
		catch()		
	)
)

rollout about_rollout mstr[1][2]  width:256 height:260
(
	GroupBox grp mstr[1][2] pos:[8,8] width:240 height:240
	label lbl1 mstr[18][2] pos:[16,30] width:224 height:40
	label lbl2 mstr[19][2] pos:[16,70] width:224 height:90
	label lbl3 mstr[20][2] pos:[16,160] width:224 height:40
	label lbl4 mstr[21][2] pos:[16,200] width:224 height:30
)

rollout Anim_toolbox_rollout (Animtoolboxname+" V"+ver)
(
	button setdst mstr[3][2] pos:[20,10] width:80 height:30
	button refresh mstr[4][2] pos:[110,10] width:60 height:30
	dotNetControl tvdst "System.Windows.Forms.TreeView" pos:[20,50] width: 250 height:300
	button setsrc mstr[6][2] pos:[330,10] width:80 height:30
	dotNetControl tvsrc "TreeView" pos:[330,50] width: 200 height:300
	button savelink mstr[23][2] toolTip:mstr[23][3] pos:[280,80] width:40 height:30
	button loadlink mstr[24][2] toolTip:mstr[24][3] pos:[280,120] width:40 height:30
	button addlink mstr[7][2] toolTip:mstr[7][3] pos:[280,160] width:40 height:30
	button dellink mstr[8][2] toolTip:mstr[8][3] pos:[280,200] width:40 height:30
	button nextautolink mstr[9][2] toolTip:mstr[9][3] pos:[280,240] width:40 height:30

	checkbox syncselect mstr[10][2] checked:true pos:[40,370]
	checkbox poscpck mstr[11][2] checked:true pos:[200,370]
	checkbox roacpck mstr[12][2] checked:true pos:[200,390]
	spinner framestart mstr[13][2] type:#integer range:[-9999,9999,0] pos:[390,370]  width:100 height:30
	spinner frameend mstr[14][2] type:#integer range:[-9999,9999,0] pos:[390,390]  width:100 height:30
	button getanimrange mstr[2][2] toolTip:mstr[2][3] pos:[495,390] width:16 height:16
	
	button cppose mstr[15][2] pos:[120,420] width:100 height:30
	button cpanim mstr[16][2] pos:[300,420] width:100 height:30
	button showabout mstr[17][2] pos:[460,420] width:60 height:30

	
	fn addchild thenode thobj=
	(
		local thenode,newnode,thobj
		dataary=#(thobj.name,thobj,undefined)
		newnode=thenode.Nodes.add thobj.name
		newnode.tag=dotNetMXSValue dataary
		--format "%\n" newnode.FullPath
		for child in thobj.children do addchild newnode child		
	)
	
	fn initTV tv obj=
	(
		tv.BeginUpdate()
		tv.Nodes.clear()
		addchild tv obj
		--theRoot.BackColor=(dotNetClass "System.Drawing.Color").red
		--theRoot.BackColor=tv.BackColor
		tv.ExpandAll()
		tv.EndUpdate()
		tv.SelectedNode=tv.Nodes.Item[0]
		
	)
	
	fn getlinkary=
	(
		nodeary=(for i=0 to tvdst.nodes.count-1 collect tvdst.nodes.Item[i])
		for cnode in  nodeary do join nodeary (for i=0 to cnode.nodes.count-1 collect cnode.nodes.Item[i])
		
		linkary=#()
		for i= 1 to nodeary.count do 
		(
			dataary=nodeary[i].tag.value
			if dataary[3]!=undefined then
			(
				append linkary #(dataary[2],dataary[3])
			)
		)
		return linkary
	)
	
	on setsrc pressed do
	(
		if $selection.count==1 then
		(
			if isValidNode $selection[1] do initTV tvsrc $selection[1]
		)
		else
		(
			messagebox mstr[22][2]
		)
	)	
	
	on setdst pressed do
	(
		if $selection.count==1 then
		(
			if isValidNode $selection[1] do initTV tvdst $selection[1]
		)
		else
		(
			messagebox mstr[22][2]
		)		
	)	
	
	on addlink pressed do
	(
		if tvdst.SelectedNode==undefined or tvsrc.SelectedNode==undefined then return false
		dstary=tvdst.SelectedNode.tag.value
		srcary=tvsrc.SelectedNode.tag.value
		tvdst.SelectedNode.text=dstary[1]+" ["+srcary[1]+"]"
		dstary[3]=srcary[2]
		tvdst.SelectedNode.tag=dotNetMXSValue dstary
		tvdst.SelectedNode.ForeColor=(dotNetClass "System.Drawing.Color").Green
	)

	on dellink pressed do
	(
		if tvdst.SelectedNode==undefined then return false
		dstary=tvdst.SelectedNode.tag.value
		tvdst.SelectedNode.text=dstary[1]
		dstary[3]=undefined
		tvdst.SelectedNode.tag=dotNetMXSValue dstary
		tvdst.SelectedNode.ForeColor=tvdst.ForeColor
	)
	
	on getanimrange pressed do
	(
		framestart.value=AnimationRange.start
		frameend.value=AnimationRange.end
	)
	
	on Anim_toolbox_rollout open do
	(
		tvsrc.ShowLines=tvdst.ShowLines=true
		tvsrc.HideSelection=tvdst.HideSelection=false
		--tvsrc.Indent=tvdst.Indent=8
		--tvsrc.BackColor=tvdst.BackColor=(dotNetClass "System.Drawing.Color").DimGray
		framestart.value=AnimationRange.start
		frameend.value=AnimationRange.end
	)
	
	on cppose pressed do
	(
		try
		(
			linkary=getlinkary()
			if linkary.count==0 then return false
			
			with Animate on
			(
				if roacpck.checked==true then
				(
					ary=linkary[1]
					copyposerotate ary[2] ary[1]
				)

				for i=2 to linkary.count do
				(
					ary=linkary[i]
					copyposerotate ary[2] ary[1]
				)
			)
		)
		catch
		(
			messagebox (getCurrentException())
		)
		
	)
	
	on cpanim pressed do
	(
		try(		
			linkary=getlinkary()
			if linkary.count==0 then return false

			tstart=framestart.value
			tend=frameend.value
			
			AnimationRange=interval tstart tend
			slidertime=tstart
			
			srcBone=linkary[1][2]
			destBone=linkary[1][1]
			srcBoneinitpos=srcBone.transform.pos
			destBoneinitpos=destBone.transform.pos

			with Animate on
			(
				for i=tstart to tend do
				(
					slidertime=i	
					
					if poscpck.checked==true then
					(
						destBonepos=srcBone.transform.pos-srcBoneinitpos+destBoneinitpos
						setBonepos destBone destBonepos
					)
					if roacpck.checked==true then
					(
						ary=linkary[1]
						copyposerotate ary[2] ary[1]
					)				
					
					for j=2 to linkary.count do
					(
						--at time (i as time)
						(
							ary=linkary[j]
							copyposerotate ary[2] ary[1]
						)
					)
				)
			)
		)
		catch
		(
			messagebox (getCurrentException())
		)
	)
	
	fn selectNoderefObj EventArg=
	(
		if EventArg.Node==undefined then return false
		dstary=EventArg.Node.tag.value
		try(select dstary[2])catch(max select none)			
	)

	on tvsrc Click EventArg do
	(
		if syncselect.checked==true and tvsrc.SelectedNode!=undefined then
		(
			selectNoderefObj (dotNetObject "System.Windows.Forms.TreeViewEventArgs" tvsrc.SelectedNode)
		)
	)
	
	on tvdst Click EventArg do
	(
		if syncselect.checked==true and tvdst.SelectedNode!=undefined then
		(
			selectNoderefObj (dotNetObject "System.Windows.Forms.TreeViewEventArgs" tvdst.SelectedNode)
		)
	)
	
	on tvsrc AfterSelect EventArg do
	(
		if syncselect.checked==true then selectNoderefObj EventArg
	)
	
	on tvdst AfterSelect EventArg do
	(
		if syncselect.checked==true then selectNoderefObj EventArg		
	)
	
	on nextautolink pressed do
	(
		Windows.sendMessage addlink.hwnd[1] 0x0201 0 0 --发送左键按下消息
		Windows.sendMessage addlink.hwnd[1] 0x0202 0 0 --发送左键抬起消息
		try
		(
			if tvdst.SelectedNode.NextVisibleNode!=undefined  and tvsrc.SelectedNode.NextVisibleNode!=undefined then
			(
				tvdst.SelectedNode=tvdst.SelectedNode.NextVisibleNode
				tvsrc.SelectedNode=tvsrc.SelectedNode.NextVisibleNode
			)
		)
		catch()
	)
	
	on refresh pressed do
	(
		try
		(
			obj=tvdst.Nodes.Item[0].tag.value[2]
			if isValidNode obj do initTV tvdst obj
		)
		catch()
	)
	
	on savelink pressed do
	(
		try
		(
			linkary=getlinkary()
			if linkary.count==0 then
			(
				messagebox mstr[25][2]
				return false
			)
			savefilepath=getSaveFileName  caption:mstr[26][2] filename:(savepath+"") types:(mstr[28][2]+"(*."+fileext+")|*."+fileext+"|")
			if savefilepath==undefined then return false
				
			fp=openfile savefilepath mode:"wt"
			format "%\r\n" mstr[29][2] to:fp
			for i=1 to linkary.count do
			(
				format "%%%\r\n" linkary[i][2].name delimiter linkary[i][1].name to:fp			
			)
			close fp
			return true
		)
		catch
		(
			messagebox (getCurrentException())
		)
	)

	on loadlink pressed do
	(
		try
		(
			loadfilepath = getOpenFileName caption:mstr[27][2] filename:(savepath+"") types:(mstr[28][2]+"(*."+fileext+")|*."+fileext+"|")
			if loadfilepath==undefined then return false
				
			linkary=#()
			fp=openFile loadfilepath mode:"rt"
			if not eof fp do readline fp
			while not eof fp do
			(
				actstr=trimRight(trimLeft(readline fp))
				s=filterString actstr delimiter
				if s.count==2 then
				(
					src=getnodebyname s[1]
					dst=getnodebyname s[2]
					if src!=undefined and dst!=undefined then
					(
						append linkary #(src,dst)
					)
				)		
			)
			close fp
			
			if tvdst.nodes.count==0 then
			(
				initTV tvdst linkary[1][2]
			)
			
			nodeary=(for i=0 to tvdst.nodes.count-1 collect tvdst.nodes.Item[i])
			for cnode in  nodeary do join nodeary (for i=0 to cnode.nodes.count-1 collect cnode.nodes.Item[i])
			
			for i= 1 to nodeary.count do 
			(
				dataary=nodeary[i].tag.value
				
				for j=1 to linkary.count do
				(
					if dataary[1]==linkary[j][2].name then
					(
						dataary[3]=linkary[j][1]
						nodeary[i].text=dataary[1]+" ["+dataary[3].name+"]"
						nodeary[i].tag=dotNetMXSValue dataary
						nodeary[i].ForeColor=(dotNetClass "System.Drawing.Color").Green
						break
					)
				)
			)
		)
		catch
		(
			messagebox (getCurrentException())
		)	
		
	)

	on showabout pressed do
	(
		createDialog about_rollout modal:true
	)
)

createDialog Anim_toolbox_rollout width:550 height:460
