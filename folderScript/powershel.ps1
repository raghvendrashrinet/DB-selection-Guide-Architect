# ============================================================
# DevSecOps GitOps Repository Bootstrap Script (Windows PowerShell)
# Creates directory tree and placeholder files for AZ-305 style infra
# ============================================================

# Root directories
New-Item -ItemType Directory -Force -Path ".github\workflows"
New-Item -ItemType Directory -Force -Path "argocd\bootstrap","argocd\system","argocd\projects","argocd\apps"
New-Item -ItemType Directory -Force -Path "databases\01-relational\postgresql","databases\01-relational\mysql-galera",
"databases\02-nosql\mongodb","databases\02-nosql\cassandra-scylla",
"databases\03-in-memory-cache\redis-cluster","databases\03-in-memory-cache\memcached",
"databases\04-vector-ai\milvus","databases\04-vector-ai\qdrant",
"databases\05-graph\neo4j","docs"

# Workflow placeholders
@"
# DevSecOps CI Pipelines (Trivy, Terrascan, Helm lint)
name: DevSecOps CI
on: [push, pull_request]
jobs:
  security-scan:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Trivy
        run: echo 'Trivy scan placeholder'
      - name: Run Terrascan
        run: echo 'Terrascan scan placeholder'
      - name: Helm Lint
        run: echo 'Helm lint placeholder'
"@ | Out-File ".github\workflows\devsecops-ci.yml" -Encoding UTF8

# ArgoCD bootstrap scripts
@"
# Single-node / testing ArgoCD bootstrap
Write-Host 'Installing ArgoCD basic setup...'
"@ | Out-File "argocd\bootstrap\install-basic.ps1" -Encoding UTF8

@"
# 3-node production HA ArgoCD bootstrap
Write-Host 'Installing ArgoCD HA setup...'
"@ | Out-File "argocd\bootstrap\install-ha.ps1" -Encoding UTF8

# ArgoCD system configs
New-Item -ItemType File -Force -Path "argocd\system\argocd-cm.yaml","argocd\system\argocd-rbac-cm.yaml","argocd\system\argocd-secret.yaml"

# ArgoCD projects
New-Item -ItemType File -Force -Path "argocd\projects\core-infra.yaml","argocd\projects\db-apps.yaml"

# ArgoCD apps
New-Item -ItemType File -Force -Path "argocd\apps\01-relational-apps.yaml","argocd\apps\02-nosql-apps.yaml","argocd\apps\03-cache-apps.yaml","argocd\apps\04-vector-graph-apps.yaml"

# Root app
@"
# The 'App-of-Apps' ultimate bootstrap entrypoint
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: root-app
spec:
  source:
    repoURL: https://github.com/your-org/your-repo
    path: argocd/apps
  destination:
    namespace: argocd
    server: https://kubernetes.default.svc
  project: default
"@ | Out-File "root-app.yaml" -Encoding UTF8

# Docs
@"
# Database Selection Matrix
| Engine | Type | CAP Focus | Use Case |
|--------|------|------------|-----------|
| PostgreSQL | Relational | Consistency | ACID workloads |
| MongoDB | NoSQL | Availability | Document storage |
| Redis | In-memory | Speed | Caching |
| Milvus | Vector | Scalability | AI embeddings |
| Neo4j | Graph | Consistency | Relationship queries |
"@ | Out-File "docs\selection-matrix.md" -Encoding UTF8

Write-Host "✅ DevSecOps GitOps directory structure created successfully!"