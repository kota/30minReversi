class Reversi

  def initialize
    @cells = [['*','*','*','*','*','*','*','*'],
              ['*','*','*','*','*','*','*','*'],
              ['*','*','*','*','*','*','*','*'],
              ['*','*','*','b','w','*','*','*'],
              ['*','*','*','w','b','*','*','*'],
              ['*','*','*','*','*','*','*','*'],
              ['*','*','*','*','*','*','*','*'],
              ['*','*','*','*','*','*','*','*']]
  end

  def is_legal?(turn,x,y)
    return false if x < 0 || x > 8
    return false if y < 0 || y > 8
    
    return can_flip(turn,x,y,-1,-1) || can_flip(turn,x,y,-1,0) || can_flip(turn,x,y,-1,1) || can_flip(turn,x,y,0,-1) ||
           can_flip(turn,x,y,0,1) || can_flip(turn,x,y,1,-1) || can_flip(turn,x,y,1,0) || can_flip(turn,x,y,1,1)
  end

  def can_flip(turn,x,y,dirx,diry)
    return false if x < 0 || x > 8
    return false if y < 0 || y > 8
    str = ""
    while x >= 0 && x <= 8 && y >= 0 && y <= 8
      x += dirx
      y += diry
      str += @cells[y][x]
    end
    if turn == 'b'
      return true if str =~ /^w+b/
    else
      return true if str =~ /^b+w/
    end
    return false
  end

end

reversi = Reversi.new
puts "黒の番です"
while(str=gets)
  x,y = str.split(' ').map(&:to_i)

  puts reversi.is_legal?('b',x,y)
end
