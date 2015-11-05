# ---------------------------------------------------------- #
# EXAMPLE 1
# ---------------------------------------------------------- #
#
# BAD
addPoints: ->
  pts = []
  for i in [0...100]
    pts.push @getRandomPointFromRect new Rectangle(0, i * 20, 20, 20)

# GOOD
addPoints: ->
  pts = []
  # Don't create new objects when you don't have to.
  rect = new Rectangle(0, 0, 20, 20)
  for i in [0...100]
    rect.y = i * 20 # or use can use Rectangle.initialize()
    pts.push @getRandomPointFromRect rect


# ---------------------------------------------------------- #
# EXAMPLE 2
# ---------------------------------------------------------- #
#
# BAD
addParticles: ->
  for i in [0...100]
    s = ShapeUtil.makeCircle(20)
    @cnt.addChild s
    @tweenMax.to s, 10, {x: "+=100", alpha:0, delay: i*.1}

# GOOD
addParticles: ->
  # Don't draw the same shape 100 times!
  # Just draw it once and reference the cache canvas.
  s = ShapeUtil.makeCircle(20)
  s.cache(0, 0, 20, 20)
  for i in [0...100]
    @cnt.addChild new Bitmap(s.cacheCanvas)
    @tweenMax.to s, 10, {x: "+=100", alpha:0, delay: i*.1}

# ---------------------------------------------------------- #
# EXAMPLE 3
# ---------------------------------------------------------- #
#
# BAD
playSounds: ->
  for i in [0...100]
    @delayedCall i * .2, ->
      @playSound 'bang'

# GOOD
playSounds: ->
  # @playSound creates a new sound object
  # Reuse sound objects where possible
  for i in [0...100]
    @delayedCall i*.2, ->
      @pool.remove('bang').play()


# ---------------------------------------------------------- #
# EXAMPLE 4
# ---------------------------------------------------------- #
#
# BAD
doSomething: ->
  # add a rect to the container
  rect = new Rectangle(0, 0, 200, 200)
  shape = @cnt.addChild makeShapeFromRect(rect)
  # add a score to the shape
  rect = 10
  shape.score = rect
  # add a type array
  rect = ["type1", "type2", "type3"]
  @typeArray = rect

# GOOD
doSomething: ->
  # Mutable data structures are BAD
  # Immutable data structures are GOOD (typescript)
  # Find the hidden bad part of this 'good' code.
  # add a rect to the container
  rect = new Rectangle(0, 0, 200, 200)
  shape = @cnt.addChild @makeShapeFromRect(rect)
  # add a score to the shape
  shape.score = 10
  # add a type array
  @typeArray = ["type1", "type2", "type3"]

# ---------------------------------------------------------- #
# EXAMPLE 5
# ---------------------------------------------------------- #
#
# BAD
class NewClass extends Actor

  someProp: []

  added: ->
    @someProp.push(1, 2)

  removed: ->
    @someProp = []


# GOOD
class NewClass extends Actor

  added: ->
    @someProp = [1, 2]

  removed: ->
    @someProp = []


# ---------------------------------------------------------- #
# EXAMPLE 6
# ---------------------------------------------------------- #
#
# BAD
addFrames: ->
  ss = @spriteSheet 'flowers'
  for i in [0...100]
    shape = ss.bitmapFromFrame 'flower-1'
    shape.x = i * 10
    shape.y = 100
    @cnt.addChild shape

# GOOD
addFrames: ->
  # SpriteSheetFrameBitmap creates a new cacheCanvas
  # Reuse the cacheCanvas where possible.
  ss = @spriteSheet 'flowers'
  cacheCanvas = ss.bitmapFromFrame('flower-1', true).cacheCanvas
  for i in [0...100]
    shape = new Bitmap(cacheCanvas)
    shape.x = i*10
    shape.y = 100
    @cnt.addChild shape




