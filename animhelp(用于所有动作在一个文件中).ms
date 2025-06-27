-- AnimHelp
-- copyright 2011 (c) Arjen van Haren
-- email: arjenvanharen@gmail.com
-- create animation ranges for objects and the complete scene
--
-- to store the animdata with the scene, the appdata construction is used

-- todo:
--  change string buildup 

-- Version 1.3
-- Date: 01-07-2011
-- added:
-- refactoring: removed returns
-- changed position show range button
-- added right-click funtionality on show range to play the animation


-- Version 1.2
-- Date: 27-06-2011
-- added:
-- rownummer before animation	
-- when adding a new animation the current active range is used
-- added: select all, select none and select invert
-- added: selection move up and move down
-- removed the checkbox before the animation line,  one selection method should be enough
-- deleting the selection will trigger a confirmation dialog popup first
-- overwriting the active range will trigger a confirmation dialog popup first
-- added an about box

-- clearlistener()
-- escape enable

-- global createAnimRollout


global VERSION_ANIMHELP = "AnimHelp version 1.31"
INIFILE_ANIMHELP		= GetDir #plugcfg + "//animhelp.ini"
global YSTART			    = 15
global Y_SPACING	    = 24
global DEFAULT_XS	= 550
global DEFAULT_YS	= 110
global AnimHelp
global settingsRolloutState
global lastId                   = 0
global MainRollout_ANIMHELP 
global flgAboutAnimHelp = false
global flgSettingsRollout = false
global flgAnimSelectRollout=false
global flgAnimSheetRollout=true
global flgAnimSheetRollupState=false

global AH_ON        = 1
global AH_NAME      = 2
global AH_START		= 3
global AH_END	    = 4
global AH_OBJ_HNDL	= 5

global AH_G_ANIM_FIRST  = 0
global AH_G_ANIM_LAST	= 0
global selButStates 	= #{}

-- UI defines 'add local animation'
global UI_ANIM_SPINNER_START_NAME  			= "开始:"
global UI_ANIM_SPINNER_END_NAME  			= "结束:"
global UI_ANIM_BUTTON_SHOW_RANGE_NAME		= "应用范围"
global UI_ANIM_BUTTON_STORE_RANGE_NAME		= "更新范围"
global UI_ANIM_BUTTON_RENDER_NAME			= "render"

global UI_BUTTON_HEIGHT						= 18
global UI_CHECKBUTTON_HEIGHT				= 30


-- UI messages defined
global UI_MSG_ERROR_ID_MISMATCH					= "Error! ID mismatch!"
global UI_MSG_ERROR_CANNOT_CREATE_DIRECTORY		= "Cannot create directory"
global UI_MSG_ERROR_WHILE_RENDERING_ABORTING	= "Error!, rendering aborted"


-- UI defines 'global controls'

global UI_BUTTON_DELETE_SELECTED_ANIMATIONS_NAME	= "删除选择"
global UI_BUTTON_ADD_ANIMATION_NAME					= "添加片段"
global UI_BUTTON_DELETE_ALL_NAME					= "删除全部"

global UI_BUTTON_EXPORT_ANIM_DATA_NAME					=  "export anim data"
global UI_BUTTON_SHOW_SELECTED_RANGE_NAME				= "show selected range"
global UI_BUTTON_SHOW_MAX_RANGE_NAME					= "show Max range"
global UI_BUTTON_SELECT_ALL_NAME						= "全选"
global UI_BUTTON_SELECT_NONE_NAME						= "取消"
global UI_BUTTON_SELECT_INVERT_NAME						= "反选"
global UI_BUTTON_ABOUT_NAME								= "?" 
global UI_BUTTON_SET_RENDER_FILE_OUTPUT_NAME			= "Set render file output"
global UI_DIALOG_SET_RENDER_OUTPUT_DIRECTORY_TEXT		= "Set the render output directory"
global UI_BUTTON_RENDER_DIRECTORY_NAME					= "Render directory"
global UI_BUTTON_RENDER_SELECTION_NAME					= "Render selection"

-- anim data
global DATA_NEW_ANIMATION_NAME = " - new - "
global playingAnimOnNodeId=-1
global conDotNet=dotNetClass "system.windows.forms.control"



fn dbg msg = (
-- 	print "start:******************"
-- 	print msg
-- 	print "end:-------------------------"
)


fn quote control = 
(
	" \"" + control + "\" "
)


fn getPrevScreenSize = 
(
	xs = (getIniSetting INIFILE_ANIMHELP "window" "xsize") as integer
	ys = (getIniSetting INIFILE_ANIMHELP "window" "ysize")  as integer

	if (xs < DEFAULT_XS) then (
	  	MainRollout_ANIMHELP.size.x = DEFAULT_XS
	) else (
		MainRollout_ANIMHELP.size.x = xs
	)
	if (ys < DEFAULT_YS) then (
	  	MainRollout_ANIMHELP.size.y = DEFAULT_YS
	) else (
	  	MainRollout_ANIMHELP.size.y = ys
	)
)

