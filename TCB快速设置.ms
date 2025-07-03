
fn IsBip o = classof o.controller == BipSlave_Control or classof o.controller == Vertical_Horizontal_Turn

struct tcb (name="",easeTo=0.,easeFrom=0.,tension=25.,continuity=25.,bias=25.)

fn setTcb theTcb currentTimeOnly =
(
	keysArr = #()
	bipCtrs = for o in selection where isbip o and o.controller.keys.count != 0 collect o.controller
	
	comCtrs = #()
	for i = bipCtrs.count to 1 by -1 do
		if classof bipCtrs[i] == Vertical_Horizontal_Turn do (
			for j=1 to 3 do append comCtrs bipCtrs[i][j]
			deleteitem bipCtrs i
		)
	join bipCtrs comCtrs
	
	for c in bipCtrs do for i=1 to c.keys.count do append keysArr (biped.getkey c i)
	
	if currentTimeOnly do
		for i=keysArr.count to 1 by -1 do
			if keysArr[i].time != slidertime do deleteitem keysArr i

	keysArr.easeto = theTcb.easeTo
	keysArr.easefrom = theTcb.easeFrom
	keysArr.tension = theTcb.tension
	keysArr.continuity = theTcb.continuity
	keysArr.bias = theTcb.bias
	keysArr.count
)

fn loadTcb =
(
	thefile = (getdir #scripts) + "/tcb_presets.txt"
	TCBs = #()

	if not (doesFileExist thefile) then (
		f = createfile thefile
		format "%\n" (tcb name:"Default") to:f
		close f
		append TCBs (tcb name:"Default")
	)
	else (
		f = openfile thefile
		while (not eof f) do append TCBs (readValue f)
		close f
	)

	TCBs
)

fn saveTcb arrTcbs =
(
	thefile = (getdir #scripts) + "/tcb_presets.txt"
	f = openfile thefile mode:"wt"
	for tcb in arrTcbs do format "%\n" tcb to:f
	close f
)
	try(destroyDialog rll_tcb)catch()

	global offsetBsTM = [0,0] 		--Dragwindow
	global dragStateBsTM = off   --Dragwindow

rollout rll_tcb "Bip_TCB快速设置" width:180
(
	local TCBs = #()
	local h = 13
	groupbox gpbOutline "" pos:[5,15] width:325 height:145

	label lblTitle "TCB快速设置" pos:[18,6]
	--button btnAbout "?" pos:[rll_tcb.width - 40,0] height:16 width:20
	--button btnClose "X" pos:[rll_tcb.width - 20,0] height:16 width:20 
	spinner s_et "缓入:  " range:[0,50,0] height:13 
	spinner s_ef "缓出:  " range:[0,50,0] height:18
	spinner s_t "张力:  " range:[0,50,25] height:13
	spinner s_c "连续性:  " range:[0,50,25] height:13
	spinner s_b "偏移:  " range:[0,50,25] height:15
	radiobuttons rdo_range labels:#("当前时间","整个时间")
	button btn_app "应用" width:155	

	listbox lb_set "预设" height:4 offset:[0,10]
	edittext etxt_name ""
	button btn_add "添加" width:49 align:#left
	button btn_edit "修改" width:49 align:#center offset:[0,-26]
	button btn_del "删除" width:49 align:#right offset:[0,-26]

	button btn_a "+" width:17 height:17 pos:(lb_set.pos + [120,-18])
	button btn_d "-" width:17 height:17 pos:(lb_set.pos + [137,-18])
	
	
	

	on btnClose pressed do 
	(
		try (destroydialog rll_tcb) catch ()
	)

	on rll_tcb mbuttondown pos do 
	(
		try (destroydialog rll_tcb) catch ()
	)
	
	on rll_tcb lbuttondown posMou do
	(
		setSysCur #move
		offsetBsTM = posMou
		dragStateBsTM = on
	)
	
	on rll_tcb lbuttonup posMou do
	(
		dragStateBsTM = off
	)
	
	on rll_tcb mouseMove pos do
	(
		if dragStateBsTM == on then
		(
			SetDialogPos rll_tcb (mouse.screenpos - offsetBsTM)
		)
	)
	on rll_tcb open do (
		TCBs = loadTcb()
		lb_set.items = for t in TCBs collect t.name
	)
	
	on rll_tcb close do (
		gc()
	)
	
	on lb_set doubleClicked i do (
		theName = lb_set.selected
		local tmp
		for t in TCBs do if t.name == theName do tmp = t
		s_et.value = tmp.easeTo
		s_ef.value = tmp.easeFrom
		s_t.value = tmp.tension
		s_c.value = tmp.continuity
		s_b.value = tmp.bias
	)
	
	on btn_add pressed do (
		if etxt_name.text != "" then (
			tmp = lb_set.items
			append tmp etxt_name.text
			lb_set.items = tmp
			append TCBs (tcb name:etxt_name.text easeTo:s_et.value easeFrom:s_ef.value \
							tension:s_t.value continuity:s_c.value bias:s_b.value)
			etxt_name.text = ""
			saveTcb TCBs
		)
		else messagebox "Check Name\t"
	)
	
	on btn_del pressed do (
		i = lb_set.selection
		if i != 0 do (
			tmp = lb_set.items
			deleteitem tmp i
			lb_set.items = tmp
			deleteitem TCBs i
			saveTcb TCBs
		)
	)
	
	on btn_edit pressed do (
		i = lb_set.selection
		if i != 0 do (
			theName = if etxt_name.text == "" then lb_set.selected else etxt_name.text
			lb_set.selected = theName
			TCBs[i] = (tcb name:theName easeTo:s_et.value easeFrom:s_ef.value \
						tension:s_t.value continuity:s_c.value bias:s_b.value)
			etxt_name.text = ""
			saveTcb TCBs
		)
	)
	
	on btn_a pressed do (
		if lb_set.height < 300 do (
			lb_set.height += h
			rll_tcb.height += h
			etxt_name.pos += [0,h]
			btn_add.pos += [0,h]
			btn_edit.pos += [0,h]
			btn_del.pos += [0,h]
		)
	)

	on btn_d pressed do (
		if lb_set.height > 32 do (
			lb_set.height -= h
			rll_tcb.height -= h
			etxt_name.pos -= [0,h]
			btn_add.pos -= [0,h]
			btn_edit.pos -= [0,h]
			btn_del.pos -= [0,h]
		)
	)
	
	on btn_app pressed do with undo "set TCB" on (
		tmp = (tcb name:"tmp" easeTo:s_et.value easeFrom:s_ef.value \
				tension:s_t.value continuity:s_c.value bias:s_b.value)
		setTcb tmp (rdo_range.state == 1)
	)

)

createdialog rll_tcb

