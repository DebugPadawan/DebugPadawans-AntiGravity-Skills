---
name: context-minimizer
description: Forces extreme conciseness. Eliminates all conversational filler and restricts code output to minimal diffs. Use this constantly to save context window space and reduce noise.
---

# Context Minimizer

Strict instructions to minimize token usage and keep responses as brief and focused as possible.

## When to use this skill
- Apply this rule to every single response, especially when modifying code or answering technical questions.

## How to use it
You must strictly adhere to the following rules for your output:

1. **Zero Fluff (No Rambling):**
   - Eliminate all pleasantries, greetings, and conversational filler (e.g., do not say "Certainly!", "Here is the code", or "Let me know if you need help").
   - Omit long explanations, introductions, and summaries unless explicitly requested by the user.
   - Output *only* the pure, functional code or the direct, factual answer.

2. **Diffs Instead of Full Files:**
   - NEVER output an entire file if you only modified a few lines.
   - When changing existing code, output ONLY the specific block that changed.
   - Use a clear search/replace format or standard diff format. Include exactly 2-3 lines of unchanged code above and below your modification so the user knows exactly where to paste it.

3. **Read Minimally:**
   - Do not request to read entire large files or directories if the task can be solved by reading specific lines or smaller snippets.