fn getPrevScreenPos = 
(
	x = (getIniSetting INIFILE_ANIMHELP "window" "xpos") as integer
	y = (getIniSetting INIFILE_ANIMHELP "window" "ypos")  as integer

	MainRollout_ANIMHELP.pos = [x,y] 	
)


fn setPrevScreenPosition = 
(
	x = (getIniSetting INIFILE_ANIMHELP "window" "xpos"  "0") as integer
	y = (getIniSetting INIFILE_ANIMHELP "window" "ypos"  "0") as integer
	setDialogPos AnimHelp [x, y]
)


-- general method to store data using the setAppData function
fn storeData aNode Id dataA =
(
	newS = dataA[AH_ON]
	for i = 2 to dataA.count do (
		append newS ","
		append newS dataA[i]
	)
	setAppData aNode Id newS	
)


-- aNode = rootNode
fn storeGroupData aNode groupId data =
(

	setAppData aNode groupId newS	
)


fn isAltKeyPressed =
(
	conDotNet.modifierKeys==conDotNet.modifierKeys.alt
)


fn isShiftKeyPressed =
(
	conDotNet.modifierKeys==conDotNet.modifierKeys.shift
)


fn isControlKeyPressed =
(
	conDotNet.modifierKeys==conDotNet.modifierKeys.control
)

fn getNrOfAnimations =
(
	nrAnimations=0
	
	nrAnimsS = getAppData rootNode 0
	if nrAnimsS != undefined then (
		nrAnimations = nrAnimsS as integer
	)
	nrAnimations
)


fn getAnimationNamesAsArray =
(
	retArray = #()
	nrAnimsS = getAppData rootNode 0
	if (nrAnimsS != undefined) then (
		nrAnims = nrAnimsS as integer

		for i = 1 to nrAnims do (
			curS = getAppData rootNode i
			curA = filterstring curS ","
			
			animLine = "[" 
			append animLine (i as string) 
			append animLine "] " 
			append animLine "(" 
			append animLine curA[AH_START] 
			append animLine " - " 
			append animLine curA[AH_END] 
			append animLine ")" 
			
			lengthToFill = 30 - animLine.count
			for i=1 to lengthToFill do (
				append animLine " "
			)
			append animLine curA[AH_NAME]
			append retArray animLine
		)
	)
	retArray
)

global animSelectRollout


fn updateSingleAnimationRollout=
(
	if(flgAnimSelectRollout) then (
		nrOfAnimations=getNrOfAnimations()
		
		selectNr=1
/*		
		if(animSelectRollout.currentAnimation.selection > nrOfAnimations) then (
			selectNr=nrOfAnimations
		) else (
			selectNr=animSelectRollout.currentAnimation.selection
		)
		*/
		animSelectRollout.fillAnimSelectDropDownList selectNr
	)
)


-- store the change of the animation name
fn animNameChanged Id newVal =
(
	curS =getAppData rootNode Id
	if curS == undefined then (
		print UI_MSG_ERROR_ID_MISMATCH
	) else (
		curA = filterstring curS ","
		curA[AH_NAME] = newVal
		storeData rootNode Id curA
		updateSingleAnimationRollout()
	)
)


-- store the change of the animation startframe
fn animStartframeChanged Id newVal =
(
	curS =getAppData rootNode Id
	if curS == undefined then (
		print UI_MSG_ERROR_ID_MISMATCH
	) else (
		curA = filterstring curS ","
		curA[AH_START] = newVal as string
		storeData rootNode Id curA
		updateSingleAnimationRollout()
	)
)


-- store the change of the animation startframe
fn animEndframeChanged Id newVal =
(
	curS =getAppData rootNode Id
	if curS == undefined then (
		print UI_MSG_ERROR_ID_MISMATCH
	) else (
		curA = filterstring curS ","
		curA[AH_END] = newVal as string
		storeData rootNode Id curA
		updateSingleAnimationRollout()
	)
)

-- show range of animation
fn animShowRange Id =
(
	stopAnimation()

	curS =getAppData rootNode Id
	if curS == undefined then (
		print UI_MSG_ERROR_ID_MISMATCH
	) else (
		curA = filterstring curS ","
		animationRange = interval (curA[AH_START] as integer) (curA[AH_END] as integer)
-- 		max time start
	)
)


-- show range and play animation
-- if control key is pressed then always start animation play from the beginning
fn animPlayShowRange Id =
(
	animWasPlaying = isAnimPlaying() 
	
	-- show range
	animShowRange Id

	if(isControlKeyPressed() or Id!=playingAnimOnNodeId ) then (
		-- goto first frame
		max time start
		-- make sure animation will be playing again
		animWasPlaying=false
	)
	
	if(animWasPlaying==false) then (		
		playAnimation  immediateReturn:true 
	)
	playingAnimOnNodeId=Id
)


