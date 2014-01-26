-----------------------------------------------------------------------------------------
--
-- MyGameFuncs.lua
--
-----------------------------------------------------------------------------------------

side_square = display.contentWidth/7
local textWinn

-----------------------------------------------------------------------------------------
 
function AddText ( _group )


	text_1 = display.newEmbossedText("Gray Cat", 1.5*side_square, 0.5*side_square, native.systemFont, 18 )
	text_1:setFillColor(  63/255, 23/255, 114/255) 
	local color = 
	{
	    highlight =   { r = 255, g = 255, b = 255, a = 180 },
	    shadow = { r = 255, g = 255, b = 255, a = 128 }
	}
	text_1:setEmbossColor( color )

	text_2 = display.newEmbossedText("Ginger Cat", 3.5*side_square, 0.5*side_square, native.systemFont, 18 )
	text_2:setFillColor( 210/255, 105/255, 30/255)
	local color = 
	{
	    highlight =   { r = 255, g = 255, b = 255, a = 180 },
	    shadow = { r = 255, g = 255, b = 255, a = 128 }
	}
	text_2:setEmbossColor( color )

	text_3 = display.newEmbossedText("White Cat", 5.5*side_square, 0.5*side_square, native.systemFont, 18 )
	text_3:setFillColor( 69/255, 77/255, 95/255) 
	local color = 
	{
	    highlight =   { r = 255, g = 255, b = 255, a = 180 },
	    shadow = { r = 255, g = 255, b = 255, a = 128 }
	}
	text_3:setEmbossColor( color )

	_group:insert( text_1 )
	_group:insert( text_2 )
	_group:insert( text_3 )

end

-----------------------------------------------------------------------------------------

function Walls( n, m, matr )
	local wall = display.newImageRect( "wall.png", side_square*0.8, side_square*0.8)
	wall.x = (n+0.5)*side_square
	wall.y = (m+0.5)*side_square
	matr[n][m].type = "wall"

	return( wall )
end



-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

function AreYouWinner( matr )
	for j=1, 5 do
		if matr[1][j].type ~= "gray_cat" then
			return false
		end
		if matr[3][j].type ~= "ginger_cat" then
			return false
		end
		if matr[5][j].type ~= "white_cat" then
			return false
		end
	end
	return true
end

-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------



function getXbyCol(col)
	return (col + 0.5) * side_square
end

function getYbyRow(row)
	return (row + 0.5) * side_square
end


function getImage( fileName, matr, touchedImage, _group, gameState )
	local img = display.newImageRect( fileName,  side_square * 0.9, side_square * 0.9 )

	function img:canMoveTo(dn, dm)
		if  (self.col + dn > 5) or (self.col + dn < 1) or 
			(self.row + dm > 5) or (self.row + dm < 1) then	
				return false
		end

		return (matr[self.col + dn][self.row + dm].type == "empty")
	end

	function img:touch(e) 
		if (gameState.value == "gameOver") then
			return true
		end
		
		if e.phase == "began" then 
			if (gameState.value == "moving") and (gameState.value ~= nil) then
				return true
			end 
			
			gameState.value = "touched"
			touchedImage = self
			self.oldX, self.oldY = e.x, e.y 
			return true
		end

		if (e.phase == "moved") then
			if (gameState.value ~= "touched") or (gameState.value == nil) then
				return true
			end
			if (touchedImage == nil) or (touchedImage ~= self) then
				return true
			end

			
			if (self.oldX - e.x < 0) and ( self:canMoveTo(1, 0) )  then 
				x, y = 1, 0
			elseif (self.oldY - e.y < 0) and ( self:canMoveTo(0, 1) )  then 
				x, y = 0, 1
			elseif (self.oldX - e.x > 0) and ( self:canMoveTo(-1, 0) )  then 
				x, y = -1, 0
			elseif (self.oldY - e.y > 0) and ( self:canMoveTo(0, -1) )  then 
				x, y = 0, -1
			else
				return true
			end

			if  (self.col + x > 5) or (self.col + x < 1) or 
				(self.row + y > 5) or (self.row + y < 1) then	
 				return true
			end

			matr[self.col + x][self.row + y].type = matr[self.col][self.row].type
			matr[self.col][self.row].type = "empty"
			self.col, self.row = (self.col + x), (self.row + y)

			gameState.value = "moving"

			local newX, newY = getXbyCol( self.col ), getYbyRow( self.row )
			transition.moveTo( self, {x = newX, y = newY, time = 400, onComplete = function(obj)
					gameState.value = "free"
					if ( AreYouWinner( matr ) == true ) then
						local timerid = timer.performWithDelay(500, function()
						  	textWinn = display.newEmbossedText( "You are Winner!", display.contentWidth/2, display.contentHeight-2.5*side_square, native.systemFont, 28 )
							textWinn:setFillColor( 49/255, 0, 98/255 )
							local color = 
							{
							    highlight =   { r = 255, g = 255, b = 255, a = 180 },
							    shadow = { r = 255, g = 255, b = 255, a = 128 }
							}
							textWinn:setEmbossColor( color )

							 _group:insert( textWinn )
						end)
						gameState.value = "gameOver"
					end
				end})

			return true
		end

		if e.phase == "ended" then
			if (gameState.value ~= "touched") or (gameState.value == nil) then
				return true
			end  
			gameState.value = "free"
			return true
		end
	end

	img:addEventListener("touch", img )

	return img
end