	global 	maxStartupPath = getDir #scripts + "\\Startup\MaxQuickBar.ms"  
	global     customPos  = [0,0]
	global     customName = ""
	global 	custom1NameStr  = "+"
	global 	custom2NameStr  = "+"
	global 	custom3NameStr  = "+"
	global 	custom4NameStr  = "+"
	global 	custom5NameStr  = "+"
	global 	custom6NameStr  = "+"
	global 	custom7NameStr  = "+"
	global 	custom8NameStr  = "+"
	global 	custom9NameStr  = "+"
	global 	custom10NameStr  = "+"
	global 	custom11NameStr  = "+"
	global 	custom12NameStr  = "+"
	global 	custom13NameStr  = "+"
	global 	custom14NameStr  = "+"
	global 	custom15NameStr  = "+"
	global 	custom16NameStr  = "+"
	global 	custom17NameStr  = "+"
	global 	custom18NameStr  = "+"
	global 	custom19NameStr  = "+"
	global 	custom20NameStr  = "+"
	global 	custom21NameStr  = "+"
	global 	custom22NameStr  = "+"
	global 	custom23NameStr  = "+"
	global 	custom24NameStr  = "+"
	global 	custom25NameStr  = "+"
	global 	custom26NameStr  = "+"
	global 	custom27NameStr  = "+"
	global 	custom28NameStr  = "+"
	global 	custom29NameStr  = "+"
	global 	custom30NameStr  = "+"
	global	 	customButton = ""
	global		yingsheStr =""
	global		xiangmuStr = ""
	global		GongJuXiangSheZhi
	global	 	setRollout		
	global 	xiangMuIniFale = "C:\HuoHuaTools\MaxQuickBar.ini"
	--创建项目ini文档是否存在
	
global versionNumber = "250728" 
--工具网络Url Ini	
global gitScriptiniUrl = "https://gitee.com/max_12/public-tools/raw/master/MaxQuickBar/MaxQuickBar.ini"
	
--工具网络 Url ms 文件	
global gitScriptUrl = "https://gitee.com/max_12/public-tools/raw/master/MaxQuickBar/MaxQuickBar.ms"	

--记录是否忽略此次版本更新文档。	
global	ScriptHulueIni = "C:\HuoHuaTools\MaxQuickBar_Hulue.ini"
	
--记录C盘工具Ini数据文档路径。	
global UrlScriptIniPath = "C:\HuoHuaTools\UrlMaxQuickBar.ini"

	
global ScriptiniPath = "C:\HuoHuaTools\MaxQuickBar.ini"



