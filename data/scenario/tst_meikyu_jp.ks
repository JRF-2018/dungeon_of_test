; =========================================================
; テストの迷宮 - ティラノスクリプト版
; 原作: JRF (youscout_ptc / yschlp.prg より移植)
; =========================================================
;
; 【変換メモ・移植者向け注意事項】
;
; ■ フラグ対応表（PRG → ティラノ変数）
;   MK  … f.mk      (カード画像ロード済み)
;   CMK … f.cmk     (MKロード確認済み)
;   K0  … f.k0      (帰り道の地図)
;   K1  … f.k1      (フシギなムスビメ)
;   K2  … f.k2      (キミョウなムスビメ)
;   K3  … f.k3      (マスターキー)
;   TR  … f.tr      (罠作動済み)
;   R1  … f.r1      (一度入場済み)
;   R3  … f.r3      (机を一度調べた)
;
; ■ BGM対応（要差し替え）
;   BGM 21 → maou_bgm_cyber29.mp3  (ダンジョン通路)
;   BGM 2  → maou_game_boss05.mp3  (門番・緊迫)
;   BGM 5  → maou_game_event17.mp3 (女神イベント)
;   BGM 6  → maou_bgm_orchestra19.mp3 (ゲームオーバー)
;   BGM 9  → maou_game_event37.mp3 (コングラチュレーション)
;   BGM 10 → maou_game_theme01.mp3 (落下→脱出)
;
; ■ カード画像（\I コマンド → [image] タグ）
;   画像名は image_xxx.png として差し替えてください。
;   各シーンの [image] タグ付近にコメントで元座標を記載。
;
; ■ 条件分岐について
;   元PRGの \C[FLAG] は [if exp] で置き換え。
;   複合条件（\C[K1]\C[K2] 等）はネストした [if] で実装。
;
; =========================================================

*tst_start
[stopbgm]
[eval exp="f.cmk = 1"]
[eval exp="f.mk = 1"]

[cm]
[clearfix]
[start_keyconfig]

[scenestart bg="A09.png"]

あなたは「テストの迷宮」に迷い込んだ。[r]
[ruby text="いん"]隠[ruby text="じゃ"]者があなたに語りかける。：[r]
「[if exp="f.r1 == 1"]
[ruby text="もど"]戻って来んでよい。
[eval exp="f.r1 = 0"]
[endif]
次へ進みなさい。」[l][r]

[mynext target=*tst_road1]
[s]


; ---------------------------------------------------------
*tst_items
; ■ 持ち物一覧
; ---------------------------------------------------------
[cm]
[clearfix name="item_button"]
[position layer="message0" left=200 top=100 width=880 height=520 page=fore visible=true ]
■ 持ち物[r]
[r]
[if exp="f.k1 == 1"]
●不思議な結び目[r]
[else]
●????[r]
[endif]
[r]
[if exp="f.k2 == 1"]
●奇妙な結び目[r]
[else]
●????[r]
[endif]
[r]
[if exp="f.k3 == 1"]
●マスターキー[r]
[else]
●????[r]
[endif]
[r]
[if exp="f.k0 == 1"]
●帰り道の地図[r]
[else]
●????[r]
[endif]
[r]
[link target=*tst_close_item]◀ 戻る[endlink][r]
[s]

*tst_close_item
[cm]
[awakegame]
[s]


; ---------------------------------------------------------
*tst_road1
; 通路1（北へ、左に部屋1）
; ---------------------------------------------------------
[cm]
[safe_playbgm storage=&f.bgm21 loop=true target="smart"]
[scenestart bg="road.png"]

北へ道が[ruby text="の"]伸びている。左側に部屋がある。[l][r]

[set_myglink num="1"]
[myglink target=*tst_room1 text="部屋へ入る。"]
[myglink target=*tst_road2 text="先へ進む。"]
[myprev target=*tst_start_r1]
[mynext target=*tst_road2]
[s]

*tst_start_r1
[eval exp="f.r1 = 1"]
[jump target=*tst_start]
[s]

