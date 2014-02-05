require_relative '../Ruiby/lib/Ruiby'

require_relative 'mobile'
require_relative 'tank'
require_relative 'bullet'
require_relative 'fire'
require_relative 'tanks'
require_relative 'obstacles'




Ruiby.app width: 500, height: 200, title: "RRobots" do
  $app=self
  @ltank =[]
  def_style "* { font-size: 10px;}"
  flow do
    stack do
      @ed=source_editor(width:300, height:400) 
      #@ed.editor.buffer.text=TankManuel.to_source
      flowi do
         button("Syntax test ") 
         button("Replace current player")
      end
    end if false
    stacki do
      @cv=canvas(200,200) do 

        on_canvas_draw { |w,cr|   
          w.init_ctx("#000000","#005050",1)
          @ltank.each { |t| t.draw(w,cr) } 
        }
        on_canvas_button_press { |w,e|  
          next unless @t
          dx=(e.x-@t.x)
          dy=(e.y-@t.y)
          a=Math.atan2(dy,dx)
          @t.turn_to( a ) 
          @t.accelerate(1.05)
          w.redraw 
        }
        on_canvas_key_press { |w,e,k| 
        p "k"
          next unless @t
          da,dr={"Left"=>[-1,0],"Right"=>[1,0],"Up"=>[0,-1],"Down"=>[0,1]}[k]||[0,0]
          @t.turn_cannon(da*Math::PI/36) ; @t.turn_radar(dr*Math::PI/36)  
          @t.accelerate(1.05) if k=="a"
          @t.turn(Math::PI/180.0) if k=="q"
          @t.fire() if k=="space"
        } if true
      end
      stack {
        lTanks=ObjectSpace.each_object(::Class).select {|klass| klass < TankGamer ? klass: nil}.map {|c|c.to_s}
        labeli("Gamer:")
        @cb=sloti(combo(lTanks,nil)) 
        buttoni("Go") { run_game(@cb.get_selection()[0]) }
      }
    end
  end
  anim(100) {  @ltank.each { |t| t.anim } ; @cv.redraw } 
  def run_game(klass_namame) 
    klass= (eval(klass_namame) rescue nil)
    return unless  klass
    @ltank =[]
    @ltank << @t=TankManuel.new(44,44,"#AA0000")
    @ltank << klass.new(50+rand(140),50+rand(140)) 
    4.times { @ltank << Obstacle.new(rand(0..200),rand(0..200),rand(3..15)) }
  end
  class << $app
    def creatBullet(o,x,y,dir)  @ltank << Bullet.new(o,x,y,dir)  end
    def kill(o,t) 
      unless t.obstacle? 
        fire(t.x,t.y)
        dead(t)
      end
    end
    def dead(o)       @ltank.delete(o) end
    def fire(x,y)     @ltank << Fire.new(x,y) end
    def obstacle?(o) 
      @ltank.any? { |t|  t!=o && t.obstacle? && t.intersect(o) }  
    end
    def test_collision(o,x,y)
      dead(o) if @ltank.any? { |t|  (t!=o && ! o.childr?(t) && (t.tank? || t.obstacle?) && t.intersect(o)) ? (kill(o,t); ;true) : false }  
    end
  end
end
