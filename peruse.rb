require 'curses'
include Curses


class Peruse
    attr_accessor :position, :data
    def initialize(data)
        @data = data
        @out = STDERR       
        @position = 0
    end    
    def io_inc        
        stash = @data[@position]
        @data[@position] = "*"
        io_show
        @data[@position] = stash
        io_tell
       @position += 1
    end
    def tell
      @data[@position].to_s
    end  
    def show
      line = @data.join('')      
    end
    def io_tell
        @out.print(tell)
        @out.flush
    end
    def io_show
      line = @data.join('')
      @out.print("\e[H\e[2J")
      @out.print(line)
      @out.print("\n\r==================================================\n\r");
      @out.flush
   end
    def report 
        output = ""
        stash = @data[@position]
        @data[@position] = "*"
        line = show
        @data[@position] = stash
        output += line
        output += "\n\n----------------\n\n"
        output += tell
        output += "\n\n"
        output += user_data_hook.to_s
        output
        
    end
    def finish
    end
    def move(direction)
        width = `tput cols`.strip.to_i
       case direction
        when 'left'  : ((@position > 0) ? @position -= 1 : 0) ;
        when 'right' : ((@position < @data.length) ? @position += 1 : @data.length) ;
        when 'up'
            moved = @position - width
            @position = moved if moved > 0

        when 'down'
            moved = @position + width
            @position = moved if moved < @data.length
        end
        report
    end
    def user_data_hook
      # just sitting here, waiting to be extended

    end
    def enter_hook
      # just sitting here, waiting to be extended

      report
    end  
    def interactive
        begin
        init_screen
         crmode
         noecho
         stdscr.keypad(true)
         addstr(report)
         loop do
             case ch = getch 
             when Key::UP   : clear ;addstr(move('up'));    
             when Key::DOWN : clear ;addstr(move('down'));    
             when Key::LEFT : clear ;addstr(move('left'));    
             when Key::RIGHT: clear ;addstr(move('right'));    
             when Key::ENTER: clear ;addstr(enter_hook);  
            
             else 
               beep  
            end
            refresh
        end
        ensure
         close_screen
        end  

 
    end
end
