# Kimi K2.5 Setup Instructions

## 1. Claude Code Terminal (Project Level)

**Status:** ✅ Configuration template created

**Action Required:** Set your Moonshot API key as an environment variable

**Windows (PowerShell - Run as Administrator):**
```powershell
# Set system-wide environment variable
[Environment]::SetEnvironmentVariable("MOONSHOT_API_KEY", "sk-your-moonshot-api-key-here", "User")

# Verify
$env:MOONSHOT_API_KEY
```

**Windows (Command Prompt - Run as Administrator):**
```cmd
setx MOONSHOT_API_KEY "sk-your-moonshot-api-key-here"
```

**macOS/Linux (add to ~/.bashrc or ~/.zshrc):**
```bash
export MOONSHOT_API_KEY=sk-your-moonshot-api-key-here
```

Then restart your terminal.

---

## 2. Claude Code Terminal (Session Only - Quick Test)

If you don't want to set a permanent env var, use this for each session:

```powershell
$env:ANTHROPIC_BASE_URL = "https://api.moonshot.cn/anthropic/"
$env:ANTHROPIC_API_KEY = "sk-your-moonshot-api-key-here"
claude
```

---

## 3. Cursor IDE - Claude Extension

**Status:** ⚠️ Configuration needed

The Cursor IDE uses its own settings. Two options:

### Option A: Native Model Settings (If Kimi is natively supported)
1. Open Cursor
2. File > Preferences > Settings (or `Ctrl + ,`)
3. Search for "Models" or "AI"
4. Look for "Custom Model" or "Add Model"
5. Enter:
   - Model: `kimi-k2-turbo-preview`
   - Base URL: `https://api.moonshot.cn/anthropic/`
   - API Key: Your Moonshot API key

### Option B: OpenRouter (Verified working)
1. Get OpenRouter API key: https://openrouter.ai/keys
2. Cursor Settings > Models:
   - Base URL: `https://openrouter.ai/api/v1`
   - API Key: Your OpenRouter key
   - Model: `moonshotai/kimi-k2`

---

## 4. "Kimi K Extension" Clarification

I'm not sure which extension you mean. Could you clarify?

**Possibilities:**
- **Kimi Code CLI extension** (if exists in VS Code/Cursor marketplace)
- **Kimi K2 model** (the AI model itself, configured above)
- **A specific VS Code extension** (please provide name)

---

## Verification Steps

After setup, verify with:

```bash
# In Claude Code terminal
/status
```

Should show: `kimi-k2-turbo-preview`

Or ask:
```
What model are you?
```

Should respond with Kimi K2.5 information.

---

## Get Your Moonshot API Key

1. Go to: https://platform.moonshot.cn/console/api-keys
2. Log in or create account
3. Click "新建API KEY" (Create New API Key)
4. Copy the key (starts with `sk-`)
5. **Important:** Add balance (¥50+ recommended) to avoid 429 rate limit errors

---

## Model Options

| Model | Speed | Best For |
|-------|-------|----------|
| `kimi-k2-turbo-preview` | ~60-100 tokens/s | Fast coding (RECOMMENDED) |
| `kimi-k2-thinking` | Standard | Complex reasoning |
| `kimi-k2-thinking-turbo` | Fast | Reasoning + speed |
| `kimi-k2-0905-preview` | Standard | 256K context |

Edit `C:\Users\Sam\.claude\settings.json` to change the model.

---

**Official Documentation:** https://platform.moonshot.cn/docs/guide/agent-support
