# coding: sjis

= MyGame Reference

 * ((<MyGame>))
   * ((<MyGame::Cacheable>))
   * ((<MyGame::DrawPrimitive>))
   * ((<MyGame::Image>))
   * ((<MyGame::Font>))
   * ((<MyGame::Square>))
   * ((<MyGame::Wave>))
   * ((<MyGame::Music>))
   * ((<MyGame::Scene>))
     * ((<MyGame::Scene::Base>))
     * ((<MyGame::Scene::Exit>))



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

== MyGame

 * @library: mygame.rb


=== Instance Methods

--- MyGame.add_event(event, tag = nil, &block)
    �C�x���g������ǉ����܂��B ((|event|)) �̓V���{���Ŏw�肵�܂��B
    
    ((|event|)) �Ɏw��ł���V���{���ɂ͎��̂��̂�����܂��B
    
    : :active
      �}�E�X�J�[�\���̃E�C���h�E�̏o����A�L�[�{�[�h�t�H�[�J�X�̓����A����эŏ����E�A�C�R����
      ���ꂽ�茳�ɖ߂����Ƃ��ɔ������܂��B
    : :key_down
      �L�[�{�[�h���������Ƃ��ɔ�������C�x���g�ł��B
    : :key_up
      �L�[�{�[�h�𗣂����Ƃ��ɔ�������C�x���g�ł��B
    : :mouse_motion
      �}�E�X�𓮂������Ƃ��ɔ�������C�x���g�ł��B
    : :mouse_button_down
      �}�E�X�{�^�����������Ƃ��̃C�x���g�ł��B
    : :mouse_button_up
      �}�E�X�{�^���𗣂����Ƃ��̃C�x���g�ł��B
    : :joy_axis joy_ball
      ���[�U���W���C�X�e�B�b�N�̎����ړ�������Ƃ��̃C�x���g���������܂��B
    : :joy_hat joy_button_up
      �W���C�X�e�B�b�N�̃g���b�N�{�[���̓����C�x���g�ł��B
    : :joy_button_down
      �W���C�X�e�B�b�N�̃n�b�g�X�C�b�`�̈ʒu�ω��C�x���g�ł��B
    : :quit
      �I���v���C�x���g�ł��B
    : :video_resize
      �E�B���h�E�����T�C�Y���ꂽ���́A���̃C�x���g���������܂��B
    
    ((|event|)) ���ƂɁA�����̏�����ǉ��ł��܂����A���̍� ((|tag|)) ���w�肵�Ă���ƁA
    ((<remove_event|MyGame.remove_event>)) �ł��̏�����������菜�����Ƃ��ł��܂�
    (�t�Ɍ����ƁA ((|tag|)) ���w�肵�Ă��Ȃ������͂܂Ƃ߂ď����ȊO����܂���)�B
    
--- MyGame.background_color
--- MyGame.background_color=([r, g, b])
    �w�i�F
--- MyGame.create_screen(w = 640, h = 480, bpp = 16, flags = SDL::SWSURFACE)
    �X�N���[���𐶐����܂��B
    �f�t�H���g�ł� 640x480 �̃X�N���[������������܂��B
--- MyGame.fps
--- MyGame.fps=(n)
    FPS
--- MyGame.init(*subsystems)
    MyGame �����������܂��B
    
    ((|subsystems|)) �͏ȗ������� (({[:audio, :video]})) �ł��B
--- MyGame.init_events
    �C�x���g�����������܂��B
    ���̃��\�b�h�����s����Ɠo�^����Ă���C�x���g�͂��ׂăN���A����܂��B
--- MyGame.key_pressed?(key)
    �L�[���͂̃`�F�b�N���s���܂��B
--- MyGame.main_loop(fps = 60)
    ���C�����[�v�����s���܂��B
    ���C�����[�v���Ŏ��s���鏈�����u���b�N�œn���܂��B
--- MyGame.new_key_pressed?(key)
    �V�K�L�[���͂̃`�F�b�N���s���܂��B
--- MyGame.quit
    MyGame ���I�����܂��B
--- MyGame.ran_main_loop?
    ((<main_loop|MyGame.main_loop>)) ���Ă΂�ς݂��ǂ���
--- MyGame.real_fps
    FPS �̎����l
--- MyGame.remove_event(event, tag = nil)
    �C�x���g�������폜���܂��B
    
    ((|tag|)) �� nil ���ƁA ((|event|)) �Ɋ֘A�t����ꂽ�������S�č폜����܂��B
--- MyGame.screen
--- MyGame.screen=(scr)
    �X�N���[���I�u�W�F�N�g�B
    ((<screen=|MyGame.screen=>)) �͒ʏ�A((<create_screen|MyGame.create_screen>)) ������̂�
    �g���K�v�͂���܂���B



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

== MyGame::Cacheable

 * @library: mygame.rb

Ruby/SDL �� API �ŉ摜��T�E���h�̃I�u�W�F�N�g�𐶐�����N���X��
extend ���āA���̃L���b�V�����s�Ȃ��B

extend ��ɂ� certain_load ����������Ă��邱�Ƃ����҂���B


=== Instance Methods

--- MyGame::Cacheable#cache
    �L���b�V���e�[�u���B Hash �����Ɉ�����B
--- MyGame::Cacheable#load(*features)
    �I�u�W�F�N�g�𐶐��A�܂��̓L���b�V����Ԃ��B
    
    ((|features|)) �̓L���b�V���e�[�u���̃L�[�ł���A #certain_load �Ɋۓ��������
    �����ł�����B
    
    �L���b�V���Ƀq�b�g���Ȃ���΁A���̃��\�b�h�� #certain_load ���Ă��
    ���̌��ʂ��L���b�V������B



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

== MyGame::DrawPrimitive

 * @library: mygame.rb

�e�`��v�f�̒��ۃX�[�p�[�N���X�B


=== Singleton Methods

--- MyGame::DrawPrimitive.new(args = {})
    �[���L�[���[�h�������󂯎��܂��B
    
    : :x [=> 0]
      �`����W
    : :y [=> 0]
      �`����W
    : :w
      �`�敝(�s�N�Z��)
    : :h
      �`�敝(�s�N�Z��)
    : :offset_x [=> 0]
      �`��I�t�Z�b�g
    : :offset_y [=> 0]
      �`��I�t�Z�b�g
    : :alpha [=> 255]
      �A���t�@�l
    : :hide [=> false]
      �`�悷�邩�ǂ���
--- MyGame::DrawPrimitive.screen
    ((<MyGame.screen>)) ���Q�Ƃ��܂��B


=== Instance Methods

--- MyGame::DrawPrimitive#alpha
--- MyGame::DrawPrimitive#alpha=(value)
    �A���t�@�l
--- MyGame::DrawPrimitive#h
--- MyGame::DrawPrimitive#h=(n)
    �`�敝(�s�N�Z��)
--- MyGame::DrawPrimitive#hide
--- MyGame::DrawPrimitive#hide=(bool)
--- MyGame::DrawPrimitive#hide?
    �`�悷�邩�ǂ���
--- MyGame::DrawPrimitive#hit?(target)
    �Փ˔���B
    
    ((|target|)).x, ((|target|)).y ���`�敨��ɂ���ꍇ�� true ��Ԃ��܂��B
--- MyGame::DrawPrimitive#offset_x
--- MyGame::DrawPrimitive#offset_x=(n)
    �`��I�t�Z�b�g
--- MyGame::DrawPrimitive#offset_y
--- MyGame::DrawPrimitive#offset_y=(n)
    �`��I�t�Z�b�g
--- MyGame::DrawPrimitive#render
    ((<#screen|MyGame::DrawPrimitive#screen>)) �ɕ`�悷��B
--- MyGame::DrawPrimitive#screen
--- MyGame::DrawPrimitive#screen=
    �`���X�N���[���B�f�t�H���g�ł� ((<MyGame::DrawPrimitive.screen>)) �B
--- MyGame::DrawPrimitive#update
    �`����e�Ȃǂ̍X�V���s�Ȃ��B
--- MyGame::DrawPrimitive#w
--- MyGame::DrawPrimitive#w=(n)
    �`�敝(�s�N�Z��)
--- MyGame::DrawPrimitive#x
--- MyGame::DrawPrimitive#x=(n)
    �`����W
--- MyGame::DrawPrimitive#y
--- MyGame::DrawPrimitive#y=(n)
    �`����W



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

== MyGame::Image

 * @inherit: ((<MyGame::DrawPrimitive>))
 * @extend:  ((<MyGame::Cacheable>))
 * @library: mygame.rb

���ߕ\�����\�ȉ摜�`��������N���X�B


=== Singleton Methods

--- MyGame::Image.new(filename, args = {})
    �摜�`��������I�u�W�F�N�g�𐶐����܂��B
    
    : filename
      �摜�t�@�C�������w�肵�܂��B
      
      �Ή����Ă���t�H�[�}�b�g�� BMP, PNM (PPM/PGM/PBM), XPM,
      XCF, PCX, GIF, JPEG, TIFF, TGA, PNG, LBM �ł��B
    : args
      �[���L�[���[�h�����ł��B
      �X�[�p�[�N���X ((<MyGame::DrawPrimitive>)) �̃C���^�[�t�F�C�X��
      �p�����Ă��܂��B
      
      : :angle [=> 0]
        �摜�̒��_�𒆐S�Ƃ�����]�p�B360 �� 1 ��]
      : :scale [=> 1]
        �g��E�k�����B��l�� 1.0
      : :transparent [=> false]
        ���߉摜�Ƃ��Ĉ������ۂ��B
        ���߂�����ꍇ�A���ߐF�ƂȂ�F���摜�̂���s�N�Z������擾���܂����A
        ���̈ʒu��^���܂��Btrue ��^����ƃf�t�H���g��
        ����([0, 0])������܂��B


=== Instance Methods

--- MyGame::Image#add_animation(table)
    �A�j���[�V�����E�p�^�[����ǉ����܂��B
    ((|table|)) �̓��x��(�A�j���[�V�����̎��ʎq�ƂȂ� Symbol )���L�[��
    �p�����[�^�̔z���������G���g���̃R���N�V�����ł�
    (�[���L�[���[�h������ Hash ���󂯎�邱�Ƃ�z�肵�Ă��܂�)�B
--- MyGame::Image#angle
--- MyGame::Image#angle=(value)
    �摜�̒��_�𒆐S�Ƃ�����]�p�B360 �� 1 ��]�B
--- MyGame::Image#render
    �X�N���[���ɉ摜��`�悷��B
--- MyGame::Image#scale
--- MyGame::Image#scale=(value)
    �g��E�k�����B��l�� 1.0 �B
--- MyGame::Image#start_animation(label, force_restart = false)
    ((|label|)) �Ɋ֘A�t����ꂽ�A�j���[�V�������J�n���܂��B
    ���̃A�j���[�V���������Ɏ��s���Ȃ�΁A ((|force_restart|)) ���^�łȂ�����
    �������܂���B
--- MyGame::Image#stop_animation
    ���݂̃A�j���[�V�������~���܂��B
    (�A�j���[�V�������łȂ���Ή����N����܂���)
--- MyGame::Image#transparent
--- MyGame::Image#transparent=([x, y])
    ���ߐF�̈ʒu�B���߂����Ȃ��ꍇ�� false �B�f�t�H���g�l���g���Ȃ� true �B
--- MyGame::Image#transparent?
    ���߂���Ă��邩�ǂ����B
--- MyGame::Image#update
    �ύX�𔽉f����B



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

== MyGame::Font

 * @inherit: ((<MyGame::DrawPrimitive>))
 * @extend:  ((<MyGame::Cacheable>))
 * @library: mygame.rb

����t�H���g�ɂ�镶����̕`��������N���X�B
�e�t���\����A���`�G�C���A�X�\�����\�B


=== Singleton Methods

--- MyGame::Font.default_size
--- MyGame::Font.default_size=(point)
    �f�t�H���g�̃t�H���g�T�C�Y�B
--- MyGame::Font.default_ttf_path
--- MyGame::Font.default_ttf_path=(path)
    �f�t�H���g�� TTF �t�H���g�t�@�C���̃p�X�B
--- MyGame::Font.new(str = '', args = {})
    �t�H���g�`��I�u�W�F�N�g�𐶐����܂��B
    
    : str
      �`�悷�镶����B
    : args
      �[���L�[���[�h�����ł��B
      �X�[�p�[�N���X ((<MyGame::DrawPrimitive>)) �̃C���^�[�t�F�C�X��
      �p�����Ă��܂��B
      
      : :size [=> MyGame::Font.default_size]
        �t�H���g�T�C�Y
      : :ttf_path [=> MyGame::Font.default_ttf_path]
        �g�p���� TTF �t�H���g�t�@�C���̃p�X
      : :color [=> [255, 255, 255]]
        �t�H���g�̐F ([R, G, B])
      : :smooth [=> false]
        �A���`�G�C���A�X��L���ɂ��邩�ǂ���
      : :shadow [=> false]
        �e�̐F ([R, G, B])�B�e�t�������Ȃ��ꍇ�� false�B
        true ���^����ꂽ�ꍇ�� ((<Font|MyGame::Font>))::DEFAULT_SHADOW �B
--- MyGame::Font.ttf_font_directories
    �t�H���g�����p�X�̔z��
--- MyGame::Font.ttf_lookup(font_name)
    TTF �t�H���g�t�@�C���� ((<ttf_font_directories|MyGame::Font.ttf_font_directories>)) ����
    �������܂��B
    
    ����̃f�B���N�g���Ƃ́A�u./font�v �� �uRuby�̃f�B���N�g��/share/mygame�v ��
    (Win32 �̏ꍇ �uC:/Windows/Font�v �̂悤�ȓ���t�H���_���܂�) �ł��B


=== Instance Methods

--- MyGame::Font#color
--- MyGame::Font#color=([r, g, b])
    �t�H���g�̐F ([R, G, B])
--- MyGame::Font#render
    �X�N���[���ɕ������`�悷��B
--- MyGame::Font#shadow
--- MyGame::Font#shadow=([r, g, b])
    �e�̐F ([R, G, B])�B�e�t�������Ȃ��ꍇ�� false�B
    true ���^����ꂽ�ꍇ�� ((<Font|MyGame::Font>))::DEFAULT_SHADOW �B
--- MyGame::Font#shadow?
    �e�t������Ă��邩�ǂ����B
--- MyGame::Font#size
--- MyGame::Font#size=(point)
    �t�H���g�T�C�Y
--- MyGame::Font#smooth
--- MyGame::Font#smooth=(bool)
--- MyGame::Font#smooth?
    �A���`�G�C���A�X��L���ɂ��邩�ǂ���
--- MyGame::Font#ttf_path
--- MyGame::Font#ttf_path=(path)
    �g�p���� TTF �t�H���g�t�@�C���̃p�X
--- MyGame::Font#update
    �ύX�𔽉f���܂��B



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

== MyGame::Square

 * @inherit: ((<MyGame::DrawPrimitive>))
 * @extend:  ((<MyGame::Cacheable>))
 * @library: mygame.rb

�����`�̕`��������N���X�B


=== Singleton Methods

--- MyGame::Square.new(x = 0, y = 0, w = 0, h = 0, args = {})
    �����`�̕`��������I�u�W�F�N�g�𐶐����܂��B
    
    : args
      �[���L�[���[�h�����ł��B
      �X�[�p�[�N���X ((<MyGame::DrawPrimitive>)) �̃C���^�[�t�F�C�X��
      �p�����Ă��܂��B
      
      : :color [=> [255, 255, 255]]
        �`��ɗp����F ([R, G, B])�B
      : :fill [=> false]
        �̈����h��Ԃ����ǂ����B


=== Instance Methods

--- MyGame::Square#color
--- MyGame::Square#color=([r, g, b])
    �`��ɗp����F ([R, G, B])�B
--- MyGame::Square#fill
--- MyGame::Square#fill=(bool)
--- MyGame::Square#filled?
    �̈����h��Ԃ����ǂ����B
--- MyGame::Square#render
    �X�N���[���ɒ����`��`�悷��B



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

== MyGame::Wave

 * @extend:  ((<MyGame::Cacheable>))
 * @library: mygame.rb

���ʉ���A���̉��t�������N���X�B


=== Singleton Methods

--- MyGame::Wave.new(filename, n_loop = 1)
    �T�E���h�������I�u�W�F�N�g�𐶐����܂��B
    
    : filename
      �����t�@�C�������w�肵�܂��B
      
      WAVE, AIFF, RIFF, OGG, VOC �ɑΉ����Ă��܂��B
    : n_loop
      �J��Ԃ����t�����
    
    OGG �����[�h�����ꍇ�A���[�h���ɂ��ׂẴf�[�^����������� RAW �f�[�^�Ƃ���
    �W�J�����̂ŁA�������g�p�ʂɒ��ӂ��Ă��������B


=== Instance Methods

--- MyGame::Wave#n_loop
--- MyGame::Wave#n_loop=(n)
    �J��Ԃ����t����񐔁B
    ���ʂ͐��l�ł����A (({:loop})) �͖����ɌJ��Ԃ����邱�Ƃ��Ӗ����܂��B
--- MyGame::Wave#play(channel = :auto)
    �T�E���h���Đ����܂��B
    
    ((|channel|)) �̓T�E���h��炷�`�����l���œK�؂Ȑ��l�ł����A (({:auto})) ��
    �����w����Ӗ����܂��B



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

== MyGame::Music

 * @inherit: ((<MyGame::Wave>))
 * @extend:  ((<MyGame::Cacheable>))
 * @library: mygame.rb

BGM �Ɏg���悤�ȉ��y��A���̉��t�������N���X�B


=== Singleton Methods

--- MyGame::Music.new(filename, n_loop = 1)
    �y�Ȃ������I�u�W�F�N�g�𐶐����܂��B
    �C���^�[�t�F�C�X�� ((<MyGame::Wave>)) �̂܂܂ł��B
    
    WAVE, MOD, MIDI, OGG, MP3 �ɑΉ����Ă��܂��B
    Windows �ł͊��ɂ���Ă� MP3 �����[�h�ł��Ȃ����Ƃ�����܂��B
--- MyGame::Music.stop
    ���t���̉��y���~�߂܂��B


=== Instance Methods

--- MyGame::Music#play(n_loop = self.n_loop)
    �y�Ȃ����t���܂��B
    ((|n_loop|)) �͌J��Ԃ��񐔂ŁA������ ((<MyGame::Wave>)) �Ɠ����ł��B



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

== MyGame::Scene

 * @library: mygame/scene.rb

�V�[���J�ڃ��f���ɂ��Q�[���쐬��񋟂���B

�V�[����`�� ((<MyGame::Scene::Base>)) ���p�������N���X��`�ɂ���čs�Ȃ��B
�ȉ��A������V�[���N���X�ƌĂԁB


=== Singleton Methods

--- MyGame::Scene.main_loop(scene_class, fps = 60, step = 1)
    �V�[���J�ڃ��f���̃��C�����[�v�����s���܂��B
    ((|scene_class|)) �̓G���g���|�C���g�ƂȂ�V�[���N���X���w�肵�܂��B



== MyGame::Scene::Base

 * @library: mygame/scene.rb

�V�[���N���X�̒��ۃX�[�p�[�N���X�B
���\�b�h���T�u�N���X�œK�؂ɍĒ�`���āA�V�[�����L�q���܂��B


=== Instance Methods

--- MyGame::Scene::Base#frame_counter
    �V�[�����J�n���Ă���̌o�߃t���[�������擾���܂��B
--- MyGame::Scene::Base#init
    �V�[���̊J�n�Ƌ��Ɏ��s�����B
    �T�u�N���X�ŕK�v�Ȃ�΍Ē�`���Ă��������B
--- MyGame::Scene::Base#next_scene
    ���ɑJ�ڂ���V�[���N���X�B
    ���̒l���Z�b�g�����ƁA���̃��[�v�ŃV�[����J�ڂ��܂��B
--- MyGame::Scene::Base#quit
    ���̃V�[���ɑJ�ڂ���O�Ɏ��s�����B
    �T�u�N���X�ŕK�v�Ȃ�΍Ē�`���Ă��������B
--- MyGame::Scene::Base#render
    update ��Ɏ��s�����B
    �T�u�N���X�ŕK�v�Ȃ�΍Ē�`���Ă��������B
--- MyGame::Scene::Base#update
    1 �X�e�b�v���ƂɎ��s�����B
    �T�u�N���X�ŕK�v�Ȃ�΍Ē�`���Ă��������B



== MyGame::Scene::Exit

 * @library: mygame/scene.rb

�V�[���J�ڂ̏I���_�ƂȂ�V�[���N���X�B
���̃V�[���ɑJ�ڂ���ƃ��C�����[�v���I������B



