
rollout testddl_rollout "动作库"
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
dropdownlist leiList1 "分类1:" items: #("两足","四足","飞鸟虫蛇","机械")width:130 pos:[260, 10]
dropdownlist leiList2 "分类2:" items:none width:130 pos:[260, 50] --this is the dropdownlist
dropdownlist leiList3 "分类3:" items:none width:130 pos:[260, 90]  --this is the dropdownlist
dropdownlist leiList4 "動作:" items:none width:130 pos:[260, 130]    --this is the dropdownlist

	checkbox filestruc "匹配bip文件骨骼" across:1 offset:[260,2]
	checkbutton newbip "预览" checked:false tooltip:"Opens setup panels" pos:[260,200]
	 button jiazai "加载"  pos:[320,200]     
	
	 HyperLink lbl9 "官网" pos:[350,5] width:80  color:(color 255 127.5 0) address:"https://pylblog.com/post/maxdzk.html"
  --this is the custom function that performs the operations normally done --inside the on selected() event handler:
  
  
  
dotNetControl wb "System.Windows.forms.WebBrowser" height:250 width:250 align:#left pos:[0, 0]


	on testddl_rollout open do( 
		
		
		
		
		ifFile=doesFileExist "C:\\ProgramData\Autodesk\autodesklog.txt"	



if ifFile==false then
(


					
				rollout rendrollout1 "The skin tool panel" width:500 height:500
(	               edittext jhm "注册码:"  labelOnTop:true
					edittext jhtxt "激活码:"  labelOnTop:true
	  button gb "关闭"  pos:[250,350]
 HyperLink lbl9 "获取激活码请点击" pos:[300,90] width:300  color:(color 255 127.5 0) address:"https://pylblog.com/post/maxdzk.html"
	button jhbtn "激活" pos:[108,90] width:50 height:30
	on rendrollout1 open do (
              a= random 111111 999999
  format "----------------------------%\n"  a
				jhm.text=a	as string
)


on gb pressed do (
	DestroyDialog testddl_rollout
	DestroyDialog rendrollout1
)

  on jhbtn pressed do (
numtxt1=jhtxt.text 
	  numtxt2=jhm.text 
	  intjh=numtxt2 as integer
	    intjh2=numtxt1 as integer
yz=intjh*2+1000*3-666*2-689+565

if   intjh2==yz then(
 
	    createFile "C:\\ProgramData\Autodesk\autodesklog.txt"


	
	format "激活成功！----------------------------"  yz
	
	DestroyDialog rendrollout1
	
	
	
	
)


)



)

	createdialog rendrollout1  bgcolor:(color 50 50 50)  fgcolor:(color 50 255 255)  style:#( #style_minimizebox)
					
  )
		
		
		
		
		
		
		
		
		path=GetFilenamePath (GetSourceFileName())+"img/250.jpg"
		wb.url = dotNetObject "System.Uri" path
	
	)
  
  on leiList1 selected i do (
	  
	global  fPath = GetFilenamePath (GetSourceFileName())
	  global db="driver={Microsoft Access Driver (*.mdb, *.accdb)}; DBQ="+fPath+"anim.mdb"
	  
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
	
  
  
  
  
  
  
  
  
  
  
  on leiList3 selected i do (
	 --case leiList.selection of
	-- (
	--	 1: aniList.items= manani
		--  2: aniList.items= huani
	--	3: aniList.items= dogani
		--  4: aniList.items= maani
		-- default:  messagebox "错误" 
		-- )
	 
	 -- )
	  DogConn1 = createOLEObject "ADODB.Connection"
DogConn1.Open db
recordSet1 = createOLEObject "ADODB.Recordset"
	global selectlist1=leiList1.selected
	  global selectlist2=leiList2.selected
	  global selectlist3=leiList3.selected
	  recordSet1.Open ("SELECT mingzi,dizhi from wenjian where fenlei1='"+selectlist1+"' and fenlei2='"+selectlist2+"' and fenlei3='"+selectlist3+"'") DogConn1
b = recordSet1.GetRows()
	  
	  c=b.dataArray
	  MyArray = #()--creates an empty array
for i=1 to c.count do(
	d=c[i]



 append MyArray (d[1])
	
)
	  leiList4.items =MyArray
	  --format "You selected %\n" b.dataArray[1]--and do something inside

	 aniurl = c[1][2]
	  format "----------------------------%\n" aniurl

  )

---创建bip

on newbip changed state do(
	if state == on then (
 global bipObja = biped.createNew 20 20 [0,0,20]
select bipObja
 bip2 = bipObja.controller
 
-- Display properties
--biped.displayPrefsDlg bip2)


	)
-----删除bip

else (delete  bipObja))

---创建bip结束

--预览动画
on leiList4 selected i do (
	
	---加载地址
	selectlistnam=leiList4.selected
	
	
mov=fPath+"img/"+selectlist2+"_"+selectlistnam+".gif"
	 format "----------------------------%\n"mov

wb.url = dotNetObject "System.Uri" mov
	
	


	
	
	
	
	
	
	
	
	
	
	
	DogConn2 = createOLEObject "ADODB.Connection"
DogConn2.Open db
recordSet2 = createOLEObject "ADODB.Recordset"
	
	  recordSet2.Open ("SELECT dizhi from wenjian where fenlei1='"+selectlist1+"' and fenlei2='"+selectlist2+"' and fenlei3='"+selectlist3+"' and mingzi='"+selectlistnam+"'") DogConn2
k= recordSet2.GetRows()
	  l=k.dataArray
	
	global m=l[1][1]

	format "You selected %\n"m
	---加载地址结束
	
	if newbip.checked==true  then(
	select bipObja
	bip3 = bipObja.controller
	biped.LoadBipFile bip3 (m) #matchFileStruct  
	)

	
	)
	--结束预览


fn ddl_someList_Selected itm =--we pass the argument passed to the handler
  (
    format "You selected %\n" itm--and do something inside
  )

--messagebox
  
 
  --on btn_select2 pressed do leiList_Selected (aniList.selection = 2)

	  
	  on jiazai pressed do ( 
		 
if classof $==Biped_Object do
(		  
bip1 = $.controller   
max motion mode   
--File I/O 
	if filestruc.triState==1 then(
	
biped.LoadBipFile bip1 ( m) #matchFileStruct  )

else if filestruc.triState==0 then (
biped.LoadBipFile bip1 ( m))
	
	)
)
	  
	  
	  )
	  

	  
createDialog testddl_rollout 400 250