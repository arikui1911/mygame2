require 'test/unit'
$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))
require 'sdl'
require 'mygame'

# incomplete
class TC_Core < Test::Unit::TestCase
  def setup
    @core = MyGame::Core.__send__(:new)  #because singleton
  end
  
  def test_quit
    assert_raises(SystemExit){ @core.quit }
  end
end

class TC_Events < Test::Unit::TestCase
  def setup
    SDL::Event2.poll_queue.clear
    @e = MyGame::Events.new
  end
  
  PollMock = Struct.new(:class)
  
  def test_add
    @e.add(:active){ throw :mygame_test_events_active_event_called }
    SDL::Event2.poll_queue.push PollMock.new("SDL::Event2::Active")
    assert_throws(:mygame_test_events_active_event_called){ @e.poll }
  end
  
  def test_remove
    @e.add(:active){ throw :mygame_test_events_event_called, :active }
    @e.add(:key_up){ throw :mygame_test_events_event_called, :key_up }
    SDL::Event2.poll_queue.push PollMock.new("SDL::Event2::Active")
    SDL::Event2.poll_queue.push PollMock.new("SDL::Event2::KeyUp")
    @e.remove(:active)
    assert_equal :key_up, catch(:mygame_test_events_event_called){ @e.poll }
  end
  
  def test_remove_by_key
    @e.add(:active, :key){ throw :mygame_test_events_event_called, :active1 }
    @e.add(:active){ throw :mygame_test_events_event_called, :active2 }
    SDL::Event2.poll_queue.push PollMock.new("SDL::Event2::Active")
    @e.remove(:active, :key)
    assert_equal :active2, catch(:mygame_test_events_event_called){ @e.poll }
  end
end

class TC_DrawPrimitive < Test::Unit::TestCase
  def setup
    @d = MyGame::DrawPrimitive.new
  end
  
  def test_attr
    assert_nothing_raised NoMethodError do
      @d.x        = @d.x
      @d.y        = @d.y
      @d.w        = @d.w
      @d.h        = @d.h
      @d.offset_x = @d.offset_x
      @d.offset_y = @d.offset_y
      @d.alpha    = @d.alpha
      @d.hide     = @d.hide
      @d.screen   = @d.screen
    end
  end
  
  def test_screen_default
    assert_same MyGame.screen, @d.screen
  end
  
  def hide_p
    @d.hide = true
    assert @d.hide?
    @d.hide = false
    assert !@d.hide?
  end
  
  def test_update
    assert_nothing_raised(NoMethodError){ @d.update }
  end
  
  def test_render
    assert_nothing_raised(NoMethodError){ @d.render }
  end
  
  HIT_TGT = Struct.new(:x, :y).new(123, 666)
  
  def test_hit_p_hidden
    @d.hide = true
    assert !@d.hit?(HIT_TGT), "doesn't hit because hidden"
  end
  
  DISP_X = Object.new
  DISP_Y = Object.new
  
  def test_hit_p
    @d.instance_variable_set :@disp_x, DISP_X
    @d.instance_variable_set :@disp_y, DISP_Y
    @d.w = 111
    @d.h = 222
    disp_x, disp_y, w, h, tx, ty, *rest = @d.hit?(HIT_TGT)
    assert_same DISP_X, disp_x
    assert_same DISP_Y, disp_y
    assert_equal [111, 222, 123, 666], [w, h, tx, ty]
    assert_equal [1, 1], rest
  end
end

class TC_Square < Test::Unit::TestCase
  def test_initialize
    s = MyGame::Square.new(1, 2, 3, 4)
    assert_equal [1, 2, 3, 4], [s.x, s.y, s.w, s.h]
  end
  
  SCREEN = Class.new{
    [:draw_rect, :draw_rect_alpha, :fill_rect, :draw_filled_rect_alpha].each do |name|
      define_method(name){|*args| name }
    end
  }.new
  
  def setup
    @s = MyGame::Square.new
    @s.screen = SCREEN
  end
  
  def test_attr
    assert_nothing_raised NoMethodError do
      @s.color = @s.color
      @s.fill  = @s.fill
    end
  end
  
  def fill_p
    @s.fill = true
    assert @s.filled?
    @s.fill = false
    assert !@s.filled?
  end
  
  def test_render
    assert_equal :draw_rect, @s.render
  end
  
  def test_render_filled
    @s.fill = true
    assert_equal :fill_rect, @s.render
  end
  
  def test_render_transparent
    @s.alpha = 128
    assert_equal :draw_rect_alpha, @s.render
  end
  
  def test_render_transparent_filled
    @s.alpha = 128
    @s.fill = true
    assert_equal :draw_filled_rect_alpha, @s.render
  end
end

#class TC_Font < Test::Unit::TestCase
#end

#class TC_Image < Test::Unit::TestCase
#end

class TC_Wave < Test::Unit::TestCase
  def test_play_loop
    wave = MyGame::Wave.new('FILENAME', :loop)
    channel, data, n_loop = wave.play
    assert_equal -1, channel
    assert_equal 'FILENAME', data.filename
    assert_equal -1, n_loop
  end
  
  def test_play_once
    wave = MyGame::Wave.new('FILENAME')
    channel, data, n_loop = wave.play
    assert_equal -1, channel
    assert_equal 'FILENAME', data.filename
    assert_equal 0, n_loop
  end
  
  def test_play
    wave = MyGame::Wave.new('FILENAME', 667)
    channel, data, n_loop = wave.play
    assert_equal -1, channel
    assert_equal 'FILENAME', data.filename
    assert_equal 666, n_loop
  end
  
  def test_play_with_channel
    wave = MyGame::Wave.new('FILENAME', 667)
    channel, data, n_loop = wave.play(123)
    assert_equal 123, channel
    assert_equal 'FILENAME', data.filename
    assert_equal 666, n_loop
  end
end

class TC_Music < Test::Unit::TestCase
  def test_play
    music = MyGame::Music.new('FILENAME', 667)
    data, n_loop = music.play
    assert_equal 'FILENAME', data.filename
    assert_equal 666, n_loop
  end
  
  def test_play_with_n_loop
    music = MyGame::Music.new('FILENAME', 667)
    data, n_loop = music.play(124)
    assert_equal 'FILENAME', data.filename
    assert_equal 123, n_loop
  end
  
  def test_stop
    assert_throws(:sdl_mixer_halt_music){ MyGame::Music.stop }
  end
end

