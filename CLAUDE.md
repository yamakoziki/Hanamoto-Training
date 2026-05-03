# 誠心トレーニング — Claude Code プロジェクト定義

## プロジェクト概要
花本建設株式会社（北海道）の土木技術者向け、AIメンター付き意思決定トレーニングシステム。
正式名：**誠心トレーニング（Seishin Training）**

---

## アーキテクチャ

```
GitHub Pages                    Google Apps Script (GAS)
┌────────────────┐              ┌─────────────────────────┐
│  index.html    │  GET リクエスト │  コード.gs              │
│  (フロントエンド) │ ────────────→ │  (バックエンド + AI中継)  │
│  全シナリオ内包  │ ←──────────── │  Claude Haiku API 呼出  │
└────────────────┘   JSONレスポンス └─────────────────────────┘
```

**重要：** 通信は POST ではなく **GET + URLエンコード** を使用（SafariのCORS問題回避のため）

---

## ファイル構成

| ファイル | 場所 | 役割 |
|--------|------|------|
| `index.html` | GitHub Pages（公開） | アプリ本体。シナリオ60件全収録 |
| `コード.gs` | Google Apps Script（非公開） | AIメンター・採点・メール送信 |
| `CLAUDE.md` | このファイル | Claude Code向けプロジェクト定義 |
| `README.md` | リポジトリルート | 人間向けセットアップ手順 |

**GitHubに置いてはいけないもの：**
- `コード.gs`（Anthropic APIキーが含まれる）
- APIキーを含む `.env` ファイル等

---

## 主要設定値（index.html 内の CONFIG）

```javascript
const CONFIG = {
  WORKER_URL: 'https://script.google.com/macros/s/【GAS_EXEC_URL】/exec',
  ALLOWED_EMAILS: ['yamakoziki@gmail.com', '@hanamoto.co.jp'],
};
```

---

## シナリオ構成

- **総数：** 60シナリオ
- **1セッション：** 5問ランダム出題
- **カテゴリ：**
  - 農業系工事 (15問)
  - 道路工事 (15問)
  - 河川工事 (12問)
  - 安全・労務 (10問)
  - 社会・環境 (8問)

---

## AI機能（コード.gs）

### ヒント機能（さらに考えてみる）
- 1問につき最大 **2回まで**
- 答えを直接教えない。問いかけで思考を促す
- 12のアプローチをランダム選択（逆転の問い・第三者の目・時間軸 等）

### 採点機能（AI採点）
6次元評価、各次元 0/4/8/12/16 点、**最大96点**

| 次元 | 内容 |
|------|------|
| 信頼 | 報告・連絡・相談・情報共有 |
| 創造 | 原因分析・改善提案 |
| 挑戦 | 再発防止・他事例展開 |
| 感謝 | 組織・仲間への配慮 |
| 奉仕 | 社会・環境的視点 |
| その他提案 | 独創的な視点 |

---

## アクセス制限

ログイン可能なメールアドレス：
- `yamakoziki@gmail.com`
- `@hanamoto.co.jp` ドメイン

---

## 外部リソース

| リソース | URL |
|--------|-----|
| 花本建設HP（誠心） | https://hanamoto.co.jp/company/ |
| 花本建設用語集 | https://yamakoziki.github.io/HanamotoGlossary/ |
| e-Gov 法令検索 | https://laws.e-gov.go.jp/ |
| Anthropic API コンソール | https://console.anthropic.com/ |

---

## コスト目安

- Claude Haiku API：約 **¥0.45 / ユーザー / セッション**
- 100ユーザー規模：約 **¥45 / セッション**

---

## よくある問題と対処法

### SafariでCORSエラーが発生する
→ GASへの通信を **POST ではなく GET** で行う。ペイロードは `?payload=` にURLエンコードして渡す。

### GASのURLが「library」URLになっている
→ 正しいURLは `https://script.google.com/macros/s/.../exec` の形式。`library` ではなく `s` が入る。

### GASを更新してもURLが変わる
→ 「デプロイを管理」→「既存のデプロイを編集（鉛筆アイコン）」→「新しいバージョン」を選択するとURLが変わらない。

---

## 変更ルール（Claude Code作業時の必須確認事項）

1. **変更前に必ず作業環境を確認する**（どのファイルがどこにあるか、デプロイ状況は？）
2. `index.html` の変更後は GitHub にプッシュ
3. `コード.gs` の変更後は GAS で「デプロイを管理」→「新しいバージョン」で更新
4. GAS URLが変わった場合は `index.html` の `WORKER_URL` も更新が必要
