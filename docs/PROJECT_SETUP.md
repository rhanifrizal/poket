# Repository Setup Notes

## Suggested local folder
```bash
mkdir -p ~/Developer
cd ~/Developer
mkdir poket
cd poket
```

Keep the documentation in the repository root so `AGENTS.md` provides Codex project instructions.

## Initialise Git locally
```bash
git init -b main
git status
git add README.md AGENTS.md docs prompts .gitignore
git commit -m "docs: define Poket product and technical foundation"
```

Do not create a remote repository until the project name and documentation are approved.

## Optional GitHub remote (only after you approve)
Install and authenticate GitHub CLI, then:
```bash
gh auth status
gh repo create poket --private --source=. --remote=origin
git push -u origin main
```

Before pushing, inspect staged files and confirm no secrets, personal data or credentials are present.

## Start Codex
```bash
cd ~/Developer/poket
```
Open the repository in Codex and use the staged workflow in `prompts/DEVELOPMENT_WORKFLOW.md` as applicable.
