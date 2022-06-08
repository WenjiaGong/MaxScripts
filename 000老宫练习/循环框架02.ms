rollout test "无标题" width:162 height:300
(
	button FileOpens "打开" pos:[27,50] width:107 height:33 align:#left
    button FileSaves "保存" pos:[27,100] width:107 height:33 align:#left
    edittext theEdittexts "名字:" pos:[27,150] width:107 height:33 align:#left
	
	
	
     local files = #()
     local filepath
	
	
	

	fn GetFileAll = 
	(
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
	on FileOpens pressed  do
		GetFileAll()
	


	
	
	on FileSaves pressed do
	(
		for i = 1 to files.count do 
			(
			loadMaxFile files[i]
			--select $box001
            --move $ [100,0,0]
            --rotate $ (angleaxis 90 [0,1,0])
            select $Bip001
            $.parent = $Root
            saveMaxFile files[i]
			)
    )





	
	
	
	
	
	
)
createdialog test