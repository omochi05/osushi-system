# osushi-system

回転寿司注文システム（総合開発演習）

テーブル端末から顧客が注文し、店舗スタッフがメニュー・在庫・調理状況を管理する単一店舗向けのシステムです。
注文の伝達ミスと重複を防ぎ、顧客が注文状況と会計前の金額を確認できるようにすることを目的とします。

## 開発環境

### 必要なツール（ホストPCにインストールするもの）

| ツール | 動作確認済みバージョン |
| --- | --- |
| Docker Desktop (Docker Engine) | 28.5.1 |
| Docker Compose | v2.40.3 |
| Git | 2.47.1 |

> Python・Node.js・MySQL は Docker コンテナ内で動作するため、ホストPCへのインストールは不要です。

### コンテナ内のランタイム

| サービス | 技術 | バージョン |
| --- | --- | --- |
| backend | Python | 3.13.16 |
| frontend | Node.js | 24.21.0 |
| frontend | React / React DOM | 19.3.0 |
| db | MySQL | 8.4（動作確認: 8.4.11） |

## 開発範囲

| 区分 | 内容 |
| --- | --- |
| 対象 | メニュー閲覧、カート編集、注文確定、来店中の履歴、注文状態管理、会計金額確認、来店・商品・在庫管理、注文金額集計 |
| 対象外 | 実際の支払い、決済連携、POS連携、注文取消、返金、複数店舗対応 |

| 利用者 | 利用端末 |
| --- | --- |
| 顧客 | テーブルに設置したタブレット |
| 店舗スタッフ（管理者） | Web管理画面 |

機能要件（REQ-01〜13）・非機能要件（NFR-01〜12）の詳細は要件定義書・機能一覧表・非機能一覧表を参照してください。

## 技術構成

| 区分 | 技術 | バージョン |
| --- | --- | --- |
| フロントエンド | React（Vite）+ TypeScript | Node.js 24（`frontend/.nvmrc`）、各ライブラリは `frontend/package.json` |
| バックエンド | Python + FastAPI | Python 3.13（`backend/.python-version`）、各ライブラリは `backend/requirements.txt` |
| データベース | MySQL | 8.4 |
| 実行環境 | Docker Compose（フロントエンド・API・DB） | - |
| 変更管理 | Git / GitHub | - |
| CI | GitHub Actions（想定） | - |

## ディレクトリ構成

```
osushi-system/
├── frontend/          # React（Vite）+ TypeScript（顧客用タブレット画面・管理画面）
├── backend/           # Python + FastAPI（API）
│   ├── app/           #   アプリケーション本体
│   ├── pytest.ini     #   pytest の設定（テストの基準フォルダを backend/ に固定）
│   └── tests/         #   テスト（pytest）
├── db/
│   └── init/          # MySQL 初回起動時に実行する SQL
├── scripts/
│   └── ci.sh          # CI と同じチェックを手元で実行するスクリプト
├── .github/
│   └── workflows/     # GitHub Actions（CI）
├── compose.yaml       # Docker Compose の構成
└── .env.example       # 環境変数のサンプル（コピーして .env を作成）
```

## 開発を始める前に（Git の準備）

### 1. 必要なツール