-- store the current timeline
fn animGetRange Id startUI endUI =
(
	retVal = yesnocancelbox "Overwrite set animation range with current active range?"
	if retVal == #YES then (

		curS =getAppData rootNode Id
		if curS == undefined then (
			print UI_MSG_ERROR_ID_MISMATCH
		) else (
			curA = filterstring curS ","

			startA = filterstring (animationrange.start as string) "f"
			endA = filterstring (animationrange.end as string) "f"
			
			startUI.value = startA[1] as integer
			endUI.value = endA[1] as integer
			
			curA[AH_START] = startA[1]
			curA[AH_END] = endA[1]
			storeData rootNode Id curA
			updateSingleAnimationRollout()
		)
	)
)


-- return the start frame of the active animation range as an Integer
fn getStartCurrentAnimationRange =
(
	startA = filterstring (animationrange.start as string) "f"
	startA[1] as Integer
)


-- return the end frame of the active animation range as an Integer
fn getEndCurrentAnimationRange =
(
	endA = filterstring (animationrange.end as string) "f"
	endA[1] as Integer
)


fn createGlobalAnimControls y Id data =
(
	Ids = Id as string
	ypos = y as string

	selAnimS 			= " selAnim" + Ids
	animActiveS			= " animActive" + Ids
	animNameS			= " animName" + Ids
	startFrameS			= " startFrame" + Ids
	endFrameS			= " endFrame" + Ids
	showRangeS			= " showRange" + Ids
	getAnimRangeS 		= " getAnimRange" + Ids
	renderAnimS	 		= " renderAnim" + Ids

	uiS = ""

	append uiS ("checkbutton" + selAnimS + " \"" + Ids +  "\" pos:[4," + ypos + "] width:35 height:18" + " checked:" + data[AH_ON] + "\n")
	append uiS ("button" + showRangeS + quote UI_ANIM_BUTTON_SHOW_RANGE_NAME + " pos:[45," + ypos + "] width:64 height:" + UI_BUTTON_HEIGHT as string + "\n")

	append uiS ("editText" + animNameS + " pos:[110," + ypos + "] width:120 height:16 text:\"" + data[AH_NAME] + "\"\n")

	append uiS ("spinner" + startFrameS + quote UI_ANIM_SPINNER_START_NAME + " pos:[260," + ypos + "] width:65 height:16 range:[0,999999," + data[AH_START] + "] type:#integer\n")
	append uiS ("spinner" + endFrameS + quote UI_ANIM_SPINNER_END_NAME + " pos:[360," + ypos + "] width:65 height:16 range:[0,999999," + data[AH_END] + "] type:#integer\n")
	append uiS ("button" + getAnimRangeS + quote UI_ANIM_BUTTON_STORE_RANGE_NAME + " pos:[430," + ypos + "] width:60 height:" + UI_BUTTON_HEIGHT as string + "\n")
-- 	append uiS ("button" + renderAnimS + quote UI_ANIM_BUTTON_RENDER_NAME + " pos:[495," + ypos + "] width:40 height:"+ UI_BUTTON_HEIGHT as string + "\n")

	append uiS ("on" + animNameS + " entered val do ( animNameChanged " + Ids + " val )\n")
	append uiS ("on" + startFrameS + " entered do ( animStartframeChanged " + Ids + startFrameS + ".value )\n")
	append uiS ("on" + endFrameS + " entered do ( animEndframeChanged " + Ids + endFrameS + ".value )\n")
	append uiS ("on" + showRangeS + " pressed do ( animShowRange " + Ids + " )\n")
	append uiS ("on" + showRangeS + " rightclick  do ( animPlayShowRange " + Ids + " )\n")
	append uiS ("on" + getAnimRangeS + " pressed do ( animGetRange " + Ids + startFrameS + endFrameS + " )\n")
	append uiS ("on" + renderAnimS + " pressed do ( renderAnim " + Ids + startFrameS + endFrameS + " )\n")	
	append uiS ("on" + selAnimS + " changed val do ( changeSelButton " + Ids + " val )\n")

	uiS
)



