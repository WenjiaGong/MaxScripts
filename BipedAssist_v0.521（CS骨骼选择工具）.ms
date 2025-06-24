-- 만든이 : 이상원
-- 사용 및 수정은 자유입니다. 하지만 재 배포는 금지합니다.

global SBA		-- 롤아웃명을 글로벌 변수로 인식하기 위해 초기에 한 번 사용
global SBAFingers
--global SBAToes
global SBAKeyframe
global SBAAnimation

-- Tools 롤아웃이 부모와 붙어다니도록 SoxBipedAssist의 이전 위치를 기억하는 변수
global SBAPosBefore
global SBAFingersPosBefore
--global SBAToesPosBefore 발가락 기능 보류
global SBAKeyframePosBefore
global SBAAnimationPosBefore

try (destroydialog SBA) catch()		-- 혹시 열려있는 창이 있으면 강제 종료

rollout SBA "Sox BipedAssist v0.521" (
	local mc_setKeyColor = color 140 0 0
	local mc_spineColor = color 8 110 134
	local mc_greenColor = color 6 134 6
	local mc_blueColor = color 80 80 230
	local mc_multipleColor = color 16 189 194
	
	checkButton uiChkBtnScanBiped "Scan" width:36 checked:true highlightColor:(color 255 20 140) offset:[-20, 0] tooltip:"Cache biped selection for faster operation. If the configuration of the Biped changes, scan again. If you have multiple bipeds, scan the selected ones. (Kor) 바이패드 선택을 캐싱 해서 빠르게 작동할 수 있게 합니다. 바이패드의 구성이 변경되면 다시 스캔하세요. 바이패드가 여러개라면 선택된 것을 스캔합니다." across:2
	button uiAbout "About" width:38 offset:[22, 0]
	
	checkButton uiHead "o  o" width: 36 height:30 checked:true highlightColor:(color 55 137 221) offset:[0, -20]
	checkButton uiNecks "" width: 20 height:18 checked:true highlightColor:mc_spineColor align:#center offset:[0, -4]
	
	checkButton uiRArms "Arms" checked:true highlightColor:mc_multipleColor width:34 align:#left offset:[-8, -30] across:2
	checkButton uiLArms "Arms" checked:true highlightColor:mc_multipleColor width:34 align:#right offset:[8, -30]
	
	checkButton uiRClavicle "" width:26 height:14 checked:true highlightColor:mc_greenColor  offset:[0, 0] across:2
	checkButton uiLClavicle "" width:26 height:14 checked:true highlightColor:mc_blueColor  offset:[0, 0]
	
	checkButton uiAllSpine height:61 width:18 checked:true highlightColor:mc_spineColor offset:[-12, -18] align:#center tooltip:"All Spine"
	checkButton uiSpine3 "" width:24 height:16 checked:true highlightColor:mc_spineColor align:#center offset:[8, -66]
	checkButton uiSpine2 "" width:24 height:16 checked:true highlightColor:mc_spineColor align:#center offset:[8, -6]
	checkButton uiSpine1 "" width:24 height:16 checked:true highlightColor:mc_spineColor align:#center offset:[8, -6]
	checkButton uiSpine0 "" width:24 height:16 checked:true highlightColor:mc_spineColor align:#center offset:[8, -6]
	
	checkButton uiCOM "" checked:true width:42 height:20 highlightColor:(color 55 137 221) offset:[0, -4]
	checkButton uiPelvis "Pelvis" height:14 checked:true highlightColor:(color 161 134 25) width:44 height:18 offset:[0, -4]
	
	checkButton uiRUpArm "" width:20  height:20 checked:true highlightColor:mc_greenColor offset:[-6, -89] across:2
	checkButton uiLUpArm "" width:20  height:20 checked:true highlightColor:mc_blueColor offset:[6, -89]
	checkButton uiRForArm "" width:20  height:20 checked:true highlightColor:mc_greenColor offset:[-6, -6] across:2
	checkButton uiLForArm "" width:20  height:20 checked:true highlightColor:mc_blueColor offset:[6, -6]
	checkButton uiRHand "" width:20  height:20 checked:true highlightColor:mc_greenColor offset:[-12, -4] across:2
	checkButton uiLHand "" width:20  height:20 checked:true highlightColor:mc_blueColor offset:[12, -4]
	
	checkButton uiRThigh "" width:24  height:24 align:#right checked:true highlightColor:mc_greenColor offset:[-4, 20] across:2
	checkButton uiLThigh "" width:24 height:24 align:#left checked:true highlightColor:mc_blueColor offset:[4, 20]
	checkButton uiRCalf "" width:24  height:24 checked:true highlightColor:mc_greenColor align:#right  offset:[-4, -4] across:2
	checkButton uiLCalf "" width:24  height:24 checked:true highlightColor:mc_blueColor align:#left offset:[4, -4]
	checkButton uiRFoot "" width:30  height:20 checked:true highlightColor:mc_greenColor align:#right offset:[-4, -4] width:43 height:25 across:2
	checkButton uiLFoot "" width:30  height:20 checked:true highlightColor:mc_blueColor align:#left offset:[4, -4] width:43 height:25
	
	checkButton uiRLegs "Legs" checked:true highlightColor:mc_multipleColor width:30 align:#left offset:[-4, -70] across:2
	checkButton uiLLegs "Legs" checked:true highlightColor:mc_multipleColor width:30 align:#right offset:[4, -70]
	
	checkButton uiRToe "toe" checked:true highlightColor:mc_greenColor width:25 height:18 align:#left offset:[-3, 22] across:2
	checkButton uiLToe "toe" checked:true highlightColor:mc_blueColor width:25 height:18 align:#right offset:[3, 22]
	
	checkButton uiAllBip "All Biped" width:50 align:#left checked:true highlightColor:mc_multipleColor offset:[-6, 0] align:#center across:2
	checkButton uiFeet "Feet" width:40 checked:true highlightColor:mc_multipleColor align:#center  offset:[-34, 0]
	-- 발가락 기능 보류
	--Button uiBtnToesWindow "Toess" width:46 align:#right offset:[8, 0] tooltip:"Open the Toes Controls window."
		
	group "Tools" (
		Button uiBtnFingersWindow "Fingers" offset:[0, 0] tooltip:"Open the Fingers Controls window." across:3
		Button uiBtnKeyframeWindow "Key." offset:[0, 0] tooltip:"Open the Keyframe Assist window."
		Button uiBtnAnimationWindow "Anim." offset:[0, 0] tooltip:"Open the Animation window."
	)

	--button uiBtnTest "Test"

	/*
	group "Hide / Unhide"
	(
		button uiBtnHideSel "Hide sel." across:2
		button uiBtnUnhideSel "Unhide sel."
	)
	*/

	-- 수동 UI UnDo 버퍼. 첫 번째 배열에 UI 오브젝트를 담고, 두 번째 배열에 UI 값을 담는다.
	-- spinner나 slider 등 buttondown과 buttonup 이벤트가 있는 경우에만 사용
	local m_UIUnDoArr = #()
	local mc_UIUnDoCount = 100 -- 맥스 디폴트 UnDo 카운트가 100

    local m_workingBipRoot -- 현재 작업중인 바이패드의 루트 노드
    
	-- 시인성을 위해 예외적으로 m_ 뒤에 대문자 사용
	-- 모든 부위 변수들은 배열
	local m_Head
	local m_RArms; local m_LArms; local m_Necks
	local m_RClavicle; local m_LClavicle
	local m_RUpArm; local m_LUpArm
	local m_AllSpine
	local m_Spine3;	local m_Spine2; local m_Spine1; local m_Spine0
	local m_RForArm; local m_LForArm
	local m_RHand; local m_LHand
	local m_COM
	local m_Pelvis
	local m_RThigh; local m_LThigh
	local m_RCalf; local m_LCalf
	local m_RFoot; local m_LFoot
	local m_RToe; local m_LToe
	local m_RLegs; local m_LLegs; local m_AllFoot
	local m_AllBip
    
	struct BipType
	(
		limbName,
		linkIndex
    )

	/*
	<< UnDo 관련 기록 >>
	로컬 변수나 함수는 모두 중앙제어
	현재 UnDo는 간단히 구현한 것인데 복잡한 사정이 있음.
	현재는 손가락 포스쳐 스피너에서 값을 직접 숫자로 입력할 경우 UnDo가 정상 작동하지 않음.
	이유는 맥스 스크립트의 이벤트 구조때문인데
	스피너나 슬라이더 작동 구조상 여러 번 이벤트가 발생하는데 맥스 자체의 UnDo는 이벤트만큼 UnDo 히스토리가 발생함.
	이 문제를 피하려면 자체적으로 UnDo를 수동 구현해야하는데
	이전 상황으로 되돌아가려면 방금 변경된 값이 어떤 UI 요소인지, 이전에 변경한 값은 어떤 손가락인지, 현재 단계와 이전 단계의 대상이 달라질 수 있으므로
	단순하고 안정적인 구조를 만들려면 메모리를 많이 쓰더라도 수동 UnDo에 관련된 UI 오브젝트와 손가락 오브젝트, 회전값들을 모두 스냅샷으로 관리해야함.
	그래서 간단히 임시 구현한 것으로 일단 적용함.
	참고: buttonup과 entered의 관계도 복잡함. entered는 buttonup을 포함하는 이벤트인데 inSpin_arg로 직접 입력인지 마우스 드래그인지를 구분하고, inCancel_arg로 마우스 우클릭 변화인지를 구분한다.
	*/

	-- UI 값 수동 UnDo를 위해 UI가 눌리는 순간 원래 UI 오브젝트와 값을 기억하는 함수
	-- Apply는 #sceneUndo 콜백 함수에서 처리 예정
	function StoreUIUnDo uiObj = (
		-- UI UnDo 최대 숫자인 경우 가장 처음 것을 지운다.
		if (m_UIUnDoArr.count >= mc_UIUnDoCount) do (
			deleteItem m_UIUnDoArr 1
		)
		local tArr = #(uiObj, uiObj.value)
		append m_UIUnDoArr tArr
	)

	-- UnDo 콜백
	function UIUnDoCallBack = (
		-- 손가락 수동 UI UnDo 콜백
		if (m_UIUnDoArr.count >= 1) do (
			-- SBAFingers 롤아웃용 UI도 잘 작동하는지 테스트 필요. 창이 닫아진 상태에도 작동하는지.
			m_UIUnDoArr[m_UIUnDoArr.count][1].value = m_UIUnDoArr[m_UIUnDoArr.count][2]
			deleteItem m_UIUnDoArr m_UIUnDoArr.count
		)
	)

	-- 바이패드 COM인지 검사
	function IfBipRoot obj = (
		if ((classof obj.baseobject) == Biped_Object) do (
			if (obj.controller.rootNode == obj) do (return true)
		)
		return false
	)

	-- 리턴 스트럭쳐의 멤버 : limbName, linkIndex
	function GetBipedType obj = (
		if ( obj == undefined ) do return undefined
		if ( (classof obj.baseobject) != Biped_Object ) do return (bipType limbName:#nonBiped linkIndex:0)
		
		-- biped.maxNumLinks $ 이 방법으로 바이패드의 최대 링크 수를 알아낼 수 있다. 보통 25이지만 넉넉하게 30
		loopCount = 30
		types = #(
			#larm,#rarm,
			#lfingers,#rfingers,
			#lleg,#rleg,
			#ltoes,#rtoes,
			#spine,
			#tail,
			#head,
			#pelvis,
			#vertical,#horizontal,#turn,
			#footprints,
			#neck,
			#pony1,#pony2,
			#prop1,#prop2,#prop3,
			#lfArmTwist,#rfArmTwist,#lUparmTwist,#rUparmTwist,#lThighTwist,#rThighTwist,#lCalfTwist,#rCalfTwist,#lHorseTwist,#rHorseTwist			
		)
		
		for o in types do (
			for p = 1 to loopCount do (
				if ( try ( obj == biped.getNode obj o link:p ) catch false ) do (
					returnType = (bipType limbName:o linkIndex:p)
					return returnType
				)
			)
		)
		
		-- 바이패드 클래스인데 정체를 알아내지 못한건 모두 Xtra로 정의
		-- https://forums.cgsociety.org/t/biped-xtra-maxscript-commands/1570351/5 숨겨진 바이패드 Xtra 함수들을 좀 살펴봐야할듯.
        -- biped.getXtraName $ 이걸 하면 엑스트라 루트는 이름을 리턴하고 엑스트라 루트가 아니면 false 리턴.
        -- 그러나 문제는 엑스트라 링크 1 이상부터는 에러 발생함. 에러 발생하는걸 이용해서 try로 0과 1 이상 인덱스를 찾는 방법도 가능할 듯. 아무튼 보류
		return (bipType limbName:#xtra linkIndex:0)
	)
	
	-- 현재 오브젝트가 애니메이션 키 지정이 가능한 바이패드인지를 검사 true 와 false 리턴
	function IfKeyableBip obj =
	(
		if ( classof obj.baseobject != Biped_object ) do return false
		
		tType = GetBipedType obj
		
		returnBool = case tType.limbName of (
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
	
	-- 바이패드 부위들 중 Limb, COM, NoKey, Etc 를 구분하여 리턴 (애니메이션 키 복제 방식이 다름)
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

	-- 바이패드 Limb 전용 기능을 위해 Limb 인지 체크하는 함수
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
	
    function DeselectAllKeys obj = (
		-- 처음엔 복잡한 방법으로 일일이 키 하나씩 루프 돌아가며 선택 해제했는데, 뭉뚱그려서 controller 로 하니 잘 되는듯
		deselectKeys obj.controller
	)
	
	-- 이 함수는 삭제 전 Deselect 는 고려하지 않음. (기존에 Deselect 되어서 진입한 것을 전제로 함)
	function TrimKeys controller frameStart frameEnd ifBip = (
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
			-- 보존 구간보다 앞쪽에 키가 있는 경우
			selectKeys controller (interval firstKeyTime (frameStart - 1))
		)
		if (lastKeyTime > frameEnd) do (
			-- 보존 구간보다 뒤쪽에 키가 있는 경우
			selectKeys controller (interval lastKeyTime (frameEnd + 1))
		)

		if (ifBip) then (
			biped.deleteKeys controller #selection
		)
		else (
			deleteKeys controller #selection
		)
	)

    -- obj 의 모든 자식들을 배열로 리턴. 배열 순서는 계층구조 순서대로
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
	
    function SetComBtnText state = (
        if state then (
            uiCOM.text = m_workingBipRoot.name
        )
        else (
            uiCOM.text = "COM"
        )
    )

    function SetButtonStateSBA state = (
        uiHead.state = state
        uiNecks.state = state
        uiRArms.state = state; uiLArms.state = state
        uiRClavicle.state = state; uiLClavicle.state = state
        uiRUpArm.state = state; uiLUpArm.state = state
		uiAllSpine.state = state
		uiSpine3.state = state; uiSpine2.state = state; uiSpine1.state = state; uiSpine0.state = state
        uiRForArm.state = state; uiLForArm.state = state
        uiRHand.state = state; uiLHand.state = state
        uiCOM.state = state
        if state == false do uiCOM.text = "COM"
        uiPelvis.state = state
        uiRThigh.state = state; uiLThigh.state = state
        uiRCalf.state = state; uiLCalf.state = state
        uiRFoot.state = state; uiLFoot.state = state
		uiRToe.state = state; uiLToe.state = state
        uiRLegs.state = state; uiLLegs.state = state
        uiFeet.state = state
		uiAllBip.state = state
		SBAAnimation.uiPlayBlock.state = state
    )
	
	-- 씬 내 바이패드 오브젝트를 모두 조사하여 바이패드가 하나만 있으면 그 바이패드를 m_workingBipRoot에 세팅.
	-- 현재 선택된 오브젝트가 바이패드면 그것을 세팅
	-- 선택이 성공하면 true, 실패하면 false 리턴
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
        m_workingBipRoot = undefined -- 씬을 새로 오픈한다거나 하면 삭제된 오브젝트를 기억하고 있을 수 있어서 (undefined 아님) 반드시 undefined 로 초기화해줘야함.
        SetComBtnText false
        SetButtonStateSBA false
		return false
	)

	-- 배열 빼기
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
	
	-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
    -- selBackup 은 selection as array
	function CompSelect selBackup selArr = (
		-- 단축키 조합이 아무것도 눌러져있지 않으면 빠르게 그냥 선택 후 리턴
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

	-- 바이패드 배열이 정상적인지 체크하여 리턴
	function IfExistBips bipArr = (
		if (bipArr == undefined) do return false
		if (bipArr.count == 0) do return false
		for obj in bipArr do (
			-- 삭제된 오브젝트에 대해 처리하려고 하면 에러가 나므로 try 처리
			try (
				if (obj == undefined) do return false
				if ((classof obj.baseobject) != Biped_Object) do return false
			) catch (return false)
		)
		return true
	)

	-- 이하 바이패드 부위들을 얻어오는 함수들은 m_workingBipRoot를 대상으로 작동
	function GetHead = (
		selObj = biped.getNode m_workingBipRoot #head
		return #(selObj)
	)

	function GetRArms = (
		tArr = #()
		for i = 1 to 4 do (
			selObj = biped.getNode m_workingBipRoot #rarm link:i
			if selObj != undefined do -- 바이패드 스트럭처 설정에 따라 팔이 없는 등 예외가 있을 수 있음
			(
				append tArr selObj
			)
		)
		return tArr
	)

	function GetNecks = (
		tArr = #()
		testBool = true
		tIndex = 1
		while testBool do (
			selObj = biped.getNode m_workingBipRoot #neck link:tIndex
			if ( selObj == undefined ) then (
				testBool = false
			)
			else (
				append tArr selObj
			)
			tIndex += 1
		)
		return tArr
	)
	function GetLArms = (
		tArr = #()
		for i = 1 to 4 do (
			selObj = biped.getNode m_workingBipRoot #larm link:i
			if selObj != undefined do ( -- 바이패드 스트럭처 설정에 따라 팔이 없는 등 예외가 있을 수 있음
				append tArr selObj
			)
		)
		return tArr
	)

	function GetRClavicle = (
		selObj = biped.getNode m_workingBipRoot #rarm link:1
		if selObj == undefined do ( -- 바이패드 스트럭처 설정에 따라 팔이 없는 등 예외가 있을 수 있음
			return #()
		)
		return #(selObj)
	)

	function GetLClavicle = (
		selObj = biped.getNode m_workingBipRoot #larm link:1
		if selObj == undefined do ( -- 바이패드 스트럭처 설정에 따라 팔이 없는 등 예외가 있을 수 있음
			return #()
		)
		return #(selObj)
	)

	function GetRUpArm = (
		selObj = biped.getNode m_workingBipRoot #rarm link:2
		if selObj == undefined do ( -- 바이패드 스트럭처 설정에 따라 팔이 없는 등 예외가 있을 수 있음
			return #()
		)
		return #(selObj)
	)

	function GetAllSpine = (
		tArr = #()
		testBool = true
		tIndex = 1
		while testBool do (
			selObj = biped.getNode m_workingBipRoot #spine link:tIndex
			if ( selObj == undefined ) then (
				testBool = false
			)
			else (
				append tArr selObj
			)
			tIndex += 1
		)
		return tArr
	)

	function GetSpine index = (
		selObj = biped.getNode m_workingBipRoot #spine link:(index + 1)
		if selObj == undefined do return #()
		return #(selObj)
	)

	function GetLUpArm = (
		selObj = biped.getNode m_workingBipRoot #larm link:2
		if selObj == undefined do ( -- 바이패드 스트럭처 설정에 따라 팔이 없는 등 예외가 있을 수 있음
			return #()
		)
		return #(selObj)
	)

	function GetRForArm = (
		selObj = biped.getNode m_workingBipRoot #rarm link:3
		if selObj == undefined do ( -- 바이패드 스트럭처 설정에 따라 팔이 없는 등 예외가 있을 수 있음
			return #()
		)
		return #(selObj)
	)

	function GetLForArm = (
		selObj = biped.getNode m_workingBipRoot #larm link:3
		if selObj == undefined do ( -- 바이패드 스트럭처 설정에 따라 팔이 없는 등 예외가 있을 수 있음
			return #()
		)
		return #(selObj)
	)

	function GetRHand = (
		selObj = biped.getNode m_workingBipRoot #rarm link:4
		if selObj == undefined do ( -- 바이패드 스트럭처 설정에 따라 팔이 없는 등 예외가 있을 수 있음
			return #()
		)
		return #(selObj)
	)
	
	function GetLHand = (
		selObj = biped.getNode m_workingBipRoot #larm link:4
		if selObj == undefined do ( -- 바이패드 스트럭처 설정에 따라 팔이 없는 등 예외가 있을 수 있음
			return #()
		)
		return #(selObj)
	)

	function GetPelvis = (
		selObj = biped.getNode m_workingBipRoot #pelvis
		return #(selObj)
	)

	function GetRThigh = (
		selObj = biped.getNode m_workingBipRoot #rleg link:1
		return #(selObj)
	)

	function GetLThigh = (
		selObj = biped.getNode m_workingBipRoot #lleg link:1
		return #(selObj)
	)

	function GetRCalf = (
		selObj = biped.getNode m_workingBipRoot #rleg link:2
		return #(selObj)
	)

	function GetLCalf = (
		selObj = biped.getNode m_workingBipRoot #lleg link:2
		return #(selObj)
	)

	function GetRFoot = (
		local footIndex = 4 -- HorseLink가 있는 경우
		if (biped.getNode m_workingBipRoot #rleg link:4) == undefined do (
			footIndex = 3
		)
		selObj = biped.getNode m_workingBipRoot #rleg link:footIndex
		return #(selObj)
	)

	function GetLFoot = (
		local footIndex = 4 -- HorseLink가 있는 경우
		if (biped.getNode m_workingBipRoot #lleg link:4) == undefined do (
			footIndex = 3
		)
		selObj = biped.getNode m_workingBipRoot #lleg link:footIndex
		return #(selObj)
	)

	function GetRToe = (
		selObj = biped.getNode m_workingBipRoot #rtoes link:1
		return #(selObj)
	)

	function GetLToe = (
		selObj = biped.getNode m_workingBipRoot #ltoes link:1
		return #(selObj)
	)

	function GetRLegs = (
		tArr = #()
		for i = 1 to 4 do (
			selObj = biped.getNode m_workingBipRoot #rleg link:i
			if selObj != undefined do (		-- HorseLink 가 있기도 하고 없기도 할 수 있음
				append tArr selObj
			)
		)
		append tArr (biped.getNode m_workingBipRoot #rtoes link:1)
		return tArr
	)

	function GetAllFoot = (
		tArr = #()
		selObj = GetLFoot()
		append tArr selObj[1]
		selObj = GetRFoot()
		append tArr selObj[1]
		return tArr
	)

	function GetLLegs = (
		tArr = #()
		for i = 1 to 4 do (
			selObj = biped.getNode m_workingBipRoot #lleg link:i
			if selObj != undefined do (		-- HorseLink 가 있기도 하고 없기도 할 수 있음
				append tArr selObj
			)
		)
		append tArr (biped.getNode m_workingBipRoot #ltoes link:1)
		return tArr
	)

	function GetAllBip = (
		local tArr = #()
		for o in objects do (
			if ( classof o.baseobject == Biped_object ) do
			(
				-- 같은Bip001의 자식이면
				if ( o.controller.rootNode == m_workingBipRoot AND (classof o.controller) != Footsteps) do
				(
					append tArr o
				)
			)
		)
		return tArr
	)

	-- 모든 서브 롤아웃 초기화
	function InitSubRollouts = (
		if (SBAFingers.open) do (SBAFingers.InitFingers())
		if (SBAKeyframe.open) do (SBAKeyframe.InitKeyframe())
		if (SBAAnimation.open) do (SBAAnimation.InitAnimation())
	)
	
	-- 작업용 바이패드 루트 노드라던가, 선택용 배열 변수 등을 미리 세팅, 버튼 상태도 세팅
	function InitSBA = (
		--uiBtnLoopDupe.enabled = false -- 개발중인 기능 봉인

		AutoGetBipRoot() -- 바이패드 루트 조사
        if m_workingBipRoot == undefined then (
            SetButtonStateSBA false
			InitSubRollouts()	-- 모든 서브 롤아웃 초기화 (버튼 비활성화용)
            return ()
        )
        else (
            SetButtonStateSBA true
		)
		uiChkBtnScanBiped.text = "Scanning..."
		
		-- 모든 부위 변수들은 배열
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
		m_Spine3 = GetSpine 3
		if (m_Spine3.count == 0) then (uiSpine3.enabled = false; uiSpine3.state = false) else (uiSpine3.enabled = true; uiSpine3.state = true)
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

		uiChkBtnScanBiped.text = "Scan"

		InitSubRollouts()	-- 모든 서브 롤아웃 초기화
	)

	-- 보정치 회전값을 입력받고 똑바로 펴주는 기능을 한다. bips는 배열. 보정치 회전값은 Toe 등에서 90도 추가 회전이 필요함
	function Straighten bips offsetRotation = (
		undo on (
			for bip in bips do (
				if (bip != undefined AND (isDeleted bip) == false) do (
					biped.setTransform bip #rotation (offsetRotation * bip.parent.transform.rotation) animButtonState
				)
			)
		)
	)

	-- Straighten 함수와 같은 기능이지만 부모 대신에 다른 프록시 오브젝트를 기준으로 한다.
	-- 바이패드의 Triangle Pelvis 옵션때문에 허벅지 부모가 척추인 경우가 종종 있어서 강제로 Pelvis를 지정
	function StraightenByProxy bips proxy offsetRotation = (
		undo on (
			for bip in bips do (
				if (bip != undefined AND (isDeleted bip) == false) do (
					biped.setTransform bip #rotation (offsetRotation * proxy.transform.rotation) animButtonState
				)
			)
		)
	)

	on uiChkBtnScanBiped changed state do (
		uiChkBtnScanBiped.state = true
		InitSBA() -- 작업용 바이패드 루트 노드라던가, 선택용 배열 변수 등을 미리 세팅, 버튼 상태도 세팅
		if (m_workingBipRoot != undefined) do (select m_AllBip)
	)
	
	on uiHead changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiHead.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		
		if keyboard.shiftPressed do (
			-- Shift 를 누르면 똑바로 펴는 기능
			Straighten m_Head ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array
		
		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_Head) catch (
			m_Head = GetHead()
			select m_Head
		)
	)

	on uiNecks changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiNecks.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		
		if keyboard.shiftPressed do (
			-- Shift 를 누르면 똑바로 펴는 기능
			Straighten m_Necks ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_Necks) catch (
			m_Necks = GetNecks()
			select m_Necks
		)
	)
	
	on uiRArms changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiRArms.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		selBackup = selection as array

		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_RArms) catch (
			m_RArms = GetRArms()
			select m_RArms
		)
	)
	
	on uiLArms changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiLArms.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		selBackup = selection as array

		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_LArms) catch (
			m_LArms = GetLArms()
			select m_LArms
		)
	)
	
	on uiRClavicle changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiRClavicle.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		
		if keyboard.shiftPressed do (
			-- Shift 를 누르면 똑바로 펴는 기능
			StraightenByProxy m_RClavicle m_AllSpine[m_AllSpine.count] ((eulerangles 0 90 -180) as quat)
			return ()
		)

		selBackup = selection as array

		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_RClavicle) catch (
			m_RClavicle = GetRClavicle()
			select m_RClavicle
		)
	)

	on uiLClavicle changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiLClavicle.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		
		if keyboard.shiftPressed do (
			-- Shift 를 누르면 똑바로 펴는 기능
			StraightenByProxy m_LClavicle m_AllSpine[m_AllSpine.count] ((eulerangles 0 -90 -180) as quat)
			return ()
		)
		
		selBackup = selection as array

		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_LClavicle) catch (
			m_LClavicle = GetLClavicle()
			select m_LClavicle
		)
	)
	
	on uiRUpArm changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiRUpArm.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		
		if keyboard.shiftPressed do (
			-- Shift 를 누르면 똑바로 펴는 기능
			Straighten m_RUpArm ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_RUpArm) catch (
			m_RUpArm = GetRUpArm()
			select m_RUpArm
		)
	)

	on uiAllSpine changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiAllSpine.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		
		if keyboard.shiftPressed do (
			-- Shift 를 누르면 똑바로 펴는 기능
			Straighten m_AllSpine ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_AllSpine) catch (
			m_AllSpine = GetAllSpine()
			select m_AllSpine
		)
	)

	on uiSpine3 changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiSpine3.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		
		if keyboard.shiftPressed do (
			-- Shift 를 누르면 똑바로 펴는 기능
			Straighten m_Spine3 ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_Spine3) catch (
			m_Spine3 = GetSpine 3
			select m_Spine3
		)
	)

	on uiSpine2 changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiSpine2.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		
		if keyboard.shiftPressed do (
			-- Shift 를 누르면 똑바로 펴는 기능
			Straighten m_Spine2 ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_Spine2) catch (
			m_Spine2 = GetSpine 2
			select m_Spine2
		)
	)

	on uiSpine1 changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiSpine1.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		
		if keyboard.shiftPressed do (
			-- Shift 를 누르면 똑바로 펴는 기능
			Straighten m_Spine1 ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_Spine1) catch (
			m_Spine1 = GetSpine 1
			select m_Spine1
		)
	)

	on uiSpine0 changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiSpine0.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		
		if keyboard.shiftPressed do (
			-- Shift 를 누르면 똑바로 펴는 기능
			Straighten m_Spine0 ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_Spine0) catch (
			m_Spine0 = GetSpine 0
			select m_Spine0
		)
	)

	on uiLUpArm changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiLUpArm.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		
		if keyboard.shiftPressed do (
			-- Shift 를 누르면 똑바로 펴는 기능
			Straighten m_LUpArm ((eulerangles 0 0 0) as quat)
			return ()
		)

		selBackup = selection as array

		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_LUpArm) catch (
			m_LUpArm = GetLUpArm()
			select m_LUpArm
		)
	)
	
	on uiRForArm changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiRForArm.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		
		if keyboard.shiftPressed do (
			-- Shift 를 누르면 똑바로 펴는 기능
			Straighten m_RForArm ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_RForArm) catch (
			m_RForArm = GetRForArm()
			select m_RForArm
		)
	)

	on uiLForArm changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiLForArm.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		
		if keyboard.shiftPressed do (
			-- Shift 를 누르면 똑바로 펴는 기능
			Straighten m_LForArm ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_LForArm) catch (
			m_LForArm = GetLForArm()
			select m_LForArm
		)
	)

	-- 손가락 롤아웃에서도 함수를 활용하기 위해 오른손 왼손 클릭 처리는 함수화
	function HandClicked uiVar bipArr isRight = (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiVar.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		
		if keyboard.shiftPressed do (
			-- Shift 를 누르면 똑바로 펴는 기능
			local angle = (eulerangles -90 0 0) -- Left Hand
			if (isRight) do (angle = (eulerangles 90 0 0)) -- Right Hand
			Straighten bipArr (angle as quat)
			return ()
		)

		selBackup = selection as array

		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup bipArr) catch (
			m_RHand = GetRHand() -- 뭔가 문제가 생겼으니 오른손과 왼손 오브젝트를 다시 조사
			m_LHand = GetLHand()
			--select m_RHand -- 오른손과 왼손 통합 함수라서 최종 선택까지는 안함 (어느 손을 통해 들어왔는지 조사까지 하는건 오버인듯)
		)
	)
	
	on uiRHand changed state do (
		HandClicked uiRHand m_RHand true
	)

	on uiLHand changed state do (
		HandClicked uiLHand m_LHand false
	)

	on uiCOM changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiCOM.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		selBackup = selection as array
        
        -- 새로운 씬을 열면 m_workingBipRoot이 undefined는 아니지만 에러 발생함
        try (
            -- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
			CompSelect selBackup #(m_workingBipRoot)
        )
        catch (
            if (AutoGetBipRoot() == false) do ( SetButtonStateSBA false; return ())
            -- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
			CompSelect selBackup #(m_workingBipRoot)
        )
	)
	
	on uiPelvis changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiPelvis.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		
		if keyboard.shiftPressed do (
			-- Shift 를 누르면 똑바로 펴는 기능
			Straighten m_Pelvis ((eulerangles -90 -90 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_Pelvis) catch (
			m_Pelvis = GetPelvis()
			select m_Pelvis
		)
	)
	
	on uiRThigh changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiRThigh.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		
		if keyboard.shiftPressed do (
			-- Shift 를 누르면 똑바로 펴는 기능
			StraightenByProxy m_RThigh m_Pelvis[1] ((eulerangles 0 180 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_RThigh) catch (
			m_RThigh = GetRThigh()
			select m_RThigh
		)
	)

	on uiLThigh changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiLThigh.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		
		if keyboard.shiftPressed do (
			-- Shift 를 누르면 똑바로 펴는 기능
			StraightenByProxy m_LThigh m_Pelvis[1] ((eulerangles 0 -180 0) as quat)
			return ()
		)
		
		selBackup = selection as array
		
		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_LThigh) catch (
			m_LThigh = GetLThigh()
			select m_LThigh
		)
	)
	
	on uiRCalf changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiRCalf.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		
		if keyboard.shiftPressed do (
			-- Shift 를 누르면 똑바로 펴는 기능
			Straighten m_RCalf ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_RCalf) catch (
			m_RCalf = GetRCalf()
			select m_RCalf
		)
	)

	on uiLCalf changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiLCalf.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		
		if keyboard.shiftPressed do (
			-- Shift 를 누르면 똑바로 펴는 기능
			Straighten m_LCalf ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_LCalf) catch (
			m_LCalf = GetLCalf()
			select m_LCalf
		)
	)
	
	on uiRFoot changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiRFoot.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		
		if keyboard.shiftPressed do (
			-- Shift 를 누르면 똑바로 펴는 기능
			Straighten m_RFoot ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_RFoot) catch (
			m_RFoot = GetRFoot()
			select m_RFoot
		)
	)
	
	on uiLFoot changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiLFoot.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		
		if keyboard.shiftPressed do (
			-- Shift 를 누르면 똑바로 펴는 기능
			Straighten m_LFoot ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array

		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_LFoot) catch (
			m_LFoot = GetLFoot()
			select m_LFoot
		)
	)

	on uiRToe changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiRToe.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록

		if keyboard.shiftPressed do (
			-- Shift 를 누르면 똑바로 펴는 기능
			Straighten m_RToe ((eulerangles 0 0 90) as quat)
			return ()
		)

		selBackup = selection as array
		
		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_RToe) catch (
			m_RToe = GetRToe()
			select m_RToe
		)
	)

	on uiLToe changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiLToe.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록

		if keyboard.shiftPressed do (
			-- Shift 를 누르면 똑바로 펴는 기능
			Straighten m_LToe ((eulerangles 0 0 90) as quat)
			return ()
		)

		selBackup = selection as array

		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_LToe) catch (
			m_LToe = GetLToe()
			select m_LToe
		)
	)
	
	on uiRLegs changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiRLegs.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		selBackup = selection as array

		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_RLegs) catch (
			m_RLegs = GetRLegs()
			select m_RLegs
		)
	)
	
	on uiFeet changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiFeet.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		selBackup = selection as array

		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_AllFoot) catch (
			m_AllFoot = GetAllFoot()
			select m_AllFoot
		)
	)
	
	on uiLLegs changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiLLegs.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		selBackup = selection as array

		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_LLegs) catch (
			m_LLegs = GetLLegs()
			select m_LLegs
		)
	)
	
	on uiAllBip changed state do (
		if (m_workingBipRoot == undefined or (isDeleted m_workingBipRoot)) do ( SetButtonStateSBA false; return ())
		uiAllBip.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		selBackup = selection as array

		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(CompSelect selBackup m_AllBip) catch (
			m_AllBip = GetAllBip()
			select m_AllBip
		)
	)
	
	

	-- IK Blend, Body/Object 등의 키값을 조사해서 Planted, Sliding, Free 셋 중 하나의 타입을 리턴한다.
	function GetLimbKeyType key = (
		-- ikSpace 0 = Body, 1 = Object
		if key.ikBlend == 1 AND key.ikSpace == 1 AND key.ikJoinedPivot == true do return "Planted"
		if key.ikBlend == 1 AND key.ikSpace == 1 AND key.ikJoinedPivot == false  do return "Sliding"
		return "Free"
	)

	on uiAbout pressed do (
		shellLaunch "http://cafe.naver.com/pinksox/6131" ""
	)
	
	on SBA open do (
        InitSBA() -- 작업용 바이패드 루트 노드라던가, 선택용 배열 변수 등을 미리 세팅

		-- 손가락 발가락 롤아웃이 부모와 붙어다니도록 SoxBipedAssist의 이전 위치를 기억하는 변수
		-- 이 변수는 InitSBA() 함수 안에 일부러 넣지 않음. 롤아웃이 열릴 떄 한 번만 실행되기 위해서.
		SBAPosBefore = GetDialogPos SBA
		SBAFingersPosBefore = [SBAPosBefore.x - 206, SBAPosBefore.y + 0]
		--SBAToesPosBefore = [SBAPosBefore.x - 206, SBAPosBefore.y + 400] 발가락 기능 보류
		SBAKeyframePosBefore = [SBAPosBefore.x - 4, SBAPosBefore.y + 340]
        SBAAnimationPosBefore = [SBAPosBefore.x - 4, SBAPosBefore.y - 131]
        
        callbacks.addScript #filePostOpen "SBA.InitSBA ()" id:#SoxBACallbackOpen
		callbacks.addScript #systemPostNew "SBA.InitSBA ()" id:#SoxBACallbackNew
		callbacks.addScript #systemPostReset "SBA.InitSBA ()" id:#SoxBACallbackReset
		callbacks.addScript #sceneUndo "SBA.UIUnDoCallBack ()" id:#SoxBACallbackUnDo

		-- Tools 창 자동 오픈
		--uiBtnFingersWindow.pressed()
		--uiBtnKeyframeWindow.pressed()
        --uiBtnAnimationWindow.pressed()
	)
	
	on SBA close do (
        callbacks.removeScripts id:#SoxBACallbackOpen
		callbacks.removeScripts id:#SoxBACallbackNew
		callbacks.removeScripts id:#SoxBACallbackReset
		callbacks.removeScripts id:#SoxBACallbackUnDo
	)

	on SBA moved newPos do (
		-- 메인 롤아웃이 이동할 때 손가락과 발가락이 같이 이동하도록
		local deltaPos = newPos - SBAPosBefore
		
		-- 손가락 창 이동 및 백업 포지션 기록
		local tPos = deltaPos + SBAFingersPosBefore
		SetDialogPos SBAFingers tPos
		SBAFingersPosBefore = tPos

		/*
		발가락 기능 보류
		tPos = deltaPos + SBAToesPosBefore
		SetDialogPos SBAToes tPos
		SBAToesPosBefore = tPos
		*/

		-- Keyframe Assist 창 이동 및 백업 포지션 기록
		tPos = deltaPos + SBAKeyframePosBefore
		SetDialogPos SBAKeyframe tPos
		SBAKeyframePosBefore = tPos

        -- Animation 창 이동 및 백업 포지션 기록
		tPos = deltaPos + SBAAnimationPosBefore
		SetDialogPos SBAAnimation tPos
		SBAAnimationPosBefore = tPos

		SBAPosBefore = newPos -- 모든 처리 후 새로운 위치를 롤아웃 로컬 변수에 기록
	)

	on uiBtnFingersWindow pressed do (
		if (SBAFingers.open) then (
            destroydialog SBAFingers
        )
        else (
            createDialog SBAFingers pos:SBAFingersPosBefore style:#(#style_toolwindow, #style_sysmenu) lockWidth:true parent:SBA.hwnd
        )
	)

	on uiBtnKeyframeWindow pressed do (
        if (SBAKeyframe.open) then (
            destroydialog SBAKeyframe
        )
        else (
		    createDialog SBAKeyframe pos:SBAKeyframePosBefore style:#(#style_toolwindow, #style_sysmenu) lockWidth:true parent:SBA.hwnd
        )
	)

    on uiBtnAnimationWindow pressed do (
		if (SBAAnimation.open) then (
            destroydialog SBAAnimation
        )
        else (
            createDialog SBAAnimation pos:SBAAnimationPosBefore style:#(#style_toolwindow, #style_sysmenu) lockWidth:true parent:SBA.hwnd
        )
	)

