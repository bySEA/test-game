-----------------------------------------------------------------------------------------
--
-- leveltwo.lua
--
-----------------------------------------------------------------------------------------
-- 
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

require( "MyGameFuncs" )
local widget = require "widget"

local gameState, touchedImage, background, rect, menubtn, restartbth, matr

-----------------------------------------------------------------------------------------
-- 
local function GoToMenu (event)
	storyboard.gotoScene( true, "menu", "slideDown", 800 )
end 

local function RelaunchScene (event)
	storyboard.purgeScene( "leveltwo" )
	storyboard.reloadScene( "leveltwo" )
end 


local function GetRandomColRow()
	local col, row
	repeat 
		col, row = math.random ( 5 ), math.random ( 5 )
	until matr[col][row].type == "empty"
	return col, row
end

local function ImageChips( fileName, namegroup, group)
	local  chips = getImage( fileName, matr, touchedImage, group, gameState )

	col, row = GetRandomColRow()
	chips.col, chips.row = col, row

	chips.x, chips.y = (col+0.5)*side_square, (row+0.5)*side_square
	matr[col][row].type = namegroup

	return( chips )
end

-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------

function scene:createScene( event )
	local group = self.view

	gameState = { value = "free" }
	touchedImage = nil

-- гыгы //
	rect = display.newRoundedRect( 3.5 * side_square, 3.5 * side_square, side_square*5*1.02, side_square*5*1.02, 10.5*side_square )
	rect.strokeWidth = 5
	rect:setStrokeColor( 61/255, 43/255, 31/255 )
	rect:toBack( )
	
	menubtn = widget.newButton {
		width =  display.contentWidth*0.4,
	    height = display.contentWidth*0.1,
	    defaultFile = "menu_1.png",
	    overFile = "menu_2.png",
		onRelease = GoToMenu
	}
	menubtn.x = display.contentWidth*0.75; menubtn.y = display.contentHeight*0.95


	restartbth = widget.newButton {
		width =  display.contentWidth*0.4,
	    height = display.contentWidth*0.1,
	    defaultFile = "to re-start_1.png",
	    overFile = "to re-start_2.png",
		onRelease = RelaunchScene
	}
	restartbth.x = display.contentWidth*0.25; restartbth.y = display.contentHeight*0.95
	
	matr = {}
	for i=1, 5 do
		table.insert( matr, {} )
		for j=1, 5 do
			table.insert( matr[i], {} )
			matr[i][j].type = "empty"
		end
	end


	group:insert( rect )

	group:insert( Walls( 2, 1, matr ) )
	group:insert( Walls( 4, 1, matr ) )
	group:insert( Walls( 2, 3, matr ) )
	group:insert( Walls( 2, 5, matr ) )
	group:insert( Walls( 4, 3, matr ) )
	group:insert( Walls( 4, 5, matr ) )

	for i = 1, 5 do
		group:insert( ImageChips( "white_cat.png",  "white_cat", group  ) )
		group:insert( ImageChips( "gray_cat.png",  "gray_cat", group  ) )
		group:insert( ImageChips( "ginger_cat.png",  "ginger_cat", group  ) )
	end

	AddText( group ) 

	group:insert( restartbth )
	group:insert( menubtn )

end

-----------------------------------------------------------------------------------------

function scene:enterScene( event )
	local group = self.view
end

function scene:exitScene( event )
	local group = self.view
	
	storyboard.purgeScene( "leveltwo" )
end

function scene:destroyScene( event )
	local group = self.view

	if menubtn then
		menubtn:removeSelf()	
		menubtn = nil
	end

	if restartbth then
		restartbth:removeSelf()	
		restartbth = nil
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