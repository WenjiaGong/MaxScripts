rollout yelangqiu "一键降版本1.0" width:216 height:200
(
	local version = (maxVersion())[1]/1000+1998 --对版本编码进行重新梳理
	local a = version - 3; --获取当前版本能保存的最低版本
	local value1 = version as string; --转成字符串
	
		
	button 'btn2' "选择需要批量降版本的目标路径" pos:[13,12] width:182 height:30 align:#left
	label 'label' "当前Max版本：" pos:[16,58] width:90 height:26 align:#left
	label 'label2'  value1 pos:[100,58] width:90 height:26 align:#left
	label 'label3'  "------------------------------
		  本插件旨在批量处理高版本文件，减少转版本的时间成本。只需要选择保存了高版本文件的目录，点击按钮一键降低三个版本并保存。（注意备份好原来的文件，避免一些高版本插件和材质丢失。）" pos:[16,78] width:190 height:100 align:#left


	on btn2 pressed do 
	(
        local targetFolder = getSavePath caption:"选择目标路径" -- 获取目标路径
        local targetFiles = getFiles (targetFolder + "\\*.max") -- 获取目标路径下的所有max文件
    
        if targetFolder != undefined do -- 如果选择了文件和目标路径，则执行以下操作
        (
   
		    for targetFile in targetFiles do -- 遍历目标路径下的所有max文件
		    (
			    local targetName = getFilenameFile targetFile -- 获取文件名
			    local targetModel = loadMaxFile targetFile -- 加载目标文件
				
			    (
					
				    saveMaxFile targetFile saveAsVersion:a clearNeedSaveFlag:true -- 保存目标文件
                    
			    )
		    )
		
        
        )
    
	)	
	
)
CreateDialog yelangqiu