# Build Guide

このビルドガイドは Rev.2 用です。[Rev.1 のビルドガイドはこちら](http://github.com/clomie/angelina72/blob/rev1/doc/BUILDGUIDE.md)。

このビルドガイドでは、左手32キー、右手36キー、合計68キー構成向けの組み立て方を説明します。
それ以外の構成で作る場合は適宜読み替えてください。

## 組み立てに必要な部品

| 部品                     | 型番         | 数量 | 備考                        |
| :----------------------- | :----------- | ---: | :-------------------------- |
| PCB                      |              |  2枚 |                             |
| トッププレート           |              |  2枚 |                             |
| ボトムプレート           |              |  2枚 |                             |
| ダイオード               | 1N4148W      | 68個 | 構成により 64個 または 72個 |
| MX用ソケット             | CPG151101S11 | 68個 | 構成により 64個 または 72個 |
| M2スペーサー 7mm         |              | 12本 |                             |
| M2スペーサー 6mm         |              |  4本 |                             |
| M2ねじ 4mm               |              | 32本 |                             |
| TRRSジャック             | MJ-4PP-9     |  2個 |                             |
| タクトスイッチ(2pin)     | TVBP06       |  2個 |                             |
| ProMicro                 |              |  2個 |                             |
| コンスルー (12pin)       |              |  4個 |                             |
| クッションゴム           |              |  8個 |                             |
| キースイッチ             |              | 68個 | 構成により 64個 or 72個     |
| キーキャップ 1Uサイズ    |              | 62個 | 構成により 58個 or 66個     |
| キーキャップ 1.25Uサイズ |              |  6個 |                             |
| TRRS(4極)ケーブル        |              |  1本 | TRS(3極)ケーブルでも可      |
| MicroUSB ケーブル        |              |  1本 |                             |

## ファームウェアのビルド環境セットアップ

途中、ProMicroにファームウェアを書き込む作業があります。
ビルド環境のセットアップに時間がかかるため、初めに進めておくと良いでしょう。
セットアップについてはQMK Firmwareの公式ドキュメント https://docs.qmk.fm/#/newbs_getting_started 等を参照してください。

## 実装

PCB、トッププレート、およびボトムプレートはリバーシブルです。
どちらを左手・右手にするのかを最初に決めます。

![01](/_image/buildguide_01.jpg)

### 左手外側4キーの分離

左手側のPCBから外側の4キー分を切り離します。

![02](/_image/buildguide_02.jpg)

ニッパーなどで切れ込みを入れてから力を加えると切り離せます。

![03](/_image/buildguide_03.jpg)

断面はヤスリなどで適宜削ってください。

![04](/_image/buildguide_04.jpg)

### ProMicro保護プレートの分離

両手のトッププレートからProMicro保護プレートを切り離します。

![05](/_image/buildguide_05.jpg)

![06](/_image/buildguide_06.jpg)

### MX用ソケットとダイオードのはんだ付け

MXソケットとダイオードをはんだ付けします。
MXソケットは裏面に取り付けます。
ダイオードは表裏どちらにはんだ付けしても動きますが、特別な理由がなければ裏面に取り付けてください。

MXソケットの両方のパッドとダイオードの片方のパッドに予備ハンダを盛ります。

![07](/_image/buildguide_07.jpg)

部品を配置し、浮かないようにピンセット等で押さえつけながら、端子を通して上から熱を伝えながらハンダを溶かすようにはんだ付けしていきます。

ダイオードの向きは左右ともに同じ向きです。ダイオードの "|||" の印がある側がシルクの "▷|" の向きに合うように実装してください。

![08](/_image/buildguide_08.jpg)

### TRRSジャックとリセットスイッチのはんだ付け

TRRSジャック、リセットスイッチは表面にパーツを取り付け、裏面からはんだ付けします。

![09](/_image/buildguide_09.jpg)

![10](/_image/buildguide_10.jpg)

### ProMicroのはんだ付け

スプリングピンヘッダ(コンスルー)を使用する場合、ProMicroとコンスルーをはんだ付けします。コンスルーとPCB間ははんだ付けしません。
はんだ付け方法は[Helixのビルドガイド](https://github.com/MakotoKurauchi/helix/blob/master/Doc/buildguide_jp.md#pro-micro)を参照してください。

ProMicroは表面のシルク枠に合わせて差し込みます。

![11](/_image/buildguide_11.jpg)

ここまでではんだ付けは完了です。

![12](/_image/buildguide_12.jpg)

![13](/_image/buildguide_13.jpg)

## ケースの組み立て

トッププレートの四隅の穴にキースイッチをはめ込み、ピンの曲がりに注意しながらPCBのソケットに差し込みます。

![14](/_image/buildguide_14.jpg)

ProMicroカバーの下に当たる部分に6mmのスペーサー、それ以外のキースイッチ部分に7mmのスペーサーを取り付けます。
ボトムプレート、ProMicroのカバーを取り付けたら、残りのキースイッチを差し込みます。

![15](/_image/buildguide_15.jpg)
![16](/_image/buildguide_16.jpg)

裏面4箇所にクッションゴムを取り付ければ完成です。

## ファームウェアの書き込み

### ビルド済みのファームウェアを書き込む場合

デフォルトキーマップのビルド済みファームウェアをダウンロードします。

https://raw.githubusercontent.com/clomie/angelina72/rev2/firmware/angelina72_rev2_default.hex

hexファイルはQMK Toolboxを利用して書き込みます。詳しくは以下の記事を参照してください。

https://salicylic-acid3.hatenablog.com/entry/qmk-toolbox

### キーマップをビルドする場合

Angelina72のファームウェアはQMKの公式リポジトリにマージされていません。
fork済みのリポジトリから`angelina72`ブランチをcloneしてビルドする必要があります。

```
git clone -b angelina72 https://github.com/clomie/qmk_firmware
```

Angelina72のデフォルトキーマップを書き込むには、cloneしたフォルダで以下のコマンドを実行します。

```
make angelina72/rev2:default:avrdude
```

`Detecting USB port, reset your controller now......` と表示されたら、キーボードのリセットボタンを押すと書き込みが始まります。

### デフォルトキーマップ

デフォルトのキーマップは画像の通りです。
青字はLOWERキー、赤字はRAISEキーと同時押しの場合に有効です。

![keymap](/_image/keymap.png)

LOWER、RAISEの同時押しでADJUSTレイヤーになります。
`Mac Mode`と`Win Mode`はDEFAULTレイヤーの最下行のキーで、それぞれのOSに合わせた設定に変更できます。

![keymap_adjust](/_image/keymap_adjust.png)
