class Operations
  def initialize
    @id=""
    @name=""
    @type=""
  end
  def create(id,name,type,input,output)
    @id=id
    @name=name
    @type=type
    @input=input
    @output=output
    
  end
  def display
    puts "id=#{@id}"
    puts "name=#{@name}"
    puts "type=#{@type}"
    @input.each do |i|
      puts "#{i}\t"
    end
    @output.each do |i|
      puts "#{i}\t"
    end
  end
end
