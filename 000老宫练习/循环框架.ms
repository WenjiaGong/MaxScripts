rollout test "创建BOX" --设置一个菜单栏，rollout 类型，test 变量名， “”
(

-------------------course 5 --- file part---May-------------------
button FileOpens "打开" width: 200 height:30 pos:[10,20,10]
button FileSaves "保存" width: 200 height:30 pos:[10,60,10]
edittext theEdittexts "名字:"width: 200 height:20 pos:[10,120,10]


local a = #()
-------------------course 5 --- file part---May-------------------
local files = #()
local filepath

Fn GetFileAll = (
    tmpFilename = getOpenFileName caption:"MAX Template File" types:"Max Files (*.max)|*.max|" historyCategory:"openfile" initialDir:(getDir #maxroot)
    if tmpFilename != undefined then 
        (

            theEdittexts.text = tmpFilename
            filepath = tmpFilename
            print filepath
            loadMaxFile theEdittexts.text

            --读取当前文件夹下的所有文件
            files=getfiles (maxfilepath +"*.max")
            Print files
        )

)


on FileOpens pressed do(

    GetFileAll()
)


on FileSaves pressed do(
    for i = 1 to files.count do (
        loadMaxFile files[i]
        select $box001
        move $ [100,0,0]

        saveMaxFile files[i]
    )
)

createdialog test 220 410