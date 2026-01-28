# Kimi K2.5 Setup - Configuration Applied

**Date:** 2026-01-28  
**Status:** ⚠️ Configuration applied, API key needs verification

---

## ✅ Configuration Files Updated

### 1. Claude Code Terminal (User-Level)
**File:** `C:\Users\Sam\.claude\settings.json`

```json
{
  "model": "kimi-k2-turbo-preview",
  "env": {
    "ANTHROPIC_BASE_URL": "https://api.moonshot.cn/anthropic/",
    "ANTHROPIC_API_KEY": "sk-kimi-EpYxHXd4Y0P4pCgjqJUXGmqN1DtwzdQkjMW3LxAleWGPozfXwXibfKSQ2uLZDisd",
    ...
  }
}
```

**Status:** ✅ Updated with API key

---

### 2. Cursor IDE - Claude Extension
**File:** `C:\Users\Sam\AppData\Roaming\Cursor\User\settings.json`

```json
{
  "claudeCode.selectedModel": "kimi-k2-turbo-preview",
  "claudeCode.environmentVariables": [
    {
      "name": "ANTHROPIC_AUTH_TOKEN",
      "value": "sk-kimi-EpYxHXd4Y0P4pCgjqJUXGmqN1DtwzdQkjMW3LxAleWGPozfXwXibfKSQ2uLZDisd"
    },
    {
      "name": "ANTHROPIC_BASE_URL",
      "value": "https://api.moonshot.cn/anthropic/"
    }
  ]
}
```

**Status:** ✅ Updated with API key

---

### 3. Environment Variable (Current Session)
```powershell
$env:MOONSHOT_API_KEY = "sk-kimi-EpYxHXd4Y0P4pCgjqJUXGmqN1DtwzdQkjMW3LxAleWGPozfXwXibfKSQ2uLZDisd"
```

**Status:** ✅ Set for current session

---

## ⚠️ API Key Verification

**Test Result:** 401 Unauthorized

This means the API key is not being accepted. Possible causes:

1. **Key format issue** - The key might need a different prefix or format
2. **Wrong endpoint** - Double-check the base URL
3. **Key not activated** - New keys sometimes need time to propagate
4. **Key revoked/expired** - May need to generate a new one

---

## 🔧 Troubleshooting Steps

### Step 1: Verify API Key Format

Check your Moonshot dashboard:
https://platform.moonshot.cn/console/api-keys

The key should look like:
- `sk-kimi-...` (what you provided) ✓
- Or possibly: `sk-...` (different prefix)

### Step 2: Test with Official Example

From https://platform.moonshot.cn/docs/guide/agent-support:

```bash
# Test the API directly
curl https://api.moonshot.cn/anthropic/v1/messages \
  -H "x-api-key: sk-kimi-EpYxHXd4Y0P4pCgjqJUXGmqN1DtwzdQkjMW3LxAleWGPozfXwXibfKSQ2uLZDisd" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{
    "model": "kimi-k2-turbo-preview",
    "max_tokens": 10,
    "messages": [{"role": "user", "content": "Hello"}]
  }'
```

### Step 3: If 401 Persists

1. Go to https://platform.moonshot.cn/console/api-keys
2. **Delete** the current key
3. **Create a new API key**
4. **Copy the new key** immediately
5. **Update the configuration** with the new key

---

## 🚀 Next Steps

### To Complete Setup:

1. **Verify the API key works** using the test above
2. **Restart Cursor IDE** completely
3. **Open new Claude Code terminal**
4. **Test:** Type `/status` or ask "What model are you?"

### Expected Response:
- Model: `kimi-k2-turbo-preview`
- Or confirmation that you're running Kimi K2.5

---

## 📝 Configuration Summary

| Component | File | Model | Base URL | API Key |
|-----------|------|-------|----------|---------|
| Claude Terminal | `~/.claude/settings.json` | kimi-k2-turbo-preview | api.moonshot.cn | ✅ Set |
| Cursor IDE | `%APPDATA%/Cursor/User/settings.json` | kimi-k2-turbo-preview | api.moonshot.cn | ✅ Set |

---

## 🔄 Switching Back to GLM

If needed, you can revert to GLM-4.7:

**Claude Terminal:**
- Model: `"glm-4.7"`
- Base URL: `"https://api.z.ai/api/anthropic"`

**Cursor IDE:**
- Same changes in settings.json

---

**Official Documentation:** https://platform.moonshot.cn/docs/guide/agent-support
