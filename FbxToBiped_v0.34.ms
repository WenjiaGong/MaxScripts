--¸¸µçÀÌ : ÀÌ»ó¿ø
--»ç¿ë È¯°æ : Max 2014 ÀÌ»ó
-- ÀÌ ½ºÅ©¸³Æ®¸¦ »ç¿ëÇÏ°Å³ª ¼öÁ¤ÇÏ´Â °ÍÀº ÀÚÀ¯ÀÔ´Ï´Ù. ÇÏÁö¸¸ Àç ¹èÆ÷´Â Çã¿ëÇÏÁö ¾Ê½À´Ï´Ù.
-- You can : Use, Edit
-- You cannot : ReDistribute

/*
¸Ş¸ğ
numKeys $.rotation.controller
numKeys $.position.controller
(getKey $.rotation.controller[1].controller 2).time
(getKey $.position.controller[1].controller 2).time
-- time, selected, value µîµî
-- TCB, XYZ ÄÁÆ®·Ñ·¯ Á¤µµ¸¸ ÇÑÁ¤ÇØ¼­ Áö¿øÇØ¾ßÇÒµí
*/

global SoxFbxToBiped		-- SoxFbxToBiped ·Ñ¾Æ¿ô¸íÀ» ±Û·Î¹ú º¯¼ö·Î ÀÎ½ÄÇÏ±â À§ÇØ ÃÊ±â¿¡ ÇÑ ¹ø »ç¿ë

try (destroydialog SoxFbxToBiped) catch()		-- È¤½Ã ¿­·ÁÀÖ´Â SoxFbxToBiped ÀÖÀ¸¸é °­Á¦ Á¾·á

