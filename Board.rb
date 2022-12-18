# Remember "B" is for mines
# "__" is for revealed tiles with no surrounding bombs
# "*" is for unrevealed tiles

require_relative "./tile.rb"
require "set"
require "colorize"
class Board
    attr_accessor :grid
    def initialize(size, mines)
        @size = size
        @mines = mines
        @grid = Array.new(size) {Array.new(size)}
        @data_of_neighbouring_mines = Array.new(size) {Array.new(size)}
        @dug = [].to_set
    end

    def populate_grid
        # First we will make all of the tiles in the grid to have a value of "__" 
        for i in (0...@size)
            for j in (0...@size)
                @grid[i][j] = Tile.new("__")
            end
        end
        # Now we begin to populate our grid with some mines
        number_of_mines = 0
        while  number_of_mines < @mines
            rand1 = rand(@size)
            rand2 = rand(@size)
            if @grid[rand1][rand2].value == "__"
                @grid[rand1][rand2].value = "B"
                number_of_mines += 1
            end
        end
    end

    def display_grid
        for i in (0...@size)
            if i == 0
                print "\t"
            end
        
            print i.to_s.yellow + "\t"
        end
        puts 
        puts
        @grid.each_with_index do |arr, ind|
            puts ind.to_s.yellow + "\t" + arr.map {|ele| if ele.flagged then "F".blue elsif ele.revealed then ele.value.to_s.green else "*".red end}.join("\t")
            puts
        end
    end

    def number_of_neighbouring_mines(x, y)
        a = [-1, 0, 1]
        b = [-1, 0, 1]
        count = 0
        a.each do |i|
            b.each do |j|
                if (x + i < 0 || x + i >= @size || y + j < 0 || y + j >= @size) || (i == 0 && j == 0)
                    next
                end
                if @grid[x + i][y + j].value == "B"
                    count += 1
                end
            end
        end
        return count
    end

    def fill_mine_data
        for i in (0...@size)
            for j in (0...@size)
                @data_of_neighbouring_mines[i][j] = number_of_neighbouring_mines(i, j)
            end
        end
    end
     
    def reveal(x, y)
        @dug << [x, y]

        if @grid[x][y].value == "B"
            return
        end

        if @grid[x][y].flagged == true
            return 
        end

        @grid[x][y].revealed = true

        if @data_of_neighbouring_mines[x][y] != 0
            @grid[x][y].value = @data_of_neighbouring_mines[x][y]
            @grid[x][y].revealed = true
            return
        end
        for i in (-1..1)
            for j in (-1..1)
                if x + i < 0 || x + i >= @size || y + j < 0 || y + j >= @size
                    next
                else
                    reveal(x + i, y + j) if !@dug.include?([x+i, y+j])
                end
            end
        end
        return


    end
     
    def unflag(x, y)
        @grid[x][y].flagged = false
    end

    def finished
        return @grid.all? {|arr| arr.all?{|ele| ele.revealed || ele.flagged}}
    end

    def won?
        w = true
        for i in (0...@size)
            for j in (0...@size)
                if @grid[i][j].flagged 
                    if @grid[i][j].value != "B"
                        w = false
                    end
                end
            end
        end
        return finished() && w
                        
                    
    end

end
