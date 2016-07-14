class Tile
  attr_accessor :revealed, :value

  def initialize(value)
    @revealed = false
    @value = value
  end

  def reveal
    @revealed = true
  end

  def to_s
    if @revealed == false
      return "*"
    else
      return @value
    end
  end
end