; ---------------------------------------------------------
*tst_road2
; 通路2（曲がり角）
; ---------------------------------------------------------
[cm]
[safe_playbgm storage=&f.bgm21 loop=true target="smart"]
[scenestart bg="corner.png"]

曲がり角のようだ。右に曲がるしかない。[l][r]

[set_myglink num="1"]
[myglink target=*tst_road3 text="先へ進む。"]
[myglink target=*tst_road1 text="後ろに戻る。"]
[myprev target=*tst_road1]
[mynext target=*tst_road3]
[s]


; ---------------------------------------------------------
*tst_road3
; 通路3（東へ、左に部屋3）
; ---------------------------------------------------------
[cm]
[safe_playbgm storage=&f.bgm21 loop=true]
[scenestart bg="road.png"]

東へ道が伸びている。左側に部屋がある。[l][r]

[set_myglink num="1"]
[myglink target=*tst_room3 text="部屋へ入る。"]
[myglink target=*tst_road4 text="先へ進む。"]
[myglink target=*tst_road2 text="後ろに戻る。"]
[myprev target=*tst_road2]
[mynext target=*tst_road4]
[s]


; ---------------------------------------------------------
*tst_road4
; 通路4（曲がり角）
; ---------------------------------------------------------
[cm]
[safe_playbgm storage=&f.bgm21 loop=true target="smart"]
[scenestart bg="corner.png"]

曲がり角のようだ。右に曲がるしかない。[l][r]

[set_myglink num="1"]
[myglink target=*tst_road5 text="先へ進む。"]
[myglink target=*tst_road3 text="後ろに戻る。"]
[myprev target=*tst_road3]
[mynext target=*tst_road5]
[s]


; ---------------------------------------------------------
*tst_road5
; 通路5（鍵のかかった扉）
; ---------------------------------------------------------
[cm]
[stopbgm]
; カード画像: K3あり → A09相当、なし → A04相当
[if exp="f.k3 == 0"]
  ; JRFTRT_A (144,0)-(179,55): カードA04相当
  [scenestart bg="A14.png"]
[else]
  ; JRFTRT_A (36,112)-(71,167): カードA03相当（別スロット）
  [scenestart bg="A06.png"]
[endif]

[ruby text="かぎ"]鍵のかかった扉が道を[ruby text="ふさ"]塞いでいる。[r]
[if exp="f.k3 == 1"]
あなたは鍵を持っている。[l][r]
[else]
あなたは鍵を持っていない。[l][r]
[endif]

[set_myglink num="1"]
[if exp="f.k3 == 1"]
[myglink target=*tst_road6 text="先へ進む。"]
[endif]
[myglink target=*tst_road4 text="後ろに戻る。"]
[myprev target=*tst_road4]
[if exp="f.k3 == 1"][mynext target=*tst_road6][endif]
[s]


; ---------------------------------------------------------
*tst_road6
; 通路6（南へ、左に部屋6）
; ---------------------------------------------------------
[cm]
[safe_playbgm storage=&f.bgm21 loop=true target="smart"]
[scenestart bg="road.png"]

南へ道が伸びている。左側に部屋がある。[l][r]

[set_myglink num="1"]
[myglink target=*tst_room6 text="部屋へ入る。"]
[myglink target=*tst_road7 text="先へ進む。"]
[myglink target=*tst_road5 text="後ろに戻る。"]
[myprev target=*tst_road5]
[mynext target=*tst_road7]
[s]


; ---------------------------------------------------------
*tst_road7
; 通路7（曲がり角）
; ---------------------------------------------------------
[cm]
[safe_playbgm storage=&f.bgm21 loop=true]
[scenestart bg="corner.png"]

曲がり角のようだ。右に曲がるしかない。[l][r]

[set_myglink num="1"]
[myglink target=*tst_road8 text="先へ進む。"]
[myglink target=*tst_road6 text="後ろに戻る。"]
[myprev target=*tst_road6]
[mynext target=*tst_road8]
[s]


