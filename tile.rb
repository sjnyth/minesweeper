class Tile
    attr_accessor :value, :revealed, :flagged
    def initialize(value)
        @value = value
        @revealed = false
        @flagged = false
    end
end