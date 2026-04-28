#  DataPulse - Technology Insights Analytics Platform

#### **Projet** : DataPulse - Plateforme de collecte et d'analyse d'insights technologiques 
#### **Matière** : INF232 EC2 - Développement Backend 
#### **Université** : Université de Yaoundé I 
#### **Niveau** : Licence 2
#### **Auteur** : Samira  Aoudou
#### **Matricule** : 24G2715
#### **Date** : 19 Avril 2026  
#### **Statut** :  Complété et Déployé
#### **Lien depot GitHub** : https://github.com/samiraaoudou91-droid/DataPulse 


![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Status](https://img.shields.io/badge/status-production--ready-brightgreen.svg)

##  À Propos

**DataPulse** est une plateforme innovante de collecte, stockage et analyse descriptive de données sur les tendances technologiques. C'est une application complète et professionnelle développée pour le **TP INF232 EC2** à l'Université de Yaoundé I.

###  Problème Résolu

En Afrique et dans les régions en développement, il existe un **manque de données centralisées** sur les innovations technologiques, les défis d'adoption, et les opportunités. DataPulse offre une solution collaborative pour :
-  **Collecter** des insights technologiques en temps réel
-  **Analyser** les tendances par région, catégorie et impact
-  **Visualiser** les statistiques descriptives via dashboards

---

##  Caractéristiques Principales

### 1️⃣ **Collecte de Données Robuste**
-  Formulaire de création d'insights avec validation
-  Champs : Titre, Catégorie, Description, Région, Niveau d'Impact, Taux d'Adoption
-  Support de 12 catégories technologiques (AI, Cybersecurity, IoT, Cloud, etc.)
-  7 régions mondiales disponibles

### 2️⃣ **Dashboard d'Analytics Descriptive**
-  **Statistiques Résumées** :
  - Total des insights, technologies, régions
  - Taux d'adoption moyen
-  **Graphiques Avancés** :
  - Distribution par catégorie (Bar Chart)
  - Distribution par impact (Progress Bars)
  - Statistiques d'adoption (Min, Max, Moy, Médiane)
- 🗺️ **Distribution Géographique** : Insights par région

### 3️⃣ **Système de Filtrage Intelligent**
- Filtrer par catégorie technologique
- Filtrer par région géographique
- Combinaisons multiples de filtres
- Reset instantané

### 4️⃣ **Design Futuriste Professionnel**
-  Thème cyberpunk avec palette cyan/purple/pink
-  UI moderne et responsive avec Flutter
-  Dark mode optimisé pour l'UX
-  Animations fluides et transitions

---

##  Architecture Technique

```
DataPulse/
├── backend/                   #  API Node.js/Express
│   ├── server.js              # Serveur principal
│   ├── package.json           # Dépendances
│   ├── .env                   # Configuration
│   └── Dockerfile             # Conteneurisation
├── frontend/                  #  Application Flutter
│   ├── lib/
│   │   ├── main.dart          # Point d'entrée
│   │   ├── models/            # Modèles de données
│   │   ├── services/          # Services API
│   │   └── screens/           # Écrans de l'app
│   ├── pubspec.yaml           # Dépendances Flutter
│   └── build/
│       └── web/               # Build web
└── docs/                      #  Documentation
    ├── CAHIER_CHARGES.md      # Guide complet de déploiement
    └── API_DOCS.md            # Documentation API
```

### **Stack Technique**

| Composant | Technologie | Version |
|-----------|-----------|---------|
| Backend | Node.js + Express | v18 |
| Base de Données | PostgreSQL | 15+ |
| Frontend | Flutter | 3.0+ |
| UI Framework | Material Design 3 | - |
| État | Provider | 6.0+ |
| Graphiques | FL Chart | 0.65+ |
| Déploiement | Render.com | - |

---

## 🚀 Démarrage Rapide

### **Développement Local**

#### Backend
```bash
cd backend
npm install
npm run dev
# API disponible à http://localhost:5000/api
```

#### Frontend
```bash
cd frontend
flutter pub get
flutter run -d chrome          # Web
flutter run -d android        # Mobile
```

### **Déploiement en Production**

j'ai opté pour le serveur render pour les raisons suivantes:

- **Gratuit** : Render offre 5000 heures gratuites/mois (suffisant)
- **Inactivité** : Les apps se mettent en veille après 15 min. Ajouter un cron job pour les réveiller
- **Limites** : 0.5GB RAM pour les services gratuits (suffisant pour cette app)

**En résumé** :
1. Configurer PostgreSQL sur Render
2. Déployer le backend sur Render
3. Générer l'APK Flutter


---

##  Endpoints API

### **Insights**
```
POST   /api/insights              # Créer un insight
GET    /api/insights              # Lister tous les insights
GET    /api/insights/:id          # Obtenir les détails
```

### **Analytics**
```
GET    /api/analytics/summary     # Statistiques globales
GET    /api/analytics/timeline    # Chronologie des données
```

### **Technologie**
```
POST   /api/technologies          # Ajouter une technologie
```

### **Santé**
```
GET    /api/health                # Vérifier l'état du serveur
```

---

##  Fonctionnalités de l'Application Flutter

### **Écran Home - Insights**
-  Liste paginée des insights
-  Filtrage par catégorie et région
-  Affichage du temps écoulé (timeago)
-  Badges de niveau d'impact
-  Pull-to-refresh

### **Écran Créer - Formulaire**
-  Saisie structurée d'insights
-  Validation en temps réel
-  Champs optimisés (dropdowns, sliders, etc.)
-  Gestion des erreurs gracieuse
-  Feedback visuel de succès

### **Écran Analytics - Dashboards**
-  4 cartes de statistiques (KPIs)
-  Graphiques interactifs
-  Statistiques descriptives détaillées
-  Distribution régionale
-  Actualisation automatique

---

##  Design & UX

### **Palette Couleurs**
```
Primaire  : Cyan (#00F0FF)
Secondaire: Magenta (#FF006E)
Tertiaire : Purple (#8338EC)
Background: Dark (#0F1419)
```

### **Typographie**
- **Display** : Orbitron (futuriste)
- **Body** : Space Mono (technique)

### **Principes de Design**
-  Cyberpunk/Futuriste
-  Dark Mode first
-  Minimaliste avec impact
-  Cohérence visuelle complète

---

##  Sécurité

-  **CORS** : Configuré pour origin spécifique
-  **Validation** : Toutes les entrées validées (express-validator)
-  **Env Vars** : Données sensibles en .env
-  **HTTPS** : Enforced en production
-  **TODO** : Authentification JWT, Rate Limiting

---

##  Cas d'Utilisation

1. **Chercheurs Technologiques** : Collecter des données sur les tendances
2. **Entrepreneurs** : Identifier les opportunités de marché
3. **Décideurs Politiques** : Comprendre l'adoption technologique
4. **Étudiants** : Apprendre sur l'écosystème tech africain
5. **Organismes Internationaux** : Suivre le développement technologique

---

##  Données Exemple

```json
{
  "id": "uuid-here",
  "title": "IA dans la Santé en Afrique",
  "category": "AI",
  "description": "Adoption rapide des solutions IA...",
  "region": "Africa",
  "impact_level": "high",
  "adoption_rate": 75.5,
  "creation_date": "2026-04-17T10:30:00Z"
}
```

---

##  Tests & QA

### **Checklist de Qualité**
-  Créativité : Design futuriste + cas d'usage réel
-  Robustesse : Gestion d'erreurs complète, validation
-  Efficacité : Requêtes optimisées, UI responsive
-  UX : Workflow intuitif et fluide
-  Performance : Shimmer loading, caching

---

##  Contribution

Pour les améliorations futures :
1. Ajouter l'authentification JWT
2. Implémenter un système de commentaires
3. Exporter les données (CSV, PDF)
4. Notifications push
5. Graphiques avancés (3D, ML predictions)

---

##  License

MIT License - Libre d'utilisation

---

##  Contact & Support

- **Auteur** : Samira Aoudou - 24G2715 (Université de Yaoundé I, INF222)
- **Professeur** : rollinfrancis28@gmail.com
- **GitHub** : https://github.com/samiraaoudou91-droid/DataPulse

---

##  Matière & Objectifs

**Cours** : INF232 EC2 - Développement Backend  
**Objectif** : Créer une application de collecte et analyse descriptive de données  
**Réalisé avec** : Node.js, PostgreSQL, Express, Flutter

---

**Date de Réalisation** :19 Avril 2026  
**Status** :  Complète et Déployée

