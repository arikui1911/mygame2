require 'sdl'
require 'singleton'
require 'kconv'
require 'rbconfig'
begin
  require 'win32ole'
rescue LoadError
end


# MyGame module.
module MyGame
  # Singleton instance which contains MyGame main functions.
  class Core
    # Defines module function which delegates to
    # Core's instance method which is the same name
    # to MyGame module.
    # 
    def self.mygame_function(*names)
      MyGame.module_eval{
        names.each do |name|
          define_method(name){|*args, &block| Core.instance.__send__(name, *args, &block) }
        end
        module_function *names
      }
    end
    private_class_method :mygame_function
    
    include Singleton
    
    # Screen instance
    attr_accessor   :screen
    mygame_function :screen, :screen=
    
    # FPS value
    attr_accessor   :fps
    mygame_function :fps, :fps=
    
    # really measured FPS value
    attr_reader     :real_fps
    mygame_function :real_fps
    
    # background color [R, G, B]
    attr_writer     :background_color
    
    # background color [R, G, B] (default: [0, 0, 0])
    def background_color
      @background_color ||= [0, 0, 0]
    end
    mygame_function :background_color, :background_color=
    
    # Has main_loop() been already called or not?
    def ran_main_loop?
      @ran_main_loop_p ? true : false
    end
    mygame_function :ran_main_loop?
    
    SDL_INIT_FLAGS = {
      :audio => SDL::INIT_AUDIO,
      :video => SDL::INIT_VIDEO,
    }
    
    # Initialize system.
    # 
    # _subsystems_ is a symbol list of initializing target subsystems (any of [:audio, :video])
    # 
    # (default: [:audio, :video])
    # 
    def init(*subsystems)
      subsystems.push(:audio, :video) if subsystems.empty?
      flags = subsystems.map{|k| SDL_INIT_FLAGS.fetch(k) }.inject(:|)
      if @ran_init
        raise "subsystems already initialized and different composition" unless @ran_init == flags
        return
      end
      raise "subsystems initialize fault" if SDL.inited_system(flags) > 0
      @ran_init = flags
      init_events
      SDL.init(flags)
      SDL::Mixer.open if subsystems.include?(:audio)
      SDL::Mixer.allocate_channels(16)
      SDL::TTF.init
    end
    mygame_function :init
    
    # Quit.
    def quit
      exit
    end
    mygame_function :quit
    
    # Generate screen instance.
    # 
    # Generated one is able to be refered by Core#screen.
    # 
    def create_screen(w = 640, h = 480, bpp = 16, flags = SDL::SWSURFACE)
      init
      self.screen ||= SDL.set_video_mode(w, h, bpp, flags).tap{|o|
        def o.update(x = 0, y = 0, w = 0, h = 0)
          update_rect(x, y, w, h)
        end
      }
    end
    mygame_function :create_screen
    
    # Run into a main loop.
    # 
    # The loop's content is a given block.
    # 
    def main_loop(fps = 60)
      self.fps = fps
      @ran_main_loop_p = true
      init_sync
      drive_mainloop do
        poll_event
        if block_given?
          screen.fill_rect(0, 0, screen.w, screen.h, background_color) if background_color
          yield(screen)
        end
        sync
        screen.flip
      end
    end
    mygame_function :main_loop
    
    # Check key is pressed or not. (_key_; MyGame::Key constants)
    def key_pressed?(key)
      SDL::Key.press?(key)
    end
    mygame_function :key_pressed?
    
    # Check key is pressed fresh-ly or not.
    # (_key_; MyGame::Key constants)
    def new_key_pressed?(key)
      flag = last_keys[key] || SDL::Key.press?(key)
      last_keys[key] = SDL::Key.press?(key)
      flag
    end
    mygame_function :new_key_pressed?
    
    # Initialize event registations.
    # 
    # Event :quit and :key_down (escape key) are bound to
    # quit main loop by tag :close.
    # 
    def init_events
      @events = Events.new
      add_event(:quit, :close){ break_mainloop }
      add_event(:key_down, :close){|e| break_mainloop if e.sym == Key::ESCAPE }
    end
    mygame_function :init_events
    
    # See Events#add.
    def add_event(event, tag = nil, &block)
      @events.add(event, tag, &block)
    end
    mygame_function :add_event
    
    # See Events#remove.
    def remove_event(event, tag = nil)
      @events.remove(event, tag)
    end
    mygame_function :remove_event
    
    private
    
    # Reserved by MyGame
    TAG_MAINLOOP_BREAK = :mygame_reserved_symbol_to_break_mainloop_which_correspond_to_drive_mainloop
    
    def drive_mainloop(&block)
      catch(TAG_MAINLOOP_BREAK){ loop(&block) }
    end
    
    def break_mainloop
      throw TAG_MAINLOOP_BREAK
    end
    
    def poll_event
      @events.poll
    end
    
    def last_keys
      @last_keys ||= {}
    end
    
    def init_sync
      @real_fps = @count = 0
      @tm_start = @ticks = SDL.get_ticks
    end
    
    def sync
      fps > 0 and (d = @ticks + 1000 / fps - SDL.get_ticks) > 0 and SDL.delay(d)
      @ticks = SDL.get_ticks
      @count += 1
      if @count += 30
        @count = 0
        @real_fps = 30 * 1000 / (@ticks - @tm_start)
        @tm_start = @ticks
      end
    end
  end #class Core
  
  # Implements cache.
  # 
  # An extendee has to respond to #certain_load privately.
  # It is a loader and cache its result.
  # 
  module Cacheable
    # Hash-like cache table
    def cache
      @cache ||= {}
    end
    
    # Returns the cached or calls #certain_load().
    # 
    # It delegates _features_ to #certain_load() as arguments.
    # 
    def load(*features)
      feature = features.size == 1 ? features.first : features.freeze
      cache[feature] ||= certain_load(*features)
    end
  end
  
  # Abstract superclass of drawees.
  class DrawPrimitive
    # Refers screen instance
    def self.screen
      @screen ||= Core.instance.screen
    end
    
    # Receives _args_ as a keyword-argument-hash.
    # 
    # [x]        position (default: 0)
    # [y]        position (default: 0)
    # [w]        width (pixel)
    # [h]        height (pixel)
    # [offset_x] offset (default: 0)
    # [offset_y] offset (default: 0)
    # [alpha]    alpha value (default: 255)
    # [hide]     draw or not
    # 
    def initialize(args = {})
      self.screen = self.class.screen
      rest = interpret_args(args)
      rest.empty? or raise ArgumentError, "invalid argument key - #{rest[0].inspect}"
    end
    
    private
    
    def interpret_args_frame(args, rest = args.keys)
      fetched = []
      fetcher = lambda{|key, ifnone|
        fetched << key
        args.fetch(key, ifnone)
      }
      yield(fetcher)
      rest - fetched
    end
    
    def interpret_args(args)
      interpret_args_frame(args) do |fetch|
        self.x        = fetch[:x, 0]
        self.y        = fetch[:y, 0]
        self.w        = fetch[:w, nil]
        self.h        = fetch[:h, nil]
        self.offset_x = fetch[:offset_x, 0]
        self.offset_y = fetch[:offset_y, 0]
        self.alpha    = fetch[:alpha, 255]
        self.hide     = fetch[:hide, false]
      end
    end
    
    public
    
    # position (default: 0)
    attr_accessor :x, :y
    
    # width (pixel)
    attr_accessor :w
    
    # height (pixel)
    attr_accessor :h
    
    # offset (default: 0)
    attr_accessor :offset_x, :offset_y
    
    # alpha value (default: 255)
    attr_accessor :alpha
    
    # draw or not
    attr_accessor :hide
    
    # A drawing destination (default: self.class.screen)
    attr_accessor :screen
    
    # draw or not
    alias hide? hide
    
    # Judge collision of self and _target_.
    def hit?(target)
      return if hide?
      return unless @disp_x && @disp_y
      SDL::CollisionMap.bounding_box_check(@disp_x, @disp_y, w, h, target.x, target.y, 1, 1)
    end
    
    # Updates a self condition.
    def update
      ;
    end
    
    # Does draw
    def render
      ;
    end
    
    private
    
    def renderable?
      not hide?
    end
    
    def if_renderable
      renderable? ? yield() : (@disp_x = @disp_y = nil)
    end
  end #class DrawPrimitive
  
  class Square < DrawPrimitive
    def initialize(x = 0, y = 0, w = 0, h = 0, args = {})
      super(args)
      self.x = x
      self.y = y
      self.w = w
      self.h = h
    end
    
    def interpret_args(args)
      interpret_args_frame(args, super(args)) do |fetch|
        self.color = fetch[:color, [255, 255, 255]]
        self.fill  = fetch[:fill,  false]
      end
    end
    private :interpret_args
    
    attr_accessor :color
    attr_accessor :fill
    
    alias filled? fill
    
    def render
      if_renderable do
        x = @x + offset_x
        y = @y + offset_y
        @disp_x, @disp_y = x, y
        return if alpha <= 0
        args = [x, y, w, h, color]
        alpha < 255 ? render_alpha(args) : render_not_alpha(args)
      end
    end
    
    private
    
    def render_alpha(args)
      args << alpha
      screen.__send__(filled? ? :draw_filled_rect_alpha : :draw_rect_alpha, *args)
    end
    
    def render_not_alpha(args)
      screen.__send__(filled? ? :fill_rect : :draw_rect, *args)
    end
  end #class Square
  
  class Font < DrawPrimitive
    DEFAULT_TTF  = 'VL-Gothic-Regular.ttf'
    DEFAULT_SIZE = 16
    
    def self.default_size
      @default_size
    end
    
    def self.default_size=(val)
      @default_size = val
    end
    
    def self.default_ttf_path
      @default_ttf_path
    end
    
    def self.default_ttf_path=(val)
      @default_ttf_path = val
    end
    
    def self.ttf_lookup(font_name)
      ttf_font_directories.map{|d| File.join(d, font_name) }.find{|path| File.exist?(path) }
    end
    
    def self.ttf_font_directories
      @ttf_font_directories ||= []
    end
    
    self.ttf_font_directories.push('./fonts', File.join(Config::CONFIG['datadir'], 'mygame'))
    self.ttf_font_directories << WIN32OLE.new('WScript.Shell').SpecialFolders('Fonts') if defined?(WIN32OLE)
    
    self.default_ttf_path = self.ttf_lookup(DEFAULT_TTF)
    self.default_size     = DEFAULT_SIZE
    
    extend Cacheable
    
    def self.certain_load(ttf_path, size)
      font = SDL::TTF.open(ttf_path, size)
      font.style = SDL::TTF::STYLE_NORMAL
      font
    end
    private_class_method :certain_load
    
    def initialize(str = '', args = {})
      super(args)
      @string = Kconv.toutf8(str)
      update
    end
    
    def interpret_args(args)
      interpret_args_frame(args, super(args)) do |fetch|
        self.size     = fetch[:size,     self.class.default_size]
        self.ttf_path = fetch[:ttf_path, self.class.default_ttf_path]
        self.color    = fetch[:color,    [255, 255, 255]]
        self.smooth   = fetch[:smooth,   false]
        self.shadow   = fetch[:shadow,   false]
      end
    end
    private :interpret_args
    
    attr_reader   :size
    attr_reader   :ttf_path
    attr_reader   :color
    attr_reader   :shadow
    attr_accessor :smooth
    
    def shadow?
      shadow ? true : false
    end
    
    alias smooth? smooth
    
    def size=(arg)
      @size = attr_writer_rval(:size, arg)
    end
    
    def ttf_path=(arg)
      @ttf_path = attr_writer_rval(:ttf_path, arg)
    end
    
    def color=(arg)
      @color = attr_writer_rval(:color, arg)
    end
    
    DEFAULT_SHADOW = [64, 64, 64]
    
    def shadow=(arg)
      arg = DEFAULT_SHADOW if arg == true
      @shadow = attr_writer_rval(:shadow, arg)
    end
    
    def update
      update_modifies
    end
    
    def render
      update_modifies
      if_renderable do
        x, y = self.x + offset_x, self.y + offset_y
        disp_w, disp_h = w >= @max_w ? [0, 0] : [w, h + @dy]
        @disp_x, @disp_y = x, y
        return if alpha <= 0
        @surface.set_alpha(SDL::SRCALPHA, alpha) if alpha < 255
        SDL.blit_surface @surface, 0, 0, disp_w, disp_h, screen, x, y
      end
    end
    
    private
    
    def create_surface
      self.w, self.h = @font.text_size(@string)
      @max_w, @max_h = w, h
      @dx = @dy = shadow? ? 1 + size / 24 : 0
      surface = SDL::Surface.new(SDL::SWSURFACE, w + @dx, h + @dy, 32, *mask_rgba())
      [@dx, 0].each{|dx| @font.draw_solid_utf8(surface, @string, dx, @dy, *shadow) } if shadow?
      @font.__send__(smooth? ? :draw_blended_utf8 : :draw_solid_utf8, surface, @string, 0, 0, *color)
      surface.set_color_key SDL::SRCCOLORKEY, surface.get_pixel(0, 0)
      surface.display_format
    end
    
    def update_modifies
      if @modified
        @modified = false
        @font = self.class.load(ttf_path, size)
        @surface = create_surface()
      end
    end
    
    def renderable?
      super && @surface
    end
    
    def last_values
      @last_values ||= {}
    end
    
    def attr_writer_rval(name, arg)
      unless last_values[name] == arg
        @modified = true
        last_values[name] = arg
      end
      last_values[name]
    end
    
    def mask_rgba
      @mask_rgba ||= [0x000000ff, 0x0000ff00, 0x00ff0000, 0xff000000].tap{|mask|
        big_endian_p = ([1].pack("N") == [1].pack("L"))
        mask.reverse! if big_endian_p
      }
    end
  end #class Font
  
  class Image < DrawPrimitive
    extend Cacheable
    
    def self.certain_load(filename, pixel = nil)
      image = SDL::Surface.load(filename).display_format
      if pixel
        image.set_color_key SDL::SRCCOLORKEY, pixel
        image = image.display_format
      end
      image
    end
    private_class_method :certain_load
    
    def initialize(filename, args = {})
      super(args)
      @filename = filename
      @animations = Animations.new
      @ox = @oy = 0
      update
      self.w ||= @image.w
      self.h ||= @image.h
    end
    
    def interpret_args(args)
      interpret_args_frame(args, super(args)) do |fetch|
        self.angle       = fetch[:angle, 0]
        self.scale       = fetch[:scale, 1]
        self.transparent = fetch[:transparent, false]
      end
    end
    private :interpret_args
    
    attr_accessor :angle
    attr_accessor :scale
    
    attr_reader :transparent
    
    def transparent?
      transparent? ? true : false
    end
    
    DEFAULT_TRANSPARENT_POINT = [0, 0]
    
    def transparent=(arg)
      arg = DEFAULT_TRANSPARENT_POINT if arg == true
      @modified = true
      @transparent = arg
    end
    
    def update
      update_modifies
      update_animation
    end
    
    def render
      update_modifies
      if_renderable do
        @disp_x = x = @x + offset_x
        @disp_y = y = @y + offset_y
        return if @alpha <= 0
        img = alpha < 255 ? alpha_image(alpha) : @image
        if scale == 1 && angle == 0 then SDL.blit_surface(img, @ox, @oy, w, h, screen, x, y)
        else SDL.transform_blit(img, screen, angle, scale, scale, w / 2, h / 2, x, y, 0)
        end
      end
    end
    
    def start_animation(label, force_restart = false)
      @animations.start(label, force_restart)
    end
    
    def stop_animation
      @animations.stop
    end
    
    def add_animation(table)
      table.each{|label, params| set_animation(label, *params) }
    end
    
    private
    
    def update_modifies
      if @modified
        @modified = false
        @alpha_image = nil
        @image = self.class.load(@filename)
        @image = self.class.load(@filename, @image.get_pixel(0, 0)) if transparent
      end
    end
    
    def alpha_image(alpha)
      (@alpha_image ||= @image.display_format).tap{|img| img.set_alpha(SDL::SRCALPHA, alpha) }
    end
    
    def renderable?
      super && @image
    end
    
    def set_animation(label, time, pattern, following = :loop)
      raise "invalid label - `#{label}'" if label == :loop
      @animations[label] = Animation.new(time, pattern, following)
    end
    
    def update_animation
      return unless offset = @animations.update
      n = @image.w / w
      @ox = offset % n * w
      @oy = offset / n * h
    end
  end #class Image
  
  Animation = Struct.new(:time, :patten, :following)
  
  class Animations
    def initialize
      @counter = 0
      @table = {}
    end
    
    def [](label)
      @table[label]
    end
    
    def []=(label, animation)
      @table[label] = animation
    end
    
    def start(label, force_restart = false)
      self[label] or raise IndexError, "missing animation - `#{label}'"
      return if @current == label && !force_restart
      @counter = 0
      @current = label
    end
    
    def stop
      @current = nil
    end
    
    # -> offset
    def update
      return unless @current
      anime = self[@current]
      idx = @counter / anime.time
      if idx >= anime.patten.size
        case anime.following
        when nil   then (stop ; return)
        when :loop then nil
        else
          start anime.following
          anime = self[@current]
        end
        @counter = idx = 0
      end
      @counter += 1
      anime.patten[idx]
    end
  end #class Animations
  
  class Wave
    extend Cacheable
    
    def self.certain_load(filename)
      SDL::Mixer::Wave.load(filename)
    end
    private_class_method :certain_load
    
    def initialize(filename, n_loop = 1)
      @sound = self.class.load(filename)
      self.n_loop = n_loop
    end
    
    attr_accessor :n_loop
    
    def play(channel = :auto)
      SDL::Mixer.play_channel(sdl_channel(channel), @sound, sdl_n_loop(n_loop))
    end
    
    private
    
    def sdl_channel(n)
      n == :auto ? -1 : n
    end
    
    def sdl_n_loop(n)
      n == :loop ? -1 : n - 1
    end
  end #class Wave
  
  class Music < Wave
    def self.certain_load(filename)
      SDL::Mixer::Music.load(filename)
    end
    private_class_method :certain_load
    
    def self.stop
      SDL::Mixer.halt_music
    end
    
    def play(n_loop = self.n_loop)
      SDL::Mixer.play_music(@sound, sdl_n_loop(n_loop))
    end
  end #class Music
  
  module Key
    include SDL::Key
  end
  
  class Events
    def initialize
      @root = {}
      SDL_EVENT_MAP.values.each{|e| @root[e] = {} }
      yield self if block_given?
    end
    
    def poll
      while event = SDL::Event2.poll
        e = SDL_EVENT_MAP[event.class] or next
        @root[e].each{|tag, block| block.call(event) }
      end
      SDL::Key.scan
    end
    
    SDL_EVENT_MAP = {
      SDL::Event2::Active          => :active,
      SDL::Event2::KeyDown         => :key_down,
      SDL::Event2::KeyUp           => :key_up,
      SDL::Event2::MouseMotion     => :mouse_motion,
      SDL::Event2::MouseButtonDown => :mouse_button_down,
      SDL::Event2::MouseButtonUp   => :mouse_button_up,
      SDL::Event2::JoyAxis         => :joy_axis,
      SDL::Event2::JoyBall         => :joy_ball,
      SDL::Event2::JoyHat          => :joy_hat,
      SDL::Event2::JoyButtonDown   => :joy_button_down,
      SDL::Event2::JoyButtonUp     => :joy_button_up,
      SDL::Event2::Quit            => :quit,
      SDL::Event2::VideoResize     => :video_resize,
    }
    
    def add(event, tag = nil, &block)
      table = @root[event] or raise "invalid event - `#{event}'"
      tag ||= block.object_id
      table[tag] = block
      tag
    end
    
    def remove(event, tag = nil)
      tag ? @root[event].delete(tag) : @root[event].clear
    end
  end #class Events
end

