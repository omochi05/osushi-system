from fastapi import FastAPI

app = FastAPI(title="osushi-system API")


# 起動確認・コンテナのヘルスチェック用。業務APIではない。
@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}
