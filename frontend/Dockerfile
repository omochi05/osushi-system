# 開発用イメージ（本番用の最適化はしていない）
FROM node:24-slim

WORKDIR /app

# 依存関係を先にインストールし、ソース変更時にキャッシュを効かせる
COPY package.json package-lock.json ./
RUN npm ci

COPY . .

EXPOSE 5173

# コンテナ外（ホストのブラウザ）からアクセスできるよう 0.0.0.0 で待ち受ける
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]
