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
=end
require_relative '../test_tool'

def sum_parts(filename)
  lines = get_lines(filename)

  parts = []
  lines.each_with_index do |line, line_idx|
    # next if line_idx > 1
    digit_str = ''
    keep_me = false

    line.chars.each_with_index do |char, idx|
      if /\d/=~char
        digit_str += char
        if !keep_me && check_for_symbol(lines, line_idx, idx)
          keep_me = true
        end
      else 
        if keep_me
          parts << digit_str
        end
        digit_str = ''
        keep_me = false
      end

      if (idx == line.length - 1) && keep_me
        parts << digit_str
      end
    end
  end
  parts.map(&:to_i).sum
end

def get_lines(filename)
  File.readlines(File.join(File.dirname(__FILE__), filename), chomp: true)
end

def check_for_symbol(lines, line_idx, char_idx)
  re = /([^a-zA-Z0-9\.])/

  first_char = (char_idx == 0)
  last_char = (lines.length - 1 == char_idx)
  first_line = (line_idx == 0)
  last_line = !(lines[line_idx + 1])

  chars = []
  chars << lines[line_idx][char_idx - 1] unless first_char
  chars << lines[line_idx][char_idx + 1] unless last_char
  chars << lines[line_idx - 1][char_idx] unless first_line
  chars << lines[line_idx - 1][char_idx - 1] unless first_line || first_char
  chars << lines[line_idx - 1][char_idx + 1] unless first_line || last_char
  chars << lines[line_idx + 1][char_idx] unless last_line
  chars << lines[line_idx + 1][char_idx - 1] unless last_line || first_char
  chars << lines[line_idx + 1][char_idx + 1] unless last_line || last_char

  if re =~ chars.join
    return true
  end
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
        # p locations
        # if check_for_stars(lines, line_idx, idx)
        #   locations << 
        # end
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
  parts.select { |key, val| val.length == 2 }.map { |_, (val1, val2)| val1 * val2 }.sum

  # parts.map(&:to_i).sum
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

  # p hits.compact
  return hits.compact
end

test(gear_ratios("testfile1.txt"), 467835)
test(gear_ratios("input.txt"), 78236071)

# test(sum_parts("testfile1.txt"), 4361)
# test(sum_parts("testfile2.txt"), 1752)
# test(sum_parts("input.txt"), 533775) 