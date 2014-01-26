-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------
-- 
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local widget = require "widget"

local background, levelone, leveltwo, titleLogo
-- 
-----------------------------------------------------------------------------------------
-- 
local function GoToScene1 (event)
	storyboard.gotoScene( "levelone", {effect = "slideLeft", time = 800} )
end 

local function GoToScene2 (event)
	storyboard.gotoScene( "leveltwo", {effect = "slideUp", time = 800} )
end
-- 
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------

function scene:createScene( event )
	local group = self.view


	background = display.newRect( display.contentWidth/2, display.contentHeight/2, display.contentWidth, display.contentHeight )
	background:setFillColor(1, 1, 1)
	background:toBack( )

	titleLogo = display.newImageRect( "logo.png", display.contentWidth, display.contentWidth*0.65  )
	titleLogo.x = display.contentWidth * 0.5
	titleLogo.y = display.contentHeight * 0.2

	levelone = widget.newButton {
		width =  display.contentWidth*0.5,
	    height = display.contentWidth*0.1,
	    defaultFile = "levelone_1.png",
	    overFile = "levelone_2.png",
		onRelease = GoToScene1
	}
	levelone.x = display.contentCenterX; levelone.y = display.contentHeight*0.7
    
	leveltwo = widget.newButton{
		width =  display.contentWidth*0.5,
	    height = display.contentWidth*0.1,
	    defaultFile = "leveltwo_1.png",
	    overFile = "leveltwo_2.png",
		onRelease = GoToScene2
	}
	leveltwo.x = display.contentCenterX; leveltwo.y = display.contentHeight*0.8

    group:insert( background )
	group:insert( titleLogo )
	group:insert( levelone )
	group:insert( leveltwo )

end

-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------

function scene:enterScene( event )
	local group = self.view	
end
-- 
-- 
function scene:exitScene( event )
	local group = self.view
end
-- 
-- 
function scene:destroyScene( event )
	local group = self.view
	
	if levelone then
		levelone:removeSelf()	
		levelone = nil
	end

	if leveltwo then
		leveltwo:removeSelf()	
		leveltwo = nil
	end
end

-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- 
scene:addEventListener( "createScene", scene )
-- 
scene:addEventListener( "enterScene", scene )
-- 
scene:addEventListener( "exitScene", scene )
-- 
scene:addEventListener( "destroyScene", scene )
-- 
-----------------------------------------------------------------------------------------
return scene