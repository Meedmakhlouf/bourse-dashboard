# ============================================================
# Script d'analyse boursière automatique
# Lance /bourse via Claude Code puis push vers GitHub Pages
# ============================================================

$REPO_DIR   = "C:\Users\makhl\Desktop\IA\TestClaude"
$LOG_FILE   = "$REPO_DIR\bourse-run.log"

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content $LOG_FILE "[$timestamp] Démarrage analyse..."

# Lance Claude Code en mode non-interactif avec la skill /bourse
# --print = mode headless (pas d'interface interactive)
$env:CLAUDE_WORKING_DIR = "C:\Users\makhl\Desktop\Projects\bourse"
claude --print "/bourse" 2>&1 | Out-Null

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content $LOG_FILE "[$timestamp] Analyse terminée. Publication GitHub..."

# Copier dashboard → index.html pour GitHub Pages
Copy-Item "$REPO_DIR\bourse-dashboard.html" "$REPO_DIR\index.html" -Force

# Commit et push vers GitHub
Set-Location $REPO_DIR
$date = Get-Date -Format "d MMMM yyyy" -Culture "fr-FR"
git add index.html bourse-dashboard.html
git commit -m "Analyse boursière — $date"
git push origin main

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content $LOG_FILE "[$timestamp] Publié sur GitHub Pages ✓"

Write-Host "Analyse boursière terminée et publiée !" -ForegroundColor Green