; ---------------------------------------------------------
*tst_road8
; 通路8（西へ、左に部屋8）
; ---------------------------------------------------------
[cm]
[safe_playbgm storage=&f.bgm21 loop=true target="smart"]
[scenestart bg="road.png"]

西へ道が伸びている。左側に部屋がある。[l][r]

[set_myglink num="1"]
[myglink target=*tst_room8 text="部屋へ入る。"]
[myglink target=*tst_road9 text="先へ進む。"]
[myglink target=*tst_road7 text="後ろに戻る。"]
[myprev target=*tst_road7]
[mynext target=*tst_road9]
[s]


; ---------------------------------------------------------
*tst_road9
; 通路9（曲がり角）
; ---------------------------------------------------------
[cm]
[safe_playbgm storage=&f.bgm21 loop=true]
[scenestart bg="corner.png"]

曲がり角のようだ。右に曲がるしかない。[l][r]

[set_myglink num="1"]
[myglink target=*tst_roada text="先へ進む。"]
[myglink target=*tst_road8 text="後ろに戻る。"]
[myprev target=*tst_road8]
[mynext target=*tst_roada]
[s]


; ---------------------------------------------------------
*tst_roada
; 通路A（北へ、前方に人）
; ---------------------------------------------------------
[cm]
[safe_playbgm storage=&f.bgm21 loop=true target="smart"]
[scenestart bg="road2.png"]

北へ道が伸びている。前方に人がいる。[l][r]

[set_myglink num="1"]
[myglink target=*tst_roadb text="先へ進む。"]
[myglink target=*tst_road9 text="後ろに戻る。"]
[myprev target=*tst_road9]
[mynext target=*tst_roadb]
[s]


; ---------------------------------------------------------
*tst_roadb
; 通路B（門番との対話）
; ---------------------------------------------------------
[cm]
[stopbgm]
; カード画像: K2なし → A11相当、K2あり → A12相当
[if exp="f.k2 == 0"]
  ; JRFTRT_A (108,112)-(143,167)
  [scenestart bg="A12.png"]
[else]
  ; JRFTRT_A (144,112)-(179,167)
  [scenestart bg="A16.png"]
[endif]

門番がいる。彼が問う。：[r]
「おまえはゆるしを得ているか。」[l][r]
[set_myglink num="1"]
[if exp="f.k1 == 1"]
[myglink target=*tst_test1 text="不思議な結び目を見せる。"]
[endif]
[if exp="f.k2 == 1"]
[myglink target=*tst_test2 text="奇妙な結び目を見せる。"]
[endif]
[myglink target=*tst_testn text="「得ていない」と答える。"]
[s]


; ---------------------------------------------------------
*tst_room1
; 部屋1（宝箱の部屋）
; ---------------------------------------------------------
[cm]
[stopbgm]
; JRFTRT_A (108,0)-(143,55): A11相当
[scenestart bg="A10.png"]

部屋に入ると、前に宝箱がある。[r]
[if exp="f.k3 == 1"]
「マスターキー」が使えるようだ。[l][r]
[else]
しかし、開けられそうにない。[l][r]
[endif]

[set_myglink num="1"]
[if exp="f.k3 == 1"]
[myglink target=*tst_room1a text="宝箱を開ける。"]
[endif]
[myglink target=*tst_road1 text="部屋を出る。"]
[myprev target=*tst_road1]
[s]


; ---------------------------------------------------------
*tst_room1a
; 部屋1A（宝箱の中身・アイテム入手）
; ---------------------------------------------------------
[cm]

ろくなものが入っていない。
[if exp="f.k1 == 1 && f.k2 == 1"]
[r]
[elsif exp="f.k1 == 0 && f.k2 == 0"]
結び目のあるヒモが2本ある。[r]
[elsif exp="f.k1 == 1 && f.k2 == 0"]
結び目のあるヒモが1本ある。[r]
[elsif exp="f.k1 == 0 && f.k2 == 1"]
結び目のあるヒモが1本ある。[r]
[endif]

