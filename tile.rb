class Tile
  attr_accessor :revealed, :value

  def initialize(value)
    @revealed = false
    @value = value
  end

  def reveal
    @revealed = true
  end


end
