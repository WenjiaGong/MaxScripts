------------------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------------
global AA_floater
global AA_pos = [2,2]

-- 卷帘 1
rollout rlt1 "坐标系转换"
(
    button btn11 "视图" pos:[15,10] width:140 height:30 align:#left --tooltip:"切换到视图坐标系"
    button btn12 "局部" pos:[15,50] width:140 height:30 align:#left --tooltip:"切换到局部坐标系"
    button btn13 "屏幕" pos:[15,90] width:140 height:30 align:#left --tooltip:"切换到屏幕坐标系"
    
    on btn11 pressed do
        toolMode.coordsys #view
    
    on btn12 pressed do
        toolMode.coordsys #local
    
    on btn13 pressed do
        toolMode.coordsys #screen
)

-- 卷帘 2
rollout rlt2 "选择过滤"
(
    button btn21 "全部" pos:[15,10] width:140 height:30 align:#left --tooltip:"选择所有对象"
    button btn22 "骨骼" pos:[15,50] width:140 height:30 align:#left --tooltip:"仅选择骨骼"
    button btn23 "采用蒙皮姿态" pos:[15,90] width:140 height:30 align:#left --tooltip:"采用蒙皮姿态"
    
    on btn21 pressed do
        SetSelectFilter 1
    
    on btn22 pressed do
        SetSelectFilter 9
    
    on btn23 pressed do
        macros.run "Characters" "AssumeSkinPose"
)

-- 卷帘 3
rollout rlt3 "外部脚本"
(
    button btn31 "类型过滤" pos:[15,10] width:140 height:30 align:#left
    button btn32 "骨骼等分" pos:[15,50] width:140 height:30 align:#left
    button btn33 "飘带解算" pos:[15,90] width:140 height:30 align:#left
    
    on btn31 pressed do

	   (
            local scriptDir = getFilenamePath (getThisScriptFilename())
			local targetFile = scriptDir + "0类型过滤器.ms"
			if doesFileExist targetFile then
			fileIn targetFile
            else
			messageBox ("文件未找到:\n" + targetFile) title:"错误"
        )


    on btn32 pressed do
        (
            local scriptDir = getFilenamePath (getThisScriptFilename())
			local targetFile = scriptDir + "Bone Divider(骨骼等分汉化).ms"
			if doesFileExist targetFile then
			fileIn targetFile
            else
			messageBox ("文件未找到:\n" + targetFile) title:"错误"
        )

    on btn33 pressed do
        (
            local scriptDir = getFilenamePath (getThisScriptFilename())
			local targetFile = scriptDir + "springmagic_v1.11_zh.ms"
			if doesFileExist targetFile then
			fileIn targetFile
            else
			messageBox ("文件未找到:\n" + targetFile) title:"错误"
        )
)

-- 解决 AA_floater 的问题
if isValidNode AA_floater do
    freeNode AA_floater  -- 确保释放之前的浮动窗口

-- 创建浮动窗口
AA_floater = newrolloutfloater "老宫坐标系与选择工具" 180 480
AA_floater.pos = AA_pos

-- 将所有卷帘添加到浮动窗口
addRollout rlt1 AA_floater rolledup:false
addRollout rlt2 AA_floater rolledup:false
addRollout rlt3 AA_floater rolledup:false
