rollout k帧动画工具 "批量设置封套2022.1.26" width:162 height:100
(
button GetID "获取BoneID" pos:[50,00] width:80 height:30
spinner StartEnvelope "起始骨骼ID" pos:[20,40] width:148 height:16 range:[0,100000,1] type:#integer
spinner EndEnvelopeSize1 "结束骨骼ID" pos:[20,60] width:148 height:16 range:[0,100000,10] type:#integer
------------
spinner OuterEnvelopeSize "外部封套大小" pos:[20,80] width:148 height:16 range:[0,100000,5] type:#float
spinner InnerEnvelopeSize "内部封套大小" pos:[20,100] width:148 height:16 range:[0,100000,3] type:#float
-------------------
button setok "设置" pos:[50,120] width:100 height:30
on GetID pressed do
(	
	try(
boneNames = skinOps.GetBoneName skinMod i 0
Print boneNames
MessageBox ID		
	   )--try
 	catch()
)--btn1

on setok pressed do
(	
	try(
		for i=StartEnvelope.value to EndEnvelopeSize1.value do(
skinOps.setOuterRadius $.modifiers[#Skin] i 2 OuterEnvelopeSize.value
skinOps.SelectCrossSection $.modifiers[#Skin] 1 1
$.modifiers[#Skin].cross_radius = InnerEnvelopeSize.value
skinOps.setOuterRadius $.modifiers[#Skin] i 1 OuterEnvelopeSize.value
skinOps.SelectCrossSection $.modifiers[#Skin] 1 0
$.modifiers[#Skin].cross_radius = InnerEnvelopeSize.value
skinOps.setInnerRadius $.modifiers[#Skin] i 1 InnerEnvelopeSize.value
skinOps.SelectCrossSection $.modifiers[#Skin] 2 0
$.modifiers[#Skin].cross_radius = InnerEnvelopeSize.value
skinOps.setInnerRadius $.modifiers[#Skin] i 2 InnerEnvelopeSize.value
		)
   )--try
 	catch()
)--btn1

)
-------------------------------------------------------------	
globalrollout = newrolloutfloater "批量设置封套" 200 200
addRollout k帧动画工具 globalrollout 
