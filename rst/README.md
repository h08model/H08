# H08 Restart Extension

このディレクトリには、デフォルトの H08 に対して追加したリスタート計算用の拡張一式を置いています。  
対象は統合モデルシミュレーション (`cpl`) のみです。

## 概要

この拡張では、`cpl` 計算を任意の日付で停止し、その時点の一時出力を使って後続日から計算を再開できます。  
H08 マニュアルに従って通常の `cpl` 計算が実行できること、すなわち気象入力・地図データなどの基本入力が整備済みであることを前提とします。

## デフォルト H08 からの主な差分

追加・変更した主なファイルは以下です。

- `cpl/bin/main_rst.f`
  - `cpl/bin/main.f` をベースに、リスタート計算に対応するよう修正した Fortran 本体です。
- `cpl/bin/main_rst.sh`
  - `cpl/bin/main.sh` をベースに、リスタート用の入出力と引数を追加した実行スクリプトです。
- `rst/`
  - リスタート計算の設定、実行補助スクリプト、一時出力の格納先をまとめた追加ディレクトリです。
- `rst/bin/main.sh`
  - `rst/cfg/restart_settings.conf` の内容を反映して Python ラッパーを起動するスクリプトです。
- `rst/bin/run_h08.py`
  - `rst/bin/main.sh` から呼ばれるエントリーポイントです。
- `rst/bin/src/*.py`
  - 設定読み込みと `main_rst.sh` 呼び出しを担うサブスクリプト群です。
- `rst/cfg/restart_settings.conf`
  - リスタート計算の設定ファイルです。


## ディレクトリ構成

```text
rst/
|- README.md
|- requirements.txt
|- cfg/
|  `- restart_settings.conf
`- bin/
   |- main.sh
   |- run_h08.py
   `- src/
      |- initial_setting.py
      |- manage_setting.py
      |- settings_book.py
      `- simulation_loop.py
```

## Python 依存関係

`rst/bin/run_h08.py` および `rst/bin/src/*.py` で追加で必要になる外部ライブラリは以下です。

- `numpy`
- `pandas`

標準ライブラリ (`configparser`, `datetime`, `os`, `subprocess` など) は別途インストール不要です。

例:

```bash
python -m pip install -r rst/requirements.txt
```

## restart_settings.conf の設定項目

設定ファイル: `rst/cfg/restart_settings.conf`

- `h08_run_dir`
  - `main_rst.sh` を実行するディレクトリのフルパスです。
  - 現在の実装では、通常は `<H08リポジトリ>/cpl/bin` を指定します。
- `run_cmd`
  - Python から実行するコマンドです。
  - 通常は `sh main_rst.sh` のままで問題ありません。
- `prj`
  - シミュレーションのプロジェクト名です。
- `run`
  - シミュレーションのラン名です。
- `prjmet`
  - 入力気象データのプロジェクト名です。
- `runmet`
  - 入力気象データのラン名です。
- `yearbgn`, `monthbgn`, `daybgn`
  - リスタート計算の開始日時です。
- `yearend`, `monthend`, `dayend`
  - 今回の実行で停止する終了日時です。
- `flag_spn`
  - スピンアップ実行フラグです。
  - `0`: スピンアップを実施してから本計算を行う初回実行
  - `1`: 既存の一時出力を使って再開するリスタート実行

内部的には、`flag_spn = 0` のとき `RSTBGNFLG=0`、`flag_spn = 1` のとき `RSTBGNFLG=1` として `main_rst.sh` に渡されます。  
`RSTENDFLG` は常に `1` で渡され、停止時点の一時出力を保存する前提です。

## 実行前提

- この機能は統合モデルシミュレーション (`cpl`) のみに対応します。
- H08 マニュアルに従って、通常の `cpl` 計算が実行可能な状態である必要があります。
- `rst/bin/main.sh` は PBS 環境を前提とした記述です。
  - `cd $PBS_O_WORKDIR`
  - `source activate pyh08`
- そのため、PBS で投入する場合は `rst/bin` で `qsub main.sh` とするのが自然です。
- 直接 `bash main.sh` で起動する場合は、`PBS_O_WORKDIR` と Python 環境有効化の部分を実行環境に合わせて調整してください。

## 計算手順

### 1. 初回実行（スピンアップあり）

1. `rst/cfg/restart_settings.conf` で `prj`, `run`, `prjmet`, `runmet` を設定します。
2. `yearbgn`, `monthbgn`, `daybgn` に初回開始日時を設定します。
3. `yearend`, `monthend`, `dayend` に今回停止したい日時を設定します。
4. `flag_spn = 0` に設定します。
5. `rst/bin/main.sh` を実行します。

この初回実行では、`yearbgn` で指定した年に対してスピンアップを行った後、`yearend-monthend-dayend` まで計算します。  
初回スピンアップの挙動に関しては、月日よりも開始年が本質的に使われます。  
停止時点の一時出力は `rst/out/tmp` に保存され、次回の再開計算で使用されます。

### 2. 再開実行（リスタート）

1. `yearbgn`, `monthbgn`, `daybgn` に、直前に停止した日時を設定します。
2. `yearend`, `monthend`, `dayend` に、新たに次回停止したい日時を設定します。
3. `flag_spn = 1` に設定します。
4. 再度 `rst/bin/main.sh` を実行します。

このとき、`rst/out/tmp` に保存済みの一時出力を読み込み、指定日時から計算を再開します。

## 実行例

```text
初回:
  yearbgn = 2000
  monthbgn = 1
  daybgn = 1
  yearend = 2000
  monthend = 1
  dayend = 31
  flag_spn = 0

再開:
  yearbgn = 2000
  monthbgn = 1
  daybgn = 31
  yearend = 2000
  monthend = 2
  dayend = 15
  flag_spn = 1
```

## 注意事項

- `rst/bin/main.sh` の `source activate pyh08` は利用環境依存です。仮想環境名が異なる場合は適宜変更してください。
- `rst/out/tmp` に必要な一時ファイルが揃っていない状態で `flag_spn = 1` を実行すると、正しく再開できません。