; --- 罠判定 (TST_TRAP: p1=0.25, p2=0.25) ---
[if exp="f.tr == 1"]
  ; 罠発動: 25%で ROOM1T（ワープ）、25%でメッセージ表示
  [eval exp="f._trap_r = Math.random()"]
  [if exp="f._trap_r < 0.25"]
    [jump target=*tst_room1t]
  [elsif exp="f._trap_r < 0.50"]
[ruby text="わな"]罠があったが、引っかからなかった。
  [endif]
[endif]
[l][r]

; --- 乱数で K1/K2 どちらを先に提示するか決める (TST_RND:2) ---
[eval exp="f._rnd = Math.random() < 0.5 ? 0 : 1"]

[set_myglink num="1"]
[if exp="f._rnd == 0 && f.k1 == 0"]
[myglink target=*tst_room1b text="不思議な結び目を拾う。"]
[endif]
[if exp="f._rnd == 0 && f.k2 == 0"]
[myglink target=*tst_room1c text="奇妙な結び目を拾う。"]
[endif]
[if exp="f._rnd == 1 && f.k2 == 0"]
[myglink target=*tst_room1c text="奇妙な結び目を拾う。"]
[endif]
[if exp="f._rnd == 1 && f.k1 == 0"]
[myglink target=*tst_room1b text="不思議な結び目を拾う。"]
[endif]
[myglink target=*tst_road1 text="部屋を出る。"]
[myprev target=*tst_road1]
; ページ終了時: TMP クリア、TR フラグを立てる
[eval exp="f._rnd = 0"]
[eval exp="f.tr = 1"]
[s]


; ---------------------------------------------------------
*tst_room1b
; フシギなムスビメ入手
; ---------------------------------------------------------
[eval exp="f.k1 = 1"]
[cm]
; JRFTRT_A (180,56)-(215,111): カードA05相当
[scenestart bg="A18.png"]

不思議な結び目を拾った。[l][r]
[mynext target=*tst_room1a]
[s]


; ---------------------------------------------------------
*tst_room1c
; キミョウなムスビメ入手
; ---------------------------------------------------------
[eval exp="f.k2 = 1"]
[cm]
; JRFTRT_A (72,0)-(107,55): カードA02相当
[scenestart bg="A07.png"]

奇妙な結び目を拾った。[l][r]
[mynext target=*tst_room1a]
[s]


; ---------------------------------------------------------
*tst_room1t
; 罠！ワープ（部屋1A の罠）
; ---------------------------------------------------------
[cm]
; JRFTRT_A (108,56)-(143,111): カードA11b相当
[scenestart bg="A11.png"]

[ruby text="わな"]罠だ！どこか別の場所に飛ばされたようだ。[l][r]
[mynext target=*tst_road8]
[s]


; ---------------------------------------------------------
*tst_room3
; 部屋3（家具の部屋・マスターキー探索）
; ---------------------------------------------------------
[cm]
[stopbgm]
; JRFTRT_A (36,56)-(71,111): カードA01b相当
[scenestart bg="A05.png"]

部屋にはいくつか家具がある。[ruby text="い"]椅[ruby text="す"]子・[ruby text="つくえ"]机・[ruby text="たな"]棚がある。[l][r]
[set_myglink num="0"]
[myglink target=*tst_room3a text="椅子を調べる。"]
; 机の調査: K3あり→3A（空振り）, R3フラグあり→3C（マスターキー）, それ以外→3B（フラグ立て）
[if exp="f.k3 == 1"]
[myglink target=*tst_room3a text="机を調べる。"]
[elsif exp="f.r3 == 1"]
[myglink target=*tst_room3c text="机を調べる。"]
[else]
[myglink target=*tst_room3b text="机を調べる。"]
[endif]
[myglink target=*tst_room3a text="棚を調べる。"]
[myglink target=*tst_road3 text="部屋を出る。"]
[myprev target=*tst_road3]
[s]


