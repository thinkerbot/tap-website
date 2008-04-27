# = Usage
# tap compile {options} ARGS...
#
# = Description
# The default command simply prints the input arguments and application 
# information, then exits.
#
# = Information
#
# Developer:: <your name>
# Homepage:: <your homepage>
# Copyright (c):: 2008, <copyright holders>
# License:: MIT-LICENSE (http://www.opensource.org/licenses/mit-license.php) <or some other license...>
#

env = Tap::Env.instance
app = Tap::App.instance   

#
# handle options
#

opts = [
  ['--rdoc', '-r', GetoptLong::NO_ARGUMENT, "Regenerate rdoc"],
  ['--help', '-h', GetoptLong::NO_ARGUMENT, "Print this help."],
  ['--debug', nil, GetoptLong::NO_ARGUMENT, "Specifies debug mode."]]

rdoc = false
Tap::Support::CommandLine.handle_options(*opts) do |opt, value| 
  case opt
  when '--help'
    puts Tap::Support::CommandLine.command_help(__FILE__, opts)
    exit
    
  when '--debug'
    app.options.debug = true
    
  when '--rdoc'
    rdoc = true
  end
end

app.indir("..") do 
  env.rake_setup
  
  app.task('rdoc').enq 
  app.run
end if rdoc

# setup copy task
require 'fileutils'
copy_task = Tap::FileTask.new do |task|
  rdoc_src = File.dirname(__FILE__) + "/../../rdoc"
  rdoc_target = File.dirname(__FILE__) + "/../public/rdoc"

  task.log :copy, 'rdoc'
  task.prepare(rdoc_target)
  FileUtils.cp_r(rdoc_src, rdoc_target)
end

# enque tasks and run
app.task('simple_site/compile').enq
copy_task.enq
app.run
