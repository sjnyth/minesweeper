require_relative "./Board.rb"
require "byebug"
require "yaml"
class Game

    def initialize(size, numofmines)
        @b = Board.new(size, numofmines)
        @b.populate_grid
        @b.fill_mine_data
    end
    
    def save_game
        puts "Enter filename to save at:"
        filename = gets.chomp

        File.write(filename, YAML.dump(self))
        # 
    end

    
    
    def game
        @b.display_grid
        while !@b.finished
            puts "Put the position in x,y,r(or f or u for unflag) format"
            puts "Game won't quit after you hit 's'. Press Ctrl+C to do that."

            a = gets.chomp
        
            if a == 's'
                self.save_game
            end

            if a[4] == "f"
                @b.grid[a[0].to_i][a[2].to_i].flagged = true
                @b.display_grid
                next
            end

            if a[4] == "u"
                @b.unflag(a[0].to_i, a[2].to_i)
                @b.display_grid
                next
            end

            if @b.grid[a[0].to_i][a[2].to_i].value == "B"
                @b.grid[a[0].to_i][a[2].to_i].revealed = true
                break
            end

            if a[4] == "r"
                @b.reveal(a[0].to_i, a[2].to_i)
                @b.display_grid
            end
        end
        @b.display_grid
        if !@b.finished
            puts "Sorry! You Lost."
        elsif @b.finished && b.won?
            puts "Congrats. You won."
        else
            puts "Sorry! You Lost."
        end
    end

    


end

if $PROGRAM_NAME == __FILE__
    # running as script
  
    case ARGV.count
    when 0
      Game.new(9, 21).game
    when 1
      # resume game, using first argument
      YAML.load_file(ARGV.shift).game
    end
end

