require 'erb'

# Define folders path
erb_folder = 'templates'
res_folder = 'render'

# Create folders if needed
Dir.mkdir(erb_folder) unless Dir.exist?(erb_folder)
Dir.mkdir(res_folder) unless Dir.exist?(res_folder)

Dir.glob("#{erb_folder}/*.erb") do |erb_file|
  res_file        = "#{res_folder}/#{File.basename(erb_file, '.erb')}"

  erb_str = File.read(erb_file)

  @title = 'HW'
  @body  = 'Hello World'
  result = ERB.new(erb_str).result

  File.open(res_file, 'w') do |f|
    f.write(result)
  end
end
