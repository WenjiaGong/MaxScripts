try(destroyDialog rol_copyPasteAni;)
catch()

--		物体姿势信息结构定义：物体名称，父物体名称，物体类型，世界坐标信息，相对父物体的位移，相对父物体的旋转，相对父物体的缩放。
struct 	objPoseInfo (nameIs,parentName,bipObj,trans,localPos,localRotation,localScale);
--		物体动画信息结构定义。
struct 	objAnimInfo (nameIs,classIs,bipParent,localTransform,subAnimName,subVisibility,subSpaceWarps,subTransform,subObject,subMaterial,subImage,subMotion);
--		子动画信息结构定义。
struct 	subAnimInfo (subName,ctrlClass,propName,propValue,keyTime,keyInfo);
--		关键帧信息结构定义。
struct 	subKeysInfo (k_propName,k_propValue);

rollout rol_copyPasteAni "复制|粘帖 动画|POSE" width:200 height:280
(
	---		脚本名称。
	local 	CopyPasteAni_Name = "CopyPasteAni";
	--		脚本版本。
	local 	CopyPasteAni_Version = "1.00";
	--		脚本内部序号。
	local 	CopyPasteAni_ID = "In-Company";
	--		脚本创建信息。
	local 	CopyPasteAni_BuildInfo = "3dsMax 8. 2008-3-3, at Company.";
	--		Script Data Folder
	local 	CopyPasteAni_FilePath = (GetDir #maxRoot) + "Coo!ToolsData\\AnimatorTools\\" + CopyPasteAni_Name + "\\";
	--		脚本配置文件。
	local 	CopyPasteAniIni_name = CopyPasteAni_FilePath + CopyPasteAni_Name + ".ini";
	--	
	local 	rol = rol_copyPasteAni;
	--		
	local 	history_str = "";
	--		已复制的POSE。
	local 	copyedPose_ary = #();
	--		已复制的动画。
	local 	copyedAnim_ary = #();
	
	/*创建按钮图标的遮罩。*/
	Function fn_invertMaskBitmap bitmapFileName_str bk_color =
	(
		try
		(
			local i_bitmap = openBitMap bitmapFileName_str;
			local invertBitmap = bitmap i_bitmap.width i_bitmap.height;
			
			for y in 0 to (i_bitmap.height - 1) do
			(
				for x in 0 to (i_bitmap.width - 1) do
				(
					local i_color = (getPixels i_bitmap [x,y] 1)[1];
					
					i_color = color (i_color.r as integer) (i_color.g as integer) (i_color.b as integer);
					if i_color == bk_color then setPixels invertBitmap [x,y] #(white);
					else setPixels invertBitmap [x,y] #(BLACK);
				)
			)
			return invertBitmap;
		)
		catch()
	)
	
	/*从图片中获取图标。*/
	Function fn_getIconFromBitmap bitmap_str bitmapIconCount_int getIconIndex_int filter_col=
	(
		try
		(
			local icon;
			local bmp = openBitMap bitmap_str;
			
			icon = bitmap (bmp.width / bitmapIconCount_int) bmp.height color:white;
			for y in 0 to bmp.height - 1 do
			(
				local temp = getPixels bmp [(getIconIndex_int * icon.width) - icon.width,y] icon.width;
				for n in 1 to temp.count do
				(
					local i_color = color (temp[n].r as integer) (temp[n].g as integer) (temp[n].b as integer);
					if i_color == filter_col do temp[n] = white;
				)
				setPixels icon [0,y] temp;
			)
			return icon;
		)
		catch()
	)
	
	/*显示按钮图标。*/
	Function fn_ctrlBitmap =
	(
		try
		(
			local bmp,mask;
			local icon_bmp,mask_bmp;
			--	建立 数据文件夹。
			if not(doesFileExist CopyPasteAni_FilePath) do
			(
				DOSCommand ("md " + CopyPasteAni_FilePath);
			)
			--	建立 INI文件。
			if not(doesFileExist CopyPasteAniIni_name) do
			(
				local iniFile = createFile CopyPasteAniIni_name;
				format "[SaveHistory]\n" to:iniFile;
				format "History=\"\"\n" to:iniFile;
				close iniFile;
			)
			--	建立按钮图标。
			if not(doesFileExist (CopyPasteAni_FilePath + "CopyPasteAni_Icon.bmp")) do
			(
				local bmp_str = "";
				local icon_ary = #();
				
				if doesFileExist ((GetDir #ui) + "\\Icons\\bip_copycol_i.bmp") do
				(
					local index_bAry = #{1..6,9,10,13..16};
					bmp_str = (GetDir #ui) + "\\Icons\\bip_copycol_i.bmp";
					for n in index_bAry do append icon_ary (fn_getIconFromBitmap bmp_str 16 n (color 191 191 191));
				)
				if doesFileExist ((GetDir #ui) + "\\Icons\\bip_mflscript_i.bmp") do
				(
					local index_bAry = #{13..16};
					bmp_str = (GetDir #ui) + "\\Icons\\bip_mflscript_i.bmp";
					for n in index_bAry do append icon_ary (fn_getIconFromBitmap bmp_str 22 n (color 191 191 191));
				)
				if doesFileExist ((GetDir #ui) + "\\Icons\\bip_comtrack_i.bmp") do
				(
					local index_bAry = #{7..12};
					bmp_str = (GetDir #ui) + "\\Icons\\bip_comtrack_i.bmp";
					for n in index_bAry do append icon_ary (fn_getIconFromBitmap bmp_str 12 n (color 191 191 191));
				)
				if doesFileExist ((GetDir #ui) + "\\Icons\\ReactionManager_i.bmp") do
				(
					local index_bAry = #{5,16};
					bmp_str = (GetDir #ui) + "\\Icons\\ReactionManager_i.bmp";
					for n in index_bAry do append icon_ary (fn_getIconFromBitmap bmp_str 22 n (color 197 197 197));
				)
				if doesFileExist ((GetDir #ui) + "\\Icons\\Classic_16i.bmp") do
				(
					local index_bAry = #{21..26};
					bmp_str = (GetDir #ui) + "\\Icons\\Classic_16i.bmp";
					for n in index_bAry do append icon_ary (fn_getIconFromBitmap bmp_str 78 n (color 192 192 192));
				)
				if doesFileExist ((GetDir #ui) + "\\Icons\\MeditImages_i.bmp") do
				(
					local index_bAry = #{33,34};
					bmp_str = (GetDir #ui) + "\\Icons\\MeditImages_i.bmp";
					for n in index_bAry do append icon_ary (fn_getIconFromBitmap bmp_str 37 n (color 188 188 188));
				)
				
				icon_bmp = bitmap (icon_ary.count * 16) 15 fileName:(CopyPasteAni_FilePath + "CopyPasteAni_icon.bmp") color:white;
				for n in 1 to icon_ary.count do
				(
					for y in 0 to 14 do
					(
						local offset_x = 0;
						local offset_y = 0;
						local temp = getPixels icon_ary[n] [0,y] icon_ary[n].width;
						if icon_ary[n].width < 16 do offset_x = (16 - icon_ary[n].width) / 2;
						if icon_ary[n].height < 15 do offset_y = (15 - icon_ary[n].height) / 2;
						setPixels icon_bmp [((n - 1) *16 + offset_x),(y + offset_y)] temp;
					)
				)
				save icon_bmp;
			)
			
			if doesFileExist (CopyPasteAni_FilePath + "CopyPasteAni_Icon.bmp") do
			(
				local icon_bmp = openBitMap (CopyPasteAni_FilePath + "CopyPasteAni_Icon.bmp");
				local n = icon_bmp.width / 16;
				
				mask_bmp = fn_invertMaskBitmap (CopyPasteAni_FilePath + "CopyPasteAni_icon.bmp") white;
				rol.btn_new.images = #(icon_bmp,mask_bmp,n,1,1,2,2);
				rol.btn_open.images = #(icon_bmp,mask_bmp,n,3,3,4,4);
				rol.btn_save.images = #(icon_bmp,mask_bmp,n,7,7,8,8);
				rol.btn_del.images = #(icon_bmp,mask_bmp,n,9,9,10,10);
				rol.btn_delAll.images = #(icon_bmp,mask_bmp,n,11,11,12,12);
				rol.btn_copy.images = #(icon_bmp,mask_bmp,n,13,13,14,14);
				rol.btn_paste.images = #(icon_bmp,mask_bmp,n,15,15,16,16);
				rol.ckb_pasteOther.images = #(icon_bmp,mask_bmp,n,23,23,24,24);
				rol.ckb_pasteMove.images = #(icon_bmp,mask_bmp,n,25,25,26,26);
				rol.ckb_pasteRotate.images = #(icon_bmp,mask_bmp,n,27,27,28,28);
				rol.ckb_pasteScale.images = #(icon_bmp,mask_bmp,n,29,29,30,30);
			)
			freeSceneBitmaps();
		)
		catch()
	)
	
	/*按钮状态*/
	Function fn_ctrlState =
	(
		try
		(
			--	屏蔽所有按钮。
			for ctrl in rol.controls do ctrl.enabled = false;
			--	创建新的复制。
			rol.btn_new.enabled = true;
			--	打开存盘动画文件。
			rol.btn_open.enabled = true;
			--	保存复制的动画。
			if rol.rdo_copyType.state == 1 then rol.btn_save.enabled = (rol.ddl_listAni.items.count != 0);
			else rol.btn_save.enabled = (rol.ddl_listPose.items.count != 0);
			--	复制 动画/POSE。
			rol.btn_copy.enabled = true;
			--	粘帖 动画/POSE。
			if rol.rdo_copyType.state == 1 then rol.btn_paste.enabled = (selection.count != 0 and rol.ddl_listAni.items.count != 0);
			else rol.btn_paste.enabled = (selection.count != 0 and rol.ddl_listPose.items.count != 0);
			--	删除 当前复制的动画/POSE。
			if rol.rdo_copyType.state == 1 then rol.btn_del.enabled = (rol.ddl_listAni.items.count != 0);
			else rol.btn_del.enabled = (rol.ddl_listPose.items.count != 0);
			--	删除 所有已复制的动画/POSE。
			if rol.rdo_copyType.state == 1 then rol.btn_delAll.enabled = (rol.ddl_listAni.items.count != 0);
			else rol.btn_delAll.enabled = (rol.ddl_listPose.items.count != 0);
			--	复制所选物体的：动画 姿势。
			rol.lbl_copyType.enabled = true;
			--	复制所选物体的：动画 姿势。
			rol.rdo_copyType.enabled = true;
			--	已复制的动画。
			rol.ddl_listAni.enabled = (selection.count != 0 and rol.ddl_listAni.items.count != 0);
			if rol.rdo_copyType.state == 1 then rol.ddl_listAni.pos.y = 80;
			else rol.ddl_listAni.pos.y = -80;
			rol.ddl_listAni.items =  rol.ddl_listAni.items;
			--	已复制的姿势。
			rol.ddl_listPose.enabled = (selection.count != 0 and rol.ddl_listPose.items.count != 0);
			if rol.rdo_copyType.state == 2 then rol.ddl_listPose.pos.y = 80;
			else rol.ddl_listPose.pos.y = -80;
			rol.ddl_listPose.items =  rol.ddl_listPose.items;
			--	粘帖动画/POSE。
			if rol.rdo_copyType.state == 1 then rol.lbl_paste.enabled = (rol.ddl_listAni.items.count != 0);
			else rol.lbl_paste.enabled = (rol.ddl_listPose.items.count != 0);
			--	粘帖物体上其他的动画。
			if rol.rdo_copyType.state == 1 then
			(
				rol.ckb_pasteOther.enabled = (rol.ddl_listAni.items.count != 0);
			)
			else
			(
				rol.ckb_pasteOther.enabled = false;
				rol.ckb_pasteOther.state = false;
			)
			--	仅粘帖位移动画。
			if rol.rdo_copyType.state == 1 then
			(
				rol.ckb_pasteMove.enabled = (rol.ddl_listAni.items.count != 0);
			)
			else
			(
				rol.ckb_pasteMove.enabled = false;
				rol.ckb_pasteMove.state = (rol.ddl_listPose.items.count != 0);
			)
			--	仅粘贴旋转动画。
			if rol.rdo_copyType.state == 1 then
			(
				rol.ckb_pasteRotate.enabled = (rol.ddl_listAni.items.count != 0);
			)
			else
			(
				rol.ckb_pasteRotate.enabled = false;
				rol.ckb_pasteRotate.state = (rol.ddl_listPose.items.count != 0);
			)
			--	仅粘贴缩放动画。
			if rol.rdo_copyType.state == 1 then
			(
				rol.ckb_pasteScale.enabled = (rol.ddl_listAni.items.count != 0);
			)
			else
			(
				rol.ckb_pasteScale.enabled = false;
				rol.ckb_pasteScale.state = (rol.ddl_listPose.items.count != 0);
			)
		)
		catch()
	)
	
	/*复制所选物体的POSE*/
	Function copyObjPose =
	(
		try
		(
			local poseSaveIni;
			--	创建帮助物体。
			local i_help = point name:"CopyAnimtedObj_helper";
			--	复制物体信息数组。
			local pose_ary = #();
			
			/*依次从当前选择的物体中收集信息。*/
			for n in 1 to selection.count do
			(
				--	初始化单个物体的信息。
				local info = objPoseInfo nameIs:selection[n].name trans:selection[n].transform;
				
				--	判断是否为BIP所属物体。
				try
				(
					info.bipObj = ((biped.getNode selection[n] #vertical link:1) != undefined);
				)
				catch
				(
					info.bipObj = false;
				)
				--	将帮助物体移动到物体相同坐标。
				try
				(
					i_help.scale = selection[n].scale;
					i_help.rotation = selection[n].rotation;
					i_help.pos = selection[n].pos;
				)
				catch(i_help.transform = selection[n].transform;)
				--	被收集物体有 父物体，收集：父物体名称，相对父物体的位移，相对父物体的旋转，相对父物体的缩放。
				if selection[n].parent != undefined then
				(
					info.parentName 	= selection[n].parent.name;
					info.localPos 		= in coordsys selection[n].parent i_help.pos;
					info.localRotation 	= in coordsys selection[n].parent i_help.rotation;
					info.localScale 		= in coordsys selection[n].parent i_help.scale;
				)
				--	将收集好的信息添加到 复制物体信息数组 中。
				append pose_ary info;
			)
			--	收集完毕，删除帮助物体。
			delete i_help;
			return pose_ary;
		)
		catch()
	)
	
	/*粘帖所选物体的POSE*/
	Function pasteObjPose pose_ary =
	(
		try
		(
			--	创建帮助物体。
			local i_help = point name:"CopyAnimtedObj_helper";
			--	已复制POSE物体的名称数组。
			local savedObjName_ary = for info in pose_ary collect info.nameIs;
			--	按名称过滤已选择的物体 并 添加到需要粘帖POSE物体数组中。
			local pasteObj_ary = for obj in selection where findItem savedObjName_ary obj.name != 0 collect obj;
			--	盆骨和脊柱骨记录数组。
			local spines_ary = #();
			
			/*检查需要粘帖POSE物体中是否存在BIP物体，对BIP物体，取出盆骨和脊柱骨存入记录数组。。*/
			for obj in pasteObj_ary where classOf obj == Biped_Object do
			(
				for n in 1 to 4 where (biped.getNode obj #spine link:n) != undefined do
				(
					if findItem spines_ary (biped.getNode obj #spine link:n) == 0 do append spines_ary (biped.getNode obj #spine link:n);
				)
				--	添加盆骨到数组中。
				if findItem spines_ary (biped.getNode obj #pelvis link:1) == 0 do append spines_ary (biped.getNode obj #pelvis link:1);
			)
			/*将没有父物体的物体先进行处理，处理后将该物体从粘贴数组中去除。*/
			for obj in pasteObj_ary do
			(
				local n = findItem savedObjName_ary obj.name;
				
				if pose_ary[n].parentName == undefined do
				(
					obj.transform = pose_ary[n].trans;
					deleteItem pasteObj_ary (findItem pasteObj_ary obj);
				)
			)
			/*对粘帖物体数组中剩下有父物体的物体进行处理：处理时须从链接的根物体开始，*/
			while pasteObj_ary.count != 0 do
			(
				--	判断物体是否是BIP物体。
				local isBipObj_bol = false;
				--	物体记录：首先取出剩余物体中的第一个。
				local obj = pasteObj_ary[1];
				--	记录该物体的父物体。
				local parent = obj.parent;
				--	记录该物体在复制信息数组中的位置。
				local n = findItem savedObjName_ary obj.name;
				
				/*当物体的父物体存在时，向上追溯物体的根。*/
				while parent != undefined do
				(
					--	如果物体的父物体存在于 需要粘帖POSE物体数组中，改变物体记录为它的父物体。
					if findItem pasteObj_ary parent != 0 do
					(
						obj = parent;
						n = findItem savedObjName_ary obj.name;
					)
					parent = parent.parent;
				)
				--	移帮助动物体到物体复制记录的坐标。
				if parent == undefined then
				(
					i_help.transform = pose_ary[n].trans;
				)
				else
				(
					in coordsys obj.parent i_help.scale = pose_ary[n].localScale;
					in coordsys obj.parent i_help.rotation = pose_ary[n].localRotation;
					in coordsys obj.parent i_help.pos = pose_ary[n].localPos;
				)
				--	判断物体是否是Bip物体。
				try
				(
					isBipObj_bol = ((biped.getNode obj #vertical link:1) != undefined);
				)
				catch
				(
					isBipObj_bol = false;
				)
				--	Bip物体。
				if isBipObj_bol then
				(
					--	非盆骨和脊柱骨物体。
					if findItem spines_ary obj == 0 then
					(
						biped.setTransform obj #rotation i_help.transform.rotation false;
					)
					--	盆骨和脊柱骨物体。
					else
					(
						rotate obj -obj.transform.rotation;
						rotate obj i_help.rotation;
					)
				)
				--	一般物体。
				else
				(
					if obj.parent == undefined then
					(
						obj.transform = pose_ary[n].trans;
					)
					else
					(
						in coordsys obj.parent obj.scale = pose_ary[n].localScale;
						in coordsys obj.parent obj.rotation = pose_ary[n].localRotation;
						in coordsys obj.parent obj.pos = pose_ary[n].localPos;
					)
				)
				--	处理后将该物体从粘贴数组中去除。
				deleteItem pasteObj_ary (findItem pasteObj_ary obj);
			)
			delete i_help;
		)
		catch()
	)
	
	/*复制所选物体的动画*/
	Function copyObjAniTracks =
	(
		try
		(
			--	收集完成的信息数组，返回值。
			local copyedInfo = #();
			--	复制动画的物体，不含Biped物体。
			local copyObj_ary = #();
			--	选择物体中 非BIPED 的物体数组。
			local notBipObj_ary = #();
			--	记录用户当前帧位置。
			local currentFrame = sliderTime;
			--	用户当前时间调设置。
			local userAnimRange = animationRange;
			
			animationRange = interval 0 animationRange.end;
			sliderTime = -1000;
			/*过滤选择的物体，排除掉BIPED物体。*/
			for obj in selection do
			(
				try	(biped.getNode obj #horizontal link:1;)
				catch(append notBipObj_ary obj;)
			)
			/*判断物体是否有动画存在，将有动画的物体存入数组copyObj_ary中，这里不能使用：<property>.isAnimated，它对顶点动画该参数无效。*/
			for obj in notBipObj_ary do
			(
				local ani_bol = false;
				local ani_ary=#();
				
				--	找出该物体所有的subAnim。
				for n in 1 to obj.numSubs do
				(
					append ani_ary obj[n];
					for sub in ani_ary do
					(
						for m in 1 to sub.numSubs do append ani_ary (getSubAnim sub m);
					)
				)
				--	检查subAnim中是否有动画。
				for sub in ani_ary do
				(
					try
					(
						if sub.isAnimated do
						(
							append copyObj_ary obj;
							exit;
						)
					)
					catch()
				)
			)
			/*对选择集中有动画的物体，逐个收集动画轨道控制器、参数设置、关键帧、关键帧参数等等......*/
			for obj in copyObj_ary do
			(
				local bipLink;
				local sub_index = #{};
				--	struct objAnimInfo (nameIs,classIs,bipParent,subAnimName,subVisibility,subSpaceWarps,subTransform,subObject,subMaterial,subImage,subMotion);
				local objInfo = objAnimInfo nameIs:obj.name classIs:(classOf obj);
				
				--	父物体是否为Biped物体，如果是，需要先断开链接。
				if obj.parent != undefined do
				(
					try
					(
						if (biped.getNode obj.parent #horizontal link:1) != undefined do bipLink = obj.parent;
					)
					catch(bipLink = undefined;)
					if bipLink != undefined then
					(
						objInfo.localTransform = #();
						objInfo.localTransform[1] = in coordsys obj.parent obj.pos;
						objInfo.localTransform[2] = in coordsys obj.parent obj.rotation;
						objInfo.localTransform[3] = in coordsys obj.parent obj.scale;
						obj.parent = undefined;
						objInfo.bipParent = true;
					)
				)
				--	收集物体上有动画的subAnimName。
				objInfo.subAnimName = #();
				for n in 1 to obj.numSubs do
				(
					local aniSub_bol = false;
					local ani_ary = #(obj[n]);
					
					--	找出该物体所有的subAnim。
					for sub in ani_ary do
					(
						for m in 1 to sub.numSubs do
						(
							append ani_ary (getSubAnim sub m);
						)
					)
					--	检查subAnim中是否有动画。
					for sub in ani_ary do
					(
						try
						(
							if sub.isAnimated do
							(
								append sub_index n;
								append objInfo.subAnimName (getSubAnimName obj n);
								case n of
								(
									1 : objInfo.subVisibility = #();
									2 : objInfo.subSpaceWarps = #();
									3 : objInfo.subTransform = #();
									4 : objInfo.subObject = #();
									5 : objInfo.subMaterial = #();
									6 : objInfo.subImage = #();
									7 : objInfo.subMotion = #();
									defaule : ();
								)
								exit;
							)
						)
						catch()
					)
				)
				--	
				for n in sub_index do
				(
					local subAnim_ary = #(obj[n]);
					local subAnimName_ary = #(("$" + obj.name + "[" + n as string + "]"));
					
					--	收集子动画。
					for sub in subAnim_ary do
					(
						local index = findItem subAnim_ary sub;
						local sub_str = subAnimName_ary[index];
						
						for m in 1 to sub.numSubs do
						(
							append subAnim_ary sub[m];
							append subAnimName_ary (sub_str + "[" + m as string + "]");
						)
					)
					--	过滤子动画。
					for sub in subAnim_ary do
					(
						local noClass_bol,noProp_bol,del_bol;
						local class_str = (classOf sub.controller) as string;
						
						--	子动画控制器类型为：undefinedClass 或 DummyClass等等。
						del_bol = (findString class_str "Class" != undefined);
						--	子动画无参数设置 或 参数为0。
						if ((getPropNames sub) != undefined and (getPropNames sub).count > 0) do del_bol = false;
						if del_bol do
						(
							while (findItem subAnim_ary sub) != 0 do
							(
								deleteItem subAnimName_ary (findItem subAnim_ary sub);
								deleteItem subAnim_ary (findItem subAnim_ary sub);
							)
						)
					)
					--	
					for m in 1 to subAnim_ary.count do
					(
						--	struct subAnimInfo (subName,ctrlClass,propName,propValue,keyTime,keyInfo);
						local subInfo = subAnimInfo subName:subAnimName_ary[m] ctrlClass:(classOf subAnim_ary[m].controller);
						
						if (getPropNames subAnim_ary[m]) != undefined and (getPropNames subAnim_ary[m]).count != 0 do
						(
							subInfo.propName = getPropNames subAnim_ary[m];
							subInfo.propValue = for name in subInfo.propName collect getProperty subAnim_ary[m] name;
						)
						if subAnim_ary[m].controller != undefined and subAnim_ary[m].controller.supportsKeys and numKeys subAnim_ary[m].controller > 0 do
						(
							subInfo.keyTime = for keys in subAnim_ary[m].keys collect keys.time;
							subInfo.keyInfo = #();
							for t in 1 to subInfo.keyTime.count do
							(
								--	struct subKeysInfo (k_propName,k_propValue);
								local subKey = subKeysInfo k_propName:#() k_propValue:#();
								
								subKey.k_propName = getPropNames subAnim_ary[m].keys[t];
								subKey.k_propValue = for name in subKey.k_propName collect (getProperty subAnim_ary[m].keys[t] name);
								append subInfo.keyInfo subKey;
							)
						)
						case n of
						(
							1 : append objInfo.subVisibility subInfo;
							2 : append objInfo.subSpaceWarps subInfo;
							3 : append objInfo.subTransform subInfo;
							4 : append objInfo.subObject subInfo;
							5 : append objInfo.subMaterial subInfo;
							6 : append objInfo.subImage subInfo;
							7 : append objInfo.subMotion subInfo;
							defaule : ();
						)
					)
				)
				append copyedInfo objInfo;
				--	还原父链接。
				if bipLink != undefined do obj.parent = bipLink;
			)
			animationRange = userAnimRange;
			sliderTime = currentFrame;
			return copyedInfo;
		)
		catch()
	)
	
	/*粘帖所选物体的动画*/
	Function pasteObjAniTracks savedObj_ary filter_ary =
	(
		try
		(
			--	存盘文件中记录的动画物体名字数组。
			local copyedObjName_ary = for objInfo in savedObj_ary collect objInfo.nameIs;
			--	存盘文件中记录的动画物体类型数组。
			local copyedObjClass_ary = for objInfo in savedObj_ary collect objInfo.classIs;
			--	需要粘帖动画的物体数组。
			local pasteObj_ary = #()
			--	需要粘帖动画的物体名称数组。
			local pasteObjInfo_ary = #();
			--	记录用户当前帧位置。
			local currentFrame = sliderTime;
			--	用户当前时间调设置。
			local userAnimRange = animationRange;
			
			animationRange = interval 0 animationRange.end;
			sliderTime = -1000;
			for obj in selection do
			(
				local n = findItem copyedObjName_ary obj.name;
				
				if n != 0 do
				(
					append pasteObj_ary obj;
					append pasteObjInfo_ary savedObj_ary[n];
				)
			)
			sliderTime = animationRange.start;
			for n in 1 to pasteObj_ary.count do
			(
				--	当前物体的复制物。
				local i_helper;
				--	当前的物体。
				local obj = pasteObj_ary[n];
				--	当前物体的复制信息。
				local objInfo = pasteObjInfo_ary[n];
				--	但却物体复制信息中的子动画名词数组。
				local pasteSubAnimName_ary = objInfo.subAnimName;
				--	物体当前的父链接。
				local currentParent;
				
				--	物体当前有父链接 并且 在复制信息中 它的父链接是biped物体：先断开链接。
				if objInfo.bipParent == true do
				(
					currentParent = obj.parent;
					obj.parent = undefined;
				)
				
				for m in 1 to obj.numsubs do
				(
					local subAnim_ary;
					local subName = getSubAnimName obj m;
					
					case m of
					(
						1 : subAnim_ary = objInfo.subVisibility;
						2 : subAnim_ary = objInfo.subSpaceWarps;
						3 : subAnim_ary = objInfo.subTransform;
						4 : subAnim_ary = objInfo.subObject;
						5 : subAnim_ary = objInfo.subMaterial;
						6 : subAnim_ary = objInfo.subImage;
						7 : subAnim_ary = objInfo.subMotion;
						default : ()
					)
					if classOf obj != copyedObjClass_ary[n] do
					(
						if m == 2 or m == 4 do subAnim_ary = undefined;
					)
					--	 参数限定：过滤非位移、旋转、放缩的动画。
					if m != 3 and filter_ary[1] == false do subAnim_ary = undefined;
					
					if subAnim_ary != undefined and findItem pasteSubAnimName_ary subName != undefined do
					(
						--	还原控制器类型和初始参数
						for w in 1 to subAnim_ary.count do
						(
							local ignore_bol = true;
							local class_str = (subAnim_ary[w].ctrlClass as string) + "()";
							local i_propName = subAnim_ary[w].propName;
							local i_propValue = subAnim_ary[w].propValue;
							local i_subName = subAnim_ary[w].subName;
							
							if m == 3 do
							(
								if filter_ary[2] == false and findString i_subName ("$" + obj.name + "[3][1]") != undefined do ignore_bol = false;
								if filter_ary[3] == false and findString i_subName ("$" + obj.name + "[3][2]") != undefined do ignore_bol = false;
								if filter_ary[4] == false and findString i_subName ("$" + obj.name + "[3][3]") != undefined do ignore_bol = false;
							)
							
							--	还原控制器类型。
							if findString class_str "Class" == undefined do
							(
								try	(if ignore_bol do execute (subAnim_ary[w].subName + ".controller = " + class_str);)
								catch()
							)
							--	还原控制器参数。
							if i_propName != undefined and i_propValue != undefined do
							(
								for v in 1 to i_propName.count do
								(
									local i_sub = execute subAnim_ary[w].subName;
									
									try	(if ignore_bol do setProperty i_sub i_propName[v] i_propValue[v];)
									catch()
								)
							)
						)
						
						--	通过i_helper帮助物体重整当前物体的Controller。
						i_helper = copy obj;
						i_helper.name = "AnimCtrlRepObj";
						for sub in subAnim_ary do
						(
							try
							(
								local ctrl = execute (sub.subName + ".controller");
								local indexs = replace sub.subName 1 (obj.name.count + 1) "";
								
								if ctrl != undefined do
								(
									execute (sub.subName + ".controller = copy ($AnimCtrlRepObj" +  indexs + ".controller)");
								)
							)
							catch()
						)
						delete i_helper;
						--	控制器上关键帧的设置
						for w in 1 to subAnim_ary.count where subAnim_ary[w].keyTime != undefined and subAnim_ary[w].keyInfo != undefined do
						(
							local ignore_bol = true;
							local i_sub = execute subAnim_ary[w].subName;
							local i_time = subAnim_ary[w].keytime;
							local i_keyInfo = subAnim_ary[w].keyInfo;
							local i_subName = subAnim_ary[w].subName;
							
							if m == 3 do
							(
								if filter_ary[2] == false and findString i_subName ("$" + obj.name + "[3][1]") != undefined do ignore_bol = false;
								if filter_ary[3] == false and findString i_subName ("$" + obj.name + "[3][2]") != undefined do ignore_bol = false;
								if filter_ary[4] == false and findString i_subName ("$" + obj.name + "[3][3]") != undefined do ignore_bol = false;
							)
							if ignore_bol do
							(
								try
								(
									--	删除现在的关键帧。
									deleteKeys i_sub.controller #allKeys;
									for t in 1 to i_time.count do
									(
										local p_name = i_keyInfo[t].k_propName;
										local p_value = i_keyInfo[t].k_propValue;
										
										--	还原关键帧的时间位置。
										addNewKey i_sub.controller i_time[t];
										--	还原关键帧参数。
										if findItem p_name "#x_locked" != 0 do setProperty i_sub.keys[t] #x_locked false;
										if findItem p_name "#y_locked" != 0 do setProperty i_sub.keys[t] #y_locked false;
										if findItem p_name "#z_locked" != 0 do setProperty i_sub.keys[t] #z_locked false;
										for x in 1 to p_name.count do
										(
											try
											(
												setProperty i_sub.keys[t] p_name[x] p_value[x];
											)
											catch()
										)
									)
								)
								catch()
							)
						)
					)
				)
				--	还原父链接。
				if currentParent != undefined do 
				(
					obj.Parent = currentParent;
					in coordsys obj.parent obj.scale = objInfo.localTransform[3];
					in coordsys obj.parent obj.rotation = objInfo.localTransform[2];
					in coordsys obj.parent obj.pos = objInfo.localTransform[1];
				)
			)
			animationRange = userAnimRange;
			sliderTime = currentFrame;
		)
		catch()
	)
	
	/*保存复制信息到文件*/
	Function saveObjPose file_str =
	(
		try
		(
			local i_file,file_txt;
			
			/*保存姿势信息到文件中。*/
			file_txt = "[ObjectPoseCopy]\n";
			file_txt += "Count=" + copyedPose_ary.count as string + "\n\n";
			for n in 1 to copyedPose_ary.count do
			(
				file_txt += "[CopyPose_" + n as string + "]\n";
				file_txt += "Name=" + rol.ddl_listPose.items[n] + "\n";
				file_txt += "Count=" + copyedPose_ary[n].count as string + "\n";
				for m in 1 to copyedPose_ary[n].count do
				(
					file_txt += "[CopyPose_" + n as string + "_" + m as string + "]\n";
					file_txt += "nameIs=\"" + copyedPose_ary[n][m].nameIs + "\"\n";
					if copyedPose_ary[n][m].parentName != undefined do file_txt += "parentName=\"" + copyedPose_ary[n][m].parentName + "\"\n";
					file_txt += "bipObj=" + copyedPose_ary[n][m].bipObj as string + "\n";
					file_txt += "Trans=" + copyedPose_ary[n][m].Trans as string + "\n";
					if copyedPose_ary[n][m].localPos != undefined do file_txt += "localPos=" + copyedPose_ary[n][m].localPos as string + "\n";
					if copyedPose_ary[n][m].localRotation != undefined do file_txt += "localRotation=" + copyedPose_ary[n][m].localRotation as string + "\n";
					if copyedPose_ary[n][m].localScale != undefined do file_txt += "localScale=" + copyedPose_ary[n][m].localScale as string + "\n";
				)
			)
			file_txt += "-----------------------\n\n";
			/*保存动画信息到文件中。*/
			file_txt += "[ObjectAnimCopy]\n";
			file_txt += "Count=" + copyedAnim_ary.count as string + "\n\n";
			for n in 1 to copyedAnim_ary.count do
			(
				file_txt += "[CopyAnim_" + n as string + "]\n";
				file_txt += "Name=" + rol.ddl_listAni.items[n] + "\n";
				file_txt += "Count=" + copyedAnim_ary[n].count as string + "\n";
				for m in 1 to copyedAnim_ary[n].count do
				(
					local i_struct;
					
					--	struct objAnimInfo (nameIs,classIs,bipParent,subAnimName,subVisibility,subSpaceWarps,subTransform,subObject,subMaterial,subImage,subMotion);
					file_txt += "[CopyAnim_" + n as string + "_" + m as string + "]\n";
					--	nameIs
					file_txt += "nameIs=\"" + copyedAnim_ary[n][m].nameIs + "\"\n";
					--	classIs
					file_txt += "classIs=" + copyedAnim_ary[n][m].classIs as string + "\n";
					--	bipParent
					file_txt += "bipParent=" + copyedAnim_ary[n][m].bipParent as string  + "\n";
					--	subAnimName
					file_txt += "subAnimName=" + copyedAnim_ary[n][m].subAnimName as string + "\n";
					
					for name in copyedAnim_ary[n][m].subAnimName do
					(
						local index = findItem (getSubAnimNames (execute ("$" + copyedAnim_ary[n][m].nameIs))) name;
						
						--	subVisibility,subSpaceWarps,subTransform,subObject,subMaterial,subImage,subMotion
						case index of
						(
							1 : i_struct = copyedAnim_ary[n][m].subVisibility;
							2 : i_struct = copyedAnim_ary[n][m].subSpaceWarps;
							3 : i_struct = copyedAnim_ary[n][m].subTransform;
							4 : i_struct = copyedAnim_ary[n][m].subObject;
							5 : i_struct = copyedAnim_ary[n][m].subMaterial;
							6 : i_struct = copyedAnim_ary[n][m].subImage;
							7 : i_struct = copyedAnim_ary[n][m].subMotion;
							default : ()
						)
						if i_struct != undefined do
						(
							file_txt += "[CopyAnim_" + n as string + "_" + m as string + "_" + index as string + "]\n";
							file_txt += "Count=" + i_struct.count as string + "\n";
							for w in 1 to i_struct.count do
							(
								file_txt += "[CopyAnim_" + n as string + "_" + m as string + "_" + index as string + "_" + w as string + "]\n";
								--	subAnimInfo (subName,ctrlClass,propName,propValue,keyTime,keyInfo);
								file_txt += "subName=\"" + i_struct[w].subName as string + "\"\n";
								file_txt += "ctrlClass=" + i_struct[w].ctrlClass as string + "\n";
								if  i_struct[w].propName != undefined do
								(
									file_txt += "propName=" + i_struct[w].propName as string + "\n";
								)
								if i_struct[w].propValue != undefined do
								(
									file_txt += "propValue=" + i_struct[w].propValue as string + "\n";
								)
								if i_struct[w].keyTime != undefined do
								(
									file_txt += "keyTime=" + i_struct[w].keyTime as string + "\n";
								)
								if i_struct[w].keyInfo != undefined do
								(
									for t in 1 to i_struct[w].keyInfo.count do
									(
										file_txt += "k_propName_" + t as string + "=" + i_struct[w].keyInfo[t].k_propName as string + "\n";
										file_txt += "k_propValue_" + t as string + "=" + i_struct[w].keyInfo[t].k_propValue as string + "\n";
									)
								)
							)
						)
					)/*
					--	subVisibility
					if copyedAnim_ary[n][m].subVisibility != undefined do
					(
						file_txt += "[CopyAnim_" + n as string + "_" + m as string + "_1]\n";
						file_txt += "Count=" + copyedAnim_ary[n][m].subVisibility.count as string + "\n";
					)
					--	subSpaceWarps
					file_txt += "subSpaceWarps=" + copyedAnim_ary[n][m].subSpaceWarps as string + "\n";
					--	subTransform
					if copyedAnim_ary[n][m].subTransform != undefined do
					(
						file_txt += "[CopyAnim_" + n as string + "_" + m as string + "_3]\n";
						file_txt += "Count=" + copyedAnim_ary[n][m].subTransform.count as string + "\n";
						for w in 1 to copyedAnim_ary[n][m].subTransform.count do
						(
							file_txt += "[CopyAnim_" + n as string + "_" + m as string + "_3_" + w as string + "]\n";
							--	subAnimInfo (subName,ctrlClass,propName,propValue,keyTime,keyInfo);
							file_txt += "subName=\"" + copyedAnim_ary[n][m].subTransform[w].subName as string + "\"\n";
							file_txt += "ctrlClass=" + copyedAnim_ary[n][m].subTransform[w].ctrlClass as string + "\n";
							if  copyedAnim_ary[n][m].subTransform[w].propName != undefined do
							(
								file_txt += "propName=" + copyedAnim_ary[n][m].subTransform[w].propName as string + "\n";
							)
							if copyedAnim_ary[n][m].subTransform[w].propValue != undefined do
							(
								file_txt += "propValue=" + copyedAnim_ary[n][m].subTransform[w].propValue as string + "\n";
							)
							if copyedAnim_ary[n][m].subTransform[w].keyTime != undefined do
							(
								file_txt += "keyTime=" + copyedAnim_ary[n][m].subTransform[w].keyTime as string + "\n";
							)
							if copyedAnim_ary[n][m].subTransform[w].keyInfo != undefined do
							(
								for t in 1 to copyedAnim_ary[n][m].subTransform[w].keyInfo.count do
								(
									file_txt += "k_propName_" + t as string + "=" + copyedAnim_ary[n][m].subTransform[w].keyInfo[t].k_propName as string + "\n";
									file_txt += "k_propValue_" + t as string + "=" + copyedAnim_ary[n][m].subTransform[w].keyInfo[t].k_propValue as string + "\n";
								)
							)
						)
					)
					--	subObject
					file_txt += "subObject=" + copyedAnim_ary[n][m].subObject as string + "\n";
					--	subMaterial
					file_txt += "subMaterial=" + copyedAnim_ary[n][m].subMaterial as string + "\n";
					--	subImage
					file_txt += "subImage=" + copyedAnim_ary[n][m].subImage as string + "\n";
					--	subMotion
					file_txt += "subMotion=" + copyedAnim_ary[n][m].subMotion as string + "\n";*/
				)
				file_txt += "\n";
			)
			/*写文件*/
			if doesFileExist file_str then i_file = openFile file_str mode:"w";
			else i_file = createFile file_str;
			format file_txt to:i_file;
			close i_file;
			return true;
		)
		catch()
	)
	
	/*读取文件*/
	Function loadSavedFile file_str =
	(
		try
		(
			local count;
			
			/*读取姿势信息*/
			count = (getINISetting file_str "ObjectPoseCopy" "Count") as integer;
			if count > 0 do
			(
				rol.ddl_listPose.items = #();
				copyedPose_ary = #();
			)
			for n in 1 to count do
			(
				local info_ary = #();
				local i_name = getINISetting file_str ("CopyPose_" + n as string) "Name";
				local i_count = execute (getINISetting file_str ("CopyPose_" + n as string) "Count");
				
				if i_count > 0 do
				(
					for m in 1 to i_count do
					(
						local i_getString = "";
						--	struct objPoseInfo (nameIs,parentName,bipObj,trans,localPos,localRotation,localScale);
						local i_PoseInfo = objPoseInfo nameIs:"";
						
						i_PoseInfo.nameIs = getINISetting file_str ("CopyPose_" + n as string + "_" + m as string) "nameIs";
						i_PoseInfo.parentName = getINISetting file_str ("CopyPose_" + n as string + "_" + m as string) "parentName";
						i_PoseInfo.bipObj = execute (getINISetting file_str ("CopyPose_" + n as string + "_" + m as string) "bipObj");
						i_PoseInfo.trans = execute (getINISetting file_str ("CopyPose_" + n as string + "_" + m as string) "trans");
						
						i_getString = getINISetting file_str ("CopyPose_" + n as string + "_" + m as string) "localPos";
						if i_getString != undefined and i_getString != OK and i_getString.count > 0 do i_PoseInfo.localPos = execute i_getString;
						
						i_getString = getINISetting file_str ("CopyPose_" + n as string + "_" + m as string) "localRotation";
						if i_getString != undefined and i_getString != OK and i_getString.count > 0 do i_PoseInfo.localRotation = execute i_getString;
						
						i_getString = getINISetting file_str ("CopyPose_" + n as string + "_" + m as string) "localScale"
						if i_getString != undefined and i_getString != OK and i_getString.count > 0 do i_PoseInfo.localScale = execute i_getString;
						
						append info_ary i_PoseInfo;
					)
				)
				
				append rol.ddl_listPose.items i_name;
				append copyedPose_ary info_ary;
			)
			count = 0;
			/*读取动画信息*/
			count = (getINISetting file_str "ObjectAnimCopy" "Count") as integer;
			if count > 0 do
			(
				rol.ddl_listAni.items = #();
				copyedAnim_ary = #();
			)
			for n in 1 to count do
			(
				local info_ary = #();
				local i_name = getINISetting file_str ("CopyAnim_" + n as string) "Name";
				local i_count = execute (getINISetting file_str ("CopyAnim_" + n as string) "count");
				
				for m in 1 to i_count do
				(
					--	struct objAnimInfo (nameIs,classIs,bipParent,subAnimName,subVisibility,subSpaceWarps,subTransform,subObject,subMaterial,subImage,subMotion);
					local i_info = objAnimInfo nameIs:"";
					
					i_info.nameIs = getINISetting file_str ("CopyAnim_" + n as string + "_" + m as string) "nameIs";
					i_info.classIs = execute (getINISetting file_str ("CopyAnim_" + n as string + "_" + m as string) "classIs");
					i_info.bipParent = execute (getINISetting file_str ("CopyAnim_" + n as string + "_" + m as string) "bipParent");
					i_info.subAnimName = execute (getINISetting file_str ("CopyAnim_" + n as string + "_" + m as string) "subAnimName");
					
					for w in 1 to 7 do
					(
						local subInfo_count = (getINISetting file_str ("CopyAnim_" + n as string + "_" + m as string + "_" + w as string) "Count") as integer;
						
						if subInfo_count != undefined do
						(
							case w of
							(
								1 : i_info.subVisibility = #();
								2 : i_info.subSpaceWarps = #();
								3 : i_info.subTransform = #();
								4 : i_info.subObject = #();
								5 : i_info.subMaterial = #();
								6 : i_info.subImage = #();
								7 : i_info.subMotion = #();
								default : ()
							)
							for s in 1 to subInfo_count do
							(
								local i_getString = "";
								--	struct subAnimInfo (subName,ctrlClass,propName,propValue,keyTime,keyInfo);
								local i_subInfo = subAnimInfo subName:"";
								
								i_subInfo.subName = getINISetting file_str ("CopyAnim_" + n as string + "_" + m as string + "_" + w as string + "_" + s as string) "subName";
								i_subInfo.ctrlClass = execute (getINISetting file_str ("CopyAnim_" + n as string + "_" + m as string + "_" + w as string + "_" + s as string) "ctrlClass");
								
								i_getString = getINISetting file_str ("CopyAnim_" + n as string + "_" + m as string + "_" + w as string + "_" + s as string) "propName";
								if i_getString != undefined and i_getString != OK and i_getString.count > 0 do i_subInfo.propName = execute i_getString;
								
								i_getString = getINISetting file_str ("CopyAnim_" + n as string + "_" + m as string + "_" + w as string + "_" + s as string) "propValue";
								if i_getString != undefined and i_getString != OK and i_getString.count > 0 do i_subInfo.propValue = execute i_getString;
								
								i_getString = getINISetting file_str ("CopyAnim_" + n as string + "_" + m as string + "_" + w as string + "_" + s as string) "keyTime";
								if i_getString != undefined and i_getString != OK and i_getString.count > 0 do i_subInfo.keyTime = execute i_getString;
								
								if i_subInfo.keyTime != undefined do
								(
									i_subInfo.keyInfo = #();
									for t in 1 to i_subInfo.keyTime.count do
									(
										--	struct subKeysInfo (k_propName,k_propValue);
										local i_subKey = subKeysInfo k_propName:undefined;
										
										i_getString = getINISetting file_str ("CopyAnim_" + n as string + "_" + m as string + "_" + w as string + "_" + s as string) ("k_propName_" + t as string);
										if i_getString != undefined and i_getString != OK and i_getString.count > 0 do i_subKey.k_propName = execute i_getString;
										
										i_getString = getINISetting file_str ("CopyAnim_" + n as string + "_" + m as string + "_" + w as string + "_" + s as string) ("k_propValue_" + t as string);
										if i_getString != undefined and i_getString != OK and i_getString.count > 0 do i_subKey.k_propValue = execute i_getString;
										append i_subInfo.keyInfo i_subKey;
									)
								)
								case w of
								(
									1 : append i_info.subVisibility i_subInfo;
									2 : append i_info.subSpaceWarps i_subInfo;
									3 : append i_info.subTransform i_subInfo;
									4 : append i_info.subObject i_subInfo;
									5 : append i_info.subMaterial i_subInfo;
									6 : append i_info.subImage i_subInfo;
									7 : append i_info.subMotion i_subInfo;
									default : ()
								)
							)
						)
					)
					
					append info_ary i_info;
				)
				
				append rol.ddl_listAni.items i_name;
				append copyedAnim_ary info_ary;
			)
			fn_ctrlState();
		)
		catch()
	)
	
	/*	注销函数：注销变量，还原设置。	*/
	Function fn_CopyPasteAniUndefined =
	(
		try
		(
			objPoseInfo = undefined;
			objAnimInfo = undefined;
			subAnimInfo = undefined;
			subKeysInfo = undefined;
			close CopyPasteAni_ini;
			rol_copyPasteAni = undefined;
		)
		catch()
	)
	
	button 		btn_new "N" pos:[8,8] width:23 height:23 tooltip:"创建新的复制"
	button 		btn_open "O" pos:[31,8] width:23 height:23 tooltip:"打开存盘动画文件"
	button 		btn_save "S" pos:[54,8] width:23 height:23 tooltip:"保存复制的动画"
	button 		btn_copy "C" pos:[88,8] width:23 height:23 tooltip:"复制 动画/POSE"
	button 		btn_paste "P" pos:[111,8] width:23 height:23 tooltip:"粘帖 动画/POSE"
	button 		btn_del "D" pos:[146,8] width:23 height:23 tooltip:"删除 当前复制的动画/POSE"
	button 		btn_delAll "D+" pos:[169,8] width:23 height:23 tooltip:"删除 所有已复制的动画/POSE"
	label 		lbl_copyType "复制所选物体的:" pos:[8,40] width:88 height:20
	radioButtons 	rdo_copyType "" pos:[100,40] width:88 height:20 labels:#("动画", "姿势") columns:2
	dropDownList 	ddl_listAni "已复制的动画：（非CS物体）" pos:[8,64] width:186 height:41 items:#()
	dropDownList 	ddl_listPose "已复制的姿势：" pos:[8,-64] width:186 height:41 items:#()
	label 		lbl_paste "动画粘帖过滤:" pos:[8,110] width:120 height:16
	checkButton 	ckb_pasteOther "A" pos:[96,106] width:20 height:20 tooltip:"粘帖物体上其他的动画"
	checkButton 	ckb_pasteMove "M" pos:[124,106] width:20 height:20 checked:true tooltip:"仅粘帖位移动画"
	checkButton 	ckb_pasteRotate "R" pos:[148,106] width:20 height:20 checked:true tooltip:"仅粘贴旋转动画"
	checkButton 	ckb_pasteScale "S" pos:[172,106] width:20 height:20 checked:true tooltip:"仅粘贴缩放动画"
	-------------------------------------
	on rol_copyPasteAni open do
	(
		fn_ctrlBitmap();
		fn_ctrlState();
		history_str = getINISetting CopyPasteAniIni_name "SaveHistory" "History";
	)
	on rol_copyPasteAni close do
	(
		fn_CopyPasteAniUndefined();
	)
	on btn_new pressed do
	(
		copyedAnim_ary = #();
		copyedPose_ary = #();
		ddl_listAni.items = #();
		ddl_listPose.items = #();
		fn_ctrlState();
	)
	on btn_open pressed do
	(
		local openfile_str;
		
		openfile_str = getOpenFileName caption:"Open File" filename:history_str types:"Pose&Animation Copy File(*.pac)|*.pac|All|*.*|";
		if openfile_str != undefined and doesFileExist openfile_str do
		(
			loadSavedFile openfile_str;
		)
	)
	on btn_save pressed do
	(
		local saveFile_str;
		
		saveFile_str = getSaveFileName caption:"Save File" filename:history_str types:"Pose&Animation Copy File(*.pac)|*.pac|All|*.*|";
		if saveFile_str != undefined and saveFile_str.count != 0 do
		(
			saveObjPose saveFile_str;
			setINISetting CopyPasteAniIni_name "SaveHistory" "History" saveFile_str;
		)
	)
	on btn_copy pressed do
	(
		local item_str = "";
		
		if rdo_copyType.state == 1 then
		(
			local copyedAnim = copyObjAniTracks();
			
			if copyedAnim.count != 0 do
			(
				if copyedAnim.count == 1 then item_str = copyedAnim[1].nameIs;
				else item_str = copyedAnim[copyedAnim.count].nameIs + " → " + copyedAnim[1].nameIs;
				insertItem copyedAnim copyedAnim_ary 1;
				insertItem ("Anim_" + copyedAnim_ary.count as string + ":" + item_str) ddl_listAni.items 1;
				ddl_listAni.selection = 1;
			)
		)
		else
		(
			local copyedPose = copyObjPose();
			
			if copyedPose.count != 0 do
			(
				if copyedPose.count == 1 then item_str = copyedPose[1].nameIs;
				else item_str = copyedPose[copyedPose.count].nameIs + " → " + copyedPose[1].nameIs;
				insertItem copyedPose copyedPose_ary 1;
				insertItem ("Pose_" + copyedPose_ary.count as string + ":" + item_str) ddl_listPose.items 1;
				ddl_listPose.selection = 1;
			)
		)
		fn_ctrlState();
	)
	on btn_paste pressed do
	(
		if rdo_copyType.state == 1 then
		(
			pasteObjAniTracks copyedAnim_ary[ddl_listAni.selection] #(ckb_pasteOther.state,ckb_pasteMove.state,ckb_pasteRotate.state,ckb_pasteScale.state);
			pasteObjAniTracks copyedAnim_ary[ddl_listAni.selection] #(ckb_pasteOther.state,ckb_pasteMove.state,ckb_pasteRotate.state,ckb_pasteScale.state);
		)
		else
		(
			pasteObjPose copyedPose_ary[ddl_listPose.selection];
		)
	)
	on btn_del pressed do
	(
		if rdo_copyType.state == 1 then
		(
			deleteItem copyedAnim_ary ddl_listAni.selection;
			deleteItem ddl_listAni.items ddl_listAni.selection;
			if ddl_listAni.selection == 0 do ddl_listAni.selection = ddl_listAni.items.count;
		)
		else
		(
			deleteItem copyedPose_ary ddl_listPose.selection;
			deleteItem ddl_listPose.items ddl_listPose.selection;
			if ddl_listPose.selection == 0 do ddl_listPose.selection = ddl_listPose.items.count;
		)
		fn_ctrlState();
	)
	on btn_delAll pressed do
	(
		if rdo_copyType.state == 1 then
		(
			copyedAnim_ary = #();
			ddl_listAni.items = #();
		)
		else
		(
			copyedPose_ary = #();
			ddl_listPose.items = #();
		)
		fn_ctrlState();
	)
	on rdo_copyType changed state do
	(
		fn_ctrlState();
	)
)

createdialog rol_copyPasteAni 200 132
