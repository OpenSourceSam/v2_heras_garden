# Model Configuration FAQ

Comprehensive guide for configuring GLM, MiniMax, Kimi K2.5, and Anthropic models in Claude Code/Cursor IDE.

**Official Documentation Sources Used:**
- Moonshot/Kimi: https://platform.moonshot.cn/docs
- Anthropic: https://docs.anthropic.com
- Cursor: https://docs.cursor.com

---

## Table of Contents

- [Section 1: GLM Configuration](#section-1-glm-configuration-how-to-set-up)
- [Section 2: Reversing Configuration](#section-2-reversing-configuration-how-to-switch-back)
- [Section 3: Troubleshooting](#section-3-troubleshooting)
- [Section 4: Reference](#section-4-reference)
- [Section 5: Kimi K2.5 Configuration](#section-5-kimi-k25-configuration-official-moonshot-documentation)
- [Section 6: Quick Reference](#section-6-quick-reference)

---

## Section 1: GLM Configuration (Official Z.AI Documentation)

### Q1: How do I configure GLM-4.7 as my main model in Claude Code?

**Official Source:** https://open.bigmodel.cn (Zhipu AI / Z.AI platform)

#### Prerequisites

1. **Z.AI Account**: You need an account at [z.ai](https://z.ai)
2. **API Key**: Obtain your API key from your Z.AI account dashboard
3. **GLM Subscription**: Subscribe to the GLM Coding Plan (see Q2)

#### Step-by-Step Instructions

1. **Locate your settings file**:
   - Windows: `C:\Users\YourName\.claude\settings.json`
   - macOS/Linux: `~/.claude/settings.json`

2. **Create a backup** (optional but recommended):
   ```bash
   cp ~/.claude/settings.json ~/.claude/settings.json.backup
   ```

3. **Edit settings.json** with the following configuration:

   ```json
   {
     "model": "glm-4.7",
     "env": {
       "ANTHROPIC_AUTH_TOKEN": "your-zai-api-key-here",
       "ANTHROPIC_BASE_URL": "https://api.z.ai/api/anthropic/",
       "ANTHROPIC_MODEL": "glm-4.7",
       "ANTHROPIC_DEFAULT_SONNET_MODEL": "glm-4.7",
       "ANTHROPIC_DEFAULT_OPUS_MODEL": "glm-4.7",
       "ANTHROPIC_DEFAULT_HAIKU_MODEL": "glm-4.5-air"
     }
   }
   ```

4. **Replace** `your-zai-api-key-here` with your actual Z.AI API key

5. **Save the file**

6. **Restart Claude Code** for changes to take effect

#### Verification Steps

To verify GLM is active:

1. **Check the status bar** in Cursor - it should show "glm-4.7"
2. **Run `/status` command** (if available) to see current model
3. **Check the startup message** - it should indicate GLM-4.7

---

### Q2: What is the GLM Coding Plan?

The GLM Coding Plan provides access to Zhipu AI's GLM (General Language Model) series through an Anthropic-compatible API.

#### Available Models

| Model | Anthropic Equivalent | Best For |
|-------|---------------------|----------|
| `glm-4.7` | Sonnet/Opus | Main coding tasks, complex reasoning |
| `glm-4.5-air` | Haiku | Fast tasks, quick responses |
| `glm-4.6v` | Claude 3.5 Sonnet (vision) | Image analysis |

#### Pricing and Features

- **Provider**: Zhipu AI (Z.AI)
- **Website**: [https://z.ai](https://z.ai)
- **API Compatibility**: Anthropic API-compatible
- **Pricing**: Check [https://open.bigmodel.cn/pricing](https://open.bigmodel.cn/pricing) for current rates

#### Where to Subscribe

1. Visit [https://z.ai](https://z.ai)
2. Create an account or sign in
3. Navigate to the API section
4. Subscribe to the GLM Coding Plan
5. Generate your API key

---

### Q3: Can I use GLM alongside MiniMax MCP tools?

Yes! GLM and MiniMax work together seamlessly:

#### How They Work Together

- **GLM as Main Model**: Handles primary coding tasks, planning, and direct interactions
- **MiniMax MCP for Delegation**: Used for specific tasks like web search and image analysis

#### Example Workflow

```
User: "Search for the latest Godot 4.5 documentation on input handling"

GLM (Main Model):
  - Recognizes this is a research task
  - Delegates to MiniMax MCP web search tool
  - MiniMax performs the search (token-efficient)
  - GLM reviews and summarizes results

Result: Token savings + efficient research
```

#### Configuration

When both are configured:
- GLM handles all direct conversations
- MiniMax tools are available for delegation via MCP
- No conflicts - they serve different purposes

---

## Section 2: Reversing Configuration (How to Switch Back)

### Q4: How do I switch back to Anthropic models (Sonnet/Opus)?

To remove GLM and restore Anthropic models:

1. **Open** `~/.claude/settings.json`

2. **Replace the entire content** with:

   ```json
   {
     "model": "sonnet"
   }
   ```

   Or use "opus" if you prefer Opus as your default:
   ```json
   {
     "model": "opus"
   }
   ```

3. **Save the file**

4. **Restart Claude Code**

   The default Anthropic API will be used automatically when `ANTHROPIC_BASE_URL` is not set.

---

### Q5: How do I switch from GLM to MiniMax as the main model?

To use MiniMax as your primary model:

1. **Open** `~/.claude/settings.json`

2. **Configure** with MiniMax settings:

   ```json
   {
     "model": "miniMax-6_5-9b",
     "env": {
       "ANTHROPIC_AUTH_TOKEN": "your-minimax-api-key",
       "ANTHROPIC_BASE_URL": "https://api.minimax.io/anthropic"
     }
   }
   ```

3. **Replace** `your-minimax-api-key` with your actual MiniMax API key

4. **Save and restart** Claude Code

---

### Q6: How do I completely remove custom model configuration?

For a clean reset to defaults:

1. **Open** `~/.claude/settings.json`

2. **Replace content** with minimal configuration:

   ```json
   {
     "model": "sonnet"
   }
   ```

3. **Alternatively**, delete the entire `env` section if it exists

4. **Save and restart**

   Your settings should now look like:
   ```json
   {
     "model": "sonnet"
   }
   ```

---

## Section 3: Troubleshooting

### Q7: Why isn't my GLM configuration working?

#### Common Issues and Solutions

| Issue | Solution |
|-------|----------|
| **API Key errors** | Verify your Z.AI API key is correct and active |
| **Connection timeout** | Check that `https://api.z.ai` is accessible from your network |
| **"Model not found"** | Ensure `ANTHROPIC_MODEL` is set to `glm-4.7` (not `glm-4.7` with typos) |
| **Base URL errors** | Use exactly: `https://api.z.ai/api/anthropic/` (note trailing slash) |

#### Verification Steps

1. **Test API key**:
   ```bash
   curl -X POST "https://api.z.ai/api/anthropic/v1/messages" \
     -H "x-api-key: your-api-key" \
     -H "anthropic-version: 2023-06-01" \
     -H "content-type: application/json" \
     -d '{"model":"glm-4.7","max_tokens":10,"messages":[{"role":"user","content":"hi"}]}'
   ```

2. **Check settings.json syntax**:
   ```bash
   # Validate JSON
   cat ~/.claude/settings.json | python -m json.tool
   ```

---

### Q8: Claude Code isn't detecting the model change

#### Restart Requirements

Model configuration changes **always require a restart**:

1. **Close Claude Code completely**
2. **Wait 2-3 seconds** for processes to terminate
3. **Reopen Claude Code**

#### Cache Clearing (if restart doesn't work)

1. **Clear Claude cache**:
   ```bash
   # Windows
   rm -rf ~/.claude/cache/*

   # macOS/Linux
   rm -rf ~/.claude/cache/*
   ```

2. **Restart Claude Code**

---

### Q9: Can I switch between models dynamically?

**Short Answer**: No, not directly. Model configuration requires editing settings.json and restarting.

#### Workarounds

1. **Manual Editing**:
   - Edit `~/.claude/settings.json`
   - Change the `model` field
   - Restart Cursor

2. **Multiple Profiles** (Advanced):
   - Create separate settings files:
     - `settings.json` (default)
     - `settings-glm.json`
     - `settings-minimax.json`
   - Swap them as needed:
     ```bash
     cp ~/.claude/settings-glm.json ~/.claude/settings.json
     ```

3. **Script Helper** (Example):
   ```bash
   # switch-model.sh
   cp ~/.claude/settings-$1.json ~/.claude/settings.json
   echo "Switched to $1 - restart Cursor"
   ```

---

### Q10: How do I know which model is currently active?

#### Methods to Check

1. **Status Bar**: Look at the bottom of Cursor - it shows the current model

2. **`/status` Command**: If available in your Claude Code version:
   ```
   /status
   ```

3. **Startup Message**: When Claude starts, it prints the model being used

4. **Check Settings File**:
   ```bash
   cat ~/.claude/settings.json | grep model
   ```

5. **Test Query**:
   ```
   User: "What model are you?"
   ```

---

## Section 4: Reference

### Configuration File Locations

| Platform | Settings File Path |
|----------|-------------------|
| Windows | `C:\Users\YourName\.claude\settings.json` |
| macOS | `~/.claude/settings.json` |
| Linux | `~/.claude/settings.json` |

| Platform | Project MCP Config |
|----------|-------------------|
| All | `.cursor/mcp.json` (project-specific) |

---

### Model Mapping

| GLM Model | Anthropic Equivalent | Use Case |
|-----------|---------------------|----------|
| `glm-4.7` | Sonnet/Opus | Main coding, complex tasks |
| `glm-4.5-air` | Haiku | Fast tasks, quick responses |
| `glm-4.6v` | Vision models | Image analysis |

| MiniMax Model | Anthropic Equivalent | Use Case |
|---------------|---------------------|----------|
| `miniMax-6_5-9b` | Sonnet | General purpose |
| `miniMax-256k` | Opus | Long context tasks |

---

### Base URLs

| Provider | Base URL |
|----------|----------|
| **GLM (Z.AI)** | `https://api.z.ai/api/anthropic/` |
| **MiniMax** | `https://api.minimax.io/anthropic` |
| **Anthropic** | (default - omit `ANTHROPIC_BASE_URL`) |

---

### Complete Configuration Examples

#### GLM Configuration
```json
{
  "model": "glm-4.7",
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "your-zai-api-key",
    "ANTHROPIC_BASE_URL": "https://api.z.ai/api/anthropic/",
    "ANTHROPIC_MODEL": "glm-4.7",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "glm-4.7",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "glm-4.7",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "glm-4.5-air"
  }
}
```

#### MiniMax Configuration
```json
{
  "model": "miniMax-6_5-9b",
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "your-minimax-api-key",
    "ANTHROPIC_BASE_URL": "https://api.minimax.io/anthropic"
  }
}
```

#### Anthropic (Default) Configuration
```json
{
  "model": "sonnet"
}
```

---

### Environment Variable Reference

| Variable | Purpose | Example |
|----------|---------|---------|
| `ANTHROPIC_AUTH_TOKEN` | API key for the provider | `sk-...` |
| `ANTHROPIC_BASE_URL` | API endpoint URL | `https://api.z.ai/api/anthropic/` |
| `ANTHROPIC_MODEL` | Default model to use | `glm-4.7` |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | Model for Sonnet requests | `glm-4.7` |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | Model for Opus requests | `glm-4.7` |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | Model for Haiku requests | `glm-4.5-air` |

---

## Related Documentation

- [MCP Setup Guide](./mcp-setup.md) - MCP server configuration
- [MiniMax MCP Terminal Guide](../MINIMAX_MCP_TERMINAL_GUIDE.md) - MiniMax terminal usage
- [MiniMax MCP Skill](../../../.claude/skills/minimax-mcp/SKILL.md) - MiniMax MCP skill documentation

---

## Quick Command Reference

```bash
# Backup current settings
cp ~/.claude/settings.json ~/.claude/settings.json.backup

# Edit settings (macOS/Linux)
nano ~/.claude/settings.json

# Edit settings (Windows)
notepad C:\Users\YourName\.claude\settings.json

# Validate JSON syntax
python -m json.tool ~/.claude/settings.json

# Test GLM API connection
curl -X POST "https://api.z.ai/api/anthropic/v1/messages" \
  -H "x-api-key: your-key" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{"model":"glm-4.7","max_tokens":10,"messages":[{"role":"user","content":"test"}]}'
```

---

**Last Updated**: 2026-01-20


---

## Section 5: Kimi K2.5 Configuration (Official Moonshot Documentation)

### K1: How do I configure Kimi K2.5 as the default model in Claude Code CLI?

**Official Source:** https://platform.moonshot.cn/docs/guide/agent-support

#### Prerequisites

1. **Moonshot Account**: Register at https://platform.moonshot.cn
2. **API Key**: Create at https://platform.moonshot.cn/console/api-keys
3. **Sufficient Balance**: Ensure account has credits (¥50+ recommended for smooth usage)

#### Claude Code CLI Configuration

**Method 1: Environment Variables (Recommended)**

Set environment variables before launching Claude Code:

**Windows (PowerShell):**
```powershell
$env:ANTHROPIC_BASE_URL = "https://api.moonshot.cn/anthropic/"
$env:ANTHROPIC_API_KEY = "your-moonshot-api-key-here"
claude
```

**macOS/Linux (bash/zsh):**
```bash
export ANTHROPIC_BASE_URL=https://api.moonshot.cn/anthropic/
export ANTHROPIC_API_KEY=your-moonshot-api-key-here
claude
```

**Method 2: settings.json Configuration**

Edit `~/.claude/settings.json` (or `C:\Users\YourName\.claude\settings.json` on Windows):

```json
{
  "model": "kimi-k2-turbo-preview",
  "env": {
    "ANTHROPIC_BASE_URL": "https://api.moonshot.cn/anthropic/",
    "ANTHROPIC_API_KEY": "your-moonshot-api-key-here"
  }
}
```

**Available Kimi K2.5 Models:**

| Model | Context | Speed | Best For |
|-------|---------|-------|----------|
| `kimi-k2-turbo-preview` | 256K | ~60-100 tokens/s | Fast coding, quick iterations |
| `kimi-k2-thinking-turbo` | 256K | Fast | Complex reasoning with thinking mode |
| `kimi-k2-thinking` | 256K | Standard | Deep reasoning, agentic tasks |
| `kimi-k2-0905-preview` | 256K | Standard | Latest preview with 256K context |

**Official Model List:** https://platform.moonshot.cn/docs/guide/model-overview

#### Verification Steps

1. **Check model in Claude Code:**
   ```
   /status
   ```
   Should show: `kimi-k2-turbo-preview` (or selected model)

2. **Test thinking mode (for thinking models):**
   - Press `Tab` in Claude Code to toggle "Thinking on"
   - Model will show reasoning process

3. **Verify API connection:**
   ```powershell
   curl -X POST "https://api.moonshot.cn/anthropic/v1/messages" `
     -H "x-api-key: your-api-key" `
     -H "anthropic-version: 2023-06-01" `
     -H "content-type: application/json" `
     -d '{"model":"kimi-k2-turbo-preview","max_tokens":10,"messages":[{"role":"user","content":"test"}]}'
   ```

---

### K2: How do I configure Kimi K2.5 in Cursor IDE?

**Official Sources:**
- Cursor docs: https://docs.cursor.com
- Moonshot integration guide: https://platform.moonshot.cn/docs/guide/agent-support

#### Cursor with OpenRouter

**Note:** This uses OpenRouter as an intermediary.

1. **Get OpenRouter API Key:** https://openrouter.ai/keys
2. **Cursor Settings > Models:**
   - Base URL: `https://openrouter.ai/api/v1`
   - API Key: Your OpenRouter key
   - Model: `moonshotai/kimi-k2`

#### Cursor with Direct Moonshot API

**Note:** For direct Moonshot integration in Cursor without OpenRouter, check the official Cursor documentation at https://docs.cursor.com for the latest supported configuration methods. Cursor's native model support changes frequently.

**Current verified method:** Use OpenRouter (see above) or configure via Cursor's native model settings.

---

### K3: Kimi K2.5 vs Other Models - When to Use

**Official Benchmarks:** https://platform.moonshot.cn/docs/guide/model-overview

| Use Case | Recommended Model | Why |
|----------|-------------------|-----|
| Fast coding iterations | `kimi-k2-turbo-preview` | 60-100 tokens/s |
| Complex agentic tasks | `kimi-k2-thinking` | Multi-step reasoning |
| Long context (200K+) | `kimi-k2-0905-preview` | 256K context window |
| Visual/image tasks | `kimi-k2-0905-preview` | Multimodal support |
| Cost-sensitive | `kimi-k2-turbo-preview` | Most efficient |

**Pricing (Official):** https://platform.moonshot.cn/docs/pricing
- Input: ¥0.60 / 1M tokens (cache miss)
- Output: ¥2.50 / 1M tokens

---

### K4: Troubleshooting Kimi K2.5 Configuration

**Official Support:** https://platform.moonshot.cn/docs/guide/faq

#### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| **429 errors** | Rate limit (Free: 3 RPM) | Upgrade account or add balance |
| **Model not found** | Incorrect model name | Use exact names from official docs |
| **Connection timeout** | Network/API issues | Check https://api.moonshot.cn status |
| **Slow responses** | Using non-turbo model | Switch to `kimi-k2-turbo-preview` |
| **Thinking mode not working** | Wrong model type | Use `kimi-k2-thinking` models |

#### Rate Limits

**Free Tier:**
- 3 RPM (requests per minute)
- Limited for Claude Code usage

**Paid Tier:**
- Higher RPM based on account level
- Recommended: ¥50+ balance for smooth Claude Code experience

---

### K5: Switching Between Kimi and Other Models

**To switch to Kimi K2.5:**
```json
{
  "model": "kimi-k2-turbo-preview",
  "env": {
    "ANTHROPIC_BASE_URL": "https://api.moonshot.cn/anthropic/",
    "ANTHROPIC_API_KEY": "your-moonshot-key"
  }
}
```

**To switch back to Anthropic:**
```json
{
  "model": "sonnet"
}
```

**To switch to GLM:**
```json
{
  "model": "glm-4.7",
  "env": {
    "ANTHROPIC_BASE_URL": "https://api.z.ai/api/anthropic/",
    "ANTHROPIC_API_KEY": "your-zai-key"
  }
}
```

---

## Section 6: Quick Reference

### Official Documentation Links

| Provider | Documentation URL | API Keys |
|----------|-------------------|----------|
| **Moonshot/Kimi** | https://platform.moonshot.cn/docs | https://platform.moonshot.cn/console/api-keys |
| **Anthropic** | https://docs.anthropic.com | https://console.anthropic.com |
| **Cursor** | https://docs.cursor.com | In-app settings |
| **GLM (Z.AI)** | https://open.bigmodel.cn | https://z.ai |

### Configuration File Locations

| Platform | File Path |
|----------|-----------|
| **Claude Code (Windows)** | `C:\Users\<username>\.claude\settings.json` |
| **Claude Code (macOS/Linux)** | `~/.claude/settings.json` |
| **Cursor (Project)** | `.cursor/mcp.json` |
| **Cursor (User)** | `%APPDATA%\Cursor\User\settings.json` (Windows) |

### Model Name Reference

**Kimi K2.5 Models:**
- `kimi-k2-turbo-preview` - Fast, efficient
- `kimi-k2-thinking-turbo` - Fast with reasoning
- `kimi-k2-thinking` - Standard reasoning
- `kimi-k2-0905-preview` - 256K context
- `kimi-k2-0711-preview` - Previous version

**Anthropic Models:**
- `sonnet` - Default (Claude 3.5 Sonnet)
- `opus` - Most capable
- `haiku` - Fastest

**GLM Models:**
- `glm-4.7` - Most capable
- `glm-4.5-air` - Fast
- `glm-4.6v` - Vision

### Quick Command Reference

```bash
# Backup current settings
cp ~/.claude/settings.json ~/.claude/settings.json.backup

# Edit settings (macOS/Linux)
nano ~/.claude/settings.json

# Edit settings (Windows)
notepad C:\Users\YourName\.claude\settings.json

# Validate JSON syntax
python -m json.tool ~/.claude/settings.json

# Test Kimi API connection
curl -X POST "https://api.moonshot.cn/anthropic/v1/messages" \
  -H "x-api-key: your-key" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{"model":"kimi-k2-turbo-preview","max_tokens":10,"messages":[{"role":"user","content":"test"}]}'

# Test GLM API connection
curl -X POST "https://api.z.ai/api/anthropic/v1/messages" \
  -H "x-api-key: your-key" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{"model":"glm-4.7","max_tokens":10,"messages":[{"role":"user","content":"test"}]}'
```

---

**Last Updated**: 2026-01-28
**Sources Verified**: platform.moonshot.cn, docs.anthropic.com, docs.cursor.com
