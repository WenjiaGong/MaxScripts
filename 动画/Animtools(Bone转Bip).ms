/*
* name：从bone骨骼拷贝动画到bip骨骼
* write by：戴剑峰 (singlerdjf@foxmail.com)
* last modify：2016-2-1
* note：也可以从任意骨骼、几何体，拷贝到任意骨骼、几何体
*/

Animtoolboxname="bip动画转换 V1.0"

try(destroydialog Anim_toolbox_rollout)catch()

fn setBonepos dstBone pos=
(
	if classof dstBone == Biped_Object then
	(
		biped.setTransform dstBone #pos pos true
	)
	else if classof dstBone == CATBone then
	(
		
	)
	else
	(
		try
		(
			dstBone.pos=pos
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
	else if classof dstBone == CATBone then
	(
		
	)
	else
	(
		try
		(
			dstBone.rotation.x_rotation=srcBone.rotation.x_rotation
			dstBone.rotation.y_rotation=srcBone.rotation.y_rotation
			dstBone.rotation.z_rotation=srcBone.rotation.z_rotation
		)
		catch()
	)	
)

rollout Anim_toolbox_rollout Animtoolboxname
(
	pickbutton pickdst "选择目标骨骼" pos:[20,10] width:80 height:30
	button setdst "设置目标骨骼" pos:[110,10] width:80 height:30
	button refresh "刷新" pos:[200,10] width:40 height:30
	dotNetControl tvdst "System.Windows.Forms.TreeView" pos:[20,50] width: 250 height:300
	pickbutton picksrc "选择源骨骼" pos:[330,10] width:80 height:30
	button setsrc "设置源骨骼" pos:[420,10] width:80 height:30
	dotNetControl tvsrc "TreeView" pos:[330,50] width: 200 height:300
	button addlink "<--->" toolTip:"添加关联" pos:[280,160] width:40 height:30
	button dellink "<-X->" toolTip:"删除关联" pos:[280,200] width:40 height:30
	button nextautolink " ↓ " toolTip:"关联并顺序移到下一对" pos:[280,240] width:40 height:30

	checkbox syncselect "同步选择场景节点" checked:true pos:[40,370]
	checkbox poscpck "拷贝根节点位置" checked:true pos:[200,370]
	checkbox roacpck "拷贝根节点旋转" checked:true pos:[200,390]
	spinner framestart "开始帧：" type:#integer range:[-9999,9999,0] pos:[390,370]  width:100 height:30
	spinner frameend "结束帧：" type:#integer range:[-9999,9999,0] pos:[390,390]  width:100 height:30
	
	button cppose "拷贝姿势" pos:[120,420] width:100 height:30
	button cpanim "拷贝动画" pos:[300,420] width:100 height:30

	
	fn addchild thenode thobj=
	(
		local thenode,newnode,thobj
		dataary=#(thobj.name,thobj,undefined)
		newnode=thenode.Nodes.add thobj.name
		newnode.tag=dotNetMXSValue dataary
		format "%\n" newnode.FullPath
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
	
	on picksrc picked obj do
	(
		if isValidNode obj do initTV tvsrc obj
	)
	
	on setsrc pressed do
	(
		if $selection.count==1 then
		(
			if isValidNode $selection[1] do initTV tvsrc $selection[1]
		)
	)	
	
	on pickdst picked obj do
	(
		if isValidNode obj do initTV tvdst obj
	)
	
	on setdst pressed do
	(
		if $selection.count==1 then
		(
			if isValidNode $selection[1] do initTV tvdst $selection[1]
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
	)

	on dellink pressed do
	(
		if tvdst.SelectedNode==undefined then return false
		dstary=tvdst.SelectedNode.tag.value
		tvdst.SelectedNode.text=dstary[1]
		dstary[3]=undefined
		tvdst.SelectedNode.tag=dotNetMXSValue dstary
	)
	
	on Anim_toolbox_rollout open do
	(
		tvsrc.ShowLines=tvdst.ShowLines=true
		tvsrc.HideSelection=tvdst.HideSelection=false
		print frameend.value
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
		)
		catch()
		if isValidNode obj do initTV tvdst obj
	)
)

/*
try
(
	toolshwnd = windows.getChildHWND 0 Animtoolboxname parent:#max -- find dialog
	if toolshwnd != undefined do windows.sendMessage toolshwnd[1] 0x0010 0 0 -- if found, send close message 
)
catch()
*/

createDialog Anim_toolbox_rollout width:550 height:480
