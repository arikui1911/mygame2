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
    イベント処理を追加します。 ((|event|)) はシンボルで指定します。
    
    ((|event|)) に指定できるシンボルには次のものがあります。
    
    : :active
      マウスカーソルのウインドウの出入り、キーボードフォーカスの得失、および最小化・アイコン化
      されたり元に戻ったときに発生します。
    : :key_down
      キーボードを押したときに発生するイベントです。
    : :key_up
      キーボードを離したときに発生するイベントです。
    : :mouse_motion
      マウスを動かしたときに発生するイベントです。
    : :mouse_button_down
      マウスボタンを押したときのイベントです。
    : :mouse_button_up
      マウスボタンを離したときのイベントです。
    : :joy_axis joy_ball
      ユーザがジョイスティックの軸を移動させるとこのイベントが発生します。
    : :joy_hat joy_button_up
      ジョイスティックのトラックボールの動きイベントです。
    : :joy_button_down
      ジョイスティックのハットスイッチの位置変化イベントです。
    : :quit
      終了要請イベントです。
    : :video_resize
      ウィンドウがリサイズされた時は、このイベントが発生します。
    
    ((|event|)) ごとに、複数の処理を追加できますが、その際 ((|tag|)) を指定していると、
    ((<remove_event|MyGame.remove_event>)) でその処理だけを取り除くことができます
    (逆に言うと、 ((|tag|)) を指定していない処理はまとめて消す以外ありません)。
    
--- MyGame.background_color
--- MyGame.background_color=([r, g, b])
    背景色
--- MyGame.create_screen(w = 640, h = 480, bpp = 16, flags = SDL::SWSURFACE)
    スクリーンを生成します。
    デフォルトでは 640x480 のスクリーンが生成されます。
--- MyGame.fps
--- MyGame.fps=(n)
    FPS
--- MyGame.init(*subsystems)
    MyGame を初期化します。
    
    ((|subsystems|)) は省略されると (({[:audio, :video]})) です。
--- MyGame.init_events
    イベントを初期化します。
    このメソッドを実行すると登録されているイベントはすべてクリアされます。
--- MyGame.key_pressed?(key)
    キー入力のチェックを行います。
--- MyGame.main_loop(fps = 60)
    メインループを実行します。
    メインループ内で実行する処理をブロックで渡します。
--- MyGame.new_key_pressed?(key)
    新規キー入力のチェックを行います。
--- MyGame.quit
    MyGame を終了します。
--- MyGame.ran_main_loop?
    ((<main_loop|MyGame.main_loop>)) が呼ばれ済みかどうか
--- MyGame.real_fps
    FPS の実測値
--- MyGame.remove_event(event, tag = nil)
    イベント処理を削除します。
    
    ((|tag|)) が nil だと、 ((|event|)) に関連付けられた処理が全て削除されます。
--- MyGame.screen
--- MyGame.screen=(scr)
    スクリーンオブジェクト。
    ((<screen=|MyGame.screen=>)) は通常、((<create_screen|MyGame.create_screen>)) があるので
    使う必要はありません。



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

== MyGame::Cacheable

 * @library: mygame.rb

Ruby/SDL の API で画像やサウンドのオブジェクトを生成するクラスが
extend して、そのキャッシュを行なう。

extend 先には certain_load が実装されていることを期待する。


=== Instance Methods

--- MyGame::Cacheable#cache
    キャッシュテーブル。 Hash 相当に扱える。
--- MyGame::Cacheable#load(*features)
    オブジェクトを生成、またはキャッシュを返す。
    
    ((|features|)) はキャッシュテーブルのキーであり、 #certain_load に丸投げされる
    引数でもある。
    
    キャッシュにヒットしなければ、このメソッドは #certain_load を呼んで
    その結果をキャッシュする。



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

== MyGame::DrawPrimitive

 * @library: mygame.rb

各描画要素の抽象スーパークラス。


=== Singleton Methods

