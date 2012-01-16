require "Object1.rb"
def mapping 
      $t.display_object   #display objects
 require "rubygems"
 require "dbi"
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
      request = (File.open(fname,"r")).read.split(" ")
      #puts request
      i=0
      $op_details={}
      while request[i]!="inputs"
        $op_details["#{request[i]}"]=request[i+2]  
        i=i+3;
      end
     
      i=i+1
      $op_details.each do |k,j|
        puts "#{k}  #{j}"
      end
     
      $input={}
      while i<request.length
        $input["#{request[i]}"]=request[i+2]
        i=i+3
      end
      
      $input.each do |k,j|
        puts "#{k}  #{j}"
      end
#---------------------------------------------------------------------------------------------------------------------------
      $map={}
      fin = File.open("mapping","r")
      fin.each  do |line|
        a=line.split " "
        $map["#{a[0]}"]=a[1]
      end
      puts $map
      require "rubygems"
      require "dbi"
      begin
        dbh = DBI.connect("DBI:Mysql:prototype:localhost", 
                      "root", "123")
        #  if $t["type"] = "debit"
        sth = dbh.prepare("update account set #{$map['bal']} = #{$map['bal']} - #{$input['amount'].to_i}  WHERE  #{$map['id']} = \'#{$input['id']}\'") ###EDITING left, statement incomplete
        sth.execute()
        #dbh.commit
        sth.finish   
     # end
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
  $t=Object1.new
  $t.create("main")
  $t.insert("id","string");
  $t.insert("bal","int");
  #$t.display_object
end
op=nil
while op!="4"
puts "1.Create Objects\n2.Create Operations\n3.testing\n4.to exit\n5.MappingEnter your choice"
op=gets
#puts "#{op}"
op=op.chomp;
puts op
case op.to_i
when 1
  object()
when 2
  puts "2"
when 3
  testing();
when 4 
  puts"Exiting program"
when 5
  mapping();
end

  
end