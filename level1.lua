-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()



local side_square = display.contentWidth/7

local matr = {}
	for i=1, 5 do
		table.insert( matr, {} )
		for j=1, 5 do
			table.insert( matr[i], {} )
			matr[i][j].type = "empty"		
		end
	end


function Walls(n, m, _group)
	local wall = display.newImageRect( "wall.png", side_square*0.9, side_square*0.9)
	wall.x = (n+0.5)*side_square
	wall.y = (m+0.5)*side_square
	matr[n][m].type = "wall"

	_group:insert( wall )
end

function getXByCol(col)
	return (col + 0.5) * side_square;
end

function getYByRow(row)
	return (row + 0.5) * side_square;
end

function AreYouWinner()
	for j=1, 5 do
		if matr[1][j].type ~= "cat" then
			return
		end
		if matr[3][j].type ~= "water" then
			return
		end
		if matr[5][j].type ~= "rose" then
			return
		end
	end
	
	local timerid = timer.performWithDelay(650, function()
		local myText = display.newText( "You are Winner!", display.contentWidth/2, display.contentHeight-2.5*side_square, native.systemFont, 28 )
		myText:setFillColor( 49/255, 0, 98/255 )		
	end)
end

function getImage( fileName )
	local img = display.newImageRect( fileName,  side_square*0.9, side_square*0.9 )

	--добавление нажатия
	function img:touch(e) 
		if e.phase=="began" then 
			self.act = true
			self.oldX, self.oldY = e.x, e.y 
			return
		end
		if e.phase=="moved" then
			if (self.act == false) or (self.act == nil) then
				return
			end

			if (self.oldX-e.x)<0 then

				if  self.col < 5 then
					if matr[self.col+1][self.row].type=="empty" then
					   matr[self.col+1][self.row].type=matr[self.col][self.row].type
					   matr[self.col][self.row].type="empty"
					   self.col=self.col+1

					   self.act = false

					   local newX = getXByCol( self.col );
				       transition.moveTo( self, {x=newX, y=self.y, time = 500})
				       AreYouWinner()
				       return
				   	end
				end
			end

			if (self.oldX-e.x)>0 then

				if  self.col >1 then
					if matr[self.col-1][self.row].type=="empty" then
					   matr[self.col-1][self.row].type=matr[self.col][self.row].type
					   matr[self.col][self.row].type="empty"
					   self.col=self.col-1

					   self.act = false

					   local newX = getXByCol( self.col );
				       transition.moveTo( self, {x=newX, y=self.y, time = 500})
				       AreYouWinner()
				       return
				   	end
				end
			end

			if (self.oldY-e.y)>0 then

				if  self.row >1 then
					if matr[self.col][self.row-1].type=="empty" then
					   matr[self.col][self.row-1].type=matr[self.col][self.row].type
					   matr[self.col][self.row].type="empty"
					   self.row=self.row-1

					   self.act = false

					   local newY = getYByRow( self.row );
				       transition.moveTo( self, {x=self.x, y=newY, time = 500})
				       AreYouWinner()
				       return
				   	end
				end
			end

			if (self.oldY-e.y)<0 then

				if  self.row <5 then
					if matr[self.col][self.row+1].type=="empty" then
					   matr[self.col][self.row+1].type=matr[self.col][self.row].type
					   matr[self.col][self.row].type="empty"
					   self.row=self.row+1

					   self.act = false

					   local newY = getYByRow( self.row );
				       transition.moveTo( self, {x=self.x, y=newY, time = 500})
				       AreYouWinner()
				       return
				   	end
				end
			end

		end

		if e.phase=="ended" then
		    self.active = false
			return
		end
	end

	img:addEventListener("touch", img )

	return img
end

function blue(_group)
		for i=1, 5 do
			local  f = getImage( "f1.png" )
			f.x = (1+0.5)*side_square
			f.y = (i+0.5)*side_square
			matr[1][i].type = "water"
			f.col = 1
			f.row = i


			_group:insert( f )
		end
end

function green(_group)
		for i=1, 5 do
			local  f = getImage( "f2.png" )
			f.x = (3+0.5)*side_square
			f.y = (i+0.5)*side_square
			matr[3][i].type = "rose"
			f.col = 3
			f.row = i

			_group:insert( f )
		end
end

function yellow(_group)
		for i=1, 5 do
			local  f = getImage( "f3.png" )
			f.x = (5+0.5)*side_square
			f.y = (i+0.5)*side_square
			matr[5][i].type = "cat"
			f.col = 5
			f.row = i

			_group:insert( f )
		end
end


function gameInit( _group )

	local bg = display.newImageRect( "bg.png", side_square*5*1.1, side_square*5*1.1)
	bg.x = 3.5*side_square
	bg.y = 3.5*side_square
	bg:toBack( )

	local background = display.newRect( display.contentWidth/2, display.contentHeight/2, display.contentWidth, display.contentHeight )
    background:setFillColor(1, 288/255, 178/255)
    background:toBack( )

	local text_1 = display.newText("Cat", 1.5*side_square, 0.5*side_square, native.systemFont, 16 )
		text_1:setFillColor( 69/255, 77/255, 95/255)

	local text_2 = display.newText("Water", 3.5*side_square, 0.5*side_square, native.systemFont, 16 )
		text_2:setFillColor( 63/255, 23/255, 114/255)

	local text_3 = display.newText("Rose", 5.5*side_square, 0.5*side_square, native.systemFont, 16 )
		text_3:setFillColor( 1, 0, 0)


	Walls( 2, 1, _group )
	Walls( 4, 1, _group )
	Walls( 2, 3, _group )
	Walls( 2, 5, _group )
	Walls( 4, 3, _group )
	Walls( 4, 5, _group )

	blue( _group )
	green( _group )
	yellow( _group )

	-- local Rectangle = display.newRect( display.contentWidth/2, side_square*3.5, side_square*5+5, side_square*5+5)
	-- Rectangle.strokeWidth = 5
	-- Rectangle:setFillColor(106/255, 106/255, 169/255)
	-- Rectangle:setStrokeColor( 103/255, 103/255, 227/255 )
end


--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	
	gameInit( group )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene