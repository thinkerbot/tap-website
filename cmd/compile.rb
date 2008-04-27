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
  ['--help', '-h', GetoptLong::NO_ARGUMENT, "Print this help."]]

rdoc = false
Tap::Support::CommandLine.handle_options(*opts) do |opt, value| 
  case opt
  when '--help'
    puts Tap::Support::CommandLine.command_help(__FILE__, opts)
    exit
    
  end
end


# setup copy task
require 'fileutils'
copy_task = Tap::FileTask.new do |task, subdir|
  src = app.filepath('content', subdir)
  target = app.filepath('pkg', subdir)

  task.log :copy, subdir
  task.prepare(target)
  FileUtils.cp_r(src, target)
end

# enque tasks and run
app.task('simple_site/compile').enq
copy_task.enq('images')
copy_task.enq('stylesheets')
app.run
