=begin
# Problem
Find the part numbers in the input
Part numbers are strings of digits, e.g. 450. They only count if they are adjacent to symbols. 
Adjacent means on the same line, above, below, or diagonal. 
Symbols are non-numbers and non-digits and not periods. e.g. &, +, %
Sum them

# Example
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..

Line 1, number 467 has 
  - no symbols next to it on the same line
  - and none in the same places below it
  - but there is one a step to the right (diagonal). 

Line 1, number 114 has
 - no symbols next to it on the same line
 - no symbols below it
 - no symbols one to the left or right of it

 Line 7, number 592 has
  - no symbols next to it on the same line
  - no symbols above or below it
  - a symbol above to the right

467 is a part number (diagonal to *). 114 is not (no symbol within range). 
When added together, they make 4361. 

# Data
Input: file of strings. Including numbers and symbols. 
Ouput: integer. 

# Algorithm
Find the numbers and their positions, as a range
 - need to find the locations of all the digits in the string. 
Each line, convert to array
Loop each line
  Loop each char
    if digit
      store location
      store digit
    add to this
    when not a digit (or end of line)
      check the adjoining places
      if symbol found, save digit
    
Check for a symbol in one of the adjoining positions
If there is a symbol 
  save the number

For each number, see if there's a symbol either: 
  - left
  - right
  - above any of the positions of the number (it will be a range)
  - above and one left or one right of the number
  - below and one left or one right of the number
If there is, add to an array of parts
Sum the array

## Part 2
We now only want numbers that share the same * symbol. 
We then multiply them by each other, and return a summed amount. 

Could: 
 - only keep numbers that have a *
 - Use the location of * as a key, and hold the digits in an array [line_char]
 - get rid of arrays with only one entry
 - check arrays with more than 2 entries
 - work with the rest

OR
 - if we find a star, look for digits?

 Refactored the first bit to use strings and Regexp.last_match with the offset info. 

 # Get the digits and the location of the digits
 # For each digit, we have line and range
 # We can check char before and after on same line
 # We can check range on line above
 # We can check range on live below. 
 # If we have a regexp match, keep the digits
=end
require_relative '../test_tool'


def sum_parts(filename)
  lines = get_lines(filename)
  lines_select = lines.map.with_index do |line, i| 
    line.gsub(/\d+/).map do |num|
      
      a, b = Regexp.last_match.offset(0)
      check_me(lines, i, a, b) ? num : nil
    end
  end.flatten.map(&:to_i).sum
end

def check_me(lines, line, x, y)
  regexp = /[^0-9\.]/

  x = x - 1 unless x == 0
  y = y + 1 unless y == lines[line].length - 1 
  line_above = (line == 0) ? line : line - 1
  line_below = (line == lines.length - 1) ? line : line + 1
  
  lines[line][x...y] =~ regexp ||
    lines[line_above][x...y] =~ regexp ||
    lines[line_below][x...y] =~ regexp 
end

def gear_ratios(filename)
  lines = get_lines(filename)

  parts = {}
  lines.each_with_index do |line, line_idx|
    # next if line_idx > 1
    digit_str = ''
    locations = []
    line.chars.each_with_index do |char, idx|
      if /\d/=~char
        digit_str += char
        locations += check_for_stars(lines, line_idx, idx)
      else 
        locations.each do |l|
          parts[l] = [digit_str.to_i, parts[l]].flatten.compact.uniq
        end
        digit_str = ''
        locations = []
      end
      
      if (idx == line.length - 1) && locations.length > 0
        locations.each do |l|
        parts[l] = [digit_str.to_i, parts[l]].flatten.compact.uniq
        end
      end
    end
  end

  parts.select { |key, val| val.length == 2 }
        .map { |_, (val1, val2)| val1 * val2 }
        .sum
end

def check_for_stars(lines, line_idx, char_idx)
  re = /\*/

  first_char = (char_idx == 0)
  last_char = (lines.length - 1 == char_idx)
  first_line = (line_idx == 0)
  last_line = !(lines[line_idx + 1])

  hits = []
  hits << ("#{line_idx}_#{char_idx - 1}" if re =~ lines[line_idx][char_idx - 1]) unless first_char
  hits << ("#{line_idx}_#{char_idx + 1}" if re =~ lines[line_idx][char_idx + 1]) unless last_char
  hits << ("#{line_idx - 1}_#{char_idx}" if re =~ lines[line_idx - 1][char_idx]) unless first_line
  hits << ("#{line_idx - 1}_#{char_idx - 1}" if re =~ lines[line_idx - 1][char_idx - 1]) unless first_line || first_char
  hits << ("#{line_idx - 1}_#{char_idx + 1}" if re =~ lines[line_idx - 1][char_idx + 1]) unless first_line || last_char
  hits << ("#{line_idx + 1}_#{char_idx}" if re =~ lines[line_idx + 1][char_idx]) unless last_line
  hits << ("#{line_idx + 1}_#{char_idx - 1}" if re =~ lines[line_idx + 1][char_idx - 1]) unless last_line || first_char
  hits << ("#{line_idx + 1}_#{char_idx + 1}" if re =~ lines[line_idx + 1][char_idx + 1]) unless last_line || last_char

  return hits.compact
end

def get_lines(filename)
  filename = File.join(File.dirname(__FILE__), filename)
  File.readlines(filename, chomp: true)
end

test(gear_ratios("testfile1.txt"), 467835)
test(gear_ratios("input.txt"), 78236071)

test(sum_parts("testfile1.txt"), 4361)
test(sum_parts("testfile2.txt"), 1752)
test(sum_parts("input.txt"), 533775) 
