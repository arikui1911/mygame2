task 'default' => 'test'

require 'rake/testtask'
Rake::TestTask.new

require 'rake/rdoctask'
Rake::RDocTask.new do |t|
  t.rdoc_dir = 'doc'
  t.rdoc_files = FileList["lib/**/*.rb"]
  t.options.push '-S', '-N'
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new
rescue LoadError
end

