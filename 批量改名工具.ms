rollout test "批量改名工具" width:165 height:120

(	label name1 "查找字符串" pos:[10,14] width:80 height:20
	label name2 "替换字符串" pos:[10,44] width:80 height:20
	
	edittext nam1 "" pos:[80,10] width:80 height:20
	edittext nam2 "" pos:[80,40] width:80 height:20
	
	button start_rename "开始改名" pos:[10,70] width:150 height:40
	
	---------------------------------------------------------------------------

	
	on start_rename pressed do
	(
		xx1=nam1.text
		xx2=nam2.text
		
		for j in selection do
				(
					aa=j.name
					cc=0
					for i=1 to aa.count do
						if aa[i]==xx1[1] then
						(
							cc+=1
							yy=i+1
							for bb=2 to xx1.count do
							(
								if aa[yy]==xx1[bb] then
									cc+=1
								else
									cc=0
									yy+=1
							)
							
							if cc==xx1.count then
								(
									zz=1
									qq=aa.count-i-xx1.count
									rr=i+xx1.count
									ee=aa[rr]
									ss=aa[1]
									for zz=2 to i-1 do
										ss=ss+aa[zz]
									for ww=1 to qq do
										(											
											rr+=1
											ee=ee+aa[rr]
										)
									if i>1 then
										(
											if (aa.count-i)>=xx1.count then
												tt=ss+xx2+ee
											else tt=ss+xx2
											j.name=tt
										)
									if i==1 then
										(
											if aa.count==xx1.count then
												tt=xx2
											if aa.count>xx1.count then
												tt=xx2+ee
											j.name=tt
										)
								)
						)
				)
	)
)
CreateDialog test