fn fnGetMaxVersion = --获取MAX版本
	(
	max_V = GetFileVersion (getDir #maxRoot + "\\3dsmax.exe")  -- 获取当前max版本号
	YY_v = substring max_V 1 2  -- 返回字符串中从第一个到第二个字符
		case of 
		(
			(YY_v == "8"): (YY_max_V = "8.0")
			(YY_v == "9"): (YY_max_V = "9.0")
			(YY_v == "10"): (YY_max_V = "2008")
			(YY_v == "11"): (YY_max_V = "2009")
			(YY_v == "12"): (YY_max_V = "2010")
			(YY_v == "13"): (YY_max_V = "2011")
			(YY_v == "14"): (YY_max_V = "2012")
			(YY_v == "15"): (YY_max_V = "2013")
			(YY_v == "16"): (YY_max_V = "2014")
			(YY_v == "17"): (YY_max_V = "2015")
			(YY_v == "18"): (YY_max_V = "2016")
			(YY_v == "19"): (YY_max_V = "2017")
			(YY_v == "20"): (YY_max_V = "2018")
			(YY_v == "21"): (YY_max_V = "2019")
			(YY_v == "22"): (YY_max_V = "2020")
			(YY_v == "23"): (YY_max_V = "2021")
			(YY_v == "24"): (YY_max_V = "2022")
			(YY_v == "25"): (YY_max_V = "2023")
			(YY_v == "26"): (YY_max_V = "2024")
			(YY_v == "27"): (YY_max_V = "2025")
			(YY_v == "28"): (YY_max_V = "2026")
			(YY_v == "29"): (YY_max_V = "2027")
			(YY_v == "30"): (YY_max_V = "2028")
			(YY_v == "31"): (YY_max_V = "2029")
			(YY_v == "32"): (YY_max_V = "2030")
			(YY_v == "33"): (YY_max_V = "2031")
			(YY_v == "34"): (YY_max_V = "2032")
			(YY_v == "35"): (YY_max_V = "2033")
			(YY_v == "36"): (YY_max_V = "2034")
			(YY_v == "37"): (YY_max_V = "2035")
		)
	)

	






-- 获取当前脚本的完整路径
fn getCurrentScriptPath =
(
    local scriptPath = getSourceFileName()
    if scriptPath != undefined then
    (
        format "当前脚本路径是: %\n" scriptPath
    )
    else
    (
        print "无法获取脚本路径。脚本可能不是从文件加载执行的。"
    )
    return scriptPath
)



-- 	
-- 	
-- rcmenu MyRCmenu   --一个右键对话框
-- (
-- 	menuItem menu1 "menu1"
-- 	menuItem menu2 "menu2"
-- 	
-- 	on menu1 picked do(
-- 		messagebox "Button1 clicked!"
-- 		print sel
-- 	)
-- 	
-- 	on menu2 picked do(
-- 		messagebox "Button2 clicked!"
-- 	)
-- )

	
--#################创建安装目录################################	
if  not (  doesFileExist 	maxStartupPath) do 
( 
	if( copyFile  ( getSourceFileName() ) ( maxStartupPath)) then
		( 
			--创建安装目录
			for tuichu = 1 to 1 do (
				
				--先尝试安装到C盘
				anZhuangLuJing = "C:\HuoHuaTools\\"
				if (makeDir anZhuangLuJing) then
				(
					if ( SetIniSetting  xiangMuIniFale  "ToolsPath"   "anZhuangMuLu" anZhuangLuJing  ) and (  SetINISetting  xiangMuIniFale  "Tingkao"  "state"  "#cui_dock_left")then (print "安装完成。  "  exit  )
					else ( messagebox ("工具箱安装失败！ \n 联系火华：QQ 195465970    \n") )
					)
				)
			)
	)
		--##############################创建完成###########################
	
	
	
	
	
	




utility Roll_MaxQuickBar "MaxQuickBar" width:50 height:445
(
	button 'OpenToolsshezhi' "设置" pos:[2,2] width:45 height:18 align:#left
	local buttonPosY = 10  --固定按钮的最后一个位置
	button 'custom1'  custom1NameStr  pos:[2,25  + buttonPosY ] width:45 height:25 align:#left
	button 'custom2'  custom2NameStr  pos:[2,50  + buttonPosY ] width:45 height:25 align:#left
	button 'custom3'  custom3NameStr  pos:[2,75  + buttonPosY ] width:45 height:25 align:#left
	button 'custom4'  custom4NameStr  pos:[2,100 + buttonPosY ] width:45 height:25 align:#left
	button 'custom5'  custom5NameStr  pos:[2,125 + buttonPosY ] width:45 height:25 align:#left
	button 'custom6'  custom6NameStr  pos:[2,150 + buttonPosY ] width:45 height:25 align:#left
	button 'custom7'  custom7NameStr  pos:[2,175 + buttonPosY ] width:45 height:25 align:#left
	button 'custom8'  custom8NameStr  pos:[2,200 + buttonPosY ] width:45 height:25 align:#left
	button 'custom9'  custom9NameStr  pos:[2,225 + buttonPosY ] width:45 height:25 align:#left
	button 'custom10' custom10NameStr pos:[2,250 + buttonPosY ] width:45 height:25 align:#left
	button 'custom11' custom11NameStr pos:[2,275 + buttonPosY ] width:45 height:25 align:#left
	button 'custom12' custom12NameStr pos:[2,300 + buttonPosY ] width:45 height:25 align:#left
	button 'custom13' custom13NameStr pos:[2,325 + buttonPosY ] width:45 height:25 align:#left
	button 'custom14' custom14NameStr pos:[2,350 + buttonPosY ] width:45 height:25 align:#left
	button 'custom15' custom15NameStr pos:[2,375 + buttonPosY ] width:45 height:25 align:#left
	button 'custom16' custom16NameStr pos:[2,400 + buttonPosY ] width:45 height:25 align:#left
	button 'custom17' custom17NameStr pos:[2,425 + buttonPosY ] width:45 height:25 align:#left
	button 'custom18' custom18NameStr pos:[2,450 + buttonPosY ] width:45 height:25 align:#left
	button 'custom19' custom19NameStr pos:[2,475 + buttonPosY ] width:45 height:25 align:#left
	button 'custom20' custom20NameStr pos:[2,500 + buttonPosY ] width:45 height:25 align:#left
	button 'custom21' custom20NameStr pos:[2,525 + buttonPosY ] width:45 height:25 align:#left
	button 'custom22' custom20NameStr pos:[2,550 + buttonPosY ] width:45 height:25 align:#left
	button 'custom23' custom20NameStr pos:[2,575 + buttonPosY ] width:45 height:25 align:#left
	button 'custom24' custom20NameStr pos:[2,600 + buttonPosY ] width:45 height:25 align:#left
	button 'custom25' custom20NameStr pos:[2,625 + buttonPosY ] width:45 height:25 align:#left
	button 'custom26' custom20NameStr pos:[2,650 + buttonPosY ] width:45 height:25 align:#left
	button 'custom27' custom20NameStr pos:[2,675 + buttonPosY ] width:45 height:25 align:#left
	button 'custom28' custom20NameStr pos:[2,700 + buttonPosY ] width:45 height:25 align:#left
	button 'custom29' custom20NameStr pos:[2,725 + buttonPosY ] width:45 height:25 align:#left
	button 'custom30' custom20NameStr pos:[2,750 + buttonPosY ] width:45 height:25 align:#left						
	
	fn  fnRightClick   custom  =   --右键按钮
	(
		customPos = custom.Pos
		customName =  custom.Name
		PoseEditpos =  GetDialogPos  Roll_MaxQuickBar  --获取主窗口在屏幕中的位
		PoseEditpos = PoseEditpos +  customPos + [35,10]  --创建一个新的rollout位置
		CREATEDIALOG  GongJuXiangSheZhi	  pos:PoseEditpos
		)
		
	fn fnLeftCilck  custom =   --左键
	(
		local filePath =  getIniSetting	xiangMuIniFale   custom.name "Path"
		if filePath != ""  then (  try (filein filePath )catch ( messagebox "该文件报错。无法启动。 " ))
		else (  fnRightClick   custom  )
		)	

	fn fnShuaXinAnNiu = (   --刷新按钮页面
		
		if ( custom1NameStr  =  getIniSetting 	 xiangMuIniFale   "custom1"    "Name") != ""  do ( 	Roll_MaxQuickBar.custom1.text = custom1NameStr   )	
		if ( custom2NameStr  =  getIniSetting 	 xiangMuIniFale   "custom2"    "Name") != ""  do ( 	Roll_MaxQuickBar.custom2.text = custom2NameStr   )	
		if ( custom3NameStr  =  getIniSetting 	 xiangMuIniFale   "custom3"    "Name") != ""  do ( 	Roll_MaxQuickBar.custom3.text = custom3NameStr   )	
		if ( custom4NameStr  =  getIniSetting 	 xiangMuIniFale   "custom4"    "Name") != ""  do ( 	Roll_MaxQuickBar.custom4.text = custom4NameStr   )	
		if ( custom5NameStr  =  getIniSetting 	 xiangMuIniFale   "custom5"    "Name") != ""  do ( 	Roll_MaxQuickBar.custom5.text = custom5NameStr   )
		if ( custom6NameStr  =  getIniSetting 	 xiangMuIniFale   "custom6"    "Name") != ""  do ( 	Roll_MaxQuickBar.custom6.text = custom6NameStr   )	
		if ( custom7NameStr  =  getIniSetting 	 xiangMuIniFale   "custom7"    "Name") != ""  do ( 	Roll_MaxQuickBar.custom7.text = custom7NameStr   )	
		if ( custom8NameStr  =  getIniSetting 	 xiangMuIniFale   "custom8"    "Name") != ""  do ( 	Roll_MaxQuickBar.custom8.text = custom8NameStr   )	
		if ( custom9NameStr  =  getIniSetting 	 xiangMuIniFale   "custom9"    "Name") != ""  do ( 	Roll_MaxQuickBar.custom9.text = custom9NameStr   )	
		if ( custom10NameStr =  getIniSetting 	 xiangMuIniFale   "custom10"   "Name") != ""  do ( 	Roll_MaxQuickBar.custom10.text = custom10NameStr )	
		if ( custom11NameStr =  getIniSetting 	 xiangMuIniFale   "custom11"   "Name") != ""  do ( 	Roll_MaxQuickBar.custom11.text = custom11NameStr )	
		if ( custom12NameStr =  getIniSetting 	 xiangMuIniFale   "custom12"   "Name") != ""  do ( 	Roll_MaxQuickBar.custom12.text = custom12NameStr )	
		if ( custom13NameStr =  getIniSetting 	 xiangMuIniFale   "custom13"   "Name") != ""  do (		Roll_MaxQuickBar.custom13.text = custom13NameStr )	
		if ( custom14NameStr =  getIniSetting 	 xiangMuIniFale   "custom14"   "Name") != ""  do ( 	Roll_MaxQuickBar.custom14.text = custom14NameStr )	
		if ( custom15NameStr =  getIniSetting 	 xiangMuIniFale   "custom15"   "Name") != ""  do ( 	Roll_MaxQuickBar.custom15.text = custom15NameStr )
		if ( custom16NameStr =  getIniSetting 	 xiangMuIniFale   "custom16"   "Name") != ""  do ( 	Roll_MaxQuickBar.custom16.text = custom16NameStr )
		if ( custom17NameStr =  getIniSetting 	 xiangMuIniFale   "custom17"   "Name") != ""  do ( 	Roll_MaxQuickBar.custom17.text = custom17NameStr )
		if ( custom18NameStr =  getIniSetting 	 xiangMuIniFale   "custom18"   "Name") != ""  do ( 	Roll_MaxQuickBar.custom18.text = custom18NameStr )
		if ( custom19NameStr =  getIniSetting 	 xiangMuIniFale   "custom19"   "Name") != ""  do ( 	Roll_MaxQuickBar.custom19.text = custom19NameStr )
		if ( custom20NameStr =  getIniSetting 	 xiangMuIniFale   "custom20"   "Name") != ""  do ( 	Roll_MaxQuickBar.custom20.text = custom20NameStr )
		if ( custom21NameStr =  getIniSetting 	 xiangMuIniFale   "custom21"   "Name") != ""  do ( 	Roll_MaxQuickBar.custom21.text = custom21NameStr )
		if ( custom22NameStr =  getIniSetting 	 xiangMuIniFale   "custom22"   "Name") != ""  do ( 	Roll_MaxQuickBar.custom22.text = custom22NameStr )
		if ( custom23NameStr =  getIniSetting 	 xiangMuIniFale   "custom23"   "Name") != ""  do (		Roll_MaxQuickBar.custom23.text = custom23NameStr )
		if ( custom24NameStr =  getIniSetting 	 xiangMuIniFale   "custom24"   "Name") != ""  do ( 	Roll_MaxQuickBar.custom24.text = custom24NameStr )
		if ( custom25NameStr =  getIniSetting 	 xiangMuIniFale   "custom25"   "Name") != ""  do ( 	Roll_MaxQuickBar.custom25.text = custom25NameStr )
		if ( custom26NameStr =  getIniSetting 	 xiangMuIniFale   "custom26"   "Name") != ""  do ( 	Roll_MaxQuickBar.custom26.text = custom26NameStr )
		if ( custom27NameStr =  getIniSetting 	 xiangMuIniFale   "custom27"   "Name") != ""  do ( 	Roll_MaxQuickBar.custom27.text = custom27NameStr )
		if ( custom28NameStr =  getIniSetting 	 xiangMuIniFale   "custom28"   "Name") != ""  do ( 	Roll_MaxQuickBar.custom28.text = custom28NameStr )
		if ( custom29NameStr =  getIniSetting 	 xiangMuIniFale   "custom29"   "Name") != ""  do ( 	Roll_MaxQuickBar.custom29.text = custom29NameStr )
		if ( custom30NameStr =  getIniSetting 	 xiangMuIniFale   "custom30"   "Name") != ""  do ( 	Roll_MaxQuickBar.custom30.text = custom30NameStr )	

		
		if ( custom1ToolTipStr  =  getIniSetting 	 xiangMuIniFale   "custom1"    "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom1.ToolTip = custom1ToolTipStr)	
		if ( custom2ToolTipStr  =  getIniSetting 	 xiangMuIniFale   "custom2"    "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom2.ToolTip = custom2ToolTipStr)	
		if ( custom3ToolTipStr  =  getIniSetting 	 xiangMuIniFale   "custom3"    "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom3.ToolTip = custom3ToolTipStr)	
		if ( custom4ToolTipStr  =  getIniSetting 	 xiangMuIniFale   "custom4"    "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom4.ToolTip = custom4ToolTipStr)	
		if ( custom5ToolTipStr  =  getIniSetting 	 xiangMuIniFale   "custom5"    "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom5.ToolTip = custom5ToolTipStr)
		if ( custom6ToolTipStr  =  getIniSetting 	 xiangMuIniFale   "custom6"    "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom6.ToolTip = custom6ToolTipStr)	
		if ( custom7ToolTipStr  =  getIniSetting 	 xiangMuIniFale   "custom7"    "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom7.ToolTip = custom7ToolTipStr)	
		if ( custom8ToolTipStr  =  getIniSetting 	 xiangMuIniFale   "custom8"    "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom8.ToolTip = custom8ToolTipStr)	
		if ( custom9ToolTipStr  =  getIniSetting 	 xiangMuIniFale   "custom9"    "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom9.ToolTip = custom9ToolTipStr)	
		if ( custom10ToolTipStr =  getIniSetting 	 xiangMuIniFale   "custom10"   "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom10.ToolTip = custom10ToolTipStr)	
		if ( custom11ToolTipStr =  getIniSetting 	 xiangMuIniFale   "custom11"   "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom11.ToolTip = custom11ToolTipStr)	
		if ( custom12ToolTipStr =  getIniSetting 	 xiangMuIniFale   "custom12"   "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom12.ToolTip = custom12ToolTipStr)	
		if ( custom13ToolTipStr =  getIniSetting 	 xiangMuIniFale   "custom13"   "ToolTip") != ""  do (	Roll_MaxQuickBar.custom13.ToolTip = custom13ToolTipStr)	
		if ( custom14ToolTipStr =  getIniSetting 	 xiangMuIniFale   "custom14"   "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom14.ToolTip = custom14ToolTipStr)	
		if ( custom15ToolTipStr =  getIniSetting 	 xiangMuIniFale   "custom15"   "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom15.ToolTip = custom15ToolTipStr)
		if ( custom16ToolTipStr =  getIniSetting 	 xiangMuIniFale   "custom16"   "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom16.ToolTip = custom16ToolTipStr)
		if ( custom17ToolTipStr =  getIniSetting 	 xiangMuIniFale   "custom17"   "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom17.ToolTip = custom17ToolTipStr)
		if ( custom18ToolTipStr =  getIniSetting 	 xiangMuIniFale   "custom18"   "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom18.ToolTip = custom18ToolTipStr)
		if ( custom19ToolTipStr =  getIniSetting 	 xiangMuIniFale   "custom19"   "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom19.ToolTip = custom19ToolTipStr)
		if ( custom20ToolTipStr =  getIniSetting 	 xiangMuIniFale   "custom20"   "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom20.ToolTip = custom20ToolTipStr)
		if ( custom21ToolTipStr =  getIniSetting 	 xiangMuIniFale   "custom21"   "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom21.ToolTip = custom21ToolTipStr)
		if ( custom22ToolTipStr =  getIniSetting 	 xiangMuIniFale   "custom22"   "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom22.ToolTip = custom22ToolTipStr)
		if ( custom23ToolTipStr =  getIniSetting 	 xiangMuIniFale   "custom23"   "ToolTip") != ""  do (	Roll_MaxQuickBar.custom23.ToolTip = custom23ToolTipStr)
		if ( custom24ToolTipStr =  getIniSetting 	 xiangMuIniFale   "custom24"   "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom24.ToolTip = custom24ToolTipStr)
		if ( custom25ToolTipStr =  getIniSetting 	 xiangMuIniFale   "custom25"   "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom25.ToolTip = custom25ToolTipStr)
		if ( custom26ToolTipStr =  getIniSetting 	 xiangMuIniFale   "custom26"   "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom26.ToolTip = custom26ToolTipStr)
		if ( custom27ToolTipStr =  getIniSetting 	 xiangMuIniFale   "custom27"   "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom27.ToolTip = custom27ToolTipStr)
		if ( custom28ToolTipStr =  getIniSetting 	 xiangMuIniFale   "custom28"   "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom28.ToolTip = custom28ToolTipStr)
		if ( custom29ToolTipStr =  getIniSetting 	 xiangMuIniFale   "custom29"   "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom29.ToolTip = custom29ToolTipStr)
		if ( custom30ToolTipStr =  getIniSetting 	 xiangMuIniFale   "custom30"   "ToolTip") != ""  do ( 	Roll_MaxQuickBar.custom30.ToolTip = custom30ToolTipStr)	
		
		) 		
		
		
	on Roll_MaxQuickBar open do
	(
			--初始停靠信息写入ini
				
			----获取ini中的按钮信息
			fnShuaXinAnNiu()    	
	)
	
	----按钮1------------------------------
	on custom1 pressed   do  ( fnLeftCilck    custom1 )
	on custom1 rightClick do ( fnrightClick   custom1 )	
	----按钮2------------------------------
	on custom2 pressed   do  ( fnLeftCilck    custom2 )
	on custom2 rightClick do ( fnrightClick   custom2 )
	----按钮3------------------------------
	on custom3 pressed   do  ( fnLeftCilck    custom3 )
	on custom3 rightClick do ( fnrightClick   custom3 )
	----按钮4------------------------------
	on custom4 pressed   do  ( fnLeftCilck    custom4 )
	on custom4 rightClick do ( fnrightClick   custom4 )
	----按钮5------------------------------
	on custom5 pressed   do  ( fnLeftCilck    custom5 )
	on custom5 rightClick do ( fnrightClick   custom5 )
	----按钮6-----------------------------
	on custom6 pressed   do  ( fnLeftCilck    custom6 )
	on custom6 rightClick do ( fnrightClick   custom6 )
	----按钮7------------------------------
	on custom7 pressed   do  ( fnLeftCilck    custom7 )
	on custom7 rightClick do ( fnrightClick   custom7 )
	----按钮8------------------------------
	on custom8 pressed   do  ( fnLeftCilck    custom8 )
	on custom8 rightClick do ( fnrightClick   custom8 )
	----按钮9------------------------------
	on custom9 pressed   do  ( fnLeftCilck    custom9 )
	on custom9 rightClick do ( fnrightClick   custom9 )
	----按钮10------------------------------
	on custom10 pressed   do  ( fnLeftCilck    custom10 )
	on custom10 rightClick do ( fnrightClick   custom10 )
	----按钮11------------------------------
	on custom11 pressed   do  ( fnLeftCilck    custom11 )
	on custom11 rightClick do ( fnrightClick   custom11 )
	----按钮12------------------------------
	on custom12 pressed   do  ( fnLeftCilck    custom12 )
	on custom12 rightClick do ( fnrightClick   custom12 )
	----按钮13------------------------------
	on custom13 pressed   do  ( fnLeftCilck    custom13 )
	on custom13 rightClick do ( fnrightClick   custom13 )
	----按钮14------------------------------
	on custom14 pressed   do  ( fnLeftCilck    custom14 )
	on custom14 rightClick do ( fnrightClick   custom14 )
	----按钮15------------------------------
	on custom15 pressed   do  ( fnLeftCilck    custom15 )
	on custom15 rightClick do ( fnrightClick   custom15 )
	----按钮16------------------------------
	on custom16 pressed   do  ( fnLeftCilck    custom16 )
	on custom16 rightClick do ( fnrightClick   custom16 )
	----按钮17------------------------------
	on custom17 pressed   do  ( fnLeftCilck    custom17 )
	on custom17 rightClick do ( fnrightClick   custom17 )
	----按钮18------------------------------
	on custom18 pressed   do  ( fnLeftCilck    custom18 )
	on custom18 rightClick do ( fnrightClick   custom18 )
	----按钮19------------------------------
	on custom19 pressed   do  ( fnLeftCilck    custom19 )
	on custom19 rightClick do ( fnrightClick   custom19 )
	----按钮20------------------------------
	on custom20 pressed   do  ( fnLeftCilck    custom20 )
	on custom20 rightClick do ( fnrightClick   custom20 )
	----按钮21------------------------------
	on custom21 pressed   do  ( fnLeftCilck    custom21 )
	on custom21 rightClick do ( fnrightClick   custom21 )
	----按钮22------------------------------
	on custom22 pressed   do  ( fnLeftCilck    custom22 )
	on custom22 rightClick do ( fnrightClick   custom22 )
	----按钮23------------------------------
	on custom23 pressed   do  ( fnLeftCilck    custom23 )
	on custom23 rightClick do ( fnrightClick   custom23 )
	----按钮24------------------------------
	on custom24 pressed   do  ( fnLeftCilck    custom24 )
	on custom24 rightClick do ( fnrightClick   custom24 )
	----按钮25------------------------------
	on custom25 pressed   do  ( fnLeftCilck    custom25 )
	on custom25 rightClick do ( fnrightClick   custom25 )
	----按钮26------------------------------
	on custom26 pressed   do  ( fnLeftCilck    custom26 )
	on custom26 rightClick do ( fnrightClick   custom26 )
	----按钮27------------------------------
	on custom27 pressed   do  ( fnLeftCilck    custom27 )
	on custom27 rightClick do ( fnrightClick   custom27 )
	----按钮28------------------------------
	on custom28 pressed   do  ( fnLeftCilck    custom28 )
	on custom28 rightClick do ( fnrightClick   custom28 )
	----按钮29------------------------------
	on custom29 pressed   do  ( fnLeftCilck    custom29 )
	on custom29 rightClick do ( fnrightClick   custom29 )
	----按钮30------------------------------
	on custom30 pressed   do  ( fnLeftCilck    custom30 )
	on custom30 rightClick do ( fnrightClick   custom30 )	
	
	
	on OpenToolsshezhi pressed do 
	(
		PoseEditpos =  GetDialogPos  Roll_MaxQuickBar  --获取主窗口在屏幕中的位
		print PoseEditpos
		PoseEditpos = PoseEditpos +  OpenToolsshezhi.pos + [35,10]  --创建一个新的rollout位置
		print  PoseEditpos
		CREATEDIALOG  setRollout   pos:PoseEditpos  --创建这个rollout
		)
		
		
	on  Roll_MaxQuickBar close do 
	(
	try (destroyDialog setRollout )catch ()  --工具箱关闭时  工具箱设置也跟着关闭
		)
	
)

tingkaoState = ( getIniSetting  xiangMuIniFale  "Tingkao"  "state") --读取停靠信息

tingkaoState = 	execute tingkaoState  --转换信息

if  doesFileExist (maxStartupPath) do 
(
CREATEDIALOG Roll_MaxQuickBar POS:[0,60] width:50
CUI.REGISTERDIALOGBAR Roll_MaxQuickBar   --注册为可停靠窗口
CUI.DOCKDIALOGBAR  Roll_MaxQuickBar  tingkaoState 
)


rollout setRollout "设置" width:179 height:202
(
	radiobuttons 'gongjuxiangtingkaofangxiang' "工具箱停靠方向" pos:[20,10] width:129 height:30 enabled:true labels:#("左", "右", "浮动") default:1 columns:3 align:#left 
 
	button 'uninstallBut' "卸载工具" pos:[30,79] width:116 height:23 checked:true align:#left
	button 'OpenStartupBut' "Startup目录" pos:[51,133] width:74 height:20 align:#left	
	
	button 'btn4' "重启工具" pos:[31,52] width:116 height:23 checked:true align:#left
	button 'btnJiancegengxin' "检测更新" pos:[29,106] width:116 height:22 align:#left
	label 'lbl5' "作者：火了个华 QQ：195465970" pos:[4,184] width:174 height:16 align:#left
	label 'lblBanbenhao' "Label" pos:[18,161] width:140 height:17 align:#left
		
		
	on setRollout open do
	(
		local tingkaoweizhi = getINISetting  xiangMuIniFale  "Tingkao"  "state"
		print tingkaoweizhi
		if  tingkaoweizhi == "#cui_dock_left" do gongjuxiangtingkaofangxiang.state = 1
		if  tingkaoweizhi == "#cui_dock_right"do gongjuxiangtingkaofangxiang.state = 2
		if  tingkaoweizhi == "#cui_floatable" do gongjuxiangtingkaofangxiang.state = 3
		lblBanbenhao.text = ("版本号:"+	versionNumber)
		)
	on gongjuxiangtingkaofangxiang changed state  do
	(
		local tingkaofangxiang = ""
		if state == 1 do ( tingkaofangxiang = "#cui_dock_left" )
		if state == 2 do ( tingkaofangxiang = "#cui_dock_right" )
		if state == 3 do ( tingkaofangxiang = "#cui_floatable" )
		
		if SetINISetting  xiangMuIniFale  "Tingkao"  "state"  tingkaofangxiang  then print "停靠位置写入成功"  else print "停靠位置写入失败"
		cui.UnRegisterDialogBar Roll_MaxQuickBar
		destroyDialog Roll_MaxQuickBar
		filein ( maxStartupPath )
		
		)
	on uninstallBut pressed do
	(
		if  queryBox ("确定要卸载工具箱吗？  \n") then
		 (
			 try(
			
			cui.UnRegisterDialogBar Roll_MaxQuickBar
			destroyDialog Roll_MaxQuickBar
			if  deletefile maxStartupPath == false do (messagebox ("自动卸载失败，请手动删除下方路径文件。    \n" + maxStartupPath +"\n\n"))
			 )
			 catch (messagebox " 卸载失败。  \n")
			 )
		)
	on OpenStartupBut pressed do
	(
		try ( shellLaunch "explorer" scriptsPath)catch (messagebox "打开失败。   ")
		)
	on btn4 pressed do   --重启
	(
		try (
			cui.UnRegisterDialogBar Roll_MaxQuickBar
			destroyDialog Roll_MaxQuickBar
				
			CREATEDIALOG Roll_MaxQuickBar POS:[0,60] width:50
			CUI.REGISTERDIALOGBAR Roll_MaxQuickBar   --注册为可停靠窗口
			CUI.DOCKDIALOGBAR  Roll_MaxQuickBar  tingkaoState 
				) 
		catch ()
	)
	on btnJiancegengxin pressed do
	(
		CREATEDIALOG Roll_Banbengengxin
		)
)



rollout GongJuXiangSheZhi "工具箱设置器" width:213 height:167
(
	
	label 'nameLabel' "简称 建议2-3字" pos:[15,24] width:85 height:17 align:#left
	edittext 'toolsName1' "" pos:[7,41] width:100 height:20 align:#left
	button 'toolsPath1' "选择" pos:[114,41] width:50 height:20 align:#left
	button 'toolsDelete1' "X" pos:[173,40] width:25 height:20 align:#left
	button 'GJXqueding' "确定" pos:[24,116] width:159 height:20 align:#left	
	
	label 'lbl2' "Label" pos:[118,29] width:0 height:0 align:#left
	label 'lbl3' "选择路径" pos:[114,24] width:51 height:15 align:#left
	label 'lbS' "删除" pos:[172,23] width:27 height:15 align:#left
	label 'lbl5' "添加自定义工具按钮" pos:[46,5] width:113 height:18 align:#left
	button 'btnDakaiyixuanzemulu' "打开当前工具目录" pos:[30,140] width:146 height:20 enabled:false align:#left
	editText 'edtToolTip' "" pos:[7,88] width:194 height:22 align:#left
	label 'lblToolTip' "鼠标悬停提示词" pos:[11,73] width:161 height:15 align:#left
		
	on GongJuXiangSheZhi open do   --启动
	( 
		global dirScript = ""
		iniName = ""
	
	   if  ( iniName   =   getIniSetting	 xiangMuIniFale   customName  "Name" ) != ""  do 
		( btnDakaiyixuanzemulu.enabled = true
			toolsName1.text = iniName  
			)
		
		if  ( iniName   =   getIniSetting	 xiangMuIniFale   customName  "Path" ) != "" do( dirScript = iniName )	
		
		if  ( iniToolIip   =   getIniSetting	 xiangMuIniFale   customName  "ToolTip" ) != "" do( edtToolTip.text = iniToolIip )	
		
		)
	on toolsPath1 pressed do   --  选择路径
	(
		
		
		dirScript = getOpenFileName   caption:"请选择添加的Max脚本:" historyCategory:"myScripts" types:"maxscript(*.ms,*.mse,*.mzp)|*.m*|All(*.*)|*.*" filename:(getDir #scripts + @"\") 
		
		
		
		if  dirScript != undefined do (
			
			nameMyScript = getFilenameFile dirScript
			
			toolsName1.text  = nameMyScript
			edtToolTip.text = nameMyScript
			
		)
		
		)
	on toolsDelete1 pressed do    --删除
	(
		if queryBox ("确定清空当前按钮吗？    \n") do 
		(
			SetINISetting  xiangMuIniFale   customName  "Name"  ""
			SetINISetting  xiangMuIniFale   customName  "Path"  ""
			SetINISetting  xiangMuIniFale   customName  "ToolTip"  ""
			toolsName1.text = ""
		
			
			execute  ("Roll_MaxQuickBar."+ customName + ".text = \"+\"")
	
			DestroyDialog   GongJuXiangSheZhi
			
			
			)
	
		)
	on GJXqueding pressed do  --确定
	(
		for tuichu = 1 to 1 do (
		
		if dirScript == ""   do ( messagebox "请选择一个工具路径。   \n"  exit )
		if  toolsName1.text == "" do ( messagebox "简称不能为空。   \n"  exit )
	
		
		SetINISetting  xiangMuIniFale  customName  "Name"  toolsName1.text
		SetINISetting  xiangMuIniFale  customName   "Path"  dirScript
		SetINISetting  xiangMuIniFale  customName   "ToolTip"  edtToolTip.text
			
		Roll_MaxQuickBar.fnShuaXinAnNiu()  --刷新页面 
			
		DestroyDialog   GongJuXiangSheZhi  --关闭页面
		 )
		)
	on btnDakaiyixuanzemulu pressed do
	(
		if  ( iniName   =   getIniSetting	 xiangMuIniFale   customName  "Path" ) != "" do 
		(
		
			local iniNameArr = filterString iniName "\\"
			
			local iniPath = ""
			for i = 1  to iniNameArr.count do 
			(
				if i != iniNameArr.count  do 
				(
					iniPath = iniPath + iniNameArr[i] + "\\"
					)
				
				)
			
			shellLaunch "explorer" iniPath
		)
	)
)





-----检查版本更新############################################################
	


	
fn downloadAndRunScript url localPath =
		(
			-- 创建一个 WebClient 对象
			webClient = dotNetObject "System.Net.WebClient"
			try
			(
				-- 下载脚本到本地
				webClient.DownloadFile url localPath
				format "Script downloaded to: %\n" localPath
				
				return True
			)
			catch
			(
				return False
			)
	)


	
rollout Roll_Banbengengxin "版本更新提示框" width:293 height:154
(
 
	button 'Roll_Banbengengxin_btnLike' "没有更新版本" pos:[46,17] width:188 height:42 align:#left  enabled:false
	button 'Roll_Banbengengxin_btnXiaci' "下次更新" pos:[54,62] width:173 height:28 align:#left   enabled:false
	checkbox 'chkZidongjianchabanbengengxin' "自动检测版本更新" pos:[81,100] width:119 height:19 align:#left
	

	
	
	on Roll_Banbengengxin open do
	(
		--如果用户禁用自动更新，则勾选自动更新按钮
		if (GetIniSetting ScriptiniPath "Zidonggengxin" "Zidonggengxin") != "false" do 
		( 
			chkZidongjianchabanbengengxin.state =  true 
			
			)
		if (getIniSetting  UrlScriptIniPath   "versions" "versionNumber") != versionNumber then 
		(
			Roll_Banbengengxin_btnLike.text = "发现新版本\n点击更新"
			
			Roll_Banbengengxin_btnLike.enabled = true
			
			Roll_Banbengengxin_btnXiaci.enabled = true
			)			
			
		)
	on Roll_Banbengengxin_btnLike pressed do
	(
		if	( downloadAndRunScript  gitScriptUrl  (getSourceFileName()) ) then 
			(
				messagebox "更新完成。\n"
				
				CUI.UnRegisterDialogBar Roll_MaxQuickBar
				DestroyDialog Roll_MaxQuickBar
				
				destroyDialog  Roll_Banbengengxin
				--打开tcb
				fileIn   (getSourceFileName())
				) 
		else ( 
			
			messagebox "更新失败。\n"
			
			destroyDialog  Roll_Banbengengxin  
			
			--打开tcb
			fileIn   (getSourceFileName())
			
		)
	
		)
	on Roll_Banbengengxin_btnXiaci pressed do
	(
		destroyDialog  Roll_Banbengengxin
		
		--打开tcb
		--fileIn   (getSourceFileName())
		
		)
	on chkZidongjianchabanbengengxin changed arg do
	(
		SetIniSetting ScriptiniPath "Zidonggengxin" "Zidonggengxin"  (arg as string)
		
		)
)

-----检查版本更新############################################################


--#############判断是否需要更新#############################################
--检查ini文档是否存在本地  如果开启禁止自动更新则跳过
if ( GetIniSetting ScriptiniPath "Zidonggengxin" "Zidonggengxin" ) != "false" then 
(		
	-- 调用函数下载工具版本ini文档
	if 	downloadAndRunScript gitScriptiniUrl UrlScriptIniPath  then
	(
		--判断是否需要更新  检测UrlScriptIniPath的版本号   和  是否忽略此次更新	
		if  (getIniSetting  UrlScriptIniPath   "versions" "versionNumber") != versionNumber   then 
		(
			createdialog Roll_Banbengengxin  
			)
		)
	else  ( print "网络环境无法更新。 " )
	
)
else (  print "用户设置跳过检测更新。   ")
