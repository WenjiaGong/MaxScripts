

rollout testddl_rollout "保存动画"
(global bipObja
	local filename
		

local  none = #()

	global  liangzu = #("男","女","老人小孩","两足怪物")
	local  nan = #("待机","走路","跑步","攻击和施法","受击死亡眩晕","个性和出场")
	local  nv =  #("待机","走路","跑步","攻击和施法","受击死亡眩晕","个性和出场")
	local  laoxiao = #("移动","攻击","其他")
	local  guai = #("待机","走路","跑步","攻击和施法","受击死亡眩晕","个性和出场")
	---------------------------------------------------------------------------------
	local  sizu = #("猫科","犬科","蹄类","四足其他")
	local  maoke = #("待机","走路","跑步","攻击","受击死亡眩晕","其他")
	local  quanke = #("待机","走路","跑步","攻击","受击死亡眩晕","其他")
	local  tilei= #("待机","走路","跑步","攻击","受击死亡眩晕","其他")
	local  sizuqita = #("待机","移动","攻击","其他")
	---------------------------------------------------------------------------------
	local  feiqin = #("飞龙","鸟类","飞禽其他")
    local  feilong = #("移动","其他")
	local  niaolei = #("移动","其他")
	local  feiqinqita = #("移动","其他")
	---------------------------------------------------------------------------------
    local  jixie = #("生物类","非生物类","机械其他")
	local  shengwu = #("待机","移动","攻击","受击死亡眩晕","其他")
	local  feishengwu = #("待机","移动","攻击","受击死亡眩晕","其他")
	local  jixieqita = #("待机","移动","攻击","受击死亡眩晕","其他")

  --button btn_select1 "Select 1" align:#left--these buttons will set the list
 -- button btn_select2 "Select 2"align:#left --by calling the custom function that
 -- button btn_select3 "Select 3" align:#left--replaces the on selected() handler
	
dropdownlist leiList1 "分类1:" items: #("两足","四足","飞鸟虫蛇","机械")
dropdownlist leiList2 "分类2:" items:none--this is the dropdownlist
dropdownlist leiList3 "分类3:" items:none--this is the dropdownlist
edittext namtxt "名称:"  labelOnTop:true
	 HyperLink lbl9 "官网" pos:[90,5] width:80  color:(color 255 127.5 0) address:"https://pylblog.com/post/maxdzk.html"

	 button jiazai "保存"  pos:[10,180]
	  button xr "更新预览"  pos:[90,180]
  --this is the custom function that performs the operations normally done --inside the on selected() event handler:
 	on leiList1 selected i do (
		local selectlist1=leiList1.selected
 case selectlist1 of (
	"两足" : leiList2.items =liangzu
"四足" : leiList2.items =sizu
	 "飞鸟虫蛇" : leiList2.items =feiqin
	 "机械" : leiList2.items =jixie
	
	default: 1
 )
	  format "----------------------------%\n" selectlist1
		
 
	)---------------------------------------------------------------------
	  
	
	
		on leiList2 selected i do (
		local selectlist2=leiList2.selected
 case selectlist2 of (
	"男" : leiList3.items =nan
"女" : leiList3.items =nv
	 
	 "老人小孩" : leiList3.items =laoxiao
	 "两足怪物" : leiList3.items =guai
	 "猫科" : leiList3.items =maoke
	 "犬科" : leiList3.items =quanke
	 "蹄类" : leiList3.items =tilei
	 "四足其他" : leiList3.items =sizuqita
	 "飞龙" : leiList3.items =feilong
	 "鸟类" : leiList3.items =niaolei
	 "飞禽其他" : leiList3.items =feiqinqita
	 "生物类" : leiList3.items =shengwu
	 "非生物类" : leiList3.items =feishengwu
	 "机械其他" : leiList3.items =jixieqita
	default: 1
 )
	  format "----------------------------%\n" selectlist1
		
 
	)
	
	  on xr pressed do ( 
			global fPath = getFileNamePath (getsourceFileName()) 
	 format "----------------------------%\n" fPath 
	global fenlei1=leiList1.selected
	global fenlei2=leiList2.selected
	global fenlei3=leiList3.selected
	global mingzi=namtxt.text
	global dizhi=fPath+"/bip/"+fenlei2+"_"+mingzi+".bip"
	global img=fPath+"/img/"+fenlei2+"_"+mingzi
				
				
				
			CS_All=for i in objects where (classof i==Biped_Object or classof i == Dummy) collect i
			hide CS_All


localPath = GetFilenamePath (GetSourceFileName())
DotNet.LoadAssembly (localPath + "Ngif.dll")
GifEncoder = DotNetObject  "NGif.AnimatedGifEncoder"
DotNetImage = DotNetClass "System.Drawing.Image"
theGifFileName = img+".gif"
GifEncoder.Start(theGifFileName )
GifEncoder.SetDelay(40);
GifEncoder.SetRepeat(0);

timeStart = AnimationRange.Start.Frame
timeEnd = AnimationRange.End.Frame

for i = timeStart to timeEnd do
(
    SliderTime = i
    tempframe = img+".png"
    render outputwidth:250 outputheight:250 outputfile:tempframe vfb:off
    tempImage = DotNetImage.FromFile tempframe 
    GifEncoder.AddFrame tempImage
    tempImage.Dispose()
)
GifEncoder.Finish()



unhide CS_All

	
				
				
				
				
				
			)
	
	  on jiazai pressed do ( 
		 
if classof $==Biped_Object  do
(		  
		global fPath = getFileNamePath (getsourceFileName()) 
	 format "----------------------------%\n" fPath 
	global fenlei1=leiList1.selected
	global fenlei2=leiList2.selected
	global fenlei3=leiList3.selected
	global mingzi=namtxt.text
	global dizhi=fPath+"/bip/"+fenlei2+"_"+mingzi+".bip"
	global img=fPath+"/img/"+fenlei2+"_"+mingzi
	
	db="driver={Microsoft Access Driver (*.mdb, *.accdb)}; DBQ="+fPath+"anim.mdb"
	
	
	DogConn2 = createOLEObject "ADODB.Connection"
DogConn2.Open db
recordSet2 = createOLEObject "ADODB.Recordset"
recordSet2.Open ("SELECT * from wenjian where fenlei1='"+fenlei1+"' and fenlei2='"+fenlei2+"' and fenlei3='"+fenlei3+"'and mingzi='"+mingzi+"'") DogConn2
if recordSet2.BOF AND recordSet2.EOF then (


	
	
	
	DogConn1 = createOLEObject "ADODB.Connection"
DogConn1.Open db
recordSet1 = createOLEObject "ADODB.Recordset"

	
	recordSet1.Open "SELECT * from wenjian" DogConn1 1 3 -- adOpenKeyset adLockOptimistic
fields=recordSet1.Fields -- print out column names
count = fields.count
for i = 1 to count do (local item = fields.item (i-1); print item.name)
recordSet1.GetRows() -- display current contents
recordSet1.AddNew #("fenlei1","fenlei2","fenlei3", "mingzi", "dizhi") #(fenlei1,fenlei2,fenlei3,mingzi,dizhi) -- add via array
	
	
	
		
bip1 = $.controller   
max motion mode   
--File I/O 
	
	
biped.saveBipFile bip1 (dizhi)

CS_All=for i in objects where (classof i==Biped_Object or classof i == Dummy) collect i
			hide CS_All


localPath = GetFilenamePath (GetSourceFileName())
DotNet.LoadAssembly (localPath + "Ngif.dll")
GifEncoder = DotNetObject  "NGif.AnimatedGifEncoder"
DotNetImage = DotNetClass "System.Drawing.Image"
theGifFileName = img+".gif"
GifEncoder.Start(theGifFileName )
GifEncoder.SetDelay(40);
GifEncoder.SetRepeat(0);

timeStart = AnimationRange.Start.Frame
timeEnd = AnimationRange.End.Frame

for i = timeStart to timeEnd do
(
    SliderTime = i
    tempframe = img+".png"
    render outputwidth:250 outputheight:250 outputfile:tempframe vfb:off
    tempImage = DotNetImage.FromFile tempframe 
    GifEncoder.AddFrame tempImage
    tempImage.Dispose()
)
GifEncoder.Finish()



unhide CS_All





messagebox "成功"
)
else  (messagebox "动作名称存在")

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	


	)
)
	  
	)  
	  
createDialog testddl_rollout