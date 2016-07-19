require_relative "tile"
require 'colorize'
require 'byebug'

class Board
  attr_accessor :grid, :tile, :all_values

  DIRECTIONS = [
    [-1,-1],[-1,0],[-1,1],
    [0,-1],[0,1],[1,-1],
    [1,0],[1,1]
  ]

  def initialize
    @grid = Array.new(9) { Array.new(9) }
    @all_values = []
    populate_values
    create_tiles
    assign_bomb_warnings
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def []=(pos, value)
    x, y = pos
    tile = grid[x][y]
    tile.value = value
  end

  def render
    puts "   #{(0...@grid.count).to_a.join("  ")} "
    @grid.each_with_index do |row,idx|
      puts "#{idx}#{visual_row(row)}"
    end
  end

  def assign_bomb_warnings
    # assign number value if touching a bomb
    @grid.each_with_index do |row,i|
      row.each_with_index do |square,j|
        num_bombs = assign_value([i,j])
        @grid[i][j].value = num_bombs unless @grid[i][j].value == :B
      end
    end

  end

  def assign_value(pos)
    x, y = pos
    num_bombs = 0
    (x-1..x+1).to_a.each do |horz|
      (y-1..y+1).to_a.each do |vert|
        next if (horz < 0 || horz > 8) || (vert < 0 || vert > 8)
        num_bombs += 1 if @grid[horz][vert].value == :B
      end
    end
    num_bombs
  end

  def bombs_revealed?
    @grid.flatten.any? {|tile| tile.value == :B && tile.revealed == true }
  end

  def spaces_revealed?
    @grid.flatten.all? { |tile| tile.value == :B || tile.revealed == true}
  end

  def visual_row(row)
    row_string = ""
    row.each do |tile|
      if tile.flagged == true
        row_string << "  #{"F".pink}"
      elsif tile.revealed == false
        row_string << "  *"
      elsif tile.value == :B
        row_string << "  #{"B".red}"
      elsif tile.value > 0
        # str = "#{tile.value.to_s}"
        case tile.value
        when 1
          row_string << "  #{tile.value.to_s.green}"
        when 2
          row_string << "  #{tile.value.to_s.blue}"
        when 3
          row_string << "  #{tile.value.to_s.red}"
        when 4
          row_string << "  #{tile.value.to_s.yellow}"
        when 5
          row_string << "  #{tile.value.to_s.red}"
        end
        # row_string << "  #{tile.value.to_s.green}"
      else
        row_string << "  _"
      end
    end
    row_string
  end

  def create_tiles
    @grid.each do |row|
      row.each_with_index do |space, idx|
        row[idx] = Tile.new(get_value)
      end
    end
  end

  def get_value
    @all_values.pop
  end

  def populate_values

    number_of_bombs.times { all_values << :B }
    (size - number_of_bombs).times {  all_values << :e }

    all_values.shuffle!

  end

  def size
    @grid.flatten.count
  end

  def number_of_bombs
    size / @grid.length
  end

  def reveal_adjacent(pos)
    # byebug
    x,y = pos
    adj_spaces = []
    DIRECTIONS.each do |dir|
      adj = [x + dir[0], y + dir[1]]
      next unless adj[0].between?(0,8) && adj[1].between?(0,8)
      adj_spaces << adj if self[adj].revealed == false
    end
    if adj_spaces.none? {|adj_pos| self[adj_pos].value == :B}
      adj_spaces.each do |adj_pos|
        self[adj_pos].reveal
        reveal_adjacent(adj_pos)
      end
    end


  end
end
