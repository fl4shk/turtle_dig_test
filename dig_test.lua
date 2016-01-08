-- This file is part of Turtle Dig Test.
-- 
-- Copyright 2016 by Andy Clark (FL4SHK).
-- 
-- Turtle Dig Test is free software: you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as published
-- by the Free Software Foundation, either version 3 of the License, or (at
-- your option) any later version.
-- 
-- Turtle Dig Test is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-- General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License along
-- with Turtle Dig Test.  If not, see <http://www.gnu.org/licenses/>.


local args = { ... }


-- Constants
local number_type_str = "number"
local string_type_str = "string"
local table_type_str = "table"
local function_type_str = "function"

local dir_positive_x, dir_positive_y = 0, 1
local dir_negative_x, dir_negative_y = 2, 3
local up_str, down_str = "up", "down"

vec3_prototype = { x = 0, y = 0, z = 0 }

function vec3_prototype.__init__( x, y, z )
	local self = { x = x, y = y, z = z }
	setmetatable( self, {__index = vec3_prototype} )
	return self
end

function vec3_prototype:get_size()
	return 3
end

function test_func( a )
	print(type(a))
end

function turn_right( faced_dir )
	faced_dir[1] = faced_dir[1] + 1
	
	if ( faced_dir[1] > dir_negative_y ) then
		faced_dir[1] = dir_positive_x
	end
	
	turtle.turnRight()
end

function turn_left( faced_dir )
	faced_dir[1] = faced_dir[1] - 1
	
	if ( faced_dir[1] < dir_positive_x ) then
		faced_dir[1] = dir_negative_y
	end
	
	turtle.turnLeft()
end

function dig_then_move_forward( faced_dir, pos )
	if ( faced_dir[1] == dir_positive_x ) then
		pos.x = pos.x + 1
	elseif ( faced_dir[1] == dir_positive_y ) then
		pos.y = pos.y + 1
	elseif ( faced_dir[1] == dir_negative_x ) then
		pos.x = pos.x - 1
	else --if ( faced_dir[1] == dir_negative_y ) then
		pos.y = pos.y - 1
	end
	
	turtle.dig()
	turtle.forward()
end

function turn_and_move_at_end_of_row( faced_dir, pos )
	if ( ( pos.z % 2 ) == 0 ) then
		if ( faced_dir[1] == dir_positive_x ) then
			turn_right(faced_dir)
			dig_then_move_forward( faced_dir, pos )
			turn_right(faced_dir)
			faced_dir = dir_negative_x
		else --if ( faced_dir[i] == dir_negative_x ) then
			turn_left(faced_dir)
			dig_then_move_forward( faced_dir, pos )
			turn_left(faced_dir)
			faced_dir = dir_negative_x
		end
	else --if ( ( pos.z % 2 ) == 1 ) then
		if ( faced_dir[1] == dir_positive_x ) then
			turn_left(faced_dir)
			dig_then_move_forward( faced_dir, pos )
			turn_left(faced_dir)
			faced_dir = dir_negative_x
		else --if ( faced_dir[i] == dir_negative_x ) then
			turn_right(faced_dir)
			dig_then_move_forward( faced_dir, pos )
			turn_right(faced_dir)
			faced_dir = dir_negative_x
		end
	end
end

function dig_up_then_move_up( faced_dir, pos )
	pos.z = pos.z + 1
	
	turtle.digUp()
	turtle.up()
end

function dig_up_then_move_up_with_turn( faced_dir, pos )
	dig_up_then_move_up( faced_dir, pos )
	
	if ( ( pos.z % 2 ) == 0 ) then
		turn_left(faced_dir)
		turn_left(faced_dir)
	else --if ( ( pos.z % 2 ) == 1 ) then
		turn_right(faced_dir)
		turn_right(faced_dir)
	end
end

function dig_down_then_move_down( faced_dir, pos )
	pos.z = pos.z - 1
	
	turtle.digDown()
	turtle.down()
end

function dig_down_then_move_down_with_turn( faced_dir, pos )
	dig_down_then_move_down( faced_dir, pos )
	
	if ( ( pos.z % 2 ) == 0 ) then
		turn_left(faced_dir)
		turn_left(faced_dir)
	else --if ( ( pos.z % 2 ) == 1 ) then
		turn_right(faced_dir)
		turn_right(faced_dir)
	end
end

function main()
	if ( #args < 3 or #args > 4 ) then
		print("Usage:  <program name> num_blocks_x num_blocks_y "
			.. "num_blocks_z (up or down)")
		return
	end
	
	-- Three entries.
	local num_blocks_vec = vec3_prototype.__init__( 0, 0, 0 )
	
	-- x
	num_blocks_vec.x = tonumber(args[1])
	if ( num_blocks_vec.x == nil ) then
		print("Error!  The argument \"" .. args[1] .. "\" is not a "
			.. "valid number!")
		return
	end
	
	-- y
	num_blocks_vec.y = tonumber(args[2])
	if ( num_blocks_vec.y == nil ) then
		print("Error!  The argument \"" .. args[2] .. "\" is not a "
			.. "valid number!")
		return
	end
	
	-- z
	num_blocks_vec.z = tonumber(args[3])
	if ( num_blocks_vec.z == nil ) then
		print("Error!  The argument \"" .. args[3] .. "\" is not a "
			.. "valid number!")
		return
	end
	
	
	
	-- The faced direction
	local faced_dir = { dir_positive_x }
	
	-- The position with respect to the initial position.
	local pos = vec3_prototype.__init__( 0, 0, 0 )
	
	local up_or_down
	
	if ( #args == 4 ) then
		if ( args[4] == up_str ) then
			up_or_down = up_str
		elseif ( args[4] == down_str ) then
			up_or_down = down_str
		else
			print("Error!  If using the optional fourth argument, it must "
				.. " be either up or down!  For reference, here is the "
				.. "fourth argument:  \"" .. args[4] .. "\"." )
			return
		end
	else
		up_or_down = up_str
	end
	
	
	for k = 1, num_blocks_vec.z do
		
		for j = 2, num_blocks_vec.y do
			
			for i = 2, num_blocks_vec.x do
				dig_then_move_forward( faced_dir, pos )
			end
			
			turn_and_move_at_end_of_row( faced_dir, pos )
			
		end
		
		for i = 2, num_blocks_vec.x do
			dig_then_move_forward( faced_dir, pos )
		end
		
		if ( num_blocks_vec.x == 1 and num_blocks_vec.y == 1 ) then
			if ( k < num_blocks_vec.z ) then
				if ( up_or_down == up_str ) then
					dig_up_then_move_up( faced_dir, pos )
				elseif ( up_or_down == down_str ) then
					dig_down_then_move_down( faced_dir, pos )
				end
			end
		else
			if ( k < num_blocks_vec.z ) then
				if ( up_or_down == up_str ) then
					dig_up_then_move_up_with_turn( faced_dir, pos )
				elseif ( up_or_down == down_str ) then
					dig_down_then_move_down_with_turn( faced_dir, pos )
				end
			end
		end
		
	end
	
	
end


main()


