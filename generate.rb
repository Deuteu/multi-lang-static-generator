require 'slop'
require 'fileutils'
require 'i18n'
require 'erb'

opts = Slop.parse do |o|
  o.string '-r', '--root',    'Root folder (current by default)',               default: nil
  o.string '-i', '--input',   'Input folder (absolute or relative to root)',    default: 'templates'
  o.string '-o', '--output',  'Output folder (absolute or relative to root)',   default: 'render'
  o.array  '-l', '--locales', 'Locales (first one is default for translation)', default: [:en, :fr]
  o.string '-t', '--trans',   'Translations (absolute or relative to root)',    default: 'locale/*.yml'
  o.on     '-h', '--help' do
    puts o
    exit
  end
end

root        = opts[:root].nil? ? '' : "#{opts[:root]}/"
erb_folder  = opts[:input].start_with?('/')  ? opts[:input]  : "#{root}#{opts[:input]}"
res_folder  = opts[:output].start_with?('/') ? opts[:output] : "#{root}#{opts[:output]}"
trans_files = opts[:trans].start_with?('/')  ? opts[:trans]  : "#{root}#{opts[:trans]}"

# Create folders if needed
FileUtils.mkpath(erb_folder) unless Dir.exist?(erb_folder)
FileUtils.mkpath(res_folder) unless Dir.exist?(res_folder)

I18n.load_path         = Dir[trans_files]
I18n.available_locales = opts[:locales]
I18n.default_locale    = opts[:locales].first
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
