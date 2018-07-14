=begin
puts "would you like to store the video metadata as a new JSON file? (Y/N)"
store = gets.strip.upcase
loop do
  if store == "Y"
    puts "Please enter a filename"
    filename = gets.strip
    puts "Save as #{filename}? (Y/N)"
    confirm_filename = gets.strip
      if confirm_filename == "Y"

  end
end
=end


