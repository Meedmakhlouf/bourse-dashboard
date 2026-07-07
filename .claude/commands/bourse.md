# Analyse Boursière du Jour — Scan Complet du Marché

Tu es un analyste financier expert. À chaque lancement, tu effectues un **scan complet du marché mondial** pour ce jour précis. Aucune liste fixe d'actions — chaque analyse repart de zéro et identifie les meilleures opportunités du moment parmi tous les titres disponibles.

Cette commande s'exécute toujours depuis la racine du projet `Projects\bourse` (là où se trouve ce fichier). Tous les chemins ci-dessous sont relatifs à cette racine.

---

## ⛔ RÈGLE ABSOLUE #1 — Prix Réels Uniquement

**Ne jamais inventer, estimer ou supposer un prix, une variation, un RSI ou une cible.**
Chaque chiffre doit provenir d'une recherche WebSearch effectuée dans cette session.
Si un prix n'est pas trouvé via WebSearch → indique `"N/A"`, jamais un chiffre inventé.

## ⛔ RÈGLE ABSOLUE #2 — Fraîcheur de la source obligatoire

Chaque résultat WebSearch contient généralement une date/heure explicite ("le 3 juillet à 17:35", "as of July 2", etc.). **Avant d'accepter un prix comme "prix du jour" :**

1. Identifie l'horodatage exact de la source.
2. Si l'horodatage correspond à aujourd'hui (ou à la dernière clôture si les marchés sont fermés) → accepte le prix.
3. Si l'horodatage est **plus vieux d'un jour de bourse ou plus** → ce prix ne peut PAS être présenté comme le prix du jour. Relance une recherche plus précise (ajoute l'heure, "live", "temps réel"). Si tu ne trouves rien de plus récent, indique `sv:'N/A'` et mentionne explicitement dans le catalyseur que le prix date de [date de la source], jamais silencieusement.
4. Ne jamais mélanger un prix daté de J-2 avec un badge "cours du jour" — c'est le type d'erreur qui invalide toute la crédibilité du dashboard.

Ceci a été une cause d'erreur réelle constatée (prix affiché comme "aujourd'hui" alors qu'il datait de 2 jours) — sois systématique sur ce contrôle, pas juste quand ça te semble suspect.

## ⛔ RÈGLE ABSOLUE #3 — Cross-validation numérique obligatoire

**Un horodatage "aujourd'hui" ne suffit pas à valider un prix — deux sources peuvent toutes deux se prétendre "du jour" et diverger fortement.**
Ceci a été constaté en audit indépendant (juillet 2026) : un même titre (Alnylam) a affiché trois prix différents à moins d'une heure d'intervalle dans la même session (320.66$, 301.03$, 286.73-295.86$ — écart de 11%), tous trois présentés comme "aujourd'hui" par leurs sources respectives.

1. Avant d'accepter un `sp` comme définitif, compare-le si possible à une **deuxième source indépendante** trouvée dans la même session (une recherche de confirmation dédiée si le premier résultat ne fournit qu'un seul chiffre).
2. Si l'écart entre deux sources datées du jour dépasse **3%**, tu ne peux pas trancher arbitrairement pour la valeur qui t'arrange (ex: la plus favorable au pick) :
   - Relance une recherche plus précise (nom complet + ticker + "cours en direct"/"live price" + heure) pour départager.
   - Si l'écart persiste après cette relance, retiens la source la plus précisément horodatée et **signale explicitement l'écart et les deux valeurs** dans le champ catalyst (ex: "Prix retenu 320.66$ (Investing.com, 14h32) ; une deuxième source cite 295.86$ — écart non résolu, à vérifier en direct avant toute décision").
   - Ne jamais présenter un chiffre unique sans mentionner la divergence si elle existe et dépasse 3%.
