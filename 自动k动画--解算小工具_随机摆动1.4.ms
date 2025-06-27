fn addRandomSwingEffect selectedBones keyframeCount startFrame endFrame randomRotX randomRotY randomRotZ randomKeyframeOffset applyRotation applyPosition =
(
    if selectedBones != undefined and keyframeCount > 1 then
    (
        local totalFrames = endFrame - startFrame
        local step = totalFrames as float / (keyframeCount - 1) 

        for bone in selectedBones do
        (
            if not iscontroller(bone.rotation.controller) then
                bone.rotation.controller = Euler_XYZ()

            local initialRot = bone.rotation.controller.value
            local initialPos = bone.position.controller.value

            at time startFrame
            (
                bone.rotation.controller.value = initialRot
                bone.position.controller.value = initialPos
                addNewKey bone.rotation.controller startFrame
                addNewKey bone.position.controller startFrame
            )
            at time endFrame
            (
                bone.rotation.controller.value = initialRot
                bone.position.controller.value = initialPos
                addNewKey bone.rotation.controller endFrame
                addNewKey bone.position.controller endFrame
            )

            for i = 1 to (keyframeCount - 2) do
            (
                local targetFrame = startFrame + step * i
                local offset = random -randomKeyframeOffset randomKeyframeOffset
                local currentFrame = floor(targetFrame + offset + 0.5)

                if currentFrame > startFrame and currentFrame < endFrame then
                (
                    at time currentFrame
                    (
                        if applyRotation then
                        (
                            local rx = random -randomRotX randomRotX
                            local ry = random -randomRotY randomRotY
                            local rz = random -randomRotZ randomRotZ
                            local m = matrix3 1
                            m = rotateX m rx
                            m = rotateY m ry
                            m = rotateZ m rz
                            bone.rotation.controller.value = initialRot * m
                            addNewKey bone.rotation.controller currentFrame
                        )
                        if applyPosition then
                        (
                            local px = random -randomRotX randomRotX
                            local py = random -randomRotY randomRotY
                            local pz = random -randomRotZ randomRotZ
                            bone.position.controller.value = initialPos + [px,py,pz]
                            addNewKey bone.position.controller currentFrame
                        )
                    )
                )
            )
        )
    )
    else
    (
        messageBox "请选择骨骼并输入有效的关键帧数量。"
    )
)

