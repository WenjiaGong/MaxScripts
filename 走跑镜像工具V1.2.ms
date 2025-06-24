fn qz = 
(
	bip = selection[1].transform.controller
	v = bip.vertical.controller
	h = bip.horizontal.controller
	r = bip.turning.controller
	hf = (animationrange.end - animationrange.start) / 2
	mid = animationrange.start + hf
	vt = #()
	ht = #()
	rt = #()
	start = animationrange.start
	end = animationrange.end
	end = start + ((end - start)/2 - 1f)
	for i= 1 to 10000 do
	(
		
		k = biped.getkey v i
		if k.time >= start and k.time <= end then
		(
			append vt k.time
		)
		else
		(
			if k.time > end do
			exit
		)
	)
	for i= 1 to 10000 do
	(
		
		k = biped.getkey h i
		if k.time >= start and k.time <= end then
		(
			append ht k.time
		)
		else
		(
			if k.time > end do
			exit
		)
	)
	for i= 1 to 10000 do
	(
		
		k = biped.getkey r i
		if k.time >= start and k.time <= end then
		(
			append rt k.time
		)
		else
		(	
			if k.time > end do
			exit
		)
	)
	zxt = #()
	if vt.count != 0 do
	(		
		for i = 1 to vt.count do
		(
			append zxt vt[i]
		)
	)
	if ht.count != 0 do
	(
		for i = 1 to ht.count do
		(
			append zxt ht[i]
		)
	)
	if rt.count != 0 do
	(
		for i = 1 to rt.count do
		(
			append zxt rt[i]
		)
	)
	xb = 1 
	tc = #()
	for i = start to end do
	(
		for j = 1 to zxt.count do
		(
			if i == zxt[j] do
			(
				tc[xb] = zxt[j]
				xb = xb + 1
				exit
			)
		)
	)
	qzs = #()
	w = 1 
	tcc = tc.count 
	for i = 2 to tcc by 1 do
	(
		qzs[w] = tc[i] + hf
		w = w + 1
	)
	for i = 1 to qzs.count do
	(
		slidertime = qzs[i]
		sfqv = true
		for j = 1 to vt.count do
		(
			if vt[j] + hf == qzs[i] do sfqv = false
		)
		if sfqv do 
		(
			dex = getkeyindex v qzs[i]
			deletekey v dex
		)
		sfqh = true
		for j = 1 to ht.count do
		(
			if ht[j] + hf == qzs[i] do sfqh = false
		)
		if sfqh do 
		(
			dex = getkeyindex h qzs[i]
			deletekey h dex
		)
		sfqr = true
		for j = 1 to rt.count do
		(
			if rt[j] + hf == qzs[i] do sfqr = false
		)
		if sfqr do 
		(
			dex = getkeyindex r qzs[i]
			deletekey r dex
		)
	)	
)

fn getzxnitime = 
(
	bip = selection[1].transform.controller
	v = bip.vertical.controller
	h = bip.horizontal.controller
	r = bip.turning.controller
	vt = #()
	ht = #()
	rt = #()
	zxt = #()
	start = animationrange.start
	end = animationrange.end
	end = start + ((end - start)/2 - 1f)
	for i= 1 to 10000 do
	(
		try(biped.getkey v i)catch(exit)
		k = biped.getkey v i
		if k.time >= start and k.time <= end then
		(
			append vt k.time
		)
		else
		(
			if k.time > end do
			exit
		)
	)
	for i= 1 to 10000 do
	(
		try(biped.getkey h i)catch(exit)
		k = biped.getkey h i
		if k.time >= start and k.time <= end then
		(
			append ht k.time
		)
		else
		(
			if k.time > end do
			exit
		)
	)
	for i= 1 to 10000 do
	(
		try(biped.getkey r i)catch(exit)
		k = biped.getkey r i
		if k.time >= start and k.time <= end then
		(
			append rt k.time
		)
		else
		(
			if k.time > end do
			exit
		)
	)
	zzt = vt.count + ht.count + rt.count
	if zzt == 0 then 
	(
		str = execute "bit.intaschar 36136 + bit.intaschar 24515 + bit.intaschar 22312 + bit.intaschar 21069 + bit.intaschar 21322 + bit.intaschar 27573 + bit.intaschar 26102 + bit.intaschar 38388 + bit.intaschar 26465 + bit.intaschar 24517 + bit.intaschar 39035 + bit.intaschar 26377 + bit.intaschar 24103 + bit.intaschar 12290"
		messagebox str
		return undefined
	)
	else
	(
		j = 1 
		if vt.count != 0 do
		(		
			for i = 1 to vt.count do
			(
				append zxt vt[i]
			)
		)
		if ht.count != 0 do
		(
			for i = 1 to ht.count do
			(
				append zxt ht[i]
			)
		)
		if rt.count != 0 do
		(
			for i = 1 to rt.count do
			(
				append zxt rt[i]
			)
		)
		xb = 1 
		tc = #()
		for i = start to end do
		(
			for j = 1 to zxt.count do
			(
				if i == zxt[j] do
				(
					tc[xb] = zxt[j]
					xb = xb + 1
					exit
				)
			)
		)
		return tc
	)
)

