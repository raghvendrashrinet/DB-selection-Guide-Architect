
 ### 3. Real Project Demo (Architect Scenario)
Project: E-commerce Product Catalog
Imagine you are designing an Amazon-like product system.
Each product has different attributes:
```
Example:

Laptop

brand
ram
processor
battery
screen_size

Shoes

brand
size
material
color
```
If you use relational DB:
```
Products Table
--------------
id
name
brand
ram
processor
battery
screen_size
size
material
color
```
Most columns will be NULL.

Bad design.

### 4. Why MongoDB is Perfect Here

Using MongoDB, each product is a document.
```
Example:

Laptop Document
{
 "name": "MacBook Pro",
 "brand": "Apple",
 "ram": "16GB",
 "processor": "M3",
 "battery": "18h"
}
Shoes Document
{
 "name": "Nike Air",
 "brand": "Nike",
 "size": 9,
 "color": "black",
 "material": "mesh"
}
```
Different structure — no problem.

### 5. Practical Project (You Can Run This)

We will build:
```
Product API
      |
      v
FastAPI (Python)
      |
      v
MongoDB
```
### 6. Install MongoDB (Local)

Install from:

MongoDB Official Download

Or run using Docker:
```
docker run -d -p 27017:27017 mongo
```
### 7. Create Project

Install dependencies:
```
sudo pip install fastapi uvicorn pymongo
```
### 8. Python API Code
```
from fastapi import FastAPI
from pymongo import MongoClient

app = FastAPI()

client = MongoClient("mongodb://localhost:27017/")
db = client["ecommerce"]
products = db["products"]

@app.post("/product")
def add_product(product: dict):
    products.insert_one(product)
    return {"message": "Product added"}

@app.get("/products")
def get_products():
    data = list(products.find({}, {"_id":0}))
    return data
```
### 9. Run Server
```
uvicorn main:app --reload
```
Open:
```
http://127.0.0.1:8000/docs
```
Now you can insert products with different structures.

#### 1. To Push Data (Add a Product)
URL: http://<YOUR_VM_PUBLIC_IP>:8000/products

HTTP Method: POST

Data Format (JSON): You can pass any flexible JSON structure because MongoDB doesn't enforce a rigid schema.

Example curl command to push data:

```
curl -X 'POST' \
  'http://<YOUR_VM_PUBLIC_IP>:8000/product' \
  -H 'Content-Type: application/json' \
  -d '{"name": "MacBook Pro", "brand": "Apple"
```
#### 2. To Retrieve Data (Get All Products)
```
URL: http://<YOUR_VM_PUBLIC_IP>:8000/products

HTTP Method: GET
```
You can type this URL directly into your regular web browser's address bar, and it will output a clean text list of all the products currently stored inside your MongoDB collection.
### 💡 The Best Option: Use the Interactive UI Portal   
Instead of manually typing out URLs, FastAPI automatically builds a web testing dashboard for you. Open your browser and navigate to:
```
http://<YOUR_VM_PUBLIC_IP>:8000/docs
```
-----------

# ☸️ Enterprise Deployment: Kubernetes & ArgoCD
For production-grade testing or cluster deployments, this repository utilizes an automated GitOps Engine Layer with ArgoCD.

### 1. Infrastructure Architecture
The MongoDB instance is tracked under the stateful application structure defined in this repository:
```
architect-db-selection-guide/
├── argocd/
│   └── apps/
│       └── 02-nosql-apps.yaml       # ArgoCD Child Application for NoSQL
└── databases/
    └── 02-nosql/
        └── mongodb/                 # Deployment manifests & Helm charts
```

### 2. Deploying via ArgoCD
If you are managing the cluster via the App-of-Apps pattern, ensure your root-app.yaml is bootstrapped. To manually sync or verify the MongoDB application state:

Open your ArgoCD Dashboard.

Ensure the db-apps project has synced the 02-nosql-apps.yaml manifest.

ArgoCD will automatically provision the MongoDB StatefulSet, persistent volumes (PVC), and internal cluster routing services (ClusterIP).

Alternatively, apply the wrapper application directly via the CLI:
```
kubectl apply -f argocd/apps/02-nosql-apps.yaml
```

## 📐 Architect's Validation Tests
Verify that MongoDB's schema-less nature is working as intended by pushing two entirely distinct data structures into the same endpoint:

#### Test 1: Insert a Laptop Asset
```
curl -X 'POST' \
  'http://127.0.0.1:8000/product' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "MacBook Pro",
  "brand": "Apple",
  "ram": "16GB",
  "processor": "M3",
  "battery": "18h"
}'
```
#### Test 2: Insert Apparel Asset
```
curl -X 'POST' \
  'http://127.0.0.1:8000/product' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "Air Max",
  "brand": "Nike",
  "size": 10,
  "color": "Black",
  "material": "Mesh"
}'
```
💡 Architect Note: Notice how both distinct entity types reside in the same collection without altering table schemas or creating wasteful NULL fields. This is why a Document Store is preferred over a Relational database for dynamic product catalogs.