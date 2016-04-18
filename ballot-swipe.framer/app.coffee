layerB = new Layer
	width: 750
	height: 1334
	backgroundColor: "rgba(234,70,74,1)"
	
no_more = new Layer
	width: 326
	height: 383
	image: "images/no more.png"
	x: 212
	y: 379

ballot_logo_3x = new Layer
	width: 116
	height: 117
	image: "images/ballot logo@3x.png"
	x: 317
	y: 26

layerC = new Layer
	y: 1209
	width: 750
	height: 125
	backgroundColor: "rgba(255,255,255,1)"

home_selected = new Layer
	width: 60
	height: 60
	image: "images/home_selected.png"
	y: 1242
	x: 37

profile = new Layer
	width: 60
	height: 66
	image: "images/profile.png"
	y: 1242
	x: 653

search = new Layer
	width: 60
	height: 60
	image: "images/search.png"
	y: 1242
	x: 345

Due_ProcessB = new Layer
	width: 752
	height: 951
	image: "images/Due Process.png"
	y: 190

MedicareB = new Layer
	width: 752
	height: 951
	image: "images/Medicare.png"
	y: 210


layers = [MedicareB, Due_ProcessB]

for layer in layers
	layer.draggable.vertical = false
	remove = endAnimation = false
	directionFactor = 1
		
	layer.on Events.DragMove, -> 	
		if Math.abs(this.x) > 350 or Math.abs(this.draggable.velocity.x) > 3
			remove = true
			if this.draggable.direction is "left" then directionFactor = -1
			if this.draggable.direction is "right" then directionFactor = 1
			
	layer.on Events.DragEnd, (event) ->	
		# If we've dragged far enough, remove the layer
		if remove is true
			# Animate & Destroy the layer
			this.animate 
				properties: {x: Screen.width * directionFactor}
				time: 0.2
			
			Utils.delay 0.2, => this.destroy()
					
			for layer in allLayers	
				# If we're removing one of the last layers
				if endAnimation
					Utils.delay 0.2, ->
						scroll.scrollToPoint
							x: 0, y: scroll.scrollY - height - margin*2, true, 
							curve: "spring"	
							curveOptions: {tension:400, friction:30, tolerance:0.01}
							
						scroll.content.once Events.AnimationEnd, ->
							scrollY = scroll.scrollY
							scroll.updateContent()
							scroll.scrollY = scrollY
					
				# Update the position of other layers
				if layer.index > this.index
					layer.animate 
						properties: {y: layer.y - height - margin}
						curve: "spring"
						curveOptions: {tension:400, friction:30, tolerance:0.01}
						delay: 0.2
					
					unless endAnimation
						layer.once Events.AnimationEnd, =>
							scrollY = scroll.scrollY
							scroll.updateContent()
							scroll.scrollY = scrollY
					
			# Reset the remove variable
			return remove = false
			
		# If we haven't dragged far enough, snap back
		else
			this.animate 
				properties: {x: Align.center}
				curve: "spring(200,40,0)"
	
	