fn getjointanitime = 
(
	times = #()
	if selection.count > 0 then 
	(
		if classof selection[1] == Biped_Object then
		(
			c = selection[1].controller
			for i = 1 to 10000 do
			(
				k = undefined 
				try(m = biped.getkey c i)catch(exit)
				k = biped.getkey c i
				if k != undefined do
				(
					if k.time >= animationrange.start and k.time <= animationrange.end do
					(
						append times k.time
					)
					continue
				)
				if k == undefined do
				(
					exit
					return times
				)
			)
			return times
		)
		else
		(
			return undefined 
		)
	)
	else 
	(
		return undefined
	)
)
fn pstop = 
(
	animbuttonenabled = true
	animbuttonstate = true
	objcontroller = selection[1].controller
	biped.deleteAllCopyCollections objcontroller
	temp = biped.createCopyCollection selection[1].controller "temp"
	posecollection = biped.getCopyCollection selection[1].controller 1
	obj = #()
	for i = 1 to selection.count do
	(
		if classof selection[i] == biped_object do
		(
			append obj selection[i]
		)
	)
	posture = biped.copyBipPosture objcontroller posecollection obj #snapAuto
	biped.pasteBipPosture objcontroller posture true #pstdefault false false false false 
	biped.deleteAllCopyCollections objcontroller
)
fn szx = 
(
	
	if selection[1].name == selection[1].controller.rootname then
	(
		return true
	)
	else
	(
		return false
	)
)

