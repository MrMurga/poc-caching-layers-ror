require 'fileutils'

# https://www.imagemagick.org/script/convert.php
# https://www.imagemagick.org/Usage/resize/#pixel
namespace 'assets' do
  
  desc 'Prepare folders'
  task :prepare_folders do
    prefix = './public/assets'
    
    %w(original large medium small).each do |dirname|
      directory = "#{prefix}/#{dirname}"

      unless File.directory? directory
        FileUtils.mkdir(directory)
      end
    end
  end
  
  desc "Resizes assets"
  task :resize do
    my_files = FileList['./public/**/*.jpg', './public/**/*.webp']
    my_files.each do |file|
      (folder, name) = File.split(file)

      # Keep original
      FileUtils.cp file, "#{folder}/original/#{name}"

      # Resize large
      sh "convert #{file} -quality 80 -strip -resize 2048x2048 #{folder}/large/#{name}"

      # Resize medium
      sh "convert #{file} -quality 80 -strip -resize 1024x1024 #{folder}/medium/#{name}"

      # Resize small
      sh "convert #{file} -quality 80 -strip -resize 768x768 #{folder}/small/#{name}"

      # Remove file
      # FileUtils.rm file
    end
  end
  
  desc "Convert assets to webp"
  task :webp do
    my_files = FileList['./public/**/*.jpg']
    my_files.each do |file|
      sh "convert #{file} #{file}.webp"
    end
  end
end

# every time you execute 'rake assets:precompile'
# run 'before_assets_precompile' first    
Rake::Task['assets:precompile'].enhance do
  Rake::Task['assets:prepare_folders'].invoke
  Rake::Task['assets:webp'].invoke
  Rake::Task['assets:resize'].invoke
end