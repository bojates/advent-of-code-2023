=begin
# Problem: 
Find the first and last digit on each line
These create the coordinates
Add those valuees together

# Example:
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet

=> 
12
38
15
77 (if just one number, use it twice)

Together makes 142

# Data
Input: file of strings
Output: integer

# Algorithm
Read file and take each line (into array, or loop?)
  File.read(filename)
  lines array
Loop each map?
  Extract just the numbers str.delete(/![0-9])  ?
    str.scan(/\d/)
  Take the first and last and join together (str[0] + str[-1] as a string)
  Convert to integer (.to_i)
Sum array
=end

NUMBERS = { "one" => "1", 
            "two" => "2", 
            "three" => "3", 
            "four" => "4", 
            "five" => "5", 
            "six" => "6", 
            "seven" => "7", 
            "eight" => "8", 
            "nine" => "9" }

def extract_codes(filename)
  lines = File.read(File.dirname(__FILE__) + '/' + filename).split
  restring = '(?=(\d|' + NUMBERS.keys.join('|') + '))' 
  re = Regexp.new(restring)

  lines.map do |line| 
    numbers = line.scan(re).flatten || ['0']
    numbers.map! { |number| NUMBERS.has_key?(number) ? NUMBERS[number] : number }
    (numbers[0] + numbers[-1]).to_i
  end.sum
end

def test(filename, expected)
  answer = extract_codes(filename)
  if expected == answer
    puts 'OK'
  else 
    puts "ERROR expected: #{expected} and got: #{answer}"
  end
end

test('testfile.txt', 142)
test('testfile2.txt', 281)
test('input.txt', 53592)