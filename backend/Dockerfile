# 開発用イメージ（本番用の最適化はしていない）
FROM python:3.13-slim

# .pyc を作らず、ログをバッファせずに即時出力する
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# 依存関係を先にインストールし、ソース変更時にキャッシュを効かせる
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