- [Git](https://git-scm.com/)（Windows の場合は Git for Windows。Git Bash が使えます）
- [Visual Studio Code](https://code.visualstudio.com/)

### 2. Git の初期設定（PC ごとに1回だけ）

コミットの作成者として記録される名前とメールアドレスを設定します。

```bash
git config --global user.name "GitHubのユーザー名"
git config --global user.email "GitHubに登録したメールアドレス"
```

公開リポジトリのため、個人のメールアドレスを公開したくない場合は、GitHub の Settings → Emails にある `xxxx@users.noreply.github.com` 形式のアドレスを使ってください。

設定内容は次のコマンドで確認できます。

```bash
git config --global --list
```

### 3. リポジトリの取得（clone）

```bash
cd ~
git clone https://github.com/omochi05/osushi-system.git
cd osushi-system
code .
```

- 認証は HTTPS で行います。初回の push 時にブラウザが開くので、GitHub にログインしてください（SSH キーの作成は不要です）。
- 他の Git リポジトリの中に clone しないでください。clone する前に `git status` を実行し、`not a git repository` と表示される場所で行います。
- `code .` が使えない場合は、VS Code の「ファイル → フォルダーを開く」から `osushi-system` フォルダを開いてください。

### 4. 取得できたかの確認

```bash
git status
git branch -a
```

`On branch main` と表示されれば準備完了です。

## セットアップ（Docker Compose）

### 1. 必要なツール

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)（起動した状態にしておく）

Node.js と Python はコンテナ内で動くため、PC へのインストールは必須ではありません（エディタの補完などで必要な場合のみインストールしてください）。

### 2. 環境変数ファイルの作成（初回のみ）

```bash
cp .env.example .env
```

`.env` の値はローカル開発用のダミーです。`.env` は Git にコミットしないでください。

### 3. 起動

```bash
docker compose up --build
```

| 対象 | URL |
| --- | --- |
| フロントエンド | http://localhost:5173 |
| API | http://localhost:8000 |
| API 仕様（Swagger UI） | http://localhost:8000/docs |
| API の起動確認 | http://localhost:8000/health |

初回は MySQL の準備に時間がかかるため、API とフロントエンドは MySQL の起動完了後に立ち上がります。
`frontend/` と `backend/` のコードを変更すると、自動で再読み込みされます。

### 4. 停止・データの削除

```bash
# 停止（DB のデータは残る）
docker compose down

# 停止して DB のデータも削除する（初期化し直したいとき。元に戻せません）
docker compose down -v
```

### 初期データの投入

テーブル定義と初期データは、DB 設計のタスクで `db/init/` に追加します。`db/init/` 内の SQL は DB の初回起動時にだけ実行されるため、追加・変更後に反映するには `docker compose down -v` でデータを削除してから起動し直してください。

### DB に接続する（MySQL Workbench などのツールを使う場合）

| 項目 | 値 |
| --- | --- |
| ホスト | `localhost` |
| ポート | `.env` の `DB_PORT`（初期値 3307） |
| ユーザー / パスワード | `.env` の `MYSQL_USER` / `MYSQL_PASSWORD` |
| DB 名 | `.env` の `MYSQL_DATABASE` |

PC に直接インストールした MySQL（通常 3306 番）と重ならないよう、初期値を 3307 番にしています。3306 番に接続すると別の MySQL を見てしまうため注意してください。

### PC で直接テストを実行する（任意）

Docker を使わずにバックエンドのテストを実行したい場合は、Python 3.13 の仮想環境を作成します（Windows の Git Bash の例）。

```bash
cd backend
py -3.13 -m venv .venv
source .venv/Scripts/activate
pip install -r requirements.txt
python -m pytest
```

- 仮想環境が有効になると、プロンプトの先頭に `(.venv)` が表示されます。ターミナルを開き直すたびに `source .venv/Scripts/activate` が必要です。
- `.venv` は `.gitignore` で除外しているため、コミットされません。
- `py -3.13` で「見つからない」と表示される場合は、Python 3.13 をインストールしてください（例: `winget install Python.Python.3.13`）。

## Issue の運用

作業は Issue を起点に進めます。1つの Issue に1つの作業（1ブランチ・1 Pull Request）を対応させます。

### Issue の作り方

1. リポジトリの **Issues** タブ → **New issue** を開く
2. 次の内容を記入して **Create** を押す

| 項目 | 書き方 | 例 |
| --- | --- | --- |
| タイトル | `[要件ID] 作業内容`（要件に対応しない作業は要件IDを省略） | `[REQ-04] 注文確定APIの実装` |
| 本文 | 目的、作業内容、完了条件、関連資料 | 下記のテンプレート参照 |
| Assignees | 担当者 | 自分 |
| Labels | 作業の種類 | `enhancement`（機能）、`bug`（不具合）、`documentation`（資料） |

本文のテンプレート:

```markdown
## 目的

## 作業内容
- [ ]

## 完了条件
- [ ]

## 関連資料
- 要件: REQ-xx / NFR-xx
```

### Issue と Pull Request の紐付け

Pull Request の本文に `Closes #Issue番号` と書くと、`main` にマージされたときに Issue が自動で閉じられます。

```
Closes #12
```

## ブランチ運用

- 作業ブランチは必ず最新の `main` から作成する
- `main` への反映は Pull Request 経由で行い、`main` へ直接 push しない
- 内容が固まりきっていない変更は Draft Pull Request で共有する

### ブランチ名

`種別-要件ID-内容` の形式で、英小文字とハイフンを使います（要件IDの `REQ` は大文字のまま）。要件に対応しない作業は要件IDを省略します。

| 種別 | 用途 | 例 |
| --- | --- | --- |
| `feat` | 機能の実装 | `feat-REQ-04-order-confirm` |
| `fix` | 不具合の修正 | `fix-REQ-02-quantity-validation` |
| `docs` | ドキュメントの追加・修正 | `docs-api-spec` |
| `chore` | 環境構築・設定・CI など | `chore-docker-compose` |

### 作業の流れ

```bash
# 0. 作業内容の Issue を作成する（GitHub 上で操作。上記「Issue の運用」を参照）

# 1. main を最新にする
git switch main
git pull

# 2. 作業ブランチを作成して切り替える
git switch -c feat-REQ-04-order-confirm

# 3. 変更をコミットする
git status
git add <変更したファイル>
git commit -m "REQ-04: 注文確定APIを追加"

# 4. GitHub に push する（初回のみ -u を付ける）
git push -u origin feat-REQ-04-order-confirm
```

push 後、GitHub で Pull Request を作成し、本文に `Closes #Issue番号` を書きます。作業途中で共有する場合は Draft Pull Request にします。

### 作業中に main が更新された場合

```bash
git switch main
git pull
git switch feat-REQ-04-order-confirm
git merge main
```

競合（コンフリクト）が発生した場合は、自分だけで解消せず、該当箇所の担当者と相談してください。

### マージ後の片付け

```bash
git switch main
git pull
git branch -d feat-REQ-04-order-confirm
```

## CI

GitHub Actions（`.github/workflows/ci.yml`）で、`main` 向けの Pull Request と `main` への push のたびに次のチェックを実行します（NFR-12）。

| ジョブ | 実行内容 | 実行されるための前提 |
| --- | --- | --- |
| Frontend | `npm ci` → `npm run typecheck` → `npm run build` | `frontend/package.json`・`frontend/package-lock.json`・`frontend/.nvmrc` があり、`package.json` に `typecheck` と `build` スクリプトが定義されている |
| Backend | `pip install -r requirements.txt` → `python -m pytest` | `backend/requirements.txt`（pytest を含む）・`backend/.python-version` がある |

- Node と Python のバージョンは、それぞれ `frontend/.nvmrc` と `backend/.python-version` で管理し、CI もその値を使います。
- `frontend/package.json` または `backend/requirements.txt` が無い場合は、該当ジョブのチェックをスキップし、実行結果の画面に notice を表示します。
- pytest はテストが1件も無いと失敗します。`backend/tests/` のテストは削除しないでください。
- フロントエンドにライブラリを追加したときは、`package.json` と `package-lock.json` を一緒にコミットしてください（CI の `npm ci` はロックファイルどおりにインストールします）。
- バックエンドにライブラリを追加したときは、`requirements.txt` にバージョンを固定して追記してください（例: `fastapi==0.143.0`）。

### 手元で CI と同じチェックを実行する

push する前に、Docker 上で同じチェックを実行できます（`.env` の作成が必要です）。

```bash
bash scripts/ci.sh
```

最後に `すべてのチェックが成功しました` と表示されれば成功です。

## トラブルシューティング

| 症状 | 原因 | 対処 |
| --- | --- | --- |
| `docker compose up` で `ports are not available ... (ポート番号)` | 他のアプリが同じポートを使用している | 表示された番号に応じて `.env` の `DB_PORT`・`BACKEND_PORT`・`FRONTEND_PORT` を空いている番号（例: `3308`）に変更して起動し直す |
| `Cannot connect to the Docker daemon` / `error during connect` | Docker Desktop が起動していない | Docker Desktop を起動し、Engine が動いている状態になってから再実行する |
| ブラウザで http://localhost:8000 などに接続できない | コンテナが起動していない | `docker compose ps -a` で状態を確認し、`docker compose logs <サービス名> --tail 30` でエラーを確認する |
| `\r: command not found` / `bad interpreter` | ファイルの改行コードが CRLF になっている | VS Code 右下の `CRLF` をクリックして `LF` に変更し保存する（`.gitattributes` でコミット時は LF に統一される） |
| `npm error enoent Could not read package.json` | `frontend/` 以外の場所で `npm` を実行している | `cd frontend` してから実行する |
| pytest の結果が `collected 0 items` / `rootdir` が `backend` 以外になる | テストファイルが無い、または `backend/` の外で実行している | `backend/` で `python -m pytest` を実行する。`backend/pytest.ini` を削除しない |
| ホーム（`~`）にいるのにプロンプトに `(main)` などのブランチ名が表示される | ホームフォルダ自体が誤って Git リポジトリになっている | `git -C ~ log` でコミットが無いことを確認したうえで、担当者に相談して `~/.git` を削除する |

## 関連資料

- [Wiki](https://github.com/omochi05/osushi-system/wiki)

## 注意事項

- パスワード、APIキー、`.env` などの秘密情報はコミットしないでください（NFR-04）。
- テストデータにはダミーデータを使用してください。