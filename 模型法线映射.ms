global selectMaskObj            
global selectCheckObj            
           
global pickMaskObj            
global pickCheckObj            
global pickCenterObj            
global checkNormalFun            
global CheckNormalInitData            
           
fn pickMaskObj =            
(            
    local selObjs = getcurrentSelection()            
    if selObjs == undefined or selObjs.count == 0 then            
    (            
        selectMaskObj = undefined            
    )            
    else            
    (            
        selectMaskObj = selObjs[1]            
    )            
    CheckNormalInitData()            
)            
           
fn pickCheckObj =            
(            
    local selObjs = getcurrentSelection()            
    if selObjs == undefined or selObjs.count == 0 then            
    (            
        selectCheckObj = undefined            
    )            
    else            
    (            
        selectCheckObj = selObjs[1]            
    )            
    CheckNormalInitData()            
)            
           
           
           
fn checkNormalFun =            
(            
               
    if selectMaskObj == undefined or selectCheckObj == undefined then            
    (            
        print selectMaskObj            
        print selectCheckObj            
           
        return 0            
    )            
    local vertNum = selectCheckObj.numverts            
    print vertNum            
    local center = selectMaskObj.pos            
    print center            
    local vRota = selectCheckObj.rotation            
           
    local rayNormalList = #()            
    --local i = 617            
    for i in 1 to vertNum do            
    (            
        local vertPos = polyop.getvert selectCheckObj i            
           
        local dir1 = vertPos - center            
        dir1 = normalize dir1            
               
        local outPoint = center + dir1*100            
           
           
        local dir2 = center - outPoint            
        local tempRay = Ray outPoint dir2            
        local hitPoint = intersectRay selectMaskObj tempRay            
           
           
        if hitPoint != undefined then            
        (            
           
            local norVal = normalize (hitPoint.pos - center)            
            norVal = norVal * vRota            
            rayNormalList[i] = norVal            
           
        )            
    )            
    select selectCheckObj            
    local needAddMod = true            
    if selectCheckObj.modifiers.count == 0 then            
    (            
        needAddMod = true            
    )            
    else            
    (            
        for i in 1 to selectCheckObj.modifiers.count do            
        (            
                       
                       
            if selectCheckObj.modifiers[i].name == "Edit Normals" then            
            (            
                needAddMod = false            
                break            
            )            
        )            
    )            
    if needAddMod == true then            
        modPanel.addModToSelection (Edit_Normals()) ui:on            
           
    local modN = selectCheckObj.Edit_Normals            
           
    for i in 1 to vertNum do            
    (            
        if rayNormalList[i] != undefined then            
        (            
            local tempVertList = #{i}            
            local normalIdList = #{}            
            modN.ConvertVertexSelection &tempVertList &normalIdList            
            for j in normalIdList do            
            (            
                modN.SetNormal j rayNormalList[i]                  
                   
            )            
        )            
    )            
           
               
)            
           
           
           
rollout CheckNormalWin "Untitled" width:241 height:300            
(            
    label 'lbl1' "映射源名称" pos:[29,12] width:150 height:31 align:#left            
    button 'pickMaskBtn' "选择映射源" pos:[45,34] width:133 height:29 align:#left            
    button 'pickObjBtn' "选择映射目标" pos:[45,100] width:134 height:34 align:#left            
    button 'createNormalBtn' "计算" pos:[43,235] width:134 height:34 align:#left            
    label 'lbl2' "映射目标名称" pos:[27,73] width:150 height:31 align:#left            
               
           
               
           
    on pickMaskBtn pressed do            
    (            
        pickMaskObj()            
    )            
    on pickObjBtn pressed do            
    (            
        pickCheckObj()            
    )            
    on createNormalBtn pressed do            
    (            
        checkNormalFun()            
    )            
)            
fn CheckNormalInitData =            
(            
    print selectMaskObj            
    if selectMaskObj == undefined then            
        CheckNormalWin.lbl1.text = "pick mask"            
    else            
        CheckNormalWin.lbl1.text = selectMaskObj.name            
               
    if selectCheckObj == undefined then            
        CheckNormalWin.lbl2.text = "pick obj"            
    else            
        CheckNormalWin.lbl2.text = selectCheckObj.name            
               
)            
           
           
createDialog CheckNormalWin            
CheckNormalInitData()