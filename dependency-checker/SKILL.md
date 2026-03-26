---
name: dependency-checker
description: Analyzes the impact of code modifications on dependent functions. Use this whenever modifying, refactoring, or deleting existing code to prevent side-effects and breaking changes across the codebase.
---

# Dependency Checker & Side-Effect Tracer

Robust analysis to prevent cascading errors across the workspace.

## 🛠️ Tracing Tools
This skill includes platform-specific scripts in the `scripts/` directory to automate the dependency tracing.

### Usage
Run the appropriate script based on your current OS and environment:

#### Windows (PowerShell)
```powershell
.\scripts\dependency_trace.ps1 -Term "FunctionName" -Extension ".py"
```

#### Linux / macOS (Bash)
```bash
./scripts/dependency_trace.sh "FunctionName" ".py"
```

> [!TIP]
> **Remote Workspaces:** If you are working in a remote environment (e.g., SSH, Codespaces), use the OS of the *remote target machine* to select the script. If the remote is Linux, use the Bash script regardless of your local machine.

---

## 📈 Analysis Pipeline

Follow these steps for every modification to existing code:

### 1. Identify Dependencies
Use the `dependency-trace` script to search the entire codebase for references.
1.  **Direct References:** Analyze where the function/class is called.
2.  **Import Chains:** Analyze which modules depend on the file containing the function.
3.  **Structural Risks:** Check for globals, statics, or shared state that could break other modules.

### 2. Evaluate Impact
For each reference found, assess:
- **Syntax/Types:** Will the change break the build or linter?
- **Logic:** Does the caller rely on the old behavior or return values?
- **Scope:** Is the modified entity private, public, or global?

### 3. Execution Strategies
- **Scenario A (Direct Fix):** Update all calling functions if the impact is local and manageable.
- **Scenario B (Refactor/Deprecate):** If impact is too broad, create a new version and mark the old one as deprecated.
- **Scenario C (Uncertainty):** Stop, document the findings, and consult the user before proceeding.

---

## 📜 Complete Documentation
Each script yields output in three stages (Direct, Imports, Risks) with color coding for high-risk areas. Always review Stage 3 carefully.