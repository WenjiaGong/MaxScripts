rollout unnamedRollout "��������" width:160 height:88
(
	button btn1 "����" pos:[8,8] width:144 height:32
	button btn2 "����" pos:[8,48] width:144 height:32
	on btn1 pressed  do
		SetTransformLockFlags selection #All
	on btn2 pressed  do
		SetTransformLockFlags selection #None
)
createDialog unnamedRollout