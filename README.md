# 星空カレンダー

今夜の星の見やすさ（月明かり＋雲量予報）、星図、月齢、惑星の見え方、流星群・月食・日食・惑星の接近などの天文現象をまとめたアプリです。

- 公開ページ: https://souya008-pixel.github.io/hoshizora/
- 1つのHTMLファイルで動きます。天体の位置はブラウザの中で計算しています（Paul Schlyter の軌道要素による近似）。
- 雲量予報は [Open-Meteo](https://open-meteo.com/) から取得しています。
- iPhone の Safari で開いて「ホーム画面に追加」すると、アプリとして使えます（オフラインでも動きます）。

アイコンは `tools/make-icons.ps1`（Windows PowerShell 5.1）で作り直せます。
