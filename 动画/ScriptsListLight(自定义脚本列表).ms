try(destroyDialog AFScriptsList_Roll)catch()

rollout AFScriptsList_Roll "脚本列表-青云汉化" width:232 height:552
(
	dropdownList ddlPaths "" pos:[8,8] width:160 height:21
	button bAddPath "+" pos:[176,8] width:16 height:21 toolTip:"将文件夹添加到列表"
	button bDelPath "X" pos:[192,8] width:16 height:21 toolTip:"从列表中删除文件夹"
	button bOpenFolder "O" pos:[208,8] width:16 height:21 toolTip:"在资源管理器中打开文件夹"
	button bAbout "A" pos:[192,40] width:16 height:21 toolTip:"关于"
	checkbutton chbLock "L" pos:[208,40] width:16 height:21 toolTip:"锁打开" checked:false
	dropdownList ddlPres "" pos:[8,40] width:64 height:21 items:#("全部", "我喜欢")
	button bExternal "+ 脚本" pos:[80,40] width:48 height:21
	button bLike "我喜欢!" pos:[136,40] width:48 height:21 toolTip:"添加到收藏夹"
	dotNetControl lbScripts "System.Windows.Forms.ListView" pos:[8,64] width:216 height:480
	--timer tmEsc "testEsc" interval:10 active:true

	local defaultPath = "C:\\Temp\\Scripts"
	local folders = #()
	local favScripts = #()
	local wColor = (dotNetClass "System.Drawing.Color").fromARGB 255 255 255
	local bColor = (dotNetClass "System.Drawing.Color").fromARGB 0 0 0
	local gColor = (dotNetClass "System.Drawing.Color").fromARGB 100 200 100
	local wgColor = (dotNetClass "System.Drawing.Color").fromARGB 200 240 200
	local rColor = (dotNetClass "System.Drawing.Color").fromARGB 200 0 0
	local sColor = (dotNetClass "System.Drawing.Color").fromARGB 150 150 150
	local pColor = (dotNetClass "System.Drawing.Color").fromARGB 240 220 220

	local lbItems = #()

	local rcLbMenu

	fn createRcMenu = 
	(
		rcMenu rcLbMenu
		(
			menuItem miRun "运行"
			seperator menuSep01
			menuItem miEditScript "编辑脚本"
			menuItem miDelete "从列表中删除"
			seperator menuSep02
			menuItem miILikeIt "我喜欢!"
			
			on rcLbMenu open do
			(
				miEditScript.enabled = if lbScripts.selectedItems.count == 1 then true else false
				miILikeIt.enabled = if ddlPres.selected == "我喜欢" then false else true
				miDelete.enabled = if ddlPres.selected == "我喜欢" then true else false
			)
			on miRun picked do AFScriptsList_Roll.runScript()
			on miEditScript picked do AFScriptsList_Roll.editScript()
			on miDelete picked do AFScriptsList_Roll.deleteLikeItems()
			on miILikeIt picked do AFScriptsList_Roll.ILikeIt()
		)
	)
	
	fn initDotNet ctrl =
	(
		ctrl.clear()
		ctrl.view = (dotNetClass "System.Windows.Forms.View").Details
		ctrl.TileSize = dotNetObject "System.Drawing.Size" 25 25
		ctrl.columns.add "脚本:" 500
		ctrl.gridLines = true
		ctrl.multiselect = true
		ctrl.hideSelection = false
		ctrl.fullRowSelect = true
	)
	
	fn getItem cnt = 
	(
		try(
			pos = cnt.mousePosition
			pos = cnt.pointToClient pos
			li = cnt.getItemAt pos.x pos.y
			si = li.getSubItemAt pos.x pos.y
			return #(li, si)
		)catch()
	)
	
	fn getScriptFile num =
	(
		res = if ddlPres.selected == "全部" then res = folders[ddlPaths.selection] + "\\" + lbScripts.items.item[num.index].text
			else res = (AFScriptsList_Roll.getLikeScripts())[num.index+1]
	)

	fn compareNames v1 v2 =
	(
		if classOf v1 == Array do (v1 = v1[1].text; v2 = v2[1].text)
		v1 = toLower (getFilenameFile v1)
		v2 = toLower (getFilenameFile v2)
		case (sort #(v1, v2))[1] of
		(
			v1 : -1
			v2 : 1
		)
	)
	
	fn getLikeScripts =
	(
		favScripts = filterString (getINISetting (getMAXIniFile()) "ScriptsListDefs" "ScriptsListILikeIt") "?"
		qsort favScripts compareNames
		return favScripts
	)
	
	fn setLikeScripts favScripts =
	(
		qsort favScripts compareNames
		paths = ""
		for i in favScripts do paths += i + "???"
		setINISetting (getMAXIniFile()) "ScriptsListDefs" "ScriptsListILikeIt" paths
	)

	fn populateList =
	(
		scripts = #()
		scriptsArr = #()
		if ddlPres.selected == "全部" then
		(
			bExternal.enabled = false
			bLike.enabled = true
			files = getFiles (folders[ddlPaths.selection] + "\\*.ms")
			join files (getFiles (folders[ddlPaths.selection] + "\\*.mse"))
			join files (getFiles (folders[ddlPaths.selection] + "\\*.mcr"))
			qsort files compareNames
			for i in files do append scripts (filenameFromPath i)
		)
		else
		(
			bExternal.enabled = true
			bLike.enabled = false
			favScripts = getLikeScripts()
			for i in favScripts do append scripts (filenameFromPath i)
		)
		initDotNet lbScripts
		img = dotNetObject "System.Windows.Forms.ImageList"
		img.ColorDepth.Depth24Bit
		img.ImageSize = dotNetObject "System.Drawing.Size" 16 16
		lbScripts.SmallImageList = img
		for i = 1 to scripts.count do
		(
			script = if ddlPres.selected == "全部" then folders[ddlPaths.selection] + "\\" + scripts[i] else favScripts[i]
			li = dotNetObject "System.Windows.Forms.ListViewItem" scripts[i]
			if doesFileExist script then li.ForeColor = bColor else li.ForeColor = sColor
			local bm
			imgFile = (getFilenamePath script) + "Img\\" + (getFilenameFile script) + ".jpg"
			if doesFileExist imgFile then bm = (dotNetClass "System.Drawing.Image").FromFile imgFile
			else
			(
				s = 0
				for char = 1 to scripts[i].count do s = s + (bit.charAsInt scripts[i][char]) * 134
				seed s
					col = (dotNetClass "System.Drawing.Color").fromARGB (random 0 255) (random 0 255) (random 0 255)
						newRgb = #(col.R, col.G, col.B)
						if amin newRgb == amax newRgb then newCol = col
						else
						(
							newRgb[findItem newRgb (amin newRgb)] = 0
							newRgb[findItem newRgb (amax newRgb)] = 255
							newCol = color newRgb[1] newRgb[2] newRgb[3]
						)
					col = (dotNetClass "System.Drawing.Color").fromARGB newCol.r newCol.g newCol.b
				bm = dotNetObject "System.Drawing.bitmap" 16 16
				for x = 0 to 14 do for y = 0 to 14 do bm.SetPixel x y col
			)
			img.images.add (bm)
			li.ImageIndex = img.images.count - 1
			append scriptsArr li
		)
		lbScripts.Items.addRange scriptsArr
		if lbScripts.items.count > 0 do lbScripts.items.item[0].selected = true
	)
	
	fn savePaths =
	(
		if ddlPaths.items.count > 1 do
		(
			setINISetting (getMAXIniFile()) "ScriptsListDefs" "ScriptsListFoldersSelection" folders[ddlPaths.selection]
		)
		sort folders
		paths = ""
		for i in folders do paths += i + "???"
		setINISetting (getMAXIniFile()) "ScriptsListDefs" "ScriptsListFolders" paths
	)

	fn getPaths =
	(
		ddlPaths.items = #()
		folders = filterString (getINISetting (getMAXIniFile()) "ScriptsListDefs" "ScriptsListFolders") "?"
		sort folders
		if folders.count == 0 do
		(
			pth = getSavePath caption:"选择脚本文件夹"
			if pth != undefined then
			(
				folders = #(pth)
				savePaths()
			)
			else folders = #(defaultPath)
		)
		pathsNames = #()
		for i = 1 to folders.count do
		(
			netPath = if folders[i][1] == "\\" then true else false
			arr = filterString folders[i] "\\"
			append pathsNames ((if netPath then "\\\\" else "") + arr[1] + (if arr.count > 1 then ("\\...\\" + arr[arr.count]) else "\\"))
		)
		ddlPaths.items = pathsNames
		sel = findItem folders (getINISetting (getMAXIniFile()) "ScriptsListDefs" "ScriptsListFoldersSelection")
		ddlPaths.selection = if sel == 0 then 1 else sel
		ddlPaths.tooltip = folders[ddlPaths.selection]
	)
	
	fn initScript =
	(
		getPaths()
		exist = false
		initDotNet lbScripts
		if doesFileExist folders[ddlPaths.selection] then exist = true
		else
		(
			if queryBox (folders[ddlPaths.selection] + "\n找不到路径!\n创建它?") title:"脚本列表" == true do
			(
				res = try(makeDir folders[ddlPaths.selection])catch(false)
				if res then exist = true
					else messageBox "错误!" title:"脚本列表"
			)
		)
		if exist do populateList()
	)

	on AFScriptsList_Roll open do
	(
		lock = getINISetting (getMAXIniFile()) "ScriptsListDefs" "ScriptsListLock"
		chbLock.checked = if lock == "1" then true else false
		preset = getINISetting (getMAXIniFile()) "ScriptsListDefs" "ScriptsListPreset"
		ddlPres.selection = if preset == "我喜欢" then 2 else 1
		initScript()
		createRcMenu()
		try(
			x = getINISetting (getMAXIniFile()) "ScriptsListDefs" "ScriptsListSizeX"
			if chbObjs.checked do x = x as integer * 1.5
			y = getINISetting (getMAXIniFile()) "ScriptsListDefs" "ScriptsListSizeY"
			if x as integer == 0 or y as integer == 0 do (x = 200; y = 531)
			AFScriptsList_Roll.width = x as integer
			AFScriptsList_Roll.height = y as integer
		)catch()
		setFocus lbScripts
	)
	
	on ddlPaths selected arg do
	(
		setINISetting (getMAXIniFile()) "ScriptsListDefs" "ScriptsListFoldersSelection" folders[ddlPaths.selection]
		ddlPaths.tooltip = folders[ddlPaths.selection]
		ddlPres.selection = 1
		savePaths()
		initScript()
	)
	
	on bAddPath pressed do
	(
		pth = getSavePath caption:"选择脚本文件夹"
		if pth != undefined do
		(
			res = appendIfUnique folders pth
			if res do
			(
				savePaths()
				setINISetting (getMAXIniFile()) "ScriptsListDefs" "ScriptsListFoldersSelection" pth
				initScript()
			)
		)
	)
	
	on bDelPath pressed do
	(
		sel = ddlPaths.selection
		folders = filterString (getINISetting (getMAXIniFile()) "ScriptsListDefs" "ScriptsListFolders") "?"
		deleteItem folders sel
		deleteItem ddlPaths.items sel
		if sel > ddlPaths.items.count then ddlPaths.selection = ddlPaths.items.count else ddlPaths.selection = sel
		savePaths()
		getPaths()
		initScript()
	)
	
	on bOpenFolder pressed do ShellLaunch folders[ddlPaths.selection] ""

	on chbLock changed arg do
	(
		setINISetting (getMAXIniFile()) "ScriptsListDefs" "ScriptsListLock" (if arg then "1" else "0")
	)
	
	fn ILikeIt file:undefined =
	(
		likeScripts = getLikeScripts()
		if file == undefined then 
		(
			for itm = 0 to lbScripts.selectedItems.count - 1 do
			(
				appendIfUnique likeScripts (folders[ddlPaths.selection] + "\\" + lbScripts.selectedItems.item[itm].text)
			)
			setLikeScripts likeScripts
		)
		else
		(
			appendIfUnique likeScripts file
			setLikeScripts likeScripts
			populateList()
		)
	)
	
	on bLike pressed do ILikeIt()

	on lbScripts MouseUp arg do
	(
		pos = lbScripts.pos + [arg.x, arg.y]
		if lbScripts.selectedItems.count > 0 and arg.button == lbScripts.mouseButtons.right do popUpMenu rcLbMenu pos:pos rollout:AFScriptsList_Roll align:#align_topleft
	)
	
	on ddlPres selected itm do
	(
		setINISetting (getMAXIniFile()) "ScriptsListDefs" "ScriptsListPreset" ddlPres.selected
		bExternal.enabled = if ddlPres.selected == "全部" then false else true
		populateList()
	)
	
	on lbScripts click arg do ()

	fn editScript =
	(
		try(edit (getScriptFile lbScripts.selectedItems.item[0]))catch()
		if chbLock.checked == false do destroyDialog AFScriptsList_Roll
	)
	
	on bExternal pressed do
	(
		fileName = getOpenFileName caption:"选择脚本:" types:("maxscript (.ms, .mse, .mcr)|*.ms; *.mse; *.mcr|")
		if fileName != undefined do ILikeIt file:fileName
	)
	
	on AFScriptsList_Roll resized size do
	(
		if AFScriptsList_Roll.placement == #normal do
		(
			lbScripts.width = size.x - 16
			lbScripts.height = size.y - lbScripts.pos.y - 8
			diagSize = getDialogSize AFScriptsList_Roll
			setINISetting (getMAXIniFile()) "ScriptsListDefs" "ScriptsListSizeX" (diagSize.x as string)
			setINISetting (getMAXIniFile()) "ScriptsListDefs" "ScriptsListSizeY" (diagSize.y as string)
		)
	)
	
	on AFScriptsList_Roll moved pos do
	(
		if AFScriptsList_Roll.placement == #normal do
		(
			diagPos = getDialogPos AFScriptsList_Roll
			setINISetting (getMAXIniFile()) "ScriptsListDefs" "ScriptsListPosX" (diagPos.x as string)
			setINISetting (getMAXIniFile()) "ScriptsListDefs" "ScriptsListPosY" (diagPos.y as string)
		)
	)

	on AFScriptsList_Roll close do ()

	fn runScript =
	(
		fileIn (getScriptFile lbScripts.selectedItems.item[0])
		if chbLock.checked == false do destroyDialog AFScriptsList_Roll
	)
	
	on lbScripts DoubleClick arg do runScript()

	on lbScripts KeyUp arg do
	(
		if arg.KeyCode == (dotnetClass "System.Windows.Forms.Keys").Enter do runScript()
		if arg.KeyCode == (dotnetClass "System.Windows.Forms.Keys").Escape do destroyDialog AFScriptsList_Roll
	)

	fn deleteLikeItems =
	(
		likeScripts = getLikeScripts()
		for itm = lbScripts.items.count-1 to 0 by -1 do
		(
			if lbScripts.items.item[itm].selected do deleteItem likeScripts (itm+1)
		)
		setLikeScripts likeScripts
		populateList()
	)
	
	rollout rollAbout "关于" width:232 height:112
	(
		button bUninstall "卸载脚本列表" pos:[16,8] width:200 height:24
		label lbl1 "脚本列表灯光 1.0" pos:[8,40] width:96 height:13
		label lbl4 "06.09.2019" pos:[160,40] width:60 height:15 color:(color 0 0 255)
		dotNetControl lbl5 "System.Windows.Forms.TextBox" pos:[112,54] width:110 height:10
		dotNetControl bDonate "System.Windows.Forms.Button" pos:[16,80] width:200 height:24
	
		on rollAbout open do
		(
			lbl5.height = 10
			lbl5.multiLine = false
			lbl5.readOnly = true
			lbl5.hideSelection = false
			col  = (colorMan.getColor #windowText) * 255
			lbl5.BackColor = (dotnetclass "System.Drawing.Color").FromArgb col.x col.y col.z
			lbl5.TextAlign = (dotnetclass "System.Windows.Forms.HorizontalAlignment").Center
			lbl5.selectAll()
			bDonate.text = "青云设计素材"
			bDonate.backColor = (dotNetClass "System.Drawing.Color").fromARGB 135 6 6
			bDonate.foreColor = (dotNetClass "System.Drawing.Color").fromARGB 250 250 250
		)
		
		on lbl5 Click arg do lbl5.selectAll()
		
		on bUninstall pressed do
		(
			if queryBox "卸载脚本列表，您是否?" do
			(
				try(deleteFile ((getDir #scripts) + "\\ScriptsListLight.ms"))catch()
				for i in (getFiles ((getDir #userMacros) + "\\Andrfil-ScriptsList*.mcr")) do deleteFile i
				try(destroyDialog AFScriptsList_Roll)catch()
			)
		)
		
		on bDonate click arg do
		(
			bSite = "https://qysc.taobao.com/"
			ShellLaunch bSite ""
		)
	)
	
	on bAbout pressed do createDialog rollAbout
		
	--on tmEsc tick do try(if keyboard.escPressed and (AFScriptsList_Roll.) do destroyDialog AFScriptsList_Roll)catch()
	
	on AFScriptsList_Roll close do try(destroyDialog rollAbout)catch()

)
try(
	diagPosX = getINISetting (getMAXIniFile()) "ScriptsListDefs" "ScriptsListPosX"
	diagPosY = getINISetting (getMAXIniFile()) "ScriptsListDefs" "ScriptsListPosY"
	diagPos = execute ("[" + diagPosX + "," + diagPosY + "]")
	createDialog AFScriptsList_Roll pos:diagPos style:#(#style_resizing,#style_minimizebox,#style_titlebar,#style_border,#style_sysmenu)
)catch(createDialog AFScriptsList_Roll style:#(#style_resizing))