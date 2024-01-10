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
      mappings[current_key] = []
    elsif /^\d+\s\d+\s\d+$/.match?(line)
      dest, source, length = line.split(" ").map(&:to_i)
      line_range = (source..source + length)
      mappings[current_key] << {line_range => dest - source}
    end
  end

  locations = []
  map_keys = [
    "seed-to-soil map:",
    "soil-to-fertilizer map:",
    "fertilizer-to-water map:",
    "water-to-light map:",
    "light-to-temperature map:",
    "temperature-to-humidity map:",
    "humidity-to-location map:"
  ]

  seeds.each do |seed|
    find_loc = seed

    map_keys.each do |map_key|
      find_loc = mappings[map_key].map { |rng|
        rng.keys.first.cover?(find_loc) ? (find_loc + rng.values.first) : nil
      }.compact.first || find_loc
    end

    locations << find_loc
  end

  locations.min
end

test(get_closest_location("testfile.txt"), 35)
test(get_closest_location("input.txt"), 379811651)
