import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173,
    watch: {
      // Windows/Mac のフォルダを Docker コンテナにマウントすると、ファイル変更の通知が
      // コンテナへ届かず自動リロードされないことがある。その場合に備え、
      // Docker 上ではポーリング（定期的な変更確認）で監視する（compose.yaml で有効化）。
      usePolling: process.env.VITE_USE_POLLING === 'true',
    },
  },
})
