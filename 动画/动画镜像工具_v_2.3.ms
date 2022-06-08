--2018/5/21 by:4698to
--E-mail:738746223@qq.com
rollout copy_mirr "动画镜像工具v.2.3" width:192 height:224
(
    GroupBox grp3 "" pos:[8,0] width:176 height:112
    -----------------------------------------------------------
    radiobuttons radioAxis "镜像轴：" pos:[16,16] width:74 height:62 labels:#("X", "XY", "Y", "YZ", "Z", "ZX") columns:2--labels:#("X", "Y", "Z") columns:3
    radiobuttons mirrorFlip "翻转" pos:[114,16] width:65 height:30 labels:#("Y", "Z") default:1 columns:2
    button bt_Axis "拾取基准轴对象" pos:[48,82] width:100 height:22 toolip:"基准轴对象"--height

    -----------------------------------------------------------
    progressBar Bar "ProgressBar" pos:[16,125] width:160 height:16 color:(color 255 0 0)
    button bt_copy_1 "A 复制" pos:[16,145] width:80 height:24 toolTip:"复制选中控制器动画" across:2
    button bt_mirror "A 黏贴" pos:[96,145] width:80 height:24 toolTip:"镜像黏贴动画"
    -----------------------------------------------------------
    HyperLink lbl_01 "帮助" pos:[84,203] width:24 height:15 address:"https://github.com/4698to/Joetime.linetool.bar/tree/master/anim_mirror"
    button btn_copy_pose "P 复制" pos:[16,169] width:80 height:24 toolTip:"复制选中控制器POSE" across:2 --enabled:false
    button btn_mirror_pose "P 黏贴" pos:[96,169] width:80 height:24 toolTip:"镜像黏贴POSE" --enabled:false
    GroupBox grp4 "" pos:[8,112] width:176 height:88

    global c_m
    struct copy_mirror_ver
    (

        copy_for_obj,
        copy_to_obj,
        --bake_node,--黏贴之前保存原有动画对象
        AxisNode,--基准轴对象
        a_sm = [1,1,1],
        mirrorTm = scaleMatrix [-1,1,1],
        from_obj = #(), --复制对象
        to_obj = #(),--黏贴对象
        -------------------------------------------------------


        -------------------------------------------------------
        fn add_mirror_anim a_a b_b A_P=
        (
            set animate off; animButtonState = false--关闭动画自动关键帧
            anim_pose = A_P
            new_anim = point() --动画过度载体
            c_m.add_anim_mirror a_a new_anim anim_pose  --镜像动画到过度载体上
            ResetScale new_anim --镜像之后缩放会变成 -100 ，这里重置缩放
            if copy_mirr.mirrorFlip.state == 1 do
            (
                in coordSys Local rotate new_anim (angleaxis -180 [1,0,0]) --local 轴旋转180
            )
            c_m.add_copy_anim new_anim b_b anim_pose--转换完成的动画复制到镜像对象上
            delete new_anim --销毁过度载体
        ),
        -------------------------------------------------------
        fn add_anim_mirror copy_for copy_to A_P= --镜像动画
        (   --A_P == 1  动画 ； 2 POSE
            try
            (
                if A_P == 1 then
                (
                    if (copy_for[3][1].keys.count != 0) do
                    (


                        for i=1 to copy_for[3][1].keys.count do
                        (

                            --undo On
                            --(
                                animate On
                                (
                                        t = (copy_for[3][1].keys[i].time.frame as integer)
                                        (
                                            at time t
                                            (
                                                --copy_to.transform =(scaleMatrix [1,-1,1])*(copy_for.transform*inverse c_m.AxisNode.transform)*c_m.mirrorTm*c_m.AxisNode.transform
                                                copy_to.transform = (copy_for.transform*inverse c_m.AxisNode.transform)*c_m.mirrorTm*c_m.AxisNode.transform

                                            )
                                        )
                                )
                            --)
                        )

                        for o=1 to copy_for[3][2].keys.count do
                        (

                            --undo On
                            --(
                                animate On
                                (
                                        t = (copy_for[3][2].keys[o].time.frame as integer)
                                        (
                                            at time t
                                            (
                                                --copy_to.transform =(scaleMatrix [1,-1,1])*(copy_for.transform*inverse c_m.AxisNode.transform)*c_m.mirrorTm*c_m.AxisNode.transform
                                                copy_to.transform =(copy_for.transform*inverse c_m.AxisNode.transform)*c_m.mirrorTm*c_m.AxisNode.transform

                                            )
                                        )
                                )
                            --)
                        )
                    )
                )
                else
                (
                    animate On
                    (
                       at time (sliderTime.frame as integer)
                       (
                            copy_to.transform =(copy_for.transform*inverse c_m.AxisNode.transform)*c_m.mirrorTm*c_m.AxisNode.transform
                        )
                    )
                )

            )catch()
        ),
        -------------------------------------------------------
        fn add_copy_anim for_b to_b A_P= --复制 动画
        (
            if A_P == 1 then
            (
                if for_b[3][1].keys.count != 0 do--then
                (
                    for i=1 to for_b[3][1].keys.count do
                    (
                        animate On
                        (
                                t = (for_b[3][1].keys[i].time.frame as integer)
                                (
                                    at time t
                                    (
                                        to_b.transform = for_b.transform

                                    )
                                )
                        )
                    )
                    for o=1 to for_b[3][2].keys.count do
                    (
                        animate On
                        (
                                t = (for_b[3][2].keys[o].time.frame as integer)
                                (
                                    at time t
                                    (
                                        to_b.transform = for_b.transform
                                    )
                                )
                        )
                    )
                )
            )
            else
            (
                animate On
                (
                    at time (sliderTime.frame as integer)
                    (
                        to_b.transform = for_b.transform
                    )
                )
            )
        ),
        -------------------------------------------------------
        fn add_tcb_anim for_b =
        (
            try (
                for_b.rotation.controller = tcb_rotation ()
            )catch()
        ),
        -------------------------------------------------------
        fn Call_Mirror =  --设置镜像轴
        (
            var_n  = copy_mirr.radioAxis.state
            c_m.a_sm = [1,1,1]
            if  (var_n <= 2 or var_n == 6 ) do  c_m.a_sm.x = (-1)
            if  (var_n >= 2 and var_n<= 4 ) do c_m.a_sm.y = (-1)
            if (var_n >= 4 ) do c_m.a_sm.z = (-1)
            c_m.mirrorTm = scaleMatrix c_m.a_sm
        )

    )--Struct body End .
    -------------------------------------------------------
    on bt_Axis pressed do--选择基准轴对象
    (
        if selection.count != 0 do
        (
            c_m.AxisNode = selection[1]
            bt_Axis.text = c_m.AxisNode.name
        )
    )
    -------------------------------------------------------

    on radioAxis changed var do --设置镜像轴
    (
        c_m.Call_Mirror()
    )
    -------------------------------------------------------

    on bt_copy_1 pressed do --复制
    (
        if selection.count != 0 do
        (
            c_m.from_obj = selection as array
        )
    )
    -------------------------------------------------------

    on bt_mirror pressed do --黏贴
    (
            if (IsValidNode c_m.AxisNode) then
            (
                if selection.count != 0 then
                (
                    c_m.Call_Mirror()
                    undo "add anim mirror_1" on
                    (
                        c_m.to_obj = selection as array
                        for p=1 to c_m.to_obj.count  do
                        (
                            c_m.copy_to_obj = c_m.to_obj[p]
                            c_m.copy_for_obj = c_m.from_obj[p]

                            c_m.add_mirror_anim c_m.copy_for_obj c_m.copy_to_obj 1
                            c_m.add_tcb_anim c_m.to_obj[p] --c_m.copy_to_obj
                            copy_mirr.Bar.value = 100 * ((p as float )/((c_m.to_obj.count) as float))
                            --print (copy_mirr.Bar.value as string)
                        )
                        copy_mirr.Bar.value = 0
                    )
                )
                else
                (
                    messageBox "请选择一个或多个物体 !! \n\r ."
                )
            )
            else
            (
                bt_Axis.text = ""
                messageBox "请设置 基准轴 对象  \n\r ."
            )
    )
    -------------------------------------------------------
    on btn_copy_pose pressed do
    (
        if selection.count != 0 do
        (
            c_m.from_obj = selection as array
        )
    )
    -------------------------------------------------------
    on btn_mirror_pose pressed do
    (
            if (IsValidNode c_m.AxisNode) then
            (
                if selection.count != 0 then
                (
                    c_m.Call_Mirror()
                    undo "add anim mirror_2" on
                    (
                        c_m.to_obj = selection as array
                        for p=1 to c_m.to_obj.count  do
                        (
                            c_m.copy_to_obj = c_m.to_obj[p]
                            c_m.copy_for_obj = c_m.from_obj[p]
                            c_m.add_mirror_anim c_m.copy_for_obj c_m.copy_to_obj 2
                            c_m.add_tcb_anim c_m.copy_to_obj

                            copy_mirr.Bar.value = 100*((p as float )/((c_m.to_obj.count) as float))
                        )
                        copy_mirr.Bar.value = 0
                    )
                )
                else
                (
                    messageBox "请选择一个或多个物体 !! \n\r ."
                )
            )
            else
            (
                bt_Axis.text = ""
                messageBox "请设置 基准轴 对象  \n\r ."
            )
    )
    -------------------------------------------------------
    on copy_mirr open do
    (
        c_m.Call_Mirror()
    )
    -------------------------------------------------------
)
c_m = copy_mirr.copy_mirror_ver()
createDialog copy_mirr