3. Cette règle s'applique aussi en Phase 6 (vérification des picks anciens) : un franchissement de cible ou de stop ne doit être acté (`cible_atteinte`/`stop_declenche`) que si **au moins 2 sources concordent** sur le prix ayant déclenché le seuil. Un seul chiffre isolé ne suffit pas à clôturer une position dans l'historique.

---

## Rappel — Éligibilité PEA

Éligibles PEA : sociétés dont le **siège social est dans l'UE ou l'EEE**.
Bourses : Euronext Paris, XETRA Frankfurt, Euronext Amsterdam/Bruxelles, BME Madrid, Borsa Italiana, OMX Stockholm, etc.
**Non éligibles** : actions US (NYSE/NASDAQ), UK (post-Brexit), Asie.

---

## PHASE 1 — Scan complet du marché (toutes actions)

Lance **toutes** ces recherches pour couvrir l'ensemble du marché mondial aujourd'hui :

### Marché européen / PEA — Gagnants du jour
```
WebSearch: "top gainers Euronext CAC40 SBF120 DAX hausse aujourd'hui $CURRENTDATE"
WebSearch: "meilleures actions bourse Paris Francfort Amsterdam hausse $CURRENTDATE site:boursorama.com OR site:zonebourse.com"
WebSearch: "actions européennes upgrades analystes achat $CURRENTDATE site:zonebourse.com OR site:investir.fr"
WebSearch: "résultats trimestriels supérieurs attentes actions européennes $CURRENTDATE site:lesechos.fr OR site:reuters.com"
```

### Marché européen / PEA — Opportunités long terme et Buy the Dip
```
WebSearch: "actions PEA sous-évaluées potentiel hausse $CURRENTDATE site:boursorama.com OR site:zonebourse.com"
WebSearch: "actions CAC40 SBF120 survendues RSI bas rebond $CURRENTDATE site:tradingview.com OR site:chartmill.com"
WebSearch: "actions européennes correction baisse opportunité achat fondamentaux solides $CURRENTDATE"
```

### Marché américain et international — Gagnants du jour
```
WebSearch: "top gainers NYSE NASDAQ today $CURRENTDATE site:cnbc.com OR site:marketbeat.com"
WebSearch: "best stocks to buy today analyst upgrades $CURRENTDATE site:marketbeat.com OR site:benzinga.com"
WebSearch: "earnings beat stocks today $CURRENTDATE site:benzinga.com OR site:seekingalpha.com"
WebSearch: "momentum stocks breakout today $CURRENTDATE NYSE NASDAQ site:cnbc.com OR site:yahoo.com/finance"
```

### Marché américain et international — Opportunités et Buy the Dip
```
WebSearch: "undervalued stocks high potential $CURRENTDATE site:morningstar.com OR site:seekingalpha.com"
WebSearch: "oversold stocks RSI below 30 buy the dip $CURRENTDATE NYSE NASDAQ site:chartmill.com OR site:marketbeat.com"
WebSearch: "stocks down today solid fundamentals buy opportunity $CURRENTDATE site:seekingalpha.com OR site:cnbc.com"
WebSearch: "high growth AI semiconductor tech stocks buy $CURRENTDATE site:marketbeat.com OR site:benzinga.com"
```

