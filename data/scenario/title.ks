
[cm]

*title_start
[cm]
[clearfix]
[stopbgm]
[hidemenubutton]
@clearstack
@bg storage ="title_bg.png" time=100
@wait time = 200

*start 

[button x=640 y=350 graphic="title/button_start1.png" enterimg="title/button_start2.png"  target="gamestart" keyfocus="1"]
[button x=640 y=500 graphic="title/button_load1.png" enterimg="title/button_load2.png" role="load" keyfocus="2"]
[add_lang_img filename="title/button_start1.png" text="はじめから"]
[add_lang_img filename="title/button_load1.png" text="つづきから"]

[s]

*gamestart
;一番最初のシナリオファイルへジャンプする
;@jump storage="scene1.ks"
@jump storage="tst_meikyu_jp.ks"



