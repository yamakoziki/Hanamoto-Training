# 誠心トレーニング — セットアップ手順書

花本建設株式会社 土木技術者育成プログラム

---

## システム構成

```
[利用者スマホ] → [GitHub Pages: index.html] → [Google Apps Script] → [Claude Haiku API]
```

---

## 初期セットアップ

### 1. GitHub Pages の設定

1. このリポジトリを GitHub にプッシュ
2. リポジトリの「Settings」→「Pages」
3. Source: `main` ブランチ → `/(root)` を選択 → Save
4. 公開URL（例: `https://yamakoziki.github.io/seishin-training/`）が発行される

### 2. Google Apps Script の設定

1. https://script.google.com を開く
2. 新規プロジェクトを作成（プロジェクト名: `seishin-training-api`）
3. `コード.gs` の内容を貼り付け
4. 以下を書き換える：

```javascript
const ANTHROPIC_API_KEY = 'sk-ant-xxxxxxxx';  // ← 自分のAPIキー
const MAIL_TO = 'yamakoziki@gmail.com';         // ← 通知先メール
```

5. 「デプロイ」→「新しいデプロイ」
   - 種類: **ウェブアプリ**
   - 実行: **自分**
   - アクセス: **全員**
6. 発行された `/exec` URLをコピー

### 3. index.html の更新

```javascript
const CONFIG = {
  WORKER_URL: 'https://script.google.com/macros/s/【ここに貼る】/exec',
};
```

### 4. 動作確認

1. GitHub Pages の URL を Chrome で開く
2. `yamakoziki@gmail.com` でログイン
3. トレーニング開始 → ヒントが表示されることを確認

---

## GAS を更新する場合

URLを変えずに更新するには：
1. GAS エディタで `コード.gs` を修正
2. 「デプロイ」→「**デプロイを管理**」
3. 鉛筆アイコン（編集）をクリック
4. バージョン: **「新しいバージョン」** を選択
5. 「デプロイ」→ URL は変わらない

---

## トラブルシューティング

| 症状 | 原因 | 対処 |
|------|------|------|
| Safari でヒントがエラーになる | CORS | GASの通信方式がPOSTになっていないか確認（GETが正解） |
| 「動作中」が表示されない | URLが library URL | `/exec` で終わるURLに変更 |
| ログインできない | メールアドレス制限 | `yamakoziki@gmail.com` か `@hanamoto.co.jp` で試す |

---

## 関連リンク

- 花本建設 HP（誠心）: https://hanamoto.co.jp/company/
- 花本建設用語集: https://yamakoziki.github.io/HanamotoGlossary/
- Anthropic API コンソール: https://console.anthropic.com/
- GAS プロジェクト: https://script.google.com
