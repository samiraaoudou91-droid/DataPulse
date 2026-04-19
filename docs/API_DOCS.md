#  API Documentation - DataPulse

**Base URL** : `https://datapulse-backend.onrender.com/api`

---

##  Health Check

### GET `/health`
Vérifier l'état du serveur

**Request**
```bash
curl https://datapulse-backend.onrender.com/api/health
```

**Response** (200 OK)
```json
{
  "status": "healthy",
  "timestamp": "2026-04-17T10:30:00.000Z"
}
```

---

##  Insights Endpoints

### POST `/insights`
Créer un nouvel insight

**Request**
```bash
curl -X POST https://datapulse-backend.onrender.com/api/insights \
  -H "Content-Type: application/json" \
  -d '{
    "title": "IA dans la Santé",
    "category": "AI",
    "description": "Adoption rapide des solutions IA pour diagnostic médical et prédiction de maladies...",
    "region": "Africa",
    "impact_level": "high",
    "adoption_rate": 75.5
  }'
```

**Response** (201 Created)
```json
{
  "success": true,
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "title": "IA dans la Santé",
    "category": "AI",
    "description": "Adoption rapide des solutions IA...",
    "region": "Africa",
    "impact_level": "high",
    "adoption_rate": 75.5,
    "creation_date": "2026-04-17T10:30:00.000Z",
    "updated_date": "2026-04-17T10:30:00.000Z"
  }
}
```

**Validation**
- `title` : min 3 caractères, max 255
- `category` : obligatoire
- `description` : min 10 caractères, max 2000
- `impact_level` : "low" | "medium" | "high"
- `adoption_rate` : 0-100 (optionnel, défaut 0)

**Erreurs**
```json
{
  "errors": [
    {
      "value": "ab",
      "msg": "Le titre doit contenir au minimum 3 caractères",
      "param": "title",
      "location": "body"
    }
  ]
}
```

---

### GET `/insights`
Récupérer la liste des insights (avec filtres)

**Request avec Filtres**
```bash
# Tous les insights
curl https://datapulse-backend.onrender.com/api/insights

# Par catégorie
curl https://datapulse-backend.onrender.com/api/insights?category=AI

# Par région
curl https://datapulse-backend.onrender.com/api/insights?region=Africa

# Combiné
curl 'https://datapulse-backend.onrender.com/api/insights?category=AI&region=Africa'

# Avec tri
curl 'https://datapulse-backend.onrender.com/api/insights?sortBy=adoption_rate'
```

**Response** (200 OK)
```json
{
  "success": true,
  "data": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "title": "IA dans la Santé",
      "category": "AI",
      "description": "Adoption rapide...",
      "region": "Africa",
      "impact_level": "high",
      "adoption_rate": 75.5,
      "creation_date": "2026-04-17T10:30:00.000Z",
      "updated_date": "2026-04-17T10:30:00.000Z"
    },
    {
      "id": "660f8400-e29b-41d4-a716-446655440001",
      "title": "Cybersécurité en Finance",
      "category": "Cybersecurity",
      "description": "Menaces augmentent...",
      "region": "Europe",
      "impact_level": "high",
      "adoption_rate": 92.0,
      "creation_date": "2026-04-16T14:22:00.000Z",
      "updated_date": "2026-04-16T14:22:00.000Z"
    }
  ]
}
```

**Query Parameters**
| Param | Type | Exemple | Description |
|-------|------|---------|-------------|
| category | string | "AI" | Filtrer par catégorie |
| region | string | "Africa" | Filtrer par région |
| sortBy | string | "adoption_rate" | Champ à trier (DESC) |

**Catégories Disponibles**
```
AI, Cybersecurity, IoT, Cloud, Blockchain, Mobile, Web, 
DevOps, Data Science, AR/VR, Quantum, Other
```

**Régions Disponibles**
```
Global, Africa, Europe, Asia, Americas, Middle East, Oceania
```

---

### GET `/insights/:id`
Récupérer les détails complets d'un insight

**Request**
```bash
curl https://datapulse-backend.onrender.com/api/insights/550e8400-e29b-41d4-a716-446655440000
```

**Response** (200 OK)
```json
{
  "success": true,
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "title": "IA dans la Santé",
    "category": "AI",
    "description": "Adoption rapide...",
    "region": "Africa",
    "impact_level": "high",
    "adoption_rate": 75.5,
    "creation_date": "2026-04-17T10:30:00.000Z",
    "updated_date": "2026-04-17T10:30:00.000Z",
    "technologies": [
      {
        "id": "tech-1",
        "name": "TensorFlow",
        "category": "ML Framework",
        "maturity_level": "stable",
        "adoption_percentage": 85.0,
        "insight_id": "550e8400-e29b-41d4-a716-446655440000"
      }
    ],
    "challenges": [
      {
        "id": "challenge-1",
        "title": "Manque de data scientist",
        "description": "Pénurie de talents...",
        "severity": "high",
        "affected_tech": "IA/ML",
        "insight_id": "550e8400-e29b-41d4-a716-446655440000",
        "created_at": "2026-04-17T10:30:00.000Z"
      }
    ]
  }
}
```

**Erreurs**
```json
{
  "error": "Insight non trouvé"
}
```

---

##  Analytics Endpoints

### GET `/analytics/summary`
Récupérer les statistiques descriptives complètes

