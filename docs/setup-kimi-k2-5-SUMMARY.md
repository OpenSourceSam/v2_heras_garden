# Kimi K2.5 Setup Summary

## ✅ What Was Configured

### 1. Claude Code Terminal (User-Level)

**File:** `C:\Users\Sam\.claude\settings.json`

**Configuration:**
```json
{
  "model": "kimi-k2-turbo-preview",
  "env": {
    "ANTHROPIC_BASE_URL": "https://api.moonshot.cn/anthropic/",
    "ANTHROPIC_API_KEY": "${MOONSHOT_API_KEY}",
    ...
  }
}
```

**Status:** ✅ Template created
**Action Needed:** Set `MOONSHOT_API_KEY` environment variable

---

### 2. Cursor IDE - Claude Code Extension

**File:** `C:\Users\Sam\AppData\Roaming\Cursor\User\settings.json`

**Configuration:**
```json
{
  "claudeCode.selectedModel": "kimi-k2-turbo-preview",
  "claudeCode.environmentVariables": [
    {
      "name": "ANTHROPIC_AUTH_TOKEN",
      "value": "${env:MOONSHOT_API_KEY}"
    },
    {
      "name": "ANTHROPIC_BASE_URL",
      "value": "https://api.moonshot.cn/anthropic/"
    }
  ]
}
```

**Status:** ✅ Configuration updated
**Action Needed:** Restart Cursor IDE

---

### 3. "Kimi K Extension" 

**Status:** ⚠️ Clarification needed

Please specify which extension you mean:
- Is this a VS Code/Cursor marketplace extension?
- Or are you referring to the Kimi K2 model itself (already configured above)?

---

## 📝 Next Steps

### Step 1: Get Your Moonshot API Key

1. Visit: https://platform.moonshot.cn/console/api-keys
2. Log in or create account
3. Create new API key
4. **Copy the key** (starts with `sk-`)

### Step 2: Set Environment Variable

**Option A - Windows System Variable (Recommended):**

Run PowerShell as Administrator:
```powershell
[Environment]::SetEnvironmentVariable("MOONSHOT_API_KEY", "sk-your-key-here", "User")
```

**Option B - PowerShell Profile (Per-Session):**

Add to your PowerShell profile:
```powershell
$env:MOONSHOT_API_KEY = "sk-your-key-here"
```

### Step 3: Restart Applications

1. **Close** any running Claude Code terminals
2. **Close** Cursor IDE completely
3. **Reopen** both applications

### Step 4: Verify

In Claude Code terminal or Cursor's Claude extension:
```
/status
```

Or ask:
```
What model are you running?
```

Should show: **kimi-k2-turbo-preview**

---

## 🔧 Model Options

To change models, edit:
- `C:\Users\Sam\.claude\settings.json` (terminal)
- `C:\Users\Sam\AppData\Roaming\Cursor\User\settings.json` (Cursor IDE)

| Model | Use Case |
|-------|----------|
| `kimi-k2-turbo-preview` | Fast coding (60-100 tokens/s) - **CURRENT** |
| `kimi-k2-thinking` | Complex reasoning with thinking mode |
| `kimi-k2-thinking-turbo` | Fast reasoning |
| `kimi-k2-0905-preview` | 256K context window |

---

## ⚠️ Important Notes

1. **Rate Limits:** Free tier = 3 RPM (too slow for Claude Code)
   - **Solution:** Add balance (¥50+) at https://platform.moonshot.cn

2. **Previous GLM Config:** Backed up - you can switch back by changing:
   - Model: `"glm-4.7"`
   - Base URL: `"https://api.z.ai/api/anthropic"`

3. **Official Documentation:** https://platform.moonshot.cn/docs/guide/agent-support

---

**Setup Instructions:** `docs/setup-kimi-k2-5.md`
