class Object1
  def initialize
    @name=""
    @attributes={}
  end
  def create(name)
    @name=name
  end
  def insert(attr_name,attr_type)
    @attributes["#{attr_name}"]=attr_type
  end
  def set_primary_key(key)
    @primary=key
  end
  def get_primary_key()    #identy id at runtime
    @primary               #only one key assuming simple pkey, later on use array
  end
  def set_balance(key)     
    @balance=key            #identify balance at runtime
  end
  def get_balance()
    @balance
  end
  def get_name
    @name
  end
  def get_attributes
    @attributes
  end
  def display_object
    
    puts "Name=#{@name}\n";
    @attributes.each do |i,j|
      puts "#{i}\t#{j}"
    end
   end
   def iterator
     @iter=@attributes
   end
   def next1
     puts @iter
     puts "\n"
             
   end
end
