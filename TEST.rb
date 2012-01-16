#for objects-----------
require "Object1.rb"
t=Object1.new
t.create("main")
t.insert("id","string");
t.insert("bal","int");
t.display_object
t.iterator
t.next1
t.next1

#-----------------------------------------------------

#for operations -------------------------------------------------------

require "Operations.rb"
op=Operations.new
input=["id","amount"]
output=["bal"]
op.create("1","cw","debit",input,output)
op.display
