require_relative '../test_tool'

def get_lines(filename)
  filename = File.join(File.dirname(__FILE__), filename)
  File.readlines(filename, chomp: true)
end

def get_score(filename)
  lines = get_lines(filename)

  lines.map do |line|
    _, winners, mine = line.split(/[:|]/).map do |chunk|
      chunk.scan(/\d+/).map(&:to_i)
    end
    win_count = winners.intersection(mine).size
    win_count == 0 ? 0 : 2 ** (win_count - 1)
  end.sum
end

def get_number_scratchcards(filename)
  lines = get_lines(filename)

  counter = Array.new(lines.size, 1)
  
  lines.each_with_index do |line, i|
    _, winners, mine = line.split(/[:|]/).map do |chunk|
      chunk.scan(/\d+/).map(&:to_i)
    end
    
    win_count = winners.intersection(mine).size
    
    (i + 1.. i + win_count).each do |j|
      counter[j] += (1 * counter[i])
    end
  end
  
  counter.sum
end

test(get_score('input.txt'), 22193) 
test(get_score('testfile1.txt'), 13)

test(get_number_scratchcards('testfile1.txt'), 30)
test(get_number_scratchcards('input.txt'), 5625994)
