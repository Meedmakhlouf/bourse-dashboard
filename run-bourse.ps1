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

# Commit et push du dashboard public (uniquement s'il y a des changements réels)
# historique-picks.json et portefeuille-utilisateur.json ne vivent PLUS ici :
# ce sont des données sensibles (positions réelles, prix d'acquisition), suivies
# séparément dans le dépôt privé data-privees/ (voir bloc dédié ci-dessous) pour
# que ce dépôt-ci puisse rester public (GitHub Pages).
$date = Get-Date -Format "d MMMM yyyy" -Culture "fr-FR"
git add index.html

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

# Commit et push des données sensibles vers le dépôt privé séparé (data-privees/)
Set-Location "$REPO_DIR\data-privees"
git add historique-picks.json portefeuille-utilisateur.json portefeuille-dashboard.html

$hasPrivateChanges = git diff --cached --quiet; if (-not $?) { $true } else { $false }

if ($hasPrivateChanges) {
    git commit -m "Analyse boursière — $date"
    git push origin master
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content $LOG_FILE "[$timestamp] Données privées publiées sur bourse-donnees-privees ✓"
} else {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content $LOG_FILE "[$timestamp] Aucun changement sur les données privées."
}
Set-Location $REPO_DIR
