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

test(get_score('input.txt'), 22193) # 24896 is too high
test(get_score('testfile1.txt'), 13)