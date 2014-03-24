# Creative Commons BY-SA :  Regis d'Aubarede <regis.aubarede@gmail.com>

#require_relative '../Ruiby/lib/Ruiby'
require 'Ruiby'
require_relative 'mobile'
require_relative 'tank'
require_relative 'bullet'
require_relative 'fire'
require_relative 'tanks'
require_relative 'obstacles'

$W=500
$H=500

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

Ruiby.app width: 300+$W, height: $H+50, title: "RRobots" do
  src=Ruiby.stock_get("source",<<'EEND')
class T < Tank
  def initialize(x,y,coul="#4444FF") 
    super(x,y,coul) ; 
    @v= 10
    @a=@cdir=@cradar=0
  end
  def tank?() true end
  def tick(c)
     turn_to(2)
     pivot_by(45) if mindist?
     fire if fire_good? 
     move()
  end
end
T
EEND
  $app=self
  @announce=""
  @status_game=0
  @ltank =[]
  def_style "* { font-size: 10px;}"
  def_style "button { background-color: #FF0000;}"
  stack do
  flow do
    stack do
      @ed=source_editor(width:400, height:500) 
      @ed.editor.buffer.text=src
      flowi do
         button("Syntax test ")  { 
           Ruiby.stock_put("source",@ed.editor.buffer.text)
           Test.test @ed.editor.buffer.text 
         }
         button("Replace current player") { 
           Ruiby.stock_put("source",@ed.editor.buffer.text)
           begin
              eval @ed.editor.buffer.text 
           rescue Exception => e
              error(e)
           end
        }
      end
    end if true
    stacki do
      @cv=sloti(canvas($W,$H) do 
        on_canvas_draw { |w,cr|   
          w.init_ctx("#000000","#005050",1)
          @ltank.each { |t| t.draw(w,cr) } 
          w.draw_text(10,40,@announce,3,"#FF5577") if @announce.size>0
        }
      end)
      stack {
        ctx=  make_StockDynObject("ctx",{"nb_player" => 1, "nb_robots" =>  4})
        lTanks=ObjectSpace.each_object(::Class).select {|klass| klass < TankGamer ? klass: nil}.map {|c|c.to_s}
        flowi { labeli("Play with :",width:150) ; @cb=sloti(combo(lTanks,0))  }
        flowi { labeli("nb Players:",width:150) ; sloti(islider(ctx.nb_player,min:1,max:30,by:2)) }
        flowi { labeli("nb Robots:",width:150)  ; sloti(islider(ctx.nb_robots,min:1,max:30,by:2) ) }
        flowi {
          regular
          button("view") { edit(source_class(eval @cb.get_selection()[0])) }
          button("Go") { run_game(@cb.get_selection()[0],ctx.nb_player.value,ctx.nb_robots.value) }
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
  anim(40) {  
    @ltank.each { |t| t._anim } if @status_game <2
    @announce=case @status_game
        when 0 then "Waiting to Start"
        when 1 then ""
        when 2 then "Bravo !!!"
        when 3 then "Game over ;("
    end
    @cv.redraw 
    end_game() if  @ltank.size==1
  } 
  def run_game(klass_namame,nbp,nbr) 
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
    nbp.to_i.times { @ltank << @player=tclass.new(rand(20..$W-20),rand(20..$H-20)) }
    nbr.to_i.times { @ltank << klass.new(50+rand($W-50),50+rand($H-50)) }
    #4.times { @ltank << Obstacle.new(rand(0..$W),rand(0..$H),rand(3..15)) }
    @status_game=1
  end
  class << $app
    def creatBullet(o,x,y,dir)  @ltank << Bullet.new(o,x,y,dir)  end
    def kill(t) 
      unless t.obstacle? 
        fire(t.x,t.y)
        dead(t)
      end
    end
    def dead(o)       
      o.dead
      @ltank.delete(o) 
    end
    def fire(x,y)     @ltank << Fire.new(x,y) end
    def obstacle?(o) 
      @ltank.any? { |t|  t!=o && t.obstacle? && t.intersect(o) }  
    end
    def test_collision(o,parent)
      dead(o) if @ltank.any? { |t|  (t!=o && ! o.childr?(t) && (t.tank? || t.obstacle?) && t.intersect(o)) ? (kill(t); true) : false }  
    end
    def each_tank(o)
       if block_given?
         @ltank.each { |t|  if t!=o && t.tank? then  yield end }  
       else
         @ltank.select { |t|  (t!=o && t.tank? ) }.each  
       end
    end
    def end_game()
     ok= true || (@ltank.size==1 && @ltank.first==@player)
     @status_game = ok ? 2 : 3
     #@ltank=[]
    end
  end
end
