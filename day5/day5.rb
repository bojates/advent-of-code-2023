#   Problem:
#   List of seeds to be planted.
#   mappings to convert numbers from source into numbers at destination.
#   e.g. see number to soil number
#   maps describe ranges.
#     dest range start
#     source range start
#     length
#   If there is no mapping for the source, it has the same destination number.
#
#   We are looking for: closest location that needs a seed. We want to find the lowest number.
#   mapping goes seed to soil, soil to fertilizer, etc, until humidity to location.

#   Data:
#   Input: mapping file
#   Output: lowest number for the location

#   Algorithm
#   create a locations array
#   Open the file
#   Manipulate the file
#     Get the seeds from the first line that says `seeds:`
#     loop the rest of the lines
#       if the line is the last line, or a blank line,
#       if the line has 'map' in it, grab the heading
#       for each line, split on spaces
#       create hashes
#       merge the hashes
#     for each seed, look up in the order provided
#     could get clever here and follow the train of words, but could also just hardcode this order. Do that for now.
#     store the location (locations << location)
#     return the lowest location (locations.min)
#   groups are split by empty lines
#   mappings are described by 'x-to-y map:' strings
#   mappings are provided as strings, with spaces between numbers
#   Can create a hash of mappings and use fetch to default to the current value

#   seed-to-soil map:
#   Hash[(37..37+2).zip (53..53+2)]
#   (37..37+2).zip(53..53+2).to_h
#   mapping.fetch(seed, seed)
require_relative "../test_tool"

def get_lines(filename)
  filename = File.join(File.dirname(__FILE__), filename)
  File.readlines(filename, chomp: true)
end

def get_closest_location(filename)
  lines = get_lines(filename)

  seeds = lines[0].split(" ").select { |section| section.match?(/\d+/) }
  mappings = {}
  current_key = ""
  lines.each do |line|
    if /map:/.match?(line)
      current_key = line
      mappings[line] = []
    elsif /\d+\s\d+\s\d+/.match?(line)
      dest, source, length = line.split(" ").map(&:to_i)
      line_range = (source..source + length)
      mappings[current_key] << {line_range => dest - source} if mappings[current_key]
    end
  end
  locations = []
  seeds.each do |seed|
    find_loc = seed.to_i

    map_keys = [
      "seed-to-soil map:",
      "soil-to-fertilizer map:",
      "fertilizer-to-water map:",
      "water-to-light map:",
      "light-to-temperature map:",
      "temperature-to-humidity map:",
      "humidity-to-location map:"
    ]
    map_keys.each do |map_key|
      find_loc = mappings[map_key].map { |rng|
        rng.keys.first.cover?(find_loc) ? (find_loc + rng.values.first) : nil
      }.compact.first || find_loc
    end
    locations << find_loc
  end
  locations.min
end

test(get_closest_location("input.txt"), 0)
test(get_closest_location("testfile.txt"), 35)
