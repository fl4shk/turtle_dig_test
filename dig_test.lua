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
local pos_index_x, pos_index_y, pos_index_z = 1, 2, 3
local up_str, down_str = "up", "down"

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
		pos[pos_index_x] = pos[pos_index_x] + 1
	elseif ( faced_dir[1] == dir_positive_y ) then
		pos[pos_index_y] = pos[pos_index_y] + 1
	elseif ( faced_dir[1] == dir_negative_x ) then
		pos[pos_index_x] = pos[pos_index_x] - 1
	else --if ( faced_dir[1] == dir_negative_y ) then
		pos[pos_index_y] = pos[pos_index_y] - 1
	end
	
	turtle.dig()
	turtle.forward()
end

function turn_and_move_at_end_of_row( faced_dir, pos )
	if ( ( pos[pos_index_z] % 2 ) == 0 ) then
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
	else --if ( ( pos[pos_index_z] % 2 ) == 1 ) then
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
	
	pos[pos_index_z] = pos[pos_index_z] + 1
	
	turtle.digUp()
	turtle.up()
	
	if ( ( pos[pos_index_z] % 2 ) == 0 ) then
		turn_left(faced_dir)
		turn_left(faced_dir)
	else --if ( ( pos[pos_index_z] % 2 ) == 1 ) then
		turn_right(faced_dir)
		turn_right(faced_dir)
	end
	
end

function dig_down_then_move_down( faced_dir, pos )
	
	pos[pos_index_z] = pos[pos_index_z] - 1
	
	turtle.digDown()
	turtle.down()
	
	if ( ( pos[pos_index_z] % 2 ) == 0 ) then
		turn_left(faced_dir)
		turn_left(faced_dir)
	else --if ( ( pos[pos_index_z] % 2 ) == 1 ) then
		turn_right(faced_dir)
		turn_right(faced_dir)
	end
	
end

function main()
	if ( #args < 3 or #args > 4 ) then
		print("Usage:  <program name> num_blocks_x num_blocks_y "
			.. "num_blocks_z (bool_move_up)")
		return
	end
	
	-- Three entries.
	local num_blocks_tbl = { 0, 0, 0 }
	
	for i = 1, #num_blocks_tbl do
		num_blocks_tbl[i] = tonumber(args[i])
		
		if ( num_blocks_tbl[i] == nil ) then
			print("Error!  The argument \"" .. args[i] .. "\" is not a "
				.. "valid number!")
			return
		end
	end
	
	-- The faced direction
	local faced_dir = { dir_positive_x }
	
	-- The position with respect to the initial position.
	local pos = { 0, 0, 0 }
	
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
	
	
	for k = 1, num_blocks_tbl[pos_index_z] do
		
		for j = 2, num_blocks_tbl[pos_index_y] do
			
			for i = 2, num_blocks_tbl[pos_index_x] do
				dig_then_move_forward( faced_dir, pos )
			end
			
			turn_and_move_at_end_of_row( faced_dir, pos )
			
		end
		
		for i = 2, num_blocks_tbl[pos_index_x] do
			dig_then_move_forward( faced_dir, pos )
		end
		
		if ( k < num_blocks_tbl[pos_index_z] ) then
			if ( up_or_down == up_str ) then
				dig_up_then_move_up( faced_dir, pos )
			elseif ( up_or_down == down_str ) then
				dig_down_then_move_down( faced_dir, pos )
			end
		end
		
	end
	
	
end


main()


