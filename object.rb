class Temp
  def init()
    @hash={}
  end
  def insert(name, age)
    @hash["#{name}"] = 123
  end
  def print1()
    puts @hash.keys
  end
end
t=Temp.new
t.init
t.insert("puneet",26)
t.print1
  