rollout SoxFbxToBiped "Sox Fbx to Biped v0.34" width:280
(
	button uiBtnScanRoot "É¨Ãè¸ù¹Ç" width:60 across:5
	button uiBtnLoad "¼ÓÔØ" width:50 offset:[10, 0]
	button uiBtnSaveAs "±£´æ" width:50 offset:[12, 0]
	button uiBtnReset "ÖØÖÃ" width:50 offset:[12, 0]
	button uiBtnAbout "?" width:30 offset:[16, 0]
	
	group "Ñ¡Ïî" (
		radiobuttons uiRBtnLoadingType "×°ÔØÀàĞÍ" labels:#("Ãû³Æ", "¾ä±ú") default:2
		checkbox uiCBoxAutoHide "ÉèÖÃºó×Ô¶¯Òş²Ø" across:2
		checkbox uiCBoxNonBipedMode "·ÇË«×ãÄ£Ê½"
-- 		checkbox uiCBoxExistingKey "Use existing keys"
-- 		spinner uiSpnThickHor "Thick. Hor." across:2
-- 		spinner uiSpnThickVer "Thick. Ver."
	)
	
	button uiBtnSetRootFbx "Ñ¡ÔñFbx¸ù¹Ç" across:2
	button uiBtnSetRootBip "Ñ¡ÔñBiped¸ù¹Ç"
	
	label uiLabelRootFbx across:2
	label uiLabelRootBip
	
	button uiBtnSetFbx "Ñ¡ÔñFBX" offset:[-4, 0] across:4
	button uiBtnClearFbx "ÇåÀíFBX" offset:[-8, 0]
	button uiBtnSetBip "Ñ¡ÔñBip" offset:[10, 0]
	button uiBtnClearBip "ÇåÀíBip" offset:[6, 0]
	
	listbox uiLBoxFbxBip height:8
	
	button uiBtnListAdd "   +   " tooltip:"Ìí¼ÓÌõÄ¿" offset:[-6,0] across:4
	button uiBtnListDel "    -   " tooltip:"ÒÆ³ıÌõÄ¿" offset:[-16,0]
    button uiBtnListHide "Òş²ØÌõÄ¿" offset:[-8,0]
    button uiBtnListUnHide "ÏÔÊ¾ÌõÄ¿"
	
	/*
	-- Select ±×·ìÀº Àß ¾È¾²´ÂµíÇÏ¿© ºÀÀÎ
	group "Select" (
	button uiBtnSelectFbxRoot "FBX Root" across:2
	button uiBtnSelectBipRoot "Bip Root"
	button uiBtnSelectFbx "1 FBX" across:4
	button uiBtnSelectFbxAll "All FBX"
	button uiBtnSelectBip "1 Bip"
	button uiBtnSelectBipAll "All Bip"
	)
	*/
	
	group "Æ¥Åä" (
 		button uiBtnFigureSync "Æ¥Åä¹Ç÷À"  width:100 across:2
		spinner uiSpnFootHeight "½Å¸ß¶È" range:[0, 999999, 10] tooltip:"¹ÙÀÌÆĞµå ¹ßÀÇ ³ôÀÌ. ¹ÙÀÌÆĞµå ¹ßÀÇ Æ¯¼º»ó ¹ß¸ñ¿¡¼­ ¹ß¹Ù´Ú±îÁö ³ôÀÌ °ªÀ» ÁöÁ¤ÇØ¾ßÇÑ´Ù."
	)
	
	group "¹Ø¼üÖ¡" (
		radiobuttons uiRBtnKeyOption labels:#("¶¯»­·¶Î§", "µ±Ç°Ö¡") default:1 across:2
		checkbox uiChkDeleteExistingKeys "É¾³ıµ±Ç°Ö¡" checked:true tooltip:"¸ğµç ¹ÙÀÌÆĞµå Å°¸¦ »èÁ¦ ÈÄ ¹ÙÀÌÆĞµå ¾Ö´Ï¸ŞÀÌ¼Ç Å°¸¦ »ı¼º"
		button uiBtnKeyAll "KÈ«²¿¹Ø¼üÖ¡" width:100 across:2
		button uiBtnKeySelectedOne "KÑ¡ÖĞ¹Ø¼üÖ¡" width:100
	)
	
	progressBar uiPBar height:8 color:red
	
	label uiLabelBipInfo "Biped : " align:#left across:2
	label uiLabelStatus "×´Ì¬: " align:#left
	
	button uiBtnSetAnimRangeBySelectedObj "Ñ¡¶¨¶ÔÏóµÄ¶¯»­·¶Î§" tooltip:"¼±ÅÃÇÑ ¿ÀºêÁ§Æ®¸¦ ±âÁØÀ¸·Î¾Ö´Ï¸ŞÀÌ¼Ç ·¹ÀÎÁö¸¦ º¯°æ"
	
	group "Ìæ»»Ãû³Æ" (
		edittext uiETxtReplaceFrom across:3
		edittext uiETxtReplaceTo
		button uiBtnDoReplace "Ìæ»»"
	)

    group "×Ô¶¯¸½¼ÓÃû³Æ" (
		edittext uiETxtAppend "¸½¼ÓÃû³Æ" width:180 offset:[0,0] across:2
        spinner uiSpnPointSize range:[0.1,9999,10]
		button uiBtnDoAppend "¸½¼Ó!" offset:[0,0] tooltip:"¸ù¾İ tempFirst Ñ¡¶¨¶ÔÏóµÄÃû³ÆÖØÃüÃûµÚ¶ş¸ö¶ÔÏó¡£" across:3
        button uiBtnDoAppendAlign "Apnnd Align!" offset:[0,0] tooltip:"Ëü»á×Ô¶¯¶ÔËüÃÇ½øĞĞÅÅĞò£¬½«ËüÃÇÁ´½ÓÎª×Ó¶ÔÏó£¬²¢ÖØÃüÃûËüÃÇ£¬±ØĞëÑ¡ÔñÁ½¸ö¶ÔÏó²ÅÄÜÔËĞĞ"
        button uiBtnDoAppendAlignedPoint "Apnend Point!" offset:[0,0] tooltip:"´´½¨×Ô¶¯¶ÔÆëÇÒ×÷ÎªÑ¡¶¨¶ÔÏóµÄµãÖúÊÖ¡£"
	)
	
	group "Ìí¼Ó¿ØÖÆÆ÷" (
		button uiBtnAddPositionConstraint "Î»ÖÃ" across:3
		button uiBtnAddLookatConstraint "×¢ÊÓ"
        button uiBtnAddOrientationConstraint "·½Ïò"
	)

	--button uiBtnDeletePosKeys "Delete Position Keys" align:#left tooltip:"Delete the Position keys after the current frame."
-- 	button uiBtnTest "Test"
	
	-- Fbx¿Í Biped ÇÑ ½ÖÀ» Á¤ÀÇÇÏ´Â ±¸Á¶Ã¼. ¹ÙÀÌÆĞµå´Â Xtra ¶ó´ø°¡ Prop ÀÌ¶ó´ø°¡ ÇÏ´Â ÀÌ·± Àú·± Ãß°¡ Á¤º¸°¡ ÀÖÀ» ¼ö ÀÖÀ½
	struct pairDef (
		fbxObj,
		bipObj
		--bipType		-- "Root" / "Body" / "Tail" / "PonyTail" / "Prop" / "Xtra" µîÀÌ °¡´É
	)
	local pairs = #()
	local rootObjFbx
	local rootObjBip
		
	struct bipType (
		limbName,
		linkIndex
	)
	
	-- trParent ·ÎºÎÅÍ trChild ÀÇ ·ÎÄÃ À§Ä¡¿Í ·ÎÅ×ÀÌ¼Ç°ú ½ºÄÉÀÏ °ªÀ» ¸¦ ¸®ÅÏÇÑ´Ù.
	function GetLocalTransform trParent trChild = -- ÀÔ·Â °ªÀº matrix3, ¸®ÅÏ °ªÀº matrix3,
	(
		trChild*(inverse trParent)
	)
	
	-- ¸®½ºÆ®¿¡ ¹ÙÀÌÆĞµå°¡ ¾Æ´Ñ ¿ÀºêÁ§Æ®°¡ ÀÖ´ÂÁö °Ë»ç. ¹ÙÀÌÆĞµå°¡ ¾Æ´Ñ ¿ÀºêÁ§Æ®°¡ ÀÖÀ¸¸é true ¸®ÅÏ
	function NonBipedCheck = (
		returnBool = false
		if ( classof rootObjBip ) != Biped_Object and rootObjBip != undefined do ( returnBool = true )

		if pairs.count == 0 do ( return returnBool )
		for o in pairs do (
			if ( classof o.bipObj ) != Biped_Object and o.bipObj != undefined do ( returnBool = true )
		)
		
		return returnBool
	)
	
	-- pairs º¯¼ö ¾È¿¡ ¸ÅÄªÀÌ ´ú µÈ °æ¿ì°¡ ÀÖ´ÂÁö °Ë»ç ¹®Á¦ ¾øÀ¸¸é true, ¹®Á¦ ÀÖÀ¸¸é false ¸®ÅÏ
	function CheckMatch = (
		if pairs.count == 0 do return true
		for o in pairs do (
			if ( o.fbxObj == undefined and o.bipObj != undefined ) do return false
			if ( o.fbxObj != undefined and o.bipObj == undefined ) do return false
		)
		return true
	)
	
	-- ¹ÙÀÌÆĞµå ¿ÀºêÁ§Æ®ÀÇ XÃà ½ºÄÉÀÏ°ª ¸¸Å­ÀÇ ¿ùµå Æ÷Áö¼ÇÀ» ¾Ë¾Æ³¿ (Xtra µîÀÇ ¿ÀºêÁ§Æ®¿¡¼­ ÀÚ½ÄÀÌ ¿©·µ ÀÖÀ» ¶§ ½ÇÁ¦ ½ºÄÉÀÏ¿¡ »ç¿ëÇÒ ÀÚ½ÄÀ» ¾Ë¾Æ³»±â À§ÇÔ)
	function GetLocalScaleXWorldPos bipObj = (
		tScale = biped.getTransform bipObj #scale
		tMatrix = matrix3 1
		tMatrix.pos = [tScale.x, 0, 0]
		tMatrix = tMatrix * bipObj.transform
		return tMatrix.pos
	)
	
	-- ¹ÙÀÌÆĞµå ¿ÀºêÁ§Æ®ÀÇ ÀÚ½ÄÀÌ ¿©·µ ÀÖÀ» ¶§ XÃà ½ºÄÉÀÏ À§Ä¡¸¦ ±âÁØÀ¸·Î ÇÏ³ªÀÇ ÀÚ½ÄÀ» ¸®ÅÏÇÑ´Ù. ÀÚ½ÄÀÌ ¾ø°Å³ª ¹®Á¦°¡ ÀÖÀ¸¸é undefined ¸®ÅÏ
	function GetChildByScalePos bipObj = (
		if ( (classof bipObj) != Biped_Object ) do return undefined
		if ( bipObj.children.count == 1 ) do return bipObj.children[1]
		if ( bipObj.children.count == 0 ) do return undefined
		
		tDestPos = GetLocalScaleXWorldPos bipObj		-- ÀÌ À§Ä¡¿¡ °¡±î¿î ÀÚ½ÄÀÌ ½ºÄÉÀÏÀÇ ±âÁØÀÌ µÇ´Â ÀÚ½Ä
		
		childDistArr = #()
		tIndex = 0
		for i = 1 to bipObj.children.count do (
			append childDistArr ( distance bipObj.children[i].transform.position tDestPos )
			tMinDist = amin childDistArr
			tIndex = finditem childDistArr tMinDist
		)
		return bipObj.children[tIndex]
	)
	
	-- ¸®ÅÏ ½ºÆ®·°ÃÄÀÇ ¸â¹ö : limbName, linkIndex
	function GetBipedType obj = (
		if ( obj == undefined ) do return undefined
		if ( (classof obj) != Biped_Object ) do return (bipType limbName:#nonBiped linkIndex:0)
		
		-- biped.maxNumLinks $ ÀÌ ¹æ¹ıÀ¸·Î ¹ÙÀÌÆĞµåÀÇ ÃÖ´ë ¸µÅ© ¼ö¸¦ ¾Ë¾Æ³¾ ¼ö ÀÖ´Ù. º¸Åë 25ÀÌÁö¸¸ ³Ë³ËÇÏ°Ô 30
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
		
		-- ¹ÙÀÌÆĞµå Å¬·¡½ºÀÎµ¥ Á¤Ã¼¸¦ ¾Ë¾Æ³»Áö ¸øÇÑ°Ç ¸ğµÎ Xtra·Î Á¤ÀÇ
		-- https://forums.cgsociety.org/t/biped-xtra-maxscript-commands/1570351/5 ¼û°ÜÁø ¹ÙÀÌÆĞµå Xtra ÇÔ¼öµéÀ» Á» »ìÆìºÁ¾ßÇÒµí.
        -- biped.getXtraName $ ÀÌ°É ÇÏ¸é ¿¢½ºÆ®¶ó ·çÆ®´Â ÀÌ¸§À» ¸®ÅÏÇÏ°í ¿¢½ºÆ®¶ó ·çÆ®°¡ ¾Æ´Ï¸é false ¸®ÅÏ.
        -- ±×·¯³ª ¹®Á¦´Â ¿¢½ºÆ®¶ó ¸µÅ© 1 ÀÌ»óºÎÅÍ´Â ¿¡·¯ ¹ß»ıÇÔ. ¿¡·¯ ¹ß»ıÇÏ´Â°É ÀÌ¿ëÇØ¼­ try·Î 0°ú 1 ÀÌ»ó ÀÎµ¦½º¸¦ Ã£´Â ¹æ¹ıµµ °¡´ÉÇÒ µí. ¾Æ¹«Æ° º¸·ù
		return (bipType limbName:#xtra linkIndex:0)
	)
		
	-- arr ¹è¿­¿¡¼­ id1°ú id2 ÀÇ ³»¿ëÀ» ¼­·Î µÚ¹Ù²Û´Ù. ¸®ÅÏµÈ ¹è¿­Àº ¿ø·¡ ¹è¿­À» º¯°æ½ÃÅ°Áö ¾Ê´Â´Ù.
	function SwapArray arr id1 id2 = (
		if arr.count < id1 or arr.count < id2 do return arr -- Àß¸øµÈ ¾ÆÀÌµğ°¡ ÀÔ·ÂµÇ¸é ±×³É ¿ø·¡ ¹è¿­À» ¸®ÅÏ
		if id1 == id2 do return arr -- °°Àº ¹øÈ£ÀÇ ¾ÆÀÌµğ°¡ ÀÔ·ÂµÇ¾îµµ ±×³É ¿ø·¡ ¹è¿­À» ¸®ÅÏÇÑ´Ù.
	
		if id1 > id2 do -- ¹è¿­ ÀÎµ¦½º´Â ¹İµå½Ã id1ÀÌ ´õ ÀÛ´Ù´Â »ç½ÇÀ» ±âÁØÀ¸·Î ÀÛµ¿ÇØ¾ß ÇÑ´Ù.
		(
			tempID = id1
			id1 = id2
			id2 = tempID
		)
	  
	-- ¹è¿­ º¹Á¦´Â deepcopy·Î ÇØ¾ßÇÔ. ¾È±×·¯¸é ¿ø·¡ ¿øº»°ú instance °ü°è°¡ µÉ °¡´É¼ºÀÌ ÀÖ´Âµ¥
	-- ¾ÈÀüÇÏ°Ô ÇÏ·Á¸é deepcopy·Î º¹Á¦ÇÏ´Â°Ô ÁÁÀ½.
		tempArr = deepcopy arr   
		tempVar = tempArr[id1]
		tempArr[id1] = tempArr[id2]
		tempArr[id2] = tempVar
	  
		return tempArr
	)
		
	function SetStatus = (
		if ( pairs.count == 0 ) do return ()
		countFbx = 0
		countBip = 0
		
		for o in pairs do (
			if ( o.fbxObj != undefined ) do ( countFbx += 1 )
			if ( o.bipObj != undefined ) do ( countBip += 1 )
		)
		
		if ( rootObjFbx != undefined ) do ( countFbx += 1 )
		if ( rootObjBip != undefined ) do ( countBip += 1 )
		
		tStr = stringstream ""
		format "Status : % FBX, % Bip" countFbx countBip to:tStr
		uiLabelStatus.text = tStr as string
	)
	
	function SetBipInfo = (
		if ( pairs.count == 0 ) do return ()
		if ( uiLBoxFbxBip.selection == 0 ) do return ()
		
		local bipType = GetBipedType pairs[uiLBoxFbxBip.selection].bipObj
		
		if ( bipType == undefined ) do ( uiLabelBipInfo.text  = "Biped : " ;return () )
		
		tStr = stringstream ""
		format "Biped : %, Link = %" bipType.limbName bipType.linkIndex to:tStr
		uiLabelBipInfo.text = tStr as string
	)
	
	-- children À» ¹è¿­¿¡ append ÇØÁØ´Ù. ÀÔ·ÂµÈ arr ÀÚÃ¼°¡ º¯°æµÇ¹Ç·Î ¸®ÅÏ ¾øÀ½
	function AppendChildren arr children = (
		if ( children.count ) == 0 do return ()
		for o in children do (
			append arr o
		)
	)
	
	-- obj ÀÇ ¸ğµç ÀÚ½ÄµéÀ» ¹è¿­·Î ¸®ÅÏ. ¹è¿­ ¼ø¼­´Â °èÃş±¸Á¶ ¼ø¼­´ë·Î
	function GetAllChildren obj = (
		if ( obj == undefined ) do return undefined
		
		local tAllChildren = #()
		if ( obj.children.count != 0 ) do (
			for o in obj.children do (
				append tAllChildren o
				if ( o.children.count != 0 ) do (
					tAllChildren = tAllChildren +  (GetAllChildren o)		-- recursive
				)
			)
		)
		return tAllChildren
	)
	
	-- pairs ¹è¿­À» ´ë»óÀ¸·Î °èÃş±¸Á¶ ¼ø¼­´ë·Î ¼ÒÆÃ ÇÑ´Ù. pairs ¹è¿­Àº ¸ğµÎ rootObjBip ÀÇ ÀÚ½ÄÀÌ¶ó´Â ÀüÁ¦
	function SortByHierarchy = (
		if ( pairs.count == 0 ) do return ()
		
		-- ÀÏ´Ü rootObjBip ÀÇ ¸ğµç ÀÚ½ÄµéÀ» ¾ò¾î¿Â´Ù. °èÃş±¸Á¶ ¼ø¼­´ë·Î ¾ò¾îÁü. ÀÌÈÄ pairs ¿¡ »ç¿ëµÈ °Íµé¸¸ ³²±â°í ³¯·Á¾ßÇÔ
		tAllChildren = GetAllChildren rootObjBip
		
		-- pairs¿¡ »ç¿ëµÈ ¹ÙÀÌÆĞµå ¿ÀºêÁ§Æ® ¹è¿­À» ÀÓ½Ã·Î ¸¸µç´Ù. °èÃş±¸Á¶ ¼ø¼­´ë·Î°¡ ¾Æ´Ï´Ù.
		tBips = #()
		for i = 1 to pairs.count do (
			append tBips pairs[i].bipObj
		)
		
		for i = tAllChildren.count to 1 by -1 do (
			-- tBips ¿¡ Á¸ÀçÇÏÁö ¾Ê´Â children Àº tAllChildren ¿¡¼­ Á¦°ÅÇÑ´Ù.
			if ( (finditem tBips tAllChildren[i]) == 0 ) do (
				tAllChildren = ( deleteitem tAllChildren i )
			)
		)

		-- tBips 			pairs¿Í ¼ø¼­´Â °°À¸³ª ¹ÙÀÌÆĞµå¸¸À¸·Î µÈ ¹è¿­
		-- tAllChildren	°èÃş±¸Á¶°¡ Á¤·ÄµÈ. ±×¸®°í ¹ÙÀÌÆĞµå¸¸ µé¾îÀÖ´Â ¹è¿­
		retArr = #()
		tProps = #()		-- ÇÁ¶øµéÀ» Æ¯º°Ã³¸®ÇÏ±â À§ÇÑ ÀÓ½Ã ¹è¿­
		for i = 1 to tAllChildren.count do (
			local bipType = ( GetBipedType tAllChildren[i] ).limbName
			if ( bipType != #prop1 and bipType != #prop2 and bipType != #prop3 ) then (
				-- ÇÁ¶øÀÌ ¾Æ´Ñ °æ¿ì
				append retArr pairs[(finditem tBips tAllChildren[i])]
			)
			else (
				-- ÇÁ¶øÀÎ °æ¿ì
				append tProps pairs[(finditem tBips tAllChildren[i])]
			)
		)
		
		retArr = retArr + tProps		-- ÇÁ¶øÀ» °¡Àå ÈÄ¼øÀ§·Î ½ÌÅ©ÇØ¾ßÇÔ
		
		-- pairs ÀÇ ¹ÙÀÌÆĞµå°¡ ÁöÁ¤µÇÁö ¾ÊÀº undefined Ç×¸ñµéÀ» »ì·ÁµÎ¾î¾ßÇÏ¹Ç·Î retArr¿¡ ´õÇØÁØ´Ù.
		for o in pairs do (
			if ( o.bipObj == undefined ) do ( append retArr o )
		)
		
		pairs = deepcopy retArr
	)
	
	function SetList = (
		-- 0.29¹öÀü±îÁö´Â ¸®½ºÆ® °»½Å½Ã¸¶´Ù ¸®½ºÆ®¸¦ °èÃş±¸Á¶ ¼ø¼­´ë·Î ¼ÒÆÃÀ» Çß¾úÀ¸³ª
		-- ¸Æ½º ÃÖ½Å¹öÀüºÎÅÍ ¸Å¿ì ´À¸®°Ô ÀÛµ¿ÇÏ¿© ¸®½ºÆ® °»½Å¿¡¼­´Â Á¦¿ÜÇÔ
		
		local items = #()
		for o = 1 to pairs.count do (
			tString = ""
			if ( pairs[o].fbxObj != undefined ) then (
				tString += pairs[o].fbxObj.name
			)
			else (
				tString += "( ... )"
			)
			tString += " --> "
			if ( pairs[o].bipObj != undefined ) then (
				tString += pairs[o].bipObj.name
			)
			else (
				tString += "( ... )"
			)
			append items tString
		)
		uiLBoxFbxBip.items = items
		
		--if ( uiLBoxFbxBip.items.count > 1 and uiLBoxFbxBip.selection == 1 ) do uiLBoxFbxBip.selection = 2
		if ( uiLBoxFbxBip.items.count > 0 and uiLBoxFbxBip.selection == 0 ) do uiLBoxFbxBip.selection = uiLBoxFbxBip.items.count
		
		tSel = uiLBoxFbxBip.selection
		uiLBoxFbxBip.selection = amin uiLBoxFbxBip.items.count (tSel + 5)
		uiLBoxFbxBip.selection = tSel
		
		SetStatus ()
		SetBipInfo ()
		if ( rootObjFbx != undefined ) then ( uiLabelRootFbx.text = rootObjFbx.name ) else ( uiLabelRootFbx.text = "" )
		if ( rootObjBip != undefined ) then ( uiLabelRootBip.text = rootObjBip.name ) else ( uiLabelRootBip.text = "" )
	)
	
	-- pairs ¹è¿­ÀÇ FBX¿¡¼­ obj ÀÇ À§Ä¡ ¹øÈ£¸¦ ¸®ÅÏ
	function FindInPairsFbx obj = (
		local pos = 0
		for o  = 1 to pairs.count do (
			try ( if ( pairs[o].fbxObj == obj ) do pos = o ) catch ()
		)
		return pos
	)
	
	-- pairs ¹è¿­ÀÇ ¹ÙÀÌÆĞµå¿¡¼­ obj ÀÇ À§Ä¡ ¹øÈ£¸¦ ¸®ÅÏ
	function FindInPairsBip obj = (
		local pos = 0
		for o  = 1 to pairs.count do (
			try ( if ( pairs[o].bipObj == obj ) do pos = o ) catch ()
		)
		return pos
	)
	
	function SetFileStream = -- pairs ¹è¿­ ±¸Á¶Ã¼ º¯¼öµéÀ» ¸ğµÎ ÃëÇÕÇØ¼­ Á¤ÇØÁø Æ÷¸ËÀ¸·Î Á¤·ÄÇÑ µÚ StringStream º¯¼ö ÇÏ³ª·Î ¸®ÅÏ
	(
		if pairs.count == 0 do return undefined
			
		tempStr = stringStream ""
		ifStr = ""

		-- uiSpnFootHeight ÀÇ Foot Height ¸ÕÀú Ã³¸®
		format "FootHeight = %\n" (uiSpnFootHeight.value as string) to:tempStr
		
		for k = 1 to pairs.count do
		(
			if ( pairs[k].fbxObj != undefined ) then ( ifStr = pairs[k].fbxObj.inode.handle as string ) else ( ifStr = "undefined" )
			format "FbxObjHandle = %\n" ifStr to:tempStr
			
			if ( pairs[k].fbxObj != undefined ) then ( ifStr = pairs[k].fbxObj.name as string ) else ( ifStr = "" )
			format "FbxObjName = %\n" ifStr to:tempStr
			
			if ( pairs[k].bipObj != undefined ) then ( ifStr = pairs[k].bipObj.inode.handle as string ) else ( ifStr = "undefined" )
			format "BipObjHandle = %\n" ifStr to:tempStr
			
			if ( pairs[k].bipObj != undefined ) then ( ifStr = pairs[k].bipObj.name as string ) else ( ifStr = "" )
			format "BipObjName = %\n" ifStr to:tempStr
		)
		return tempStr
	)
	
	function CheckFileExt str = -- ½ºÆ®¸µÀÇ È®ÀåÀÚ¸¦ °Ë»ç
	(
		keyword = "sftb"
		if str.count <= (keyword.count + 1) do return false
		
		tempStr = ""
		tempIndex = str.count - keyword.count + 1
		for o = tempIndex to str.count do tempStr += str[o]
		
		if (stricmp keyword tempStr) == 0 do return true
		-- if (toUpper keyword) == (toUpper tempStr) do return true -- for max 2008 or higher
		return false
	)
	
	-- obj°¡ parent ÀÇ ÇÏÀ§ ÀÚ½Ä¿¡ ¼Ò¼ÓµÇ¾îÀÖ´ÂÁö °Ë»ç
	function IfChild parent obj = (
		
		found = false
		checkObj = obj
		while checkObj != undefined do (
			if ( parent == checkObj ) do ( found = true )
			checkObj = checkObj.parent
		)
		return found
	)
	
	-- ¾À ³»¿¡ °°Àº ÀÌ¸§À» °¡Áø ¿ÀºêÁ§Æ®°¡ ¿©·µ ÀÖÀ» ¶§ ¹è¿­·Î ¸ğµÎ ¸®ÅÏ
	function GetObjsByName str = (
		objs = #()
		for o in objects do (
			if ( o.name == str ) do ( append objs o )
		)
		return objs
	)
	
	-- ÀüÃ¼ ¾ÀÀ» Á¶»çÇØ¼­ ±âÁ¸¿¡ FbxRoot ÁöÁ¤µÈ À¯Àú ÇÁ·ÎÆÛÆ¼¸¦ Á¦°ÅÇÏ°í obj ¿¡ ·çÆ®¶ó´Â Ç¥½Ã¸¦ ÇÑ´Ù.
	function SetUserPropFbxRoot obj = (
		if ( objects.count == 0 ) do return ()
		if ( obj == undefined ) do return ()
		
		for o in objects do (
			if ( (getUserProp o "SoxFbxToBiped_FbxRoot") != undefined  ) do ( setUserProp o "SoxFbxToBiped_FbxRoot" false )
		)
		
		setUserProp obj "SoxFbxToBiped_FbxRoot" true
	)
	
	function SetUserPropBipRoot obj = (
		if ( objects.count == 0 ) do return ()
		if ( obj == undefined ) do return ()
		
		for o in objects do (
			if ( (getUserProp o "SoxFbxToBiped_BipRoot") != undefined  ) do ( setUserProp o "SoxFbxToBiped_BipRoot" false )
		)
		
		setUserProp obj "SoxFbxToBiped_BipRoot" true
	)

	function GetParentObj obj = (
		return (maxOps.getNodeByHandle (getUserProp obj "FBXtoBiped_FixedDistHelperParent"))
	)

	function GetTargetObj obj = (
		maxOps.getNodeByHandle (getUserProp obj "FBXtoBiped_FixedDistHelperTarget")
	)

	function GetHelperType obj = (
		return (getUserProp obj "FBXtoBiped_FixedDistHelperType")
	)

	function GetLookAtHelperByPointer obj = (
		local tUserProp = getUserProp obj "FBXtoBiped_FixedDistPointerLookAt"
		if (tUserProp == undefined) do return undefined
		return (maxOps.getNodeByHandle tUserProp)	
	)

	function GetOrientationHelperByPointer obj = (
		local tUserProp = getUserProp obj "FBXtoBiped_FixedDistPointerOrientation"
		if (tUserProp == undefined) do return undefined
		return (maxOps.getNodeByHandle tUserProp)	
	)

	-- ¼Õ¸ñ°°Àº ºÎÀ§´Â º»ÀÇ ÀÚ½ÄÀ¸·Î ¿©·¯ º»ÀÌ ÀÖÀ» ¼ö ÀÖ¾î¼­ ¿©·¯ °³ÀÇ ÇïÆÛ°¡ ÁßÃ¸µÈ´Ù.
	-- ±×·¯¹Ç·Î ºÎ¸ğ º»¿¡ ÀÚ½Ä ÇïÆÛ Æ÷ÀÎÅÍ ¹øÈ£¸¦ ±â·ÏÇÏ·Á¸é ±¸Á¶°¡ º¹ÀâÇØÁø´Ù.
	-- ±×·¡¼­ ´Ü¼øÇÏ°Ô, ÀÚ½ÄÁß¿¡ ÇïÆÛ°¡ ÀÖ´ÂÁö, ±×¸®°í µÎ ¹øÂ° ¼±ÅÃ º»°ú ÀÏÄ¡ÇÏ´ÂÁö¸¦ Á¶»çÇÑ´Ù.
	-- ÀÔ·Â°ª : selA´Â Ã¹ ¹øÂ° ¼±ÅÃ º», selB´Â µÎ ¹øÂ° ¼±ÅÃ º»
	-- Ãâ·Â°ª : ¸ÅÄª µÇ¸é ÇïÆÛ¸¦ ¸®ÅÏÇÏ´ø°¡, ¸ÅÄªÀÌ ¾ÈµÇ¸é undefined
	-- ÀÌ ¹æ½ÄÀº Orientation ÇïÆÛ¸¦ Ã£´Âµ¥ »ç¿ëÇÒ ¼ö ¾ø´Ù. Orientation ÇïÆÛ´Â selAÀÇ ÀÚ½Ä¿¡ ¾øÀ¸¹Ç·Î. ´ë½Å¿¡ FindOrientationHelperByTarget ÇÔ¼ö¸¦ »ç¿ëÇØ¾ßÇÔ
	function GetLookAtHelper selA selB = (
		for obj in selA.children do (
			if (GetHelperType obj == "LookAt") do (
				tTarget = GetTargetObj obj
				if (tTarget == selB) do ( return obj)
			)
		)
		-- ¸ÅÄªµÇ´Â°Ô ¾øÀ¸¸é undefined
		return undefined
	)

	-- ¾À ÀüÃ¼¿¡¼­ obj¸¦ Å¸°ÙÀ¸·Î ÇÏ´Â Orientation ÇïÆÛ¸¦ Ã£´Â´Ù. ¾øÀ¸¸é undefined
	function FindOrientationHelperByTarget obj = (
		for o in helpers do (
			if (GetHelperType o == "Orientation") do (
				local target = GetTargetObj o
				if (target == obj) do (return o)
			)
		)
		return undefined
	)
	
	-- Äİ¹é¿¡¼­ È£ÃâµÇ´Â ÇÔ¼ö. ¾À¿¡¼­ ¼±ÅÃÀÌ º¯È­µÉ ¶§¸¶´Ù ÅøÀÇ ¸®½ºÆ®¸¦ µ¿±âÈ­ ÇØÁØ´Ù.
	-- Fixed Distance Helper ¹öÆ°ÀÇ È°¼º, ºñÈ°¼ºµµ ¼¼ÆÃÇÑ´Ù.
	function CallbackSyncSel = (
		if ( pairs.count == 0 ) do return ()
		tIndex = 0
		for i = 1 to pairs.count do (
			if ( pairs[i].fbxObj == selection[1] and selection.count != 0 ) do ( tIndex = i )
			if ( pairs[i].bipObj == selection[1] and selection.count != 0 ) do ( tIndex = i )
		)
		
		if ( tIndex != 0  ) do (
			uiLBoxFbxBip.selection = tIndex
			SetList ()
 			SetStatus ()
			SetBipInfo()
		)
	)

	-- FBXÀÇ ¹ßÀº ¹ß°¡¶ôÀ» ¹Ù¶óº¸°í, ¹ÙÀÌÆĞµåÀÇ ¹ßÀº ¹ß°¡¶ô°ú ¼öÆòÀÎ Â÷ÀÌ·Î ÀÎÇØ
	-- ¹ÙÀÌÆĞµå ¹ßÀÇ ³ôÀÌ¿Í °¢µµ¸¦ FBX ±âÁØÀ¸·Î ¾Ë¾Æ³»¾ßÇÔ.
	-- ZÃàÀ¸·Î Angle¸¸Å­ ¸¶ÀÌ³Ê½º È¸ÀüµÈ ÄõÅÍ´Ï¾ğÀ» ¸®ÅÏ
	function GetBipedFootAngleQuat bipFoot = (
		local footAngle = 0
		local bipToe = bipFoot.children[1]	-- ¹ÙÀÌÆĞµå ¹ßÀº ¹ß°¡¶ôÀÌ ¹«Á¶°Ç ÇÏ³ª¶óµµ ÀÖ´Ù.
		
		local footIndex = FindInPairsBip bipFoot
		if footIndex == 0 do (return footAngle)	-- ¸®½ºÆ®¿¡ Á¸ÀçÇÏÁö ¾ÊÀ¸¸é ±âº» Angle °ªÀ» ¸®ÅÏ
		local toeIndex = FindInPairsBip bipToe
		if toeIndex == 0 do (return footAngle)	-- ¸®½ºÆ®¿¡ Á¸ÀçÇÏÁö ¾ÊÀ¸¸é ±âº» Angle °ªÀ» ¸®ÅÏ

		local fbxFoot = pairs[footIndex].fbxObj
		if (fbxFoot == undefined) OR (isDeleted fbxFoot) do (return footAngle)
		local fbxToe = pairs[toeIndex].fbxObj
		if (fbxToe == undefined) OR (isDeleted fbxToe) do (return footAngle)

		local distC = distance fbxFoot.pos fbxToe.pos
		local distB = uiSpnFootHeight.value
		local distA = sqrt(distC * distC - distB * distB)	-- »ï°¢ÇÔ¼ö aÁ¦°ö + bÁ¦°ö = cÁ¦°ö
		footAngle = atan(distB/distA)
		return (quat -footAngle [0, 0, 1])
	)
	
	-- pairs ÀüÃ¼¿¡ ´ëÇØ ÁöÁ¤µÈ ½Ã°£¸¸Å­ ¾Ö´Ï¸ŞÀÌ¼Ç Å°¸¦ ½ÌÅ© ÇÑ´Ù.
	function SyncKeyRangedAll frameStart frameEnd = (
		if ( classof rootObjBip ) == Biped_Object do (
			rootObjBip.controller.rootnode.controller.figureMode = false
			-- Separate FK Tracks¸¦ ºĞ¸®ÇØ¾ß ÆÈ²ŞÄ¡¿Í ¹«¸­ÀÌ ¾ÈÁ¤ÀûÀ¸·Î ±¸¿öÁø´Ù. ¹ÙÀÌÆĞµå´Â ÇÏ¹ÚÀÌ³ª Á¾¾Æ¸®¸¦ È¸Àü½ÃÅ³ ¶§ ºÎ¸ğ°¡ °°ÀÌ Æ²¾îÁö´Â Æ¯¼ºÀÌ ÀÖ´Âµ¥, Æ®·¢À» ºĞ¸®ÇÏ¸é µ¶ÀÚÀûÀ¸·Î Å°°¡ ¹İ¿µµÈ´Ù.
			rootObjBip.controller.sepLegsTracks = true
			rootObjBip.controller.sepArmsTracks = true
		)
		clearSelection()		-- ¹ÙÀÌÆĞµå°¡ ¼±ÅÃµÈ »óÅÂ¿¡¼­´Â at time ¹æ½Ä°ú È£È¯µÇÁö ¾Ê´Â´Ù.
		
		--disableSceneRedraw()
		
		--ÀÏ´Ü Å° »èÁ¦
		deselectKeys rootObjBip.controller frameStart frameEnd
		selectKeys rootObjBip.controller frameStart frameEnd
		local deleteType
		if uiChkDeleteExistingKeys.state then (deleteType = #allKeys) else (deleteType = #selection)
		if ( classof rootObjBip ) == Biped_Object then (
			biped.deleteKeys rootObjBip.controller.vertical.controller deleteType
			biped.deleteKeys rootObjBip.controller.horizontal.controller deleteType
			biped.deleteKeys rootObjBip.controller.turning.controller deleteType
		)
		else (
			deleteKeys rootObjBip.controller deleteType
		)
		
		for p = 1 to pairs.count do (
			local bipObj = pairs[p].bipObj
			deselectKeys bipObj.controller frameStart frameEnd
			selectKeys bipObj.controller frameStart frameEnd
			if ( classof bipObj ) == Biped_Object then (
				biped.deleteKeys bipObj.controller deleteType 
			)
			else (
				deleteKeys bipObj.controller deleteType 
			)
		)
		
		-- root ³ëµå ¸ÕÀú
		for i = frameStart to frameEnd do (
			at time (i as time) (
				if ( classof rootObjBip ) == Biped_Object then (
						biped.setTransform rootObjBip #pos rootObjFbx.transform.position true
						biped.setTransform rootObjBip #rotation  rootObjFbx.transform.rotation true
				)
				else (
					with animate on (
						tMatrix = matrix3 1
						tMatrix.rotation = rootObjFbx.transform.rotation
						tMatrix.position = rootObjFbx.transform.position		-- rotation ´ÙÀ½¿¡ position ÀÇ ¼ø¼­°¡ Áß¿ä
						rootObjBip.transform = tMatrix
					)
				)
			) -- at time end
		) -- for end

		-- fbx º»ÀÇ Å°ÇÁ·¹ÀÓÀÌ ¶ç¾ö ¶ç¾ö ÀÖÀ» °æ¿ì ¸Å ¿ÀºêÁ§Æ®¸¶´Ù ÀüÃ¼ ÇÁ·¹ÀÓÀ» ¸ğµÎ ÀÛ¾÷ÇÑ µÚ¿¡ ´ÙÀ½ ¿ÀºêÁ§Æ®·Î ³Ñ¾î°¡´Â ¹æ½ÄÀ» ÃëÇØ¾ßÇÑ´Ù.
		for p = 1 to pairs.count do (
			local bipObj = pairs[p].bipObj
			local fbxObj = pairs[p].fbxObj
			local bipType = GetBipedType bipObj
			for i = frameStart to frameEnd do (
				at time (i as time) (
					if ( classof bipObj ) == Biped_Object then (
						-- ¿Ş¹ßÀÌ°Å³ª ¿À¸¥¹ßÀÌ°í ¸µÅ© ¹øÈ£°¡ 3¹øÀÎ FootÀÎ °æ¿ì Offset °¢µµ¸¦ ´õÇÑ´Ù.
						local tQuat = fbxObj.transform.rotation
						if (bipType.limbName == #lleg OR bipType.limbName == #rleg) do (
							if (bipType.linkIndex == 3) do (
								-- ¿©±â¼­ ´õÇÏ´Â °¢µµ´Â Figure Sync¿¡¼­ ÀÌ¹Ì °è»êµÈ °ªÀ» Àç»ç¿ëÇÏ´Â °Íµµ °ËÅäÇßÀ¸³ª, Figure Sync ¾øÀÌ Key AllÀ» ÇÏ´Â °æ¿ìµµ °í·ÁÇá¿© ¸Å ¹ø AngleÀ» °è»êÇÏ´Â ¹æ½ÄÀ¸·Î Àû¿ë
								-- ¿Ş¹ßÀ» ±âÁØÀ¸·Î ¹Ì¸® ¹ß¸ñ Offset AngleÀ» ¾ò¾îµĞ´Ù. (FBX¿Í ¹ÙÀÌÆĞµåÀÇ ¹ß¸ñ ±¸Á¶ Â÷ÀÌ º¸Á¤)
								local offsetQuat = GetBipedFootAngleQuat bipObj	-- ¹ß¸ñÀ» ZÃà ¸¶ÀÌ³Ê½º ¹æÇâÀ¸·Î µ¹¸° ÄõÅÍ´Ï¾ğ »ı¼º
								tQuat = offsetQuat * tQuat	-- ±âÁ¸ FBX ¹ß¸ñ °¢µµ¿¡ ¿ÀÇÁ¼Â ¾Ş±Û Àû¿ë
							)
						)
						biped.setTransform bipObj #pos fbxObj.transform.position true
						biped.setTransform bipObj #rotation tQuat true
					)
					else (
						with animate on (
							tMatrix = matrix3 1
							tMatrix.rotation = fbxObj.transform.rotation
							tMatrix.position = fbxObj.transform.position		-- rotation ´ÙÀ½¿¡ position ÀÇ ¼ø¼­°¡ Áß¿ä
							bipObj.transform = tMatrix
						)
					)
				) -- at time end
			) -- for end
			uiPBar.value = (((p as float) / (pairs.count as float)) * 100 ) as integer
		)
		
		--enableSceneRedraw()
	)
	
	-- ¼±ÅÃµÈ ¹ÙÀÌÆĞµå ÇÏ³ª¿¡ ´ëÇØ ÁöÁ¤µÈ ½Ã°£¸¸Å­ ¾Ö´Ï¸ŞÀÌ¼Ç Å°¸¦ ½ÌÅ© ÇÑ´Ù.
	function SyncKeyRangedSel frameStart frameEnd obj= (
		if ( classof rootObjBip ) == Biped_Object do (
			rootObjBip.controller.rootnode.controller.figureMode = false
			-- Separate FK Tracks¸¦ ºĞ¸®ÇØ¾ß ÆÈ²ŞÄ¡¿Í ¹«¸­ÀÌ ¾ÈÁ¤ÀûÀ¸·Î ±¸¿öÁø´Ù. ¹ÙÀÌÆĞµå´Â ÇÏ¹ÚÀÌ³ª Á¾¾Æ¸®¸¦ È¸Àü½ÃÅ³ ¶§ ºÎ¸ğ°¡ °°ÀÌ Æ²¾îÁö´Â Æ¯¼ºÀÌ ÀÖ´Âµ¥, Æ®·¢À» ºĞ¸®ÇÏ¸é µ¶ÀÚÀûÀ¸·Î Å°°¡ ¹İ¿µµÈ´Ù.
			rootObjBip.controller.sepLegsTracks = true
			rootObjBip.controller.sepArmsTracks = true
		)
		clearSelection()		-- ¹ÙÀÌÆĞµå°¡ ¼±ÅÃµÈ »óÅÂ¿¡¼­´Â at time ¹æ½Ä°ú È£È¯µÇÁö ¾Ê´Â´Ù.
		
		--disableSceneRedraw() 
		
		tIndex = FindInPairsBip obj
		for i = frameStart to frameEnd do (
			if ( obj == rootObjBip ) then (
				-- root ³ëµåÀÎ °æ¿ì
				at time (i as time) (
					if ( classof rootObjBip ) == Biped_Object then (
						biped.setTransform rootObjBip #pos rootObjFbx.transform.position true
						biped.setTransform rootObjBip #rotation  rootObjFbx.transform.rotation true
					)
					else (
						with animate on (
							tMatrix = matrix3 1
							tMatrix.rotation = rootObjFbx.transform.rotation
							tMatrix.position = rootObjFbx.transform.position		-- rotation ´ÙÀ½¿¡ position ÀÇ ¼ø¼­°¡ Áß¿ä
							rootObjBip.transform = tMatrix
						)
					)
				) -- at time end
			)
			else (
				-- ³ª¸ÓÁö ºÎÀ§ÀÎ °æ¿ì
				local bipObj = pairs[tIndex].bipObj
				local fbxObj = pairs[tIndex].fbxObj
				at time (i as time) (
					if ( classof bipObj ) == Biped_Object then (
						local tQuat = fbxObj.transform.rotation
						local bipType = GetBipedType bipObj
						-- ¿Ş¹ßÀÌ°Å³ª ¿À¸¥¹ßÀÌ°í ¸µÅ© ¹øÈ£°¡ 3¹øÀÎ FootÀÎ °æ¿ì Offset °¢µµ¸¦ ´õÇÑ´Ù.
						if (bipType.limbName == #lleg OR bipType.limbName == #rleg) do (
							if (bipType.linkIndex == 3) do (
								-- ¿©±â¼­ ´õÇÏ´Â °¢µµ´Â Figure Sync¿¡¼­ ÀÌ¹Ì °è»êµÈ °ªÀ» Àç»ç¿ëÇÏ´Â °Íµµ °ËÅäÇßÀ¸³ª, Figure Sync ¾øÀÌ Key AllÀ» ÇÏ´Â °æ¿ìµµ °í·ÁÇá¿© ¸Å ¹ø AngleÀ» °è»êÇÏ´Â ¹æ½ÄÀ¸·Î Àû¿ë
								-- ¿Ş¹ßÀ» ±âÁØÀ¸·Î ¹Ì¸® ¹ß¸ñ Offset AngleÀ» ¾ò¾îµĞ´Ù. (FBX¿Í ¹ÙÀÌÆĞµåÀÇ ¹ß¸ñ ±¸Á¶ Â÷ÀÌ º¸Á¤)
								local offsetQuat = GetBipedFootAngleQuat bipObj	-- ¹ß¸ñÀ» ZÃà ¸¶ÀÌ³Ê½º ¹æÇâÀ¸·Î µ¹¸° ÄõÅÍ´Ï¾ğ »ı¼º
								tQuat = offsetQuat * tQuat	-- ±âÁ¸ FBX ¹ß¸ñ °¢µµ¿¡ ¿ÀÇÁ¼Â ¾Ş±Û Àû¿ë
							)
						)
						biped.setTransform bipObj #pos fbxObj.transform.position true
						biped.setTransform bipObj #rotation tQuat true
					)
					else (
						with animate on (
							tMatrix = matrix3 1
							tMatrix.rotation = fbxObj.transform.rotation
							tMatrix.position = fbxObj.transform.position		-- rotation ´ÙÀ½¿¡ position ÀÇ ¼ø¼­°¡ Áß¿ä
							bipObj.transform = tMatrix
						)
					)
				) -- at time end
			)
		) -- for end
		
		--enableSceneRedraw()
	)

	-- Å°ÇÁ·¹ÀÓ »ı¼ºÇÏ±â Àü ÀüÃ¼ ¹ÙÀÌÆĞµå¿¡ ´ëÇØ ¸ÅÆ®¸¯½º ¸®¼ÂÀ» ÇÑ´Ù.
	-- ¸ÅÆ®¸¯½º ¸®¼ÂÀ» ÇÏ´Â ÀÌÀ¯ : ¿¡µğÅÍ¿¡¼­ ¼öµ¿À¸·Î Align µîÀ» ÇÏ¸é ¹ÙÀÌÆĞµåÀÇ ¸ÅÆ®¸¯½º°¡ ²¿¿©¼­ ÀÌÈÄ ½ºÅ©¸³Æ®¿¡¼­ AlignÀ» ÇØµµ Á¦´ë·Î Á¤·ÄÀÌ ¾ÈµÈ´Ù.
	-- ¾Ö´Ï¸ŞÀÌ¼Ç Å° »ı¼ºÇÏ±â Àü¿¡ ÀÏ°ı·Î ÇØ¾ßÇÏ´Â ÀÌÀ¯ : IK°¡ »ì¾ÆÀÖ´Â Limb ºÎÀ§, ¿¹¸¦ µé¾î ÇÏ¹Ú¿¡¼­ Matrix3 1 ¸¦ ÇÏ´Â ¼ø°£ »ó¹Ú¿¡ ¿µÇâÀ» ÁÖ±â¶§¹®¿¡ º»°İÀûÀ¸·Î Å°¸¦ »ı¼ºÇÏ±â Àü¿¡ ÇÑ¹ø ÈÈ¾î¾ßÇÑ´Ù.
	function ResetBipedMatrix = (
		for i = 1 to pairs.count do (
			pairs[i].bipObj.transform = Matrix3 1
		)
	)

	on uiBtnScanRoot pressed do (
		if ( objects.count == 0 ) do return ()
		
		for o in objects do (
			if ( (getUserProp o "SoxFbxToBiped_FbxRoot") == true ) do ( rootObjFbx = o )
			if ( (getUserProp o "SoxFbxToBiped_BipRoot") == true ) do ( rootObjBip = o )
		)
		
		SetList ()
	)
	
	on uiBtnFigureSync pressed do (
		-- pairs ¸¦ °èÃş±¸Á¶ ¼ø¼­´ë·Î ¸ÕÀú Á¤·ÄÇÑ´Ù.
		-- Á¤·ÄÇÏ´Â ÀÌÀ¯ : ¹ÙÀÌÆĞµå´Â °ÔÃş±¸Á¶ ¼ø¼­´ë·Î figure ¸¦ Á¶Á¤ÇØ¾ßÇÔ
		-- 3ds Max ÃÖ½Å¹öÀüÀÌ µÇ¸é¼­ ¼ÒÆÃ ÀÛµ¿ÀÌ ¸Å¿ì ´À¸®´Ù. 0.29¹öÀü±îÁö´Â ¸®½ºÆ® °»½Å½Ã¸¶´Ù ¼ÒÆÃÀ» ÇßÀ¸³ª 0.30ºÎÅÍ ¸®½ºÆ® °»½Å½Ã¿¡´Â ¼ÒÆÃÀ» ¾ÈÇÑ´Ù.
		SortByHierarchy ()
		SetList ()

		if NonBipedCheck() do return()		-- ¹ÙÀÌÆĞµå°¡ ¾Æ´Ñ ¿ÀºêÁ§Æ®¸¦ ´ë»óÀ¸·Î ÇÏ´Â ¸®½ºÆ®¿¡¼­´Â Figure Sync ±â´ÉÀÌ ÀÛµ¿ÇÏÁö ¾Ê´Â´Ù.
		
		if ( CheckMatch () == false ) do (
			messagebox "Please check list"
			return ()
		)
		
		if ( pairs.count == 0 ) do return ()
		if ( rootObjBip == undefined or rootObjFbx == undefined ) do return ()
		
		setCommandPanelTaskMode mode:#motion -- ¾ÈÀüÀ» À§ÇØ ¸ğ¼Ç ÆĞ³Î·Î º¯°æ
		select rootObjBip	-- ¹ÙÀÌÆĞµå ¼±ÅÃ »óÅÂ¿¡¼­ Ã³¸®ÇØ¾ßÇÔ
		undo on (
		tFigureSaved = rootObjBip.controller.rootnode.controller.figureMode
		rootObjBip.controller.rootnode.controller.figureMode = true
		
		biped.setTransform rootObjBip #pos rootObjFbx.transform.position false
		biped.setTransform rootObjBip #rotation  rootObjFbx.transform.rotation false
		
		for i = 1 to pairs.count do (
			local meFbx = pairs[i].fbxObj
			local meBip = pairs[i].bipObj

			-- bipType.limbName, bipType.linkIndex
			local bipType = GetBipedType meBip
			
			-- XÃà ½ºÄÉÀÏ¿¡ »ç¿ëÇÒ ÀÚ½Ä ¹ÙÀÌÆĞµå ¿ÀºêÁ§Æ® ¼±Á¤. undefined¸é ÀÚ½ÄÀÌ ¾ø´Â ³ëµåÀÓ. ÇÏÁö¸¸ nub¶§¹®¿¡ ÀÚ½ÄÀÌ ¾ø´Â ³ëµå°¡ ÁöÁ¤µÉ ÀÏÀº °ÅÀÇ ¾øÀ½. ÀÖ´Ù¸é À¯Àú ½Ç¼ö
			tChildForScale = GetChildByScalePos meBip
			tOriginalScale = biped.getTransform meBip #scale

			case of
				(
					-- Pelvis
					(bipType.limbName == #pelvis):(
						tLLeg = biped.getNode rootObjBip #lleg link:1
						tIndex = FindInPairsBip tLLeg
						if ( tIndex != 0 ) then ( tLLegFbx = pairs[tIndex].fbxObj ) else ( tLLegFbx = undefined )
						
						tRLeg = biped.getNode rootObjBip #rleg link:1
						tIndex = FindInPairsBip tRLeg
						if ( tIndex != 0 ) then ( tRLegFbx = pairs[tIndex].fbxObj ) else ( tRLegFbx = undefined )
						
						if ( tLLegFbx != undefined and tRLegFbx != undefined ) do (
							tOriginalScale = biped.getTransform meBip #scale
							tDist = distance tLLegFbx.transform.position tRLegFbx.transform.position
							meBip.transform = Matrix3 1 -- Æ®·£½ºÆû ÃÊ±âÈ­, ¸Æ½º ¿¡µğÅÍ¿¡¼­ À¯Àú¿¡ ÀÇÇØ Align µÈ º»Àº Æ®·£½ºÆûÀÌ ²¿¿©ÀÖ´Â °æ¿ì°¡ °¡²û ¹ß»ıÇÑ´Ù(´ëÇ¥ÀûÀ¸·Î ¿À¸¥ÂÊ ¼â°ñ). ÀÌ·± °æ¿ì¿¡µµ ¹®Á¦ ¾øÀÌ µÇ·Á¸é Matrix3 1 ·Î ÃÊ±âÈ­ ÇØÁÖ¸é ¾ÈÀüÇÏ´Ù.
							biped.setTransform meBip #rotation ( meFbx.transform.rotation ) false
							biped.setTransform meBip #scale [tOriginalScale.x, tOriginalScale.y, tDist ] false
						)
					) -- Pelvis end

					-- Left Foot
					(bipType.limbName == #lleg and bipType.linkIndex == 3):(
						if (meBip.parent == rootObjBip) then
						(
							tMeFbxParent = rootObjFbx
						)
						else
						(
							-- fbx Æ®¸®±¸Á¶´Â ¹ÙÀÌÆĞµå¿ÍÀÇ Ãà Á¤·ÄÀ» À§ÇØ ´ë¸®¿ë ´õ¹Ì¸¦ Á¾Á¾ »ç¿ëÇÏ±â¶§¹®¿¡ fbxÀÇ ºÎ¸ğ¸¦ Ã£±â À§ÇØ¼­´Â ¹ÙÀÌÆĞµå ºÎ¸ğ ±âÁØÀ¸·Î fbx ¸®½ºÆ®¸¦ °Ë»öÇØ¾ßÇÑ´Ù.
							tMeFbxParent = pairs[(FindInPairsBip meBip.parent)].fbxObj
						)
						
						tDeltaPosFbx = meFbx.transform.position - tMeFbxParent.transform.position
						if ( tMeFbxParent == rootObjFbx ) then (
							tBipParent = rootObjBip
						)
						else (
							tFbxParentIndex = FindInPairsFbx tMeFbxParent
							tBipParent = pairs[tFbxParentIndex].bipObj
						)
						
						tBipPos = tBipParent.transform.position + tDeltaPosFbx
						meBip.transform = Matrix3 1 -- Æ®·£½ºÆû ÃÊ±âÈ­, ¸Æ½º ¿¡µğÅÍ¿¡¼­ À¯Àú¿¡ ÀÇÇØ Align µÈ º»Àº Æ®·£½ºÆûÀÌ ²¿¿©ÀÖ´Â °æ¿ì°¡ °¡²û ¹ß»ıÇÑ´Ù(´ëÇ¥ÀûÀ¸·Î ¿À¸¥ÂÊ ¼â°ñ). ÀÌ·± °æ¿ì¿¡µµ ¹®Á¦ ¾øÀÌ µÇ·Á¸é Matrix3 1 ·Î ÃÊ±âÈ­ ÇØÁÖ¸é ¾ÈÀüÇÏ´Ù.
						biped.setTransform meBip #pos tBipPos false
						
						-- FBX´Â ¹ß¸ñÀÌ ¹ß°¡¶ôÀ» ¹Ù¶óº¸°í ¹ÙÀÌÆĞµå´Â ¹ß¸ñ°ú ¹ß°¡¶ôÀÌ ÆòÇàÇÑ ¹®Á¦°¡ ÀÖ¾î¼­ uiSpnFootHeight ³ôÀÌ°ªÀ» ±â¹İÀ¸·Î ÇÑ È¸Àü ¿ÀÇÁ¼Â ¹İ¿µ
						local offsetQuat = GetBipedFootAngleQuat meBip	-- ¹ß¸ñÀ» ZÃà ¸¶ÀÌ³Ê½º ¹æÇâÀ¸·Î µ¹¸° ÄõÅÍ´Ï¾ğ »ı¼º
						offsetQuat = offsetQuat * meFbx.transform.rotation	-- ±âÁ¸ FBX ¹ß¸ñ °¢µµ¿¡ ¿ÀÇÁ¼Â ¾Ş±Û Àû¿ë
						biped.setTransform meBip #rotation offsetQuat false
						
						tChildIndex = FindInPairsBip tChildForScale
						if ( tChildIndex != 0 ) do (
							tChildFbx = pairs[tChildIndex].fbxObj
							--tLocalDistM3 = GetLocalTransform meFbx.transform tChildFbx.transform		-- ÀÚ½ÄÀÇ ·ÎÄÃ Æ®·£½ºÆûÀ» »ç¿ëÇÏ´Â ¹æ½ÄÀº ºÀÀÎ.
							--FBX´Â ¹ßÀÌ ¹ß°¡¶ôÀ» ¹Ù¶óº¸´Âµ¥ ¹ÙÀÌÆĞµå´Â ¹ß°ú ¹ß°¡¶ôÀÌ ÆòÇàÇÏ°í ³ôÀÌ Â÷°¡ ÀÖ´Â ¹æ½ÄÀÌ´Ù. FBXÀÇ ¹ß È¸Àü°ªÀ» Á¦´ë·Î ¹İ¿µÇÏ·Á¸é ¹ß°¡¶ôÀ» ¹Ù¶óº¸´Â ¹æ½ÄÀ¸·Î ÇØ¾ß¸¸ ÇÑ´Ù. ¹Ù¶óº¸´Â ¹æ½Ä¿¡¼­´Â ÀÚ½ÄÀÇ ³ôÀÌ°ªÀÌ 0ÀÎ ¹®Á¦°¡ ¹ß»ıÇÑ´Ù.
							--±×·¡¼­ ¹ß¿¡ ´ëÇØ¼­¸¸ ¼öµ¿À¸·Î Foot Height °ªÀ» ÁöÁ¤ÇÏ¿© »ç¿ëÇÑ´Ù.
							biped.setTransform meBip #scale [uiSpnFootHeight.value, tOriginalScale.y, tOriginalScale.z ] false
						)
					) -- Left Foot end
					
					-- Right Foot
					(bipType.limbName == #rleg and bipType.linkIndex == 3):(
						if (meBip.parent == rootObjBip) then
						(
							tMeFbxParent = rootObjFbx
						)
						else
						(
							-- fbx Æ®¸®±¸Á¶´Â ¹ÙÀÌÆĞµå¿ÍÀÇ Ãà Á¤·ÄÀ» À§ÇØ ´ë¸®¿ë ´õ¹Ì¸¦ Á¾Á¾ »ç¿ëÇÏ±â¶§¹®¿¡ fbxÀÇ ºÎ¸ğ¸¦ Ã£±â À§ÇØ¼­´Â ¹ÙÀÌÆĞµå ºÎ¸ğ ±âÁØÀ¸·Î fbx ¸®½ºÆ®¸¦ °Ë»öÇØ¾ßÇÑ´Ù.
							tMeFbxParent = pairs[(FindInPairsBip meBip.parent)].fbxObj
						)
						
						tDeltaPosFbx = meFbx.transform.position - tMeFbxParent.transform.position
						if ( tMeFbxParent == rootObjFbx ) then (
							tBipParent = rootObjBip
						)
						else (
							tFbxParentIndex = FindInPairsFbx tMeFbxParent
							tBipParent = pairs[tFbxParentIndex].bipObj
						)
						
						tBipPos = tBipParent.transform.position + tDeltaPosFbx
						meBip.transform = Matrix3 1 -- Æ®·£½ºÆû ÃÊ±âÈ­, ¸Æ½º ¿¡µğÅÍ¿¡¼­ À¯Àú¿¡ ÀÇÇØ Align µÈ º»Àº Æ®·£½ºÆûÀÌ ²¿¿©ÀÖ´Â °æ¿ì°¡ °¡²û ¹ß»ıÇÑ´Ù(´ëÇ¥ÀûÀ¸·Î ¿À¸¥ÂÊ ¼â°ñ). ÀÌ·± °æ¿ì¿¡µµ ¹®Á¦ ¾øÀÌ µÇ·Á¸é Matrix3 1 ·Î ÃÊ±âÈ­ ÇØÁÖ¸é ¾ÈÀüÇÏ´Ù.
						biped.setTransform meBip #pos tBipPos false
						
						-- FBX´Â ¹ß¸ñÀÌ ¹ß°¡¶ôÀ» ¹Ù¶óº¸°í ¹ÙÀÌÆĞµå´Â ¹ß¸ñ°ú ¹ß°¡¶ôÀÌ ÆòÇàÇÑ ¹®Á¦°¡ ÀÖ¾î¼­ uiSpnFootHeight ³ôÀÌ°ªÀ» ±â¹İÀ¸·Î ÇÑ È¸Àü ¿ÀÇÁ¼Â ¹İ¿µ
						local offsetQuat = GetBipedFootAngleQuat meBip	-- ¹ß¸ñÀ» ZÃà ¸¶ÀÌ³Ê½º ¹æÇâÀ¸·Î µ¹¸° ÄõÅÍ´Ï¾ğ »ı¼º
						offsetQuat = offsetQuat * meFbx.transform.rotation	-- ±âÁ¸ FBX ¹ß¸ñ °¢µµ¿¡ ¿ÀÇÁ¼Â ¾Ş±Û Àû¿ë
						biped.setTransform meBip #rotation offsetQuat false
						
						tChildIndex = FindInPairsBip tChildForScale
						if ( tChildIndex != 0 ) do (
							tChildFbx = pairs[tChildIndex].fbxObj
							--tLocalDistM3 = GetLocalTransform meFbx.transform tChildFbx.transform		-- ÀÚ½ÄÀÇ ·ÎÄÃ Æ®·£½ºÆûÀ» »ç¿ëÇÏ´Â ¹æ½ÄÀº ºÀÀÎ.
							--FBX´Â ¹ßÀÌ ¹ß°¡¶ôÀ» ¹Ù¶óº¸´Âµ¥ ¹ÙÀÌÆĞµå´Â ¹ß°ú ¹ß°¡¶ôÀÌ ÆòÇàÇÏ°í ³ôÀÌ Â÷°¡ ÀÖ´Â ¹æ½ÄÀÌ´Ù. FBXÀÇ ¹ß È¸Àü°ªÀ» Á¦´ë·Î ¹İ¿µÇÏ·Á¸é ¹ß°¡¶ôÀ» ¹Ù¶óº¸´Â ¹æ½ÄÀ¸·Î ÇØ¾ß¸¸ ÇÑ´Ù. ¹Ù¶óº¸´Â ¹æ½Ä¿¡¼­´Â ÀÚ½ÄÀÇ ³ôÀÌ°ªÀÌ 0ÀÎ ¹®Á¦°¡ ¹ß»ıÇÑ´Ù.
							--±×·¡¼­ ¹ß¿¡ ´ëÇØ¼­¸¸ ¼öµ¿À¸·Î Foot Height °ªÀ» ÁöÁ¤ÇÏ¿© »ç¿ëÇÑ´Ù.
							biped.setTransform meBip #scale [uiSpnFootHeight.value, tOriginalScale.y, tOriginalScale.z ] false
						)
					) -- Right Foot end

					-- L R Clavicle ¹ÙÀÌÆĞµå ¼â°ñÀº figure ¸ğµå¿¡¼­ È¸ÀüÀÌ Á¦´ë·Î ÅëÁ¦µÇÁö ¾Ê´Â ¹®Á¦°¡ ÀÖ¾î¼­ standard ¸ğµå¿¡¼­ ¹æÇâÀ» Àâ°í copy posture·Î figure ¸ğµå¿¡¼­ Àû¿ë (ÁöÀúºĞÇÑ ¿ìÈ¸¹æ¹ıÀÓ)
					-- °ü·Ã Æ÷½ºÆÃ https://forums.cgsociety.org/t/clavicle-orientation-in-figure-mode-biped/1512488/3
					(bipType.limbName == #larm and bipType.linkIndex == 1 or bipType.limbName == #rarm and bipType.linkIndex == 1):(
						if (meBip.parent == rootObjBip) then
						(
							tMeFbxParent = rootObjFbx
						)
						else
						(
							-- fbx Æ®¸®±¸Á¶´Â ¹ÙÀÌÆĞµå¿ÍÀÇ Ãà Á¤·ÄÀ» À§ÇØ ´ë¸®¿ë ´õ¹Ì¸¦ Á¾Á¾ »ç¿ëÇÏ±â¶§¹®¿¡ fbxÀÇ ºÎ¸ğ¸¦ Ã£±â À§ÇØ¼­´Â ¹ÙÀÌÆĞµå ºÎ¸ğ ±âÁØÀ¸·Î fbx ¸®½ºÆ®¸¦ °Ë»öÇØ¾ßÇÑ´Ù.
							tMeFbxParent = pairs[(FindInPairsBip meBip.parent)].fbxObj
						)

						tDeltaPosFbx = meFbx.transform.position - tMeFbxParent.transform.position
						if ( tMeFbxParent == rootObjFbx ) then (
							tBipParent = rootObjBip
						)
						else (
							tFbxParentIndex = FindInPairsFbx tMeFbxParent
							-- Xtraº» µîÀ» »ç¿ëÇÒ ¶§ XtraÀÇ ºÎ¸ğ¸¦ Æ®À§½ºÆ®º»À» ºÎ¸ğ·Î »ç¿ëÇÏ´Â µî °èÃş±¸Á¶°¡ ÀÌ¾îÁöÁö ¾Ê´Â »óÈ²¿¡¼­
							-- Â¦À» Ã£Áö ¸øÇÏ°í tFbxParentIndex °ªÀÌ 0ÀÌ µÉ ¼ö ÀÖ´Ù.
							-- ±×·¯¸é ¾îÂ¿ ¼ö ¾øÀÌ ÀÛµ¿Àº ÇÏµµ·Ï meBip.parent¸¦ »ç¿ëÇÏÀÚ.
							if ( tFbxParentIndex != 0 ) then (
								tBipParent = pairs[tFbxParentIndex].bipObj
							)
							else (
								tBipParent = meBip.parent;
							)
						)
						
						tBipPos = tBipParent.transform.position + tDeltaPosFbx
						meBip.transform = Matrix3 1 -- Æ®·£½ºÆû ÃÊ±âÈ­, ¸Æ½º ¿¡µğÅÍ¿¡¼­ À¯Àú¿¡ ÀÇÇØ Align µÈ º»Àº Æ®·£½ºÆûÀÌ ²¿¿©ÀÖ´Â °æ¿ì°¡ °¡²û ¹ß»ıÇÑ´Ù(´ëÇ¥ÀûÀ¸·Î ¿À¸¥ÂÊ ¼â°ñ). ÀÌ·± °æ¿ì¿¡µµ ¹®Á¦ ¾øÀÌ µÇ·Á¸é Matrix3 1 ·Î ÃÊ±âÈ­ ÇØÁÖ¸é ¾ÈÀüÇÏ´Ù.
						biped.setTransform meBip #pos tBipPos false
						
						-- ¼â°ñ ·ÎÅ×ÀÌ¼Ç Ã³¸® ½ÃÀÛ
						rootObjBip.controller.figureMode = false -- Àá½Ã standard ¸ğµå·Î ÀüÈ¯
						biped.setTransform meBip #rotation meFbx.transform.rotation false
						local tNowBipedController = meBip.controller -- Áßº¹ »ç¿ëÇÏ´Â ÄÁÆ®·Ñ·¯¸¦ ·ÎÄÃ º¯¼ö·Î »ı¼º
						-- Äİ·º¼ÇÀÌ ¾øÀ¸¸é ÇÏ³ª ¸¸µç´Ù
						if (biped.numCopyCollections tNowBipedController == 0) do (
							biped.createCopyCollection tNowBipedController "Col01"
						)
						select meBip
						local tPostureName = biped.copyPosture tNowBipedController #posture true true true
						rootObjBip.controller.figureMode = true -- ´Ù½Ã figure ¸ğµå·Î ÀüÈ¯
						biped.pastePosture tNowBipedController #posture false tPostureName
						biped.deleteCopy tNowBipedController #posture tPostureName
						-- ¼â°ñ ·ÎÅ×ÀÌ¼Ç Ã³¸® ³¡

						tChildIndex = FindInPairsBip tChildForScale
						if ( tChildIndex != 0 ) do (
							tChildFbx = pairs[tChildIndex].fbxObj
							tDist = distance meFbx.transform.position tChildFbx.transform.position		-- ÀÚ½Ä°úÀÇ °Å¸®
							biped.setTransform meBip #scale [tDist, tOriginalScale.y, tOriginalScale.z ] false
						)
					) -- L R Clavicle end
					
					default: (
						if (meBip.parent == rootObjBip) then
						(
							tMeFbxParent = rootObjFbx
						)
						else
						(
							-- fbx Æ®¸®±¸Á¶´Â ¹ÙÀÌÆĞµå¿ÍÀÇ Ãà Á¤·ÄÀ» À§ÇØ ´ë¸®¿ë ´õ¹Ì¸¦ Á¾Á¾ »ç¿ëÇÏ±â¶§¹®¿¡ fbxÀÇ ºÎ¸ğ¸¦ Ã£±â À§ÇØ¼­´Â ¹ÙÀÌÆĞµå ºÎ¸ğ ±âÁØÀ¸·Î fbx ¸®½ºÆ®¸¦ °Ë»öÇØ¾ßÇÑ´Ù.
							local tIndex = FindInPairsBip meBip.parent
							if tIndex == 0 then
							(
								--°æ°í ¸Ş½ÃÁö¹Ú½º ºÀÀÎ, ¿¹¿ÜÃ³¸®°¡ Ãß°¡µÇ¸é¼­ °æ°í´Â ¾ø¾îµµ µÉ µí.
								--messagebox ("Warning - There are no pairs in the list that match the 'biped' you specified as parent. - " + tMeBip.parent.name)
								-- ¸®½ºÆ®¿¡ ¾ø´Â Æ®À§½ºÆ®º»ÀÇ ÀÚ½ÄÀ¸·Î ºÙÀº Xtra º»À» ¸®½ºÆ®¿¡ »ç¿ëÇÒ °æ¿ì ÀÌ·± ÀÏÀÌ »ı±æ ¼ö ÀÖ´Ù.
								-- ¿©±â¼­ Áß´ÜÇÒ ¼öµµ ¾øÀ¸´Ï ÀÚ½ÅÀÇ fbx Æä¾î¸¦ Ã£°í ±× fbxÀÇ ºÎ¸ğ¸¦ »ç¿ëÇÏÀÚ.
								tIndex = FindInPairsBip meBip -- ÇöÀç ¹ÙÀÌÆĞµåÀÇ ÀÎµ¦½º¸¦ ¾Ë¾Æ³»°í
								tMeFbxParent = pairs[tIndex].fbxObj.parent -- ÀÎµ¦½º ½ÖÀÇ fbxÀÇ ºÎ¸ğ¸¦ tMeFbxParent¿¡ ³Ö´Â´Ù.
								-- °æ°íµµ ÇßÀ¸´Ï ÀÌ·¡µµ ¾ÈµÇ´Â°Ç ³ªÁß¿¡ Á»´õ °í¹ÎÇØº¼ ºÎºĞ.
							)
							else (
								tMeFbxParent = pairs[tIndex].fbxObj
							)
						)
						
						tDeltaPosFbx = meFbx.transform.position - tMeFbxParent.transform.position
						if ( tMeFbxParent == rootObjFbx ) then (
							tBipParent = rootObjBip
						)
						else (
							tFbxParentIndex = FindInPairsFbx tMeFbxParent
							-- Xtraº» µîÀ» »ç¿ëÇÒ ¶§ XtraÀÇ ºÎ¸ğ¸¦ Æ®À§½ºÆ®º»À» ºÎ¸ğ·Î »ç¿ëÇÏ´Â µî °èÃş±¸Á¶°¡ ÀÌ¾îÁöÁö ¾Ê´Â »óÈ²¿¡¼­
							-- Â¦À» Ã£Áö ¸øÇÏ°í tFbxParentIndex °ªÀÌ 0ÀÌ µÉ ¼ö ÀÖ´Ù.
							-- ±×·¯¸é ¾îÂ¿ ¼ö ¾øÀÌ ÀÛµ¿Àº ÇÏµµ·Ï meBip.parent¸¦ »ç¿ëÇÏÀÚ.
							if ( tFbxParentIndex != 0 ) then (
								tBipParent = pairs[tFbxParentIndex].bipObj
							)
							else (
								tBipParent = meBip.parent;
							)
						)
						
						tBipPos = tBipParent.transform.position + tDeltaPosFbx
						-- ´ÙÀ½ Æ®·£½ºÆû ÃÊ±âÈ­´Â ¼â°ñÀ» ºĞ¸®ÇÏ¸é¼­ À¯ÁöÇØ¾ßÇÏ´ÂÁö Å×½ºÆ® ÇÊ¿ä
						meBip.transform = Matrix3 1 -- Æ®·£½ºÆû ÃÊ±âÈ­, ¸Æ½º ¿¡µğÅÍ¿¡¼­ À¯Àú¿¡ ÀÇÇØ Align µÈ º»Àº Æ®·£½ºÆûÀÌ ²¿¿©ÀÖ´Â °æ¿ì°¡ °¡²û ¹ß»ıÇÑ´Ù(´ëÇ¥ÀûÀ¸·Î ¿À¸¥ÂÊ ¼â°ñ). ÀÌ·± °æ¿ì¿¡µµ ¹®Á¦ ¾øÀÌ µÇ·Á¸é Matrix3 1 ·Î ÃÊ±âÈ­ ÇØÁÖ¸é ¾ÈÀüÇÏ´Ù.
						biped.setTransform meBip #pos tBipPos false
						
						biped.setTransform meBip #rotation meFbx.transform.rotation false
						
						tChildIndex = FindInPairsBip tChildForScale
						if ( tChildIndex != 0 ) do (
							tChildFbx = pairs[tChildIndex].fbxObj
							tDist = distance meFbx.transform.position tChildFbx.transform.position		-- ÀÚ½Ä°úÀÇ °Å¸®
							biped.setTransform meBip #scale [tDist, tOriginalScale.y, tOriginalScale.z ] false
						)
					) -- default end
				) -- case end
		) -- for end
		) -- undo off
		
-- 		rootObjBip.controller.figureMode = tFigureSaved -- ÀÚµ¿À¸·Î Figure¸ğµå¿¡¼­ ¿ø·¡ ÀÏ¹İ ¸ğµå·Î µÇµ¹¾Æ°¡µµ·Ï ÇÒ °æ¿ì Clevicle ¿¡¼­ ÀÌÀ¯¸¦ ¾Ë ¼ö ¾ø´Â ·ÎÅ×ÀÌ¼Ç ¿¡·¯°¡ ¹ß»ıÇØ¼­ ¹«Á¶°Ç Figure¸ğµå·Î ³¡³»µµ·Ï ÇÔ
	)
	
	on uiBtnKeyAll pressed do (
		if ( CheckMatch () == false ) do (
			messagebox "Please check list"
			return ()
		)
		if ( pairs.count == 0 ) do return ()
		if ( rootObjBip == undefined or rootObjFbx == undefined ) do return ()
		
		if ( uiRBtnKeyOption.state == 1 ) then (
			frameStart = animationRange.start as integer / TicksPerFrame
			frameEnd = animationRange.end as integer / TicksPerFrame
		)
		else (
			frameStart = slidertime as integer / TicksPerFrame
			frameEnd = slidertime as integer / TicksPerFrame
		)
		tSelBackup = selection as array
		undo on (
			ResetBipedMatrix()
			SyncKeyRangedAll frameStart frameEnd
		)
		select tSelBackup
	)
	
	on uiBtnKeySelectedOne pressed do (
		if ( CheckMatch () == false ) do (
			messagebox "Please check list"
			return ()
		)
		if ( pairs.count == 0 ) do return ()
		if ( rootObjBip == undefined or rootObjFbx == undefined ) do return ()
		
		-- ¼±ÅÃµÈ ¿ÀºêÁ§Æ®°¡ ¸®½ºÆ®¿¡ ¾øÀ¸¸é ±×³É ¸®ÅÏ
		if ( ( FindInPairsBip selection[1] ) == 0 and selection[1] != rootObjBip ) do return ()
		
		if ( uiRBtnKeyOption.state == 1 ) then (
			frameStart = animationRange.start as integer / TicksPerFrame
			frameEnd = animationRange.end as integer / TicksPerFrame
		)
		else (
			frameStart = slidertime as integer / TicksPerFrame
			frameEnd = slidertime as integer / TicksPerFrame
		)
		tSelBackup = selection as array
		undo on (
			-- ¼±ÅÃµÈ °Í ÇÏ³ª¿¡ ´ëÇØ¼­´Â Matrix3 1 À» ÇÏ¸é ¾ÈµÈ´Ù. Limb°°Àº°÷¿¡¼­ ÇÏÀ§ ÇÏ³ª¿¡¼­ ÇÏ¸é »óÀ§¿¡µµ ¿µÇâÀ» ÁØ´Ù.
			SyncKeyRangedSel frameStart frameEnd selection[1]
		)
		select tSelBackup
	)
	
	on uiBtnReset pressed do (
		pairs = #()
		rootObjFbx = undefined
		rootObjBip = undefined
		SetList ()
	)

	-- Bip001ÀÌ ¾Æ´Ñ ÀÏ¹İ ¿ÀºêÁ§Æ®¿¡¼­ ¾Ö´Ï¸ŞÀÌ¼Ç Å° ¼ıÀÚ¸¦ ¾Ë¾Æ³»´Â ÇÔ¼ö.
	-- ÀÏ¹İ ¹ÙÀÌÆĞµå¿¡¼­ keys¸¦ Á÷Á¢ ¾ò¾î¿À´Â ¹æ¹ıÀ» ¸øÃ£¾Æ¼­ count ¾ò¾î¿À´Â °ÍÀ» ¿ìÈ¸ÀûÀ¸·Î ±¸Çö.
	function GetKeyCountNonRootBiped bipObj = (
		local keyCount = 1
		local breakFlag = false
		while breakFlag == false do (
			try(biped.getKey bipObj.transform.controller keyCount) catch (
				breakFlag = true
				return (keyCount - 1)
			)
			keyCount += 1
		)
	)

	on uiBtnSetAnimRangeBySelectedObj pressed do (
		if selection.count == 0 then return()
		local tempFirst
		local tempLast
		local returnFirst = 999999f
		local returnLast = 0f
		for obj in selection do (
			if (classof obj.baseobject) == Biped_Object then (
				if obj == obj.transform.controller.rootNode then (
					-- Bip001ÀÎ °æ¿ì
					local bipRootKeys = obj.transform.controller.horizontal.controller.keys -- ÀÌ°Ç Bip001¿ë
					if bipRootKeys.count != 0 do (
						tempFirst = bipRootKeys[1].time
						tempLast = bipRootKeys[bipRootKeys.count].time
					)
				)
				else (
					-- ÀÏ¹İ ¹ÙÀÌÆĞµåÀÎ °æ¿ì
					local bipKeyCount = GetKeyCountNonRootBiped obj
					if bipKeyCount != 0 do (
						tempFirst = (biped.getKey obj.transform.controller 1).time
						tempLast = (biped.getKey obj.transform.controller bipKeyCount).time
					)
				)
			)
			else (
				-- ¹ÙÀÌÆĞµå°¡ ¾Æ´Ñ ÀÏ¹İ ¿ÀºêÁ§Æ®ÀÎ °æ¿ì
				local notError = true
				try (obj.position.controller) catch (notError = false)	-- ¿¹¿ÜÃ³¸®. ¹ÙÀÌÆĞµå Nub ´õ¹Ì°°Àº °æ¿ì ¹ÙÀÌÆĞµå Å¬·¡½ºµµ ¾Æ´Ï°í ÄÁÆ®·Ñ·¯¸¦ ¾ò¾î¿Ã ¼ö ¾øÀ½.
				if notError do
				(
					local positionKeys = obj.position.controller.keys
					local rotationKeys = obj.rotation.controller.keys
					local keys
					if (positionKeys.count > rotationKeys.count) then (
						keys = positionKeys
					)
					else (
						keys = rotationKeys
					)
					local keyCount = keys.count
					if keyCount >= 1 do (
						tempFirst = keys[1].time
						tempLast = keys[keyCount].time
					)
				)
			)
			returnFirst = amin tempFirst returnFirst
			returnLast = amax tempLast returnLast
		)
		animationRange = Interval returnFirst returnLast
	)
	
	on uiBtnDoReplace pressed do (
		strToFind = uiETxtReplaceFrom.text
		strToReplace = uiETxtReplaceTo.text
	
        undo on (
            for o in selection do(
                tStr = o.name
                tPos = findstring tStr strToFind
                if (tPos != undefined) do (
                    newStr = replace tStr tPos strToFind.count strToReplace
                    o.name = newStr
                )
            )
        ) --undo end
		
		SetList ()
	)

    on uiBtnDoAppend pressed do (
        if ( selection.count >= 3) do (
            messagebox ( "Please select only one or two objects." )
            return()
        )
        
        undo on (
            --ÇÏ³ª ¼±ÅÃÇÏ¸é ±×³É ÅØ½ºÆ®¸¸ Ãß°¡
            if ( selection.count == 1) do (
                selection[1].name += uiETxtAppend.text
            )

            --µÑ ¼±ÅÃÇÏ¸é 1¹ø ÀÌ¸§À» ±â¹İÀ¸·Î 2¹ø¿¡ ÅØ½ºÆ®¸¦ Ãß°¡ÇØÁÜ
            if ( selection.count == 2) do (
                selection[2].name = selection[1].name + uiETxtAppend.text
            )
        ) --undo end
    )

    on uiBtnDoAppendAlign pressed do (
        if ( selection.count != 2) do (
            messagebox ( "You need to select two objects." )
            return()
        )

        undo on (
            selection[2].transform = selection[1].transform
            selection[2].parent = selection[1]
            selection[2].name = selection[1].name + uiETxtAppend.text
        ) --undo end
    )

    on uiBtnDoAppendAlignedPoint pressed do (
        undo on (
            tSel = #()
            for o in selection do(
                tPoint = Point()
                tPoint.wirecolor = (color 14 255 2)
                tPoint.size = uiSpnPointSize.value
                tPoint.parent = o
                tPoint.transform = o.transform
                tPoint.name = o.name + uiETxtAppend.text
                append tSel tPoint
            )
        select tSel
        )--undo end
    )

    on uiBtnAddPositionConstraint pressed do (
        undo on (
            for o in selection do(
                o.pos.controller = Position_Constraint ()
            )
        ) -- undo end
    )

    on uiBtnAddLookatConstraint pressed do (
        undo on (
        for o in selection do(
            o.rotation.controller = LookAt_Constraint ()
        )
        ) -- undo end
    )

    on uiBtnAddOrientationConstraint pressed do (
        undo on (
        for o in selection do(
            o.rotation.controller = Orientation_Constraint ()
        )
        ) -- undo end
    )
	
	on uiBtnSetRootFbx pressed do (
		if selection[1] == undefined do return ()
		if ( classof selection[1] == Biped_Object ) do (
			messagebox ( "Please select NON Biped Object" )
			return ()
		)
		
		if ( rootObjFbx == selection[1] ) do return ()
		
		uiLabelRootFbx.text = selection[1].name
		rootObjFbx = selection[1]
		
		-- Root ¿ÀºêÁ§Æ®°¡ º¯°æµÇ¾úÀ¸¸é ³ª¸ÓÁö FBX ¿ÀºêÁ§Æ®µéÀº »õ·Î ±¸¼ºÇØ¾ßÇÔ. ¸ğµÎ ³¯·Á¹ö¸°´Ù.
		if ( pairs.count > 0 ) do (
			for o = 1 to pairs.count do (
				pairs[o].fbxObj = undefined
			)
		)
		
		-- À¯Àú ÇÁ·ÎÆÛÆ¼¿¡ ·çÆ® ³ëµå¶ó´Â Ç¥½Ã¸¦ ÇÑ´Ù.
		SetUserPropFbxRoot selection[1]
		
		if uiCBoxAutoHide.state do (
			hide selection[1]
			clearSelection()
		)
		
		SetList ()
	)
	
	on uiBtnSetRootBip pressed do (
		if selection[1] == undefined do return ()
		if ( classof selection[1] != Biped_Object and uiCBoxNonBipedMode.state == false ) do (
			messagebox ( "Please select Biped Object" )
			return ()
		)
		
		if ( rootObjBip == selection[1] ) do return ()
		
		uiLabelRootBip.text = selection[1].name
		rootObjBip = selection[1]
		
		-- Root ¿ÀºêÁ§Æ®°¡ º¯°æµÇ¾úÀ¸¸é ³ª¸ÓÁö Bip ¿ÀºêÁ§Æ®µéÀº »õ·Î ±¸¼ºÇØ¾ßÇÔ. ¸ğµÎ ³¯·Á¹ö¸°´Ù.
		if ( pairs.count > 0 ) do (
			for o = 1 to pairs.count do (
				pairs[o].bipObj = undefined
			)
		)
		
		-- À¯Àú ÇÁ·ÎÆÛÆ¼¿¡ ·çÆ® ³ëµå¶ó´Â Ç¥½Ã¸¦ ÇÑ´Ù.
		SetUserPropBipRoot selection[1]
		
		if uiCBoxAutoHide.state do (
			hide selection[1]
			clearSelection()
		)
		
		SetList ()
	)
	
	on uiLBoxFbxBip selected arg do (
		SetBipInfo ()
	)
	
	on uiLBoxFbxBip doubleClicked arg do (
		if ( pairs.count == 0 ) do return ()
		
		objs = #()
		if ( pairs[arg].fbxObj != undefined ) do append objs pairs[arg].fbxObj
		if ( pairs[arg].bipObj != undefined ) do append objs pairs[arg].bipObj
		select objs
	)
	
	on uiBtnSelectFbxRoot pressed do (
		if ( rootObjFbx != undefined ) do ( select rootObjFbx )
	)
	
	on uiBtnSelectBipRoot pressed do (
		if ( rootObjBip != undefined ) do ( select rootObjBip )
	)
	
	on uiBtnSelectFbx pressed do (
		if ( uiLBoxFbxBip.selection == 0 ) do return ()
		try ( select pairs[uiLBoxFbxBip.selection].fbxObj ) catch ()
	)
	on uiBtnSelectFbxAll pressed do (
		if ( pairs.count == 0 ) do return ()
		objs = #()
		for o in pairs do (
			if ( o.fbxObj != undefined ) do ( append objs o.fbxObj )
		)
		if ( rootObjFbx != undefined ) do ( append objs rootObjFbx )
		
		if ( objs.count != 0 ) do ( select objs )
	)
	on uiBtnSelectBip pressed do (
		if ( uiLBoxFbxBip.selection == 0 ) do return ()
		try ( select pairs[uiLBoxFbxBip.selection].bipObj ) catch ()
	)
	on uiBtnSelectBipAll pressed do (
		if ( pairs.count == 0 ) do return ()
		objs = #()
		for o in pairs do (
			if ( o.bipObj != undefined ) do ( append objs o.bipObj )
		)
		
		if ( rootObjBip != undefined ) do ( append objs rootObjBip )
		
		if ( objs.count != 0 ) do ( select objs )
	)
	
	on uiBtnLoad pressed do
	(
		if ( rootObjFbx == undefined or rootObjBip == undefined ) do (
			messagebox "You must Get root objects tempFirst"
			return ()
		)
		
		sftbFile = (getOpenFileName caption:"Select sftb file" types:"SOX Fbx to Biped (*.sftb)|*.sftb|All (*.*)|*.*|") as string
		if sftbFile == "undefined" do return ()
		if (CheckFileExt sftbFile) == false do (messagebox "*.sftb È®ÀåÀÚ¸¸ Áö¿øÇÕ´Ï´Ù"; return())
		
		openStream = openFile sftbFile mode:#rt
		
		pairs = #()
		pairsIndex = 0
		
		if ( uiRBtnLoadingType.state == 2 ) then (
			-- Handle ¹øÈ£·Î ºÒ·¯¿À´Â ¹æ½Ä
			while (eof openStream) != true do
			(
				tempKeyword = readDelimitedString openStream "="	-- "=" µô¸®¹ÌÅÍ¸¦ ¸¸³¯ ¶§±îÁö ½ºÆ®¸² ÀĞ¾îµéÀÓ
				tempKeyword = trimLeft tempKeyword -- ¾ÈÀüÀ» À§ÇØ ¾ÕµÚ °ø¹éÀ» ¾ø¾Ø´Ù
				tempKeyword = trimRight tempKeyword -- ¾ÈÀüÀ» À§ÇØ ¾ÕµÚ °ø¹éÀ» ¾ø¾Ø´Ù
				
				case of
				(
					(tempKeyword == "FootHeight"):(
						tempValue = readDelimitedString openStream "\n"	-- ¸®ÅÏ µô¸®¹ÌÅÍ¸¦ ¸¸³¯ ¶§±îÁö ½ºÆ®¸² ÀĞ¾îµéÀÓ
						uiSpnFootHeight.value = execute tempValue	-- ½ºÆ®¸µÀ¸·ÎºÎÅÍ ³ôÀÌ°ª ¾ò¾î³»¼­ ui¿¡ Àû¿ë
					)

					(tempKeyword == "FbxObjHandle"):(
						append pairs (pairdef ()) ; pairsIndex += 1	-- pairs ¹è¿­¿¡ Ãß°¡
						tempValue = readDelimitedString openStream "\n"	-- ¸®ÅÏ µô¸®¹ÌÅÍ¸¦ ¸¸³¯ ¶§±îÁö ½ºÆ®¸² ÀĞ¾îµéÀÓ
						tHandle = execute tempValue
						tHandleObj = try ( maxOps.getNodeByHandle tHandle ) catch (undefined)
						pairs[pairsIndex].fbxObj = undefined
						
						--if ( tHandle != undefined  and (IfChild rootObjFbx tHandleObj) ) do (
						if ( tHandle != undefined  ) do (
							pairs[pairsIndex].fbxObj = tHandleObj
						)
					)
					
					(tempKeyword == "BipObjHandle"):(
						tempValue = readDelimitedString openStream "\n"
						tHandle = execute tempValue
						tHandleObj = try ( maxOps.getNodeByHandle tHandle ) catch (undefined)
						pairs[pairsIndex].bipObj = undefined
						if ( tHandle != undefined and (IfChild rootObjBip tHandleObj) ) do (
							pairs[pairsIndex].bipObj = tHandleObj
						)
					)
					
					default: (readDelimitedString openStream "\n")
				)
			)
		)
		else (
			-- NameÀ¸·Î ºÒ·¯¿À´Â ¹æ½Ä
			while (eof openStream) != true do
			(
				tempKeyword = readDelimitedString openStream "="
				tempKeyword = trimLeft tempKeyword -- ¾ÈÀüÀ» À§ÇØ ¾ÕµÚ °ø¹éÀ» ¾ø¾Ø´Ù
				tempKeyword = trimRight tempKeyword -- ¾ÈÀüÀ» À§ÇØ ¾ÕµÚ °ø¹éÀ» ¾ø¾Ø´Ù
				
				case of
				(
					(tempKeyword == "FootHeight"):(
						tempValue = readDelimitedString openStream "\n"	-- ¸®ÅÏ µô¸®¹ÌÅÍ¸¦ ¸¸³¯ ¶§±îÁö ½ºÆ®¸² ÀĞ¾îµéÀÓ
						uiSpnFootHeight.value = execute tempValue	-- ½ºÆ®¸µÀ¸·ÎºÎÅÍ ³ôÀÌ°ª ¾ò¾î³»¼­ ui¿¡ Àû¿ë
					)
					
					(tempKeyword == "FbxObjName"):(
						append pairs (pairdef ()) ; pairsIndex += 1
						tempValue = readDelimitedString openStream "\n"
						tempValue = trimLeft tempValue -- ¾ÈÀüÀ» À§ÇØ ¾ÕµÚ °ø¹éÀ» ¾ø¾Ø´Ù
						tempValue = trimRight tempValue -- ¾ÈÀüÀ» À§ÇØ ¾ÕµÚ °ø¹éÀ» ¾ø¾Ø´Ù
						tObjs = GetObjsByName tempValue
						pairs[pairsIndex].fbxObj = undefined
						if ( tObjs.count != 0 ) do (
							for o in tObjs do (
								--if ( IfChild rootObjFbx o ) do ( pairs[pairsIndex].fbxObj = o )
								pairs[pairsIndex].fbxObj = o
							)
						)
					)
					
					(tempKeyword == "BipObjName"):(
						tempValue = readDelimitedString openStream "\n"
						tObj = getNodeByName tempValue
						tempValue = trimLeft tempValue -- ¾ÈÀüÀ» À§ÇØ ¾ÕµÚ °ø¹éÀ» ¾ø¾Ø´Ù
						tempValue = trimRight tempValue -- ¾ÈÀüÀ» À§ÇØ ¾ÕµÚ °ø¹éÀ» ¾ø¾Ø´Ù
						tObjs = GetObjsByName tempValue
						pairs[pairsIndex].bipObj = undefined
						if ( tObjs.count != 0 ) do (
							for o in tObjs do (
								--if ( IfChild rootObjBip o ) do ( pairs[pairsIndex].bipObj = o )
								pairs[pairsIndex].bipObj = o
							)
						)
					)
					
					default: (readDelimitedString openStream "\n")
				)
			)
		)
		SetList ()
		
		close openStream
	)
	
	on uiBtnSaveAs pressed do ( 
		file = (getSaveFileName caption:"Save sftb file" types:"Sox Fbx to Biped (*.sftb)|*.sftb|All (*.*)|*.*|")

		-- ÀúÀå Àü °èÃş±¸Á¶ ±âÁØÀ¸·Î ¼ÒÆÃ ¼öÇà (·¢ÀÌ °É¸®´Â ÀÛ¾÷ÀÓ)
		SortByHierarchy ()
		SetList ()

		try (
			if (file != undefined) and (ss = createFile file) != undefined do
			(
			format "%" (SetFileStream() as string) to:ss

			flush ss
			close ss
			true
			)
		) catch ( messagebox "File Access Error" )
	)
	
	on uiBtnListAdd pressed do (
		append pairs (pairDef ())
		uiLBoxFbxBip.selection = pairs.count
		SetList ()
	)
	
	on uiBtnListDel pressed do (
		if ( pairs.count == 0 ) do return ()
		if ( uiLBoxFbxBip.selection == 0 ) do return ()
		deleteItem pairs uiLBoxFbxBip.selection
		SetList ()
	)

    on uiBtnListHide pressed do (
        if ( pairs.count == 0 ) do return ()
		local selIndex = uiLBoxFbxBip.selection

		objs = #()
		if ( pairs[selIndex].fbxObj != undefined ) do append objs pairs[selIndex].fbxObj
		if ( pairs[selIndex].bipObj != undefined ) do append objs pairs[selIndex].bipObj
		hide objs
    )

    on uiBtnListUnHide pressed do (
        if ( pairs.count == 0 ) do return ()
        local selIndex = uiLBoxFbxBip.selection
		
		objs = #()
		if ( pairs[selIndex].fbxObj != undefined ) do append objs pairs[selIndex].fbxObj
		if ( pairs[selIndex].bipObj != undefined ) do append objs pairs[selIndex].bipObj
		unhide objs
    )
	
	-- ÇöÀç ¼±ÅÃµÈ ¿ÀºêÁ§Æ®¸¦ FBX ¸®Æ®½º¿¡ Ãß°¡
	on uiBtnSetFbx pressed do (
		if ( uiLBoxFbxBip.selection == 0 ) do return ()
		if ( classof selection[1] == Biped_Object ) do (
			messagebox ( "Please select NON Biped Object" )
			return ()
		)
		
		/*
		-- FBX´Â °èÃş±¸Á¶ÀÇ ÀÚÀ¯µµ¸¦ À§ÇØ¼­ °°Àº °èÃş±¸Á¶¿¡ ÀÖ´ÂÁö °Ë»ç¸¦ »ı·«ÇÔ
		if ( IfChild rootObjFbx selection[1] ) == false do (
			messagebox "It must exist in same hierarchy"
			return ()
		)
		*/
		
		
		tPos = FindInPairsFbx (selection[1])
		if ( tPos > 0 ) do (
			-- ÇöÀç ¼±ÅÃµÈ ¿ÀºêÁ§Æ® ÀÌ¸§ÀÌ ±âÁ¸¿¡ ÀÌ¹Ì Á¸ÀçÇÑ´Ù¸é
			-- ±âÁ¸¿¡ Á¸ÀçÇÏ´Â ¿ÀºêÁ§Æ® ¿¬°áÀ» ÀÏ´Ü ÇØÁ¦
			pairs[tPos].fbxObj = undefined
		)

		pairs[uiLBoxFbxBip.selection].fbxObj = selection[1]
		
		if uiCBoxAutoHide.state then (
			hide selection[1]
			clearSelection()
			SetList ()
		)
		else (
			SetList ()
			CallbackSyncSel ()
		)
	)
	on uiBtnClearFbx pressed do (
		if ( uiLBoxFbxBip.selection == 0 ) do return ()
		if ( pairs.count == 0 ) do return ()
		pairs[uiLBoxFbxBip.selection].fbxObj = undefined
		SetList ()
	)
	
	-- ÇöÀç ¼±ÅÃµÈ ¿ÀºêÁ§Æ®¸¦ Bip ¸®Æ®½º¿¡ Ãß°¡
	on uiBtnSetBip pressed do (
		if ( uiLBoxFbxBip.selection == 0 ) do return ()
		if ( classof selection[1] != Biped_Object and uiCBoxNonBipedMode.state == false ) do (
			messagebox ( "Please select Biped Object" )
			return ()
		)
		if ( IfChild rootObjBip selection[1] ) == false do (
			messagebox "It must exist in same hierarchy"
			return ()
		)
		
		tPos = FindInPairsBip (selection[1])
		if ( tPos > 0 ) do (
			-- ÇöÀç ¼±ÅÃµÈ ¿ÀºêÁ§Æ® ÀÌ¸§ÀÌ ±âÁ¸¿¡ ÀÌ¹Ì Á¸ÀçÇÑ´Ù¸é
			-- ±âÁ¸¿¡ Á¸ÀçÇÏ´Â ¿ÀºêÁ§Æ® ¿¬°áÀ» ÀÏ´Ü ÇØÁ¦
			pairs[tPos].bipObj = undefined
		)

		pairs[uiLBoxFbxBip.selection].bipObj = selection[1]
		
		if uiCBoxAutoHide.state then ( 
			hide selection[1]
			clearSelection()
			SetList ()
		)
		else (
			SetList ()
			CallbackSyncSel ()
		)
	)
	
	on uiBtnClearBip pressed do (
		if ( uiLBoxFbxBip.selection == 0 ) do return ()
		if ( pairs.count == 0 ) do return ()
		pairs[uiLBoxFbxBip.selection].bipObj = undefined
		SetList ()
	)
	
	on SoxFbxToBiped open do (
        callbacks.addScript #selectionSetChanged "SoxFbxToBiped.CallbackSyncSel ()" id:#SFTBSelect
        -- ¿ÀÇÂ Á÷ÈÄ Scan Root ¼öÇàÇÏ´Â ÀÛ¾÷Àº ¸®½ºÆ®¸¦ ºñ¿ì°ÔµÇ°í ¿ÀÈ÷·Á ºÒÆíÇØ¼­ ºÀÀÎ.
		callbacks.addScript #filePostOpen "SoxFbxToBiped.uiBtnReset.pressed();SoxFbxToBiped.uiBtnScanRoot.pressed()" id:#SFTBOpen
        callbacks.addScript #systemPostNew "SoxFbxToBiped.uiBtnReset.pressed();SoxFbxToBiped.uiBtnScanRoot.pressed()" id:#SFTBNew
        callbacks.addScript #systemPostReset "SoxFbxToBiped.uiBtnReset.pressed();SoxFbxToBiped.uiBtnScanRoot.pressed()" id:#SFTBReset
    
        rootObjFbx = undefined
        rootObjBip = undefined
    
-- 			uiSpnThickHor.value	= 0.5
-- 			uiSpnThickVer.value	= 0.4

        uiBtnScanRoot.pressed()
        SetList ()

        uiETxtAppend.text = "_proxy"
    )
	
	on SoxFbxToBiped close do (
        callbacks.removeScripts id:#SFTBSelect
        callbacks.removeScripts id:#SFTBOpen
        callbacks.removeScripts id:#SFTBNew
        callbacks.removeScripts id:#SFTBReset
	)
	
	on uiBtnAbout pressed do
	(
		shellLaunch "http://cafe.naver.com/pinksox/6064" ""
	)
	
)

createDialog SoxFbxToBiped style:#(#style_titlebar, #style_toolwindow, #style_sysmenu) lockWidth:true