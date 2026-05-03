#!/bin/bash
# デプロイ前チェックスクリプト
# 使い方: bash scripts/deploy-check.sh

echo "=============================="
echo " 誠心トレーニング デプロイチェック"
echo "=============================="
echo ""

ERRORS=0

# 1. index.html の存在確認
if [ -f "index.html" ]; then
  echo "✅ index.html が存在します"
else
  echo "❌ index.html が見つかりません"
  ERRORS=$((ERRORS+1))
fi

# 2. WORKER_URL が placeholder のままでないか確認
if grep -q "GAS_EXEC_URL" index.html 2>/dev/null; then
  echo "❌ WORKER_URL がプレースホルダーのままです（GAS_EXEC_URL を実際のURLに変えてください）"
  ERRORS=$((ERRORS+1))
else
  echo "✅ WORKER_URL が設定されています"
fi

# 3. APIキーが index.html に直書きされていないか確認
if grep -q "sk-ant-" index.html 2>/dev/null; then
  echo "❌ 警告: index.html に Anthropic APIキーが含まれています！削除してください"
  ERRORS=$((ERRORS+1))
else
  echo "✅ APIキーは index.html に含まれていません"
fi

# 4. コード.gs が誤ってコミットされていないか確認
if git ls-files --error-unmatch "コード.gs" 2>/dev/null; then
  echo "❌ 警告: コード.gs がGit管理に含まれています！.gitignore を確認してください"
  ERRORS=$((ERRORS+1))
else
  echo "✅ コード.gs はGit管理外です（安全）"
fi

# 5. /exec URL形式の確認
if grep -q "macros/s/" index.html 2>/dev/null; then
  echo "✅ WORKER_URL の形式が正しい（/macros/s/...）"
elif grep -q "macros/library" index.html 2>/dev/null; then
  echo "❌ WORKER_URL が library URL です。/macros/s/.../exec に変更してください"
  ERRORS=$((ERRORS+1))
fi

echo ""
echo "=============================="
if [ $ERRORS -eq 0 ]; then
  echo "✅ チェック完了。デプロイ可能です。"
else
  echo "❌ $ERRORS 件の問題があります。修正してからデプロイしてください。"
fi
echo "=============================="