**Request**
```bash
curl https://datapulse-backend.onrender.com/api/analytics/summary
```

**Response** (200 OK)
```json
{
  "success": true,
  "summary": {
    "total_insights": 42,
    "total_technologies": 128,
    "unique_regions": 6,
    "avg_adoption_rate": 67.5
  },
  "categories": [
    {
      "category": "AI",
      "count": 12
    },
    {
      "category": "Cybersecurity",
      "count": 8
    },
    {
      "category": "Cloud",
      "count": 7
    }
  ],
  "regions": [
    {
      "region": "Africa",
      "count": 18
    },
    {
      "region": "Europe",
      "count": 12
    },
    {
      "region": "Asia",
      "count": 10
    }
  ],
  "impactDistribution": [
    {
      "impact_level": "high",
      "count": 15
    },
    {
      "impact_level": "medium",
      "count": 18
    },
    {
      "impact_level": "low",
      "count": 9
    }
  ],
  "adoptionStats": {
    "min_adoption": 15.5,
    "max_adoption": 98.0,
    "avg_adoption": 67.5,
    "median_adoption": 72.0
  }
}
```

---

### GET `/analytics/timeline`
Récupérer l'historique des insights par jour (30 derniers jours)

**Request**
```bash
curl https://datapulse-backend.onrender.com/api/analytics/timeline
```

**Response** (200 OK)
```json
{
  "success": true,
  "data": [
    {
      "date": "2026-04-17",
      "count": 5
    },
    {
      "date": "2026-04-16",
      "count": 3
    },
    {
      "date": "2026-04-15",
      "count": 7
    }
  ]
}
```

---

##  Technologies Endpoints

### POST `/technologies`
Ajouter une technologie à un insight

**Request**
```bash
curl -X POST https://datapulse-backend.onrender.com/api/technologies \
  -H "Content-Type: application/json" \
  -d '{
    "name": "TensorFlow",
    "category": "ML Framework",
    "maturity_level": "stable",
    "adoption_percentage": 85.0,
    "insight_id": "550e8400-e29b-41d4-a716-446655440000"
  }'
```

**Response** (201 Created)
```json
{
  "success": true,
  "data": {
    "id": "tech-uuid",
    "name": "TensorFlow",
    "category": "ML Framework",
    "maturity_level": "stable",
    "adoption_percentage": 85.0,
    "insight_id": "550e8400-e29b-41d4-a716-446655440000"
  }
}
```

**Validation**
- `name` : obligatoire, min 2 chars
- `category` : obligatoire
- `insight_id` : obligatoire, doit exister
- `adoption_percentage` : 0-100

---

##  Error Handling

### Erreurs Courantes

**400 Bad Request** - Validation failed
```json
{
  "errors": [
    {
      "param": "title",
      "msg": "Le titre est requis"
    }
  ]
}
```

**404 Not Found** - Ressource inexistante
```json
{
  "error": "Insight non trouvé"
}
```

**500 Internal Server Error** - Erreur serveur
```json
{
  "error": "Erreur serveur",
  "details": "Connection refused"
}
```

---

##  Sécurité

- ✅ **CORS** : Configuré pour origin spécifique
- ✅ **Validation** : Toutes les entrées validées
- ✅ **Authentification** : À ajouter en v1.1
- ✅ **Rate Limiting** : À ajouter en v1.1

---

##  Exemples Complets

### Flux Complet : Créer et Analyser

```bash
# 1. Créer un insight
INSIGHT_ID=$(curl -s -X POST https://datapulse-backend.onrender.com/api/insights \
  -H "Content-Type: application/json" \
  -d '{
    "title":"IA en Agriculture",
    "category":"AI",
    "description":"Robots et drones pour agriculture de précision",
    "region":"Africa",
    "impact_level":"high",
    "adoption_rate":45.0
  }' | jq -r '.data.id')

# 2. Ajouter une technologie
curl -X POST https://datapulse-backend.onrender.com/api/technologies \
  -H "Content-Type: application/json" \
  -d "{
    "name":"Precision Agriculture Drones",
    "category":"IoT",
    "adoption_percentage":50.0,
    "insight_id":"$INSIGHT_ID"
  }"

# 3. Récupérer les détails
curl https://datapulse-backend.onrender.com/api/insights/$INSIGHT_ID

# 4. Voir les analytics
curl https://datapulse-backend.onrender.com/api/analytics/summary
```

---

##  Postman Collection

```json
{
  "info": {
    "name": "DataPulse API",
    "version": "1.0.0"
  },
  "item": [
    {
      "name": "Health Check",
      "request": {
        "method": "GET",
        "url": "{{baseUrl}}/health"
      }
    },
    {
      "name": "Create Insight",
      "request": {
        "method": "POST",
        "url": "{{baseUrl}}/insights",
        "body": {
          "mode": "raw",
          "raw": "{\"title\":\"\",\"category\":\"\",\"description\":\"\"}"
        }
      }
    },
    {
      "name": "Get Analytics",
      "request": {
        "method": "GET",
        "url": "{{baseUrl}}/analytics/summary"
      }
    }
  ],
  "variable": [
    {
      "key": "baseUrl",
      "value": "https://datapulse-backend.onrender.com/api"
    }
  ]
}
```

---

**Créé** : 19 Avril 2026  
**Version** : 1.0.0  
**Statut** :  Production
