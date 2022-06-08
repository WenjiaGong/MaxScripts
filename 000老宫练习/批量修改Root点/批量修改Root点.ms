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
			
			--创建bone骨骼	
			startPos=[0,0,0]                                         
            endPos=[10,0,0]                                           
			b = boneSys.createBone startPos endPos [0,0,1]         
            b.width = 10
            b.height = 10
            b.taper = 90
            b.sideFins = off
            b.frontFin = off
            b.backFin = off
			b.name = "Root"
            --将骨骼进行旋转
			r = eulerangles 90 0 0
            rotate b r	
			
			
            saveMaxFile files[i]
			)
    )





	
	
	
	
	
	
)
createdialog test