-- dynamicly build the animations UI
-- when a new animation is added or deleted this method will be called as well to rebuild the rollout
fn createAnimRollout  =
(
	if( flgAnimSheetRollout) then (
		Undo off (
			with redraw off (
				if AnimHelp != undefined then (
					removeRollout AnimHelp 
				)
				newUI = "rollout AnimHelp \"展开菜单\" category:3 (\n " 
				
				append newUI "button delAnim UI_BUTTON_DELETE_SELECTED_ANIMATIONS_NAME pos:[10,10] width:80 height:UI_BUTTON_HEIGHT \n"
				append newUI "button moveSelectionUpButton \"上移\" pos:[105,10] width:110 height:UI_BUTTON_HEIGHT \n"
				append newUI "button moveSelectionDownButton \"下移\" pos:[220,10] width:110 height:UI_BUTTON_HEIGHT \n"
	
				append newUI "label selectLabel \"选择:\" pos:[362,12] \n"
				append newUI "button btnSelectAll UI_BUTTON_SELECT_ALL_NAME pos:[400,10] width:36 height:UI_BUTTON_HEIGHT \n"
				append newUI "button btnSelectNone UI_BUTTON_SELECT_NONE_NAME pos:[440,10] width:36 height:UI_BUTTON_HEIGHT \n"
				append newUI "button btnSelectInvert UI_BUTTON_SELECT_INVERT_NAME pos:[480,10] width:36 height:UI_BUTTON_HEIGHT \n"
				
				i = 1
				nrAnimsS = getAppData rootNode 0
				if nrAnimsS != undefined then (
					nrAnims = nrAnimsS as integer
					for i = 1 to nrAnims do (
						retVal = getAppData rootNode i
						if retVal == undefined then (
							rebuildAppData()			-- error, rebuild list
							messagebox "Anim data was corrupted, anim data rebuild, restart script"
							closeRolloutFloater MainRollout_ANIMHELP 
						) else (
							retA = filterstring retVal ","
							append newUI (createGlobalAnimControls (YSTART + (i * Y_SPACING)) i retA) 
						)
						i += 1
					)
				)
	-- 			handleButtonStates()
				append newUI "on AnimHelp rolledUp state do ( handleAnimSheetRolledUp state ) \n"
				append newUI "on delAnim pressed do ( deleteSelectedAnimations() ) \n"
				append newUI "on moveSelectionUpButton pressed do ( moveSelectionUp() )\n"
				append newUI "on moveSelectionDownButton pressed do ( moveSelectionDown() ) \n"
				append newUI "on btnSelectAll pressed do ( selectAllAnimations() ) \n"
				append newUI "on btnSelectNone pressed do ( selectNoneAnimations() ) \n"
				append newUI "on btnSelectInvert pressed do ( selectInvertAnimations() ) \n"
				
				append newUI "\n)"
				dlgStyle = #(#style_resizing, #style_titlebar, #style_border, #style_sysmenu,#style_minimizebox, #style_maximizebox)
				addrollout (execute newUI) MainRollout_ANIMHELP rolledUp:flgAnimSheetRollupState
			)
		)
	)
)	

rollout animSelectRollout "下拉菜单" category:2
(
	button singleAnimShowRange "应用范围" pos:[4,10] width:64 height:UI_BUTTON_HEIGHT
	dropdownlist currentAnimation pos:[80,8] width:280
	label labelChangeSelected  "更改选择:" pos:[4,36]
	editText singleAnimName pos:[110, 34] width:120 height:16 
	spinner singleAnimStartRange "开始:" pos:[260, 34] width:65 height:16 range:[0,999999,0] type:#integer
	spinner singleAnimEndRange "结束:" pos:[360, 34] width:65 height:16 range:[0,999999,0] type:#integer
	button singleAnimStoreAnimRange UI_ANIM_BUTTON_STORE_RANGE_NAME pos:[430,34] width:60 height:UI_BUTTON_HEIGHT

	on animSelectRollout rolledUp state do (
		if(state) then (
			setinisetting INIFILE_ANIMHELP "rollout_displayed" "animselect" "2"
		) else (
			setinisetting INIFILE_ANIMHELP "rollout_displayed" "animselect" "1"
		)
	)
		
	-- the animation selected in the drop down changed, update the edit controls
	fn selectedAnimationChanged itm =
	(
		if(itm > 0) then (
			curS = getAppData rootNode itm
			if( curS != undefined) then (
				curA = filterstring curS ","
				singleAnimName.text=curA[AH_NAME]
				singleAnimStartRange.value=curA[AH_START] as integer
				singleAnimEndRange.value=curA[AH_END] as integer
			)
		)
	)


	fn fillAnimSelectDropDownList selAnim =
	(
		animsArray=getAnimationNamesAsArray()
		currentAnimation.items=animsArray
		if( animsArray.count > 0 ) then (
			selectedAnimationChanged selAnim
		) else (
			singleAnimName.text=""
			singleAnimStartRange.value=0
			singleAnimEndRange.value=0
		)
	)
	
	on animSelectRollout open do (
		fillAnimSelectDropDownList 1
	)
	
	on currentAnimation selected itm do selectedAnimationChanged itm
		
	on singleAnimName entered val do ( 
		animNameChanged currentAnimation.selection val
		fillAnimSelectDropDownList currentAnimation.selection
		createAnimRollout()
	)
	
	on singleAnimStartRange entered do (
		animStartframeChanged currentAnimation.selection singleAnimStartRange.value
		createAnimRollout()
	)

	on singleAnimEndRange entered do (
		animEndframeChanged currentAnimation.selection singleAnimEndRange.value
		createAnimRollout()
	)

	on singleAnimShowRange pressed do (
		animShowRange currentAnimation.selection
	)

	on singleAnimShowRange rightclick do (
		animPlayShowRange currentAnimation.selection
	)
	
	on singleAnimStoreAnimRange pressed do (
		animGetRange currentAnimation.selection singleAnimStartRange singleAnimEndRange
		createAnimRollout()
	)
)



