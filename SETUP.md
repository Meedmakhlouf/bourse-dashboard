# Setup — Dashboard Bourse sur GitHub Pages

## ÉTAPE 1 — Créer le repo GitHub
1. Allez sur https://github.com/new
2. Nom du repo : `bourse-dashboard`
3. Cochez **Public**
4. NE cochez PAS "Add README" (le repo doit être vide)
5. Cliquez "Create repository"

## ÉTAPE 2 — Connecter le repo local à GitHub
Ouvrez PowerShell et copiez-collez ces commandes (remplacez VOTRE_USERNAME) :

```powershell
cd "C:\Users\makhl\Desktop\IA\TestClaude"
git remote add origin https://github.com/VOTRE_USERNAME/bourse-dashboard.git
git branch -M main
git push -u origin main
```

## ÉTAPE 3 — Activer GitHub Pages
1. Allez sur https://github.com/VOTRE_USERNAME/bourse-dashboard
2. Cliquez **Settings** → **Pages** (dans le menu gauche)
3. Source : **Deploy from a branch**
4. Branch : **main** / **(root)**
5. Cliquez **Save**

→ Dans 1-2 minutes, votre dashboard sera accessible à :
   https://VOTRE_USERNAME.github.io/bourse-dashboard/

## ÉTAPE 4 — Automatiser avec Windows Task Scheduler

1. Appuyez sur **Win + R**, tapez `taskschd.msc`, validez
2. Cliquez **Créer une tâche** (pas "tâche simple")

### Onglet Général
- Nom : `Analyse Boursière Quotidienne`
- Cochez : **Exécuter même si l'utilisateur n'est pas connecté**
- Cochez : **Exécuter avec les autorisations maximales**

### Onglet Déclencheurs → Nouveau
- Début : **Selon un programme**
- Paramètres : **Hebdomadaire**, lun + mar + mer + jeu + ven
- Heure : **08:00:00**

### Onglet Actions → Nouveau
- Programme : `powershell.exe`
- Arguments :
  ```
  -ExecutionPolicy Bypass -File "C:\Users\makhl\Desktop\IA\TestClaude\run-bourse.ps1"
  ```

### Onglet Conditions
- Décochez "Démarrer uniquement si l'ordinateur est sur secteur"
- Cochez "Démarrer uniquement si une connexion réseau est disponible"

3. Cliquez **OK** et saisissez votre mot de passe Windows si demandé.

## RÉSULTAT FINAL
- **Chaque matin à 8h00** (lun-ven) : Claude analyse les marchés automatiquement
- **Le dashboard est mis à jour** sur GitHub Pages
- **Accessible depuis votre téléphone** : https://VOTRE_USERNAME.github.io/bourse-dashboard/
- **Logs** consultables dans : C:\Users\makhl\Desktop\IA\TestClaude\bourse-run.log
