# Setup — Dashboard Bourse sur GitHub Pages

> Le projet est désormais unique : tout (skill `/bourse`, dashboard, script, dépôt git) vit dans
> `C:\Users\makhl\Desktop\Projects\bourse`. L'ancien répertoire `C:\Users\makhl\Desktop\IA\TestClaude`
> a été retiré — ne plus s'y référer.

## ÉTAPE 1 — Le repo GitHub existe déjà
Le dépôt `https://github.com/Meedmakhlouf/bourse-dashboard` est déjà créé et connecté
(branche `master`). Rien à refaire ici sauf si vous recommencez sur une nouvelle machine :

```powershell
cd "C:\Users\makhl\Desktop\Projects\bourse"
git remote add origin https://github.com/VOTRE_USERNAME/bourse-dashboard.git
git branch -M master
git push -u origin master
```

## ÉTAPE 2 — Activer GitHub Pages
1. Allez sur https://github.com/Meedmakhlouf/bourse-dashboard
2. Cliquez **Settings** → **Pages** (dans le menu gauche)
3. Source : **Deploy from a branch**
4. Branch : **master** / **(root)**
5. Cliquez **Save**

→ Dashboard accessible à :
   https://Meedmakhlouf.github.io/bourse-dashboard/

## ÉTAPE 3 — Automatiser avec Windows Task Scheduler

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
  -ExecutionPolicy Bypass -File "C:\Users\makhl\Desktop\Projects\bourse\run-bourse.ps1"
  ```
- **Démarrer dans (optionnel)** : `C:\Users\makhl\Desktop\Projects\bourse`
  (le script fait déjà un `Set-Location` explicite vers ce dossier avant d'appeler `claude`,
  donc ce champ n'est plus critique — mais le renseigner évite toute ambiguïté).

### Onglet Conditions
- Décochez "Démarrer uniquement si l'ordinateur est sur secteur"
- Cochez "Démarrer uniquement si une connexion réseau est disponible"

3. Cliquez **OK** et saisissez votre mot de passe Windows si demandé.

### Vérifier que la tâche a bien tourné
```powershell
Get-Content "C:\Users\makhl\Desktop\Projects\bourse\bourse-run.log" -Tail 10
```
Si ce fichier n'existe pas après l'heure prévue, la tâche planifiée ne s'est pas exécutée
(vérifier dans `taskschd.msc` → historique de la tâche).

## RÉSULTAT FINAL
- **Chaque matin à 8h00** (lun-ven) : Claude analyse les marchés automatiquement
- **Le dashboard (`index.html`) et l'historique des picks (`historique-picks.json`) sont mis à jour**
  et commit/push automatiquement s'il y a un vrai changement
- **Accessible depuis votre téléphone** : https://Meedmakhlouf.github.io/bourse-dashboard/
- **Logs** consultables dans : `C:\Users\makhl\Desktop\Projects\bourse\bourse-run.log`
