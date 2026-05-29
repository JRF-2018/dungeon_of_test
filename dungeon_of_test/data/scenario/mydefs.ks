
*start

[iscript]
f.mk  = 0 //(カード画像ロード済み)
f.cmk = 0 //(MKロード確認済み)
f.k0  = 0 //(帰り道の地図)
f.k1  = 0 //(フシギなムスビメ)
f.k2  = 0 //(キミョウなムスビメ)
f.k3  = 0 //(マスターキー)
f.tr  = 0 //(罠作動済み)
f.r1  = 0 //(一度入場済み)
f.r3  = 0 //(机を一度調べた)

f.bgm21 = "maou_bgm_cyber29.mp3"     //(ダンジョン通路)
f.bgm2  = "maou_game_boss05.mp3"     //(門番・緊迫)
f.bgm5  = "maou_game_event17.mp3"    //(女神イベント)
f.bgm6  = "maou_bgm_orchestra19.mp3" //(ゲームオーバー)
f.bgm9  = "maou_game_event37.mp3"    //(コングラチュレーション)
f.bgm10 = "maou_game_theme01.mp3"    //(落下→脱出)
[endscript]

;フォントは tyrano/css/font.css で定義
;[loadfont storage="shippori-mincho.woff2" name="game_mincho"]
[deffont face="game_mincho" size="26"]
;[deffont face="game_mincho"]
[resetfont]

[macro name="scenestart"]
;@layopt layer=message0 visible=false

[bg  time="1000"  method="crossfade" storage=%bg  ]

[button graphic="button/button_item1.png" enterimg="button/button_item2.png" storage="tst_meikyu_jp.ks" target=*tst_items  x="30" y="30" role="sleepgame" name="item_button"]

[if exp="f.k0 == 1"]
[eval exp="f.disable_title_btn = false"]
[else]
[eval exp="f.disable_title_btn = true"]
[endif]

@showmenubutton

[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true]

;メッセージウィンドウの表示
;@layopt layer=message0 visible=true

[endmacro]

[macro name="set_myglink"]
[eval exp="f.myglink_num = parseInt(mp.num)"]
[endmacro]

[macro name="myglink"]
    [if exp="mp.num !== undefined && mp.num !== ''"]
      [eval exp="f.myglink_num = parseInt(mp.num)"]
    [endif]
    [eval exp="f.ytmp = 100 + f.myglink_num * 75"]
    [eval exp="f.myglink_num += 1"]
    [if exp="mp.role"]
        [glink text="%text" face="game_mincho" role="%role" x="360" y=&f.ytmp color="black" size="28" width="500"]
    [else]
        [glink text="%text" face="game_mincho" target="%target" x="360" y=&f.ytmp color="black" size="28" width="500"]
    [endif]
[endmacro]

[macro name="myprev"]
    [if exp="mp.role"]
        [glink text="◀戻る" face="game_mincho" role="%role" x="360" y="400" color="black" size="28" width="100"]
    [else]
        [glink text="◀戻る" face="game_mincho" target="%target" x="360" y="400" color="black" size="28" width="100"]
    [endif]
[endmacro]

[macro name="mynext"]
    [if exp="mp.role"]
        [glink text="次へ▶" face="game_mincho" role="%role" x="760" y="400" color="black" size="28" width="100"]
    [else]
        [glink text="次へ▶" face="game_mincho" target="%target" x="760" y="400" color="black" size="28" width="100"]
    [endif]
[endmacro]


; ==================================================================
; 二重再生を防ぐ安全なBGM再生マクロ
; ==================================================================
[macro name="safe_playbgm"]
[iscript]
// マクロに渡された再生したいファイル名（例：mp.storage）
var nextBgm = mp.storage;

// ティラノスクリプトが記憶している「現在再生中のファイル名」を取得
var currentBgm = TYRANO.kag.stat.current_bgm;

// 音量（指定がなければ 100 にする）
var bgmVolume = mp.volume || "100";

// もし「現在鳴っている曲」と「次に鳴らしたい曲」が違う場合のみ再生処理を行う
if (nextBgm !== currentBgm) {
    TYRANO.kag.ftag.startTag("playbgm", {
        storage: nextBgm,
        volume: bgmVolume,
        loop: "true"
    });
}
[endscript]
[endmacro]

[return]
