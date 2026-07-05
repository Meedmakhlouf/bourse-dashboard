# ============================================================
# Script d'analyse boursière automatique
# Lance /bourse via Claude Code depuis Projects\bourse puis push vers GitHub Pages
# ============================================================

$REPO_DIR = "C:\Users\makhl\Desktop\Projects\bourse"
$LOG_FILE = "$REPO_DIR\bourse-run.log"

Set-Location $REPO_DIR

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content $LOG_FILE "[$timestamp] Démarrage analyse (cwd: $REPO_DIR)..."

# Lance Claude Code en mode non-interactif avec la skill /bourse
# --print = mode headless (pas d'interface interactive)
# Le cwd (Set-Location ci-dessus) est ce qui permet à Claude Code de trouver
# .claude/commands/bourse.md — une variable d'environnement ne suffit pas.
claude --print "/bourse" 2>&1 | Out-Null

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content $LOG_FILE "[$timestamp] Analyse terminée. Publication GitHub..."

# Commit et push vers GitHub (uniquement s'il y a des changements réels)
$date = Get-Date -Format "d MMMM yyyy" -Culture "fr-FR"
git add index.html historique-picks.json

$hasChanges = git diff --cached --quiet; if (-not $?) { $true } else { $false }

if ($hasChanges) {
    git commit -m "Analyse boursière — $date"
    git push origin master
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content $LOG_FILE "[$timestamp] Publié sur GitHub Pages ✓"
    Write-Host "Analyse boursière terminée et publiée !" -ForegroundColor Green
} else {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content $LOG_FILE "[$timestamp] Aucun changement détecté, rien à publier."
    Write-Host "Analyse terminée, aucun changement à publier." -ForegroundColor Yellow
}
