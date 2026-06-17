#!/bin/bash
cd "c:\Users\userinsta\Desktop\MLOps projects\mlflow\1-MLproject"
git init
git config user.name "Your Name"
git config user.email "your.email@example.com"
git add .
git commit -m "Initial commit: MLOps project with MLflow"
git branch -M main
git remote add origin https://github.com/dynivthuriaf/Machine-Learning-Pipeline-with-MLFlow.git
git push -u origin main
