#!/usr/bin/env bash
# CI（.github/workflows/ci.yml）と同じチェックを、手元の Docker 上で実行する。
# Node や Python を PC に直接インストールしていなくても実行できるよう、開発用コンテナを使う。
#
# 使い方（リポジトリのルートで実行）:
#   bash scripts/ci.sh
#
# 前提: Docker Desktop が起動していて、.env が作成済みであること。
set -euo pipefail

# どこから実行してもリポジトリのルートで動くようにする
cd "$(dirname "$0")/.."

if [ ! -f .env ]; then
  echo "[ERROR] .env がありません。cp .env.example .env で作成してください。" >&2
  exit 1
fi

echo "==> イメージをビルド（依存関係の変更を反映）"
docker compose build frontend backend

echo "==> Frontend: 型検査・ビルド"
docker compose run --rm --no-deps frontend sh -c "npm run typecheck && npm run build"

echo "==> Backend: テスト"
docker compose run --rm --no-deps backend python -m pytest

echo "==> すべてのチェックが成功しました"
