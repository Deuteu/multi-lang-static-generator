require 'erb'
require 'i18n'

# Define folders path
erb_folder = 'templates'
res_folder = 'render'

# Create folders if needed
Dir.mkdir(erb_folder) unless Dir.exist?(erb_folder)
Dir.mkdir(res_folder) unless Dir.exist?(res_folder)

I18n.load_path         = Dir['locale/*.yml']
I18n.available_locales = [:en, :fr]
I18n.default_locale    = :en
I18n.backend.load_translations

Dir.glob("#{erb_folder}/*.erb") do |erb_file|
  I18n.available_locales.each do |locale|
    I18n.with_locale(locale) do
      no_erb_filename = File.basename(erb_file, '.erb')
      ext             = File.extname(no_erb_filename)
      res_file        = "#{res_folder}/#{File.basename(no_erb_filename, ext)}.#{locale}#{ext}"

      erb_str = File.read(erb_file)

      result = ERB.new(erb_str).result

      File.open(res_file, 'w') do |f|
        f.write(result)
      end
    end
  end
end
