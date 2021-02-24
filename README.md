# LongestRoad

Minecraftのコマンドで、カタンの最長交易路(Longest Road)を見つけだします。  
このワールドの方法では、functionなしで見つけ出せます。(コマブロ設置済み)  
必要コマンド実行数 = 15 + (n + 5) * (n - 1) + 5 (n:街道初期所持数) (道表示有なら + (n + 6))  
オリジナルのカタンではn=15なので、たった300コマンド実行するだけで求められます。(このワールドはn=20)

# 動作確認済みバージョン

- 1.14.4

# 操作

- スコアボードなどの作成  
  function calc/init
- 最長交易路の計算と表示  
  function calc/main
- 配置を初期化  
  function demo/start
- １ターン進める  
  function demo/resume
- 10ターン進める  
  function demo/resume10
- 計算と表示  
  function demo/show

# 動画

- v1  
https://twitter.com/AiAkaishi/status/1197572802074693632
- v2  
https://twitter.com/AiAkaishi/status/1197861344671756288
