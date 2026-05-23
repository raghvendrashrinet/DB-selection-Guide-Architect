#!/bin/bash
# ============================================================
# DevSecOps GitOps Repository Bootstrap Script
# Creates directory tree and placeholder files for AZ-305 style infra
# ============================================================

set -e

# Root directories
mkdir -p .github/workflows
mkdir -p argocd/{bootstrap,system,projects,apps}
mkdir -p databases/{01-relational/{postgresql,mysql-galera},02-nosql/{mongodb,cassandra-scylla},03-in-memory-cache/{redis-cluster,memcached},04-vector-ai/{milvus,qdrant},05-graph/neo4j}
mkdir -p docs

# Workflow placeholders
cat > .github/workflows/devsecops-ci.yml <<'EOF'
# DevSecOps CI Pipelines (Trivy, Terrascan, Helm lint)
name: DevSecOps CI
on: [push, pull_request]
jobs:
  security-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Trivy
        run: echo "Trivy scan placeholder"
      - name: Run Terrascan
        run: echo "Terrascan scan placeholder"
      - name: Helm Lint
        run: echo "Helm lint placeholder"
EOF

# ArgoCD bootstrap scripts
cat > argocd/bootstrap/install-basic.sh <<'EOF'
#!/bin/bash
# Single-node / testing ArgoCD bootstrap
echo "Installing ArgoCD basic setup..."
EOF

cat > argocd/bootstrap/install-ha.sh <<'EOF'
#!/bin/bash
# 3-node production HA ArgoCD bootstrap
echo "Installing ArgoCD HA setup..."
EOF

# ArgoCD system configs
touch argocd/system/{argocd-cm.yaml,argocd-rbac-cm.yaml,argocd-secret.yaml}

# ArgoCD projects
touch argocd/projects/{core-infra.yaml,db-apps.yaml}

# ArgoCD apps
touch argocd/apps/{01-relational-apps.yaml,02-nosql-apps.yaml,03-cache-apps.yaml,04-vector-graph-apps.yaml}

# Root app
cat > root-app.yaml <<'EOF'
# The "App-of-Apps" ultimate bootstrap entrypoint
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
EOF

# Docs
cat > docs/selection-matrix.md <<'EOF'
# Database Selection Matrix
| Engine | Type | CAP Focus | Use Case |
|--------|------|------------|-----------|
| PostgreSQL | Relational | Consistency | ACID workloads |
| MongoDB | NoSQL | Availability | Document storage |
| Redis | In-memory | Speed | Caching |
| Milvus | Vector | Scalability | AI embeddings |
| Neo4j | Graph | Consistency | Relationship queries |
EOF

echo "✅ DevSecOps GitOps directory structure created successfully!"