require 'favicon_maker'

def say(message)
  puts message unless Rake.application.options.silent
end

namespace :favicon do
  task :generate do
    options = {
      versions: [:apple_114, :apple_57, :apple, :fav_png, :fav_ico],
      custom_versions: {apple_extreme_retina: {filename: "apple-touch-icon-228x228-precomposed.png", dimensions: "228x228", format: "png"}},
      root_dir: Rails.root,
      input_dir: File.join('app', 'assets', 'images'),
      base_image: 'favicon.png',
      output_dir: 'public',
      copy: true
    }

    if File::exists?(File.join('app', 'assets', 'images', 'favicon.png'))
      if Gem.loaded_specs['favicon_maker'].version < Gem::Version.new('1.0.0')
        FaviconMaker::Generator.create_versions(options) do |filepath|
          say "Created favicon: #{filepath}"
        end
      else
        FaviconMaker.generate do

          setup do
            template_dir  options.root_dir.join(options.input_dir)
            output_dir    options.root_dir.join(options.output_dir)
          end

          from 'favicon_base_hires.png' do
            icon 'apple-touch-icon-152x152-precomposed.png'
            icon 'apple-touch-icon-144x144-precomposed.png'
            icon 'apple-touch-icon-120x120-precomposed.png'
            icon 'apple-touch-icon-114x114-precomposed.png'
            icon 'favicon-196x196.png'
            icon 'favicon-160x160.png'
            icon 'favicon-96x96.png'
            icon 'mstile-144x144', format: 'png'
          end

          from 'favicon_base.png' do
            icon 'apple-touch-icon-76x76-precomposed.png'
            icon 'apple-touch-icon-72x72-precomposed.png'
            icon 'apple-touch-icon-60x60-precomposed.png'
            icon 'apple-touch-icon-57x57-precomposed.png'
            icon 'apple-touch-icon-precomposed.png', size: '57x57'
            icon 'apple-touch-icon.png', size: '57x57'
            icon 'favicon-32x32.png'
            icon 'favicon-16x16.png'
            icon 'favicon.png', size: '16x16'
            icon 'favicon.ico', size: '64x64,32x32,24x24,16x16'
          end

          each_icon do |filepath|
            puts filepath # verbose example
          end unless Rake.application.options.silent
        end
      end
    else
      say 'No source favicon found, please create favicon.png in your app/assets/images directory.'
    end
  end
end

desc 'Generate favicons from single favicon.png source'
task favicon: "favicon:generate"
