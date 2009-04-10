# usage: ruby reference-compile.rb [-options] source-file
#   (more: ruby reference-compile.rb --help

require 'rbconfig'
require 'optparse'

rd2 = File.join(Config::CONFIG['bindir'], 'rd2')
unless File.file?(rd2)
  puts "#{File.basename($0, '.rb')}: RDtool not installed."
  exit 1
end

def parse_argv!(o)
  dest = css = encoding = nil
  o.on '-o', '--output=DEST', 'output file path (without suffix)' do |path|
    dest = path
  end
  o.on '-s', '--style-sheet=CSS', 'style sheet path' do |path|
    css = path
  end
  o.on '-e', '--encoding=ENC', 'encoding assignment [sjis]' do |enc|
    encoding = enc
  end
  o.parse! ARGV
  raise 'wrong number of arguments' unless ARGV.size == 1
  return ARGV.shift, dest, css, encoding
end

begin
  op = OptionParser.new
  op.banner << ' source-file'
  src, dest, css, encoding = parse_argv!(op)
rescue => ex
  me = File.basename($0, '.rb')
  $stderr.puts "#{me}: #{ex.message}"
  $stderr.puts op.help
  exit 1
end

dest     ||= File.basename(src, '.rd')
css      ||= "#{dest}.css"
encoding ||= "sjis"

ARGV.push(src, "-o#{dest}", "-rrd/rd2html-lib", "--with-css=#{css}", "--out-code=#{encoding}")
load rd2

