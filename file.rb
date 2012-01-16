require "modules.rb"
include Parse
parser('request.xml')
puts $input
