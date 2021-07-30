try(destroyDialog UntitledRollout)catch()
rollout UntitledRollout "UntitledRollout" width:112 height:40
(
        button savesel "存物并集图" pos:[8,8] width:100 height:24

        fn copy_map sel dir up:undefined = (        ----------//收集贴图 ,更新贴图
                for i in sel do (
                        for v in usedmaps i do copyfile v (dir+"\\"+ filenamefromPath v )        --//复制使用中的贴图到指定
                        if up != undefined and  i.material != undefined do (        
                                local ss = getClassInstances bitmaptexture target:i.material
                                for o in ss do o.filename = (dir+"\\"+ filenamefromPath o.filename )        --//复制后更新材质路径
                
                        )
                )
        )

        on savesel pressed do
        (
            try (
                        dir = getSavePath caption:"自定义设置路径" initialDir:(maxFilepath)
                        if (dir != undefined) then
                        copy_map selection dir up:true
                        newMax = dir + "\\" +"Untitled.max"
                        saveNodes $ newMax
                        ATSOps.Refresh()
                )catch()
        )
)
createDialog UntitledRollout