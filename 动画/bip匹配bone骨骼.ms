rollout QS "Ò»¼übipÆ¥Åäbone" width:240 height:60
(	
	button QS "Ò»¼übipÆ¥Åäbone" pos:[10,10] width:220 height:40
on QS pressed do
(
   bipobj= #()
for i in $* do 
	(
		if Classof i == biped_object then append bipobj i		
	)	
		
	a=bipobj.count
	
for a = 3 to a do
(
		
	Ps= bipobj[a].transform.pos
    Pe= bipobj[a].children[1].transform.pos
    S= bipobj[a].transform.scale
    boneSys.createbone Ps Pe  S
)	
B = #()
for x in $* do
(
   if classof x == boneGeometry then append B x	
	
)
   s=B.count
for s = 1 to s do 
(
	b[s].name = bipobj[s+2].name
)

for s = 1 to s do
(
	if b[s].name == "Bip001 R Foot" then (continue)
    if b[s].name == "Bip001 L Foot" then (continue)
    if b[s].name == bipobj[s+2].name then 
		b[s].transform = bipobj[s+2].transform
		b[s].parent = bipobj[s+2]

 )
 for s = 1 to s do
 (
	if b[s].name == "Bip001 R Foot" then (b[s].rotation.x_rotation = 90;b[s].name="Bip001 R Foot G";b[s].parent=$Bip001_R_Foot )
    if b[s].name == "Bip001 L Foot" then (b[s].rotation.x_rotation = 90;b[s].name="Bip001 L Foot G";b[s].parent=$Bip001_L_Foot )
 )
   bone1=#()
for i in $* do
(
	if CLassof i == Dummy then (continue) else 
	if i.name == "Bip001 Footsteps" then (continue) else 
  if i.name == "Bip001 Neck" then append bone1 i
  )
  n = bone1.count
for i = 1 to n do
(
	if Classof bone1[i] == boneGeometry then (delete bone1[i])
)
    select $Bip001_Neck
(
	if $Bip001_Neck.children[1].name == "Bip001 Neck1" then 
	(
	nek= $Bip001_Neck.transform.pos	
	head1= $Bip001_Neck1.transform.pos
	SC= $Bip001_Neck.transform.scale
	neck_bone = bonesys.createBone nek head1 SC
	neck_bone.name = "Bip001 Neck"
	neck_bone.transform = $Bip001_Neck.transform
    neck_bone.parent = 	$Bip001_Neck
		
		)
	else
(
	if $Bip001_Neck.children[1].name == "Bip001 Head" then (continue)	 
	if $Bip001_Neck.children[1].name != "Bip001 Head" then	 
		
	
	nek= $Bip001_Neck.transform.pos	
	head1= $Bip001_Head.transform.pos
	SC= $Bip001_Neck.transform.scale
	neck_bone = bonesys.createBone nek head1 SC
	neck_bone.name = "Bip001 Neck G"
	neck_bone.transform = $Bip001_Neck.transform
    neck_bone.parent = 	$Bip001_Neck	
)
)
select $Bip001_R_Foot
(

    if $Bip001_R_Foot.children.count > 2 then 
	(
		delete $Bip001_R_Foot_G
	nek= $Bip001_R_Foot.transform.pos	
	head1= $Bip001_R_Toe2.transform.pos
	SC= $Bip001_R_Toe2.transform.scale
	neck_bone = bonesys.createBone nek head1 SC
	neck_bone.name = "Bip001 R Foot F"
    neck_bone.parent = 	$Bip001_R_Foot
	neck_bone.rotation.x_rotation = 90
	)
)
select $Bip001_L_Foot
(	

	if $Bip001_L_Foot.children.count > 2 then 
	(
		delete $Bip001_L_Foot_G
	nek= $Bip001_L_Foot.transform.pos	
	head1= $Bip001_L_Toe2.transform.pos
	SC= $Bip001_L_Toe2.transform.scale
	neck_bone = bonesys.createBone nek head1 SC
	neck_bone.name = "Bip001 L Foot F"
    neck_bone.parent = 	$Bip001_L_Foot
	neck_bone.rotation.x_rotation = 90
	)
)
clearSelection()

)
)
Createdialog QS