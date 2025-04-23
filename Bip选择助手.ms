-- ¸¸µçÀÌ : ÀÌ»ó¿ø
-- »ç¿ë ¹× ¼öÁ¤Àº ÀÚÀ¯ÀÔ´Ï´Ù. ÇÏÁö¸¸ Àç ¹èÆ÷´Â ±ÝÁöÇÕ´Ï´Ù.

global SoxBipedAssist		-- ·Ñ¾Æ¿ô¸íÀ» ±Û·Î¹ú º¯¼ö·Î ÀÎ½ÄÇÏ±â À§ÇØ ÃÊ±â¿¡ ÇÑ ¹ø »ç¿ë

global rolLoadSelSetAssist

global strXmlRootNameAssist = "SelectionSet_Tools"


global arrSelSetNameLoadedAssist
global arrSelSetObjLoadedAssist
try (
	cui.unRegisterDialogBar SoxBipedAssist 
	destroydialog SoxBipedAssist
	) catch()
try (callbacks.removeScripts #filePostOpen id:#UpdateSelSetList) catch ()
	
fn fnSaveSelSetAll pathXml = 
(
	local dotNetXmlDoc = dotNetObject "System.xml.xmlDocument"
	local rootElement = dotNetXmlDoc.createElement strXmlRootNameAssist
	dotNetXmlDoc.appendChild rootElement

	for s in selectionSets do
	(
		local setElement = dotNetXmlDoc.createElement "SelectionSet"
		setElement.SetAttribute "SetName" s.name
		rootElement.appendChild setElement

		for o in s do
		(
			local objElement = dotNetXmlDoc.createElement "ObjectName"
			objElement.InnerText = o.name
			setElement.appendChild objElement
		)
	)
	dotNetXmlDoc.save pathXml
)

fn fnLoadSelXml pathXml = 
(
	local dotNetXmlDoc = dotNetObject "System.xml.xmlDocument"
	dotNetXmlDoc.Load pathXml
	local rootElement = dotNetXmlDoc.DocumentElement
	
	if rootElement.name != strXmlRootNameAssist then
	(
		messagebox "Õâ²»ÊÇBsSelSetTools´´½¨µÄXMLÎÄ¼þ¡£          \t"
		undefined
	)
	
	local nodesSelSet = rootElement.ChildNodes

	local arrSelSetName = #()
	local arrSelSetObj = #()

	for i = 0 to nodesSelSet.count - 1 do
	(
		local elemSelSet = nodesSelSet.Item[i]
		
		append arrSelSetName (elemSelSet.Attributes.GetNamedItem "SetName").value
		
		local objNodes = elemSelSet.ChildNodes
		
		arrSelSetObj[i+1] = #()
		for j = 0 to objNodes.count - 1 do
		(
			local objElement = objNodes.Item[j]
			append arrSelSetObj[i+1] objElement.InnerText
		)
	)
	local result = #(arrSelSetName, arrSelSetObj)
	result
)

fn fnCreateSelSet arrSelSetName arrSelSetObj n = 
(
	local re_selset_obj_list = #()
	for o in arrSelSetObj[n] do
	(
		if getNodeByName o != undefined  then
		(
			append re_selset_obj_list o
		)
	)
	if re_selset_obj_list.count != 0 then
	(
		local txt = "selectionSets[\""
		txt += arrSelSetName[n] + "\"] = #("
		for o in re_selset_obj_list do
		(
			txt += "$'" + o +"', "
		)
		txt = substring txt  1 (txt.count - 2)
		txt+= ")"

		execute txt
	)else
	(
		messagebox( "Selection Set \"" + arrSelSetName[n] + "\" ÊÇ¿ÕµÄ¡£\nÑ¡Ôñ¼¯\"" + arrSelSetName[n] + "\"°üº¬µÄ¶ÔÏó²»ÔÚ³¡¾°ÖÐ£¬ËùÒÔÎ´±»¶ÁÈ¡...                    \t")
	)
)

fn fnSortNames str1 str2 = stricmp str1 str2

fn fnUpdateSelSetList = 
(
	local arrNodesList = #()
	for s in selectionSets do
	(
		append arrNodesList s.name
	)
	qsort arrNodesList fnSortNames
	SoxBipedAssist.mlbSelSet.items = arrNodesList
	SoxBipedAssist.mlbSelSet.selection = 0
	SoxBipedAssist.mlbSelSetNode.items = #()
	SoxBipedAssist.lblCount.text = "¹² " + selectionsets.count as string + " ¸öÑ¡Ôñ¼¯"
)

rollout rolCreateSelSet "´´½¨Ñ¡Ôñ¼¯"
(
	edittext edtCreateName "ÃüÃû:" width:190 pos:[5,5]
	button btnDoCreate "ÒÔÑ¡ÖÐÎïÌå´´½¨Ñ¡Ôñ¼¯" width:190 pos:[5,30]

	on btnDoCreate pressed do 
	(
		local strCreate = edtCreateName.text
		local arrSelection = getcurrentselection()
		local arrSelSetName = for i in selectionsets collect i.name
		if ((strCreate != "") or (strCreate != undefined)) then 
		(
			if finditem arrSelSetName strCreate != 0 then
			(
				local duplicateSelSetName = arrSelSetName[finditem arrSelSetName strCreate]
				if (queryBox ("µ±Ç°ÒÑÓÐÖØÃûÑ¡Ôñ¼¯£¬\r\n\r\nÖØÃûÑ¡Ôñ¼¯£º\"" + duplicateSelSetName + "\"\r\n\r\nÊÇ·ñ½«Ñ¡ÔñÎïÌåÌí¼Ó½ø¸ÃÑ¡Ôñ¼¯£¿                                  ") \
				title:"Ñ¡Ôñ¼¯ÖØÃû" beep:false) then
				(
					selectionsets[duplicateSelSetName] = join (join #() selectionsets[duplicateSelSetName]) arrSelection
					fnUpdateSelSetList()
				)
			)
			else (selectionsets[strCreate] = arrSelection;fnUpdateSelSetList())
		)
	
		try(destroydialog rolCreateSelSet)catch()
	)
)

rollout rolLoadSelSetAssist "¼ÓÔØÑ¡Ôñ¼¯"
(
	multilistbox mlbLoadSelSet "Ñ¡Ôñ¼¯ÁÐ±í" height:22
	button btnLoadSel "¼ÓÔØÑ¡ÖÐ" width:80 height: 25 across:2
	button btnLoadAll "¼ÓÔØËùÓÐ" width:80 height:25
		
	on btnLoadSel pressed do
	(
		for n in mlbLoadSelSet.selection do
		(
			fnCreateSelSet arrSelSetNameLoadedAssist arrSelSetObjLoadedAssist n
		)
		fnUpdateSelSetList()
		try(destroydialog rolLoadSelSetAssist)catch()
	)
	
	on btnLoadAll pressed do(
		for n = 1 to mlbLoadSelSet.items.count do
		(
			fnCreateSelSet arrSelSetNameLoadedAssist arrSelSetObjLoadedAssist n
		)
		fnUpdateSelSetList()
		try(destroydialog rolLoadSelSetAssist)catch()
	)
)

rollout SoxBipedAssist "Sox BipedÖúÊÖ v0.423"
(
	local mc_setKeyColor = color 140 0 0
	local mc_spineColor = color 8 110 134
	local Left_Right ="R"
	
	checkButton uiChkBtnScanBiped "É¨ÃèBiped" width:70 checked:true highlightColor:(color 180 0 80) tooltip:"»º´æbipedÑ¡Ôñ¼¯ÒÔ¸ü¿ì²Ù×÷,Èç¹ûbipedÅäÖÃ·¢Éú¸ü¸Ä,ÐèÖØÐÂÉ¨Ãè,Èç¹ûÓÐ¶à¸öbiped,½öÉ¨ÃèÑ¡ÔñµÄbiped." across:2
	button uiAbout "<< >>" tooltip:"×óÓÒÍ£¿¿"
	checkBox uiChkSelHiddenObj "Ñ¡ÔñÒþ²ØµÄbiped" checked:true
	
	group ""
	(
	checkButton uiHead "0_0" width: 50 height:33 checked:true highlightColor:(color 55 137 221) offset:[0, -4]
	checkButton uiNecks "Necks" width: 35 checked:true highlightColor:mc_spineColor align:#center offset:[0, -4]
	
	checkButton uiRArms "Arms" checked:true highlightColor:(color 6 95 6) width:34 align:#left offset:[-8, -30] across:2
	checkButton uiLArms "Arms" checked:true highlightColor:(color 28 28 128) width:34 align:#right offset:[8, -30]
	
	checkButton uiRClavicle "R Clavicle" width:54 height:16 checked:true highlightColor:(color 6 134 6) across:2
	checkButton uiLClavicle "L Clavicle" width:54 height:16 checked:true highlightColor:(color 28 28 177) offset:[20, 0]
	
	checkButton uiAllSpine height:58 width:26 checked:true highlightColor:mc_spineColor offset:[-12, -4] align:#center tooltip:"All Spine"
	checkButton uiSpine2 "2" width:26 height:18 checked:true highlightColor:mc_spineColor align:#center offset:[16, -62]
	checkButton uiSpine1 "1" width:26 height:18 checked:true highlightColor:mc_spineColor align:#center offset:[16, -4]
	checkButton uiSpine0 "0" width:26 height:18 checked:true highlightColor:mc_spineColor align:#center offset:[16, -4]
	
	checkButton uiCOM "COM" checked:true width:42 height:22 highlightColor:(color 55 137 221) offset:[0, -4]
	checkButton uiPelvis "Pelvis" checked:true highlightColor:(color 161 134 25) width:50 height:18 offset:[0, -4]
	
	checkButton uiRUpArm "R" width:25  height:30 offset:[-18, -104] checked:true highlightColor:(color 6 134 6) across:2
	checkButton uiLUpArm "L" width:25  height:30 offset:[18, -104] checked:true highlightColor:(color 28 28 177)
	checkButton uiRForArm "R" width:25  height:30 offset:[-18, -4] checked:true highlightColor:(color 6 134 6) across:2
	checkButton uiLForArm "L" width:25  height:30 offset:[18, -4] checked:true highlightColor:(color 28 28 177)
	checkButton uiRHand "Hand" offset:[-22, -4] checked:true highlightColor:(color 6 134 6) across:2
	checkButton uiLHand "Hand" offset:[22, -4] checked:true highlightColor:(color 28 28 177)
	
	checkButton uiRThigh "R" width:25  height:30 align:#right checked:true highlightColor:(color 6 134 6) offset:[-4, 12] across:2
	checkButton uiLThigh "L" width:25 height:30 align:#left checked:true highlightColor:(color 28 28 177) offset:[4, 12]
	checkButton uiRCalf "R" width:25  height:30 checked:true highlightColor:(color 6 134 6) align:#right  offset:[-4, -4] across:2
	checkButton uiLCalf "L" width:25  height:30 checked:true highlightColor:(color 28 28 177) align:#left offset:[4, -4]
	checkButton uiRFoot "R Foot" checked:true highlightColor:(color 6 134 6) align:#right offset:[0, -4] width:43 height:25 across:2
	checkButton uiLFoot "L Foot" checked:true highlightColor:(color 28 28 177) align:#left offset:[0, -4] width:43 height:25
	
	checkButton uiRLegs "Legs" checked:true highlightColor:(color 6 95 6) width:30 align:#left offset:[-4, -70] across:2
	checkButton uiLLegs "Legs" checked:true highlightColor:(color 28 28 128) width:30 align:#right offset:[4, -70]
	
	checkButton uiRToe "toe" checked:true highlightColor:(color 6 134 6) width:25 height:18 align:#left offset:[-3, 22] across:2
	checkButton uiLToe "toe" checked:true highlightColor:(color 28 28 177) width:25 height:18 align:#right offset:[3, 22]
	
	checkButton uiAllFoot "All Foot" width:60 checked:true highlightColor:mc_spineColor align:#center  offset:[0, 0]
	checkButton uiAllBip "All Biped" width:100 checked:true highlightColor:(color 55 137 221) offset:[0, -4] align:#center
		
	)
	group "¹Ø¼üÖ¡¸¨Öú" (
		checkButton uiBtnSetAllKey "ÉèÖÃËùÓÐÖ¡" checked:true highlightColor:mc_setKeyColor offset:[6, 0] across:3
		checkButton uiBtnLimbIK "IK" tooltip:"Shift + Click Ó¦ÓÃµ½ËùÓÐ¹Ø¼üÖ¡,\nCtrl + Click Ó¦ÓÃµ½Ñ¡¶¨¹Ø¼üÖ¡." checked:true highlightColor:(color 168 170 13) offset:[22, 0]
		checkButton uiBtnLimbFK "FK" tooltip:"Shift + Click Ó¦ÓÃµ½ËùÓÐ¹Ø¼üÖ¡,\nCtrl + Click Ó¦ÓÃµ½Ñ¡¶¨¹Ø¼üÖ¡." checked:true highlightColor:(color 86 87 7) offset:[8, 0]
        
		label uiLabelLoopRagne "Ñ­»·" tooltip:"Loop Range" align:#left offset:[-2, 2] across:4
		spinner uiSpnLoopStart tooltip:"ÆðÊ¼" type:#integer range:[-9999,9999,0] width:40 align:#left offset:[-12, 2]
		spinner uiSpnLoopEnd tooltip:"½áÊø" type:#integer range:[-9999,9999,30] width:40 align:#left offset:[-6, 2]
		button uiBtnGotoMirror "¾µÏñ" tooltip:"Ìø×ªµ½¾µÏñÖ¡" align:#right offset:[8, -2] width:38
		checkButton uiBtnLoopTrim "ÐÞ¼õ" width:40 offset:[-3, -2] checked:true highlightColor:mc_setKeyColor tooltip:"É¾³ý·¶Î§ÍâËùÓÐ¹Ø¼üÖ¡" across:4
		-- checkButton uiBtnLoopDupe "Dupl." width:40 offset:[6, 0] checked:true highlightColor:(color 60 0 0) tooltip:"Duplicate the keys before and after the Loop."
		checkButton uiBtnLoopSel "Ñ¡Ôñ" width:40 offset:[6, -2] checked:true highlightColor:(color 123 74 0) align:#center tooltip:"Ñ¡Ôñ·¶Î§ÄÚËùÓÐ¹Ø¼üÖ¡"
		button uiBtnLoopGet "·¶Î§" offset:[12, -2] width:30 tooltip:"»ñÈ¡µ±Ç°Ê±¼äÖá·¶Î§"
		button uiBtnLoopSet "ÉèÖÃ" offset:[10, -2] width:30 tooltip:"ÉèÖÃÎªÊ±¼äÖá·¶Î§"
    )
	
	dropdownlist uiDropPlaySpeed items:#("1/4x Speed", "1/2x Speed", " 1x Speed", "2x Speed", "4x Speed") selection:3 tooltip:"Playback Speed" width:90 offset:[-8, 0] across:2
	checkbutton uiPlayBlock "²¥·ÅBlock" offset:[14, 0] width:60 tooltip:"²¥·ÅÑ¡¶¨bipedÖ«ÌåµÄBlock¶¯»­"
	timer clock "PlayClock" interval:1 active:false -- °¡Àå ºü¸¥ ÀÎÅÍ¹ú·Î
	
	
	
	group "Ñ¡Ôñ¼¯¹¤¾ß"
	(
	button btnCreateSelSet "´´½¨" width:30 height:20  enabled:true tooltip:"´´½¨Ñ¡Ôñ¼¯" across:4
	button btnDeleteSelSet "É¾³ý" width:30 height:20  enabled:true tooltip:"É¾³ýÑ¡Ôñ¼¯" 
	button btnSaveXml "±£´æ" width:30 height:20  tooltip:"±£´æÑ¡Ôñ¼¯" 
	button btnLoadXml "¼ÓÔØ" width:30 height:20  tooltip:"¼ÓÔØÑ¡Ôñ¼¯" 
	button btnAddToSelSet "Ìí¼Ó" width:30 height:20  enabled:true tooltip:"Ìí¼ÓËùÑ¡ÎïÌåµ½Ñ¡ÖÐµÄÑ¡Ôñ¼¯" across:4
	button btnRemoveFromSelSet "ÒÆ³ý" width:30 height:20  enabled:true tooltip:"´ÓÑ¡ÖÐµÄÑ¡Ôñ¼¯ÖÐÒÆ³ýËùÑ¡ÎïÌå" 
	button btnHighlightSelObj "¸ßÁÁ" width:30 height:20  enabled:true tooltip:"¸ßÁÁÑ¡ÖÐÎïÌå¼°ÆäËùÔÚÑ¡Ôñ¼¯"
	button btnUpdateList "¸üÐÂ" width:30 height:20 tooltip:"¸üÐÂÁÐ±í" 
	
	
		
	MultiListBox mlbSelSet "" width:135 height:6
	MultiListBox mlbSelSetNode "" width:135 height:6  enabled:true
	label lblCount "" width:135 height:15 
	)

    local m_workingBipRoot -- ÇöÀç ÀÛ¾÷ÁßÀÎ ¹ÙÀÌÆÐµåÀÇ ·çÆ® ³ëµå

	local m_Head
	local m_RArms
	local m_Necks
	local m_LArms
	local m_RClavicle
	local m_LClavicle
	local m_RUpArm
	local m_AllSpine
	local m_Spine2
	local m_Spine1
	local m_Spine0
	local m_LUpArm
	local m_RForArm
	local m_LForArm
	local m_RHand
	local m_COM
	local m_LHand
	local m_Pelvis
	local m_RThigh
	local m_LThigh
	local m_RCalf
	local m_LCalf
	local m_RFoot
	local m_LFoot
	local m_RToe
	local m_LToe
	local m_RLegs
	local m_AllFoot
	local m_LLegs
	local m_AllBip

	local m_goto1
	local m_goto2
	local m_goto3
	local m_goto4
	local m_goto5
	local m_goto6
	local m_goto7
    local m_goto8
    
    local m_PBKeyTimeArray      -- ºí·°Å· ¾Ö´Ï¸ÞÀÌ¼Ç¿ë Å° Å¸ÀÓ ¹è¿­ ·ÎÄÃ º¯¼ö (Frame)
    local m_PBKeyMiliSecArray  -- ºí·°Å· ¾Ö´Ï¸ÞÀÌ¼Ç¿ë Å° Å¸ÀÓ ¹è¿­ ·ÎÄÃ º¯¼ö (¹Ð¸®¼¼ÄÁµå)
    local m_PBStartTime     -- ºí·°Å· ¾Ö´Ï¸ÞÀÌ¼Ç ¹Ýº¹ ½ÃÀÛ½Ã°£ ºñ±³¿ë ±â·Ï
    local m_PBPointer       -- ¾îµð±îÁö Àç»ýÁßÀÎÁö ±â·ÏÇÏ´Â Æ÷ÀÎÅÍ
    local m_PBPlaySpeed     -- Àç»ý ¼Óµµ °¡¼Ó °¨¼Ó¿ë, uiDropPlaySpeed ¿Í ¿¬µ¿µÊ
	
	struct BipType
	(
		limbName,
		linkIndex
    )
    
    function SetPBPlaySpeed = (
        case timeConfiguration.playbackSpeed of (
        1: (m_PBPlaySpeed = 4.0) -- 1/4 ¼Óµµ¶ó¼­ 4¹è ´õ Å« ½Ã°£ °ªÀ» Àû¿ëÇØ¾ßÇÔ
        2: (m_PBPlaySpeed = 2.0)
        3: (m_PBPlaySpeed = 1.0)
        4: (m_PBPlaySpeed = 0.5)
        5: (m_PBPlaySpeed = 0.25) -- 4¹è ¼Óµµ¶ó¼­ 0.25¹è ÀÛÀº ½Ã°£°ªÀ» Àû¿ëÇØ¾ßÇÔ
        )
    )

	-- ¹ÙÀÌÆÐµå COMÀÎÁö °Ë»ç
	fn IfBipRoot obj = (
		if ((classof obj.baseobject) == Biped_Object) do (
			if (obj.controller.rootNode == obj) do (return true)
		)
		return false
	)

	fn SaveRangeLoop = (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do return ()
		setUserProp m_workingBipRoot "SoxBA_RangeLoopStart" uiSpnLoopStart.value
		setUserProp m_workingBipRoot "SoxBA_RangeLoopEnd" uiSpnLoopEnd.value
	)

	fn LoadRangeLoop = (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do return ()
		try (
			uiSpnLoopStart.value = getUserProp m_workingBipRoot "SoxBA_RangeLoopStart"
			uiSpnLoopEnd.value = getUserProp m_workingBipRoot "SoxBA_RangeLoopEnd"
		) catch ()
	)

	fn SaveRangeA = (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do return ()
		
		
	)

	fn LoadRangeA = (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do return ()
		
	)

	fn SaveRangeB = (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do return ()
		
	)

	fn LoadRangeB = (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do return ()

	)

	fn LoadGoto = (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do return ()
		try (
			m_goto1 = getUserProp m_workingBipRoot "SoxBA_Goto1"
			if (m_goto1 == "undefined") do (m_goto1 = undefined)
			m_goto2 = getUserProp m_workingBipRoot "SoxBA_Goto2"
			if (m_goto2 == "undefined") do (m_goto2 = undefined)
			m_goto3 = getUserProp m_workingBipRoot "SoxBA_Goto3"
			if (m_goto3 == "undefined") do (m_goto3 = undefined)
			m_goto4 = getUserProp m_workingBipRoot "SoxBA_Goto4"
			if (m_goto4 == "undefined") do (m_goto4 = undefined)
			m_goto5 = getUserProp m_workingBipRoot "SoxBA_Goto5"
			if (m_goto5 == "undefined") do (m_goto5 = undefined)
			m_goto6 = getUserProp m_workingBipRoot "SoxBA_Goto6"
			if (m_goto6 == "undefined") do (m_goto6 = undefined)
			m_goto7 = getUserProp m_workingBipRoot "SoxBA_Goto7"
			if (m_goto7 == "undefined") do (m_goto7 = undefined)
			m_goto8 = getUserProp m_workingBipRoot "SoxBA_Goto8"
			if (m_goto8 == "undefined") do (m_goto8 = undefined)
		) catch ()
	)

	fn SaveGoto ui val index = (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do return ()
		local pString = "SoxBA_Goto" + (index as string)
		try (
			setUserProp m_workingBipRoot pString val
		) catch ()
	)

	fn SetGotoBtnTextSub ui val = (
		local tString
		if (val == undefined) then (tString = "") else (tString = (val as string))
		ui.text = tString
		ui.tooltip = tString
	)

	


	-- m_goto1 µîÀÇ º¯¼ö¸¦ ÂüÁ¶ Çü½ÄÀ¸·Î &val ¸Å°³º¯¼ö¿¡ Àü´Þ
	fn GotoFrame ui &val index = (
		if (keyboard.controlPressed) do (
			val = int sliderTime
			
			SaveGoto ui val index
			return ()
		)

		if (keyboard.altPressed) do (
			val = undefined
			
			SaveGoto ui val index
			return ()
		)

		if (val != undefined) do (
			try (
				sliderTime = val
			) catch ()
		)
	)
	
		-- ¸®ÅÏ ½ºÆ®·°ÃÄÀÇ ¸â¹ö : limbName, linkIndex
	function GetBipedType obj = (
		if ( obj == undefined ) do return undefined
		if ( (classof obj.baseobject) != Biped_Object ) do return (bipType limbName:#nonBiped linkIndex:0)
		
		-- biped.maxNumLinks $ ÀÌ ¹æ¹ýÀ¸·Î ¹ÙÀÌÆÐµåÀÇ ÃÖ´ë ¸µÅ© ¼ö¸¦ ¾Ë¾Æ³¾ ¼ö ÀÖ´Ù. º¸Åë 25ÀÌÁö¸¸ ³Ë³ËÇÏ°Ô 30
		loopCount = 30
		types = #(
			#larm,
			#rarm,
			#lfingers,
			#rfingers,
			#lleg,
			#rleg,
			#ltoes,
			#rtoes,
			#spine,
			#tail,
			#head,
			#pelvis,
			#vertical,
			#horizontal,
			#turn,
			#footprints,
			#neck,
			#pony1,
			#pony2,
			#prop1,
			#prop2,
			#prop3,
			#lfArmTwist,
			#rfArmTwist,
			#lUparmTwist,
			#rUparmTwist,
			#lThighTwist,
			#rThighTwist,
			#lCalfTwist,
			#rCalfTwist,
			#lHorseTwist,
			#rHorseTwist			
		)
		
		for o in types do (
			for p = 1 to loopCount do (
				if ( try ( obj == biped.getNode obj o link:p ) catch false ) do (
					returnType = (bipType limbName:o linkIndex:p)
					return returnType
				)
			)
		)
		
		-- ¸Æ½º ½ºÅ©¸³Æ®¿¡¼­ Xtra º»À» ÀüÇô Áö¿øÇÏÁö ¾Ê¾Æ¼­ ¾îÂ¿ ¼ö ¾øÀÌ ¹ÙÀÌÆÐµå Å¬·¡½ºÀÎµ¥ Á¤Ã¼¸¦ ¾Ë¾Æ³»Áö ¸øÇÑ°Ç ¸ðµÎ Xtra·Î Á¤ÀÇ
		-- https://forums.cgsociety.org/t/biped-xtra-maxscript-commands/1570351/5 ¼û°ÜÁø ¹ÙÀÌÆÐµå Xtra ÇÔ¼öµéÀ» Á» »ìÆìºÁ¾ßÇÒµí.
		return (bipType limbName:#xtra linkIndex:0)
	)
	
	-- ÇöÀç ¿ÀºêÁ§Æ®°¡ ¾Ö´Ï¸ÞÀÌ¼Ç Å° ÁöÁ¤ÀÌ °¡´ÉÇÑ ¹ÙÀÌÆÐµåÀÎÁö¸¦ °Ë»ç true ¿Í false ¸®ÅÏ
	function IfKeyableBip obj =
	(
		if ( classof obj.baseobject != Biped_object ) do return false
		
		tType = GetBipedType obj
		
		returnBool = case tType.limbName of
		(
			#footprints: false
			#lfArmTwist: false
			#rfArmTwist: false
			#lUparmTwist: false
			#rUparmTwist: false
			#lThighTwist: false
			#rThighTwist: false
			#lCalfTwist: false
			#rCalfTwist: false
			#lHorseTwist: false
			#rHorseTwist: false
			default: true
		)
		return returnBool
	)
	
	-- ¹ÙÀÌÆÐµå ºÎÀ§µé Áß Limb, COM, NoKey, Etc ¸¦ ±¸ºÐÇÏ¿© ¸®ÅÏ (¾Ö´Ï¸ÞÀÌ¼Ç Å° º¹Á¦ ¹æ½ÄÀÌ ´Ù¸§)
	function GetBipKeyType obj = (
		if ( classof obj.baseobject != Biped_object ) do return false
		
		tType = GetBipedType obj

		if tType.limbName == #vertical OR\
			tType.limbName == #horizontal OR\
			tType.limbName == #turn do (
			return "COM"
		)

		if tType.limbName == #larm OR\
			tType.limbName == #rarm OR\
			tType.limbName == #lleg OR\
			tType.limbName == #rleg OR\
			tType.limbName == #ltoes OR\
			tType.limbName == #rtoes do (
				return "Limb"
		)

		if tType.limbName == #lfArmTwist OR\
			tType.limbName == #rfArmTwist OR\
			tType.limbName == #lUparmTwist OR\
			tType.limbName == #rUparmTwist OR\
			tType.limbName == #lThighTwist OR\
			tType.limbName == #rThighTwist OR\
			tType.limbName == #lCalfTwist OR\
			tType.limbName == #rCalfTwist OR\
			tType.limbName == #lHorseTwist OR\
			tType.limbName == #rHorseTwist OR\
			tType.limbName == #footprints do (
				return "NoKey"
		)
		
		return "Etc"
	)

	-- ¹ÙÀÌÆÐµå Limb Àü¿ë ±â´ÉÀ» À§ÇØ Limb ÀÎÁö Ã¼Å©ÇÏ´Â ÇÔ¼ö
	function IfLimb obj = (
		if ( classof obj.baseobject != Biped_object ) do return false
		tType = GetBipedType obj
		if tType.limbName == #larm OR\
			tType.limbName == #rarm OR\
			tType.limbName == #lleg OR\
			tType.limbName == #rleg OR\
			tType.limbName == #ltoes OR\
			tType.limbName == #rtoes do (
				return true
		)
		return false
	)
	
    fn DeselectAllKeys obj = (
		-- Ã³À½¿£ º¹ÀâÇÑ ¹æ¹ýÀ¸·Î ÀÏÀÏÀÌ Å° ÇÏ³ª¾¿ ·çÇÁ µ¹¾Æ°¡¸ç ¼±ÅÃ ÇØÁ¦Çß´Âµ¥, ¹¶¶×±×·Á¼­ controller ·Î ÇÏ´Ï Àß µÇ´Âµí
		deselectKeys obj.controller
	)
	
	-- ÀÌ ÇÔ¼ö´Â »èÁ¦ Àü Deselect ´Â °í·ÁÇÏÁö ¾ÊÀ½. (±âÁ¸¿¡ Deselect µÇ¾î¼­ ÁøÀÔÇÑ °ÍÀ» ÀüÁ¦·Î ÇÔ)
	fn TrimKeys controller frameStart frameEnd ifBip = (
		local firstKeyTime
		local lastKeyTime
		if (ifBip) then (
			local keyCount = numKeys controller
			if keyCount < 1 do return()
			firstKeyTime = (getKey controller 1).time
			lastKeyTime = (getKey controller keyCount).time
		)
		else (
			firstKeyTime = -99999
			lastKeyTime = 99999
		)

		if (firstKeyTime < frameStart) do (
			-- º¸Á¸ ±¸°£º¸´Ù ¾ÕÂÊ¿¡ Å°°¡ ÀÖ´Â °æ¿ì
			selectKeys controller (interval firstKeyTime (frameStart - 1))
		)
		if (lastKeyTime > frameEnd) do (
			-- º¸Á¸ ±¸°£º¸´Ù µÚÂÊ¿¡ Å°°¡ ÀÖ´Â °æ¿ì
			selectKeys controller (interval lastKeyTime (frameEnd + 1))
		)

		if (ifBip) then (
			biped.deleteKeys controller #selection
		)
		else (
			deleteKeys controller #selection
		)
	)

    -- obj ÀÇ ¸ðµç ÀÚ½ÄµéÀ» ¹è¿­·Î ¸®ÅÏ. ¹è¿­ ¼ø¼­´Â °èÃþ±¸Á¶ ¼ø¼­´ë·Î
	function fnGetAllChildren obj = (
		if ( obj == undefined ) do return undefined
		
		local tAllChildren = #()
		if ( obj.children.count != 0 ) do (
			for o in obj.children do (
				append tAllChildren o
				if ( o.children.count != 0 ) do (
					tAllChildren = tAllChildren +  (fnGetAllChildren o)		-- recursive
				)
			)
		)
		return tAllChildren
	)
	
    fn SetComBtnText state = (
        if state then (
            uiCOM.text = m_workingBipRoot.name
        )
        else (
            uiCOM.text = "COM"
        )
    )

    fn SetButtonState state = (
        uiHead.state = state
        uiRArms.state = state
        uiNecks.state = state
        uiLArms.state = state
        uiRClavicle.state = state
        uiLClavicle.state = state
        uiRUpArm.state = state
		uiAllSpine.state = state
		uiSpine2.state = state
		uiSpine1.state = state
		uiSpine0.state = state
        uiLUpArm.state = state
        uiRForArm.state = state
        uiLForArm.state = state
        uiRHand.state = state
        uiCOM.state = state
        if state == false do uiCOM.text = "COM"
        uiLHand.state = state
        uiPelvis.state = state
        uiRThigh.state = state
        uiLThigh.state = state
        uiRCalf.state = state
        uiLCalf.state = state
        uiRFoot.state = state
		uiLFoot.state = state
		uiRToe.state = state
		uiLToe.state = state
        uiRLegs.state = state
        uiAllFoot.state = state
        uiLLegs.state = state
		uiAllBip.state = state
		uiPlayBlock.state = state
    )
	
	-- ¾À ³» ¹ÙÀÌÆÐµå ¿ÀºêÁ§Æ®¸¦ ¸ðµÎ Á¶»çÇÏ¿© ¹ÙÀÌÆÐµå°¡ ÇÏ³ª¸¸ ÀÖÀ¸¸é ±× ¹ÙÀÌÆÐµå¸¦ m_workingBipRoot¿¡ ¼¼ÆÃ.
	-- ÇöÀç ¼±ÅÃµÈ ¿ÀºêÁ§Æ®°¡ ¹ÙÀÌÆÐµå¸é ±×°ÍÀ» ¼¼ÆÃ
	-- ¼±ÅÃÀÌ ¼º°øÇÏ¸é true, ½ÇÆÐÇÏ¸é false ¸®ÅÏ
	function AutoGetBipRoot = (
		if ( try(classof selection[1].baseobject == Biped_object) catch false ) do (
            m_workingBipRoot = selection[1].controller.rootnode
            SetComBtnText true
            return true
		)
		
		for o in objects do (
			if (classof o.baseobject == Biped_object) do (
                m_workingBipRoot = o.controller.rootnode
                SetComBtnText true
                return true
			)
        )
        m_workingBipRoot = undefined -- ¾ÀÀ» »õ·Î ¿ÀÇÂÇÑ´Ù°Å³ª ÇÏ¸é »èÁ¦µÈ ¿ÀºêÁ§Æ®¸¦ ±â¾ïÇÏ°í ÀÖÀ» ¼ö ÀÖ¾î¼­ (undefined ¾Æ´Ô) ¹Ýµå½Ã undefined ·Î ÃÊ±âÈ­ÇØÁà¾ßÇÔ.
        SetComBtnText false
        SetButtonState false
		return false
	)

	-- ¹è¿­ »©±â
	function ArraySubtract arrFrom arrSub = (
		if arrSub.count == 0 do (return arrFrom)
		
		for o in arrSub do (
			foundNum = findItem arrFrom o
			if foundNum != 0 do (
				deleteItem arrFrom foundNum
			)
		)
		return arrFrom
	)
	
	-- ±âÁ¸ selection ¹é¾÷°ú ÀÌ¹ø¿¡ ¼±ÅÃÇÒ selArr À» ÀÔ·Â¹Þ¾Æ ÀûÀýÇÏ°Ô ¼±ÅÃÇÑ´Ù. ºÎ¼öÀûÀ¸·Î ¸ð¼ÇÆÐ³Î·ÎÀÇ º¯°æµµ °°ÀÌ ¼öÇà
    -- selBackup À» »ç¿ëÇÒÁö´Â ¹ÌÁ¤
    -- selBackup Àº selection as array
	function CompSelect selBackup selArr = (
		-- ´ÜÃàÅ° Á¶ÇÕÀÌ ¾Æ¹«°Íµµ ´­·¯Á®ÀÖÁö ¾ÊÀ¸¸é ºü¸£°Ô ±×³É ¼±ÅÃ ÈÄ ¸®ÅÏ
		if (keyboard.controlPressed == false) and (keyboard.altPressed == false) do (
			undo on (
				select selArr
			)
			return()
		)

		if keyboard.controlPressed do (
			selArr += selBackup
		)
		
		if keyboard.altPressed do (
			selArr = ArraySubtract selBackup selArr
		)
		
		undo on (
			if selArr.count == 0 then (
				clearSelection()
			)
			else (
				--setCommandPanelTaskMode mode:#motion
				select selArr
			)
		)
	)

	-- ¹ÙÀÌÆÐµå ¹è¿­ÀÌ Á¤»óÀûÀÎÁö Ã¼Å©ÇÏ¿© ¸®ÅÏ
	fn IfExistBips bipArr = (
		if (bipArr == undefined) do return false
		if (bipArr.count == 0) do return false
		for obj in bipArr do (
			-- »èÁ¦µÈ ¿ÀºêÁ§Æ®¿¡ ´ëÇØ Ã³¸®ÇÏ·Á°í ÇÏ¸é ¿¡·¯°¡ ³ª¹Ç·Î try Ã³¸®
			try (
				if (obj == undefined) do return false
				if ((classof obj.baseobject) != Biped_Object) do return false
			) catch (return false)
		)
		return true
	)

	-- ÀÌÇÏ ¹ÙÀÌÆÐµå ºÎÀ§µéÀ» ¾ò¾î¿À´Â ÇÔ¼öµéÀº m_workingBipRoot¸¦ ´ë»óÀ¸·Î ÀÛµ¿
	fn GetHead = (
		selObj = biped.getNode m_workingBipRoot #head
		if ( selObj.isHidden == false ) or uiChkSelHiddenObj.state then (
			return #(selObj)
		)
		else (
			return #()
		)
	)
	fn GetRArms = (
		tArr = #()
		for i = 1 to 4 do (
			selObj = biped.getNode m_workingBipRoot #rarm link:i
			if selObj != undefined do -- ¹ÙÀÌÆÐµå ½ºÆ®·°Ã³ ¼³Á¤¿¡ µû¶ó ÆÈÀÌ ¾ø´Â µî ¿¹¿Ü°¡ ÀÖÀ» ¼ö ÀÖÀ½
			(
				if ( selObj.isHidden == false ) or uiChkSelHiddenObj.state do (
					append tArr selObj
				)
			)
		)
		return tArr
	)
	fn GetNecks = (
		tArr = #()
		testBool = true
		tIndex = 1
		while testBool do (
			selObj = biped.getNode m_workingBipRoot #neck link:tIndex
			if ( selObj == undefined ) then (
				testBool = false
			)
			else (
				if ( selObj.isHidden == false ) or uiChkSelHiddenObj.state do (
					append tArr selObj
				)
			)
			tIndex += 1
		)
		return tArr
	)
	fn GetLArms = (
		tArr = #()
		for i = 1 to 4 do (
			selObj = biped.getNode m_workingBipRoot #larm link:i
			if selObj != undefined do -- ¹ÙÀÌÆÐµå ½ºÆ®·°Ã³ ¼³Á¤¿¡ µû¶ó ÆÈÀÌ ¾ø´Â µî ¿¹¿Ü°¡ ÀÖÀ» ¼ö ÀÖÀ½
			(
				if ( selObj.isHidden == false ) or uiChkSelHiddenObj.state do (
					append tArr selObj
				)
			)
		)
		return tArr
	)
	fn GetRClavicle = (
		selObj = biped.getNode m_workingBipRoot #rarm link:1
		if selObj == undefined do -- ¹ÙÀÌÆÐµå ½ºÆ®·°Ã³ ¼³Á¤¿¡ µû¶ó ÆÈÀÌ ¾ø´Â µî ¿¹¿Ü°¡ ÀÖÀ» ¼ö ÀÖÀ½
		(
			return #()
		)
		if ( selObj.isHidden == false ) or uiChkSelHiddenObj.state then (
			return #(selObj)
		)
		else (
			return #()
		)
	)
	fn GetLClavicle = (
		selObj = biped.getNode m_workingBipRoot #larm link:1
		if selObj == undefined do -- ¹ÙÀÌÆÐµå ½ºÆ®·°Ã³ ¼³Á¤¿¡ µû¶ó ÆÈÀÌ ¾ø´Â µî ¿¹¿Ü°¡ ÀÖÀ» ¼ö ÀÖÀ½
		(
			return #()
		)
		if ( selObj.isHidden == false ) or uiChkSelHiddenObj.state then (
			return #(selObj)
		)
		else (
			return #()
		)
	)
	fn GetRUpArm = (
		selObj = biped.getNode m_workingBipRoot #rarm link:2
		if selObj == undefined do -- ¹ÙÀÌÆÐµå ½ºÆ®·°Ã³ ¼³Á¤¿¡ µû¶ó ÆÈÀÌ ¾ø´Â µî ¿¹¿Ü°¡ ÀÖÀ» ¼ö ÀÖÀ½
		(
			return #()
		)
		if ( selObj.isHidden == false ) or uiChkSelHiddenObj.state then (
			return #(selObj)
		)
		else (
			return #()
		)
	)
	fn GetAllSpine = (
		tArr = #()
		testBool = true
		tIndex = 1
		while testBool do (
			selObj = biped.getNode m_workingBipRoot #spine link:tIndex
			if ( selObj == undefined ) then (
				testBool = false
			)
			else (
				if ( selObj.isHidden == false ) or uiChkSelHiddenObj.state do (
					append tArr selObj
				)
			)
			tIndex += 1
		)
		return tArr
	)
	fn GetSpine index = (
		selObj = biped.getNode m_workingBipRoot #spine link:(index + 1)
		if selObj == undefined do return #()
		if ( selObj.isHidden == false ) or uiChkSelHiddenObj.state then (
			return #(selObj)
		)
		else (
			return #()
		)
	)
	fn GetLUpArm = (
		selObj = biped.getNode m_workingBipRoot #larm link:2
		if selObj == undefined do -- ¹ÙÀÌÆÐµå ½ºÆ®·°Ã³ ¼³Á¤¿¡ µû¶ó ÆÈÀÌ ¾ø´Â µî ¿¹¿Ü°¡ ÀÖÀ» ¼ö ÀÖÀ½
		(
			return #()
		)
		if ( selObj.isHidden == false ) or uiChkSelHiddenObj.state then (
			return #(selObj)
		)
		else (
			return #()
		)
	)
	fn GetRForArm = (
		selObj = biped.getNode m_workingBipRoot #rarm link:3
		if selObj == undefined do -- ¹ÙÀÌÆÐµå ½ºÆ®·°Ã³ ¼³Á¤¿¡ µû¶ó ÆÈÀÌ ¾ø´Â µî ¿¹¿Ü°¡ ÀÖÀ» ¼ö ÀÖÀ½
		(
			return #()
		)
		if ( selObj.isHidden == false ) or uiChkSelHiddenObj.state then (
			return #(selObj)
		)
		else (
			return #()
		)
	)
	fn GetLForArm = (
		selObj = biped.getNode m_workingBipRoot #larm link:3
		if selObj == undefined do -- ¹ÙÀÌÆÐµå ½ºÆ®·°Ã³ ¼³Á¤¿¡ µû¶ó ÆÈÀÌ ¾ø´Â µî ¿¹¿Ü°¡ ÀÖÀ» ¼ö ÀÖÀ½
		(
			return #()
		)
		if ( selObj.isHidden == false ) or uiChkSelHiddenObj.state then (
			return #(selObj)
		)
		else (
			return #()
		)
	)
	fn GetRHand = (
		selObj = biped.getNode m_workingBipRoot #rarm link:4
		if selObj == undefined do -- ¹ÙÀÌÆÐµå ½ºÆ®·°Ã³ ¼³Á¤¿¡ µû¶ó ÆÈÀÌ ¾ø´Â µî ¿¹¿Ü°¡ ÀÖÀ» ¼ö ÀÖÀ½
		(
			return #()
		)
		if ( selObj.isHidden == false ) or uiChkSelHiddenObj.state then (
			return #(selObj)
		)
		else (
			return #()
		)
	)
	--fn GetCOM = ()
	fn GetLHand = (
		selObj = biped.getNode m_workingBipRoot #larm link:4
		if selObj == undefined do -- ¹ÙÀÌÆÐµå ½ºÆ®·°Ã³ ¼³Á¤¿¡ µû¶ó ÆÈÀÌ ¾ø´Â µî ¿¹¿Ü°¡ ÀÖÀ» ¼ö ÀÖÀ½
		(
			return #()
		)
		if ( selObj.isHidden == false ) or uiChkSelHiddenObj.state then (
			return #(selObj)
		)
		else (
			return #()
		)
	)
	fn GetPelvis = (
		selObj = biped.getNode m_workingBipRoot #pelvis
		if ( selObj.isHidden == false ) or uiChkSelHiddenObj.state then (
			return #(selObj)
		)
		else (
			return #()
		)
	)
	fn GetRThigh = (
		selObj = biped.getNode m_workingBipRoot #rleg link:1
		if ( selObj.isHidden == false ) or uiChkSelHiddenObj.state then (
			return #(selObj)
		)
		else (
			return #()
		)
	)
	fn GetLThigh = (
		selObj = biped.getNode m_workingBipRoot #lleg link:1
		if ( selObj.isHidden == false ) or uiChkSelHiddenObj.state then (
			return #(selObj)
		)
		else (
			return #()
		)
	)
	fn GetRCalf = (
		selObj = biped.getNode m_workingBipRoot #rleg link:2
		if ( selObj.isHidden == false ) or uiChkSelHiddenObj.state then (
			return #(selObj)
		)
		else (
			return #()
		)
	)
	fn GetLCalf = (
		selObj = biped.getNode m_workingBipRoot #lleg link:2
		if ( selObj.isHidden == false ) or uiChkSelHiddenObj.state then (
			return #(selObj)
		)
		else (
			return #()
		)
	)
	fn GetRFoot = (
		local footIndex = 4 -- HorseLink°¡ ÀÖ´Â °æ¿ì
		if (biped.getNode m_workingBipRoot #rleg link:4) == undefined do (
			footIndex = 3
		)
		selObj = biped.getNode m_workingBipRoot #rleg link:footIndex
		if ( selObj.isHidden == false ) or uiChkSelHiddenObj.state then (
			return #(selObj)
		)
		else (
			return #()
		)
	)
	fn GetLFoot = (
		local footIndex = 4 -- HorseLink°¡ ÀÖ´Â °æ¿ì
		if (biped.getNode m_workingBipRoot #lleg link:4) == undefined do (
			footIndex = 3
		)
		selObj = biped.getNode m_workingBipRoot #lleg link:footIndex
		if ( selObj.isHidden == false ) or uiChkSelHiddenObj.state then (
			return #(selObj)
		)
		else (
			return #()
		)
	)
	fn GetRToe = (
		selObj = biped.getNode m_workingBipRoot #rtoes link:1
		if ( selObj.isHidden == false ) or uiChkSelHiddenObj.state then (
			return #(selObj)
		)
		else (
			return #()
		)
	)
	fn GetLToe = (
		selObj = biped.getNode m_workingBipRoot #ltoes link:1
		if ( selObj.isHidden == false ) or uiChkSelHiddenObj.state then (
			return #(selObj)
		)
		else (
			return #()
		)
	)
	fn GetRLegs = (
		tArr = #()
		for i = 1 to 4 do (
			selObj = biped.getNode m_workingBipRoot #rleg link:i
			if selObj != undefined do (		-- HorseLink °¡ ÀÖ±âµµ ÇÏ°í ¾ø±âµµ ÇÒ ¼ö ÀÖÀ½
				if ( selObj.isHidden == false ) or uiChkSelHiddenObj.state do (
					append tArr selObj
				)
			)
		)
		append tArr (biped.getNode m_workingBipRoot #rtoes link:1)
		return tArr
	)
	fn GetAllFoot = (
		tArr = #()
		selObj = GetLFoot()
		if ( selObj[1].isHidden == false ) or uiChkSelHiddenObj.state do ( append tArr selObj[1] )
		selObj = GetRFoot()
		if ( selObj[1].isHidden == false ) or uiChkSelHiddenObj.state do ( append tArr selObj[1] )
		return tArr
	)
	fn GetLLegs = (
		tArr = #()
		for i = 1 to 4 do (
			selObj = biped.getNode m_workingBipRoot #lleg link:i
			if selObj != undefined do (		-- HorseLink °¡ ÀÖ±âµµ ÇÏ°í ¾ø±âµµ ÇÒ ¼ö ÀÖÀ½
				if ( selObj.isHidden == false ) or uiChkSelHiddenObj.state do (
					append tArr selObj
				)
			)
		)
		append tArr (biped.getNode m_workingBipRoot #ltoes link:1)
		return tArr
	)
	fn GetAllBip = (
		local retBips = #()
		for o in objects do (
			if ( classof o.baseobject == Biped_object ) do
			(
				-- °°ÀºBip001ÀÇ ÀÚ½ÄÀÌ¸é
				if ( o.controller.rootNode == m_workingBipRoot AND (classof o.controller) != Footsteps) do
				(
					append retBips o
				)
			)
		)
		return retBips
	)
	
	-- Go to Mirror frame ¹öÆ°ÀÌ ÀÛµ¿ÇÏ±â À§ÇÑ Á¶°Ç °Ë»ç ÈÄ ¹öÆ° enable ¼¼ÆÃ
	-- ·çÇÎ ±¸°£ ÇÁ·¹ÀÓÀÌ Â¦¼ö¿©¾ßÇÏ°í ÀÏÁ¤ ¼ö ÀÌ»óÀÌ¿©¾ßÇÔ
	fn SetGotoMirrorEnable = (
		--uiBtnGotoMirror
		local fCount = uiSpnLoopEnd.value - uiSpnLoopStart.value
		if (fCount < 2) do (
			uiBtnGotoMirror.enabled = false
			return ()
		)

		local fCountHalf = fCount / 2.0
		-- È¦¼öÀÎÁö?
		if float (int fCountHalf) != fCountHalf do (
			uiBtnGotoMirror.enabled = false
			return ()
		)
		uiBtnGotoMirror.enabled = true
	)
    
	-- ÀÛ¾÷¿ë ¹ÙÀÌÆÐµå ·çÆ® ³ëµå¶ó´ø°¡, ¼±ÅÃ¿ë ¹è¿­ º¯¼ö µîÀ» ¹Ì¸® ¼¼ÆÃ
	function InitLocalVars = (
		
		--uiBtnLoopDupe.enabled = false -- °³¹ßÁßÀÎ ±â´É ºÀÀÎ
		AutoGetBipRoot()
        if m_workingBipRoot == undefined then (
            SetButtonState false
            return ()
        )
        else (
            SetButtonState true
		)
		uiChkBtnScanBiped.text = "Scanning..."
		
		-- ¸ðµç ºÎÀ§ º¯¼öµéÀº ¹è¿­
		m_Head = GetHead()
		m_RArms = GetRArms()
		if (m_RArms.count == 0) then (uiRArms.enabled = false; uiRArms.state = false) else (uiRArms.enabled = true; uiRArms.state = true)
		m_Necks = GetNecks()
		m_LArms = GetLArms()
		if (m_LArms.count == 0) then (uiLArms.enabled = false; uiLArms.state = false) else (uiLArms.enabled = true; uiLArms.state = true)
		m_RClavicle = GetRClavicle()
		if (m_RClavicle.count == 0) then (uiRClavicle.enabled = false; uiRClavicle.state = false) else (uiRClavicle.enabled = true; uiRClavicle.state = true)
		m_LClavicle = GetLClavicle()
		if (m_LClavicle.count == 0) then (uiLClavicle.enabled = false; uiLClavicle.state = false) else (uiLClavicle.enabled = true; uiLClavicle.state = true)
		m_RUpArm = GetRUpArm()
		if (m_RUpArm.count == 0) then (uiRUpArm.enabled = false; uiRUpArm.state = false) else (uiRUpArm.enabled = true; uiRUpArm.state = true)
		m_AllSpine = GetAllSpine()
		m_Spine2 = GetSpine 2
		if (m_Spine2.count == 0) then (uiSpine2.enabled = false; uiSpine2.state = false) else (uiSpine2.enabled = true; uiSpine2.state = true)
		m_Spine1 = GetSpine 1
		if (m_Spine1.count == 0) then (uiSpine1.enabled = false; uiSpine1.state = false) else (uiSpine1.enabled = true; uiSpine1.state = true)
		m_Spine0 = GetSpine 0
		if (m_Spine0.count == 0) then (uiSpine0.enabled = false; uiSpine0.state = false) else (uiSpine0.enabled = true; uiSpine0.state = true)
		m_LUpArm = GetLUpArm()
		if (m_LUpArm.count == 0) then (uiLUpArm.enabled = false; uiLUpArm.state = false) else (uiLUpArm.enabled = true; uiLUpArm.state = true)
		m_RForArm = GetRForArm()
		if (m_RForArm.count == 0) then (uiRForArm.enabled = false; uiRForArm.state = false) else (uiRForArm.enabled = true; uiRForArm.state = true)
		m_LForArm = GetLForArm()
		if (m_LForArm.count == 0) then (uiLForArm.enabled = false; uiLForArm.state = false) else (uiLForArm.enabled = true; uiLForArm.state = true)
		m_RHand = GetRHand()
		if (m_RHand.count == 0) then (uiRHand.enabled = false; uiRHand.state = false) else (uiRHand.enabled = true; uiRHand.state = true)
		--m_COM = GetCOM()
		m_LHand = GetLHand()
		if (m_LHand.count == 0) then (uiLHand.enabled = false; uiLHand.state = false) else (uiLHand.enabled = true; uiLHand.state = true)
		m_Pelvis = GetPelvis()
		m_RThigh = GetRThigh()
		m_LThigh = GetLThigh()
		m_RCalf = GetRCalf()
		m_LCalf = GetLCalf()
		m_RFoot = GetRFoot()
		m_LFoot = GetLFoot()
		m_RToe = GetRToe()
		m_LToe = GetLToe()
		m_RLegs = GetRLegs()
		m_AllFoot = GetAllFoot()
		m_LLegs = GetLLegs()
		m_AllBip = GetAllBip()

		uiChkBtnScanBiped.text = "É¨ÃèBiped"

		LoadRangeLoop()
		LoadRangeA()
		LoadRangeB()
		LoadGoto()
		

		uiDropPlaySpeed.selection = timeConfiguration.playbackSpeed

        SetGotoMirrorEnable ()
        
        uiPlayBlock.state = false
		clock.active = false
		m_PBKeyTimeArray = #()
		m_PBKeyMiliSecArray = #()
        SetPBPlaySpeed()
	)

	-- º¸Á¤Ä¡ È¸Àü°ªÀ» ÀÔ·Â¹Þ°í ¶È¹Ù·Î ÆìÁÖ´Â ±â´ÉÀ» ÇÑ´Ù. bips´Â ¹è¿­. º¸Á¤Ä¡ È¸Àü°ªÀº Toe µî¿¡¼­ 90µµ Ãß°¡ È¸ÀüÀÌ ÇÊ¿äÇÔ
	function Straighten bips offsetRotation = (
		for bip in bips do (
			if (bip != undefined AND (isDeleted bip) == false) do (
				biped.setTransform bip #rotation (offsetRotation * bip.parent.transform.rotation) animButtonState
			)
		)
	)

	-- Straighten ÇÔ¼ö¿Í °°Àº ±â´ÉÀÌÁö¸¸ ºÎ¸ð ´ë½Å¿¡ ´Ù¸¥ ÇÁ·Ï½Ã ¿ÀºêÁ§Æ®¸¦ ±âÁØÀ¸·Î ÇÑ´Ù.
	-- ¹ÙÀÌÆÐµåÀÇ Triangle Pelvis ¿É¼Ç¶§¹®¿¡ Çã¹÷Áö ºÎ¸ð°¡ Ã´ÃßÀÎ °æ¿ì°¡ Á¾Á¾ ÀÖ¾î¼­ °­Á¦·Î Pelvis¸¦ ÁöÁ¤
	function StraightenByProxy bips proxy offsetRotation = (
		for bip in bips do (
			if (bip != undefined AND (isDeleted bip) == false) do (
				biped.setTransform bip #rotation (offsetRotation * proxy.transform.rotation) animButtonState
			)
		)
	)
	
	
	
	

	fn fnUpdateSelSetNodeList selSetAll =
	(
		local arrSelSetNodesName = #()
		for i in selSetAll do
		(
			if selectionsets[mlbSelSet.items[i]] != undefined then join arrSelSetNodesName (for i in selectionsets[mlbSelSet.items[i]] collect i.name)
		)
		arrSelSetNodesName = makeUniqueArray arrSelSetNodesName
		qsort arrSelSetNodesName fnSortNames
		-- print arrSelSetNodesName
		mlbSelSetNode.items = arrSelSetNodesName
		mlbSelSetNode.selection = 0
		lblCount.text = "µ±Ç°¹²ÓÐ " + arrSelSetNodesName.count as string + " ¸öÎïÌå"
	)
	fn fnAddRemoveNode tarSelSet action =
	(
		local arrSelection = getcurrentselection()
		if arrSelection != undefined then 
		(
			case of
			(
				(action == "Add"):(tarSelSet = join (join #() tarSelSet) arrSelection)
				(action == "Del"):
				(
					for o in arrSelection do 
					(
						tarSelSet = for n in tarSelSet where n != o collect n
					)
				)
			)
		)
		tarSelSet
	)














	on btnSaveXml pressed do
	(
		local save_path = getSaveFileName caption:"Save XML File " filename:".xml" types:"XML(*.xml)|*.xml|"
		if save_path != undefined then
		(
			fnSaveSelSetAll save_path
		)
	)	

	on btnLoadXml pressed do
	(
		local pathLoad = getOpenFileName caption:"Load XML File" types:"XML(*.xml)|*.xml|"
		if pathLoad != undefined then
		(
			local dataLoad = fnLoadSelXml pathLoad
			
			if dataLoad != undefined then
			(
				print (dataLoad as string)
				arrSelSetNameLoadedAssist = dataLoad[1]
				arrSelSetObjLoadedAssist  = dataLoad[2]
				createdialog rolLoadSelSetAssist  width:200 height:350 
				rolLoadSelSetAssist.mlbLoadSelSet.items = dataLoad[1]
			)
		)
	)

	on btnUpdateList pressed do
	(
		fnUpdateSelSetList()

	)

	on mlbSelSet doubleClicked val do 
	(
		if (selectionsets[mlbSelSet.items[val]] != undefined) then 
		(
			select selectionsets[mlbSelSet.items[val]]
			fnUpdateSelSetNodeList mlbSelSet.selection

		)
	)	

	on mlbSelSet selectionEnd do
	(
		if (mlbSelSet.selection as array).count != 0 then
		(
			clearselection()
			for i in (mlbSelSet.selection as array) do 
			(
				if selectionsets[mlbSelSet.items[i]] !=undefined then selectmore selectionsets[mlbSelSet.items[i]]
			)
			fnUpdateSelSetNodeList mlbSelSet.selection

		)	
	)

	on btnDeleteSelSet pressed do with undo "DeleteSelSet" on
	(
		if (mlbSelSet.selection as array).count != 0 then
		(
			for i in (mlbSelSet.selection as array) do 
			(
				deleteItem selectionSets mlbSelSet.items[i]
			)
			fnUpdateSelSetList()

		)
	)

	on btnAddToSelSet pressed do
	(
		if (mlbSelSet.selection as array).count != 0 then
		(
			for i in (mlbSelSet.selection as array) do 
			(
				selectionsets[mlbSelSet.items[i]] = fnAddRemoveNode selectionsets[mlbSelSet.items[i]] "Add"
			)
			fnUpdateSelSetNodeList (mlbSelSet.selection as array)

		)
	)

	on btnRemoveFromSelSet pressed do undo "RemoveSelSet" on
	(
		if (mlbSelSet.selection as array).count != 0 then
		(
			for i in (mlbSelSet.selection as array) do 
			(
				selectionsets[mlbSelSet.items[i]] = fnAddRemoveNode selectionsets[mlbSelSet.items[i]] "Del"
			)
			fnUpdateSelSetNodeList (mlbSelSet.selection as array)

		)
	)

	on btnHighlightSelObj pressed do 
	(
		local arrCurSelection = getCurrentSelection()
		local arrCurSelSet = #()
		local arrSelIndex = #()
		for i in (mlbSelSet.selection as array) do 
		(
			join arrCurSelSet selectionsets[mlbSelSet.items[i]]
		)
		makeUniqueArray arrCurSelSet
		for i in arrCurSelection do 
		(
			local indexTemp = findItem mlbSelSetNode.items i.name
			if indexTemp != 0 then append arrSelIndex indexTemp
		)
		mlbSelSetNode.selection = arrSelIndex
		lblCount.text = "Ñ¡ÖÐ¸ßÁÁ " + arrSelIndex.count as string + " ¸öÎïÌå"
	)

	on btnCreateSelSet pressed do 
	(
		local arrSelection = getCurrentselection()
		if arrSelection != undefined then 
		(
			createdialog rolCreateSelSet width:200 height:55 
		)
	)

	on mlbSelSetNode doubleClicked val do 
	(
		if (getNodeByName mlbSelSetNode.items[val] != undefined) then (select (getNodeByName mlbSelSetNode.items[val]))
	)	

	on mlbSelSetNode selectionEnd do 
	(
		if mlbSelSetNode.selection != 0 then
		(
			local strSelSetNode = for i in mlbSelSetNode.selection collect mlbSelSetNode.items[i]
			clearselection()
			for o in strSelSetNode where (getNodeByName o != undefined) do selectmore (getNodeByName o)
		)
	)


	on uiChkBtnScanBiped changed state do (
		uiChkBtnScanBiped.state = true
		InitLocalVars() -- ÀÛ¾÷¿ë ¹ÙÀÌÆÐµå ·çÆ® ³ëµå¶ó´ø°¡, ¼±ÅÃ¿ë ¹è¿­ º¯¼ö µîÀ» ¹Ì¸® ¼¼ÆÃ
		if (m_workingBipRoot != undefined) do (select m_AllBip)
	)
	
	on uiBtnSetAllKey changed state do (
		uiBtnSetAllKey.state = true
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		if (m_workingBipRoot.transform.controller.figureMode) do (
			messageBox "You cannot add keyframes in Figure mode." title:"Sox Biped Assist Message"
			return ()
		)

		selBackup = selection as array

		-- ¹Ì¸® ÀúÀåÇÑ ¹è¿­¿¡ ¹®Á¦°¡ ÀÖÀ¸¸é ´Ù½Ã ¹è¿­À» ÃÊ±âÈ­
		if (IfExistBips m_AllBip) == false do (
			m_AllBip = GetAllBip()
		)
		if (IfExistBips m_AllBip) == false do return () -- ±×·¡µµ ¹®Á¦°¡ ÀÖÀ¸¸é ±×³É ¸®ÅÏ
		
		undo on
		(
			for o in m_AllBip do
			(
				if ( o == m_workingBipRoot ) then
				(
					biped.addNewKey o.controller.vertical.controller slidertime
					biped.addNewKey o.controller.horizontal.controller slidertime
					biped.addNewKey o.controller.turning.controller slidertime
				)
				else
				(
					try ( biped.addNewKey o.controller slidertime ) catch ()		-- Footstep ¿ÀºêÁ§Æ®¶§¹®¿¡ try Ã³¸®
				)
			) -- for end
		) -- undo end	
		clearSelection()
		select selBackup
	)

	on uiBtnLimbIK changed state do (
		uiBtnLimbIK.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		setCommandPanelTaskMode mode:#motion -- biped.setSlidingKey µîÀÇ ±â´ÉÀº MotionÆÇ³Ú¿¡¼­¸¸ Á¤»ó ÀÛµ¿ÇÑ´Ù. ´Ù¸¥ °÷¿¡¼­ ÇÏ¸é ¾û¶×ÇÑ ÀÚ¼¼°¡ µ¤¾î½áÁü
		local timeBefore = sliderTime
		disableSceneRedraw()
		undo on (
			for obj in selection do (
				if (IfLimb obj) do (
					if (keyboard.shiftPressed OR keyboard.controlPressed) then (
						local keys = obj.controller.keys
						local animRangeBackup = animationRange -- Àá½Ã ¹Ù±ù¿¡ ÀÖ´Â Å°µéµµ ¼öÁ¤ÇÒ ¼ö ÀÖµµ·Ï ÇöÀçÀÇ ¾Ö´Ï¸ÞÀÌ¼Ç ±¸°£À» ±â¾ïÇÑ´Ù.
						animationRange = Interval keys[1].time keys[keys.count].time
						for i = 1 to keys.count do (
							if keyboard.shiftPressed do (
								-- Shift°¡ ´­·ÁÀÖÀ¸¸é Å° ¼±ÅÃ°ú »ó°ü ¾øÀÌ ¸ðµÎ º¯°æ
								sliderTime = keys[i].time -- at time ¹æ½ÄÀ¸·Î ÇÏ¸é sliderTimeÀÇ ÀÚ¼¼·Î Å°°¡ »ý¼ºµÇ´Â ¹®Á¦°¡ ÀÖ¾î¼­ ½ÇÁ¦ sliderTimeÀ» º¯°æ½ÃÄÑ¼­ ÁøÇà
								biped.setSlidingKey obj
							)
							if keyboard.controlPressed do (
								-- CtrlÀÌ ´­·ÁÀÖÀ¸¸é ¼±ÅÃµÈ Å°µê¸¸ º¯°æ
								if keys[i].selected == true do (
									sliderTime = keys[i].time -- at time ¹æ½ÄÀ¸·Î ÇÏ¸é sliderTimeÀÇ ÀÚ¼¼·Î Å°°¡ »ý¼ºµÇ´Â ¹®Á¦°¡ ÀÖ¾î¼­ ½ÇÁ¦ sliderTimeÀ» º¯°æ½ÃÄÑ¼­ ÁøÇà
									biped.setSlidingKey obj
								)
							)
						)
						animationRange = animRangeBackup -- ´Ù½Ã ¿ø·¡´ë·ÎÀÇ ¾Ö´Ï¸ÞÀÌ¼Ç ±¸°£À¸·Î º¹±¸
					)
					else (
						biped.setSlidingKey obj
					)
				)
			) -- for
		) -- Undo
		enableSceneRedraw()
		sliderTime = timeBefore
	)

	on uiBtnLimbFK changed state do (
		uiBtnLimbFK.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		setCommandPanelTaskMode mode:#motion -- biped.setSlidingKey µîÀÇ ±â´ÉÀº MotionÆÇ³Ú¿¡¼­¸¸ Á¤»ó ÀÛµ¿ÇÑ´Ù. ´Ù¸¥ °÷¿¡¼­ ÇÏ¸é ¾û¶×ÇÑ ÀÚ¼¼°¡ µ¤¾î½áÁü
		local timeBefore = sliderTime
		disableSceneRedraw()
		undo on (
			for obj in selection do (
				if (IfLimb obj) do (
					if (keyboard.shiftPressed OR keyboard.controlPressed) then (
						local keys = obj.controller.keys
						local animRangeBackup = animationRange -- Àá½Ã ¹Ù±ù¿¡ ÀÖ´Â Å°µéµµ ¼öÁ¤ÇÒ ¼ö ÀÖµµ·Ï ÇöÀçÀÇ ¾Ö´Ï¸ÞÀÌ¼Ç ±¸°£À» ±â¾ïÇÑ´Ù.
						animationRange = Interval keys[1].time keys[keys.count].time
						for i = 1 to keys.count do (
							if keyboard.shiftPressed do (
								-- Shift°¡ ´­·ÁÀÖÀ¸¸é Å° ¼±ÅÃ°ú »ó°ü ¾øÀÌ ¸ðµÎ º¯°æ
								sliderTime = keys[i].time -- at time ¹æ½ÄÀ¸·Î ÇÏ¸é sliderTimeÀÇ ÀÚ¼¼·Î Å°°¡ »ý¼ºµÇ´Â ¹®Á¦°¡ ÀÖ¾î¼­ ½ÇÁ¦ sliderTimeÀ» º¯°æ½ÃÄÑ¼­ ÁøÇà
								biped.setFreeKey obj
							)
							if keyboard.controlPressed do (
								-- CtrlÀÌ ´­·ÁÀÖÀ¸¸é ¼±ÅÃµÈ Å°µê¸¸ º¯°æ
								if keys[i].selected == true do (
									sliderTime = keys[i].time -- at time ¹æ½ÄÀ¸·Î ÇÏ¸é sliderTimeÀÇ ÀÚ¼¼·Î Å°°¡ »ý¼ºµÇ´Â ¹®Á¦°¡ ÀÖ¾î¼­ ½ÇÁ¦ sliderTimeÀ» º¯°æ½ÃÄÑ¼­ ÁøÇà
									biped.setFreeKey obj
								)
							)
						)
						animationRange = animRangeBackup -- ´Ù½Ã ¿ø·¡´ë·ÎÀÇ ¾Ö´Ï¸ÞÀÌ¼Ç ±¸°£À¸·Î º¹±¸
					)
					else (
						biped.setFreeKey obj
					)
				)
			) -- for
		) -- Undo
		enableSceneRedraw()
		sliderTime = timeBefore
	)
	
	on uiHead changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiHead.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		
		if keyboard.shiftPressed do (
			-- Shift ¸¦ ´©¸£¸é ¶È¹Ù·Î Æì´Â ±â´É
			Straighten m_Head ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array
		
		try(CompSelect selBackup m_Head) catch (
			m_Head = GetHead()
			select m_Head
		)
	)

	on uiNecks changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiNecks.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		
		if keyboard.shiftPressed do (
			-- Shift ¸¦ ´©¸£¸é ¶È¹Ù·Î Æì´Â ±â´É
			Straighten m_Necks ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		try(CompSelect selBackup m_Necks) catch (
			m_Necks = GetNecks()
			select m_Necks
		)
	)
	
	on uiRArms changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiRArms.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		selBackup = selection as array

		try(CompSelect selBackup m_RArms) catch (
			m_RArms = GetRArms()
			select m_RArms
		)
	)
	
	on uiLArms changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiLArms.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		selBackup = selection as array

		try(CompSelect selBackup m_LArms) catch (
			m_LArms = GetLArms()
			select m_LArms
		)
	)
	
	on uiRClavicle changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiRClavicle.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		
		if keyboard.shiftPressed do (
			-- Shift ¸¦ ´©¸£¸é ¶È¹Ù·Î Æì´Â ±â´É
			StraightenByProxy m_RClavicle m_AllSpine[m_AllSpine.count] ((eulerangles 0 90 -180) as quat)
			return ()
		)

		selBackup = selection as array

		try(CompSelect selBackup m_RClavicle) catch (
			m_RClavicle = GetRClavicle()
			select m_RClavicle
		)
	)

	on uiLClavicle changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiLClavicle.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		
		if keyboard.shiftPressed do (
			-- Shift ¸¦ ´©¸£¸é ¶È¹Ù·Î Æì´Â ±â´É
			StraightenByProxy m_LClavicle m_AllSpine[m_AllSpine.count] ((eulerangles 0 -90 -180) as quat)
			return ()
		)
		
		selBackup = selection as array

		try(CompSelect selBackup m_LClavicle) catch (
			m_LClavicle = GetLClavicle()
			select m_LClavicle
		)
	)
	
	on uiRUpArm changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiRUpArm.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		
		if keyboard.shiftPressed do (
			-- Shift ¸¦ ´©¸£¸é ¶È¹Ù·Î Æì´Â ±â´É
			Straighten m_RUpArm ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		try(CompSelect selBackup m_RUpArm) catch (
			m_RUpArm = GetRUpArm()
			select m_RUpArm
		)
	)

	on uiAllSpine changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiAllSpine.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		
		if keyboard.shiftPressed do (
			-- Shift ¸¦ ´©¸£¸é ¶È¹Ù·Î Æì´Â ±â´É
			Straighten m_AllSpine ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		try(CompSelect selBackup m_AllSpine) catch (
			m_AllSpine = GetAllSpine()
			select m_AllSpine
		)
	)

	on uiSpine2 changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiSpine2.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		
		if keyboard.shiftPressed do (
			-- Shift ¸¦ ´©¸£¸é ¶È¹Ù·Î Æì´Â ±â´É
			Straighten m_Spine2 ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		try(CompSelect selBackup m_Spine2) catch (
			m_Spine2 = GetSpine 2
			select m_Spine2
		)
	)

	on uiSpine1 changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiSpine1.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		
		if keyboard.shiftPressed do (
			-- Shift ¸¦ ´©¸£¸é ¶È¹Ù·Î Æì´Â ±â´É
			Straighten m_Spine1 ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		try(CompSelect selBackup m_Spine1) catch (
			m_Spine1 = GetSpine 1
			select m_Spine1
		)
	)

	on uiSpine0 changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiSpine0.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		
		if keyboard.shiftPressed do (
			-- Shift ¸¦ ´©¸£¸é ¶È¹Ù·Î Æì´Â ±â´É
			Straighten m_Spine0 ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		try(CompSelect selBackup m_Spine0) catch (
			m_Spine0 = GetSpine 0
			select m_Spine0
		)
	)

	on uiLUpArm changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiLUpArm.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		
		if keyboard.shiftPressed do (
			-- Shift ¸¦ ´©¸£¸é ¶È¹Ù·Î Æì´Â ±â´É
			Straighten m_LUpArm ((eulerangles 0 0 0) as quat)
			return ()
		)

		selBackup = selection as array

		try(CompSelect selBackup m_LUpArm) catch (
			m_LUpArm = GetLUpArm()
			select m_LUpArm
		)
	)
	
	on uiRForArm changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiRForArm.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		
		if keyboard.shiftPressed do (
			-- Shift ¸¦ ´©¸£¸é ¶È¹Ù·Î Æì´Â ±â´É
			Straighten m_RForArm ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		try(CompSelect selBackup m_RForArm) catch (
			m_RForArm = GetRForArm()
			select m_RForArm
		)
	)

	on uiLForArm changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiLForArm.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		
		if keyboard.shiftPressed do (
			-- Shift ¸¦ ´©¸£¸é ¶È¹Ù·Î Æì´Â ±â´É
			Straighten m_LForArm ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		try(CompSelect selBackup m_LForArm) catch (
			m_LForArm = GetLForArm()
			select m_LForArm
		)
	)
	
	on uiRHand changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiRHand.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		
		if keyboard.shiftPressed do (
			-- Shift ¸¦ ´©¸£¸é ¶È¹Ù·Î Æì´Â ±â´É
			Straighten m_RHand ((eulerangles 90 0 0) as quat)
			return ()
		)

		selBackup = selection as array

		try(CompSelect selBackup m_RHand) catch (
			m_RHand = GetRHand()
			select m_RHand
		)
	)

	on uiCOM changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiCOM.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		selBackup = selection as array
        
        -- »õ·Î¿î ¾ÀÀ» ¿­¸é m_workingBipRootÀÌ undefined´Â ¾Æ´ÏÁö¸¸ ¿¡·¯ ¹ß»ýÇÔ
        try (
            if ( m_workingBipRoot.isHidden == false ) or uiChkSelHiddenObj.state then (
                CompSelect selBackup #(m_workingBipRoot)
            )
            else (
                clearselection()
            )
        )
        catch (
            if (AutoGetBipRoot() == false) do ( SetButtonState false; return ())
            if ( m_workingBipRoot.isHidden == false ) or uiChkSelHiddenObj.state then (
                CompSelect selBackup #(m_workingBipRoot)
            )
            else (
                clearselection()
            )
        )
	)
	
	on uiLHand changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiLHand.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		
		if keyboard.shiftPressed do (
			-- Shift ¸¦ ´©¸£¸é ¶È¹Ù·Î Æì´Â ±â´É
			Straighten m_LHand ((eulerangles -90 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		try(CompSelect selBackup m_LHand) catch (
			m_LHand = GetLHand()
			select m_LHand
		)
	)
	
	on uiPelvis changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiPelvis.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		
		if keyboard.shiftPressed do (
			-- Shift ¸¦ ´©¸£¸é ¶È¹Ù·Î Æì´Â ±â´É
			Straighten m_Pelvis ((eulerangles -90 -90 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		try(CompSelect selBackup m_Pelvis) catch (
			m_Pelvis = GetPelvis()
			select m_Pelvis
		)
	)
	
	on uiRThigh changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiRThigh.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		
		if keyboard.shiftPressed do (
			-- Shift ¸¦ ´©¸£¸é ¶È¹Ù·Î Æì´Â ±â´É
			StraightenByProxy m_RThigh m_Pelvis[1] ((eulerangles 0 180 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		try(CompSelect selBackup m_RThigh) catch (
			m_RThigh = GetRThigh()
			select m_RThigh
		)
	)

	on uiLThigh changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiLThigh.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		
		if keyboard.shiftPressed do (
			-- Shift ¸¦ ´©¸£¸é ¶È¹Ù·Î Æì´Â ±â´É
			StraightenByProxy m_LThigh m_Pelvis[1] ((eulerangles 0 -180 0) as quat)
			return ()
		)
		
		selBackup = selection as array
		
		try(CompSelect selBackup m_LThigh) catch (
			m_LThigh = GetLThigh()
			select m_LThigh
		)
	)
	
	on uiRCalf changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiRCalf.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		
		if keyboard.shiftPressed do (
			-- Shift ¸¦ ´©¸£¸é ¶È¹Ù·Î Æì´Â ±â´É
			Straighten m_RCalf ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		try(CompSelect selBackup m_RCalf) catch (
			m_RCalf = GetRCalf()
			select m_RCalf
		)
	)

	on uiLCalf changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiLCalf.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		
		if keyboard.shiftPressed do (
			-- Shift ¸¦ ´©¸£¸é ¶È¹Ù·Î Æì´Â ±â´É
			Straighten m_LCalf ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		try(CompSelect selBackup m_LCalf) catch (
			m_LCalf = GetLCalf()
			select m_LCalf
		)
	)
	
	on uiRFoot changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiRFoot.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		
		if keyboard.shiftPressed do (
			-- Shift ¸¦ ´©¸£¸é ¶È¹Ù·Î Æì´Â ±â´É
			Straighten m_RFoot ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		try(CompSelect selBackup m_RFoot) catch (
			m_RFoot = GetRFoot()
			select m_RFoot
		)
	)
	
	on uiLFoot changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiLFoot.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		
		if keyboard.shiftPressed do (
			-- Shift ¸¦ ´©¸£¸é ¶È¹Ù·Î Æì´Â ±â´É
			Straighten m_LFoot ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		try(CompSelect selBackup m_LFoot) catch (
			m_LFoot = GetLFoot()
			select m_LFoot
		)
	)

	on uiRToe changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiRToe.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï

		if keyboard.shiftPressed do (
			-- Shift ¸¦ ´©¸£¸é ¶È¹Ù·Î Æì´Â ±â´É
			Straighten m_RToe ((eulerangles 0 0 90) as quat)
			return ()
		)

		selBackup = selection as array
		
		try(CompSelect selBackup m_RToe) catch (
			m_RToe = GetRToe()
			select m_RToe
		)
	)

	on uiLToe changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiLToe.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï

		if keyboard.shiftPressed do (
			-- Shift ¸¦ ´©¸£¸é ¶È¹Ù·Î Æì´Â ±â´É
			Straighten m_LToe ((eulerangles 0 0 90) as quat)
			return ()
		)

		selBackup = selection as array

		try(CompSelect selBackup m_LToe) catch (
			m_LToe = GetLToe()
			select m_LToe
		)
	)
	
	on uiRLegs changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiRLegs.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		selBackup = selection as array

		try(CompSelect selBackup m_RLegs) catch (
			m_RLegs = GetRLegs()
			select m_RLegs
		)
	)
	
	on uiAllFoot changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiAllFoot.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		selBackup = selection as array

		try(CompSelect selBackup m_AllFoot) catch (
			m_AllFoot = GetAllFoot()
			select m_AllFoot
		)
	)
	
	on uiLLegs changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiLLegs.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		selBackup = selection as array

		try(CompSelect selBackup m_LLegs) catch (
			m_LLegs = GetLLegs()
			select m_LLegs
		)
	)
	
	on uiAllBip changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonState false; return ())
		uiAllBip.state = on -- ¾î¶² »óÅÂ¿¡¼­µµ ¹öÆ° ½ºÅ×ÀÌÆ®´Â ´­·ÁÀÖµµ·Ï
		selBackup = selection as array

		try(CompSelect selBackup m_AllBip) catch (
			m_AllBip = GetAllBip()
			select m_AllBip
		)
	)
	
	on uiSpnLoopStart changed var do (
		SaveRangeLoop()
		SetGotoMirrorEnable() -- Go to Mirror frame ¹öÆ° È°¼º/ºñÈ°¼º ¼³Á¤
	)
	on uiSpnLoopEnd changed var do (
		SaveRangeLoop()
		SetGotoMirrorEnable() -- Go to Mirror frame ¹öÆ° È°¼º/ºñÈ°¼º ¼³Á¤
	)




	on uiBtnGotoMirror pressed do (
		local now = int sliderTime
		if (now < uiSpnLoopStart.value) OR (now > uiSpnLoopEnd.value) do return ()

		if now == uiSpnLoopEnd.value do (now = uiSpnLoopStart.value) -- ·çÇÁ ³¡ ÇÁ·¹ÀÓ¿¡¼­ ¹öÆ°ÀÌ ´­·¯Á³À¸¸é Ã¹ ÇÁ·¹ÀÓÀ¸·Î °£ÁÖÇÔ
		local fCount = uiSpnLoopEnd.value - uiSpnLoopStart.value
		fCount *= 0.5
		local targetFrame = (int sliderTime) + fCount
		if targetFrame == uiSpnLoopEnd.value do (
			sliderTime = uiSpnLoopStart.value
			return ()
		)
		if targetFrame > uiSpnLoopEnd.value then (
			sliderTime = uiSpnLoopStart.value + (targetFrame - uiSpnLoopEnd.value)
			return ()
		)
		else (
			sliderTime = targetFrame
			return ()
		)
	)
    
    fn LoopTrim = (
		undo on (
			for obj in selection do (
				DeselectAllKeys obj
				if (IfBipRoot obj) == false then (
					-- COMÀÌ ¾Æ´Ï°Å³ª ÀÏ¹Ý ¿ÀºêÁ§Æ®ÀÎ °æ¿ì
					if (classof obj.baseobject == Biped_Object) then (
						TrimKeys obj.controller uiSpnLoopStart.value uiSpnLoopEnd.value true
					)
					else (
						TrimKeys obj.controller uiSpnLoopStart.value uiSpnLoopEnd.value false
					)
				)
				else (
					-- COMÀÎ °æ¿ì
					TrimKeys obj.controller.Vertical.controller uiSpnLoopStart.value uiSpnLoopEnd.value true
					TrimKeys obj.controller.Horizontal.controller uiSpnLoopStart.value uiSpnLoopEnd.value true
					TrimKeys obj.controller.Turning.controller uiSpnLoopStart.value uiSpnLoopEnd.value true
				)
			)
		)
	)
	on uiBtnLoopTrim changed state do (
		uiBtnLoopTrim.state = true
		LoopTrim()
	)

	fn LoopDupeCOM bip = (
		disableSceneRedraw()
		-- Turning
		local loopLength = uiSpnLoopEnd.value - uiSpnLoopStart.value
		local keyCount = numKeys bip.controller.Turning.controller
		-- Áß¿ä. Å° ÀÚÃ¼¸¦ ¹è¿­·Î ¾ò¾î¿À¸é Å°¸¦ Ãß°¡ÇÏ´Â °úÁ¤¿¡¼­ ÀÎµ¦½º°¡ ´Ù ²¿ÀÎ´Ù. ¹è¿­À» deepCopy·Î º¹»çÇÏµç ¹» ÇÏµç ¹æ¹ýÀÌ ¾øÀ½
		-- ±×·¡¼­ º¹»çÇÒ Å°ÀÇ ½Ã°£À» ¹è¿­·Î ÁØºñÇØµÎ´Â ¹æ¹ýÀ» »ç¿ëÇÔ
		local refKeyTimes = #() -- ·çÇÁ Å°¸¦ Ãß°¡ÇÏ±â Àü¿¡ ¹Ì¸® ´Ù ¾ò¾îµÎ¾î¾ßÇÔ.
		for i = 1 to keyCount do (
			append refKeyTimes (getKey bip.controller.Turning.controller i).time
		)

		for i = 1 to keyCount do (
			local newTimeBefore = refKeyTimes[i] - loopLength
			local newTimeAfter = refKeyTimes[i] + loopLength
			sliderTime = refKeyTimes[i] -- ¿øº» È¸Àü°ªÀ» ¾ò¾î¿Ã ½Ã°£À¸·Î Á¡ÇÁ
			local refRot = biped.getTransform bip #rotation 
			--Before
			if (newTimeBefore != refKeyTimes[1]) do (
				-- BeforeÀÇ º¹»çÇÏ´Â ¸¶Áö¸· Å°°¡ ¿øº» Å°ÀÇ Ã¹ Å°¿Í °°Àº À§Ä¡¸é º¹»ç ¾ÈÇÔ
				sliderTime = newTimeBefore
				biped.setTransform bip #rotation refRot true
			)
			--After
			if (newTimeAfter != refKeyTimes[refKeyTimes.count]) do (
				-- AfterÀÇ º¹»çÇÏ´Â Ã¹ Å°°¡ ¿øº» Å°ÀÇ ¸¶Áö¸· Å°¿Í °°Àº À§Ä¡¸é º¹»ç ¾ÈÇÔ
				sliderTime = newTimeAfter
				biped.setTransform bip #rotation refRot true
			)

			-- ¾Õ µÚ Å°¸¦ »ý¼ºÇÑ ÈÄ ¼¼ºÎ °ªµé º¹Á¦
			local refKeyIndex = getkeyindex bip.controller.Turning.controller refKeyTimes[i]
			local refKey = biped.getKey bip.controller.Turning.controller refKeyIndex
			local newKeyIndexBefore = getkeyindex bip.controller.Turning.controller newTimeBefore
			local newKeyBefore = biped.getKey bip.controller.Turning.controller newKeyIndexBefore
			local newKeyIndexAfter = getkeyindex bip.controller.Turning.controller newTimeAfter
			local newKeyAfter = biped.getKey bip.controller.Turning.controller newKeyIndexAfter
			newKeyBefore.tension = refKey.tension;newKeyAfter.tension = refKey.tension;
			newKeyBefore.continuity = refKey.continuity;newKeyAfter.continuity = refKey.continuity;
			newKeyBefore.bias = refKey.bias;newKeyAfter.bias = refKey.bias;
			newKeyBefore.easeTo = refKey.easeTo;newKeyAfter.easeTo = refKey.easeTo;
			newKeyBefore.easeFrom = refKey.easeFrom;newKeyAfter.easeFrom = refKey.easeFrom;
		)

		-- Horizontal, Vertical À» Å° Âï±â Àü¿¡ ¹Ì¸® ÁØºñÇÏ´Â ÀÌÀ¯ : biped.setTransform bip #pos ´Â °¡·Î ¼¼·Î µûÁöÁö ¾Ê°í Å°¸¦ »ý¼ºÇÏ¹Ç·Î
		-- Horizontal ÁØºñ
		keyCount = numKeys bip.controller.Horizontal.controller
		local refKeyTimesHor = #() -- ·çÇÁ Å°¸¦ Ãß°¡ÇÏ±â Àü¿¡ ¹Ì¸® ´Ù ¾ò¾îµÎ¾î¾ßÇÔ.
		for i = 1 to keyCount do (
			append refKeyTimesHor (getKey bip.controller.Horizontal.controller i).time
		)
		-- Vertical ÁØºñ
		keyCount = numKeys bip.controller.Vertical.controller
		local refKeyTimesVer = #() -- ·çÇÁ Å°¸¦ Ãß°¡ÇÏ±â Àü¿¡ ¹Ì¸® ´Ù ¾ò¾îµÎ¾î¾ßÇÔ.
		for i = 1 to keyCount do (
			append refKeyTimesVer (getKey bip.controller.Vertical.controller i).time
		)

		-- Horizontal
		for i = 1 to refKeyTimesHor.count do (
			local newTimeBefore = refKeyTimesHor[i] - loopLength
			local newTimeAfter = refKeyTimesHor[i] + loopLength
			sliderTime = refKeyTimesHor[i] -- ¿øº» À§Ä¡°ªÀ» ¾ò¾î¿Ã ½Ã°£À¸·Î Á¡ÇÁ
			local refPos = biped.getTransform bip #pos
			--Before
			if (newTimeBefore != refKeyTimesHor[1]) do (
				-- BeforeÀÇ º¹»çÇÏ´Â ¸¶Áö¸· Å°°¡ ¿øº» Å°ÀÇ Ã¹ Å°¿Í °°Àº À§Ä¡¸é º¹»ç ¾ÈÇÔ
				sliderTime = newTimeBefore
				biped.setTransform bip #pos refPos true
			)
			--After
			if (newTimeAfter != refKeyTimesHor[refKeyTimesHor.count]) do (
				-- AfterÀÇ º¹»çÇÏ´Â Ã¹ Å°°¡ ¿øº» Å°ÀÇ ¸¶Áö¸· Å°¿Í °°Àº À§Ä¡¸é º¹»ç ¾ÈÇÔ
				sliderTime = newTimeAfter
				biped.setTransform bip #pos refPos true
			)
			-- Vertical ½Ã°£µéÀ» ±â·ÏÇÑ ¹è¿­¿¡¼­ Hor ½Ã°£À» Ã£À» ¼ö ¾øÀ¸¸é Vertical Å° »èÁ¦
			if (findItem refKeyTimesVer refKeyTimesHor[i]) == 0 do (
				selectKeys bip.controller.Vertical.controller newTimeBefore
				selectKeys bip.controller.Vertical.controller newTimeAfter
				biped.deleteKeys bip.controller.Vertical.controller #selection
			)

			-- ¾Õ µÚ Å°¸¦ »ý¼ºÇÑ ÈÄ ¼¼ºÎ °ªµé º¹Á¦
			local refKeyIndex = getkeyindex bip.controller.Horizontal.controller refKeyTimesHor[i]
			local refKey = biped.getKey bip.controller.Horizontal.controller refKeyIndex
			local newKeyIndexBefore = getkeyindex bip.controller.Horizontal.controller newTimeBefore
			local newKeyBefore = biped.getKey bip.controller.Horizontal.controller newKeyIndexBefore
			local newKeyIndexAfter = getkeyindex bip.controller.Horizontal.controller newTimeAfter
			local newKeyAfter = biped.getKey bip.controller.Horizontal.controller newKeyIndexAfter
			newKeyBefore.tension = refKey.tension;newKeyAfter.tension = refKey.tension;
			newKeyBefore.continuity = refKey.continuity;newKeyAfter.continuity = refKey.continuity;
			newKeyBefore.bias = refKey.bias;newKeyAfter.bias = refKey.bias;
			newKeyBefore.easeTo = refKey.easeTo;newKeyAfter.easeTo = refKey.easeTo;
			newKeyBefore.easeFrom = refKey.easeFrom;newKeyAfter.easeFrom = refKey.easeFrom;
			newKeyBefore.balanceFactor = refKey.balanceFactor;newKeyAfter.balanceFactor = refKey.balanceFactor;
		)

		-- Vertical
		for i = 1 to refKeyTimesVer.count do (
			local newTimeBefore = refKeyTimesVer[i] - loopLength
			local newTimeAfter = refKeyTimesVer[i] + loopLength
			sliderTime = refKeyTimesVer[i] -- ¿øº» À§Ä¡°ªÀ» ¾ò¾î¿Ã ½Ã°£À¸·Î Á¡ÇÁ
			local refPos = biped.getTransform bip #pos
			--Before
			if (newTimeBefore != refKeyTimesVer[1]) do (
				-- BeforeÀÇ º¹»çÇÏ´Â ¸¶Áö¸· Å°°¡ ¿øº» Å°ÀÇ Ã¹ Å°¿Í °°Àº À§Ä¡¸é º¹»ç ¾ÈÇÔ
				sliderTime = newTimeBefore
				biped.setTransform bip #pos refPos true
			)
			--After
			if (newTimeAfter != refKeyTimesVer[refKeyTimesVer.count]) do (
				-- AfterÀÇ º¹»çÇÏ´Â Ã¹ Å°°¡ ¿øº» Å°ÀÇ ¸¶Áö¸· Å°¿Í °°Àº À§Ä¡¸é º¹»ç ¾ÈÇÔ
				sliderTime = newTimeAfter
				biped.setTransform bip #pos refPos true
			)
			-- Horizontal ½Ã°£µéÀ» ±â·ÏÇÑ ¹è¿­¿¡¼­ Vertical ½Ã°£À» Ã£À» ¼ö ¾øÀ¸¸é Horizontal Å° »èÁ¦
			if (findItem refKeyTimesHor refKeyTimesVer[i]) == 0 do (
				selectKeys bip.controller.Horizontal.controller newTimeBefore
				selectKeys bip.controller.Horizontal.controller newTimeAfter
				biped.deleteKeys bip.controller.Horizontal.controller #selection
			)

			-- ¾Õ µÚ Å°¸¦ »ý¼ºÇÑ ÈÄ ¼¼ºÎ °ªµé º¹Á¦
			local refKeyIndex = getkeyindex bip.controller.Vertical.controller refKeyTimesVer[i]
			local refKey = biped.getKey bip.controller.Vertical.controller refKeyIndex
			local newKeyIndexBefore = getkeyindex bip.controller.Vertical.controller newTimeBefore
			local newKeyBefore = biped.getKey bip.controller.Vertical.controller newKeyIndexBefore
			local newKeyIndexAfter = getkeyindex bip.controller.Vertical.controller newTimeAfter
			local newKeyAfter = biped.getKey bip.controller.Vertical.controller newKeyIndexAfter
			newKeyBefore.tension = refKey.tension;newKeyAfter.tension = refKey.tension;
			newKeyBefore.continuity = refKey.continuity;newKeyAfter.continuity = refKey.continuity;
			newKeyBefore.bias = refKey.bias;newKeyAfter.bias = refKey.bias;
			newKeyBefore.easeTo = refKey.easeTo;newKeyAfter.easeTo = refKey.easeTo;
			newKeyBefore.easeFrom = refKey.easeFrom;newKeyAfter.easeFrom = refKey.easeFrom;
			newKeyBefore.dynamicsBlend = refKey.dynamicsBlend;newKeyAfter.dynamicsBlend = refKey.dynamicsBlend;
			newKeyBefore.ballisticTension = refKey.ballisticTension;newKeyAfter.ballisticTension = refKey.ballisticTension;
		)

		enableSceneRedraw()
	)

	-- IK Blend, Body/Object µîÀÇ Å°°ªÀ» Á¶»çÇØ¼­ Planted, Sliding, Free ¼Â Áß ÇÏ³ªÀÇ Å¸ÀÔÀ» ¸®ÅÏÇÑ´Ù.
	fn GetLimbKeyType key = (
		-- ikSpace 0 = Body, 1 = Object
		if key.ikBlend == 1 AND key.ikSpace == 1 AND key.ikJoinedPivot == true do return "Planted"
		if key.ikBlend == 1 AND key.ikSpace == 1 AND key.ikJoinedPivot == false  do return "Sliding"
		return "Free"
	)

	fn LoopDupeLimb bip = (
		disableSceneRedraw()

		local loopLength = uiSpnLoopEnd.value - uiSpnLoopStart.value
		local bipKeys = bip.controller.keys


		enableSceneRedraw()
	)

	on uiBtnLoopDupe changed state do (
		uiBtnLoopDupe.state = true
		LoopTrim() -- º¹Á¦ Àü¿¡ ¹üÀ§ ¹ÛÀÇ Å°µéÀ» ¸ðµÎ ³¯¸°´Ù.
		if (IfExistBips m_AllBip) == false do return ()
		for bip in m_AllBip do (
			local keyTypeStr = GetBipKeyType bip
			case keyTypeStr of (
				"COM": (LoopDupeCOM bip)
				"Limb": (LoopDupeLimb bip)
				"Etc": ()
				"NoKey": ()
			)
		)
	)

	on uiBtnLoopSel changed state do (
		uiBtnLoopSel.state = true

		for obj in selection do (
			DeselectAllKeys obj
			-- ¼±ÅÃ½Ã ÄÁÆ®·Ñ·¯´Â ¼¼ºÎ ÄÁÆ®·Ñ·¯ ¸í½Ã ¾ø¾îµµ ´ëÃæ Àß ¼±ÅÃÇØÁÜ
			selectKeys obj.controller (interval uiSpnLoopStart.value uiSpnLoopEnd.value)
		)
	)
	
	on uiBtnLoopGet pressed do (
		undo on (
			uiSpnLoopStart.value = animationRange.start as integer / TicksPerFrame
			uiSpnLoopEnd.value = animationRange.end as integer / TicksPerFrame
			SaveRangeLoop()
		)
	)

	on uiBtnLoopSet pressed do (
		undo on (
			tFrame = uiSpnLoopEnd.value
			if ( uiSpnLoopStart.value == tFrame ) do ( tFrame += 1 )
			animationRange = interval (uiSpnLoopStart.value as time) (tFrame as time)
		)
	)



	on uiDropPlaySpeed selected sel do (
        timeConfiguration.playbackSpeed = sel
        SetPBPlaySpeed()
    )

    -- ÇÁ·¹ÀÓÀ» Æ½À¸·Î, Æ½À» ¹Ð¸®¼¼ÄÁµå·Î (integer ¸®ÅÏ)
    function FramToMilisecond frame = (
		-- animationRange.start¸¦ »©ÁÖÁö ¾ÊÀ¸¸é 0ÇÁ·¹ÀÓÀÌ ¾Æ´Ñ °÷¿¡¼­ ½ÃÀÛÇÒ ¶§ µô·¹ÀÌ ¹ß»ýÇÔ
		return ((((frame - animationRange.start) as integer) * (10.0 / 48.0) * m_PBPlaySpeed) as integer)
    )

    function AppendKeyTimeArray m_PBKeyMiliSecArray keys = (
        if keys.count == 0 do return()
        for i = 1 to keys.count do (
            if (keys[i].time >= animationRange.start) AND (keys[i].time <= animationRange.end) do (
                appendifUnique m_PBKeyMiliSecArray (FramToMilisecond keys[i].time)
                appendifUnique m_PBKeyTimeArray keys[i].time
            )
        )
        -- ¾Ö´Ï¸ÞÀÌ¼Ç ·¹ÀÎÁöÀÇ ½ÃÀÛ°ú ³¡Àº ¹«Á¶°Ç Æ÷ÇÔ½ÃÅ´
        appendifUnique m_PBKeyMiliSecArray (FramToMilisecond animationRange.start)
        appendifUnique m_PBKeyTimeArray animationRange.start
        appendifUnique m_PBKeyMiliSecArray (FramToMilisecond animationRange.end)
        appendifUnique m_PBKeyTimeArray animationRange.end
	)
	
	function StopBlocking = (
        clock.active = false
        uiPlayBlock.state = false
        uiPlayBlock.text = "²¥·ÅBlock"
	)
    
    function PlayBlocking = (
		m_PBKeyTimeArray = #() -- ºí·°Å· ¾Ö´Ï¸ÞÀÌ¼Ç¿ë Å° Å¸ÀÓ ¹è¿­ ·ÎÄÃ º¯¼ö (Frame)
        m_PBKeyMiliSecArray = #() -- ºí·°Å· ¾Ö´Ï¸ÞÀÌ¼Ç¿ë Å° Å¸ÀÓ ¹è¿­ ·ÎÄÃ º¯¼ö (¹Ð¸®¼¼ÄÁµå)
        local nowTime = timeStamp()
        for obj in selection do (
            if (classof obj.baseObject) == Biped_Object do (
                if (IfBipRoot obj) then (
                    AppendKeyTimeArray m_PBKeyMiliSecArray obj.transform.controller.horizontal.controller.keys
                    AppendKeyTimeArray m_PBKeyMiliSecArray obj.transform.controller.vertical.controller.keys
                    AppendKeyTimeArray m_PBKeyMiliSecArray obj.transform.controller.turning.controller.keys
                )
                else (
                    AppendKeyTimeArray m_PBKeyMiliSecArray obj.transform.controller.keys
                )
            )
		)
		if m_PBKeyMiliSecArray.count == 0 do (
			StopBlocking()
			return() -- ÀÏ¹Ý ¿ÀºêÁ§Æ®¸¦ ¼±ÅÃÇÏ¸é ¹è¿­ÀÌ ºñ¾îÀÖÀ½
		)
		
		if (isAnimPlaying()) do (
			stopAnimation()
		)		
		
        sort m_PBKeyTimeArray
        sort m_PBKeyMiliSecArray
        m_PBPointer = 1
        while (m_PBKeyTimeArray[m_PBPointer] < sliderTime) do (
            m_PBPointer += 1
        )

        m_PBStartTime = timeStamp() - (FramToMilisecond sliderTime)
		sliderTime = m_PBKeyTimeArray[m_PBPointer] -- ÀÏ´Ü ½½¶óÀÌ´õ Å¸ÀÓÀ» µ¿±âÈ­ (¾ÈÇÏ¸é °­Á¦·Î ½ºÅéµÊ)
		clock.active = true
		uiPlayBlock.text = "Í£Ö¹"
    )
	
	function ReplayBlocking = (
		m_PBPointer = 1
        m_PBStartTime = timeStamp()
        sliderTime = m_PBKeyTimeArray[m_PBPointer]
	)

	on uiPlayBlock changed state do (
        if (selection.count == 0) do (
            StopBlocking()
            return()
        )
		if state then (
            PlayBlocking()
        )
        else (
            StopBlocking()
        )
    )
    
    -- Play Blocking¿ë Æ½ ÀÌº¥Æ® Ã³¸®
    on clock tick do (
        if (m_PBPointer > m_PBKeyMiliSecArray.count) do return()
		local now = timeStamp()
		local pointer
		if (m_PBKeyMiliSecArray.count == m_PBPointer) then (
			ReplayBlocking()
			pointer = 1
		)
		else (
			pointer = m_PBStartTime + m_PBKeyMiliSecArray[m_PBPointer + 1] -- ´ÙÀ½ Å°ÇÁ·¹ÀÓ°ú ÇöÀç ½Ã°£À» ºñ±³
		)
        
        -- ÇöÀç ½Ã°£ÀÌ ´ÙÀ½ ÇÁ·¹ÀÓÀ» ³Ñ¾î¼­¸é Æ÷ÀÎÅÍ Áõ°¡, ½½¶óÀÌ´õ º¯°æ
        if ( now > pointer ) do (
            m_PBPointer += 1
            sliderTime = m_PBKeyTimeArray[m_PBPointer]
        )
        
        -- Æ÷ÀÎÅÍ°¡ ¸¶Áö¸· ÇÁ·¹ÀÓÀ» °¡¸®Å°¸é Ã³À½À¸·Î µÇµ¹¸®°í ½ÃÀÛ½Ã°£ ¸®¼Â
        if (m_PBPointer >= m_PBKeyMiliSecArray.count) do (
            ReplayBlocking()
        )

        if keyboard.escPressed do (
            StopBlocking()
		)
		
		-- ¿ÜºÎ ¿äÀÎ¿¡ ÀÇÇØ °­Á¦·Î ½½¶óÀÌ´õ ½Ã°£ÀÌ º¯°æµÇ¸é »ç¿ëÀÚ¿¡ ÀÇÇÑ ÇÃ·¹ÀÌ Ãë¼Ò·Î °£ÁÖ
		if (sliderTime != m_PBKeyTimeArray[m_PBPointer]) do (
			StopBlocking()
		)
    )

	on uiAbout pressed do (
		if Left_Right=="R" then (cui.dockDialogBar SoxBipedAssist #cui_dock_left; Left_Right="L")
		else if Left_Right=="L" then (cui.dockDialogBar SoxBipedAssist #cui_dock_right; Left_Right="R")
	)
	
	on SoxBipedAssist open do (
        InitLocalVars() -- ÀÛ¾÷¿ë ¹ÙÀÌÆÐµå ·çÆ® ³ëµå¶ó´ø°¡, ¼±ÅÃ¿ë ¹è¿­ º¯¼ö µîÀ» ¹Ì¸® ¼¼ÆÃ
		
		cui.RegisterDialogBar SoxBipedAssist 
        cui.dockDialogBar SoxBipedAssist #cui_dock_right
        callbacks.addScript #filePostOpen "SoxBipedAssist.InitLocalVars ()" id:#SoxBACallbackOpen
		callbacks.addScript #systemPostNew "SoxBipedAssist.InitLocalVars ()" id:#SoxBACallbackNew
		callbacks.addScript #systemPostReset "SoxBipedAssist.InitLocalVars ()" id:#SoxBACallbackReset
	)
	
	on SoxBipedAssist close do (
        callbacks.removeScripts id:#SoxBACallbackOpen
		callbacks.removeScripts id:#SoxBACallbackNew
		callbacks.removeScripts id:#SoxBACallbackReset
	)
)

createDialog SoxBipedAssist lockWidth:true
callbacks.addScript #filePostOpen "fnUpdateSelSetList()" id:#UpdateSelSetList
cui.registerDialogBar SoxBipedAssist style:#(#cui_dock_all,#cui_floatable)
