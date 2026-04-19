#!/bin/bash

# ===========================================
# DataPulse - Setup Script
# Initialiser rapidement le projet en local
# ===========================================

set -e  # Exit on error

echo "🚀 DataPulse Setup Script"
echo "========================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check prerequisites
echo "📋 Vérification des prérequis..."
echo ""

# Node.js check
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js n'est pas installé${NC}"
    echo "   Télécharger de: https://nodejs.org/"
    exit 1
else
    echo -e "${GREEN}✅ Node.js $(node -v)${NC}"
fi

# npm check
if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm n'est pas installé${NC}"
    exit 1
else
    echo -e "${GREEN}✅ npm $(npm -v)${NC}"
fi

# Flutter check
if ! command -v flutter &> /dev/null; then
    echo -e "${YELLOW}⚠️  Flutter n'est pas installé (optionnel pour web)${NC}"
    echo "   Télécharger de: https://flutter.dev/docs/get-started/install"
else
    echo -e "${GREEN}✅ Flutter $(flutter --version | head -1)${NC}"
fi

echo ""
echo "📦 Installation des dépendances..."
echo ""

# Backend setup
if [ -d "backend" ]; then
    echo "🔧 Backend setup..."
    cd backend

    # Check if .env exists
    if [ ! -f ".env" ]; then
        echo "   Création du fichier .env"
        cp .env.example .env 2>/dev/null || echo "   (Utiliser .env par défaut)"
    fi

    npm install
    echo -e "${GREEN}✅ Backend dépendances installées${NC}"
    cd ..
else
    echo -e "${YELLOW}⚠️  Dossier backend non trouvé${NC}"
fi

echo ""

# Frontend setup
if [ -d "frontend" ]; then
    echo "📱 Frontend setup..."
    cd frontend
    flutter pub get
    echo -e "${GREEN}✅ Frontend dépendances installées${NC}"
    cd ..
else
    echo -e "${YELLOW}⚠️  Dossier frontend non trouvé${NC}"
fi

echo ""
echo "✨ Setup complété!"
echo ""
echo "========================================"
echo "📚 Prochaines étapes:"
echo "========================================"
echo ""
echo "1️⃣  Backend (développement):"
echo "   cd backend && npm run dev"
echo "   API: http://localhost:5000/api"
echo ""
echo "2️⃣  Frontend (web):"
echo "   cd frontend && flutter run -d chrome"
echo ""
echo "3️⃣  Documentation:"
echo "   Voir docs/DEPLOYMENT_GUIDE.md"
echo ""
echo "4️⃣  PostgreSQL:"
echo "   Installer PostgreSQL localement ou utiliser Docker:"
echo "   docker run --name postgres -e POSTGRES_PASSWORD=pass -p 5432:5432 -d postgres"
echo ""
echo "========================================"
echo -e "${GREEN}🎉 Prêt à développer!${NC}"
echo "========================================”