; ---------------------------------------------------------
*tst_room3a
; 部屋3A（空振り）
; ---------------------------------------------------------
[cm]

何もないようだ。[l][r]
[myprev target=*tst_room3]
[s]


; ---------------------------------------------------------
*tst_room3b
; 部屋3B（初回調査：フラグR3を立てる）
; ---------------------------------------------------------
[eval exp="f.r3 = 1"]
[cm]

何もないようだが……[l][r]
[myprev target=*tst_room3]
[s]


; ---------------------------------------------------------
*tst_room3c
; 部屋3C（マスターキー発見）
; ---------------------------------------------------------
[cm]

引き出しをよく調べると、「マスターキー」を見つけた。[l][r]
[set_myglink num="1"]
[myglink target=*tst_room3d text="マスターキーを拾う。"]
[myglink target=*tst_road3 text="部屋を出る。"]
[myprev target=*tst_room3]
[s]


; ---------------------------------------------------------
*tst_room3d
; マスターキー入手
; ---------------------------------------------------------
[eval exp="f.k3 = 1"]
[cm]
; JRFTRT_A (180,0)-(215,55): カードA05a相当
[scenestart bg="A17.png"]

マスターキーを拾った。[l][r]
[mynext target=*tst_room3]
[s]


; ---------------------------------------------------------
*tst_room6
; 部屋6（グシャの部屋・何もない）
; ---------------------------------------------------------
[cm]
[stopbgm]
; JRFTRT_D (180,0)-(215,55): A00(グシャ)
[scenestart bg="A00.png"]

部屋には家具があり、人がいる。彼が言う。：[r]
「ここには何もないぞ。」[l][r]
[set_myglink num="0"]
[myglink target=*tst_room6a text="椅子を調べる。"]
[myglink target=*tst_room6a text="机を調べる。"]
[myglink target=*tst_room6a text="棚を調べる。"]
[myglink target=*tst_road6 text="部屋を出る。"]
[myprev target=*tst_road6]
[s]


; ---------------------------------------------------------
*tst_room6a
; 部屋6A（空振り）
; ---------------------------------------------------------
[cm]

何もないようだ。[l][r]
[myprev target=*tst_room6]
[s]


; ---------------------------------------------------------
*tst_room8
; 部屋8（時の女神）アイテム全没収
; ---------------------------------------------------------
[safe_playbgm storage=&f.bgm5 loop=false target="smart"]
; K0なし → 女神A、K0あり → 女神B
[if exp="f.k0 == 0"]
  ; JRFTRT_A (0,112)-(35,167): 女神A
  [scenestart bg="A03.png"]
[else]
  ; JRFTRT_A (0,56)-(35,111): 女神B
  [scenestart bg="A02.png"]
[endif]
; アイテム没収（K1/K2/K3 → 0）
[eval exp="f.k1 = 0"]
[eval exp="f.k2 = 0"]
[eval exp="f.k3 = 0"]
[cm]

部屋に入ると、「時の女神」が現れた。：[r]
[if exp="f.k0 == 0"]
「あなたがこんなものを持つのは早い。」[r]
[else]
「あなたがこんなものを持つ意味はない。」[r]
[endif]
[if exp="f.k0 == 1"]
地図以外の[endif]持ち物をすべて[ruby text="うば"]奪われてしまった！[l][r]
[myglink target=*tst_road8 text="部屋を出る。" num="1"]
[myprev target=*tst_road8]
[s]


; ---------------------------------------------------------
*tst_testn
; 「許可を得ていない」と答える → 通行拒否
; ---------------------------------------------------------
[cm]

「ならばここは通せん。」[l][r]
[myglink target=*tst_roada text="後ろに戻る。" num="1"]
[myprev target=*tst_roada]
[s]


; ---------------------------------------------------------
*tst_test1
; フシギなムスビメを見せる → 通過許可
; ---------------------------------------------------------
[cm]
; K2なし → A07相当、K2あり → A06相当
[if exp="f.k2 == 0"]
  ; JRFTRT_A (216,56)-(251,111)
  [scenestart bg="A21.png"]
