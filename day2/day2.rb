require_relative '../test_tool'

MAX_CUBES = { red: 12, green: 13, blue: 14 }

def cubes(filename) 
  lines = create_hash(filename)

  lines.select! do |line|
    line[:red] <= MAX_CUBES[:red] &&
    line[:green] <= MAX_CUBES[:green] &&
    line[:blue] <= MAX_CUBES[:blue] 
  end

  lines.map { |line| line[:game] }.sum
end

def get_powers(filename) 
  lines = create_hash(filename)
  lines.map { |line| line[:red] * line[:green] * line[:blue]}.sum
end

def create_hash(filename)
  lines = File.readlines(File.join(File.dirname(__FILE__), filename))

  lines.map do |line| 
    game, rounds = line.split(':')
    game = game.scan(/\d+/).first.to_i

    { game: game, 
      red: get_max(rounds, 'red'), 
      green: get_max(rounds, 'green'), 
      blue: get_max(rounds, 'blue') }
  end
end

def get_max(line, search_term)
  search_str = '\d+\s' + search_term
  regexp = Regexp.new(search_str)
  hits = line.scan(regexp)
  hits.map do |hit|
    hit.scan(/\d+/).first.to_i
  end.max
end

# Part 1
test(cubes('testfile1.txt'), 8)
test(cubes('input.txt'), 2563)
# Part 2
test(get_powers('testfile1.txt'), 2286)
test(get_powers('input.txt'), 70768)