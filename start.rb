require "Object1.rb"
require "Operations.rb"
require "rubygems"
require "ruby-debug-ide"
require "modules.rb"
require "dbi"




def ready_obj
  $obj = []
  temp=Object1.new
   fobj=File.open("obj.txt", "r")
   object=fobj.read.split " "
   i=0
   while i<object.length
     if object[i]== "#NAME"
      if i!=0
        $obj.push(temp)
      end
      temp=Object1.new
      i=i+1
      temp.create(object[i])
     end
     if(object[i] == "#ATTR") 
       temp.insert(object[i+1],object[i+2])
       i=i+2
     end
     if(object[i])=="#KEY"
       i=i+1
       temp.set_primary_key(object[i])
     end
     if(object[i])=="#BALANCE"
       i=i+1
       temp.set_balance(object[i])
     end  
     i=i+1
  end
   $obj.push(temp)
   i=0 
fobj.close
end

def ready_op
  $op =[]
  temp=Operations.new
   fobj=File.open("op.txt", "r")
   object=fobj.read.split " "
   i=0
   id=""
   name=""
   type=""
   while i<object.length
     input=[]
     output=[]
     if object[i]== "#ID"
      if i!=0
        $op.push(temp)
      end
      temp=Operations.new
      i=i+1
      id=object[i]
      i=i+2
      name=object[i]
      i=i+2
      type=object[i]
      i=i+1
     end
     while (object[i] == "#INPUT") 
       input.push(object[i+1])
       i=i+2
     end
     while (object[i] == "#OUTPUT") 
       output.push(object[i+1])
       i=i+2
     end
     temp.create(id,name,type,input,output)  
   end
   $op.push(temp)
   i=0 
  while i<$op.length  
   $op[i].display()
   i=i+1
  end
     
end


def mapping
   
 $obj[0].display_object   #display objects
 
 #-----------------------code to display dummy fields
begin
     # connect to the MySQL server
     dbh = DBI.connect("DBI:Mysql:prototype:localhost","root", "123")
     sth = dbh.prepare("show Fields from account")
     sth.execute()
     sth.fetch do |row|
        puts "#{row[0]}\t#{row[1]}\n"
     end
     sth.finish
rescue DBI::DatabaseError => e
     puts "An error occurred"
     puts "Error code:    #{e.err}"
     puts "Error message: #{e.errstr}"
ensure
     # disconnect from server
     dbh.disconnect if dbh
end


fout=File.open("mapping","w")
puts "\n enter mapping info for each object attribute as pair of:  object_attribute mapped_field\n enter #to exit "
while (s=gets.chomp) !="#"
  fout.puts("#{s}\n")
end 
fout.close
end
def operation
  require "Operations.rb"
  op=Operations.new
  input=["id"]
  output=["bal","name"]
  op.create("1","cw","debit",input,output)
  op.display
end

def testing()
      puts "\nENTER request FILE NAME : "
      fname=gets.chomp
      include Parse
      parser(fname)
      
#---------------------------------------------------------------------------------------------------------------------------
      $map={}
      fin = File.open("mapping","r")
      fin.each  do |line|
        a=line.split " "
        $map["#{a[0]}"]=a[1]
      end
      #puts $map
      $op.each do |op|
        if op.get_id == $op_id
          $op_name=op.get_name
          $op_type=op.get_type
          $op_input=op.get_input
          $op_output=op.get_output
          $obj_key=$obj[0].get_primary_key
          $obj_balance=$obj[0].get_balance
          break
        end
        
      end
      begin
        dbh = DBI.connect("DBI:Mysql:prototype:localhost","root", "123")
        if $op_type == "DEBIT"
          sth = dbh.prepare("update account set #{$map[$obj_balance]} = #{$map[$obj_balance]} - #{$input['amt'][0].to_i}  WHERE  #{$map[$obj_key]} = \'#{$input[$obj_key][0]}\'") ###EDITING left, statement incomplete
          sth.execute()
          dbh.commit
          response=File.open("response.xml","w")
          response.puts"<response>"
          response.puts"<op_id>#{$op_id}</op_id>"
          response.puts"<output>"
          $op_output.each do |i|
            sth = dbh.prepare("select #{$map[i]} from account where #{$map[$obj_key]} = \'#{$input[$obj_key][0]}\'")
            sth.execute()
            out=""
            sth.fetch do |row|
              out=row[0]
            end
            response.puts"<#{i}>#{out}</#{i}>"
          end
          response.puts"</output>"
          response.puts"</response>"
        sth.finish   
        response.close
        end
       if $op_type == "CREDIT"
          sth = dbh.prepare("update account set #{$map[$obj_balance]} = #{$map[$obj_balance]} + #{$input['amt'][0].to_i}  WHERE  #{$map[$obj_key]} = \'#{$input[$obj_key][0]}\'") ###EDITING left, statement incomplete
          sth.execute()
          dbh.commit
          response=File.open("response.xml","w")
          response.puts"<response>"
          response.puts"<op_id>#{$op_id}</op_id>"
          response.puts"<output>"
          $op_output.each do |i|
            sth = dbh.prepare("select #{$map[i]} from account where #{$map[$obj_key]} = \'#{$input[$obj_key][0]}\'")
            sth.execute()
            out=""
            sth.fetch do |row|
              out=row[0]
            end
            response.puts"<#{i}>#{out}</#{i}>"
          end
          response.puts"</output>"
          response.puts"</response>"
        sth.finish   
        response.close
        end 
      rescue DBI::DatabaseError => e
        puts "An error occurred"
        puts "Error code:    #{e.err}"
        puts "Error message: #{e.errstr}"
      ensure
     # disconnect from server
        dbh.disconnect if dbh
      end      
end

def object
  fobj=File.open("obj.txt","w")
  puts "\nenter object name :"
  while (s1=gets.chomp)!="#"
  fobj.puts "#NAME  #{s1}\n"
  puts "\n ENTER attributes type pair as: attr_name type  "
  while (s=gets.chomp)!="#" 
      fobj.puts "#ATTR  #{s}\n"
  end
  puts "\nenter primary key:"
  fobj.puts"#KEY #{gets.chomp}"
  puts "\nenter balance key:"
  fobj.puts"#BALANCE #{gets.chomp}"
  puts "\nenter object name :"
  end
  fobj.close
  #$t.display_object
end
def operation
  fop=File.open("op.txt","w")
  puts "\nenter operation id :"  ##generate automatically 
  while (s1=gets.chomp)!="#"
    fop.puts "#ID  #{s1}\n"
    puts "\nenter operation name :"
    fop.puts "#NAME  #{gets.chomp}\n"
    puts "\nenter operation type :"
    fop.puts "#TYPE  #{gets.chomp}\n"
    puts "\n ENTER input type pair as: attr_name Object_name(object name not currently!!)  "
  while (s=gets.chomp)!="#" 
      fop.puts "#INPUT  #{s}\n"
  end
    puts "\n ENTER output type pair as: attr_name Object_name(object name not currently!!)  "
  while (s=gets.chomp)!="#" 
      fop.puts "#OUTPUT  #{s}\n"
  end
  puts "\nenter op name :"
  end
  fop.close
  #$t.display_object
end

op=nil
while op!="5"
puts "1.Create Objects\n2.Create Operations\n3.mapping\n4.testing\n5.to exit\nEnter your choice"
op=gets
#puts "#{op}"
op=op.chomp;
case op.to_i
when 1
  object()
when 2
  operation()
when 3
  ready_obj()
  mapping();
when 4
  ready_obj()
  ready_op()
  testing();
when 5 
  puts "Thank tou for using this application"

end
end