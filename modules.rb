require "rubygems"
require 'xmlsimple'
module Parse
def parser(fname) 
  config = XmlSimple.xml_in(fname)
  $trans_id=config['trans_id'][0]
  $op_id=config['op_id'][0]
  $input=(config['input'])[0]
end
end