try(destroydialog WAR )catch()
rollout WAR "" width:122 height:114
(
	
	button 'btn1' "Button" pos:[9,7] width:103 height:26 align:#left
	button 'btn2' "Button" pos:[9,43] width:103 height:26 align:#left
	button 'btn3' "Button" pos:[9,78] width:103 height:26 align:#left
	--label  'maker' ""      pos:[47,116] width:103 height:26 align:#left
	ON WAR OPEN DO
	(
		
		btn1.caption = execute "bit.intaschar 38236 + bit.intaschar 20687 + bit.intaschar 36136 + bit.intaschar 24515"
		btn2.caption = execute "bit.intaschar 38236 + bit.intaschar 20687 + bit.intaschar 22836 + bit.intaschar 36523"
		btn3.caption = execute "bit.intaschar 38236 + bit.intaschar 20687 + bit.intaschar 22235 + bit.intaschar 32930"
		--maker.caption = execute "bit.intaschar 20316 + bit.intaschar 32773 + bit.intaschar 65306 + bit.intaschar 39068+ bit.intaschar 20426 + bit.intaschar 36745"
		WAR.title = execute "bit.intaschar 36208 + bit.intaschar 36305 + bit.intaschar 21046 + bit.intaschar 20316 + bit.intaschar 24037 + bit.intaschar 20855"
		
		
	)
	on btn1 pressed  do
	(
		--undo on
		(
			animbuttonenabled = true
			animbuttonstate = true
			if selection.count == 0 do 
			(
				str = execute "bit.intaschar 38656 + bit.intaschar 35201 + bit.intaschar 20808 + bit.intaschar 36873 + bit.intaschar 25321 + bit.intaschar 36136 + bit.intaschar 24515 + bit.intaschar 12290"
				messagebox str
			)
			if selection.count > 1 do
			(
				str = execute "bit.intaschar 21482 + bit.intaschar 33021 + bit.intaschar 36873 + bit.intaschar 25321 + bit.intaschar 36136 + bit.intaschar 24515 + bit.intaschar 12290"
				messagebox str
			)
			if selection.count == 1 do
			(
				pdzx = szx()
				if pdzx == false then
				(
					str = execute "bit.intaschar 38656 + bit.intaschar 35201 + bit.intaschar 20808 + bit.intaschar 36873 + bit.intaschar 25321 + bit.intaschar 36136 + bit.intaschar 24515 + bit.intaschar 12290"
					messagebox str
				)
				else
				(
					zxt = getzxnitime()
					hf = (animationrange.end - animationrange.start)/2
					if zxt.count > 0 do 
					(
						for i = 1 to zxt.count do
						(
							slidertime = zxt[i]
							tt = selection[1].transform 
							mtt = copy tt
							a = mtt.row4
							a[1] = a[1] * -1
							mtt.row4 = a
							a = mtt.row1;a[1] = a[1] * -1; mtt.row1 = a
							a = mtt.row2;a[2] = a[2] * -1; a[3] = a[3] * -1; mtt.row2 = a
							a = mtt.row3;a[1] = a[1] * -1; mtt.row3 = a
							slidertime = zxt[i] + hf
							selection[1].transform = mtt
						)
						slidertime = animationrange.start
						tt = selection[1].transform
						slidertime = animationrange.end
						selection[1].transform = tt
						qz()
					)
				)
			)
			
			
			
		)
	)
	on btn2 pressed  do
	(
		--undo on
		(
			animbuttonenabled = true
			animbuttonstate = true
			len = animationrange.end - animationrange.start
			jlen = (len as Integer) / 160
			m = mod jlen 2
			if m == 0 then 
			(
				hf = (animationrange.end - animationrange.start) / 2
				mid = hf + animationrange.start
				mid = ((mid as integer) / 160)
				biped.addnewkey selection[1].controller (animationrange.start as integer / 160)
				biped.addnewkey selection[1].controller mid
				objtime = getjointanitime()
				for i in objtime do
				(
					if i <= mid then
					(
						slidertime = i
						objcontroller = selection[1].controller
						biped.deleteAllCopyCollections objcontroller
						temp = biped.createCopyCollection selection[1].controller "temp"
						posecollection = biped.getCopyCollection selection[1].controller 1
						obj = #()
						for i = 1 to selection.count do
						(
							if classof selection[i] == biped_object do
							(
								append obj selection[i]
							)
						)
						posture = biped.copyBipPosture objcontroller posecollection obj #snapAuto
						slidertime = i + hf
						biped.pasteBipPosture objcontroller posture true #pstdefault false false false false 
						biped.deleteAllCopyCollections objcontroller
					)
					else exit
				)
			)
			else
			(
				str = execute "bit.intaschar 35831 + bit.intaschar 23558 + bit.intaschar 26102 + bit.intaschar 38388 + bit.intaschar 26465 + bit.intaschar 35774 + bit.intaschar 32622 + bit.intaschar 25104 + bit.intaschar 20598 + bit.intaschar 25968 + bit.intaschar 12290"
				messagebox str
			)	
		)
	)
	on btn3 pressed  do
	(
		--undo on
		(
			animbuttonenabled = true
			animbuttonstate = true
			len = animationrange.end - animationrange.start
			jlen = (len as Integer) / 160
			m = mod jlen 2
			if m == 0 then 
			(
				biped.addnewkey selection[1].controller (animationrange.start as integer / 160)
				biped.addnewkey selection[1].controller (animationrange.end as integer / 160)
				objtime = getjointanitime()
				hf = (animationrange.end - animationrange.start) / 2
				mid = hf + animationrange.start
				
				for i in objtime do
				(
					slidertime = i
					if i < mid do
					(
						objcontroller = selection[1].controller
						biped.deleteAllCopyCollections objcontroller
						temp = biped.createCopyCollection selection[1].controller "temp"
						posecollection = biped.getCopyCollection selection[1].controller 1
						obj = #()
						for i = 1 to selection.count do
						(
							if classof selection[i] == biped_object do
							(
								append obj selection[i]
							)
						)
						posture = biped.copyBipPosture objcontroller posecollection obj #snapAuto
						slidertime = i + hf
						biped.pasteBipPosture objcontroller posture true #pstdefault false false false false 
						biped.deleteAllCopyCollections objcontroller
					)
					if i == mid do
					(
						objcontroller = selection[1].controller
						biped.deleteAllCopyCollections objcontroller
						temp = biped.createCopyCollection selection[1].controller "temp"
						posecollection = biped.getCopyCollection selection[1].controller 1
						obj = #()
						for i = 1 to selection.count do
						(
							if classof selection[i] == biped_object do
							(
								append obj selection[i]
							)
						)
						posture = biped.copyBipPosture objcontroller posecollection obj #snapAuto
						slidertime = animationrange.start
						biped.pasteBipPosture objcontroller posture true #pstdefault false false false false 
						slidertime = animationrange.end
						biped.pasteBipPosture objcontroller posture true #pstdefault false false false false 
						biped.deleteAllCopyCollections objcontroller
					)
					if i > mid do
					(
						objcontroller = selection[1].controller
						biped.deleteAllCopyCollections objcontroller
						temp = biped.createCopyCollection selection[1].controller "temp"
						posecollection = biped.getCopyCollection selection[1].controller 1
						obj = #()
						for i = 1 to selection.count do
						(
							if classof selection[i] == biped_object do
							(
								append obj selection[i]
							)
						)
						posture = biped.copyBipPosture objcontroller posecollection obj #snapAuto 
						slidertime = i - hf
						biped.pasteBipPosture objcontroller posture true #pstdefault false false false false 
						biped.deleteAllCopyCollections objcontroller
					)
				)
			)
			else
			(
				str = execute "bit.intaschar 35831 + bit.intaschar 23558 + bit.intaschar 26102 + bit.intaschar 38388 + bit.intaschar 26465 + bit.intaschar 35774 + bit.intaschar 32622 + bit.intaschar 25104 + bit.intaschar 20598 + bit.intaschar 25968 + bit.intaschar 12290"
				messagebox str
			)
		)
	)
)
createdialog WAR 122 114