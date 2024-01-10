require_relative "../test_tool"

def get_lines(filename)
  filename = File.join(File.dirname(__FILE__), filename)
  File.readlines(filename, chomp: true)
end

def get_closest_location(filename)
  lines = get_lines(filename)

  seeds = lines[0].split(" ").select { |section| section.match?(/\d+/) }.map(&:to_i)

  mappings = {}
  current_key = ""
  lines.each do |line|
    if /map:/.match?(line)
      current_key = line
      mappings[current_key] = {}
    elsif /^\d+\s\d+\s\d+$/.match?(line)
      dest, source, length = line.split(" ").map(&:to_i)
      line_range = (source..source + length)
      mappings[current_key].merge!({line_range => dest - source})
    end
  end

  locations = []
  seeds.each do |seed|
    find_loc = seed

    mappings.each do |_, values|
      find_loc = values.map { |rng, val|
        rng.cover?(find_loc) ? (find_loc + val) : nil
      }.compact.first || find_loc
    end

    locations << find_loc
  end

  locations.min
end

test(get_closest_location("testfile.txt"), 35)
test(get_closest_location("input.txt"), 379811651)
