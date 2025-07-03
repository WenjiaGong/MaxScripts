--------------------------------------------------------------------------------------
-- Script Name:        TotalAnimationBaker.ms
-- Compatible:                Max 2011 and up
-- Version:                v1.0
-- Release date:   29 March 2016
-- Code by:                Hernan Rodenstein  - www.pylblog.com
------------------------------------------------------------------------------------

        global AA_floater
        global AA_pos = [407,77]
        
        rollout RL_BakeAnim "Total Animation Baker V1.0"
        (                
                local astart = animationrange.start
                local aend = animationrange.end
                
                group "适用于"
                (
                        radiobuttons rbApplyTo labels:#("选择", "所有对象") align:#center default:1
                )
                
                group "帧范围"
                (
                        radiobuttons useTimeRange labels:#("活动范围", "设置范围") align:#center default:1
                        spinner sframe "开始时间" range:[1,1000000,astart] type:#integer fieldwidth:50 align:#center enabled:false
                        spinner eframe "结束时间" range:[1,1000000,aend] type:#integer fieldwidth:50 align:#center enabled:false
                )

                group "增量"
                (
                        spinner stepCount "步进计数" range:[1,100,1] type:#integer fieldwidth:30 align:#center
                )

                checkbox incBipeds "包括Biped" checked:true offset:[0,10]
                checkbox bakeRegular "烘焙标准动画" checked:false
                checkbox delObsolete "移除过时的东西" checked:true tooltip:"删除过时的辅助对象、形状和IK目标"
                
                button AnimAlign "烘焙动画" width:150 height:30 align:#center offset:[0,10]
                progressbar progBar width:150 height:5 color:blue align:#center offset:[0,3]

                -- Collect the root node of every biped and make an array
                function getBipedsRoots objsArr =
                (
                        bipedRootsArr = #()
                        for obj in objsArr do (
                                if isValidNode obj==true do (
                                        if classOf obj == Biped_Object then (
                                                bipedRoot = biped.getNode obj #vertical
                                                appendIfUnique bipedRootsArr bipedRoot
                                        )
                                )
                        )
                        return bipedRootsArr
                )
                
                -- Get the main animation nodes of a biped (given the root node)
                function getBodyNodes theRoot =
                (
                        nodeIndexList = #(#larm,#rArm,#lLeg,#rLeg,#spine,#head,#pelvis,#tail,#prop1,#prop2,#prop3) -- ,#vertical,#horizontal,#turn)
                        obj = undefined
                        for i in nodeIndexList where ( obj = ( biped.getNode theRoot i ) ) != undefined collect obj
                )
                
                -- Get all the animation nodes of a biped
                function getAllCtrlNodes theRoot =
                (
                        objList = ( getBodyNodes theRoot ) + #( theRoot.controller.vertical,theRoot.controller.Horizontal,theRoot.controller.turning )
                )
                
                -- Reduce the number of keyframes in a biped according to the stepCount parameter 
                function reduceBipedKeys theRoot =
                (
                        theCtrlNodes = (getAllCtrlNodes theRoot)
                        StartFrame = astart +1                
                        do
                        (
                                currentEndFrame = StartFrame + stepcount.value - 2
                                for currentFrame = StartFrame to currentEndFrame do         (
                                        for obj in theCtrlNodes do
                                        (
                                                i = getKeyIndex obj.controller currentFrame
                                                if i > 0 then deleteKey obj.controller i
                                        )
                                )
                        )
                        while ( StartFrame = currentEndFrame + 2 )<= aend
                )
                
                function removeIKHelpers objsArr =
                (        
                        for obj in objsArr do (
                                if isValidNode obj==true then (
                                        if classOf obj==BoneGeometry and classOf obj.controller==IKControl then (
                                                IKObj = (for o in (refs.dependentNodes obj) where (classOf o)==IK_Chain_Object collect o)[1]
                                                if IKObj!=undefined and isValidNode IKObj then delete IKObj
                                        )
                                )
                        )
                )
                
                -- Check if object is animated 
                function checkIfAnimated obj =
                (
                        isAniObj = false
                        for c=1 to 3 do (
                                if obj.controller[c]!=undefined then (
                                        if obj.controller[c].isAnimated==true then (isAniObj=true; exit)
                                )
                        )
                        return isAniObj
                )
                
                -- Determine whether an object has standard position/rotation/scale controllers
                function hasStandardControllers obj =
                (
                        stdCtrl = true
                        if (classOf obj.controller)!=prs then (
                                stdCtrl = false
                        ) else (
                                if (classOf obj.pos.controller)!=Position_XYZ and (classOf obj.pos.controller)!=bezier_position then (
                                        stdCtrl = false
                                        return stdCtrl
                                )
                                if (classOf obj.rotation.controller)!=Euler_XYZ and (classOf obj.rotation.controller)!=tcb_rotation then (
                                        stdCtrl = false
                                        return stdCtrl
                                )
                                if (classOf obj.scale.controller)!=ScaleXYZ and (classOf obj.scale.controller)!=bezier_scale then (
                                        stdCtrl = false
                                        return stdCtrl
                                )
                        )
                        return stdCtrl
                )
                
                -- Bake Animation
                function bakeAnimation objsArr =
                (
                        TMArray=#() -- Array of transform matrix                
                        -- Get the animation of every object, a TM per each frame
                        for b=1 to objsArr.count do (
                                append TMArray #()
                                for f=astart to aend do (
                                        at time f append TMArray objsArr.transform
                                )
                        )
                        removeIKHelpers objsArr
                        -- Assign a new prs controller (to delete any constraint or undesirible controller) and set back the animation
                        animate on
                        (
                                for b=1 to objsArr.count do (
                                        if (classOf objsArr.controller==prs) then objsArr.controller = transform_script() -- if prs controller already exists, assign a temporary controller
                                        objsArr.controller = prs()
                                        count=1
                                        for t=astart to aend by stepcount.value do (
                                                at time t objsArr.transform=TMArray[count]
                                                count+=stepcount.value
                                        )
                                        progBar.value = 100.0*b/objsArr.count
                                )
                        )
                )
                
                -- Get objects related to objsArr
                function getAssociatedObjs objsArr =
                (
                        objsArr = (for o in objsArr where (superClassOf o)==GeometryClass collect o)
                        arr = #()
                        for obj in objects do (
                                if (findItem objsArr obj)!=0 then (
                                        dpArr = refs.dependentNodes obj
                                        for dp in dpArr do appendIfUnique arr dp
                                ) else (
                                        dpArr = refs.dependentNodes obj
                                        for o in dpArr do (
                                                if (findItem objsArr o)!=0 then (
                                                        appendIfUnique arr obj
                                                        exit
                                                )
                                        )
                                )
                        )
                        return arr
                )
                
                -- Delete helpers or shapes that have turned obsolete after the baking 
                function removeObsoleteObjs objsArr =
                (
                        for obj in objsArr do (                                                                
                                if isValidNode obj==true then (
                                        if (superClassOf obj)!=GeometryClass and obj.children.count==0 and (refs.dependentNodes obj).count==0 then (
                                                if (classOf obj.parent)!=Biped_Object and (classOf obj.parent)!=BoneGeometry and (classOf obj)!=CATParent and (classOf obj)!=IKTarget then (                                
                                                        if (superClassOf obj)==shape then (
                                                                if obj.render_displayRenderMesh==false and obj.render_renderable==false then delete obj
                                                        ) else (                        
                                                                delete obj
                                                        )
                                                )
                                        )
                                )
                        )
                )
                
                on useTimeRange changed state do
                (
                        if useTimeRange.state == 2 then (
                                sframe.enabled = true
                                eframe.enabled = true
                        ) else (
                                sframe.enabled = false
                                eframe.enabled = false
                                astart = animationrange.start
                                aend = animationrange.end
                        )                        
                )

                on sframe changed val do astart = val
                
                on eframe changed val do aend = val
                
                on AnimAlign pressed do
                (
                        if astart > aend then (
                                messageBox "结束时间小于开始时间！\请检查您的范围" title:"JJTools错误" beep:true
                        ) else (
                                clearUndoBuffer()
                                undo on (        
                                        doIt = true                                                
                                        if rbApplyTo.state==1 then (
                                                if selection.count>0 then (
                                                        objsArr = selection as array
                                                ) else (
                                                        messageBox "Nothing selected!"
                                                        doIt = false
                                                )
                                        ) else (
                                                objsArr = objects
                                        )                                
                                        
                                        if doIt==true then
                                        (
                                                relObjsArr = getAssociatedObjs objsArr
                                                for obj in objsArr do appendIfUnique relObjsArr obj
                                                
                                                newObjsArr = #()
                                                if bakeRegular.checked==false then (                                                
                                                        for obj in objsArr do (
                                                                if (hasStandardControllers obj)==false then (
                                                                        append newObjsArr obj
                                                                )
                                                        )                                                        
                                                ) else (
                                                        for obj in objsArr do (
                                                                if (hasStandardControllers obj)==false or ((hasStandardControllers obj)==true and (checkIfAnimated obj)==true) then append newObjsArr obj
                                                        )                                                        
                                                )
                                                
                                                bkObjsArr = (for o in newObjsArr where ((classof o)!=IK_Chain_Object and (classof o)!=Biped_Object and (classof o)!=CATBone and (classof o)!=HubObject and (classof o)!=CATParent and (classof o)!=IKTarget) collect o)                                                        
                                                bakeAnimation bkObjsArr
                                                
                                                if incBipeds.checked==true then (
                                                        bipedRootsArr = getBipedsRoots objsArr
                                                        -- Bake Bipeds
                                                        for obj in bipedRootsArr do (
                                                                biped.convertToFreeform obj.transform.controller keyPerFrame:true
                                                                if stepcount.value > 1 then reduceBipedKeys obj
                                                        )
                                                )
                                                
                                                -- Delete unnecessary objects
                                                if delObsolete.checked==true then removeObsoleteObjs relObjsArr
                                                
                                                progBar.value = 0
                                        )
                                )-- end undo                                
                        ) -- end if
                ) -- end on
        ) -- end rollout

        try
        (
                closerolloutfloater aa_floater
                aa_pos = aa_floater.pos
        )catch()
        aa_floater = newrolloutfloater "Total Animation Baker V1.0" 170 376
        AA_floater.pos = AA_pos
        addrollout RL_BakeAnim AA_floater rolledup:false