fn RenderCam cam2Render camdirname startframe endframe basedir objectname skip showvfb =
(
	camdir = basedir + "\\" + camdirname
	checkdir = getDirectories camdir
	if checkdir.count == 0 then (
		RetVal = makedir camdir
		if RetVal == false then (
			messagebox UI_MSG_ERROR_CANNOT_CREATE_DIRECTORY
			return false
		)
	)
	filename = camdir + "\\" + camdirname + "_.bmp"
	showvfbI = not showvfb
    -- render camera:cam2Render 
	--	print filename
	try (
		render fromframe:startframe toframe:endframe nthframe:skip outputFile:filename
	) catch (
		messagebox UI_MSG_ERROR_WHILE_RENDERING_ABORTING
	)
)


-- render animation range
fn renderAnim Id startUI endUI =
(
	curS = getAppData rootNode Id
	if curS == undefined then (
		print 
	) else (
		curA = filterstring curS ","
		animName = curA[AH_NAME]
		subdirName = animName
		if (subdirName == undefined) or (subdirName == "") then (
			subdirName  = Id as string
		)
		skipVal = 1;
		renderPath = (getIniSetting INIFILE_ANIMHELP "directories" "renderpath") as string
		RenderCam "NOCAM" subdirName startUI.value endUI.value renderPath animName skipVal false
	)
)


-- selection button state changed
fn changeSelButton Id val =
(
	curS = getAppData rootNode Id
	if curS == undefined then (
		print UI_MSG_ERROR_ID_MISMATCH
	) else (
		curA = filterstring curS ","
		curA[AH_ON] = val as string
		storeData rootNode Id curA
	)
)


-- get the current selected animation and return as an array
fn getSelection = 
(
	selectionArray = #()

	nrAnimsS = getAppData rootNode 0
	if nrAnimsS != undefined then (
		nrAnims = nrAnimsS as integer

		for nodeId = 1 to nrAnims do (
			curS =getAppData rootNode nodeID
			curA = filterstring curS ","
			if(curA[AH_ON] as string == "true") then (
				append selectionArray nodeId
			)
		)
	)
	selectionArray
)


fn handleSelectionState =
(
	arrayVal = selButStates as array
	for Id in arrayVal do (
	)
)


-- add global animation entry
fn doAddGlobalAnim =
(
	-- create new appData entry
	i = 0
	retS = getAppData rootNode 0
	if retS != undefined then (
		i = retS as integer
	)
	i += 1 
	
		-- add new animation, use active time range as range to set
	animStart = getStartCurrentAnimationRange() as string
	animEnd = getEndCurrentAnimationRange() as string
	
	nodeData = "false," + DATA_NEW_ANIMATION_NAME + " (" +  i as string +  ")," +  animStart + "," + animEnd + ",-1"
	setAppData rootNode i nodeData
	setAppData rootNode 0 (i as string)			-- set max length appData
)


-- rebuilds the AppData and removes the undefined entries
fn rebuildAppData =
(
	local newI = 1
	
	lenDataS = getAppData rootNode 0
	if lenDataS != undefined then (
		lenData = lenDataS as integer
		for i = 1 to lenData do (
			curString = getAppData rootnode i
			if curString != undefined then (
				if newI != i then (
					setAppData rootnode newI curString
				)
				newI += 1
			)
		)
	)
	deleteAppData rootnode (newI + 1) 
	setAppData rootnode 0 ((newI - 1 ) as string)
)

fn swapNodes node1 node2 =
(
	nodeData1 = getAppData rootNode node1
	nodeData2 = getAppData rootNode node2
	setAppData rootNode node1 nodeData2
	setAppData rootNode node2 nodeData1
)

fn handleAnimSheetRolledUp state=
(
	flgAnimSheetRollupState=not state
	if(state) then (
		setinisetting INIFILE_ANIMHELP "rollout_displayed" "animsheet" "2"
	) else (
		setinisetting INIFILE_ANIMHELP "rollout_displayed" "animsheet" "1"
	)
)	


fn moveSelectionUp=
(
	selArray = getSelection()

	if(selArray.count > 0 and selArray[1] >1) then (
		for Id in selArray do (
			swapNodes Id (Id-1)
		)		
		rebuildAppData()	-- remove all undefines
		createAnimRollout()
		updateSingleAnimationRollout()
	)			
)


fn moveSelectionDown=
(
	selArray = getSelection()
	selCount = selArray.count
	nrOfAnimations = getNrOfAnimations()
	if (selCount > 0 and selArray[selCount] <  nrOfAnimations) then (
		i=selCount
		while(i>0) do (
			id = selArray[i]
-- 				print id
			if (id < nrOfAnimations ) then (
				swapNodes id (id+1)
			)
			i=i-1
		)
		rebuildAppData()	-- remove all undefines
		createAnimRollout()
		updateSingleAnimationRollout()
	)			
)	

	fn selectAllAnimations=
	(
		nrAnimsS = getAppData rootNode 0
		if nrAnimsS != undefined then (
			nrAnims = nrAnimsS as integer
			for i = 1 to nrAnims do (
				execString = "AnimHelp.selAnim" + i as string + ".checked=true"
				execute(execString)
				changeSelButton i true
			)
		)
-- 		handleButtonStates()
	)
	
	fn selectNoneAnimations=
	(
		nrAnimsS = getAppData rootNode 0
		if nrAnimsS != undefined then (
			nrAnims = nrAnimsS as integer
			for i = 1 to nrAnims do (
				execString = "AnimHelp.selAnim" + i as string + ".checked=false"
				execute(execString)
				changeSelButton i false
			)
		)
-- 		handleButtonStates()
	)

	
	fn selectInvertAnimations=
	(
		nrAnimsS = getAppData rootNode 0
		if nrAnimsS != undefined then (
			nrAnims = nrAnimsS as integer
			for i = 1 to nrAnims do (
				tS = "AnimHelp.selAnim" + i as string + ".checked";
				execString = tS + "= not(" + tS + ")";
				execute(execString)
				
				curS = getAppData rootNode i
				curA = filterstring curS ","
-- 				print curA[AH_ON]
				if(curA[AH_ON] as string == "true") then (
					changeSelButton i false
				) else (
					changeSelButton i true
				)
			)
		)
-- 		handleButtonStates()
	)
	


