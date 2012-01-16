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
