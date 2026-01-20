"""
Minimal MCP wrapper for MiniMax API to expose code agent tools.
Exposes: coding_plan_general and coding_plan_execute
"""

import os
import re
from typing import Optional

import httpx
from mcp.server.fastmcp import FastMCP
from mcp.types import TextContent

MINIMAX_API_KEY = os.environ.get(
    "MINIMAX_API_KEY",
    "sk-cp-xgttGx8GfmjMzMR64zQOU0BXYjrikYD0nSTMfWBbIT0Ykq17fUeT3f7Dmmt2UOQaskwOjaOPxMYk6jev0G4Av2-znT8-a3aRWGfHVpgMvgzc8dVYc4W8U6c",
)
MINIMAX_API_HOST = os.environ.get("MINIMAX_API_HOST", "https://api.minimax.io")
MINIMAX_API_SOURCE = "MiniMax-MCP-Wrapper"
MINIMAX_MODEL = os.environ.get("MINIMAX_MODEL", "MiniMax-M2.1")

mcp = FastMCP("MiniMax-Wrapper")


def call_minimax_chat(messages: list[dict[str, str]]) -> dict:
    """Call MiniMax OpenAI-compatible chat completions API."""
    url = f"{MINIMAX_API_HOST}/v1/chat/completions"
    payload = {
        "model": MINIMAX_MODEL,
        "messages": messages,
    }
    headers = {
        "Authorization": f"Bearer {MINIMAX_API_KEY}",
        "Content-Type": "application/json",
        "MM-API-Source": MINIMAX_API_SOURCE,
    }

    try:
        response = httpx.post(url, json=payload, headers=headers, timeout=30.0)
        response.raise_for_status()
        return response.json()
    except httpx.HTTPError as exc:
        return {
            "error": f"HTTP error: {exc}",
            "response_status": getattr(exc.response, "status_code", None)
            if exc.response
            else None,
        }
    except Exception as exc:
        return {"error": f"Error: {exc}"}


def strip_think_blocks(text: str) -> str:
    """Remove <think> blocks from model output to keep responses concise."""
    return re.sub(r"<think>.*?</think>", "", text, flags=re.DOTALL).strip()


@mcp.tool()
def coding_plan_general(prompt: str, context: Optional[str] = None) -> TextContent:
    """General coding queries for MiniMax."""
    if not prompt:
        return TextContent(type="text", text='Error: "prompt" parameter is required')

    full_prompt = prompt
    if context:
        full_prompt = f"Context: {context}\n\nQuery: {prompt}"

    messages = [
        {
            "role": "system",
            "content": "You are a concise coding assistant. Provide direct, actionable answers.",
        },
        {"role": "user", "content": full_prompt},
    ]

    result = call_minimax_chat(messages)
    if "error" in result:
        return TextContent(
            type="text", text=f"Error calling MiniMax API: {result['error']}"
        )

    message = result.get("choices", [{}])[0].get("message", {}).get("content", "")
    if not message:
        return TextContent(type="text", text=f"Unexpected response: {result}")

    return TextContent(type="text", text=strip_think_blocks(message))


@mcp.tool()
def coding_plan_execute(
    prompt: Optional[str] = None,
    plan: Optional[str] = None,
    context: Optional[str] = None,
) -> TextContent:
    """Execute structured plans with MiniMax."""
    if not prompt and not plan:
        return TextContent(
            type="text",
            text='Error: Either "prompt" or "plan" parameter is required',
        )

    parts = []
    if plan:
        parts.append(f"Plan: {plan}")
    if prompt:
        parts.append(f"Task: {prompt}")
    if context:
        parts.append(f"Context: {context}")

    full_prompt = "\n\n".join(parts)
    messages = [
        {
            "role": "system",
            "content": "You are a coding plan executor. Follow the plan and provide results.",
        },
        {"role": "user", "content": full_prompt},
    ]

    result = call_minimax_chat(messages)
    if "error" in result:
        return TextContent(
            type="text", text=f"Error calling MiniMax API: {result['error']}"
        )

    message = result.get("choices", [{}])[0].get("message", {}).get("content", "")
    if not message:
        return TextContent(type="text", text=f"Unexpected response: {result}")

    return TextContent(type="text", text=strip_think_blocks(message))


def main() -> None:
    """Run the MCP server."""
    mcp.run()


if __name__ == "__main__":
    main()
