--만든이 : 이상원
--사용 환경 : Max 2014 이상
-- 이 스크립트를 사용하거나 수정하는 것은 자유입니다. 하지만 재 배포는 허용하지 않습니다.
-- You can : Use, Edit
-- You cannot : ReDistribute

/*
메모
numKeys $.rotation.controller
numKeys $.position.controller
(getKey $.rotation.controller[1].controller 2).time
(getKey $.position.controller[1].controller 2).time
-- time, selected, value 등등
-- TCB, XYZ 컨트롤러 정도만 한정해서 지원해야할듯
*/

global SoxFbxToBiped		-- SoxFbxToBiped 롤아웃명을 글로벌 변수로 인식하기 위해 초기에 한 번 사용

try (destroydialog SoxFbxToBiped) catch()		-- 혹시 열려있는 SoxFbxToBiped 있으면 강제 종료

rollout SoxFbxToBiped "Sox Fbx to Biped v0.31" width:280
(
	button uiBtnScanRoot "Scan Root" across:4
	button uiBtnLoad "Load"
	button uiBtnSaveAs "SaveAs"
	button uiBtnReset "Reset"
	group "Options" (
		radiobuttons uiRBtnLoadingType "Loading type" labels:#("Name", "Handle") default:1
		checkbox uiCBoxAutoHide "Auto hide after Set" across:2
		checkbox uiCBoxNonBipedMode "Non Biped Mode"
-- 		checkbox uiCBoxExistingKey "Use existing keys"
-- 		spinner uiSpnThickHor "Thick. Hor." across:2
-- 		spinner uiSpnThickVer "Thick. Ver."
	)
	
	button uiBtnSetRootFbx "Set Fbx Root" across:2
	button uiBtnSetRootBip "Set Biped Root"
	
	label uiLabelRootFbx across:2
	label uiLabelRootBip
	
	button uiBtnSetFbx "Set FBX" across:4
	button uiBtnClearFbx "Clear FBX"
	button uiBtnSetBip "Set Bip"
	button uiBtnClearBip "Clear Bip"
	
	listbox uiLBoxFbxBip height:12
	
	button uiBtnListAdd "   +   " across:2
	button uiBtnListDel "    -   "
-- 	button uiBtnListUp "   ^   "
-- 	button uiBtnListDown "   v   "
	
	group "Select" (
	button uiBtnSelectFbxRoot "FBX Root" across:2
	button uiBtnSelectBipRoot "Bip Root"
	button uiBtnSelectFbx "1 FBX" across:4
	button uiBtnSelectFbxAll "All FBX"
	button uiBtnSelectBip "1 Bip"
	button uiBtnSelectBipAll "All Bip"
	)
	
	group "Figure" (
 		button uiBtnFigureSync "Figure Sync"		
	)
	
	group "Keyframe" (
		radiobuttons uiRBtnKeyOption labels:#("Animation Range", "1 Frame") default:1
		button uiBtnSyncAll "All Listed" across:2
		button uiBtnSyncSel "1 Selected"
	)
	
	progressBar uiPBar height:8 color:red
	
	label uiLabelBipInfo "Biped : " align:#left
	label uiLabelStatus "Status : " align:#left
	
	group "Replace name in selection" (
		edittext uiETxtReplaceFrom across:3
		edittext uiETxtReplaceTo
		button uiBtnDoReplace "Replace!"
	)

	group "Fixed Distance Helper (Rigging Utility)" (
		button uiBtnFDHelper "Fixed Distance Helper" align:#left tooltip:"Create Fixed Distance Helper. This button should be used with two bones selected. You can select the relevant helpers and press the button." across:2
		spinner uiSpinFDHelperSize toolTip:"Fixed Distance Helper Size" range:[0,10000,20] offset:[0, 0] align:#left
		radiobuttons uiRBtnFDHelperForward labels:#("X", "Y", "Z") default:1 tooltip:"Forward Direction of Fixed Distance Helper" columns:3 offset:[0, 0] across:2
		checkbox uiCBoxFDHelperForwardFlip "Flip" tooltip:"Flip Forward Direction"
	)
	--button uiBtnDeletePosKeys "Delete Position Keys" align:#left tooltip:"Delete the Position keys after the current frame."
	
	button uiBtnAbout "About..."
-- 	button uiBtnTest "Test"
	
	-- Fbx와 Biped 한 쌍을 정의하는 구조체. 바이패드는 Xtra 라던가 Prop 이라던가 하는 이런 저런 추가 정보가 있을 수 있음
	struct pairDef (
		fbxObj,
		bipObj
		--bipType		-- "Root" / "Body" / "Tail" / "PonyTail" / "Prop" / "Xtra" 등이 가능
	)
	local pairs = #()
	local rootObjFbx
	local rootObjBip
		
	struct bipType (
		limbName,
		linkIndex
	)
	
	-- trParent 로부터 trChild 의 로컬 위치와 로테이션과 스케일 값을 를 리턴한다.
	function fnGetLocalTransform trParent trChild = -- 입력 값은 matrix3, 리턴 값은 matrix3,
	(
		trChild*(inverse trParent)
	)
	
	-- 리스트에 바이패드가 아닌 오브젝트가 있는지 검사. 바이패드가 아닌 오브젝트가 있으면 true 리턴
	function fnNonBipedCheck = (
		returnBool = false
		if ( classof rootObjBip ) != Biped_Object and rootObjBip != undefined do ( returnBool = true )

		if pairs.count == 0 do ( return returnBool )
		for o in pairs do (
			if ( classof o.bipObj ) != Biped_Object and o.bipObj != undefined do ( returnBool = true )
		)
		
		return returnBool
	)
	
	-- pairs 변수 안에 매칭이 덜 된 경우가 있는지 검사 문제 없으면 true, 문제 있으면 false 리턴
	function fnCheckMatch = (
		if pairs.count == 0 do return true
		for o in pairs do (
			if ( o.fbxObj == undefined and o.bipObj != undefined ) do return false
			if ( o.fbxObj != undefined and o.bipObj == undefined ) do return false
		)
		return true
	)
	
	-- 바이패드 오브젝트의 X축 스케일값 만큼의 월드 포지션을 알아냄 (Xtra 등의 오브젝트에서 자식이 여럿 있을 때 실제 스케일에 사용할 자식을 알아내기 위함)
	function fnGetLocalScaleXWorldPos bipObj = (
		tScale = biped.getTransform bipObj #scale
		tMatrix = matrix3 1
		tMatrix.pos = [tScale.x, 0, 0]
		tMatrix = tMatrix * bipObj.transform
		return tMatrix.pos
	)
	
	-- 바이패드 오브젝트의 자식이 여럿 있을 때 X축 스케일 위치를 기준으로 하나의 자식을 리턴한다. 자식이 없거나 문제가 있으면 undefined 리턴
	function fnGetChildByScalePos bipObj = (
		if ( (classof bipObj) != Biped_Object ) do return undefined
		if ( bipObj.children.count == 1 ) do return bipObj.children[1]
		if ( bipObj.children.count == 0 ) do return undefined
		
		tDestPos = fnGetLocalScaleXWorldPos bipObj		-- 이 위치에 가까운 자식이 스케일의 기준이 되는 자식
		
		childDistArr = #()
		tIndex = 0
		for i = 1 to bipObj.children.count do (
			append childDistArr ( distance bipObj.children[i].transform.position tDestPos )
			tMinDist = amin childDistArr
			tIndex = finditem childDistArr tMinDist
		)
		return bipObj.children[tIndex]
	)
	
	-- 리턴 스트럭쳐의 멤버 : limbName, linkIndex
	function fnGetBipedType obj = (
		if ( obj == undefined ) do return undefined
		if ( (classof obj) != Biped_Object ) do return (bipType limbName:#nonBiped linkIndex:0)
		
		-- biped.maxNumLinks $ 이 방법으로 바이패드의 최대 링크 수를 알아낼 수 있다. 보통 25이지만 넉넉하게 30
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
		
		-- 맥스 스크립트에서 Xtra 본을 전혀 지원하지 않아서 어쩔 수 없이 바이패드 클래스인데 정체를 알아내지 못한건 모두 Xtra로 정의
		return (bipType limbName:#xtra linkIndex:0)
	)
		
	function fnSwapArray arr id1 id2 = 	-- arr 배열에서 id1과 id2 의 내용을 서로 뒤바꾼다. 리턴된 배열은 원래 배열을 변경시키지 않는다.
	(
		if arr.count < id1 or arr.count < id2 do return arr -- 잘못된 아이디가 입력되면 그냥 원래 배열을 리턴
		if id1 == id2 do return arr -- 같은 번호의 아이디가 입력되어도 그냥 원래 배열을 리턴한다.
	
		if id1 > id2 do -- 배열 인덱스는 반드시 id1이 더 작다는 사실을 기준으로 작동해야 한다.
		(
			tempID = id1
			id1 = id2
			id2 = tempID
		)
	  
	-- 배열 복제는 deepcopy로 해야함. 안그러면 원래 원본과 instance 관계가 될 가능성이 있는데
	-- 안전하게 하려면 deepcopy로 복제하는게 좋음.
		tempArr = deepcopy arr   
		tempVar = tempArr[id1]
		tempArr[id1] = tempArr[id2]
		tempArr[id2] = tempVar
	  
		return tempArr
	)
		
	function fnSetStatus = (
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
	
	function fnSetBipInfo = (
		if ( pairs.count == 0 ) do return ()
		if ( uiLBoxFbxBip.selection == 0 ) do return ()
		
		tBipType = fnGetBipedType pairs[uiLBoxFbxBip.selection].bipObj
		
		if ( tBipType == undefined ) do ( uiLabelBipInfo.text  = "Biped : " ;return () )
		
		tStr = stringstream ""
		format "Biped : %, Link = %" tBipType.limbName tBipType.linkIndex to:tStr
		uiLabelBipInfo.text = tStr as string
	)
	
		-- children 을 배열에 append 해준다. 입력된 arr 자체가 변경되므로 리턴 없음
	function fnAppendChildren arr children = (
		if ( children.count ) == 0 do return ()
		for o in children do (
			append arr o
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
	
	-- pairs 배열을 대상으로 계층구조 순서대로 소팅 한다. pairs 배열은 모두 rootObjBip 의 자식이라는 전제
	function fnSortByHierarchy = (
		if ( pairs.count == 0 ) do return ()
		
		-- 일단 rootObjBip 의 모든 자식들을 얻어온다. 계층구조 순서대로 얻어짐. 이후 pairs 에 사용된 것들만 남기고 날려야함
		tAllChildren = fnGetAllChildren rootObjBip
		
		-- pairs에 사용된 바이패드 오브젝트 배열을 임시로 만든다. 계층구조 순서대로가 아니다.
		tBips = #()
		for i = 1 to pairs.count do (
			append tBips pairs[i].bipObj
		)
		
		for i = tAllChildren.count to 1 by -1 do (
			-- tBips 에 존재하지 않는 children 은 tAllChildren 에서 제거한다.
			if ( (finditem tBips tAllChildren[i]) == 0 ) do (
				tAllChildren = ( deleteitem tAllChildren i )
			)
		)

		-- tBips 			pairs와 순서는 같으나 바이패드만으로 된 배열
		-- tAllChildren	계층구조가 정렬된. 그리고 바이패드만 들어있는 배열
		retArr = #()
		tProps = #()		-- 프랍들을 특별처리하기 위한 임시 배열
		for i = 1 to tAllChildren.count do (
			tBipType = ( fnGetBipedType tAllChildren[i] ).limbName
			if ( tBipType != #prop1 and tBipType != #prop2 and tBipType != #prop3 ) then (
				-- 프랍이 아닌 경우
				append retArr pairs[(finditem tBips tAllChildren[i])]
			)
			else (
				-- 프랍인 경우
				append tProps pairs[(finditem tBips tAllChildren[i])]
			)
		)
		
		retArr = retArr + tProps		-- 프랍을 가장 후순위로 싱크해야함
		
		-- pairs 의 바이패드가 지정되지 않은 undefined 항목들을 살려두어야하므로 retArr에 더해준다.
		for o in pairs do (
			if ( o.bipObj == undefined ) do ( append retArr o )
		)
		
		pairs = deepcopy retArr
	)
	
	function fnSetList = (
		-- 0.29버전까지는 리스트 갱신시마다 리스트를 계층구조 순서대로 소팅을 했었으나
		-- 맥스 최신버전부터 매우 느리게 작동하여 리스트 갱신에서는 제외함
		
		tItems = #()
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
			append tItems tString
		)
		uiLBoxFbxBip.items = tItems
		
		--if ( uiLBoxFbxBip.items.count > 1 and uiLBoxFbxBip.selection == 1 ) do uiLBoxFbxBip.selection = 2
		if ( uiLBoxFbxBip.items.count > 0 and uiLBoxFbxBip.selection == 0 ) do uiLBoxFbxBip.selection = uiLBoxFbxBip.items.count
		
		tSel = uiLBoxFbxBip.selection
		uiLBoxFbxBip.selection = amin uiLBoxFbxBip.items.count (tSel + 5)
		uiLBoxFbxBip.selection = tSel
		
		fnSetStatus ()
		fnSetBipInfo ()
		if ( rootObjFbx != undefined ) then ( uiLabelRootFbx.text = rootObjFbx.name ) else ( uiLabelRootFbx.text = "" )
		if ( rootObjBip != undefined ) then ( uiLabelRootBip.text = rootObjBip.name ) else ( uiLabelRootBip.text = "" )
	)
	
	-- pairs 배열 속의 구조체에 이미 있는 오브젝트인지를 검사하여 true 와 false 를 반환함. 존재하면 번호 리턴 , 없으면 0 리턴
	function fnFindInPairsFbx obj = (
		tPos = 0
		for o  = 1 to pairs.count do (
			try ( if ( pairs[o].fbxObj == obj ) do tPos = o ) catch ()
		)
		return tPos
	)
	
	-- pairs 배열의 바이패드쪽에서 obj 의 위치 번호를 리턴
	function fnFindInPairsBip obj = (
		tPos = 0
		for o  = 1 to pairs.count do (
			try ( if ( pairs[o].bipObj == obj ) do tPos = o ) catch ()
		)
		return tPos
	)
	
	function fnSetFileStream = -- pairs 배열 구조체 변수들을 모두 취합해서 정해진 포맷으로 정렬한 뒤 StringStream 변수 하나로 리턴
	(
		if pairs.count == 0 do return undefined
			
		tempStr = stringStream ""
		ifStr = ""
		
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
	
	function fnCheckFileExt str = -- 스트링의 확장자를 검사
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
	
	-- obj가 parent 의 하위 자식에 소속되어있는지 검사
	function fnIfChild parent obj = (
		
		found = false
		checkObj = obj
		while checkObj != undefined do (
			if ( parent == checkObj ) do ( found = true )
			checkObj = checkObj.parent
		)
		return found
	)
	
	-- 씬 내에 같은 이름을 가진 오브젝트가 여럿 있을 때 배열로 모두 리턴
	function fnGetObjsByName str = (
		objs = #()
		for o in objects do (
			if ( o.name == str ) do ( append objs o )
		)
		return objs
	)
	
	-- 전체 씬을 조사해서 기존에 FbxRoot 지정된 유저 프로퍼티를 제거하고 obj 에 루트라는 표시를 한다.
	function fnSetUserPropFbxRoot obj = (
		if ( objects.count == 0 ) do return ()
		if ( obj == undefined ) do return ()
		
		for o in objects do (
			if ( (getUserProp o "SoxFbxToBiped_FbxRoot") != undefined  ) do ( setUserProp o "SoxFbxToBiped_FbxRoot" false )
		)
		
		setUserProp obj "SoxFbxToBiped_FbxRoot" true
	)
	
	function fnSetUserPropBipRoot obj = (
		if ( objects.count == 0 ) do return ()
		if ( obj == undefined ) do return ()
		
		for o in objects do (
			if ( (getUserProp o "SoxFbxToBiped_BipRoot") != undefined  ) do ( setUserProp o "SoxFbxToBiped_BipRoot" false )
		)
		
		setUserProp obj "SoxFbxToBiped_BipRoot" true
	)

	function fnGetParentObj obj = (
		return (maxOps.getNodeByHandle (getUserProp obj "FBXtoBiped_FixedDistHelperParent"))
	)

	function fnGetTargetObj obj = (
		maxOps.getNodeByHandle (getUserProp obj "FBXtoBiped_FixedDistHelperTarget")
	)

	function fnGetHelperType obj = (
		return (getUserProp obj "FBXtoBiped_FixedDistHelperType")
	)

	function fnGetLookAtHelperByPointer obj = (
		local tUserProp = getUserProp obj "FBXtoBiped_FixedDistPointerLookAt"
		if (tUserProp == undefined) do return undefined
		return (maxOps.getNodeByHandle tUserProp)	
	)

	function fnGetOrientationHelperByPointer obj = (
		local tUserProp = getUserProp obj "FBXtoBiped_FixedDistPointerOrientation"
		if (tUserProp == undefined) do return undefined
		return (maxOps.getNodeByHandle tUserProp)	
	)

	-- 손목같은 부위는 본의 자식으로 여러 본이 있을 수 있어서 여러 개의 헬퍼가 중첩된다.
	-- 그러므로 부모 본에 자식 헬퍼 포인터 번호를 기록하려면 구조가 복잡해진다.
	-- 그래서 단순하게, 자식중에 헬퍼가 있는지, 그리고 두 번째 선택 본과 일치하는지를 조사한다.
	-- 입력값 : selA는 첫 번째 선택 본, selB는 두 번째 선택 본
	-- 출력값 : 매칭 되면 헬퍼를 리턴하던가, 매칭이 안되면 undefined
	-- 이 방식은 Orientation 헬퍼를 찾는데 사용할 수 없다. Orientation 헬퍼는 selA의 자식에 없으므로. 대신에 fnFindOrientationHelperByTarget 함수를 사용해야함
	function fnGetLookAtHelper selA selB = (
		for obj in selA.children do (
			if (fnGetHelperType obj == "LookAt") do (
				tTarget = fnGetTargetObj obj
				if (tTarget == selB) do ( return obj)
			)
		)
		-- 매칭되는게 없으면 undefined
		return undefined
	)

	-- 씬 전체에서 obj를 타겟으로 하는 Orientation 헬퍼를 찾는다. 없으면 undefined
	function fnFindOrientationHelperByTarget obj = (
		for o in helpers do (
			if (fnGetHelperType o == "Orientation") do (
				local target = fnGetTargetObj o
				if (target == obj) do (return o)
			)
		)
		return undefined
	)

	function fnSetFixedDistHelperButton = (
		if (selection.count == 2) do (
			uiBtnFDHelper.enabled = true
			return()
		)

		if (selection.count == 1) do (
			if ((fnGetHelperType selection[1]) == "LookAt" or (fnGetHelperType selection[1]) == "Orientation") do (
				uiBtnFDHelper.enabled = true
				return()
			)
		)
		uiBtnFDHelper.enabled = false
	)
	
	-- 콜백에서 호출되는 함수. 씬에서 선택이 변화될 때마다 툴의 리스트를 동기화 해준다.
	-- Fixed Distance Helper 버튼의 활성, 비활성도 세팅한다.
	function fnCallbackSyncSel = (
		fnSetFixedDistHelperButton()

		if ( pairs.count == 0 ) do return ()
		tIndex = 0
		for i = 1 to pairs.count do (
			if ( pairs[i].fbxObj == selection[1] and selection.count != 0 ) do ( tIndex = i )
			if ( pairs[i].bipObj == selection[1] and selection.count != 0 ) do ( tIndex = i )
		)
		
		if ( tIndex != 0  ) do (
			uiLBoxFbxBip.selection = tIndex
			fnSetList ()
 			fnSetStatus ()
			fnSetBipInfo()
		)
	)
	
	-- pairs 전체에 대해 지정된 시간만큼 애니메이션 키를 싱크 한다.
	function fnSyncKeyRangedAll frameStart frameEnd = (
		if ( classof rootObjBip ) == Biped_Object do (
			rootObjBip.controller.rootnode.controller.figureMode = false
		)
		clearSelection()		-- 바이패드가 선택된 상태에서는 at time 방식과 호환되지 않는다.
		
		disableSceneRedraw() 
		
		--일단 키 삭제
		deselectKeys rootObjBip.controller frameStart frameEnd
		selectKeys rootObjBip.controller frameStart frameEnd
		if ( classof rootObjBip ) == Biped_Object then (
			biped.deleteKeys rootObjBip.controller #selection
		)
		else (
			deleteKeys rootObjBip.controller #selection
		)
		
		for p = 1 to pairs.count do (
				deselectKeys pairs[p].bipObj.controller frameStart frameEnd
				selectKeys pairs[p].bipObj.controller frameStart frameEnd
				if ( classof pairs[p].bipObj ) == Biped_Object then (
					biped.deleteKeys pairs[p].bipObj.controller #selection 
				)
				else (
					deleteKeys pairs[p].bipObj.controller #selection 
				)
			)
		
		-- root 노드 먼저.
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
						tMatrix.position = rootObjFbx.transform.position		-- rotation 다음에 position 의 순서가 중요
						rootObjBip.transform = tMatrix
					)
				)
			) -- at time end
		) -- for end
		
		-- fbx 본의 키프레임이 띄엄 띄엄 있을 경우 매 오브젝트마다 전체 프레임을 모두 작업한 뒤에 다음 오브젝트로 넘어가는 방식을 취해야한다.
		for p = 1 to pairs.count do (
			for i = frameStart to frameEnd do (
				at time (i as time) (
					if ( classof pairs[p].bipObj ) == Biped_Object then (
						biped.setTransform pairs[p].bipObj #pos pairs[p].fbxObj.transform.position true
						biped.setTransform pairs[p].bipObj #rotation  pairs[p].fbxObj.transform.rotation true
					)
					else (
						with animate on (
							tMatrix = matrix3 1
							tMatrix.rotation = pairs[p].fbxObj.transform.rotation
							tMatrix.position = pairs[p].fbxObj.transform.position		-- rotation 다음에 position 의 순서가 중요
							pairs[p].bipObj.transform = tMatrix
						)
					)
				) -- at time end
			) -- for end
			uiPBar.value = (((p as float) / (pairs.count as float)) * 100 ) as integer
		)
		
		enableSceneRedraw()
	)
	
	-- 선택된 바이패드 하나에 대해 지정된 시간만큼 애니메이션 키를 싱크 한다.
	function fnSyncKeyRangedSel frameStart frameEnd obj= (
		if ( classof rootObjBip ) == Biped_Object do (
			rootObjBip.controller.rootnode.controller.figureMode = false
		)
		clearSelection()		-- 바이패드가 선택된 상태에서는 at time 방식과 호환되지 않는다.
		
		disableSceneRedraw() 
		
		tIndex = fnFindInPairsBip obj
		for i = frameStart to frameEnd do (
			if ( obj == rootObjBip ) then (
				at time (i as time) (
					if ( classof rootObjBip ) == Biped_Object then (
						biped.setTransform rootObjBip #pos rootObjFbx.transform.position true
						biped.setTransform rootObjBip #rotation  rootObjFbx.transform.rotation true
					)
					else (
						with animate on (
							tMatrix = matrix3 1
							tMatrix.rotation = rootObjFbx.transform.rotation
							tMatrix.position = rootObjFbx.transform.position		-- rotation 다음에 position 의 순서가 중요
							rootObjBip.transform = tMatrix
						)
					)
				) -- at time end
			)
			else (
				at time (i as time) (
					if ( classof pairs[tIndex].bipObj ) == Biped_Object then (
						biped.setTransform pairs[tIndex].bipObj #pos pairs[tIndex].fbxObj.transform.position true
						biped.setTransform pairs[tIndex].bipObj #rotation  pairs[tIndex].fbxObj.transform.rotation true
					)
					else (
						with animate on (
							tMatrix = matrix3 1
							tMatrix.rotation = pairs[tIndex].fbxObj.transform.rotation
							tMatrix.position = pairs[tIndex].fbxObj.transform.position		-- rotation 다음에 position 의 순서가 중요
							pairs[tIndex].bipObj.transform = tMatrix
						)
					)
				) -- at time end
			)
		) -- for end
		
		enableSceneRedraw()
	)

	-- 키프레임 생성하기 전 전체 바이패드에 대해 매트릭스 리셋을 한다.
	-- 매트릭스 리셋을 하는 이유 : 에디터에서 수동으로 Align 등을 하면 바이패드의 매트릭스가 꼬여서 이후 스크립트에서 Align을 해도 제대로 정렬이 안된다.
	-- 애니메이션 키 생성하기 전에 일괄로 해야하는 이유 : IK가 살아있는 Limb 부위, 예를 들어 하박에서 Matrix3 1 를 하는 순간 상박에 영향을 주기때문에 본격적으로 키를 생성하기 전에 한번 훑어야한다.
	function fnResetBipedMatrix = (
		for i = 1 to pairs.count do (
			pairs[i].bipObj.transform = Matrix3 1
		)
	)
	
	on uiBtnTest pressed do (
		
	)
	
	on uiBtnScanRoot pressed do (
		if ( objects.count == 0 ) do return ()
		
		for o in objects do (
			if ( (getUserProp o "SoxFbxToBiped_FbxRoot") == true ) do ( rootObjFbx = o )
			if ( (getUserProp o "SoxFbxToBiped_BipRoot") == true ) do ( rootObjBip = o )
		)
		
		fnSetList ()
	)
	
	on uiBtnFigureSync pressed do (
		-- pairs 를 계층구조 순서대로 먼저 정렬한다.
		-- 정렬하는 이유 : 바이패드는 게층구조 순서대로 figure 를 조정해야함
		-- 3ds Max 최신버전이 되면서 소팅 작동이 매우 느리다. 0.29버전까지는 리스트 갱신시마다 소팅을 했으나 0.30부터 리스트 갱신시에는 소팅을 안한다.
		fnSortByHierarchy ()
		fnSetList ()

		if fnNonBipedCheck() do return()		-- 바이패드가 아닌 오브젝트를 대상으로 하는 리스트에서는 Figure Sync 기능이 작동하지 않는다.
		
		if ( fnCheckMatch () == false ) do (
			messagebox "Please check list"
			return ()
		)
		
		if ( pairs.count == 0 ) do return ()
		if ( rootObjBip == undefined or rootObjFbx == undefined ) do return ()
		
		undo on (
		tFigureSaved = rootObjBip.controller.rootnode.controller.figureMode
		rootObjBip.controller.rootnode.controller.figureMode = true
		
		biped.setTransform rootObjBip #pos rootObjFbx.transform.position false
		biped.setTransform rootObjBip #rotation  rootObjFbx.transform.rotation false
		
		for i = 1 to pairs.count do (
			-- bipType.limbName, bipType.linkIndex
			tBipType = fnGetBipedType pairs[i].bipObj
			
			-- X축 스케일에 사용할 자식 바이패드 오브젝트 선정. undefined면 자식이 없는 노드임. 하지만 nub때문에 자식이 없는 노드가 지정될 일은 거의 없음. 있다면 유저 실수
			tChildForScale = fnGetChildByScalePos pairs[i].bipObj
			tOriginalScale = biped.getTransform pairs[i].bipObj #scale
			
			case of
				(
					-- Pelvis
					(tBipType.limbName == #pelvis):(
						tLLeg = biped.getNode rootObjBip #lleg link:1
						tIndex = fnFindInPairsBip tLLeg
						if ( tIndex != 0 ) then ( tLLegFbx = pairs[tIndex].fbxObj ) else ( tLLegFbx = undefined )
						
						tRLeg = biped.getNode rootObjBip #rleg link:1
						tIndex = fnFindInPairsBip tRLeg
						if ( tIndex != 0 ) then ( tRLegFbx = pairs[tIndex].fbxObj ) else ( tRLegFbx = undefined )
						
						if ( tLLegFbx != undefined and tRLegFbx != undefined ) do (
							tOriginalScale = biped.getTransform pairs[i].bipObj #scale
							tDist = distance tLLegFbx.transform.position tRLegFbx.transform.position
							pairs[i].bipObj.transform = Matrix3 1 -- 트랜스폼 초기화, 맥스 에디터에서 유저에 의해 Align 된 본은 트랜스폼이 꼬여있는 경우가 가끔 발생한다(대표적으로 오른쪽 쇄골). 이런 경우에도 문제 없이 되려면 Matrix3 1 로 초기화 해주면 안전하다.
							biped.setTransform pairs[i].bipObj #rotation ( pairs[i].fbxObj.transform.rotation ) false
							biped.setTransform pairs[i].bipObj #scale [tOriginalScale.x, tOriginalScale.y, tDist ] false
						)
					)
					
					-- Left Foot
					(tBipType.limbName == #lleg and tBipType.linkIndex == 3):(
						tMeFbx = pairs[i].fbxObj
						tMeBip = pairs[i].bipObj
						
						if (tMeBip.parent == rootObjBip) then
						(
							tMeFbxParent = rootObjFbx
						)
						else
						(
							-- fbx 트리구조는 바이패드와의 축 정렬을 위해 대리용 더미를 종종 사용하기때문에 fbx의 부모를 찾기 위해서는 바이패드 부모 기준으로 fbx 리스트를 검색해야한다.
							tMeFbxParent = pairs[(fnFindInPairsBip tMeBip.parent)].fbxObj
						)
						
						tDeltaPosFbx = tMeFbx.transform.position - tMeFbxParent.transform.position
						if ( tMeFbxParent == rootObjFbx ) then (
							tBipParent = rootObjBip
						)
						else (
							tFbxParentIndex = fnFindInPairsFbx tMeFbxParent
							tBipParent = pairs[tFbxParentIndex].bipObj
						)
						
						tBipPos = tBipParent.transform.position + tDeltaPosFbx
						pairs[i].bipObj.transform = Matrix3 1 -- 트랜스폼 초기화, 맥스 에디터에서 유저에 의해 Align 된 본은 트랜스폼이 꼬여있는 경우가 가끔 발생한다(대표적으로 오른쪽 쇄골). 이런 경우에도 문제 없이 되려면 Matrix3 1 로 초기화 해주면 안전하다.
						biped.setTransform pairs[i].bipObj #pos tBipPos false
						
						biped.setTransform pairs[i].bipObj #rotation tMeFbx.transform.rotation false
						--if ( tMeFbx.name == "_Bip001 L Clavicle" ) do (print tMeFbx.transform.rotation)
						
						tChildIndex = fnFindInPairsBip tChildForScale
						if ( tChildIndex != 0 ) do (
							tChildFbx = pairs[tChildIndex].fbxObj
							tLocalDistM3 = fnGetLocalTransform tMeFbx.transform tChildFbx.transform		-- 자식의 로컬 트랜스폼
							biped.setTransform pairs[i].bipObj #scale [tLocalDistM3.position.x, tOriginalScale.y, tOriginalScale.z ] false
						)
					)
					
					-- Right Foot
					(tBipType.limbName == #rleg and tBipType.linkIndex == 3):(
						tMeFbx = pairs[i].fbxObj
						tMeBip = pairs[i].bipObj
					
						if (tMeBip.parent == rootObjBip) then
						(
							tMeFbxParent = rootObjFbx
						)
						else
						(
							-- fbx 트리구조는 바이패드와의 축 정렬을 위해 대리용 더미를 종종 사용하기때문에 fbx의 부모를 찾기 위해서는 바이패드 부모 기준으로 fbx 리스트를 검색해야한다.
							tMeFbxParent = pairs[(fnFindInPairsBip tMeBip.parent)].fbxObj
						)
						
						tDeltaPosFbx = tMeFbx.transform.position - tMeFbxParent.transform.position
						if ( tMeFbxParent == rootObjFbx ) then (
							tBipParent = rootObjBip
						)
						else (
							tFbxParentIndex = fnFindInPairsFbx tMeFbxParent
							tBipParent = pairs[tFbxParentIndex].bipObj
						)
						
						tBipPos = tBipParent.transform.position + tDeltaPosFbx
						pairs[i].bipObj.transform = Matrix3 1 -- 트랜스폼 초기화, 맥스 에디터에서 유저에 의해 Align 된 본은 트랜스폼이 꼬여있는 경우가 가끔 발생한다(대표적으로 오른쪽 쇄골). 이런 경우에도 문제 없이 되려면 Matrix3 1 로 초기화 해주면 안전하다.
						biped.setTransform pairs[i].bipObj #pos tBipPos false
						
						biped.setTransform pairs[i].bipObj #rotation tMeFbx.transform.rotation false
						--if ( tMeFbx.name == "_Bip001 L Clavicle" ) do (print tMeFbx.transform.rotation)
						
						tChildIndex = fnFindInPairsBip tChildForScale
						if ( tChildIndex != 0 ) do (
							tChildFbx = pairs[tChildIndex].fbxObj
							tLocalDistM3 = fnGetLocalTransform tMeFbx.transform tChildFbx.transform		-- 자식의 로컬 트랜스폼
							biped.setTransform pairs[i].bipObj #scale [tLocalDistM3.position.x, tOriginalScale.y, tOriginalScale.z ] false
						)
					)
					
					default: (
						tMeFbx = pairs[i].fbxObj
						tMeBip = pairs[i].bipObj
						
						if (tMeBip.parent == rootObjBip) then
						(
							tMeFbxParent = rootObjFbx
						)
						else
						(
							-- fbx 트리구조는 바이패드와의 축 정렬을 위해 대리용 더미를 종종 사용하기때문에 fbx의 부모를 찾기 위해서는 바이패드 부모 기준으로 fbx 리스트를 검색해야한다.
							local tIndex = fnFindInPairsBip tMeBip.parent
							if tIndex == 0 then
							(
								messagebox ("Warning - There are unmatched Biped - " + tMeBip.parent.name)
								exit
							)
							else
							(
								tMeFbxParent = pairs[tIndex].fbxObj
							)
						)
						
						tDeltaPosFbx = tMeFbx.transform.position - tMeFbxParent.transform.position
						if ( tMeFbxParent == rootObjFbx ) then (
							tBipParent = rootObjBip
						)
						else (
							tFbxParentIndex = fnFindInPairsFbx tMeFbxParent
							tBipParent = pairs[tFbxParentIndex].bipObj
						)
						
						tBipPos = tBipParent.transform.position + tDeltaPosFbx
						pairs[i].bipObj.transform = Matrix3 1 -- 트랜스폼 초기화, 맥스 에디터에서 유저에 의해 Align 된 본은 트랜스폼이 꼬여있는 경우가 가끔 발생한다(대표적으로 오른쪽 쇄골). 이런 경우에도 문제 없이 되려면 Matrix3 1 로 초기화 해주면 안전하다.
						biped.setTransform pairs[i].bipObj #pos tBipPos false
						
						biped.setTransform pairs[i].bipObj #rotation tMeFbx.transform.rotation false
						--if ( tMeFbx.name == "_Bip001 L Clavicle" ) do (print tMeFbx.transform.rotation)
						
						tChildIndex = fnFindInPairsBip tChildForScale
						if ( tChildIndex != 0 ) do (
							tChildFbx = pairs[tChildIndex].fbxObj
							tDist = distance tMeFbx.transform.position tChildFbx.transform.position		-- 자식과의 거리
							biped.setTransform pairs[i].bipObj #scale [tDist, tOriginalScale.y, tOriginalScale.z ] false
						)
					)
				) -- case end
		) -- for end
		) -- undo off
		
-- 		rootObjBip.controller.figureMode = tFigureSaved -- 자동으로 Figure모드에서 원래 일반 모드로 되돌아가도록 할 경우 Clevicle 에서 이유를 알 수 없는 로테이션 에러가 발생해서 무조건 Figure모드로 끝내도록 함
	)
	
	on uiBtnSyncAll pressed do (
		if ( fnCheckMatch () == false ) do (
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
			fnResetBipedMatrix()
			fnSyncKeyRangedAll frameStart frameEnd
		)
		select tSelBackup
	)
	
	on uiBtnSyncSel pressed do (
		if ( fnCheckMatch () == false ) do (
			messagebox "Please check list"
			return ()
		)
		if ( pairs.count == 0 ) do return ()
		if ( rootObjBip == undefined or rootObjFbx == undefined ) do return ()
		
		-- 선택된 오브젝트가 리스트에 없으면 그냥 리턴
		if ( ( fnFindInPairsBip selection[1] ) == 0 and selection[1] != rootObjBip ) do return ()
		
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
			-- 선택된 것 하나에 대해서는 Matrix3 1 을 하면 안된다. Limb같은곳에서 하위 하나에서 하면 상위에도 영향을 준다.
			fnSyncKeyRangedSel frameStart frameEnd selection[1]
		)
		select tSelBackup
	)
	
	on uiBtnReset pressed do (
		pairs = #()
		rootObjFbx = undefined
		rootObjBip = undefined
		fnSetList ()
	)
	
	on uiBtnDoReplace pressed do (
		strToFind = uiETxtReplaceFrom.text
		strToReplace = uiETxtReplaceTo.text
	
		for o in selection do(
			tStr = o.name
			tPos = findstring tStr strToFind
			if (tPos != undefined) do (
				newStr = replace tStr tPos strToFind.count strToReplace
				o.name = newStr
			)
		)
		
		fnSetList ()
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
		
		-- Root 오브젝트가 변경되었으면 나머지 FBX 오브젝트들은 새로 구성해야함. 모두 날려버린다.
		if ( pairs.count > 0 ) do (
			for o = 1 to pairs.count do (
				pairs[o].fbxObj = undefined
			)
		)
		
		-- 유저 프로퍼티에 루트 노드라는 표시를 한다.
		fnSetUserPropFbxRoot selection[1]
		
		if uiCBoxAutoHide.state do (
			hide selection[1]
			clearSelection()
		)
		
		fnSetList ()
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
		
		-- Root 오브젝트가 변경되었으면 나머지 Bip 오브젝트들은 새로 구성해야함. 모두 날려버린다.
		if ( pairs.count > 0 ) do (
			for o = 1 to pairs.count do (
				pairs[o].bipObj = undefined
			)
		)
		
		-- 유저 프로퍼티에 루트 노드라는 표시를 한다.
		fnSetUserPropBipRoot selection[1]
		
		if uiCBoxAutoHide.state do (
			hide selection[1]
			clearSelection()
		)
		
		fnSetList ()
	)
	
	on uiLBoxFbxBip selected arg do (
		fnSetBipInfo ()
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
			messagebox "You must Get root objects first"
			return ()
		)
		
		sftbFile = (getOpenFileName caption:"Select sftb file" types:"SOX Fbx to Biped (*.sftb)|*.sftb|All (*.*)|*.*|") as string
		if sftbFile == "undefined" do return ()
		if (fnCheckFileExt sftbFile) == false do (messagebox "*.sftb 확장자만 지원합니다"; return())
		
		openStream = openFile sftbFile mode:#rt
		
		pairs = #()
		pairsIndex = 0
		
		if ( uiRBtnLoadingType.state == 2 ) then (
			-- Handle 번호로 불러오는 방식
			while (eof openStream) != true do
			(
				tempKeyword = readDelimitedString openStream "="
				tempKeyword = trimLeft tempKeyword -- 안전을 위해 앞뒤 공백을 없앤다
				tempKeyword = trimRight tempKeyword -- 안전을 위해 앞뒤 공백을 없앤다
				
				case of
				(
					(tempKeyword == "FbxObjHandle"):(
						append pairs (pairdef ()) ; pairsIndex += 1
						tempValue = readDelimitedString openStream "\n"
						tHandle = execute tempValue
						tHandleObj = try ( maxOps.getNodeByHandle tHandle ) catch (undefined)
						pairs[pairsIndex].fbxObj = undefined
						
						--if ( tHandle != undefined  and (fnIfChild rootObjFbx tHandleObj) ) do (
						if ( tHandle != undefined  ) do (
							pairs[pairsIndex].fbxObj = tHandleObj
						)
					)
					
					(tempKeyword == "BipObjHandle"):(
						tempValue = readDelimitedString openStream "\n"
						tHandle = execute tempValue
						tHandleObj = try ( maxOps.getNodeByHandle tHandle ) catch (undefined)
						pairs[pairsIndex].bipObj = undefined
						if ( tHandle != undefined and (fnIfChild rootObjBip tHandleObj) ) do (
							pairs[pairsIndex].bipObj = tHandleObj
						)
					)
					
					default: (readDelimitedString openStream "\n")
				)
			)
		)
		else (
			-- Name으로 불러오는 방식
			while (eof openStream) != true do
			(
				tempKeyword = readDelimitedString openStream "="
				tempKeyword = trimLeft tempKeyword -- 안전을 위해 앞뒤 공백을 없앤다
				tempKeyword = trimRight tempKeyword -- 안전을 위해 앞뒤 공백을 없앤다
				
				case of
				(
					(tempKeyword == "FbxObjName"):(
						append pairs (pairdef ()) ; pairsIndex += 1
						tempValue = readDelimitedString openStream "\n"
						tempValue = trimLeft tempValue -- 안전을 위해 앞뒤 공백을 없앤다
						tempValue = trimRight tempValue -- 안전을 위해 앞뒤 공백을 없앤다
						tObjs = fnGetObjsByName tempValue
						pairs[pairsIndex].fbxObj = undefined
						if ( tObjs.count != 0 ) do (
							for o in tObjs do (
								--if ( fnIfChild rootObjFbx o ) do ( pairs[pairsIndex].fbxObj = o )
								pairs[pairsIndex].fbxObj = o
							)
						)
					)
					
					(tempKeyword == "BipObjName"):(
						tempValue = readDelimitedString openStream "\n"
						tObj = getNodeByName tempValue
						tempValue = trimLeft tempValue -- 안전을 위해 앞뒤 공백을 없앤다
						tempValue = trimRight tempValue -- 안전을 위해 앞뒤 공백을 없앤다
						tObjs = fnGetObjsByName tempValue
						pairs[pairsIndex].bipObj = undefined
						if ( tObjs.count != 0 ) do (
							for o in tObjs do (
								--if ( fnIfChild rootObjBip o ) do ( pairs[pairsIndex].bipObj = o )
								pairs[pairsIndex].bipObj = o
							)
						)
					)
					
					default: (readDelimitedString openStream "\n")
				)
			)
		)
		fnSetList ()
		
		close openStream
	)
	
	on uiBtnSaveAs pressed do ( 
		file = (getSaveFileName caption:"Save sftb file" types:"Sox Fbx to Biped (*.sftb)|*.sftb|All (*.*)|*.*|")

		-- 저장 전 계층구조 기준으로 소팅 수행 (랙이 걸리는 작업임)
		fnSortByHierarchy ()
		fnSetList ()

		try (
			if (file != undefined) and (ss = createFile file) != undefined do
			(
			format "%" (fnSetFileStream() as string) to:ss

			flush ss
			close ss
			true
			)
		) catch ( messagebox "File Access Error" )
	)
	
	/*
	on uiBtnListUp pressed do (
		if ( uiLBoxFbxBip.selection <= 1 ) do return ()
		pairs = fnSwapArray pairs uiLBoxFbxBip.selection (uiLBoxFbxBip.selection - 1)
		uiLBoxFbxBip.selection -= 1
		fnSetList ()
	)
	
	on uiBtnListDown pressed do (
		if ( uiLBoxFbxBip.selection == 0 ) do return ()
		if ( uiLBoxFbxBip.selection == uiLBoxFbxBip.items.count ) do return ()
		pairs = fnSwapArray pairs uiLBoxFbxBip.selection (uiLBoxFbxBip.selection + 1)
		uiLBoxFbxBip.selection += 1
		fnSetList ()
	)
	*/
	
	on uiBtnListAdd pressed do (
		append pairs (pairDef ())
		uiLBoxFbxBip.selection = pairs.count
		fnSetList ()
	)
	
	on uiBtnListDel pressed do (
		if ( pairs.count == 0 ) do return ()
		if ( uiLBoxFbxBip.selection == 0 ) do return ()
		deleteItem pairs uiLBoxFbxBip.selection
		fnSetList ()
	)
	
	-- 현재 선택된 오브젝트를 FBX 리트스에 추가
	on uiBtnSetFbx pressed do (
		if ( uiLBoxFbxBip.selection == 0 ) do return ()
		if ( classof selection[1] == Biped_Object ) do (
			messagebox ( "Please select NON Biped Object" )
			return ()
		)
		
		/*
		-- FBX는 계층구조의 자유도를 위해서 같은 계층구조에 있는지 검사를 생략함
		if ( fnIfChild rootObjFbx selection[1] ) == false do (
			messagebox "It must exist in same hierarchy"
			return ()
		)
		*/
		
		
		tPos = fnFindInPairsFbx (selection[1])
		if ( tPos > 0 ) do (
			-- 현재 선택된 오브젝트 이름이 기존에 이미 존재한다면
			-- 기존에 존재하는 오브젝트 연결을 일단 해제
			pairs[tPos].fbxObj = undefined
		)

		pairs[uiLBoxFbxBip.selection].fbxObj = selection[1]
		
		if uiCBoxAutoHide.state then (
			hide selection[1]
			clearSelection()
			fnSetList ()
		)
		else (
			fnSetList ()
			fnCallbackSyncSel ()
		)
	)
	on uiBtnClearFbx pressed do (
		if ( uiLBoxFbxBip.selection == 0 ) do return ()
		if ( pairs.count == 0 ) do return ()
		pairs[uiLBoxFbxBip.selection].fbxObj = undefined
		fnSetList ()
	)
	
	-- 현재 선택된 오브젝트를 Bip 리트스에 추가
	on uiBtnSetBip pressed do (
		if ( uiLBoxFbxBip.selection == 0 ) do return ()
		if ( classof selection[1] != Biped_Object and uiCBoxNonBipedMode.state == false ) do (
			messagebox ( "Please select Biped Object" )
			return ()
		)
		if ( fnIfChild rootObjBip selection[1] ) == false do (
			messagebox "It must exist in same hierarchy"
			return ()
		)
		
		tPos = fnFindInPairsBip (selection[1])
		if ( tPos > 0 ) do (
			-- 현재 선택된 오브젝트 이름이 기존에 이미 존재한다면
			-- 기존에 존재하는 오브젝트 연결을 일단 해제
			pairs[tPos].bipObj = undefined
		)

		pairs[uiLBoxFbxBip.selection].bipObj = selection[1]
		
		if uiCBoxAutoHide.state then ( 
			hide selection[1]
			clearSelection()
			fnSetList ()
		)
		else (
			fnSetList ()
			fnCallbackSyncSel ()
		)
	)
	
	on uiBtnClearBip pressed do (
		if ( uiLBoxFbxBip.selection == 0 ) do return ()
		if ( pairs.count == 0 ) do return ()
		pairs[uiLBoxFbxBip.selection].bipObj = undefined
		fnSetList ()
	)
	
	on SoxFbxToBiped open do (
			callbacks.addScript #selectionSetChanged "SoxFbxToBiped.fnCallbackSyncSel ()" id:#SFTBSelect
			callbacks.addScript #filePostOpen "SoxFbxToBiped.uiBtnReset.pressed();SoxFbxToBiped.uiBtnScanRoot.pressed()" id:#SFTBOpen
			callbacks.addScript #systemPostNew "SoxFbxToBiped.uiBtnReset.pressed();SoxFbxToBiped.uiBtnScanRoot.pressed()" id:#SFTBNew
			callbacks.addScript #systemPostReset "SoxFbxToBiped.uiBtnReset.pressed();SoxFbxToBiped.uiBtnScanRoot.pressed()" id:#SFTBReset
		
			rootObjFbx = undefined
			rootObjBip = undefined
		
-- 			uiSpnThickHor.value	= 0.5
-- 			uiSpnThickVer.value	= 0.4

			uiBtnScanRoot.pressed()
			fnSetList ()
			fnSetFixedDistHelperButton()
		)
	
	on SoxFbxToBiped close do (
			callbacks.removeScripts id:#SFTBSelect
			callbacks.removeScripts id:#SFTBOpen
			callbacks.removeScripts id:#SFTBNew
			callbacks.removeScripts id:#SFTBReset
	)

	/* -- Fixed Distance Helper 에 의해 필요 없어진 기능 주석 처리
	on uiBtnDeletePosKeys pressed do
	(
		if (selection.count < 1) do return()

		for obj in selection do 
		(
			if (getClassName obj.position.controller == "Position XYZ") do
			(
				for p = 1 to 3 do -- 1,2,3 은 x, y, z 포지션
				(
					track = obj.position.controller[p].controller -- 포지션 컨트롤러 선택
		
					-- select keys by skip each 5th
					for i = 1 to track.keys.count do
					(
						-- 현재 타임의 키만 제외하고 나머지 키를 다 선택한다.
						if (track.keys[i].time <= sliderTime) then
						(
							deselectKey track i
						)
						else
						(
							selectKey track i
						)
					)
					
					-- delete selected keys
					deleteKeys track #selection
				)
			)
		)
	)
	*/
	
	on uiBtnFDHelper pressed do (
		if (selection.count < 1) do return()
		
		undo on (
			-- FBXtoBiped_FixedDistHelperType == "LookAt" 를 선택하고 버튼을 누르면 부모와 타겟 본을 자동으로 선택한다.
			if (fnGetHelperType selection[1] == "LookAt" or fnGetHelperType selection[1] == "Orientation") do
			(
				local selArray = #()
				local tObj = fnGetParentObj selection[1]
				if (tObj != undefined) do (append selArray tObj)
				tObj = fnGetTargetObj selection[1]
				if (tObj != undefined) do (append selArray tObj)
				select selArray
			)
			
			if (selection.count < 2) do return()
			
			-- 여기까지 오면 최초 본 두 개를 선택했던, LookAt 헬퍼를 선택했던 상관 없이 선택 두 개는 본 두 개이다.
			local selA = selection[1]
			local selB = selection[2]
			
			-- 두 본 선택 기준으로 적절한 헬퍼가 있는지 얻어온다. 적절한게 없으면 undefined
			local newPointA = fnGetLookAtHelper selA selB
				
			-- newPointA 가 비어있으면 채운다.
			if (newPointA == undefined) do
			(
				local newPointA = Point()
				newPointA.wireColor = yellow
				newPointA.transform = selA.transform
				newPointA.parent = selA
				newPointA.name = selA.name + "--" + selB.name + " LookAt"
				newPointA.cross = on
				newPointA.Box = off
				newPointA.axistripod = off
				newPointA.centermarker = off
				newPointA.size = uiSpinFDHelperSize.value
				setUserProp newPointA "FBXtoBiped_FixedDistHelperType" "LookAt"
				setUserProp newPointA "FBXtoBiped_FixedDistHelperParent" selA.inode.handle -- FixedDistHelper 는 리깅 과정에서 부모가 수시로 바뀌므로 원래 어떤 본을 부모로 했는지 고유번호를 기록해둔다.
				setUserProp newPointA "FBXtoBiped_FixedDistHelperTarget" selB.inode.handle -- 위와 비슷한 이유로 일단 기록히둔다. 사용할지는 미지수.
			)
			
			newPointA.rotation.controller = LookAt_Constraint ()
			
			-- 이미 LookAt 타겟이 있으면 삭제
			if (newPointA.rotation.controller.getNumTargets () >= 1) do (
				for i = 1 to newPointA.rotation.controller.getNumTargets () do (
					newPointA.rotation.controller.deleteTarget 1 -- 가장 위의것만 여러 번 삭제
				)
			)
			
			newPointA.rotation.controller.appendTarget selB 50
			newPointA.rotation.controller.pickUpNode =  selA
			newPointA.rotation.controller.upnode_world = false
			newPointA.rotation.controller.lookat_vector_length = 0
			
			case of
			(
				(uiRBtnFDHelperForward.state == 1): (
					-- X
					newPointA.rotation.controller.target_axis = 0
					newPointA.rotation.controller.StoUP_axis = 2
					newPointA.rotation.controller.upnode_axis = 2
				)
				(uiRBtnFDHelperForward.state == 2): (
					-- Y
					newPointA.rotation.controller.target_axis = 1
					newPointA.rotation.controller.StoUP_axis = 2
					newPointA.rotation.controller.upnode_axis = 2
				)
				(uiRBtnFDHelperForward.state == 3): (
					-- Z
					newPointA.rotation.controller.target_axis = 2
					newPointA.rotation.controller.StoUP_axis = 1
					newPointA.rotation.controller.upnode_axis = 1
				)
			)
			newPointA.rotation.controller.target_axisFlip = uiCBoxFDHelperForwardFlip.state
			
			-- 두 본 선택 기준으로 적절한 헬퍼가 있는지 얻어온다. 적절한게 없으면 undefined
			local newPointB = fnFindOrientationHelperByTarget selB
				
			if (newPointB == undefined) do (
				newPointB = Point()
				newPointB.wireColor = yellow
				newPointB.transform = newPointA.transform
				newPointB.parent = selA
				newPointB.name = selA.name + " Orientation"
				newPointB.cross = off
				newPointB.Box = on
				newPointB.axistripod = off
				newPointB.centermarker = off
				newPointB.size = uiSpinFDHelperSize.value * 0.85

				setUserProp newPointB "FBXtoBiped_FixedDistHelperType" "Orientation"
				setUserProp newPointB "FBXtoBiped_FixedDistHelperParent" selA.inode.handle -- FixedDistHelper 는 리깅 과정에서 부모가 수시로 바뀌므로 원래 어떤 본을 부모로 했는지 고유번호를 기록해둔다.
				setUserProp newPointB "FBXtoBiped_FixedDistHelperTarget" selB.inode.handle -- 위와 비슷한 이유로 일단 기록히둔다. 사용할지는 미지수.
				setUserProp newPointB "FBXtoBiped_FixedDistPointerLookAt" newPointA.inode.handle -- 참조할 LookAt 헬퍼를 기록
				setUserProp newPointA "FBXtoBiped_FixedDistPointerOrientation" newPointB.inode.handle -- LookAt 헬퍼에 참조할 Orientation 헬퍼를 기록
			)

			newPointB.rotation.controller = Orientation_Constraint ()
			
			-- 이미 Orientation 타겟이 있으면 삭제
			if (newPointB.rotation.controller.getNumTargets () >= 1) do (
				for i = 1 to newPointB.rotation.controller.getNumTargets () do (
					newPointB.rotation.controller.deleteTarget 1 -- 가장 위의것만 여러 번 삭제
				)
			)
			
			newPointB.rotation.controller.appendTarget newPointA 50

			-- newPointB의 Parent 본을 타겟으로 하는 Orientation 헬퍼를 찾는다.
			local parentOrientation = fnFindOrientationHelperByTarget (fnGetParentObj newPointB)
			if (parentOrientation != undefined) do (
				newPointB.parent = parentOrientation
				local parentLookAt = fnGetLookAtHelperByPointer parentOrientation
				-- distance를 측정해서 expression 내용에 바로 넣는 방식은 스케일이 적용된 경우 골치아프기때문에
				-- 일반 컨트롤러로 강제로 전환한 후 다시 Expression 으로 전환해서 디폴트 값을 사용한다.
				newPointB.pos.controller = Position_XYZ ()
				newPointB.position = selA.position
				newPointB.pos.controller = Position_Expression ()
			)

			-- 부모 -> 자식의 순서로 헬퍼를 생성하면 문제가 없지만, 반대로 생성하면 Orientation 헬퍼의 부모가 제대로 연결되지 않으니 자식에 연결되지 않은게 있는지 찾아본다.
			-- selB를 parent 로 하는 Orientation 헬퍼를 찾는 방식
			for obj in helpers do (
				if (fnGetHelperType obj == "Orientation") do (
					if ((fnGetParentObj obj) == selB) do (
						obj.parent = newPointB
						newPointB.pos.controller = Position_Expression ()
					)
				)
			)

			select newPointB
		) -- end fo UnDo
	)

	on uiSpinFDHelperSize changed value do (
		local objs = #()
		-- 하나만 선택했는데 Fixed Distance 관련 헬퍼일 경우 쌍으로 스케일을 조절
		if (selection.count == 1) then (
			append objs selection[1]
			if (fnGetHelperType selection[1] == "LookAt") do (
				append objs (fnGetOrientationHelperByPointer selection[1])
			)

			if (fnGetHelperType selection[1] == "Orientation") do (
				append objs (fnGetLookAtHelperByPointer selection[1])
			)
		)
		else (
			objs = selection as array
		)

		for obj in objs do (
			if (classof obj == Point) do (
				if ((fnGetHelperType obj) == "LookAt") do (
					obj.size = value
				)
				if ((fnGetHelperType obj) == "Orientation") do (
					obj.size = value * 0.85
				) 
			)
		)
	)
	
	on uiBtnAbout pressed do
	(
		shellLaunch "http://cafe.naver.com/pinksox/6064" ""
	)
	
)

createDialog SoxFbxToBiped style:#(#style_titlebar, #style_toolwindow, #style_sysmenu) lockWidth:true