fn deleteSelectedAnimations=
(
	retVal = yesnocancelbox "All selected animation data will be deleted!\nContinue?"
	if retVal == #YES then (
		arrayVal = getSelection()
			
		for Id in arrayVal do (
			deleteAppData rootnode Id
		)
		rebuildAppData()	-- remove all undefines
		createAnimRollout()
		updateSingleAnimationRollout()
	)
)



/*
fn handleButtonStates =
(
return
	nrAnimsS = getAppData rootNode 0
	if nrAnimsS != undefined then (
		nrAnims = nrAnimsS as integer
	)
	-- set button states
	if(nrAnims != undefined and nrAnims > 0) then (
		TEMPLATE_ANIMHELP.delAll.enabled = true
		TEMPLATE_ANIMHELP.delAnim.enabled = false
		TEMPLATE_ANIMHELP.btnSelectAll.enabled = true
		TEMPLATE_ANIMHELP.btnSelectNone.enabled = true
		TEMPLATE_ANIMHELP.btnSelectInvert.enabled = true
	) else (
		TEMPLATE_ANIMHELP.delAll.enabled = false
		TEMPLATE_ANIMHELP.delAnim.enabled = false
		TEMPLATE_ANIMHELP.btnSelectAll.enabled = false
		TEMPLATE_ANIMHELP.btnSelectNone.enabled = false
		TEMPLATE_ANIMHELP.btnSelectInvert.enabled = false
	)
	
	-- check if we have an selection
	hasSelection = false
	if(nrAnims != undefined and nrAnims > 0) then (
		for i = 1 to nrAnims do (
			execString = "hasSelection = AnimHelp.selAnim" + i as string + ".checked";
			execute(execString)
			if(hasSelection)  then (
				break;
			)
		)
	)
	if(hasSelection) then (
		TEMPLATE_ANIMHELP.delAnim.enabled = true
	) else (
		TEMPLATE_ANIMHELP.delAnim.enabled = false
	)
)
*/

rollout AboutMeAnimHelp "关于"
(
	label Name VERSION_ANIMHELP
	label creator "(c) 2011 - created by Arjen van Haren"
	label email "email: spring.to@gmail.com"
	-- 	hyperlink ls "(c) 2011 Arjen van Haren" address:"spring.to@gmail.com" align:#center
)


rollout SettingsRollout "Settings" category:4
(
	editText renderOutputDirectory UI_BUTTON_RENDER_DIRECTORY_NAME pos:[8,8] width:480 height:16
	button butRenderLoc1 " ... " pos:[500,8] width:30 height:UI_BUTTON_HEIGHT
	
	on butRenderLoc1 pressed do
	(
		retString = getSavePath UI_DIALOG_SET_RENDER_OUTPUT_DIRECTORY_TEXT
		if retString != undefined then (
			setinisetting INIFILE_ANIMHELP "directories" "renderpath" retString
			butRenderLoc1.caption = retString
		)
	)
	
	on SettingsRollout rolledUp state do (
		if(state) then (
			setinisetting INIFILE_ANIMHELP "rollout_displayed" "settings" "2"
		) else (
			setinisetting INIFILE_ANIMHELP "rollout_displayed" "settings" "1"
		)
	)
)


fn setupRolloutStates =
(
	-- 0=not displayed,1=displayed but rollout closed, 2=displayed and rollout opened
	animSelect= (getIniSetting INIFILE_ANIMHELP "rollout_displayed" "animselect") as integer
 	animSheet= (getIniSetting INIFILE_ANIMHELP "rollout_displayed" "animsheet") as integer
 	animSort= (getIniSetting INIFILE_ANIMHELP "rollout_displayed" "animsort") as integer
 	importExport= (getIniSetting INIFILE_ANIMHELP "rollout_displayed" "importexport") as integer
	settings= (getIniSetting INIFILE_ANIMHELP "rollout_displayed" "settings") as integer

	if(settings > 0) then (
		addrollout SettingsRollout MainRollout_ANIMHELP rolledUp:(settings!=2)
	)
	flgSettingsRollout=settings!=0

	if(animSelect > 0) then (
		addrollout animSelectRollout MainRollout_ANIMHELP rolledUp:(animSelect!=2)
	)
	flgAnimSelectRollout=animSelect!=0

	flgAnimSheetRollupState = (animSheet!=2)
	if(animSheet > 0) then (
		createAnimRollout
	)
)

