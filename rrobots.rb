# Creative Commons BY-SA :  Regis d'Aubarede <regis.aubarede@gmail.com>

require_relative '../Ruiby/lib/Ruiby'

require_relative 'mobile'
require_relative 'tank'
require_relative 'bullet'
require_relative 'fire'
require_relative 'tanks'
require_relative 'obstacles'


def source_class(klass)
  lsm = (klass.methods(false).map{|m| klass.method(m)} +
             klass.instance_methods(false).map{|m| klass.instance_method(m)}).
            map(&:source_location).
            compact
  file,start,count=lsm.group_by{|sl| sl[0]}.map do |file, sls|
    lines = sls.map{|sl| sl[1]}.sort
    count = lines.last-lines.first
    line = lines.min
    {file: file, count: count, line: line}
  end.sort_by!{|fc| -fc[:count]}.map{|fc| [fc[:file], fc[:line], fc[:count]]}[0]
  
  lines=File.read(file).split(/\r?\n/)
  nol_start=start.downto(0) { |nol| break(nol) if lines[nol] =~/^class\b/ && lines[nol] !~ /<</}
  nol_end=(start+count).upto(lines.size) { |nol| break(nol) if lines[nol]=~/^end/ }
  if nol_start && nol_end && nol_end>nol_start && nol_end<= lines.size
    lines[nol_start..nol_end].join("\n")
  else 
    raise("no class found")
  end
end

class Test
  class << self
     def test(string)
       eval string
     rescue Exception => e
       Message.alert(e.to_s)
     end
  end
end

Ruiby.app width: 500, height: 200, title: "RRobots" do
  src=Ruiby.stock_get("source",<<'EEND')
class T < Tank
  def initialize(x,y,coul="#4444FF") 
    super(x,y,coul) ; 
    @v= 3
    @cradar=0
  end
  def tank?() true end
  def anim()
     #turn_radar(0.5*Math::PI/360)
     turn_to(Math::PI/16.0)
     move()
  end
end
EEND
  $app=self
  @ltank =[]
  def_style "* { font-size: 10px;}"
  stack do
  flow do
    stack do
      @ed=source_editor(width:300, height:400) 
      @ed.editor.buffer.text=src
      flowi do
         button("Syntax test ")  { Test.test @ed.editor.buffer.text }
         button("Replace current player") { eval @ed.editor.buffer.text }
      end
    end if true
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
        labeli("Play with :")
        @cb=sloti(combo(lTanks,0)) 
        flowi {
          regular
          button("view") { edit(source_class(eval @cb.get_selection()[0])) }
          button("Go") { run_game(@cb.get_selection()[0]) }
        }
      }
    end
  end
    buttoni("reload") { 
      load __FILE__ 
      load "mobile.rb"
      load "tank.rb"
    }
  end
  anim(40) {  @ltank.each { |t| t.anim } ; @cv.redraw } 
  def run_game(klass_namame) 
    klass= (eval(klass_namame) rescue nil)
    return unless  klass
    Ruiby.stock_put("source",@ed.editor.buffer.text)
    begin
      tclass = eval @ed.editor.buffer.text 
    rescue Exception => e
       error e
       return
    end
    @ltank =[]
    @ltank << @t=tclass.new(rand(20..180),rand(20..180))
    @ltank << klass.new(50+rand(140),50+rand(140)) 
    @ltank << klass.new(50+rand(140),50+rand(140)) 
    @ltank << klass.new(50+rand(140),50+rand(140)) 
    #4.times { @ltank << Obstacle.new(rand(0..200),rand(0..200),rand(3..15)) }
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
    def each_tank(o)
       if block_given?
         @ltank.each { |t|  if t!=o && t.tank? then  yield end }  
       else
         @ltank.select { |t|  (t!=o && t.tank? ) }.each  
       end
    end
  end
end
