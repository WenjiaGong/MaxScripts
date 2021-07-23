/*
Bone Divider 0.1
by Jefferson D. Lim

- This script will simple let you divide a bone.

[0.1]
- first public release
*/
try(destroyDialog boneDivider)catch()
rollout boneDivider "Bone等分工具" width:165 height:185
(	
	GroupBox grp_ops "层级关系设置:" pos:[5,5] width:155 height:80
	
	checkbox chk_hier "层级关系A" pos:[10,20] width:105 height:15 checked:true  enabled:true 
	checkbox chk_par "层级关系B " pos:[10,35] width:105 height:15 checked:false
	checkbox chk_retA "层级关系C" pos:[10,50] width:105 height:15 checked:true 
	checkbox chk_retB "层级关系D" pos:[10,65] width:105 height:15 checked:true 
	
	GroupBox grp_set "划分设置:" pos:[5,85] width:155 height:55
	checkbox chk_rep "替换原Bone" pos:[10,100] width:145 height:15 checked:true
	label lbl_div "分段数:" pos:[20,120] width:50 height:15
	spinner spn_div "" pos:[75,120] width:80 height:16 range:[2,999,3] type:#integer
	button btn_div "执行" pos:[5,145] width:155 height:25
	
	fn divideBone2 b num axis:1 =
	(
		d = b.transform[axis] 		
		pos1 = b.pos
		pos2 = d * b.length-- using the transform x axis as the direction
		
		lastPos = pos1
		newBones = #()
		for i in 1 to num do
		(
			nextPos = pos1 + (d  * ((b.length/num)*i))
			x = boneSys.createBone lastPos nextPos b.dir
			append newBones x
			lastPos = nextPos
		)
		newBones
	)
	
	
	on btn_div pressed do
	(
		sel = for i in selection where classOf i == BoneGeometry collect i
		
		segs = spn_div.value
		txt = "Divide Bones:" + segs as string
		undo txt on
		(
			for i in sel do
			(
				nb = divideBone2 i segs
				count = nb.count
				
				if chk_hier.enabled and chk_hier.checked do
				(
					for h in 1 to count do
					(
						if h != count do nb[h+1].parent = nb[h]
					)
				)
				
				if chk_retA.checked do
				(
					nb[1].parent = i.parent
				)
				
				if chk_retB.checked do
				(
					c = for h in i.children collect h
					for h in c do h.parent = nb[count]
				)
				
				if chk_rep.checked then
				(
					delete i
				)
				else if chk_par.enabled and chk_par.checked do
				(
					for b in nb do b.parent = i
				)
			)
		)
	)
	
	fn initUI =
	(
		chk_par.enabled = not chk_retA.checked and not chk_rep.checked
-- 		chk_hier.enabled = not chk_par.checked
	)
	
	on chk_par changed state do initUI()
	on chk_rep changed state do initUI()	
	on chk_retA changed state do initUI()
	
)

createDialog boneDivider

/*
[to do]
/- add undo history
- add select newly created bones button
- retain bone/fin settings
*/
