background = new Layer
	width: 750
	height: 1334
	backgroundColor: "#eee"

no_more = new Layer
	width: 226
	height: 250
	opacity: 0
	image: "images/no more.png"
	x: Align.center
	y: 333
	
load_more = new Layer
	height: 69
	image: "images/load more.png"
	x: Align.center
	y: 700
	opacity: 0
	borderWidth: 1
	borderColor: '#296194'
	borderRadius: 2
	width: 200

scroll = new ScrollComponent
	y: 100
	width: Screen.width, 
	height: (Screen.height) - 202
	
	scrollHorizontal: false
	contentInset: {top:32, bottom:32}

topBar = new Layer
	width: 640
	height: 100
	backgroundColor: "#E8484E"
	shadowY: 2
	shadowSpread: 1
	shadowColor: "rgba(113,113,113,0.2)"

ballot_logo_3x = new Layer
	width: 60
	height: 60
	image: "images/ballot logo@3x.png"
	x: Align.center
	y: 20

tabBar = new Layer
	y: 1036
	width: 640
	height: 100
	backgroundColor: "rgba(255,255,255,1)"
	shadowSpread: 1
	shadowColor: "rgba(123,123,123,0.1)"
	shadowY: -2
	shadowBlur: 4

home_selected = new Layer
	width: 50
	height: 50
	image: "images/home_selected.png"
	y: 1056
	x: 37

profile = new Layer
	width: 50
	height: 54
	image: "images/profile.png"
	y: 1056
	x: 556

search = new Layer
	width: 50
	height: 50
	image: "images/search.png"
	y: 1056
	x: Align.center

scroll.content.draggable.bounceOptions = 
	friction: 40, tension: 300, tolerance: 1

# Define Scroll Content
height = 400
margin = 60

# Array that will store our layers
allLayers = []

# Generate a set of layers
for i in [0...5]
	layer = new Layer 
		backgroundColor: "#fff"
		borderRadius: 8
		image: "images/card.png"
		opacity: 1
		width: scroll.width - 48
		height: 440,
		x: 24
		y: (height + margin) * i
		superLayer: scroll.content
		
	layer.style = "font-size":"48px", "font-weight":"300", "color":"#333", "lineHeight":"#{height}px", "box-shadow":"0 3px 6px rgba(0,0,0,0.1)"
	
	allLayers.push(layer)

# Set directionLock and threshold
scroll.content.draggable.directionLock = true
scroll.content.draggable.directionLockThreshold = {x:25, y:25}

# Determine horizontal dragging based on direction
scroll.content.draggable.on Events.DirectionLockDidStart, (event) ->
	for layer in allLayers
		if event.x then layer.draggable.enabled = false
		if event.y then layer.draggable.enabled = true
			
counter = 0
# Define dragging properties & events for all layers
for layer in allLayers	
	layer.draggable.vertical = false
	remove = endAnimation = false
	directionFactor = 1
		
	layer.on Events.DragMove, ->
		if Math.abs(this.x) > 300 or Math.abs(this.draggable.velocity.x) > 3
			remove = true
			if this.draggable.direction is "left" then directionFactor = -1
			if this.draggable.direction is "right" then directionFactor = 1
			
	layer.on Events.DragEnd, (event) ->	
		# Detect if we're at the bottom of the page
		bottomOfPage = scroll.scrollY > (scroll.content.height - Screen.height)
		endAnimation = if bottomOfPage then true else false
		
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
				
			if counter == (allLayers.length-1)
				no_more.animate
					properties:
						opacity: 1
				load_more.animate
					properties:
						opacity: 1
				
			# Reset the remove variable
			counter = counter + 1
			return remove = false
			
			
		
		# If we haven't dragged far enough, snap back
		else
			this.animate 
				properties: {x: 24}
				curve: "spring(200,40,0)"

backgroundA = new BackgroundLayer
	backgroundColor: "rgba(234,234,234,1)"
