# Machine Learning Pipeline with MLflow

Ce projet presente un pipeline MLOps simple autour de MLflow. Il montre comment entrainer des modeles de machine learning avec scikit-learn, suivre les experiences, journaliser les hyperparametres et les metriques, enregistrer les modeles, puis les recharger pour faire de l'inference ou les exposer via une API locale.

## Objectifs du projet

- Mettre en place un serveur local MLflow Tracking.
- Entrainer des modeles scikit-learn sur des jeux de donnees de demonstration.
- Suivre les runs, hyperparametres, metriques et artefacts dans l'interface MLflow.
- Enregistrer les modeles dans le Model Registry.
- Recharger un modele sauvegarde pour effectuer des predictions.
- Servir un modele MLflow localement via une API REST.

## Contenu

- `gettingstarted.ipynb` : introduction a MLflow avec un modele `LogisticRegression` sur le dataset Iris. Le notebook couvre le tracking, le logging du modele, la validation du payload de serving, le chargement via `mlflow.pyfunc` et l'utilisation du Model Registry.
- `housepricepredict.ipynb` : prediction de prix immobiliers avec le dataset California Housing. Le notebook utilise `RandomForestRegressor`, `GridSearchCV`, le suivi des hyperparametres, le logging du `mse` et l'enregistrement du meilleur modele.
- `.gitignore` : exclut les environnements virtuels, les artefacts MLflow locaux et les fichiers temporaires.
- `requirements.txt` : dependances Python necessaires pour executer les notebooks.

## Stack technique

- Python
- MLflow
- scikit-learn
- pandas
- Jupyter Notebook

## Installation

### 1. Cloner le projet

```powershell
git clone https://github.com/dynivthuriaf/Machine-Learning-Pipeline-with-MLFlow.git
cd Machine-Learning-Pipeline-with-MLFlow
```

### 2. Creer et activer un environnement virtuel

Sous Windows PowerShell :

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```

Sous macOS ou Linux :

```bash
python -m venv .venv
source .venv/bin/activate
```

### 3. Installer les dependances

```powershell
python -m pip install --upgrade pip
pip install -r requirements.txt
python -m ipykernel install --user --name mlflow-project --display-name "Python (mlflow-project)"
```

Si une dependance pose probleme avec une version recente de Python, utilise de preference Python 3.10, 3.11 ou 3.12.

## Execution locale

### 1. Demarrer le serveur MLflow

Dans un terminal active avec l'environnement virtuel :

```powershell
mlflow server --host 127.0.0.1 --port 5000
```

L'interface MLflow sera disponible a l'adresse :

```text
http://127.0.0.1:5000
```

### 2. Lancer Jupyter Notebook

Dans un deuxieme terminal, avec le meme environnement virtuel active :

```powershell
jupyter notebook
```

Ouvre ensuite l'un des notebooks :

- `gettingstarted.ipynb`
- `housepricepredict.ipynb`

Dans Jupyter, selectionne le kernel `Python (mlflow-project)` puis execute les cellules.

## Suivi des experiences

Les notebooks utilisent MLflow pour enregistrer :

- les hyperparametres des modeles ;
- les metriques d'evaluation, comme `accuracy` ou `mse` ;
- les signatures d'entree/sortie ;
- les exemples d'entree ;
- les artefacts de modeles ;
- les versions de modeles dans le registry.

Pendant ou apres l'execution des notebooks, ouvre `http://127.0.0.1:5000` pour comparer les runs et inspecter les artefacts generes.

## Deploiement local d'un modele

Apres avoir execute un notebook et enregistre un modele dans MLflow, il est possible de le servir localement avec `mlflow models serve`.

### Exemple avec le modele Iris

Remplace `1` par la version du modele visible dans l'interface MLflow si necessaire.

```powershell
mlflow models serve -m "models:/tracking-quickstart/1" -p 8000 --env-manager local
```

Le modele sera expose sur :

```text
http://127.0.0.1:8000/invocations
```

Exemple de requete PowerShell :

```powershell
$body = @{ inputs = @(@(5.7, 3.8, 1.7, 0.3)) } | ConvertTo-Json -Depth 3
Invoke-RestMethod -Method Post -Uri http://127.0.0.1:8000/invocations -ContentType "application/json" -Body $body
```

### Exemple avec le modele Random Forest

Si le modele de prediction immobiliere est enregistre dans le registry sous le nom `Best Randomforest Model`, lance :

```powershell
mlflow models serve -m "models:/Best Randomforest Model/1" -p 8001 --env-manager local
```

Adapte le numero de version selon celui indique dans l'interface MLflow.

## Structure recommandee du workflow

1. Demarrer le serveur MLflow.
2. Lancer Jupyter Notebook.
3. Executer le notebook d'entrainement.
4. Comparer les runs dans l'UI MLflow.
5. Selectionner le meilleur modele.
6. Verifier ou recuperer sa version dans le Model Registry.
7. Servir le modele avec `mlflow models serve`.
8. Tester l'endpoint `/invocations` avec une requete REST.

## Notes

- Les dossiers `mlruns/` et `mlartifacts/` sont generes localement par MLflow et ne sont pas versionnes dans Git.
- Le dossier `.venv/` est ignore afin d'eviter de pousser l'environnement virtuel sur GitHub.
- Pour que le tracking fonctionne correctement, le serveur MLflow doit etre lance avant l'execution des cellules qui appellent `mlflow.start_run()`.