--- MyGame::DrawPrimitive.new(args = {})
    擬似キーワード引数を受け取ります。
    
    : :x [=> 0]
      描画座標
    : :y [=> 0]
      描画座標
    : :w
      描画幅(ピクセル)
    : :h
      描画幅(ピクセル)
    : :offset_x [=> 0]
      描画オフセット
    : :offset_y [=> 0]
      描画オフセット
    : :alpha [=> 255]
      アルファ値
    : :hide [=> false]
      描画するかどうか
--- MyGame::DrawPrimitive.screen
    ((<MyGame.screen>)) を参照します。


=== Instance Methods

--- MyGame::DrawPrimitive#alpha
--- MyGame::DrawPrimitive#alpha=(value)
    アルファ値
--- MyGame::DrawPrimitive#h
--- MyGame::DrawPrimitive#h=(n)
    描画幅(ピクセル)
--- MyGame::DrawPrimitive#hide
--- MyGame::DrawPrimitive#hide=(bool)
--- MyGame::DrawPrimitive#hide?
    描画するかどうか
--- MyGame::DrawPrimitive#hit?(target)
    衝突判定。
    
    ((|target|)).x, ((|target|)).y が描画物上にある場合に true を返します。
--- MyGame::DrawPrimitive#offset_x
--- MyGame::DrawPrimitive#offset_x=(n)
    描画オフセット
--- MyGame::DrawPrimitive#offset_y
--- MyGame::DrawPrimitive#offset_y=(n)
    描画オフセット