[else]
  ; JRFTRT_A (144,56)-(179,111)
  [scenestart bg="A15.png"]
[endif]

「うむ、ゆるしを得ているな。通ってヨシ。」[l][r]
; K2 を持っている場合は TESTE（尋問）へ、なければ FINAL へ
[set_myglink num="1"]
[if exp="f.k2 == 1"]
[myglink target=*tst_teste text="先へ進む。"]
[else]
[myglink target=*tst_final text="先へ進む。"]
[endif]
[if exp="f.k2 == 1"]
[mynext target=*tst_teste]
[else]
[mynext target=*tst_final]
[endif]
[s]


; ---------------------------------------------------------
*tst_teste
; 門番の追加尋問（K2 所持がバレる）
; ---------------------------------------------------------
[cm]
[safe_playbgm storage=&f.bgm2 loop=true target="smart"]

「ちょっと待て。ポケットからもう一つ結び目が見えている。それは何だ。」[l][r]
[myglink target=*tst_test2 num="1" text="奇妙な結び目を見せる。"]
[s]


; ---------------------------------------------------------
*tst_test2
; キミョウなムスビメを見せる → ゲームオーバー
; ---------------------------------------------------------
[cm]
[safe_playbgm storage=&f.bgm2 loop=true target="smart"]
[scenestart bg="attack.png"]

「おのれ、これは父を殺したのはわたしという印。父の[ruby text="かたき"]仇め！」[r]
[playse storage="maou_se_battle03.mp3" volume="100"]
[layermode color="0xff0000" mode="multiply" time="100"]
[wait time="1000"]
[free_layermode time="800"]
門番はあなたを一刀両断にした。[l][r]
[mynext target=*tst_gover]
[s]


; ---------------------------------------------------------
*tst_gover
; ゲームオーバー
; ---------------------------------------------------------
[safe_playbgm storage=&f.bgm6 loop=false target="smart"]
[cm]
; JRFTRT_D (180,56)-(215,111): A13(シニガミ)
[scenestart bg="A13.png"]
[clearfix name="item_button"] 
; フラグ全リセット
[iscript]
f.k0 = 0
f.k1 = 0
f.k2 = 0
f.k3 = 0
f.tr  = 0
f.r3  = 0
[endscript]

ゲームオーバー。[l][r]
[mynext target=*tst_start]
[s]


; ---------------------------------------------------------
*tst_final
; 落下シーン（エンディングへ）
; ---------------------------------------------------------
[cm]
[safe_playbgm storage=&f.bgm10 loop=true target="smart"]
; JRFTRT_A (216,0)-(251,55): カードA07a相当
[scenestart bg="A20.png"]

突然、あなたは足を[ruby text="すべ"]滑らせた。[r]
あなたは深い穴を落ちていく……[l][r]
[mynext target=*tst_congl]
[s]


; ---------------------------------------------------------
*tst_congl
; クリア！おめでとう
; ---------------------------------------------------------
[eval exp="f.k0 = 1"]
[eval exp="f.tr = 0"]
[eval exp="f.r3 = 0"]
[safe_playbgm storage=&f.bgm9 loop=false target="smart"]
[cm]
; JRFTRT_A (180,112)-(215,167): カードA05b相当
[scenestart bg="A19.png"]

気づくと前に光が見える。[r]
おめでとう。きみは出口にたどり着いた。[r]
……ちなみに、このゲームは「ティラノスクリプト」で作られています。[r]
シナリオ: JRF、音楽: 魔王魂、絵: ChatGPT でした。[l][r]
[set_myglink num="1"]
[myglink text="セーブする。" target=*tst_clear_save]
[myglink text="タイトルに戻る。" target=*tst_clear_title]
[mynext target=*tst_clear_title]
[s]


*tst_clear_save
[showsave]
[jump target="*tst_congl"]


*tst_clear_title
[jump storage="title.ks" target="*title_start"]