rollout TEMPLATE_ANIMHELP "全局设置" width:528 height:144 category:1
(
	groupBox menuGroup "动画菜单" pos:[6,4] width:520 height:38
	button btnAnimationSelect "下拉菜单" pos:[10,18] width:76 height:UI_BUTTON_HEIGHT
	button btnAnimSheet "展开菜单" pos:[90,18] width:76 height:UI_BUTTON_HEIGHT
-- 	button btnSort "Sort" pos:[170,18] width:76 height:UI_BUTTON_HEIGHT
	button btnExport "导出记录" pos:[250,18] width:120 height:UI_BUTTON_HEIGHT
-- 	button btnSettings "Settings" pos:[330,18] width:76 height:UI_BUTTON_HEIGHT
	button btnAbout "关于" pos:[440,18] width:76 height:UI_BUTTON_HEIGHT

	button addGlobalAnim UI_BUTTON_ADD_ANIMATION_NAME pos:[10,50] width:76 height:UI_BUTTON_HEIGHT
	button delAll UI_BUTTON_DELETE_ALL_NAME pos:[100,50] width:76 height:UI_BUTTON_HEIGHT

	/*
-- 	button exportAnimData UI_BUTTON_EXPORT_ANIM_DATA_NAME pos:[368,8] width:110 height:UI_BUTTON_HEIGHT
-- 	button btnShowSelRange UI_BUTTON_SHOW_SELECTED_RANGE_NAME pos:[247,8] width:110 height:UI_BUTTON_HEIGHT
-- 	button btnShowMaxRange UI_BUTTON_SHOW_MAX_RANGE_NAME pos:[248,32] width:110 height:UI_BUTTON_HEIGHT

	groupBox extrasGroup "Menu" pos:[420,4] width:110 height:125
*/
-- 	button btnGroups "Groups" pos:[440,25] width:80 height:UI_BUTTON_HEIGHT
-- 	button btnRender "Render" pos:[440,50] width:80 height:UI_BUTTON_HEIGHT
-- 	button btnSettings "Settings" pos:[440,100] width:80 height:UI_BUTTON_HEIGHT

-- 	button btnRenderSelection UI_BUTTON_RENDER_SELECTION_NAME pos:[8,104] width:128 height:UI_BUTTON_HEIGHT

--	button btnImportAnim "import anim data" pos:[248,200] width:110 height:18
--	combobox cbGroupAnims "Group animations:" pos:[8,176] width:200 height:1
--	button btnAddGroup "add group" pos:[56,224] width:72 height:18
--	button btnDeleteGroup "delete group" pos:[136,224] width:72 height:18
--	checkbox cbShowAllGroups "show all groups" pos:[112,248] width:96 height:16

	on TEMPLATE_ANIMHELP open do
	(
		getPrevScreenSize()
		getPrevScreenPos()
		renderPath = (getIniSetting INIFILE_ANIMHELP "directories" "renderpath") as string
		if (renderPath != "") then (
		  SettingsRollout.butRenderLoc1.caption = renderPath
		) else (
			SettingsRollout.butRenderLoc1.caption = " - RENDER OUTPUT PATH NOT SET - "
		)
		setupRolloutStates()
	)
	
	on TEMPLATE_ANIMHELP resized size do
	(
			xysize = MainRollout_ANIMHELP.size
			setinisetting INIFILE_ANIMHELP "window" "xsize" (xysize.x as string)  
			setinisetting INIFILE_ANIMHELP "window" "ysize" (xysize.y as string)  
	)
	
	on TEMPLATE_ANIMHELP moved pos do
	(
			xypos = MainRollout_ANIMHELP.pos 	
			setinisetting INIFILE_ANIMHELP "window" "xpos" (xypos.x as string)  
			setinisetting INIFILE_ANIMHELP "window" "ypos" (xypos.y as string)  
	)
	
	
	
	on addGlobalAnim pressed do
	(
		doAddGlobalAnim()
		createAnimRollout() 	-- rebuild dialog
		updateSingleAnimationRollout()
	)
	
	
	on delAll pressed do
	(
		retVal = yesnocancelbox "所有动画数据将被删除！\n继续?"
		if retVal == #YES then (
			clearAllAppData rootnode
			createAnimRollout()
			updateSingleAnimationRollout()
		)
	)
	
	
	on btnExport pressed do
	(
		filename = getSaveFileName "Export global animations sheet"	types:"SAS(*.sas)|All|*.*|" 
			if filename != undefined then (
				fs = openFile filename mode:"wt"
				if fs != undefined then (
				
					local newI = 1
					lenDataS = getAppData rootNode 0
					if lenDataS != undefined then (
						lenData = lenDataS as integer
						for i = 1 to lenData do (
							curString = getAppData rootnode i
							if curString != undefined then (
								dataA = filterString curString ","
								tval = stricmp dataA[AH_ON] "true"
								if tval == 0 then (
									-- TODO loopflag !
									newS = dataA[AH_START] + "," + dataA[AH_END] + ",0" + "," + dataA[AH_NAME] + "\n"
									format newS to:fs
								)
								newI += 1
							)
						)
					)
					deleteAppData rootnode (newI + 1) 
					setAppData rootnode 0 ((newI - 1 ) as string)
				)
				close fs
			)
		)
	
		
	on btnShowSelRange pressed do
	(
		local minAnim = 99999999
		local maxAnim = -99999999
		
		arrayVal = selButStates	as array
		for Id in arrayVal do (
			curS = getAppData rootNode Id
			if curS == undefined then (
				print UI_MSG_ERROR_ID_MISMATCH
			) else (
				curA = filterstring curS ","
				newMinAnim = curA[AH_START] as integer
				newMaxAnim = curA[AH_END] as integer
	
				if(minAnim > newMinAnim) then (
				  minAnim = newMinAnim
				)
				if(maxAnim < newMaxAnim) then (
				  maxAnim = newMaxAnim
				)
			)
		)
		if(minAnim < maxAnim) then (
			animationRange = interval minAnim maxAnim
			
		)
	)
	
	
	on btnShowMaxRange pressed do
	(
		local minAnim = 99999999
		local maxAnim = -99999999
	
		nrAnimsS = getAppData rootNode 0
		if nrAnimsS != undefined then (
			nrAnims = nrAnimsS as integer
			for i = 1 to nrAnims do (
				retVal = getAppData rootNode i
				curA = filterstring retVal ","		
				newMinAnim = curA[AH_START] as integer
				newMaxAnim = curA[AH_END] as integer
				if(minAnim > newMinAnim) then (
				  minAnim = newMinAnim
				)
				if(maxAnim < newMaxAnim) then (
				  maxAnim = newMaxAnim
				)
			)
			if(minAnim < maxAnim) then (
				animationRange = interval minAnim maxAnim
			)
		)
	)
	

	
	on btnSettings pressed do
	(
		flgSettingsRollout = not flgSettingsRollout
		if(flgSettingsRollout) then (
			addrollout SettingsRollout MainRollout_ANIMHELP rolledUp:false
			setinisetting INIFILE_ANIMHELP "rollout_displayed" "settings" "2"
		) else (
			removerollout SettingsRollout 
			setinisetting INIFILE_ANIMHELP "rollout_displayed" "settings" "0"
		)
	)
	

	on btnAnimSheet pressed do
	(
		flgAnimSheetRollout = not flgAnimSheetRollout
		if(flgAnimSheetRollout) then (
			setinisetting INIFILE_ANIMHELP "rollout_displayed" "animsheet" "2"
			createAnimRollout()
		) else (
			setinisetting INIFILE_ANIMHELP "rollout_displayed" "animsheet" "0"
			removerollout AnimHelp 
		)	
	)
	

	on btnAnimationSelect pressed do
	(
		flgAnimSelectRollout = not flgAnimSelectRollout
		if(flgAnimSelectRollout) then (
			setinisetting INIFILE_ANIMHELP "rollout_displayed" "animselect" "2"
			addrollout animSelectRollout MainRollout_ANIMHELP rolledUp:false
		) else (
			setinisetting INIFILE_ANIMHELP "rollout_displayed" "animselect" "0"
			removerollout animSelectRollout 
		)	
	)


	on btnAbout pressed do
	(
		flgAboutAnimHelp = not flgAboutAnimHelp
		if(flgAboutAnimHelp) then (
			addrollout AboutMeAnimHelp MainRollout_ANIMHELP rolledUp:false
			AnimHelp.open = false
			animSelectRollout.open=false
		) else (
			removerollout AboutMeAnimHelp
		)	
	)

	
	on btnRenderSelection pressed do
	(
		arrayVal = selButStates	as array
		skipVal = 1;
		renderPath = (getIniSetting INIFILE_ANIMHELP "directories" "renderpath") as string

		for Id in arrayVal do (
			curS = getAppData rootNode Id
			if curS == undefined then (
				print UI_MSG_ERROR_ID_MISMATCH
			) else (
				curA = filterstring curS ","
				animName = curA[AH_NAME]
				animStart = curA[AH_START] as integer
				animEnd = curA[AH_END] as integer
				
				subdirName = animName
				if (subdirName == undefined) or (subdirName == "") then (
					subdirName  = Id as string
				)
				RenderCam "NOCAM" subdirName animStart animEnd renderPath animName skipVal false
			)
		)
	)
)


if MainRollout_ANIMHELP != undefined then closeRolloutFloater MainRollout_ANIMHELP 				--close existing rollout
MainRollout_ANIMHELP = newRolloutFloater VERSION_ANIMHELP DEFAULT_XS DEFAULT_YS					--Create new floater
addrollout TEMPLATE_ANIMHELP MainRollout_ANIMHELP rolledUp:false

createAnimRollout()
clearlistener()