--- MyGame::DrawPrimitive#render
    ((<#screen|MyGame::DrawPrimitive#screen>)) に描画する。
--- MyGame::DrawPrimitive#screen
--- MyGame::DrawPrimitive#screen=
    描画先スクリーン。デフォルトでは ((<MyGame::DrawPrimitive.screen>)) 。
--- MyGame::DrawPrimitive#update
    描画内容などの更新を行なう。
--- MyGame::DrawPrimitive#w
--- MyGame::DrawPrimitive#w=(n)
    描画幅(ピクセル)
--- MyGame::DrawPrimitive#x
--- MyGame::DrawPrimitive#x=(n)
    描画座標
--- MyGame::DrawPrimitive#y
--- MyGame::DrawPrimitive#y=(n)
    描画座標



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

== MyGame::Image

 * @inherit: ((<MyGame::DrawPrimitive>))
 * @extend:  ((<MyGame::Cacheable>))
 * @library: mygame.rb

透過表示も可能な画像描画を扱うクラス。
元祖 MyGame のアニメーション機能は実装されていない。


=== Singleton Methods

--- MyGame::Image.new(filename, args = {})
    画像描画を扱うオブジェクトを生成します。
    
    : filename
      画像ファイル名を指定します。
      
      対応しているフォーマットは BMP, PNM (PPM/PGM/PBM), XPM,
      XCF, PCX, GIF, JPEG, TIFF, TGA, PNG, LBM です。
    : args
      擬似キーワード引数です。
      スーパークラス ((<MyGame::DrawPrimitive>)) のインターフェイスを
      継承しています。
      
      : :angle [=> 0]
        画像の中点を中心とした回転角。360 で 1 回転
      : :scale [=> 1]
        拡大・縮小率。基準値は 1.0
      : :transparent [=> false]
        透過画像として扱うか否か。
        透過させる場合、透過色となる色を画像のあるピクセルから取得しますが、
        その位置を与えます。true を与えるとデフォルトの
        左上([0, 0])から取ります。


=== Instance Methods

--- MyGame::Image#angle
--- MyGame::Image#angle=(value)
    画像の中点を中心とした回転角。360 で 1 回転。
--- MyGame::Image#render
    スクリーンに画像を描画する。
--- MyGame::Image#scale
--- MyGame::Image#scale=(value)
    拡大・縮小率。基準値は 1.0 。
--- MyGame::Image#transparent
--- MyGame::Image#transparent=([x, y])
    透過色の位置。透過させない場合は false 。デフォルト値を使うなら true 。
    これを変更しても、 ((<update|MyGame::Image#update>)) を呼ばない限り反映はされない。
--- MyGame::Image#transparent?
    透過されているかどうか。
--- MyGame::Image#update
    透過設定の変更を反映する。



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

== MyGame::Font

 * @inherit: ((<MyGame::DrawPrimitive>))
 * @extend:  ((<MyGame::Cacheable>))
 * @library: mygame.rb

あるフォントによる文字列の描画を扱うクラス。
影付き表示やアンチエイリアス表示も可能。


=== Singleton Methods

--- MyGame::Font.default_size
--- MyGame::Font.default_size=(point)
    デフォルトのフォントサイズ。
--- MyGame::Font.default_ttf_path
--- MyGame::Font.default_ttf_path=(path)
    デフォルトの TTF フォントファイルのパス。
--- MyGame::Font.new(str = '', args = {})
    フォント描画オブジェクトを生成します。
    
    : str
      描画する文字列。
    : args
      擬似キーワード引数です。
      スーパークラス ((<MyGame::DrawPrimitive>)) のインターフェイスを
      継承しています。
      
      : :size [=> MyGame::Font.default_size]
        フォントサイズ
      : :ttf_path [=> MyGame::Font.default_ttf_path]
        使用する TTF フォントファイルのパス
      : :color [=> [255, 255, 255]]
        フォントの色 ([R, G, B])
      : :smooth [=> false]
        アンチエイリアスを有効にするかどうか
      : :shadow [=> false]
        影の色 ([R, G, B])。影付けをしない場合は false。
        true が与えられた場合は ((<Font|MyGame::Font>))::DEFAULT_SHADOW 。
--- MyGame::Font.ttf_lookup(font_name)
    TTF フォントファイルを既定のディレクトリから検索します。
    
    既定のディレクトリとは、「./font」 と 「Rubyのディレクトリ/share/mygame」 等
    (Win32 の場合 「C:/Windows/Font」 のような特殊フォルダも含む) です。


=== Instance Methods

--- MyGame::Font#color
--- MyGame::Font#color=([r, g, b])
    フォントの色 ([R, G, B])
    
    この項目は ((<update|MyGame::Font#update>)) を呼ばないと変更が反映されません。
--- MyGame::Font#render
    スクリーンに文字列を描画する。
--- MyGame::Font#shadow
--- MyGame::Font#shadow=([r, g, b])
    影の色 ([R, G, B])。影付けをしない場合は false。
    true が与えられた場合は ((<Font|MyGame::Font>))::DEFAULT_SHADOW 。
    
    この項目は ((<update|MyGame::Font#update>)) を呼ばないと変更が反映されません。
--- MyGame::Font#shadow?
    影付けされているかどうか。
--- MyGame::Font#size
--- MyGame::Font#size=(point)
    フォントサイズ
    
    この項目は ((<update|MyGame::Font#update>)) を呼ばないと変更が反映されません。
--- MyGame::Font#smooth
--- MyGame::Font#smooth=(bool)
--- MyGame::Font#smooth?
    アンチエイリアスを有効にするかどうか
--- MyGame::Font#ttf_path
--- MyGame::Font#ttf_path=(path)
    使用する TTF フォントファイルのパス
    
    この項目は ((<update|MyGame::Font#update>)) を呼ばないと変更が反映されません。
--- MyGame::Font#update
    各項目の変更を反映します。



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

== MyGame::Square

 * @inherit: ((<MyGame::DrawPrimitive>))
 * @extend:  ((<MyGame::Cacheable>))
 * @library: mygame.rb

長方形の描画を扱うクラス。


=== Singleton Methods

--- MyGame::Square.new(x = 0, y = 0, w = 0, h = 0, args = {})
    長方形の描画を扱うオブジェクトを生成します。
    
    : args
      擬似キーワード引数です。
      スーパークラス ((<MyGame::DrawPrimitive>)) のインターフェイスを
      継承しています。
      
      : :color [=> [255, 255, 255]]
        描画に用いる色 ([R, G, B])。
      : :fill [=> false]
        領域内を塗りつぶすかどうか。


=== Instance Methods

--- MyGame::Square#color
--- MyGame::Square#color=([r, g, b])
    描画に用いる色 ([R, G, B])。
--- MyGame::Square#fill
--- MyGame::Square#fill=(bool)
--- MyGame::Square#filled?
    領域内を塗りつぶすかどうか。
--- MyGame::Square#render
    スクリーンに長方形を描画する。



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

== MyGame::Wave

 * @extend:  ((<MyGame::Cacheable>))
 * @library: mygame.rb

効果音や、その演奏を扱うクラス。


=== Singleton Methods

--- MyGame::Wave.new(filename, n_loop = 1)
    サウンドを扱うオブジェクトを生成します。
    
    : filename
      音声ファイル名を指定します。
      
      WAVE, AIFF, RIFF, OGG, VOC に対応しています。
    : n_loop
      繰り返し演奏する回数
    
    OGG をロードした場合、ロード時にすべてのデータがメモリ上に RAW データとして
    展開されるので、メモリ使用量に注意してください。


=== Instance Methods

--- MyGame::Wave#n_loop
--- MyGame::Wave#n_loop=(n)
    繰り返し演奏する回数。
    普通は数値ですが、 (({:loop})) は無限に繰り返しすることを意味します。
--- MyGame::Wave#play(channel = :auto)
    サウンドを再生します。
    
    ((|channel|)) はサウンドを鳴らすチャンネルで適切な数値ですが、 (({:auto})) は
    自動指定を意味します。



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

== MyGame::Music

 * @inherit: ((<MyGame::Wave>))
 * @extend:  ((<MyGame::Cacheable>))
 * @library: mygame.rb

BGM に使うような音楽や、その演奏を扱うクラス。


=== Singleton Methods

--- MyGame::Music.new(filename, n_loop = 1)
    楽曲を扱うオブジェクトを生成します。
    インターフェイスは ((<MyGame::Wave>)) のままです。
    
    WAVE, MOD, MIDI, OGG, MP3 に対応しています。
    Windows では環境によっては MP3 がロードできないことがあります。
--- MyGame::Music.stop
    演奏中の音楽を止めます。


=== Instance Methods

--- MyGame::Music#play(n_loop = self.n_loop)
    楽曲を演奏します。
    ((|n_loop|)) は繰り返し回数で、扱いは ((<MyGame::Wave>)) と同じです。



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

== MyGame::Scene

 * @library: mygame/scene.rb

シーン遷移モデルによるゲーム作成を提供する。

シーン定義は ((<MyGame::Scene::Base>)) を継承したクラス定義によって行なう。
以下、それをシーンクラスと呼ぶ。


=== Singleton Methods

--- MyGame::Scene.main_loop(scene_class, fps = 60, step = 1)
    シーン遷移モデルのメインループを実行します。
    ((|scene_class|)) はエントリポイントとなるシーンクラスを指定します。



== MyGame::Scene::Base

 * @library: mygame/scene.rb

シーンクラスの抽象スーパークラス。
メソッドをサブクラスで適切に再定義して、シーンを記述します。


=== Instance Methods

--- MyGame::Scene::Base#frame_counter
    シーンが開始してからの経過フレーム数を取得します。
--- MyGame::Scene::Base#init
    シーンの開始と共に実行される。
    サブクラスで必要ならば再定義してください。
--- MyGame::Scene::Base#next_scene
    次に遷移するシーンクラス。
    この値がセットされると、次のループでシーンを遷移します。
--- MyGame::Scene::Base#quit
    次のシーンに遷移する前に実行される。
    サブクラスで必要ならば再定義してください。
--- MyGame::Scene::Base#render
    update 後に実行される。
    サブクラスで必要ならば再定義してください。
--- MyGame::Scene::Base#update
    1 ステップごとに実行される。
    サブクラスで必要ならば再定義してください。



== MyGame::Scene::Exit

 * @library: mygame/scene.rb

シーン遷移の終了点となるシーンクラス。
このシーンに遷移するとメインループを終了する。



