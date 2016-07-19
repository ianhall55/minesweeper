class Tile
  attr_accessor :revealed, :value, :flagged

  def initialize(value)
    @revealed = false
    @value = value
    @flagged = false
  end

  def reveal
    @revealed = true
    @flagged = false
  end

  def flag
    @flagged = @flagged ? false : true
  end

  def to_s
    if @revealed == false
      return "*"
    else
      return @value
    end
  end
end