rollout randomSwingRollout "随机摆动控制面板" width:250 height:385
(
    spinner spn_keyframeCount "关键帧数量: " pos:[60,10] width:150 range:[2,100,8] type:#integer
    spinner spn_randomKeyframeOffset "关键帧偏移: " pos:[60,30] width:150 range:[0,20,0] type:#integer
    spinner spn_startFrame "起始帧: " pos:[50,60] width:65 range:[0,1000,0] type:#integer
    spinner spn_endFrame "结束帧: " pos:[160,60] width:65 range:[0,1000,50] type:#integer

    slider sl_randomRotX "X范围: " pos:[30,90] width:150 range:[0,90,10] type:#float
    spinner spn_randomRotXValue "" pos:[175,118] width:60 range:[0,90,10] type:#float
    slider sl_randomRotY "Y范围: " pos:[30,140] width:150 range:[0,90,10] type:#float
    spinner spn_randomRotYValue "" pos:[175,168] width:60 range:[0,90,10] type:#float
    slider sl_randomRotZ "Z范围: " pos:[30,190] width:150 range:[0,90,10] type:#float
    spinner spn_randomRotZValue "" pos:[175,218] width:60 range:[0,90,10] type:#float

    checkbox chk_applyRotation "应用旋转" pos:[30,250] width:100 checked:true 
    checkbox chk_applyPosition "应用位置" pos:[150,250] width:100

    button btn_deleteRotationKeys "删除旋转关键帧" pos:[15,270] width:105 height:30 align:#left
    button btn_deletePositionKeys "删除位置关键帧" pos:[130,270] width:105 height:30 align:#right	
    button btn_apply "应用随机摆动" pos:[15,300] width:220 height:40 align:#center
    button btn_deleteKeys "删除范围内关键帧" pos:[15,340] width:220 height:40 align:#center
	
    on randomSwingRollout open do
    (
        spn_startFrame.value = animationRange.start.frame as integer
        spn_endFrame.value = animationRange.end.frame as integer
    )

    on sl_randomRotX changed val do
    (
        spn_randomRotXValue.value = val
    )

    on sl_randomRotY changed val do
    (
        spn_randomRotYValue.value = val
    )

    on sl_randomRotZ changed val do
    (
        spn_randomRotZValue.value = val
    )

    on spn_randomRotXValue changed val do
    (
        sl_randomRotX.value = val
    )

    on spn_randomRotYValue changed val do
    (
        sl_randomRotY.value = val
    )

    on spn_randomRotZValue changed val do
    (
        sl_randomRotZ.value = val
    )

    on btn_apply pressed do
    (
        local selectedBones = selection as array
        local keyframeCount = spn_keyframeCount.value
        local startFrame = spn_startFrame.value
        local endFrame = spn_endFrame.value
        local randomRotX = sl_randomRotX.value
        local randomRotY = sl_randomRotY.value
        local randomRotZ = sl_randomRotZ.value
        local randomKeyframeOffset = spn_randomKeyframeOffset.value
        local applyRotation = chk_applyRotation.checked
        local applyPosition = chk_applyPosition.checked

        if endFrame > startFrame then
        (
            addRandomSwingEffect selectedBones keyframeCount startFrame endFrame randomRotX randomRotY randomRotZ randomKeyframeOffset applyRotation applyPosition
        )
        else
        (
            messageBox "结束帧必须大于起始帧。"
        )
    )
	
on btn_deleteRotationKeys pressed do
(
    local selectedBones = selection as array
    local startFrame = spn_startFrame.value
    local endFrame = spn_endFrame.value

    if endFrame > startFrame then
    (
        for bone in selectedBones do
        (
            if iscontroller(bone.rotation.controller) then
            (
                local keys = bone.rotation.controller.keys
                for k = keys.count to 1 by -1 do
                (
                    local keyTime = getKeyTime bone.rotation.controller k
                    if keyTime > startFrame and keyTime < endFrame then
                    (
                        deleteKey bone.rotation.controller k
                    )
                )
            )
        )
    )
    else
    (
        messageBox "结束帧必须大于起始帧。"
    )
)

on btn_deletePositionKeys pressed do
(
    local selectedBones = selection as array
    local startFrame = spn_startFrame.value
    local endFrame = spn_endFrame.value

    if endFrame > startFrame then
    (
        for bone in selectedBones do
        (
            if iscontroller(bone.position.controller) then
            (
                local keys = bone.position.controller.keys
                for k = keys.count to 1 by -1 do
                (
                    local keyTime = getKeyTime bone.position.controller k
                    if keyTime > startFrame and keyTime < endFrame then
                    (
                        deleteKey bone.position.controller k
                    )
                )
            )
        )
    )
    else
    (
        messageBox "结束帧必须大于起始帧。"
    )
)
	

    on btn_deleteKeys pressed do
    (
        local selectedBones = selection as array
        local startFrame = spn_startFrame.value
        local endFrame = spn_endFrame.value

        if endFrame > startFrame then
        (
        for bone in selectedBones do
        (
            if iscontroller(bone.rotation.controller) then
            (
                local keys = bone.rotation.controller.keys
                for k = keys.count to 1 by -1 do
                (
                    local keyTime = getKeyTime bone.rotation.controller k
                    if keyTime > startFrame and keyTime < endFrame then
                    (
                        deleteKey bone.rotation.controller k 
                    )
                )
            )
        if iscontroller(bone.position.controller) then
       (
        local posKeys = bone.position.controller.keys
        for k = posKeys.count to 1 by -1 do
          (
            local keyTime = getKeyTime bone.position.controller k
            if keyTime > startFrame and keyTime < endFrame then
            (
                deleteKey bone.position.controller k 
            )
          )
        )
    )
        )
        else
        (
            messageBox "结束帧必须大于起始帧。"
        )
    )
)

createDialog randomSwingRollout