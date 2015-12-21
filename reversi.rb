# Reversi
class Reversi
  attr_accessor :turn_color

  BOARD_WIDTH = 8

  module SearchState
    MID_POINT = 0
    END_POINT = 1
  end

  class Color
    BLACK = 0
    WHITE = 1

    def initialize(color)
      @color = color
    end

    def self.black
      Color.new(BLACK)
    end

    def self.white
      Color.new(WHITE)
    end

    def to_s
      @color == BLACK ? 'b' : 'w'
    end

    def reverse
      Color.new(1 - @color)
    end

    def black?
      @color == BLACK
    end

    def white?
      !black?
    end
  end

  DIRS = [[-1, -1], [-1, 0], [-1, 1],
          [0, -1], [0, 1],
          [1, -1], [1, 0], [1, 1]]

  def initialize
    @cells = [['*', '*', '*', '*', '*', '*', '*', '*'],
              ['*', '*', '*', '*', '*', '*', '*', '*'],
              ['*', '*', '*', '*', '*', '*', '*', '*'],
              ['*', '*', '*', 'b', 'w', '*', '*', '*'],
              ['*', '*', '*', 'w', 'b', '*', '*', '*'],
              ['*', '*', '*', '*', '*', '*', '*', '*'],
              ['*', '*', '*', '*', '*', '*', '*', '*'],
              ['*', '*', '*', '*', '*', '*', '*', '*']]
    @turn_color = Color.black
  end

  def legal?(color, x, y)
    return false if x < 0 || x > 8
    return false if y < 0 || y > 8

    DIRS.each do |dir|
      if can_flip(color, x, y, dir[0], dir[1])
        return true
      end
    end
    false
  end

  def try_flip(color, x, y, dx, dy, search_state, dry_run=false)
    x += dx
    y += dy
    return false unless x >= 0 && x <= BOARD_WIDTH - 1 &&
                        y >= 0 && y <= BOARD_WIDTH - 1

    reverse_color = color.reverse
    if search_state == SearchState::MID_POINT
      if @cells[y][x] == reverse_color.to_s
        if try_flip(color, x, y, dx, dy, SearchState::END_POINT, dry_run)
          @cells[y][x] = color.to_s unless dry_run
          return true
        end
      else
        return false
      end
    elsif search_state == SearchState::END_POINT
      if @cells[y][x] == reverse_color.to_s &&
         try_flip(color, x, y, dx, dy, search_state, dry_run)
        @cells[y][x] = color.to_s unless dry_run
        return true
      elsif @cells[y][x] == color.to_s
        return true
      end
    end
    false
  end

  def can_flip(color, x, y, dx, dy)
    return false if x < 0 || x > 8
    return false if y < 0 || y > 8
    str = ''
    loop do
      x += dx
      y += dy
      break unless x >= 0 && x <= BOARD_WIDTH - 1 && y >= 0 && y <= BOARD_WIDTH - 1
      str += @cells[y][x]
    end
    if color.black?
      return true if str =~ /^w+b/
    else
      return true if str =~ /^b+w/
    end
    false
  end

  def make_move(color, x, y)
    return unless self.legal?(color, x, y)

    result = DIRS.inject(false) { |a, e| a || try_flip(color, x, y, e[0], e[1], SearchState::MID_POINT) }
    @cells[y][x] = color.to_s if result
    @turn_color = color.reverse
  end

  def print_board
    puts '  ' + ((0..7).to_a.join(' '))
    @cells.each_with_index do |row, i|
      puts "#{i} #{row.join(' ')}"
    end
  end
end

reversi = Reversi.new
loop do
  puts ''
  reversi.print_board
  puts "#{reversi.turn_color.to_s}の番です"
  str = gets
  x, y = str.split(' ').map(&:to_i)
  if reversi.legal?(reversi.turn_color, x, y)
    reversi.make_move(reversi.turn_color, x, y)
  else
    puts 'その手は打てません'
  end
end
