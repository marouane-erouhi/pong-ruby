require 'gosu'

$width = 640
$height = 480
DIFFICULTY_SCALE = 0.0
class Player
    attr_accessor :x, :y, :w, :h,:score,:velocity
    def initialize(x, y, vel=5.0)
        @x = x
        @y = y
        @velocity = vel
        @w = 10
        @h = 100
        @score=0
    end

    def draw()
        draw_rect(@x, @y, 20, 100, Gosu::Color::BLUE)
    end
end

class Ball
    attr_accessor :x,:y,:w,:velx,:vely
    def initialize(x,y,w,vel)
        @x=x
        @y=y
        @w=w
        @velx=vel
        @vely=vel
    end
    def update
        @x+=@velx
        @y+=@vely
    end
end


class MyWindow < Gosu::Window
    def initialize
        super($width, $height)
        self.caption = 'Pong in 2 hours'
        @p1 = Player.new($width-40, $height/2)
        @p2 = Player.new(40, $height/2)
        @velocity = 5.0
        @ball = Ball.new($width/2, $height/2, 10, 3.0)
        @speed = 0.0
    end

    def update
        p1_move_up if Gosu.button_down? Gosu::KB_UP
        p1_move_down if Gosu.button_down? Gosu::KB_DOWN

        p2_move_up if Gosu.button_down? Gosu::KB_W
        p2_move_down if Gosu.button_down? Gosu::KB_S


        # collision up and down wall
        if @ball.y > height-@ball.w || @ball.y <= 0
            @ball.vely *= -1
        end

        # lose condition
        if @ball.x > width
            # p1 lost
            puts "P2 WINS"
            @p2.score+=1
            reset_ball
        end
        if @ball.x < 0
            # p2 lost
            puts "P1 WINS"
            @p1.score+=1
            reset_ball
        end
        puts @p1.velocity.to_s 

        if coll(@p1)
            puts "p1"
        end

        if coll(@p2)
            puts "p2"
        end

        @ball.update
    end
    def draw
        draw_player(@p1, Gosu::Color::BLUE)
        draw_player(@p2, Gosu::Color::RED)

        draw_rect(@ball.x, @ball.y, @ball.w, @ball.w, Gosu::Color::WHITE)

        #  draw scores
        Gosu::Image.from_text(self, 'Score '+@p2.score.to_s, Gosu.default_font_name, 20).draw(20, 20, 0)
        Gosu::Image.from_text(self, 'Score '+@p1.score.to_s, Gosu.default_font_name, 20).draw($width-100, 20, 0)
        #  Draw dificulty label
        Gosu::Image.from_text(self, "Dificulty: ", Gosu.default_font_name, 20).draw($width/2-28, 20, 0)
        Gosu::Image.from_text(self, @speed.to_s, Gosu.default_font_name, 20).draw($width/2-20, 40, 0)
    end

    def coll(player)
        if @ball.x >= player.x && @ball.x <= player.x+player.w && @ball.y >= player.y && @ball.y <= player.y+player.h
            puts "Bounce"
            @ball.velx *= -1
            return true
        end
        return false
    end


    def reset_ball
        @ball.x = width/2
        @ball.y = height/2
        @ball.velx *= -1
        @speed+=DIFFICULTY_SCALE
        if @ball.velx > 0
            @ball.velx += @speed
        else
            @ball.velx -= @speed
        end
        puts @ball.velx
    end
    
    def p1_move_up
        @p1.y -= @velocity
    end
    def p1_move_down
        @p1.y += @velocity
    end

    def p2_move_up
        @p2.y -= @velocity
    end
    def p2_move_down
        @p2.y += @velocity
    end




    def draw_player(player, color)
        draw_rect(player.x, player.y, player.w, player.h, color)
    end
    def button_down(button_id)
        case button_id
            when Gosu::KB_ESCAPE
                close
            when Gosu::KB_SPACE
                shoot
            else
            super
        end
    end
end
window = MyWindow.new
window.show