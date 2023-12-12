def test(answer, expected)
  if expected == answer
    puts 'OK'
  else 
    puts "NOPE: expected: #{expected} and got: #{answer}"
  end
end