/*
발가락 기능 보류
	on uiBtnToesWindow pressed do (
		createDialog SBAToes pos:SBAToesPosBefore style:#(#style_toolwindow, #style_sysmenu) lockWidth:true parent:SBA.hwnd
	)
*/
)

rollout SBAFingers "Fingers" width:200 (
	local mc_greenColor = color 6 134 6
	local mc_greenAllColor = mc_greenColor * 0.7
	local mc_blueColor = color 80 80 230
	local mc_blueAllColor = mc_blueColor * 0.7
	local mc_greenThumbColor = color 224 198 87
	local mc_blueThumbColor = color 200 70 100
	local mc_spreadMaxAngle = 45.0

	checkButton uiRHand "R Hand" width:60 height:20 checked:true highlightColor:mc_greenColor offset:[-16, -2] across:2
	checkButton uiLHand "L Hand" width:60 height:20 checked:true highlightColor:mc_blueColor offset:[16, -2]
	
	checkButton uiRFingersAll "R Fingers" width:60 height:14 checked:true highlightColor:mc_greenAllColor offset:[-16, 0] across:2
	checkButton uiLFingersAll "L Fingers" width:60 height:14 checked:true highlightColor:mc_blueAllColor offset:[16, 0]
	
	local tWidth = 18; local tHeight = 18; local tOffsetX = 90; local tOffsetY = -4
	checkButton uiRFinger4 width:tWidth height:tHeight checked:true highlightColor:mc_greenColor offset:[-tOffsetX, tOffsetY]
	checkButton uiRFinger41 width:tWidth height:tHeight checked:true highlightColor:mc_greenColor offset:[-tOffsetX, tOffsetY]
	checkButton uiRFinger42 width:tWidth height:tHeight checked:true highlightColor:mc_greenColor offset:[-tOffsetX, tOffsetY]
	checkButton uiRFinger43 width:tWidth height:tHeight checked:true highlightColor:mc_greenColor offset:[-tOffsetX, tOffsetY]

	checkButton uiLFinger4 width:tWidth height:tHeight checked:true highlightColor:mc_blueColor offset:[tOffsetX, tOffsetY-76]
	checkButton uiLFinger41 width:tWidth height:tHeight checked:true highlightColor:mc_blueColor offset:[tOffsetX, tOffsetY]
	checkButton uiLFinger42 width:tWidth height:tHeight checked:true highlightColor:mc_blueColor offset:[tOffsetX, tOffsetY]
	checkButton uiLFinger43 width:tWidth height:tHeight checked:true highlightColor:mc_blueColor offset:[tOffsetX, tOffsetY]

	local tHeight = 20; local tOffsetX = 72
	checkButton uiRFinger3 width:tWidth height:tHeight checked:true highlightColor:mc_greenColor offset:[-tOffsetX, tOffsetY-76]
	checkButton uiRFinger31 width:tWidth height:tHeight checked:true highlightColor:mc_greenColor offset:[-tOffsetX, tOffsetY]
	checkButton uiRFinger32 width:tWidth height:tHeight checked:true highlightColor:mc_greenColor offset:[-tOffsetX, tOffsetY]
	checkButton uiRFinger33 width:tWidth height:tHeight checked:true highlightColor:mc_greenColor offset:[-tOffsetX, tOffsetY]

	checkButton uiLFinger3 width:tWidth height:tHeight checked:true highlightColor:mc_blueColor offset:[tOffsetX, tOffsetY-84]
	checkButton uiLFinger31 width:tWidth height:tHeight checked:true highlightColor:mc_blueColor offset:[tOffsetX, tOffsetY]
	checkButton uiLFinger32 width:tWidth height:tHeight checked:true highlightColor:mc_blueColor offset:[tOffsetX, tOffsetY]
	checkButton uiLFinger33 width:tWidth height:tHeight checked:true highlightColor:mc_blueColor offset:[tOffsetX, tOffsetY]

	local tHeight = 22; local tOffsetX = 54
	checkButton uiRFinger2 width:tWidth height:tHeight checked:true highlightColor:mc_greenColor offset:[-tOffsetX, tOffsetY-84]
	checkButton uiRFinger21 width:tWidth height:tHeight checked:true highlightColor:mc_greenColor offset:[-tOffsetX, tOffsetY]
	checkButton uiRFinger22 width:tWidth height:tHeight checked:true highlightColor:mc_greenColor offset:[-tOffsetX, tOffsetY]
	checkButton uiRFinger23 width:tWidth height:tHeight checked:true highlightColor:mc_greenColor offset:[-tOffsetX, tOffsetY]

	checkButton uiLFinger2 width:tWidth height:tHeight checked:true highlightColor:mc_blueColor offset:[tOffsetX, tOffsetY-92]
	checkButton uiLFinger21 width:tWidth height:tHeight checked:true highlightColor:mc_blueColor offset:[tOffsetX, tOffsetY]
	checkButton uiLFinger22 width:tWidth height:tHeight checked:true highlightColor:mc_blueColor offset:[tOffsetX, tOffsetY]
	checkButton uiLFinger23 width:tWidth height:tHeight checked:true highlightColor:mc_blueColor offset:[tOffsetX, tOffsetY]
	
	local tHeight = 20; local tOffsetX = 36
	checkButton uiRFinger1 width:tWidth height:tHeight checked:true highlightColor:mc_greenColor offset:[-tOffsetX, tOffsetY-92]
	checkButton uiRFinger11 width:tWidth height:tHeight checked:true highlightColor:mc_greenColor offset:[-tOffsetX, tOffsetY]
	checkButton uiRFinger12 width:tWidth height:tHeight checked:true highlightColor:mc_greenColor offset:[-tOffsetX, tOffsetY]
	checkButton uiRFinger13 width:tWidth height:tHeight checked:true highlightColor:mc_greenColor offset:[-tOffsetX, tOffsetY]

	checkButton uiLFinger1 width:tWidth height:tHeight checked:true highlightColor:mc_blueColor offset:[tOffsetX, tOffsetY-84]
	checkButton uiLFinger11 width:tWidth height:tHeight checked:true highlightColor:mc_blueColor offset:[tOffsetX, tOffsetY]
	checkButton uiLFinger12 width:tWidth height:tHeight checked:true highlightColor:mc_blueColor offset:[tOffsetX, tOffsetY]
	checkButton uiLFinger13 width:tWidth height:tHeight checked:true highlightColor:mc_blueColor offset:[tOffsetX, tOffsetY]
	
	local tHeight = 18; local tOffsetX = 16
	checkButton uiRFinger0 width:tWidth height:tHeight checked:true highlightColor:mc_greenThumbColor offset:[-tOffsetX-4, tOffsetY-100]
	checkButton uiRFinger01 width:tWidth height:tHeight checked:true highlightColor:mc_greenThumbColor offset:[-tOffsetX, tOffsetY]
	checkButton uiRFinger02 width:tWidth height:tHeight checked:true highlightColor:mc_greenThumbColor offset:[-tOffsetX, tOffsetY]
	checkButton uiRFinger03 width:tWidth height:tHeight checked:true highlightColor:mc_greenThumbColor offset:[-tOffsetX, tOffsetY]

	checkButton uiLFinger0 width:tWidth height:tHeight checked:true highlightColor:mc_blueThumbColor offset:[tOffsetX+4, tOffsetY-76]
	checkButton uiLFinger01 width:tWidth height:tHeight checked:true highlightColor:mc_blueThumbColor offset:[tOffsetX, tOffsetY]
	checkButton uiLFinger02 width:tWidth height:tHeight checked:true highlightColor:mc_blueThumbColor offset:[tOffsetX, tOffsetY]
	checkButton uiLFinger03 width:tWidth height:tHeight checked:true highlightColor:mc_blueThumbColor offset:[tOffsetX, tOffsetY]
	
	local tOffsetY = 28
	checkButton uiRFingers4 "a" width:tWidth height:tHeight checked:true highlightColor:mc_greenAllColor offset:[-12, tOffsetY] across:10
	checkButton uiRFingers3 "a" width:tWidth height:tHeight checked:true highlightColor:mc_greenAllColor offset:[-10, tOffsetY]
	checkButton uiRFingers2 "a" width:tWidth height:tHeight checked:true highlightColor:mc_greenAllColor offset:[-8, tOffsetY]
	checkButton uiRFingers1 "a" width:tWidth height:tHeight checked:true highlightColor:mc_greenAllColor offset:[-6, tOffsetY]
	checkButton uiRFingers0 "a" width:tWidth height:tHeight checked:true highlightColor:(mc_greenThumbColor * 0.7) offset:[-4, tOffsetY]
	checkButton uiLFingers0 "a" width:tWidth height:tHeight checked:true highlightColor:(mc_blueThumbColor * 0.7) offset:[10, tOffsetY]
	checkButton uiLFingers1 "a" width:tWidth height:tHeight checked:true highlightColor:mc_blueAllColor offset:[12, tOffsetY]
	checkButton uiLFingers2 "a" width:tWidth height:tHeight checked:true highlightColor:mc_blueAllColor offset:[14, tOffsetY]
	checkButton uiLFingers3 "a" width:tWidth height:tHeight checked:true highlightColor:mc_blueAllColor offset:[16, tOffsetY]
	checkButton uiLFingers4 "a" width:tWidth height:tHeight checked:true highlightColor:mc_blueAllColor offset:[18, tOffsetY]
	
	spinner uiRBendEnd width:40 range:[-45,90,0] scale:1 type:#integer align:#left tooltip:"R Bend End" offset:[-8, -2] across:4
	spinner uiRBendStart width:40 range:[-45,90,0] scale:1 type:#integer align:#left tooltip:"R Bend Start" offset:[-8, -2]
	spinner uiLBendStart width:40 range:[-45,90,0] scale:1 type:#integer align:#right tooltip:"L Bend Start" offset:[8, -2]
	spinner uiLBendEnd width:40 range:[-45,90,0] scale:1 type:#integer align:#right tooltip:"L Bend End" offset:[8, -2]
	
	slider uiRSpread range:[-0.3,1,0] ticks:0 align:#left tooltip:"R Spread" offset:[0, -4] across:2
	slider uiLSpread range:[-0.3,1,0] ticks:0 align:#right tooltip:"L Spread" offset:[12, -4]
	
	local m_RFingersAll; local m_LFingersAll
	local m_RFingers; local m_LFingers -- 5x4 2차원 배열로 모든 손가락을 저장
	local m_fingersRotArr -- 수동 UnDo를 위해 5x4 2차원 배열로 모든 손가락의 회전값을 저장시키는 용도
	
	-- 두 float 값 사이를 보간하는 함수. 무조건 float로 변환한다.
	function LerpFloat a b bias = (
		return ((a as float) + (((b as float) - (a as float)) * (bias as float)))
	)

	function SetButtonStateFingers state = (
		uiRHand.state = state; uiLHand.state = state
		uiRFingersAll.state = state; uiLFingersAll.state = state
		
		uiRFinger4.state = state; uiRFinger41.state = state; uiRFinger42.state = state; uiRFinger43.state = state
		uiLFinger4.state = state; uiLFinger41.state = state; uiLFinger42.state = state; uiLFinger43.state = state
		uiRFingers4.state = state; uiLFingers4.state = state
		
		uiRFinger3.state = state; uiRFinger31.state = state; uiRFinger32.state = state; uiRFinger33.state = state
		uiLFinger3.state = state; uiLFinger31.state = state; uiLFinger32.state = state; uiLFinger33.state = state
		uiRFingers3.state = state; uiLFingers3.state = state

		uiRFinger2.state = state; uiRFinger21.state = state; uiRFinger22.state = state; uiRFinger23.state = state
		uiLFinger2.state = state; uiLFinger21.state = state; uiLFinger22.state = state; uiLFinger23.state = state
		uiRFingers2.state = state; uiLFingers2.state = state

		uiRFinger1.state = state; uiRFinger11.state = state; uiRFinger12.state = state; uiRFinger13.state = state
		uiLFinger1.state = state; uiLFinger11.state = state; uiLFinger12.state = state; uiLFinger13.state = state
		uiRFingers1.state = state; uiLFingers1.state = state

		uiRFinger0.state = state; uiRFinger01.state = state; uiRFinger02.state = state; uiRFinger03.state = state
		uiLFinger0.state = state; uiLFinger01.state = state; uiLFinger02.state = state; uiLFinger03.state = state
		uiRFingers0.state = state; uiLFingers0.state = state
	)
	
	-- 바이패드 스트럭쳐의 Finger Links 숫자를 알아내는 함수. 스트럭쳐 관련 API가 너무 없어서 무식하게 알아냄
	function GetFingerLinkCount = (
		local firstFinger = biped.getNode SBA.m_workingBipRoot #rfingers link:1
		if (firstFinger == undefined) do (return 0) -- 최초 손가락도 없다는 것은 Fingers가 0인 상황. 손가락 링크 숫자와 무관하게 0을 리턴
		local stringLength = firstFinger.name.count
		for i = 2 to 4 do (
			local compareFinger = biped.getNode SBA.m_workingBipRoot #rfingers link:i
			if (compareFinger == undefined) do (return (i - 1)) -- 손가락이 없으면 바로 전 단계의 숫자가 링크 수
			if (compareFinger.name[stringLength] == "1") do (return (i - 1))
		)
		return 4
	)

	-- 손가락 번호와 Left Right bool 정보를 받아서 손가락 변수 세팅 (리턴 없음)
	function SetFingersVar = (
		-- isRight는 오른쪽인지 bool, false면 왼쪽
		-- idx는 엄지 검지 등 손가락 번호
		m_RFingers = #(); m_LFingers = #() -- 손가락 변수 배열 초기화,  5x4 2차원 배열로 모든 손가락을 저장
		m_RFingersAll = #(); m_LFingersAll = #() -- 모든 손가락들 배열 변수도 초기화
		local fingerLink = 1
		for fingerIndex = 1 to 5 do (			
			local tRFingersArray = #()
			local tLFingersArray = #()
			local tFingerLinkCount = GetFingerLinkCount()
			for i = 1 to tFingerLinkCount do (
				-- 오른 손가락 얻어오기
				local tFinger = biped.getNode SBA.m_workingBipRoot #rfingers link:fingerLink
				if (tFinger != undefined) do (
					append tRFingersArray tFinger
					append m_RFingersAll tFinger -- 모든 손가락 변수에도 오른 손가락 추가
				)
				
				-- 왼 손가락 얻어오기
				tFinger = biped.getNode SBA.m_workingBipRoot #lfingers link:fingerLink
				if (tFinger != undefined) do (
					append tLFingersArray tFinger
					append m_LFingersAll tFinger -- 모든 손가락 변수에도 왼 손가락 추가
				)
				fingerLink += 1
			)
			-- 손가락 숫자가 5 이하일 수 있어서 m_RFingers의 배열에 빈 손가락은 넣지 않는다.
			-- 결국 m_RFingers.count가 손가락 개수 역할을 한다.
			if (tRFingersArray[1] != undefined) do (append m_RFingers tRFingersArray)
			if (tLFingersArray[1] != undefined) do (append m_LFingers tLFingersArray)
		)
	)

	-- 손가락 변수의 undefined 상태를 조사해서 손가락 체크버튼의 활성을 세팅한다.
	function SetFingerButtonState = (
		for fingerIndex = 1 to 5 do (			
			-- execute는 글로벌 스코프에서 실행되므로 전체 ui 경로를 사용해야함.
			 -- uiRFinger0, uiRFinger01, uiRFinger02, uiRFinger03 네 개의 버튼
			local uiRString = "SBAFingers.uiRFinger" + ((fingerIndex - 1) as string)
			local uiLString = "SBAFingers.uiLFinger" + ((fingerIndex - 1) as string)
			for i = 1 to 4 do (
				-- 하위 손가락들 버튼 이름을 위한 문자열 가공
				-- 세 번째 진입부터 uiRString의 끝 한 글자를 없애고...
				if (i >= 3) do (
					local tSubString = substring uiRString 1 (uiRString.count - 1)
					uiRString = tSubString
					tSubString = substring uiLString 1 (uiLString.count - 1)
					uiLString = tSubString
				)

				-- 두 번째 진입부터 뒤에 숫자 추가
				if (i >= 2) do (
					uiRString += ((i - 1) as string)
					uiLString += ((i - 1) as string)
				)

				local tRUI = execute uiRString
				local tLUI = execute uiLString
				-- 현재 for 루프의 fingerIndex (손가락 번호)가 실제 m_RFingers 배열의 손가락 숫자보다 크면..., 이 방식의 이유: m_RFingers.count로 손가락 숫자를 알아내기 위해서 undefined로 채운 배열을 사용하지 않음
				-- 그러면 실제 존재하지 않는 손가락이므로 UI를 끈다.
				if (fingerIndex > m_RFingers.count) then (
					tRUI.enabled = false; tRUI.state = false
				)
				else (
					-- 존재하는 손가락이라도 손가락 마디가 존재하지 않을 수 있으므로 마디 숫자로 다시 검사
					if (i > m_RFingers[fingerIndex].count) then (
						tRUI.enabled = false; tRUI.state = false
					)
					else (
						tRUI.enabled = true; tRUI.state = true
					)
				)

				if (fingerIndex > m_LFingers.count) then (
					tLUI.enabled = false; tLUI.state = false
				)
				else (
					-- 존재하는 손가락이라도 손가락 마디가 존재하지 않을 수 있으므로 마디 숫자로 다시 검사
					if (i > m_LFingers[fingerIndex].count) then (
						tLUI.enabled = false; tLUI.state = false
					)
					else (
						tLUI.enabled = true; tLUI.state = true
					)
				)
			)
		)
	)
	
	-- Fingers 초기화
	function InitFingers = (
		if SBA.m_workingBipRoot == undefined then (
			SetButtonStateFingers false
            return ()
		)
		else (
			SetButtonStateFingers true
		)

		SetFingersVar() -- 손가락 로컬 변수 세팅
		SetFingerButtonState() -- 손가락 버튼 상태 세팅
	)

	-- 클릭한 UI와 바이패드 오브젝트를 받아서 선택 가공, 똑바로 펴기, UI 모양 등을 처리
	function FingerClicked uiVar bip = (
		local bipRoot = SBA.m_workingBipRoot
		if (bipRoot == undefined or (isDeleted bipRoot)) do ( SetButtonStateFingers false; return ())
		uiVar.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		
		local bipArr = #(bip)

		-- Shift 를 누르면 똑바로 펴는 기능
		if keyboard.shiftPressed do (
			SBA.Straighten bipArr ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array
		
		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(SBA.CompSelect selBackup bipArr) catch (
			SetFingersVar()
			select bipArr
		)
	)

	-- 클릭한 UI와 바이패드 배열을 받아서 선택 가공, 똑바로 펴기, UI 모양 등을 처리
	function FingersClicked uiVar bipArr = (
		local bipRoot = SBA.m_workingBipRoot
		if (bipRoot == undefined or (isDeleted bipRoot)) do ( SetButtonStateFingers false; return ())
		uiVar.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		
		-- Shift 를 누르면 똑바로 펴는 기능
		if keyboard.shiftPressed do (
			SBA.Straighten bipArr ((eulerangles 0 0 0) as quat)
			return ()
		)
		
		selBackup = selection as array
		
		-- 기존 selection 백업과 이번에 선택할 selArr 을 입력받아 키보드 조합으로 적절하게 선택한다. 부수적으로 모션패널로의 변경도 같이 수행
		try(SBA.CompSelect selBackup bipArr) catch (
			SetFingersVar()
			select bipArr
		)
	)

	on uiRHand changed state do (
		uiRHand.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		SBA.HandClicked uiRHand SBA.m_RHand true
	)
	on uiLHand changed state do (
		uiLHand.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		SBA.HandClicked uiLHand SBA.m_LHand false
	)
	on uiRFingersAll changed state do (
		FingersClicked uiRFingersAll m_RFingersAll
	)
	on uiLFingersAll changed state do (
		FingersClicked uiLFingersAll m_LFingersAll
	)

	on uiRFinger0 changed state do (FingerClicked uiRFinger0 m_RFingers[1][1])
	on uiRFinger01 changed state do (FingerClicked uiRFinger01 m_RFingers[1][2])
	on uiRFinger02 changed state do (FingerClicked uiRFinger02 m_RFingers[1][3])
	on uiRFinger03 changed state do (FingerClicked uiRFinger03 m_RFingers[1][4])
	on uiLFinger0 changed state do (FingerClicked uiLFinger0 m_LFingers[1][1])
	on uiLFinger01 changed state do (FingerClicked uiLFinger01 m_LFingers[1][2])
	on uiLFinger02 changed state do (FingerClicked uiLFinger02 m_LFingers[1][3])
	on uiLFinger03 changed state do (FingerClicked uiLFinger03 m_LFingers[1][4])

	on uiRFinger1 changed state do (FingerClicked uiRFinger1 m_RFingers[2][1])
	on uiRFinger11 changed state do (FingerClicked uiRFinger11 m_RFingers[2][2])
	on uiRFinger12 changed state do (FingerClicked uiRFinger12 m_RFingers[2][3])
	on uiRFinger13 changed state do (FingerClicked uiRFinger13 m_RFingers[2][4])
	on uiLFinger1 changed state do (FingerClicked uiLFinger1 m_LFingers[2][1])
	on uiLFinger11 changed state do (FingerClicked uiLFinger11 m_LFingers[2][2])
	on uiLFinger12 changed state do (FingerClicked uiLFinger12 m_LFingers[2][3])
	on uiLFinger13 changed state do (FingerClicked uiLFinger13 m_LFingers[2][4])

	on uiRFinger2 changed state do (FingerClicked uiRFinger2 m_RFingers[3][1])
	on uiRFinger21 changed state do (FingerClicked uiRFinger21 m_RFingers[3][2])
	on uiRFinger22 changed state do (FingerClicked uiRFinger22 m_RFingers[3][3])
	on uiRFinger23 changed state do (FingerClicked uiRFinger23 m_RFingers[3][4])
	on uiLFinger2 changed state do (FingerClicked uiLFinger2 m_LFingers[3][1])
	on uiLFinger21 changed state do (FingerClicked uiLFinger21 m_LFingers[3][2])
	on uiLFinger22 changed state do (FingerClicked uiLFinger22 m_LFingers[3][3])
	on uiLFinger23 changed state do (FingerClicked uiLFinger23 m_LFingers[3][4])

	on uiRFinger3 changed state do (FingerClicked uiRFinger3 m_RFingers[4][1])
	on uiRFinger31 changed state do (FingerClicked uiRFinger31 m_RFingers[4][2])
	on uiRFinger32 changed state do (FingerClicked uiRFinger32 m_RFingers[4][3])
	on uiRFinger33 changed state do (FingerClicked uiRFinger33 m_RFingers[4][4])
	on uiLFinger3 changed state do (FingerClicked uiLFinger3 m_LFingers[4][1])
	on uiLFinger31 changed state do (FingerClicked uiLFinger31 m_LFingers[4][2])
	on uiLFinger32 changed state do (FingerClicked uiLFinger32 m_LFingers[4][3])
	on uiLFinger33 changed state do (FingerClicked uiLFinger33 m_LFingers[4][4])

	on uiRFinger4 changed state do (FingerClicked uiRFinger4 m_RFingers[5][1])
	on uiRFinger41 changed state do (FingerClicked uiRFinger41 m_RFingers[5][2])
	on uiRFinger42 changed state do (FingerClicked uiRFinger42 m_RFingers[5][3])
	on uiRFinger43 changed state do (FingerClicked uiRFinger43 m_RFingers[5][4])
	on uiLFinger4 changed state do (FingerClicked uiLFinger4 m_LFingers[5][1])
	on uiLFinger41 changed state do (FingerClicked uiLFinger41 m_LFingers[5][2])
	on uiLFinger42 changed state do (FingerClicked uiLFinger42 m_LFingers[5][3])
	on uiLFinger43 changed state do (FingerClicked uiLFinger43 m_LFingers[5][4])

	on uiRFingers0 changed state do (FingersClicked uiRFingers0 m_RFingers[1])
	on uiRFingers1 changed state do (FingersClicked uiRFingers1 m_RFingers[2])
	on uiRFingers2 changed state do (FingersClicked uiRFingers2 m_RFingers[3])
	on uiRFingers3 changed state do (FingersClicked uiRFingers3 m_RFingers[4])
	on uiRFingers4 changed state do (FingersClicked uiRFingers4 m_RFingers[5])
	on uiLFingers0 changed state do (FingersClicked uiLFingers0 m_LFingers[1])
	on uiLFingers1 changed state do (FingersClicked uiLFingers1 m_LFingers[2])
	on uiLFingers2 changed state do (FingersClicked uiLFingers2 m_LFingers[3])
	on uiLFingers3 changed state do (FingersClicked uiLFingers3 m_LFingers[4])
	on uiLFingers4 changed state do (FingersClicked uiLFingers4 m_LFingers[5])

	function MakeClosest quat1 quat2 = -- modifies quat2 and also returns quat2
	(
		local dot = quat1.x*quat2.x + quat1.y*quat2.y + quat1.z*quat2.z+quat1.w*quat2.w
		if (dot < 0.0) do (quat2.x = -quat2.x; quat2.y = -quat2.y;quat2.z = -quat2.z; quat2.w = -quat2.w)
		quat2
	)

	on uiRSpread rightClick do (
		uiRSpread.value = 0
		uiRSpread.changed 0
	)
	on uiLSpread rightClick do (
		uiLSpread.value = 0
		uiLSpread.changed 0
	)

	function SpreadFingers fingersArr minAngle maxAngle spread bendStart bendEnd = (
		if (fingersArr.count < 3) do (return()) -- 엄지 포함 손가락 2개부터는 작업 대상이 아님
		-- 슬라이더에서 호출되는 작동이라 Undo On으로 묶어줘도 정상적인 Undo가 안됨 (세밀한 스텝으로 Undo가 됨)
		-- 두 번째 검지손가락부터 끝 손가락까지
		for fingerIndex = 2 to fingersArr.count do (
			-- 다음 tFingerBias 계산 샘플: 예를 들어 다섯 손가락 다 있을 때 i가 5인 새끼손가락은 3 / 3
			local tFingerBias = ((fingerIndex - 2) as float) / ((fingersArr.count - 2) as float) -- 손가락이 얼마나 치우친 위치인지
			-- 손가락마다 구부러진 정도
			local tWeightedAngle = LerpFloat bendStart bendEnd tFingerBias

			local tSpreadMaxAngle = LerpFloat minAngle maxAngle tFingerBias -- 현재 fingerIndex 손가락의 가로로 최대 벌어진 각도
			local tSpreadMaxQuat = eulerToQuat (eulerAngles 0 tSpreadMaxAngle tWeightedAngle) order:1
			local tSpreadMinQuat = eulerToQuat (eulerAngles 0 0 tWeightedAngle) order:1

			MakeClosest tSpreadMinQuat tSpreadMaxQuat -- 쿼터니언 slerp 계산 전 가까운 쪽으로 데이터 가공
			local tRot = slerp tSpreadMinQuat tSpreadMaxQuat spread
			biped.setTransform fingersArr[fingerIndex][1] #rotation (tRot * fingersArr[fingerIndex][1].parent.transform.rotation) animButtonState
		)
	)

	-- 손가락들 수동 UnDo를 위해 버튼이 눌러지는 순간의 손가락 회전값 기억
	function StoreFingersUnDo fingersArr = (
		m_fingersRotArr = #()
		for fingerIndex = 1 to fingersArr.count do (
			local tempArr = #()
			for i = 1 to fingersArr[fingerIndex].count do (
				if (fingersArr[fingerIndex][i] != undefined) do (
					append tempArr fingersArr[fingerIndex][i].transform.rotation
				)
			)
			append m_fingersRotArr tempArr
		)
	)
	
	-- 손가락들 수동 UnDo를 위해 버튼이 떼어지는 순간 원래 손가락으로 되돌린 후 UnDo로 다시 회전시킨다.
	function ApplyFingersUnDo fingersArr = (
		-- m_fingersRotArr에 손가락들 원래 회전값이 있다는 가정에서 작동
		local fingersRotTargetArr = #() -- 현재 손가락의 회전 상태를 UnDo로 적용할 목표 배열로 저장
		for fingerIndex = 1 to fingersArr.count do (
			local tempArr = #()
			for i = 1 to fingersArr[fingerIndex].count do (
				if (fingersArr[fingerIndex][i] != undefined) do (
					append tempArr fingersArr[fingerIndex][i].transform.rotation
				)
			)
			append fingersRotTargetArr tempArr
		)

		-- 수동 UnDo를 위해 손가락을 원래 상태로 임시로 되돌림
		UnDo Off (
			for fingerIndex = 1 to fingersArr.count do (
				for i = 1 to fingersArr[fingerIndex].count do (
					if (fingersArr[fingerIndex][i] != undefined) do (
						local tRot = m_fingersRotArr[fingerIndex][i]
						biped.setTransform fingersArr[fingerIndex][i] #rotation tRot animButtonState
					)
				)
			)
		)

		-- UnDo 상태에서 다시 타겟 회전 적용
		UnDo On (
			for fingerIndex = 1 to fingersArr.count do (
				for i = 1 to fingersArr[fingerIndex].count do (
					if (fingersArr[fingerIndex][i] != undefined) do (
						local tRot = fingersRotTargetArr[fingerIndex][i]
						biped.setTransform fingersArr[fingerIndex][i] #rotation tRot animButtonState
					)
				)
			)
		)
	)

	on uiRSpread buttondown do (
		SBA.StoreUIUnDo uiRSpread -- UI 값 수동 UnDo를 위해 UI가 눌리는 순간 원래 값과 UI 오브젝트를 저장하는 함수
		StoreFingersUnDo m_RFingers -- 손가락들 수동 UnDo를 위해 버튼이 눌러지는 순간의 손가락 회전값 기억
	)
	on uiRSpread buttonup do (
		ApplyFingersUnDo m_RFingers -- 손가락들 수동 UnDo를 위해 버튼이 떼어지는 순간 원래 손가락으로 되돌린 후 UnDo로 다시 회전시킨다.
	)
	on uiRSpread changed var do (
		UnDo off (
			SpreadFingers m_RFingers -mc_spreadMaxAngle mc_spreadMaxAngle var uiRBendStart.value uiRBendEnd.value
		)
	)

	on uiLSpread buttondown do (
		SBA.StoreUIUnDo uiLSpread -- UI 값 수동 UnDo를 위해 UI가 눌리는 순간 원래 값과 UI 오브젝트를 저장하는 함수
		StoreFingersUnDo m_LFingers -- 손가락들 수동 UnDo를 위해 버튼이 눌러지는 순간의 손가락 회전값 기억
	)
	on uiLSpread buttonup do (
		ApplyFingersUnDo m_LFingers -- 손가락들 수동 UnDo를 위해 버튼이 떼어지는 순간 원래 손가락으로 되돌린 후 UnDo로 다시 회전시킨다.
	)
	on uiLSpread changed var do (
		UnDo off (
			SpreadFingers m_LFingers mc_spreadMaxAngle -mc_spreadMaxAngle var uiLBendStart.value uiLBendEnd.value
		)
	)

	-- 손가락 구부리는 함수
	function BendFingers fingersArr bendStart bendEnd spread = (
		if (fingersArr.count < 2) do (return()) -- 단순한 구조를 위해 엄지만 있는 경우는 작업하지 않음 (예외 처리가 필요한데, 추후 예외 처리를 할지도 모름)
		
		-- 두 번째 검지손가락부터 끝 손가락까지
		for fingerIndex = 2 to fingersArr.count do (
			-- 다음 tFingerBias 계산 샘플: 예를 들어 다섯 손가락 다 있을 때 i가 5인 새끼손가락은 3 / 3
			local tFingerBias = ((fingerIndex - 2) as float) / ((fingersArr.count - 2) as float) -- 손가락이 얼마나 치우친 위치인지
			-- 시작 최대 각도와 끝 최소 각도를 보간. 기준은 현재 손가락의 위치
			local tWeightedAngle = LerpFloat bendStart bendEnd tFingerBias

			local tSpreadSliderValue = ((tFingerBias - 0.5) * 2.0) * spread * mc_spreadMaxAngle
			-- 일단 뿌리 손가락 한 마디는 m_fingersRootAngleInit을 활용해서 Spread 적용
			-- Bend가 90도로 접히면 X와 Y가 뒤바뀌면서 서로 영향력이 교차 감소해야함. X는 마이너스 방향.
			local tBendY = LerpFloat tSpreadSliderValue 0 ((tWeightedAngle as float) / 90.0)
			local tBendX = LerpFloat 0 -tSpreadSliderValue ((tWeightedAngle as float) / 90.0)
			
			local tRot = eulerToQuat (eulerAngles tWeightedAngle tBendY tBendX) order:6 -- ZYX 순서 (6번) 스피너 var만큼 z 회전한 쿼터니언
			tRot = tRot * fingersArr[fingerIndex][1].parent.transform.rotation
			biped.setTransform fingersArr[fingerIndex][1] #rotation tRot animButtonState

			-- 여기부터 뿌리 이하 마디들
			if (fingersArr[fingerIndex].count >= 2) do (
				for i = 2 to fingersArr[fingerIndex].count do (
					tRot = eulerToQuat (eulerAngles tWeightedAngle 0 0) order:6 -- ZYX 순서 (6번) 스피너 var만큼 z 회전한 쿼터니언
					tRot = tRot * fingersArr[fingerIndex][i].parent.transform.rotation
					biped.setTransform fingersArr[fingerIndex][i] #rotation tRot animButtonState
				)
			)
		)
	)

	on uiRBendEnd buttondown do (SBA.StoreUIUnDo uiRBendEnd;StoreFingersUnDo m_RFingers) -- UI 값 UnDo를 위한 로컬 변수 기억
	on uiRBendEnd buttonup  do (ApplyFingersUnDo m_RFingers)  -- 손가락 수동 UnDo
	on uiRBendEnd changed var do (
		UnDo off (
			BendFingers m_RFingers uiRBendStart.value uiRBendEnd.value uiRSpread.value
		)
	)
	on uiRBendStart buttondown do (SBA.StoreUIUnDo uiRBendStart;StoreFingersUnDo m_RFingers) -- UI 값 UnDo를 위한 로컬 변수 기억
	on uiRBendStart buttonup do (ApplyFingersUnDo m_RFingers) -- 손가락 수동 UnDo
	on uiRBendStart changed var do (
		UnDo off (
			BendFingers m_RFingers uiRBendStart.value uiRBendEnd.value uiRSpread.value
		)
	)
	on uiLBendStart buttondown do (SBA.StoreUIUnDo uiLBendStart;StoreFingersUnDo m_LFingers) -- UI 값 UnDo를 위한 로컬 변수 기억
	on uiLBendStart buttonup do (ApplyFingersUnDo m_LFingers) -- 손가락 수동 UnDo
	on uiLBendStart changed var do (
		UnDo off (
			BendFingers m_LFingers uiLBendStart.value uiLBendEnd.value -uiLSpread.value
		)
	)
	on uiLBendEnd buttondown do (SBA.StoreUIUnDo uiLBendEnd;StoreFingersUnDo m_LFingers) -- UI 값 UnDo를 위한 로컬 변수 기억
	on uiLBendEnd buttonup do (ApplyFingersUnDo m_LFingers) -- 손가락 수동 UnDo
	on uiLBendEnd changed var do (
		UnDo off (
			BendFingers m_LFingers uiLBendStart.value uiLBendEnd.value -uiLSpread.value
		)
	)

	on SBAFingers open do (
		-- 손가락 발가락 롤아웃이 부모와 붙어다니도록 SoxBipedAssist의 이전 위치를 기억하는 변수
		SBAFingersPosBefore = GetDialogPos SBAFingers
		InitFingers()
	)

	on SBAFingers moved newPos do (
		SBAFingersPosBefore = newPos
	)
)

rollout SBAKeyframe "Keyframe Assist" rolledUp:true (
	local mc_setKeyColor = color 255 40 40
	checkButton uiBtnSetAllKey "Set All Key" checked:true highlightColor:mc_setKeyColor offset:[6, 0] across:3
	checkButton uiBtnLimbIK "IK" tooltip:"Shift + Click - apply to all keys, Ctrl + Click - Apply to selected keys. (Shift 클릭 - 모든 키에 적용, Ctrl 클릭 - 선택된 키에 적용)" checked:true highlightColor:(color 207 210 34) offset:[22, 0]
	checkButton uiBtnLimbFK "FK" tooltip:"Shift + Click - apply to all keys, Ctrl + Click - Apply to selected keys. (Shift 클릭 - 모든 키에 적용, Ctrl 클릭 - 선택된 키에 적용)" checked:true highlightColor:(color 153 139 77) offset:[8, 0]
	
	group "Looping" (
		label uiLabelLoopRagne "Loop" tooltip:"Loop Range" align:#left offset:[-4, 2] across:4
		spinner uiSpnLoopStart tooltip:"Loop Range" type:#integer range:[-9999,9999,0] width:40 align:#left offset:[-14, 2]
		spinner uiSpnLoopEnd tooltip:"Loop Range" type:#integer range:[-9999,9999,30] width:40 align:#left offset:[-8, 2]
		button uiBtnGotoMirror "Mirror" tooltip:"Go to Mirror frame" align:#right offset:[6, -2] width:38
		checkButton uiBtnLoopTrim "Trim" width:40 offset:[-5, -2] checked:true highlightColor:mc_setKeyColor tooltip:"Delete keys outside the Loop" across:4
		-- 앞 뒤로 복제 기능은 만들다 중단. (일일이 자세를 복사해주는 방법을 시도했는데 너무 느림)
		-- Shift 복제처럼 KeyArray를 한 방에 복제해주는 방법을 써야할듯. 일반 오브젝트는 복제가 되는데 바이패드는 안됨.
		-- checkButton uiBtnLoopDupe "Dupl." width:40 offset:[6, 0] checked:true highlightColor:(color 60 0 0) tooltip:"Duplicate the keys before and after the Loop."
		checkButton uiBtnLoopSel "Sel." width:40 offset:[4, -2] checked:true highlightColor:(color 198 127 21) align:#center tooltip:"Select keys in the looping range."
		button uiBtnLoopGet "Get" offset:[10, -2] width:30 tooltip:"Get current time"
		button uiBtnLoopSet "Set" offset:[8, -2] width:30
	)
	
	-- 시작 프레임과 끝 프레임 값은 바이패드 루트에 유저 프로퍼티로 기록하지 않음. 불편하면 추후 버전업시 기록할 수 있음.
	group "Process in range" (
		button uiBtnGetProcessRangeStart "Start" tooltip:"Gets the current frame value. Right-click: Change the slider time to the current value." width:34 offset:[-2, 0] across:4
		spinner uiSpnProcessRangeStart tooltip:"Processing Range Start Frame" type:#integer range:[-9999,9999,0] width:36 align:#center offset:[-4, 3]
		button uiBtnGetProcessRangeEnd "End" tooltip:"Gets the current frame value. Right-click: Change the slider time to the current value." width:34 offset:[3, 0]
		spinner uiSpnProcessRangeEnd tooltip:"Processing Range End Frame" type:#integer range:[-9999,9999,30] width:36 align:#center offset:[4, 3]
		
		pickbutton uiPickAnimatedAlignSource "S." tooltip:"Select the Source object for Animated Align" align:#left offset:[-5, 0] across:3
		pickbutton uiPickAnimatedAlignTarget "T." tooltip:"Select the Target object for Animated Align" offset:[-22, 0] align:#left
		button uiBtnAnimatedAlign "Animated Align" align:#right offset:[6, 0]
		
		label uiLabelAnimatedAlignOption "A. Align Option" tooltip:"Animated Align Option" align:#left offset:[-3, 0] across:4
		checkButton uiBtnAnimatedAlignOptionPosition "P" tooltip:"Position" offset:[31, -3] checked:true
		checkButton uiBtnAnimatedAlignOptionRotation "R" tooltip:"Rotation" offset:[20, -3] checked:true
		checkButton uiBtnAnimatedAlignOptionScale "S" tooltip:"Scale" offset:[11, -3] checked:true
	)

	-- Go to Mirror frame 버튼이 작동하기 위한 조건 검사 후 버튼 enable 세팅
	-- 루핑 구간 프레임이 짝수여야하고 일정 수 이상이여야함
	function SetGotoMirrorEnable = (
		--uiBtnGotoMirror
		local fCount = uiSpnLoopEnd.value - uiSpnLoopStart.value
		if (fCount < 2) do (
			uiBtnGotoMirror.enabled = false
			return ()
		)

		local fCountHalf = fCount / 2.0
		-- 홀수인지?
		if float (int fCountHalf) != fCountHalf do (
			uiBtnGotoMirror.enabled = false
			return ()
		)
		uiBtnGotoMirror.enabled = true
	)

	function SetButtonStateKeyframe state = (
		uiBtnSetAllKey.state = state
		uiBtnLimbIK.state = state
		uiBtnLimbFK.state = state
		uiBtnLoopTrim.state = state
		uiBtnLoopSel.state = state
	)

	function LoadRangeLoop = (
		if (SBA.m_workingBipRoot == undefined or (isDeleted SBA.m_workingBipRoot)) do return ()
		try (
			uiSpnLoopStart.value = getUserProp SBA.m_workingBipRoot "SoxBA_RangeLoopStart"
			uiSpnLoopEnd.value = getUserProp SBA.m_workingBipRoot "SoxBA_RangeLoopEnd"
		) catch ()
	)

	function SaveRangeLoop = (
		if (SBA.m_workingBipRoot == undefined or (isDeleted SBA.m_workingBipRoot)) do return ()
		setUserProp SBA.m_workingBipRoot "SoxBA_RangeLoopStart" uiSpnLoopStart.value
		setUserProp SBA.m_workingBipRoot "SoxBA_RangeLoopEnd" uiSpnLoopEnd.value
	)

	-- Keyframe 초기화
	function InitKeyframe = (
		if SBA.m_workingBipRoot == undefined then (
			SetButtonStateKeyframe false
            return ()
		)
		else (
			SetButtonStateKeyframe true
			LoadRangeLoop()
			SetGotoMirrorEnable()
		)
	)

	on uiBtnSetAllKey changed state do (
		uiBtnSetAllKey.state = true
		if (SBA.m_workingBipRoot == undefined or (isDeleted SBA.m_workingBipRoot)) do ( SetButtonStateKeyframe false; return ())
		if (SBA.m_workingBipRoot.transform.controller.figureMode) do (
			messageBox "You cannot add keyframes in Figure mode." title:"Sox Biped Assist Message"
			return ()
		)

		selBackup = selection as array

		-- 미리 저장한 배열에 문제가 있으면 다시 배열을 초기화
		if (SBA.IfExistBips SBA.m_AllBip) == false do (
			SBA.m_AllBip = GetAllBip()
		)
		if (SBA.IfExistBips SBA.m_AllBip) == false do return () -- 그래도 문제가 있으면 그냥 리턴
		
		undo on
		(
			for o in SBA.m_AllBip do
			(
				if ( o == SBA.m_workingBipRoot ) then
				(
					biped.addNewKey o.controller.vertical.controller slidertime
					biped.addNewKey o.controller.horizontal.controller slidertime
					biped.addNewKey o.controller.turning.controller slidertime
				)
				else
				(
					try ( biped.addNewKey o.controller slidertime ) catch ()		-- Footstep 오브젝트때문에 try 처리
				)
			) -- for end
		) -- undo end	
		clearSelection()
		select selBackup
	)

	on uiBtnLimbIK changed state do (
		uiBtnLimbIK.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		local commandModeBefore = getCommandPanelTaskMode() -- biped.setSlidingKey 기능때문에 Motion판넬로 전환하더라도 다시 되돌아오기 위해 저장
		setCommandPanelTaskMode mode:#motion -- biped.setSlidingKey 등의 기능은 Motion판넬에서만 정상 작동한다. 다른 곳에서 하면 엉뚱한 자세가 덮어써짐

		local timeBefore = sliderTime
		disableSceneRedraw()
		undo on (
			for obj in selection do (
				if (SBA.IfLimb obj) do (
					if (keyboard.shiftPressed OR keyboard.controlPressed) then (
						local keys = obj.controller.keys
						local animRangeBackup = animationRange -- 잠시 바깥에 있는 키들도 수정할 수 있도록 현재의 애니메이션 구간을 기억한다.
						animationRange = Interval keys[1].time keys[keys.count].time
						for i = 1 to keys.count do (
							if keyboard.shiftPressed do (
								-- Shift가 눌려있으면 키 선택과 상관 없이 모두 변경
								sliderTime = keys[i].time -- at time 방식으로 하면 sliderTime의 자세로 키가 생성되는 문제가 있어서 실제 sliderTime을 변경시켜서 진행
								biped.setSlidingKey obj
							)
							if keyboard.controlPressed do (
								-- Ctrl이 눌려있으면 선택된 키듦만 변경
								if keys[i].selected == true do (
									sliderTime = keys[i].time -- at time 방식으로 하면 sliderTime의 자세로 키가 생성되는 문제가 있어서 실제 sliderTime을 변경시켜서 진행
									biped.setSlidingKey obj
								)
							)
						)
						animationRange = animRangeBackup -- 다시 원래대로의 애니메이션 구간으로 복구
					)
					else (
						biped.setSlidingKey obj
					)
				)
			) -- for
		) -- Undo
		
		if (commandModeBefore != #motion) do (setCommandPanelTaskMode mode:commandModeBefore) --원래 모션패널이 아니였으면 다시 되돌아간다.
		enableSceneRedraw()
		sliderTime = timeBefore
	)

	on uiBtnLimbFK changed state do (
		uiBtnLimbFK.state = on -- 어떤 상태에서도 버튼 스테이트는 눌려있도록
		local commandModeBefore = getCommandPanelTaskMode() -- biped.setSlidingKey 기능때문에 Motion판넬로 전환하더라도 다시 되돌아오기 위해 저장
		setCommandPanelTaskMode mode:#motion -- biped.setSlidingKey 등의 기능은 Motion판넬에서만 정상 작동한다. 다른 곳에서 하면 엉뚱한 자세가 덮어써짐
		local timeBefore = sliderTime
		disableSceneRedraw()
		undo on (
			for obj in selection do (
				if (SBA.IfLimb obj) do (
					if (keyboard.shiftPressed OR keyboard.controlPressed) then (
						local keys = obj.controller.keys
						local animRangeBackup = animationRange -- 잠시 바깥에 있는 키들도 수정할 수 있도록 현재의 애니메이션 구간을 기억한다.
						animationRange = Interval keys[1].time keys[keys.count].time
						for i = 1 to keys.count do (
							if keyboard.shiftPressed do (
								-- Shift가 눌려있으면 키 선택과 상관 없이 모두 변경
								sliderTime = keys[i].time -- at time 방식으로 하면 sliderTime의 자세로 키가 생성되는 문제가 있어서 실제 sliderTime을 변경시켜서 진행
								biped.setFreeKey obj
							)
							if keyboard.controlPressed do (
								-- Ctrl이 눌려있으면 선택된 키듦만 변경
								if keys[i].selected == true do (
									sliderTime = keys[i].time -- at time 방식으로 하면 sliderTime의 자세로 키가 생성되는 문제가 있어서 실제 sliderTime을 변경시켜서 진행
									biped.setFreeKey obj
								)
							)
						)
						animationRange = animRangeBackup -- 다시 원래대로의 애니메이션 구간으로 복구
					)
					else (
						biped.setFreeKey obj
					)
				)
			) -- for
		) -- Undo
		if (commandModeBefore != #motion) do (setCommandPanelTaskMode mode:commandModeBefore) --원래 모션패널이 아니였으면 다시 되돌아간다.
		enableSceneRedraw()
		sliderTime = timeBefore
	)

	on uiSpnLoopStart changed var do (
		SaveRangeLoop()
		SetGotoMirrorEnable() -- Go to Mirror frame 버튼 활성/비활성 설정
	)
	on uiSpnLoopEnd changed var do (
		SaveRangeLoop()
		SetGotoMirrorEnable() -- Go to Mirror frame 버튼 활성/비활성 설정
	)

	on uiBtnGotoMirror pressed do (
		local now = int sliderTime
		if (now < uiSpnLoopStart.value) OR (now > uiSpnLoopEnd.value) do return ()

		if now == uiSpnLoopEnd.value do (now = uiSpnLoopStart.value) -- 루프 끝 프레임에서 버튼이 눌러졌으면 첫 프레임으로 간주함
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

	function LoopTrim = (
		undo on (
			for obj in selection do (
				SBA.DeselectAllKeys obj
				if (SBA.IfBipRoot obj) == false then (
					-- COM이 아니거나 일반 오브젝트인 경우
					if (classof obj.baseobject == Biped_Object) then (
						SBA.TrimKeys obj.controller uiSpnLoopStart.value uiSpnLoopEnd.value true
					)
					else (
						SBA.TrimKeys obj.controller uiSpnLoopStart.value uiSpnLoopEnd.value false
					)
				)
				else (
					-- COM인 경우
					SBA.TrimKeys obj.controller.Vertical.controller uiSpnLoopStart.value uiSpnLoopEnd.value true
					SBA.TrimKeys obj.controller.Horizontal.controller uiSpnLoopStart.value uiSpnLoopEnd.value true
					SBA.TrimKeys obj.controller.Turning.controller uiSpnLoopStart.value uiSpnLoopEnd.value true
				)
			)
		)
	)

	on uiBtnLoopTrim changed state do (
		uiBtnLoopTrim.state = true
		LoopTrim()
	)

	/*
	-- 앞 뒤로 복제 기능은 만들다 중단. (일일이 자세를 복사해주는 방법을 시도했는데 너무 느림)
	function LoopDupeCOM bip = (
		disableSceneRedraw()
		-- Turning
		local loopLength = uiSpnLoopEnd.value - uiSpnLoopStart.value
		local keyCount = numKeys bip.controller.Turning.controller
		-- 중요. 키 자체를 배열로 얻어오면 키를 추가하는 과정에서 인덱스가 다 꼬인다. 배열을 deepCopy로 복사하든 뭘 하든 방법이 없음
		-- 그래서 복사할 키의 시간을 배열로 준비해두는 방법을 사용함
		local refKeyTimes = #() -- 루프 키를 추가하기 전에 미리 다 얻어두어야함.
		for i = 1 to keyCount do (
			append refKeyTimes (getKey bip.controller.Turning.controller i).time
		)

		for i = 1 to keyCount do (
			local newTimeBefore = refKeyTimes[i] - loopLength
			local newTimeAfter = refKeyTimes[i] + loopLength
			sliderTime = refKeyTimes[i] -- 원본 회전값을 얻어올 시간으로 점프
			local refRot = biped.getTransform bip #rotation 
			--Before
			if (newTimeBefore != refKeyTimes[1]) do (
				-- Before의 복사하는 마지막 키가 원본 키의 첫 키와 같은 위치면 복사 안함
				sliderTime = newTimeBefore
				biped.setTransform bip #rotation refRot true
			)
			--After
			if (newTimeAfter != refKeyTimes[refKeyTimes.count]) do (
				-- After의 복사하는 첫 키가 원본 키의 마지막 키와 같은 위치면 복사 안함
				sliderTime = newTimeAfter
				biped.setTransform bip #rotation refRot true
			)

			-- 앞 뒤 키를 생성한 후 세부 값들 복제
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

		-- Horizontal, Vertical 을 키 찍기 전에 미리 준비하는 이유 : biped.setTransform bip #pos 는 가로 세로 따지지 않고 키를 생성하므로
		-- Horizontal 준비
		keyCount = numKeys bip.controller.Horizontal.controller
		local refKeyTimesHor = #() -- 루프 키를 추가하기 전에 미리 다 얻어두어야함.
		for i = 1 to keyCount do (
			append refKeyTimesHor (getKey bip.controller.Horizontal.controller i).time
		)
		-- Vertical 준비
		keyCount = numKeys bip.controller.Vertical.controller
		local refKeyTimesVer = #() -- 루프 키를 추가하기 전에 미리 다 얻어두어야함.
		for i = 1 to keyCount do (
			append refKeyTimesVer (getKey bip.controller.Vertical.controller i).time
		)

		-- Horizontal
		for i = 1 to refKeyTimesHor.count do (
			local newTimeBefore = refKeyTimesHor[i] - loopLength
			local newTimeAfter = refKeyTimesHor[i] + loopLength
			sliderTime = refKeyTimesHor[i] -- 원본 위치값을 얻어올 시간으로 점프
			local refPos = biped.getTransform bip #pos
			--Before
			if (newTimeBefore != refKeyTimesHor[1]) do (
				-- Before의 복사하는 마지막 키가 원본 키의 첫 키와 같은 위치면 복사 안함
				sliderTime = newTimeBefore
				biped.setTransform bip #pos refPos true
			)
			--After
			if (newTimeAfter != refKeyTimesHor[refKeyTimesHor.count]) do (
				-- After의 복사하는 첫 키가 원본 키의 마지막 키와 같은 위치면 복사 안함
				sliderTime = newTimeAfter
				biped.setTransform bip #pos refPos true
			)
			-- Vertical 시간들을 기록한 배열에서 Hor 시간을 찾을 수 없으면 Vertical 키 삭제
			if (findItem refKeyTimesVer refKeyTimesHor[i]) == 0 do (
				selectKeys bip.controller.Vertical.controller newTimeBefore
				selectKeys bip.controller.Vertical.controller newTimeAfter
				biped.deleteKeys bip.controller.Vertical.controller #selection
			)

			-- 앞 뒤 키를 생성한 후 세부 값들 복제
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
			sliderTime = refKeyTimesVer[i] -- 원본 위치값을 얻어올 시간으로 점프
			local refPos = biped.getTransform bip #pos
			--Before
			if (newTimeBefore != refKeyTimesVer[1]) do (
				-- Before의 복사하는 마지막 키가 원본 키의 첫 키와 같은 위치면 복사 안함
				sliderTime = newTimeBefore
				biped.setTransform bip #pos refPos true
			)
			--After
			if (newTimeAfter != refKeyTimesVer[refKeyTimesVer.count]) do (
				-- After의 복사하는 첫 키가 원본 키의 마지막 키와 같은 위치면 복사 안함
				sliderTime = newTimeAfter
				biped.setTransform bip #pos refPos true
			)
			-- Horizontal 시간들을 기록한 배열에서 Vertical 시간을 찾을 수 없으면 Horizontal 키 삭제
			if (findItem refKeyTimesHor refKeyTimesVer[i]) == 0 do (
				selectKeys bip.controller.Horizontal.controller newTimeBefore
				selectKeys bip.controller.Horizontal.controller newTimeAfter
				biped.deleteKeys bip.controller.Horizontal.controller #selection
			)

			-- 앞 뒤 키를 생성한 후 세부 값들 복제
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

	function LoopDupeLimb bip = (
		disableSceneRedraw()

		local loopLength = uiSpnLoopEnd.value - uiSpnLoopStart.value
		local bipKeys = bip.controller.keys


		enableSceneRedraw()
	)

	on uiBtnLoopDupe changed state do (
		uiBtnLoopDupe.state = true
		LoopTrim() -- 복제 전에 범위 밖의 키들을 모두 날린다.
		if (SBA.IfExistBips SBA.m_AllBip) == false do return ()
		for bip in SBA.m_AllBip do (
			local keyTypeStr = GetBipKeyType bip
			case keyTypeStr of (
				"COM": (LoopDupeCOM bip)
				"Limb": (LoopDupeLimb bip)
				"Etc": ()
				"NoKey": ()
			)
		)
	)
	*/

	on uiBtnLoopSel changed state do (
		uiBtnLoopSel.state = true

		for obj in selection do (
			SBA.DeselectAllKeys obj
			-- 선택시 컨트롤러는 세부 컨트롤러 명시 없어도 대충 잘 선택해줌
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

	on uiBtnGetProcessRangeStart pressed do (
		uiSpnProcessRangeStart.value = slidertime.frame
		if (uiSpnProcessRangeEnd.value < uiSpnProcessRangeStart.value) do (
			uiSpnProcessRangeEnd.value = uiSpnProcessRangeStart.value
		)
	)
	on uiBtnGetProcessRangeStart rightclick do (
		sliderTime = (uiSpnProcessRangeStart.value as time)
	)
	on uiBtnGetProcessRangeEnd pressed do (
		uiSpnProcessRangeEnd.value = slidertime.frame
		if (uiSpnProcessRangeStart.value > uiSpnProcessRangeEnd.value) do (
			uiSpnProcessRangeStart.value = uiSpnProcessRangeEnd.value
		)
	)
	on uiBtnGetProcessRangeEnd rightclick do (
		sliderTime = (uiSpnProcessRangeEnd.value as time)
	)

	on uiPickAnimatedAlignSource picked obj do (
		uiPickAnimatedAlignSource.tooltip = "The name of the source object is " + obj.name
	)
	on uiPickAnimatedAlignSource rightclick do (
		if (uiPickAnimatedAlignSource.object == undefined or (isDeleted uiPickAnimatedAlignSource.object)) do return()
		select uiPickAnimatedAlignSource.object
	)
	on uiPickAnimatedAlignTarget picked obj do (
		uiPickAnimatedAlignTarget.tooltip = "The name of the target object is " + obj.name
	)
	on uiPickAnimatedAlignTarget rightclick do (
		if (uiPickAnimatedAlignTarget.object == undefined or (isDeleted uiPickAnimatedAlignTarget.object)) do return()
		select uiPickAnimatedAlignTarget.object
	)

    -- 지정된 프레임에 컨트롤러의 애니메이션 키가 있는지 검사하여 있으면 true 리턴. 자동으로 0프레임에 생기는 키를 제어하기 위해 직접 frame 번호를 지정하는 방식의 함수로 구성함
    function IsKeyAtFrame controller frame = (
        keysCount = controller.keys.count
        if keysCount == 0 do (return false) -- 키가 아무것도 없으면 false 리턴
        for i = 1 to keysCount do (
            keyTime = controller.keys[i].time
            if (keyTime == frame) do (return true)
        )
        return false    -- 현재 시간과 일치하는 키가 없으면 false 리턴
    )

    -- 지정된 프레임의 키를 지운다. 자동으로 0프레임에 생기는 키를 제어하기 위해 직접 frame 번호를 지정하는 방식의 함수로 구성함
    function DeleteKeyAtTime controller frame = (
        keysCount = controller.keys.count
        if keysCount == 0 do return () -- 키가 아무것도 없으면 그냥 리턴
        for i = 1 to keysCount do (
            keyTime = controller.keys[i].time
            if (keyTime == frame) do (
                deleteKey controller i
                return()    -- 발견 즉시 리턴을 하지 않으면 다음 반복에서 keys 배열 숫자가 줄어들면서 에러가 발생한다.
            )
        )
    )

	on uiBtnAnimatedAlign pressed do (
        local source = uiPickAnimatedAlignSource.object
        local target = uiPickAnimatedAlignTarget.object
		if (source == undefined or (isDeleted source)) do return()
		if (target == undefined or (isDeleted target)) do return()
		local sliderTimeBackup = sliderTime
		undo on (
			animate on (
				local forStart = (uiSpnProcessRangeStart.value as integer)
				local forEnd = (uiSpnProcessRangeEnd.value as integer)
				for o = forStart to forEnd do (
					sliderTime = (o as time)
                    -- PRS 옵션에 의한 Align 작동은 다양한 컨트롤러의 예외를 최소화 하기 위해 Matrix 방식으로 처리한다.
                    local targetMatrix = target.transform
                    local sourceMatrix = source.transform
                    local tempMatrix = matrix3 1    -- identity matrix
                    -- Animated Align 옵션을 기준으로 타겟의 원래 트랜스폼 정보를 유지, Matrix 적용 순서를 Scale > Rotation > Position 순서로 적용해야 매트릭스가 유지됨.
					if (uiBtnAnimatedAlignOptionScale.state) then (tempMatrix = tempMatrix * (scaleMatrix sourceMatrix.scale)) else (tempMatrix = tempMatrix * (scaleMatrix targetMatrix.scale))
                    if (uiBtnAnimatedAlignOptionRotation.state) then (tempMatrix = tempMatrix * (sourceMatrix.rotation as matrix3)) else (tempMatrix = tempMatrix * (targetMatrix.rotation as matrix3))
                    if (uiBtnAnimatedAlignOptionPosition.state) then (tempMatrix = tempMatrix * (transMatrix sourceMatrix.position)) else (tempMatrix = tempMatrix * (transMatrix targetMatrix.position))
                    -- 여기까지 하면 tempMatrix에 Position, Rotation, Scale 모두 적용됨.

                    -- 이후 3가지 경우의 수에 대해 Align 처리
                    -- 1. Transform:Position/Rotation/Scale 컨트롤러에 대한 처리
                    -- 2. Biped Root에 대한 처리
                    -- 3. 1번도 2번도 아닌 경우 그냥 트랜스폼으로 처리 (강력한 방식이지만 드문 예외 케이스에서 에러가 발생할 수 있음)

                    local controllerClass = classof target.transform.controller
                    case controllerClass of (
                        -- 1번, Transform:Position/Rotation/Scale 컨트롤러에 대한 처리
                        prs: (
                            -- 꺼진 옵션은 타겟의 원래존 키를 보존하기 위해서 타겟에 원래 키가 없었다면 방금 생성된 키를 삭제해야함. 타겟에 원래 키가 있었다면 방금 생성된 키는 원래 키와 같으니 그대로 둔다.
                            -- Align 키를 PRS 모두 생성하기 전에 타겟에 원래 키가 있었는지 조사
                            local ifTargetKeyExistPosition = IsKeyAtFrame target.position.controller sliderTime
                            local ifTargetKeyExistRotation = IsKeyAtFrame target.rotation.controller sliderTime
                            local ifTargetKeyExistScale = IsKeyAtFrame target.scale.controller sliderTime
                            
                            -- 0프레임에 자동 키가 생성되지 않도록 하기 위해 강제로 현재 프레임에만 키를 하나 생성한다. (0프레임 키 자동 생성 옵션을 끄는 것이 스크립트로 지원하지 않아서 이런 편법을 사용함.)
                            addNewKey target.position.controller sliderTime
                            addNewKey target.rotation.controller sliderTime
                            addNewKey target.scale.controller sliderTime
                            target.transform = tempMatrix   -- PRS 모든 키 생성.
                            
                            -- 옵션이 꺼져있는데 원래 키도 없었다면 방금 생성된 키를 지운다.
                            if (uiBtnAnimatedAlignOptionPosition.state == false AND ifTargetKeyExistPosition == false) do (DeleteKeyAtTime target.position.controller sliderTime)
                            if (uiBtnAnimatedAlignOptionRotation.state == false AND ifTargetKeyExistRotation == false) do (DeleteKeyAtTime target.rotation.controller sliderTime)
                            if (uiBtnAnimatedAlignOptionScale.state == false AND ifTargetKeyExistScale == false) do (DeleteKeyAtTime target.scale.controller sliderTime)
                        )
                        -- 2번, Biped Root에 대한 처리
                        Vertical_Horizontal_Turn: (
                            if (uiBtnAnimatedAlignOptionPosition.state) do (biped.setTransform target #pos tempMatrix.position true)
                            if (uiBtnAnimatedAlignOptionRotation.state) do (biped.setTransform target #rotation tempMatrix.rotation true)
                        )
                        -- 1번도 2번도 아닌 경우 그냥 트랜스폼으로 처리 (강력한 방식이지만 드문 예외 케이스에서 에러가 발생할 수 있음)
                        default: (
                            target.transform = tempMatrix   -- PRS 모든 키 생성.
                        )
                    )
				)
			)
		)
		sliderTime = sliderTimeBackup
	)

	on SBAKeyframe open do (
		SBAKeyframePosBefore = GetDialogPos SBAKeyframe
		InitKeyframe()
	)

	on SBAKeyframe moved newPos do (
		SBAKeyframePosBefore = newPos
	)
)

rollout SBAAnimation "Animation" rolledUp:true (
	spinner uiSpnAnimRangeAStart type:#integer range:[-9999,9999,0] width:40 offset:[-10, 0] across:4
    spinner uiSpnAnimRangeAEnd type:#integer range:[-9999,9999,30] width:40
    button uiBtnAnimRangeAGet "Get" offset:[12, -2] width:30 tooltip:"Get current time"
    button uiBtnAnimRangeASet "Set" offset:[10, -2] width:30
    
    spinner uiSpnAnimRangeBStart type:#integer range:[-9999,9999,-20] width:40 offset:[-10, 0] across:4
    spinner uiSpnAnimRangeBEnd type:#integer range:[-9999,9999,30] width:40
    button uiBtnAnimRangeBGet "Get" offset:[12, -2] width:30 tooltip:"Get current time"
    button uiBtnAnimRangeBSet "Set" offset:[10, -2] width:30
    
    /*
    spinner uiSpnAnimRangeCStart type:#integer range:[-9999,9999,0]width:40 offset:[-10, 0] across:4
    spinner uiSpnAnimRangeCEnd type:#integer range:[-9999,9999,50] width:40
    button uiBtnAnimRangeCGet "Get" offset:[10, -2] tooltip:"Get current time"
    button uiBtnAnimRangeCSet "Set" offset:[10, -2]
    */

    local mc_gotoSize = 20
	button uiBtnGoto1 align:#center offset:[-6, -6] width:mc_gotoSize across:8
	button uiBtnGoto2 align:#center offset:[-5, -6] width:mc_gotoSize
	button uiBtnGoto3 align:#center offset:[-4, -6] width:mc_gotoSize
	button uiBtnGoto4 align:#center offset:[-3, -6] width:mc_gotoSize
	button uiBtnGoto5 align:#center offset:[3, -6] width:mc_gotoSize
	button uiBtnGoto6 align:#center offset:[4, -6] width:mc_gotoSize
	button uiBtnGoto7 align:#center offset:[5, -6] width:mc_gotoSize
	button uiBtnGoto8 align:#center offset:[6, -6] width:mc_gotoSize
	
	dropdownlist uiDropPlaySpeed items:#("1/4x Speed", "1/2x Speed", " 1x Speed", "2x Speed", "4x Speed") selection:3 tooltip:"Playback Speed" width:90 offset:[-8, 0] across:2
	checkbutton uiPlayBlock "Play.B" offset:[14, 0] width:54 highlightColor:(color 161 134 25) tooltip:"Play blocking animation of selected biped objects"
	timer clock "PlayClock" interval:1 active:false -- 가장 빠른 인터벌로
    --------------------- UI 끝

    local m_goto1; local m_goto2; local m_goto3; local m_goto4; local m_goto5; local m_goto6; local m_goto7; local m_goto8
    local m_PBKeyTimeArray      -- 블럭킹 애니메이션용 키 타임 배열 로컬 변수 (Frame)
    local m_PBKeyMiliSecArray  -- 블럭킹 애니메이션용 키 타임 배열 로컬 변수 (밀리세컨드)
    local m_PBStartTime     -- 블럭킹 애니메이션 반복 시작시간 비교용 기록
    local m_PBPointer       -- 어디까지 재생중인지 기록하는 포인터
    local m_PBPlaySpeed     -- 재생 속도 가속 감속용, uiDropPlaySpeed 와 연동됨

    function SaveRangeA = (
		if (SBA.m_workingBipRoot == undefined or (isDeleted SBA.m_workingBipRoot)) do return ()
		setUserProp SBA.m_workingBipRoot "SoxBA_RangeAStart" uiSpnAnimRangeAStart.value
		setUserProp SBA.m_workingBipRoot "SoxBA_RangeAEnd" uiSpnAnimRangeAEnd.value
	)

	function LoadRangeA = (
		if (SBA.m_workingBipRoot == undefined or (isDeleted SBA.m_workingBipRoot)) do return ()
		try (
			uiSpnAnimRangeAStart.value = getUserProp SBA.m_workingBipRoot "SoxBA_RangeAStart"
			uiSpnAnimRangeAEnd.value = getUserProp SBA.m_workingBipRoot "SoxBA_RangeAEnd"
		) catch ()
	)

	function SaveRangeB = (
		if (SBA.m_workingBipRoot == undefined or (isDeleted SBA.m_workingBipRoot)) do return ()
		setUserProp SBA.m_workingBipRoot "SoxBA_RangeBStart" uiSpnAnimRangeBStart.value
		setUserProp SBA.m_workingBipRoot "SoxBA_RangeBEnd" uiSpnAnimRangeBEnd.value
	)

	function LoadRangeB = (
		if (SBA.m_workingBipRoot == undefined or (isDeleted SBA.m_workingBipRoot)) do return ()
		try (
			uiSpnAnimRangeBStart.value = getUserProp SBA.m_workingBipRoot "SoxBA_RangeBStart"
			uiSpnAnimRangeBEnd.value = getUserProp SBA.m_workingBipRoot "SoxBA_RangeBEnd"
		) catch ()
	)

    function LoadGoto = (
		if (SBA.m_workingBipRoot == undefined or (isDeleted SBA.m_workingBipRoot)) do return ()
		try (
			m_goto1 = getUserProp SBA.m_workingBipRoot "SoxBA_Goto1"
			if (m_goto1 == "undefined") do (m_goto1 = undefined)
			m_goto2 = getUserProp SBA.m_workingBipRoot "SoxBA_Goto2"
			if (m_goto2 == "undefined") do (m_goto2 = undefined)
			m_goto3 = getUserProp SBA.m_workingBipRoot "SoxBA_Goto3"
			if (m_goto3 == "undefined") do (m_goto3 = undefined)
			m_goto4 = getUserProp SBA.m_workingBipRoot "SoxBA_Goto4"
			if (m_goto4 == "undefined") do (m_goto4 = undefined)
			m_goto5 = getUserProp SBA.m_workingBipRoot "SoxBA_Goto5"
			if (m_goto5 == "undefined") do (m_goto5 = undefined)
			m_goto6 = getUserProp SBA.m_workingBipRoot "SoxBA_Goto6"
			if (m_goto6 == "undefined") do (m_goto6 = undefined)
			m_goto7 = getUserProp SBA.m_workingBipRoot "SoxBA_Goto7"
			if (m_goto7 == "undefined") do (m_goto7 = undefined)
			m_goto8 = getUserProp SBA.m_workingBipRoot "SoxBA_Goto8"
			if (m_goto8 == "undefined") do (m_goto8 = undefined)
		) catch ()
	)

    function SaveGoto ui val index = (
		if (SBA.m_workingBipRoot == undefined or (isDeleted SBA.m_workingBipRoot)) do return ()
		local pString = "SoxBA_Goto" + (index as string)
		try (
			setUserProp SBA.m_workingBipRoot pString val
		) catch ()
	)

	function SetGotoBtnTextSub ui val = (
		local tString
		if (val == undefined) then (tString = "") else (tString = (val as string))
		ui.text = tString
		ui.tooltip = tString
	)

	function SetGotoBtnText = (
		SetGotoBtnTextSub uiBtnGoto1 m_goto1
		SetGotoBtnTextSub uiBtnGoto2 m_goto2
		SetGotoBtnTextSub uiBtnGoto3 m_goto3
		SetGotoBtnTextSub uiBtnGoto4 m_goto4
		SetGotoBtnTextSub uiBtnGoto5 m_goto5
		SetGotoBtnTextSub uiBtnGoto6 m_goto6
		SetGotoBtnTextSub uiBtnGoto7 m_goto7
		SetGotoBtnTextSub uiBtnGoto8 m_goto8
	)

	-- m_goto1 등의 변수를 참조 형식으로 &val 매개변수에 전달
	function GotoFrame ui &val index = (
		if (keyboard.controlPressed) do (
			val = int sliderTime
			SetGotoBtnText()
			SaveGoto ui val index
			return ()
		)

		if (keyboard.altPressed) do (
			val = undefined
			SetGotoBtnText()
			SaveGoto ui val index
			return ()
		)

		if (val != undefined) do (
			try (
				sliderTime = val
			) catch ()
		)
	)

	function SetButtonStateAnimation state = (
		uiPlayBlock.state = state
	)

	function SetPBPlaySpeed = (
        case timeConfiguration.playbackSpeed of (
        1: (m_PBPlaySpeed = 4.0) -- 1/4 속도라서 4배 더 큰 시간 값을 적용해야함
        2: (m_PBPlaySpeed = 2.0)
        3: (m_PBPlaySpeed = 1.0)
        4: (m_PBPlaySpeed = 0.5)
        5: (m_PBPlaySpeed = 0.25) -- 4배 속도라서 0.25배 작은 시간값을 적용해야함
        )
    )

	-- Animation 초기화
	function InitAnimation = (
		if SBA.m_workingBipRoot == undefined then (
			SetButtonStateAnimation false
            return ()
		)
		else (
			SetButtonStateAnimation true
			LoadRangeA()
			LoadRangeB()
			LoadGoto()
			SetGotoBtnText()
			uiDropPlaySpeed.selection = timeConfiguration.playbackSpeed
			uiPlayBlock.state = false
			clock.active = false

			m_PBKeyTimeArray = #()
			m_PBKeyMiliSecArray = #()
			SetPBPlaySpeed()
		)
	)

    on uiSpnAnimRangeAStart changed var do (
		SaveRangeA()
	)
	on uiSpnAnimRangeAEnd changed var do (
		SaveRangeA()
	)
	on uiSpnAnimRangeBStart changed var do (
		SaveRangeB()
	)
	on uiSpnAnimRangeBEnd changed var do (
		SaveRangeB()
	)

    on uiBtnAnimRangeAGet pressed do (
		undo on (
			uiSpnAnimRangeAStart.value = animationRange.start as integer / TicksPerFrame
			uiSpnAnimRangeAEnd.value = animationRange.end as integer / TicksPerFrame
			SaveRangeA()
		)
	)
	
	on uiBtnAnimRangeBGet pressed do (
		undo on (
			uiSpnAnimRangeBStart.value = animationRange.start as integer / TicksPerFrame
			uiSpnAnimRangeBEnd.value = animationRange.end as integer / TicksPerFrame
			SaveRangeB()
		)
	)
	
	/*on uiBtnAnimRangeCGet pressed do (
		undo on (
			uiSpnAnimRangeCStart.value = animationRange.start as integer / TicksPerFrame
			uiSpnAnimRangeCEnd.value = animationRange.end as integer / TicksPerFrame
		)
	)*/
	
	on uiBtnAnimRangeASet pressed do (
		undo on (
			tFrame = uiSpnAnimRangeAEnd.value
			if ( uiSpnAnimRangeAStart.value == tFrame ) do ( tFrame += 1 )
			animationRange = interval (uiSpnAnimRangeAStart.value as time) (tFrame as time)
		)
	)
	
	on uiBtnAnimRangeBSet pressed do (
		undo on (
			tFrame = uiSpnAnimRangeBEnd.value
			if ( uiSpnAnimRangeBStart.value == tFrame ) do ( tFrame += 1 )
			animationRange = interval (uiSpnAnimRangeBStart.value as time) (tFrame as time)
		)
	)
	
	/*on uiBtnAnimRangeCSet pressed do (
		undo on (
			tFrame = uiSpnAnimRangeCEnd.value
			if ( uiSpnAnimRangeCStart.value == tFrame ) do ( tFrame += 1 )
			animationRange = interval (uiSpnAnimRangeCStart.value as time) (tFrame as time)
		)
	)*/

	-- GotoFrame함수에 m_goto1 등의 변수는 참조 형식으로 전달
	on uiBtnGoto1 pressed do (GotoFrame uiBtnGoto1 &m_goto1 1)
	on uiBtnGoto2 pressed do (GotoFrame uiBtnGoto2 &m_goto2 2)
	on uiBtnGoto3 pressed do (GotoFrame uiBtnGoto3 &m_goto3 3)
	on uiBtnGoto4 pressed do (GotoFrame uiBtnGoto4 &m_goto4 4)
	on uiBtnGoto5 pressed do (GotoFrame uiBtnGoto5 &m_goto5 5)
	on uiBtnGoto6 pressed do (GotoFrame uiBtnGoto6 &m_goto6 6)
	on uiBtnGoto7 pressed do (GotoFrame uiBtnGoto7 &m_goto7 7)
	on uiBtnGoto8 pressed do (GotoFrame uiBtnGoto8 &m_goto8 8)

	on uiDropPlaySpeed selected sel do (
        timeConfiguration.playbackSpeed = sel
        SetPBPlaySpeed()
    )

    -- 프레임을 틱으로, 틱을 밀리세컨드로 (integer 리턴)
    function FramToMilisecond frame = (
		-- animationRange.start를 빼주지 않으면 0프레임이 아닌 곳에서 시작할 때 딜레이 발생함
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
        -- 애니메이션 레인지의 시작과 끝은 무조건 포함시킴
        appendifUnique m_PBKeyMiliSecArray (FramToMilisecond animationRange.start)
        appendifUnique m_PBKeyTimeArray animationRange.start
        appendifUnique m_PBKeyMiliSecArray (FramToMilisecond animationRange.end)
        appendifUnique m_PBKeyTimeArray animationRange.end
	)
	
	function StopBlocking = (
        clock.active = false
        uiPlayBlock.state = false
        uiPlayBlock.text = "Play.B"
	)
    
    function PlayBlocking = (
		m_PBKeyTimeArray = #() -- 블럭킹 애니메이션용 키 타임 배열 로컬 변수 (Frame)
        m_PBKeyMiliSecArray = #() -- 블럭킹 애니메이션용 키 타임 배열 로컬 변수 (밀리세컨드)
        local nowTime = timeStamp()
        for obj in selection do (
            if (classof obj.baseObject) == Biped_Object do (
                if (SBA.IfBipRoot obj) then (
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
			return() -- 일반 오브젝트를 선택하면 배열이 비어있음
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
		sliderTime = m_PBKeyTimeArray[m_PBPointer] -- 일단 슬라이더 타임을 동기화 (안하면 강제로 스톱됨)
		clock.active = true
		uiPlayBlock.text = "Stop"
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
    
    -- Play Blocking용 틱 이벤트 처리
    on clock tick do (
        if (m_PBPointer > m_PBKeyMiliSecArray.count) do return()
		local now = timeStamp()
		local pointer
		if (m_PBKeyMiliSecArray.count == m_PBPointer) then (
			ReplayBlocking()
			pointer = 1
		)
		else (
			pointer = m_PBStartTime + m_PBKeyMiliSecArray[m_PBPointer + 1] -- 다음 키프레임과 현재 시간을 비교
		)
        
        -- 현재 시간이 다음 프레임을 넘어서면 포인터 증가, 슬라이더 변경
        if ( now > pointer ) do (
            m_PBPointer += 1
            sliderTime = m_PBKeyTimeArray[m_PBPointer]
        )
        
        -- 포인터가 마지막 프레임을 가리키면 처음으로 되돌리고 시작시간 리셋
        if (m_PBPointer >= m_PBKeyMiliSecArray.count) do (
            ReplayBlocking()
        )

        if keyboard.escPressed do (
            StopBlocking()
		)
		
		-- 외부 요인에 의해 강제로 슬라이더 시간이 변경되면 사용자에 의한 플레이 취소로 간주
		if (sliderTime != m_PBKeyTimeArray[m_PBPointer]) do (
			StopBlocking()
		)
    )

    on SBAAnimation open do (
		SBAAnimationPosBefore = GetDialogPos SBAAnimation
		InitAnimation()
	)

	on SBAAnimation moved newPos do (
		SBAAnimationPosBefore = newPos
	)
)

/*
발가락 기능 보류
rollout SBAToes "Toes"
(
	local mc_greenColor = color 6 134 6
	local mc_blueColor = color 28 28 177
	
	button uiBtnTest "Test"

	on SBAToes open do (
		-- 손가락 발가락 롤아웃이 부모와 붙어다니도록 SoxBipedAssist의 이전 위치를 기억하는 변수
		SBAToesPosBefore = GetDialogPos SBAToes
	)

	on SBAToes moved newPos do (
		SBAToesPosBefore = newPos
	)
)
*/

createDialog SBA style:#(#style_titlebar, #style_toolwindow, #style_sysmenu) lockWidth:true

-- 다음 내용은 플로터 위에 확장형 롤아웃을 올리는 방식의 롤아웃 코드인데 사용하지 않음. 참고용으로 남겨둠
--SBAFloater = newrolloutfloater "Sox BipedAssist v0.503" 180 480 lockHeight:true lockWidth:true
--addrollout SBA SBAFloater
--addrollout SBAKeyframe SBAFloater

/*
다이얼로그, 롤아웃 관련 메모
다음은 참고 링크들
https://help.autodesk.com/view/MAXDEV/2023/ENU/?guid=GUID-A72112A6-BDFB-47A6-88FB-8D49C4CBD049
https://help.autodesk.com/view/MAXDEV/2024/ENU/?guid=GUID-816D257C-CD2D-4753-A792-6E7AEFAFA6A7
https://help.autodesk.com/view/MAXDEV/2023/ENU/?guid=GUID-DC435555-362D-4A03-BCF2-21179C5442F2
롤아웃 플로터를 깔고 그 위에 롤아웃을 올리는 방식으로 하지 않았음.
다이얼로그 창을 개별적으로 여는 방식을 선택한 이유에 대해서...
두 방식이 서로 장단점이 있는데, 롤아웃 플로터에 롤아웃을 올리는 방식의 단점은,
1. 창의 헤더 부분을 마우스로 끌고 드래그 하기 불편함
2. 롤아웃 창마다 서로 다른 가로 폭을 지정할 수 없음.
*/