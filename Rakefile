require 'rake'
require 'rake/rdoctask'
require 'yaml'

#
# Hoe tasks
#

desc "Compile Website"
task :compile_website do
  rm 'simple_site'
  sh 'tap compile'
end

desc "Publish Website to RubyForge"
task :publish_website => [:compile_website] do
  config = YAML.load(File.read(File.expand_path("~/.rubyforge/user-config.yml")))
  host = "#{config["username"]}@rubyforge.org"
  
  rsync_args = "-v -c -r"
  remote_dir = "/var/www/gforge-projects/tap"
  local_dir = "pkg"
 
  sh %{rsync #{rsync_args} #{local_dir}/ #{host}:#{remote_dir}}
end
