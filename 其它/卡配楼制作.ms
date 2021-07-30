try destroydialog peilou catch()
(
rollout peilou "配楼制作：" width:309 height:223
(
fn louban_mat o=
(
jj=#()
  for e in Geometry do
  (
  try
  (
  if e.material.name=="配楼" then 
   (
 append jj e
   )
   )catch()
   )
 if jj.count!=0 then
 (
o.material=jj[1].material
 )
 else
 (
o.material=Standardmaterial ()
o.material.Diffuse = color 255 255 255
o.material.ambient = color 255 255 255
o.material.specularLevel = 0
o.material.opacity = 100
o.material.name="配楼"
)	
)
fn heixian o=                         -----------------------------heixian
(
jj=#()
  for e in Geometry do
  (
  try
  (
  if e.material.name=="黑线" then 
   (
 append jj e
   )
   )catch()
   )
 if jj.count!=0 then
 (
o.material=jj[1].material
 )
 else
 (
o.material=Standardmaterial ()
o.material.Diffuse = color 25 25 25
o.material.ambient = color 25 25 25
o.material.specularLevel = 0
o.material.opacity = 80
o.material.name="黑线"
)	
)

fn poli o=
(

jj=#()
  for e in Geometry do
  (
  try
  (
  if e.material.name=="玻璃盒子" then 
   (
 append jj e
   )
   )catch()
   )
 if jj.count!=0 then
 (
o.material=jj[1].material
 )
 else
 (
o.material=Standardmaterial ()
o.material.Diffuse = color 252 252 252
o.material.ambient = color 252 252 252
o.material.specularLevel = 0
o.material.opacity = 50
o.material.name="玻璃盒子"
)	

)
fn topoly rr am=
(
select rr
modPanel.addModToSelection (Extrude ()) ui:on
$.modifiers[#Extrude].amount = am
$.modifiers[#Extrude].capStart = off
$.name="玻璃盒子"
)
	
	
	spinner cg "层高：" pos:[28,39] width:112 height:16 range:[0,10000,3000] type:#integer scale:1
	GroupBox grp1 "" pos:[8,26] width:145 height:148
	spinner cs "层数：" pos:[28,66] width:112 height:16 range:[0,10000,8] type:#integer scale:1
	button btn1 "OK" pos:[127,183] width:116 height:27
	spinner spn3 "间距：" pos:[28,94] width:112 height:16 range:[0,100000,4000] type:#integer scale:10
	spinner spn4 "合心筒：" pos:[28,148] width:112 height:16 range:[0,5,2] type:#integer scale:1
	GroupBox grp2 "" pos:[162,26] width:138 height:148
	spinner spn6 "条宽：" pos:[28,119] width:112 height:16 range:[0,10000,1000] type:#integer scale:10
	radiobuttons rdo1 "" pos:[90,9] width:136 height:16 labels:#("单体楼", "一群楼") columns:2
	spinner spn8 "" pos:[177,39] width:112 height:16 range:[0,10000,3000] type:#integer scale:1
	spinner spn9 "" pos:[177,65] width:41 height:16 range:[1,1000,3] type:#integer scale:1
	spinner spn10 "" pos:[248,65] width:41 height:16 range:[1,1000,40] type:#integer scale:1
	label lbl1 "---" pos:[222,67] width:22 height:15
	spinner spn11 "" pos:[177,92] width:41 height:16 range:[1,100000,3000] type:#integer scale:1
	spinner spn12 "" pos:[248,92] width:41 height:16 range:[1,100000,5000] type:#integer scale:1
	label lbl2 "---" pos:[222,94] width:22 height:15
	spinner spn13 "" pos:[177,117] width:54 height:16 range:[1,1000,50] type:#integer scale:1
	spinner spn14 "" pos:[234,117] width:55 height:16 range:[1,5000,1000] type:#integer scale:1
	spinner spn15 "" pos:[177,146] width:41 height:16 range:[0,5,0] type:#integer scale:1
	spinner spn16 "" pos:[248,146] width:41 height:16 range:[0,5,3] type:#integer scale:1
	label lbl4 "---" pos:[222,148] width:22 height:15
	HyperLink lbl9 "加入讨论群" pos:[19,187] width:80 height:16 color:(color 255 127.5 0) address:"http://jq.qq.com/?_wv=1027&k=Xl0yNR"

	
	
	
	
	on peilou open do
	(
	spn8.enabled=false
	spn9.enabled=false
	spn10.enabled=false
	spn11.enabled=false
	spn12.enabled=false
	spn13.enabled=false
	spn14.enabled=false
	spn15.enabled=false
	spn16.enabled=false
	)
	on rdo1 changed state do
	(
	if rdo1.state==1 then
	(
	spn8.enabled=false
	spn9.enabled=false
	spn10.enabled=false
	spn11.enabled=false
	spn12.enabled=false
	spn13.enabled=false
	spn14.enabled=false
	spn15.enabled=false
	spn16.enabled=false
	 cg.enabled=true
	 cs.enabled = true
	 spn3.enabled = true
	 spn4.enabled = true
	 spn6.enabled = true
	)
	if rdo1.state==2 then
	(
	spn8.enabled= true
	spn9.enabled=true
	spn10.enabled=true
	spn11.enabled=true
	spn12.enabled=true
	spn13.enabled=true
	spn14.enabled=true
	spn15.enabled=true
	spn16.enabled=true
	 cg.enabled=false
	 cs.enabled = false
	 spn3.enabled = false
	 spn4.enabled = false
	 spn6.enabled = false

	)
	)
	on btn1 pressed do
	(
	try (
	if rdo1.state==1 then
	(
	converttosplineshape $	
	if selection.count==1 and superclassof $ == shape then
	(
	disableSceneRedraw()
	max create mode

	oldline=getcurrentselection()
	----------------------------------玻璃盒子
	myobj=copy oldline[1]
	zg=cg.value*cs.value
	addmodifier myobj (extrude amount:zg capstart:off capend:off)
	myobj.name="玻璃盒子"
	poli myobj         --玻璃盒子材质
	redrawviews()
	----------------------------------顶
	ding=copy oldline[1]
	ding.pos=ding.pos+[0,0,zg]
	converttopoly ding
	select ding
	max modify mode
	subobjectlevel=4
	polyop.setfaceselection ding 1
	$.outlineAmount = 500
	$.EditablePoly.Outline ()
	subobjectlevel=0
	addmodifier $ (shell outeramount:1500 inneramount:0)
	converttopoly $
	subobjectlevel=4
	polyop.setfaceselection ding 1
	$.insetAmount = 400
	$.EditablePoly.buttonOp #Inset
	$.extrusionType = 0
	$.faceExtrudeHeight = -600
	$.EditablePoly.buttonOp #Extrude
	subobjectlevel=0
	louban_mat $           ---顶的材质
	clearselection()
	redrawviews()
	----------------------------------楼板
	for e= 1 to (cs.value-1) do
	(
	lb=copy oldline[1]
	lb.pos.z=lb.pos.z+cg.value*e
	lb.name="配楼楼板"
	converttopoly lb
	)
	select $配楼楼板*
	ef=getcurrentselection()
	for n=1 to ef.count do
		(
		try
		(
		polyop.attach ef[1] ef[n+1]
		)catch()
		)
		louban_mat $
	subobjectlevel=4
	max select all
	$.outlineAmount = 220
	$.EditablePoly.Outline ()
	subobjectlevel=0
	addmodifier $ (shell outeramount:300 inneramount:300)
	$.name="OK配楼楼板"
	redrawviews()
	----------------------------------------坚条
	myo=copy oldline[1]
	nseg=numsegments myo 1
	print nseg
	l=getseglengths myo 1
	for q=1 to nseg do
	(
	 nu=(l[q+nseg] as integer)/spn3.value
	y=mod l[q+nseg]  spn3.value
	if y>(spn3.value/2) then
	(
	nu=nu+1
	)
	p1=getknotpoint myo 1 q
	if (q+1)>(numknots myo) then
	(
	p2=getknotpoint myo 1 1
	)
	else
	(
	p2=getknotpoint myo 1 (q+1)
	)
	dd=distance p1 p2
	av=(dd as float)/nu
	for e = 1 to (nu-1) do
	(
	pp=(p2-p1)*(e as float)/nu + p1
	mybox=box length:zg width:spn6.value height:spn6.value
	mybox.pos=pp+[0,0,zg/2]
	mybox.dir=normalize(p2-p1)
	mybox.name="坚条"
	converttopoly mybox
	)
	)
	select $坚条*
	ef=getcurrentselection()
	for n=1 to ef.count do
		(
		try
		(
		polyop.attach ef[1] ef[n+1]
		)catch()
		)
		louban_mat $
	$.name="OK_坚条"
	--------------------------------------------
	zg=cg.value*cs.value
	addmodifier myo (extrude amount:zg capstart:off capend:off)
	converttopoly myo
	es=polyOp.getOpenEdges myo
	select myo
	 subobjectlevel = 2
	 polyop.setedgeselection $ es
	max select invert
	polyOp.createShape $ (polyop.getedgeselection $) name:"ll"

	delete myo

	$ll.baseobject.renderable=true
	$ll.displayrendermesh=true
	 $ll.render_rectangular=true
	$ll.render_viewport_length=1000
	$ll.render_viewport_width=1000
	louban_mat $ll
	converttopoly $ll
	$ll.name="OK_边坚条"
	redrawviews()
	----------------------------------合心筒

	for ss=1 to spn4.value do
	(
	oo=copy oldline[1]
	sx=random 0.2 0.5
		sy=random 0.1 0.7
		oo.pivot=oo.center
		oo.scale.x=sx
		oo.scale.y=sy
		converttopoly oo
		gg=zg+4000
		addmodifier oo (shell outeramount:gg inneramount:0 )
		p=random oldline[1].max oldline[1].min
		oo.pos=p
		louban_mat oo
		converttopoly oo
		select oo
		subobjectlevel=4
		polyop.setfaceselection oo 1
		$.insetAmount = 400
		$.EditablePoly.buttonOp #Inset
		$.extrusionType = 0
		$.faceExtrudeHeight = -600
		$.EditablePoly.buttonOp #Extrude
		subobjectlevel=0
	     clearselection()	
	)
	)
	)

	if rdo1.state==2 then                      --------------------------------------  一群楼
	(
	sg=getcurrentselection()
	for er= 1 to sg.count do
	(
	converttosplineshape sg[er]	
	if superclassof sg[er] == shape then
	(
	disableSceneRedraw()
	max create mode
	oldline=sg[er]
	----------------------------------玻璃盒子
	myobj=copy oldline
	css=random spn9.value spn10.value
	zg=cg.value*css
	addmodifier myobj (extrude amount:zg capstart:off capend:off)
	myobj.name="玻璃盒子"
	poli myobj         --玻璃盒子材质
	redrawviews()
	----------------------------------顶
	ding=copy oldline
	ding.pos=ding.pos+[0,0,zg]
	converttopoly ding
	select ding
	max modify mode
	subobjectlevel=4
	polyop.setfaceselection ding 1
	$.outlineAmount = 500
	$.EditablePoly.Outline ()
	subobjectlevel=0
	addmodifier $ (shell outeramount:1500 inneramount:0)
	converttopoly $
	subobjectlevel=4
	polyop.setfaceselection ding 1
	$.insetAmount = 400
	$.EditablePoly.buttonOp #Inset
	$.extrusionType = 0
	$.faceExtrudeHeight = -600
	$.EditablePoly.buttonOp #Extrude
	subobjectlevel=0
	louban_mat $           ---顶的材质
	clearselection()
	redrawviews()
	----------------------------------楼板
	for e= 1 to (css-1) do
	(
	lb=copy oldline
	lb.pos.z=lb.pos.z+cg.value*e
	lb.name="配楼楼板"
	converttopoly lb
	)
	select $配楼楼板*
	ef=getcurrentselection()
	for n=1 to ef.count do
		(
		try
		(
		polyop.attach ef[1] ef[n+1]
		)catch()
		)
		louban_mat $
	subobjectlevel=4
	max select all
	$.outlineAmount = 220
	$.EditablePoly.Outline ()
	subobjectlevel=0
	addmodifier $ (shell outeramount:300 inneramount:300)
	$.name="OK配楼楼板"
	redrawviews()
	----------------------------------------坚条
	myo=copy oldline
	nseg=numsegments myo 1
	print nseg
	l=getseglengths myo 1
	aaa=random 1 2
	for q=1 to nseg do
	(
	 nu=(l[q+nseg] as integer)/spn3.value
	y=mod l[q+nseg]  spn3.value
	if y>(spn3.value/2) then
	(
	nu=nu+1
	)
	p1=getknotpoint myo 1 q
	if (q+1)>(numknots myo) then
	(
	p2=getknotpoint myo 1 1
	)
	else
	(
	p2=getknotpoint myo 1 (q+1)
	)
	dd=distance p1 p2
	av=(dd as float)/nu
	for e = 1 to (nu-1) do
	(
	pp=(p2-p1)*(e as float)/nu + p1
	if aaa==1 then
	(
	mybox=box length:zg width:spn13.value height:spn13.value
	heixian mybox
	)
	else
	(
	mybox=box length:zg width:spn14.value height:spn14.value
	louban_mat mybox
	)
	mybox.pos=pp+[0,0,zg/2]
	mybox.dir=normalize(p2-p1)
	mybox.name="坚条"
	converttopoly mybox
	)
	)
	select $坚条*
	ef=getcurrentselection()
	for n=1 to ef.count do
		(
		try
		(
		polyop.attach ef[1] ef[n+1]
		)catch()
		)
	$.name="OK_坚条"
	--------------------------------------------
	zg=cg.value*css
	addmodifier myo (extrude amount:zg capstart:off capend:off)
	converttopoly myo
	es=polyOp.getOpenEdges myo
	select myo
	 subobjectlevel = 2
	 polyop.setedgeselection $ es
	max select invert
	polyOp.createShape $ (polyop.getedgeselection $) name:"ll"

	delete myo

	$ll.baseobject.renderable=true
	$ll.displayrendermesh=true
	 $ll.render_rectangular=true
	$ll.render_viewport_length=1000
	$ll.render_viewport_width=1000
	louban_mat $ll
	converttopoly $ll
	$ll.name="OK_边坚条"
	redrawviews()
	----------------------------------合心筒
	hex=random spn15.value spn16.value
	for ss=1 to hex do
	(
	oo=copy oldline
	sx=random 0.2 0.5
		sy=random 0.1 0.7
		oo.pivot=oo.center
		oo.scale.x=sx
		oo.scale.y=sy
		converttopoly oo
		gg=zg+4000
		addmodifier oo (shell outeramount:gg inneramount:0 )
		p=random oldline.max oldline.min
		oo.pos=p
		louban_mat oo
		converttopoly oo
		select oo
		subobjectlevel=4
		polyop.setfaceselection oo 1
		$.insetAmount = 400
		$.EditablePoly.buttonOp #Inset
		$.extrusionType = 0
		$.faceExtrudeHeight = -600
		$.EditablePoly.buttonOp #Extrude
		subobjectlevel=0
	     clearselection()	
	)
	)
	)
	)
	)catch()
	enableSceneRedraw()
	)

)
CreateDialog peilou
)