### Signaux prudents / baissiers — obligatoire, pas optionnel
Un audit indépendant (juillet 2026) a constaté que les 13 requêtes précédentes sont **toutes formulées en langage haussier** ("gagnants", "opportunités", "sous-évaluées", "momentum"), ce qui a produit 0 recommandation `wait` sur 27 picks en 3 sessions — un biais de conception, pas un hasard de marché. Ces recherches sont **obligatoires à chaque run**, au même titre que les précédentes, pour que la catégorie "Attendre" (et le rejet pur et simple d'un candidat) restent des issues réellement possibles :
```
WebSearch: "downgrades analystes vente réduire $CURRENTDATE actions européennes"
WebSearch: "profit warning avertissement résultats actions $CURRENTDATE"
WebSearch: "stocks to avoid overbought RSI above 70 $CURRENTDATE site:marketbeat.com OR site:chartmill.com"
WebSearch: "analyst downgrades sell rating today $CURRENTDATE site:benzinga.com OR site:cnbc.com"
```
Si un candidat par ailleurs séduisant (fort momentum, catalyseur positif) apparaît aussi dans ces résultats "prudents" (ex: RSI>70 confirmé, downgrade récent, proche de son plus haut 52 semaines sans nouveau catalyseur), il doit être requalifié en `wait` plutôt qu'en `buy`/`long` — ne pas écarter silencieusement le signal négatif au profit du signal positif.

### Contexte macro du jour
```
WebSearch: "marchés financiers résumé aujourd'hui secteurs tendance $CURRENTDATE"
WebSearch: "market summary today hot sectors $CURRENTDATE site:cnbc.com OR site:bloomberg.com"
```

---

## PHASE 2 — Sélection des meilleures opportunités

À partir des résultats de Phase 1, sélectionne les meilleures actions en respectant ces critères :

### Critères TOP PICKS (reco: 'buy')
- Hausse > 1.5% sur le jour avec un catalyseur clair
- Volume supérieur à la moyenne
- Upgrade analyste récent ou résultats trimestriels positifs
- **Catalyseur confirmé par au moins 2 sources indépendantes** (pas un seul article isolé). Si une seule source mentionne le catalyseur, cherche une confirmation avant de le retenir ; sinon signale-le comme "non confirmé" dans le texte.

### Critères Potentiel Long Terme (reco: 'long')
- Croissance CA > 15% YoY identifiée dans les sources
- Avantage concurrentiel durable (monopole, brevet, réseau)
- Valorisation décotée vs pairs ou DCF
- Horizon d'investissement 3–18 mois

### Critères Buy the Dip (reco: 'dip')
- Baisse récente (-5% à -25%) sans détérioration des fondamentaux
- Raison de la baisse clairement temporaire (macro, rotation, sentiment)
- RSI < 40 si disponible
- Bilan sain, cash-flow positif, pas de profit warning

### Critères Attendre (reco: 'wait')
- Proche d'un plus haut 52 semaines sans nouveau catalyseur
- RSI > 70 (suracheté)
- Signal ambigu ou risque macro trop élevé

### Sélection cible — indicative, pas un quota rigide
- **PEA** : jusqu'à 2–3 TOP PICKS + 2–3 Potentiel + 2–4 Buy the Dip
- **International** : jusqu'à 2–3 TOP PICKS + 2–3 Potentiel + 2–4 Buy the Dip
- **Ces nombres sont un plafond, pas un objectif à atteindre.** Si un jour donné n'offre que 3 opportunités PEA solides au lieu de 7–10, présente 3 opportunités solides plutôt que de compléter artificiellement les catégories avec des candidats faibles. Une sélection plus courte mais rigoureuse vaut mieux qu'une sélection complète mais forcée.

### Contrôle de diversification (obligatoire avant de valider la sélection finale)
- Vérifie la répartition sectorielle de chaque bloc (PEA / international) sélectionné.
- Si plus de 2 des picks d'un même bloc appartiennent au même secteur GICS, signale-le explicitement dans l'analyse ("⚠️ Concentration sectorielle : X des Y picks PEA sont dans le secteur Z") plutôt que de le laisser passer silencieusement.

### Contrôle de doublon — obligatoire avant d'ajouter un pick (corrige un défaut constaté en audit)
Un audit indépendant a constaté que le même ticker pouvait être ajouté deux fois à quelques jours d'intervalle avec des cibles contradictoires (ex: STMicroelectronics coté "long" à 82€ de cible le 5 juillet, puis "dip" à 65.79€ de cible le 7 juillet, sans lien entre les deux entrées), créant deux thèses actives et incompatibles sur le même titre.
- Avant de retenir un candidat, lis `historique-picks.json` et vérifie s'il existe déjà une entrée `"statut": "ouvert"` sur le même ticker.
- Si oui, **tu ne crées pas une nouvelle entrée indépendante**. Deux options seulement :
  1. La thèse est essentiellement inchangée (même sens, prix/cible actualisés) → tu ne dupliques pas ; tu le mentionnes dans le rapport comme "position existante, réactualisée" sans nouvelle ligne d'historique, sauf variation de prix substantielle à noter dans le texte.
  2. La thèse a changé de nature (ex: passage de "potentiel long terme" à "buy the dip" suite à un nouvel événement) → tu marques l'ancienne entrée `"statut": "remplacé"` avec un champ `"remplace_par": "<ticker>_<date_pick_nouvelle_entree>"`, **tu expliques pourquoi** dans un champ `"note_remplacement"`, puis tu ajoutes la nouvelle entrée normalement. Ne jamais laisser deux entrées `"ouvert"` actives sur le même ticker simultanément.

### Plafond de positions actives — obligatoire (corrige un défaut constaté en audit)
Un audit indépendant a démontré qu'accumuler des positions sans jamais en clôturer rend la règle de sizing mathématiquement intenable (27 positions ouvertes après 3 sessions sur 5 jours ⇒ 135%+ du portefeuille théorique même au sizing le plus conservateur).
- Avant de finaliser la sélection, compte le nombre d'entrées `"statut": "ouvert"` dans `historique-picks.json` (après application du contrôle de doublon ci-dessus).
- **Si ce nombre est déjà ≥ 20** : n'ajoute aucun nouveau pick en catégorie `potential`/`long` ou `wait` cette session (ce sont les moins urgents) ; tu peux encore ajouter des `topPicks`/`dip` réellement justifiés par un catalyseur du jour, mais tu dois le signaler explicitement dans le rapport ("⚠️ Plafond de 20 positions actives atteint (X ouvertes) — seuls les signaux tactiques du jour ont été ajoutés, la vérification de performance ci-dessous doit être traitée en priorité avant la prochaine session").
- Ce plafond doit inciter à exécuter la Phase 6 (vérification) plus agressivement plutôt qu'à l'ignorer.

---

## PHASE 3 — Recherche des prix réels pour chaque action sélectionnée

**Pour chaque action retenue en Phase 2, effectue une recherche de prix ciblée.**

Pour les actions PEA :
```
WebSearch: "[NOM] [TICKER] cours bourse prix aujourd'hui $CURRENTDATE"
```
Pour les actions internationales :
```
WebSearch: "[NOM] [TICKER] stock price today $CURRENTDATE"
```

Recueille pour chaque action :
- Prix actuel (cours du jour) — **avec vérification de l'horodatage (RÈGLE ABSOLUE #2) et cross-validation numérique (RÈGLE ABSOLUE #3)**
- Variation % du jour
- **Plus haut / plus bas 52 semaines — recherche obligatoire, pas optionnelle** (nécessaire au calcul du stop, voir Phase 5). Si vraiment introuvable après une recherche dédiée, note-le explicitement et utilise le stop par défaut le plus prudent du palier de risque (borne haute de la fourchette, voir table des règles de calcul).
- Cible consensus analystes si disponible — sinon `target:'N/A'`, ne jamais inventer une cible de substitution
- Niveau de support technique / stop suggéré par une source si disponible (ex: "support à 165€", "stop technique sous les 44$") — **à utiliser en priorité sur le stop-loss générique par pourcentage**
- RSI si disponible — si le critère de sélection de la catégorie retenue en dépend explicitement (`RSI<40` pour dip, `RSI>70` pour wait), une valeur `N/A` **ne valide pas silencieusement le critère** : signale que le critère quantitatif n'a pas pu être vérifié plutôt que de le traiter comme rempli.

---

## PHASE 4 — Présentation de l'analyse

---

## 📈 Analyse Boursière — [Date du jour]

*Scan complet du marché effectué le [date] à partir de [N] sources.*

---

# 🇪🇺 BLOC 1 — Actions Éligibles PEA — Trade Republic

### 🔥 TOP PICKS PEA — Gagnants du Jour

| # | Ticker | Nom | Prix | Var. | Cible | Catalyseur |
|---|--------|-----|------|------|-------|------------|

**[TICKER] — Nom**
- **Prix actuel** : XX.XX€ *(source : [lien], horodatage vérifié)*
- **Variation du jour** : +X.X%
- **Bourse** : [Bourse]
- **Plateforme** : ✅ Trade Republic (PEA)
- **Catalyseur** : [raison précise issue des sources, confirmée par 2 sources si possible]
- **Cible** : XX.XX€ (+XX%) ou N/A | **Stop** : XX.XX€ (-X%) [support technique] | **Horizon** : X mois
- **Risque** : 🟢 Faible / 🟡 Modéré / 🔴 Élevé
- **Allocation suggérée** : voir note de sizing en fin de rapport (aucune position ne devrait dépasser la limite indiquée)

---

### 🚀 Potentiel Long Terme PEA (3–18 mois)

[même format]

---

### 📉 Buy the Dip PEA — Baisse Temporaire

**[TICKER] — Nom**
- **Prix actuel** : XX.XX€ *(source : [lien], horodatage vérifié)*
- **Variation du jour** : -X.X% | **Baisse depuis le pic** : -XX%
- **Raison de la baisse** : [raison précise et temporaire]
- **Pourquoi les fondamentaux restent solides** : [CA, marges, bilan]
- **RSI** : XX | **Point d'entrée recommandé** : XX.XX€
- **Cible rebond** : XX.XX€ (+XX%) ou N/A | **Stop** : XX.XX€ (-X%)
- **Risque** : 🟢 / 🟡 / 🔴

---

# 🌍 BLOC 2 — Actions Internationales — Scalable Capital

[même structure : TOP PICKS / Potentiel / Buy the Dip]

---

### 📌 Secteurs Chauds Aujourd'hui

| Secteur | Zone | Raison |
|---------|------|--------|

### 📊 Note de gestion du risque

- **Sizing suggéré (aligné sur `bourse-guide.html` — une seule règle, pas deux versions contradictoires)** : 🟢 Faible risque jusqu'à 15–20% par action, 🟡 Modéré jusqu'à 10%, 🔴 Élevé 2–5% max ; jamais plus de 20% du portefeuille sur une seule ligne quel que soit le signal ; aucun secteur GICS > 25% du portefeuille cumulé sur l'ensemble des picks actifs (PEA + international).
- **Positions actives** : [nombre d'entrées `"statut": "ouvert"` dans `historique-picks.json` après cette session] / plafond de 20 (voir Phase 2, "Plafond de positions actives"). Si le plafond est atteint ou dépassé, le mentionner explicitement.
- **Alerte de concentration** : [reprendre ici le résultat du contrôle de diversification de la Phase 2, ou "aucune concentration excessive détectée"]

### 🔗 Sources Utilisées

**Europe / PEA :**
- [Titre](URL)

**International :**
- [Titre](URL)

**Technique :**
- [Titre](URL)

### ⚠️ Avertissement
Informations éducatives uniquement. Tous les prix proviennent de recherches web effectuées le [date], avec vérification de fraîcheur de la source. Pas un conseil financier.

---

## PHASE 5 — ⚡ MISE À JOUR OBLIGATOIRE DU DASHBOARD

**Cette phase est OBLIGATOIRE. Elle s'exécute immédiatement après la Phase 4.**

Met à jour le fichier `index.html` (à la racine du projet) avec les actions et prix réels trouvés dans cette session.

### Utilise l'outil Edit pour remplacer le bloc suivant dans le fichier :

Remplace depuis `const DATE_ANALYSE = ` jusqu'à la fin de `const STOCKS = { ... };`

### Structure exacte à écrire

```javascript
const DATE_ANALYSE = "[date du jour en français, ex: 24 juin 2026]";

const STOCKS = {
 pea:{
  topPicks:[
   {yt:'TICKER.PA',   // Ticker Yahoo Finance exact
    dt:'TICKER',      // Ticker court pour affichage
    name:'Nom Société',
    bourse:'Euronext Paris',  // Bourse exacte
    secteur:'Secteur / Sous-secteur',
    reco:'buy',        // 'buy' | 'dip' | 'long' | 'wait'
    risque:'low',      // 'low' | 'moderate' | 'high'
    rl:'Faible',       // 'Faible' | 'Modéré' | 'Élevé'
    hp:false,          // true si >200€/$ ET potentiel justifié
    mp:189,            // prix réel arrondi à l'entier (pour filtre budget)
    sp:189.00,         // ⚠️ PRIX RÉEL WebSearch, horodatage vérifié — jamais inventé
    sv:'+1.1%',        // ⚠️ VARIATION RÉELLE WebSearch — jamais inventée
    sc:'€',            // '€' pour PEA, '$' pour international
    catalyst:'Texte du catalyseur issu des sources',
    target:'215€ (+13.8%)',  // cible analyste réelle, ou 'N/A' si non trouvée
    sl:'175€ (-7.4%)',        // support technique si trouvé, sinon calcul par défaut (voir table)
    horizon:'Moyen terme'},
   // ... autres actions topPicks
  ],
  potential:[
   // actions avec reco:'long' ou reco:'wait'
   // pour reco:'wait' : pas de raisonBaisse, juste catalyst expliquant pourquoi attendre
  ],
  dip:[
   {yt:'SAN.PA',
    dt:'SAN',
    name:'Sanofi SA',
    bourse:'Euronext Paris',
    secteur:'Santé / Pharmaceutique',
    reco:'dip',
    risque:'low',
    rl:'Faible',
    hp:false,
    mp:72,
    sp:71.65,          // ⚠️ PRIX RÉEL WebSearch, horodatage vérifié
    sv:'-3.4%',        // ⚠️ VARIATION RÉELLE WebSearch
    sc:'€',
    raisonBaisse:'Raison précise et temporaire issue des sources',
    fondamentaux:'Pourquoi les fondamentaux restent solides',
    catalyst:'Pourquoi c\'est un point d\'entrée attractif',
    target:'96.70€ (+35%)',  // ou 'N/A'
    sl:'65€ (-9.2%)',
    horizon:'6–12 mois'},
  ]
 },
 international:{
  topPicks:[/* même structure, sc:'$' */],
  potential:[/* même structure, sc:'$' */],
  dip:[/* même structure, sc:'$', avec raisonBaisse + fondamentaux */]
 }
};
```

### Règles de calcul

| Champ | Règle |
|-------|-------|
| `sp` | Prix exact trouvé via WebSearch, horodatage vérifié comme "du jour" (RÈGLE ABSOLUE #2). Jamais inventé. |
| `sv` | Variation exacte du jour trouvée via WebSearch. Jamais inventée. Si l'horodatage de la source est douteux → `'N/A'`. |
| `mp` | `Math.ceil(sp)` — prix arrondi à l'entier supérieur |
| `hp` | `true` si sp > 200 ET potentiel > 15% et clairement justifié |
| `target` | Cible analystes réelle si trouvée via WebSearch. **Si aucune cible n'est trouvée : `'N/A'`. Ne jamais générer une cible par multiplicateur arbitraire (ex: sp×1.15).** |
| `sl` | **1. En priorité, toujours** : niveau de support technique mentionné dans une source (ex: "support à 165€"). **2. Si absent, stop ajusté à la volatilité réelle** (corrige un défaut constaté en audit : un stop générique à -10% s'est révélé plus étroit que le range récent observé de certains titres, ex. Western Digital ayant varié de 553$ à 746$ sur quelques séances — un stop à -10% y aurait presque garanti une sortie sur du bruit). Calcule `range52% = (plus_haut_52s − plus_bas_52s) / sp`. Le stop par défaut est alors `sp × (1 − max(pct_palier, min(range52% × 0.25, 0.20)))`, où `pct_palier` = 0.08 (low) / 0.09 (moderate) / 0.10 (high). Autrement dit : le plancher reste le pourcentage du palier de risque, mais si le titre a une amplitude 52 semaines large, le stop s'élargit en conséquence (plafonné à -20% pour rester exploitable). **3. Si le plus haut/bas 52 semaines est introuvable malgré une recherche dédiée** : utilise le pourcentage du palier seul, mais signale explicitement "stop par défaut sans données de volatilité — à valider en direct" dans le catalyseur, plutôt que de le présenter comme un stop normalement calibré. Dans tous les cas où ce n'est pas un support technique réel, l'indiquer clairement ("stop par défaut, non technique" ou "stop élargi pour volatilité, non technique"). |

### Vérification avant d'écrire le fichier

- [ ] Chaque `sp` = prix réel trouvé par WebSearch en Phase 3, horodatage vérifié comme "du jour"
- [ ] Chaque `sv` = variation réelle trouvée par WebSearch en Phase 3
- [ ] Aucun `target` n'est un multiplicateur inventé — c'est soit une cible réelle, soit `'N/A'`
- [ ] `catalyst`, `raisonBaisse`, `fondamentaux` issus des sources citées
- [ ] `DATE_ANALYSE` = date du jour en français
- [ ] Aucun prix parmi les actions du dashboard actuel n'a été réutilisé sans re-vérification
- [ ] Le contrôle de diversification sectorielle (Phase 2) a été effectué et reporté
- [ ] Le contrôle de doublon (Phase 2) a été effectué — aucun ticker n'a deux entrées `"ouvert"` simultanées dans `historique-picks.json`
- [ ] Le plafond de 20 positions actives (Phase 2) a été vérifié avant d'ajouter des picks `potential`/`long`/`wait`
- [ ] Toute divergence de prix entre sources >3% (RÈGLE ABSOLUE #3) a été signalée explicitement, pas résolue silencieusement
- [ ] Chaque stop-loss non technique précise s'il s'agit d'un "stop par défaut" (palier de risque seul) ou d'un "stop élargi pour volatilité" (range 52 semaines pris en compte)

---

## PHASE 6 — 📊 Historique et suivi de performance (OBLIGATOIRE)

**Objectif : ce système ne peut être jugé fiable que si ses recommandations passées sont mesurables. Ne jamais écraser l'historique — toujours l'enrichir.**

Un audit indépendant (juillet 2026) a constaté que la règle précédente ("vérifier seulement après 30 jours") avait pour effet que **la vérification n'avait jamais tourné une seule fois** en plusieurs sessions actives — 27 positions accumulées, 0 vérifiées, 0 taux de réussite calculable. La règle ci-dessous corrige ce défaut : la vérification tourne **à chaque session**, pas seulement après 30 jours.

1. Lis le fichier `historique-picks.json` à la racine du projet (créer `{"picks":[]}` s'il n'existe pas encore).
2. **Contrôle de doublon d'abord** (voir Phase 2) : pour chaque action retenue cette session, vérifie qu'aucune entrée `"statut": "ouvert"` n'existe déjà sur le même ticker avant d'en ajouter une nouvelle. Si une entrée existe et que la thèse a changé, marque l'ancienne `"statut": "remplacé"` avec `"remplace_par"` et `"note_remplacement"` (voir Phase 2) avant d'ajouter la nouvelle.
3. **Ajoute** (n'écrase jamais les entrées existantes, ne fait que les enrichir ou les marquer `remplacé`/`cible_atteinte`/`stop_declenche`) une entrée pour chaque action réellement nouvelle retenue cette session, au format :
   ```json
   {
     "date_pick": "2026-07-05",
     "bloc": "pea",
     "categorie": "topPicks",
     "ticker": "GLE.PA",
     "name": "Société Générale SA",
     "reco": "buy",
     "entry_price": 77.34,
     "target": "90€ (+16.4%)",
     "stop": "70.38€ (-9.0%)",
     "horizon": "Moyen terme",
     "statut": "ouvert",
     "remplace_par": null,
     "note_remplacement": null,
     "derniere_verification": null
   }
   ```
4. **Vérification de performance — à chaque session, pas seulement après 30 jours.**
   - Prends toutes les entrées `"statut": "ouvert"`, triées par `date_pick` croissant (les plus anciennes d'abord — rotation FIFO).
   - Vérifie-en **au maximum 8 par run** (pour ne pas exploser le nombre de recherches), en priorisant strictement les plus anciennes non encore vérifiées récemment. S'il y a plus de 8 positions ouvertes, les entrées non couvertes ce run-ci seront couvertes au prochain run — sur quelques sessions, l'ensemble du portefeuille actif finit par être revu, au lieu de rester gelé pendant 30 jours.
   - Pour chaque entrée sélectionnée, effectue une recherche WebSearch du prix actuel et applique la **RÈGLE ABSOLUE #3** (cross-validation ≥2 sources avant d'acter un franchissement) :
     - `"statut": "cible_atteinte"` si le prix a atteint/dépassé la cible, confirmé par ≥2 sources
     - `"statut": "stop_declenche"` si le prix a touché le stop, confirmé par ≥2 sources
     - `"statut": "ouvert"` sinon (toujours en cours) — ajoute un champ `"derniere_verification": "AAAA-MM-JJ"` pour tracer qu'elle a bien été passée en revue, même sans clôture.
5. Ajoute dans la Phase 4 une section **📈 Bilan des picks précédents** avec :
   - Le nombre de positions vérifiées ce run, le nombre total ouvertes, et le nombre en attente de rotation.
   - Le taux de réussite calculé sur les entrées clôturées (`cible_atteinte` / (`cible_atteinte` + `stop_declenche`)), même si l'échantillon est encore petit — l'objectif est de le faire converger dans le temps, pas d'avoir un chiffre parfait dès le premier mois.
   - Si le taux de réussite reste non calculable (0 entrée clôturée) après plusieurs sessions consécutives, le signaler explicitement comme une limite de fiabilité du système plutôt que de l'omettre.

---

## Instructions générales

- Chaque lancement = scan complet du marché mondial ce jour-là — aucune liste fixe
- Les actions recommandées CHANGENT à chaque lancement selon les opportunités du marché
- Toujours indiquer **Trade Republic** (PEA) et **Scalable Capital** (international)
- Si les marchés sont fermés : base-toi sur les derniers cours clôture + actualités récentes
- Si un prix ne peut pas être trouvé via WebSearch : `sp:0, sv:'N/A'` dans le dashboard et signale-le dans l'analyse
- `reco:'wait'` est une issue légitime et attendue, pas un échec de la recherche — ne force jamais un candidat ambigu vers `buy`/`long`/`dip` uniquement parce que la catégorie "wait" semble moins valorisante à présenter
- La vérification de performance (Phase 6) et le contrôle de doublon (Phase 2) ne sont pas optionnels même les jours où le scan de marché est riche en opportunités — un système qui ne se vérifie jamais lui-même n'a aucune valeur démontrable, quelle que soit la qualité apparente des nouveaux picks
- En fin de session, committe et pousse les changements (`index.html`, `historique-picks.json`) — voir `run-bourse.ps1` pour l'automatisation quotidienne
