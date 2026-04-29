
import express from 'express';
import cors from 'cors';
import pg from 'pg';
import { v4 as uuidv4 } from 'uuid';
import { body, validationResult } from 'express-validator';
import dotenv from 'dotenv';

dotenv.config();

const { Pool } = pg;
const app = express();

// Middleware
app.use(cors({
  origin:'*',
  methods:['GET','POST','PUT','DELETE'],
  allowedHeaders:['Content-Type']
}));
app.use(express.json());

// Pool PostgreSQL
const pool = new Pool({
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || 'SAMIRA237',
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'datapulse_db'
});

// ==================== INITIALISATION BD ====================

async function initDatabase() {
  try {
    const client = await pool.connect();
    
    // Créer les tables
    await client.query(`
      CREATE TABLE IF NOT EXISTS insights (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        title VARCHAR(255) NOT NULL,
        category VARCHAR(50) NOT NULL,
        description TEXT NOT NULL,
        region VARCHAR(100),
        impact_level VARCHAR(20) DEFAULT 'medium',
        adoption_rate DECIMAL(5,2),
        creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      CREATE TABLE IF NOT EXISTS technologies (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        name VARCHAR(255) NOT NULL,
        category VARCHAR(100) NOT NULL,
        maturity_level VARCHAR(30),
        adoption_percentage DECIMAL(5,2),
        insight_id UUID REFERENCES insights(id) ON DELETE CASCADE
      );

      CREATE TABLE IF NOT EXISTS challenges (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        title VARCHAR(255) NOT NULL,
        description TEXT NOT NULL,
        severity VARCHAR(20),
        affected_tech VARCHAR(255),
        insight_id UUID REFERENCES insights(id) ON DELETE CASCADE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      CREATE TABLE IF NOT EXISTS metrics (
        id SERIAL PRIMARY KEY,
        metric_date DATE DEFAULT CURRENT_DATE,
        total_insights INT DEFAULT 0,
        total_technologies INT DEFAULT 0,
        active_regions INT DEFAULT 0,
        avg_adoption_rate DECIMAL(5,2)
      );
    `);
    
    client.release();
    console.log(' Base de données initialisée');
  } catch (err) {
    console.error('Erreur initialisation BD:', err);
  }
}

// ==================== ROUTES ====================

// INSIGHTS
app.post('/api/insights', [
  body('title').notEmpty().isLength({ min: 3 }),
  body('category').notEmpty(),
  body('description').notEmpty().isLength({ min: 10 }),
  body('region').optional(),
  body('impact_level').isIn(['low', 'medium', 'high']),
  body('adoption_rate').optional().isDecimal()
], async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    const { title, category, description, region, impact_level, adoption_rate } = req.body;
    const id = uuidv4();
    
    const result = await pool.query(
      `INSERT INTO insights (id, title, category, description, region, impact_level, adoption_rate)
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       RETURNING *`,
      [id, title, category, description, region || 'Global', impact_level || 'medium', adoption_rate || 0]
    );

    res.status(201).json({ success: true, data: result.rows[0] });
  } catch (err) {
    console.error('Erreur POST insight:', err);
    res.status(500).json({ error: 'Erreur serveur', details: err.message });
  }
});

app.get('/api/insights', async (req, res) => {
  try {
    const { category, region, sortBy = 'creation_date' } = req.query;
    
    let query = 'SELECT * FROM insights WHERE 1=1';
    const params = [];

    if (category) {
      query += ' AND category = $' + (params.length + 1);
      params.push(category);
    }
    if (region) {
      query += ' AND region = $' + (params.length + 1);
      params.push(region);
    }

    query += ` ORDER BY ${sortBy} DESC LIMIT 100`;
    
    const result = await pool.query(query, params);
    res.json({ success: true, data: result.rows });
  } catch (err) {
    console.error('Erreur GET insights:', err);
    res.status(500).json({ error: err.message });
  }
});

app.get('/api/insights/:id', async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM insights WHERE id = $1',
      [req.params.id]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Insight non trouvé' });
    }

    const insight = result.rows[0];

    // Récupérer technos et défis associés
    const techResult = await pool.query(
      'SELECT * FROM technologies WHERE insight_id = $1',
      [req.params.id]
    );
    const challengeResult = await pool.query(
      'SELECT * FROM challenges WHERE insight_id = $1',
      [req.params.id]
    );

    res.json({
      success: true,
      data: {
        ...insight,
        technologies: techResult.rows,
        challenges: challengeResult.rows
      }
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ANALYTICS / STATISTIQUES DESCRIPTIVES
app.get('/api/analytics/summary', async (req, res) => {
  try {
    const counts = await pool.query(`
      SELECT 
        (SELECT COUNT(*) FROM insights) as total_insights,
        (SELECT COUNT(*) FROM technologies) as total_technologies,
        (SELECT COUNT(DISTINCT region) FROM insights) as unique_regions,
        (SELECT AVG(adoption_rate) FROM insights) as avg_adoption_rate
    `);

    const categories = await pool.query(`
      SELECT category, COUNT(*) as count
      FROM insights
      GROUP BY category
      ORDER BY count DESC
    `);

    const regions = await pool.query(`
      SELECT region, COUNT(*) as count
      FROM insights
      GROUP BY region
      ORDER BY count DESC
    `);

    const impactDistribution = await pool.query(`
      SELECT impact_level, COUNT(*) as count
      FROM insights
      GROUP BY impact_level
    `);

    const adoptionStats = await pool.query(`
      SELECT 
        MIN(adoption_rate) as min_adoption,
        MAX(adoption_rate) as max_adoption,
        AVG(adoption_rate) as avg_adoption,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY adoption_rate) as median_adoption
      FROM insights
      WHERE adoption_rate IS NOT NULL
    `);

    res.json({
      success: true,
      summary: counts.rows[0],
      categories: categories.rows,
      regions: regions.rows,
      impactDistribution: impactDistribution.rows,
      adoptionStats: adoptionStats.rows[0]
    });
  } catch (err) {
    console.error('Erreur analytics:', err);
    res.status(500).json({ error: err.message });
  }
});

app.get('/api/analytics/timeline', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT 
        DATE(creation_date) as date,
        COUNT(*) as count
      FROM insights
      GROUP BY DATE(creation_date)
      ORDER BY date DESC
      LIMIT 30
    `);

    res.json({ success: true, data: result.rows });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// TECHNOLOGIES
app.post('/api/technologies', [
  body('name').notEmpty(),
  body('category').notEmpty(),
  body('insight_id').notEmpty()
], async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    const { name, category, maturity_level, adoption_percentage, insight_id } = req.body;
    const id = uuidv4();

    const result = await pool.query(
      `INSERT INTO technologies (id, name, category, maturity_level, adoption_percentage, insight_id)
       VALUES ($1, $2, $3, $4, $5, $6)
       RETURNING *`,
      [id, name, category, maturity_level || 'emerging', adoption_percentage || 0, insight_id]
    );

    res.status(201).json({ success: true, data: result.rows[0] });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// HEALTH CHECK
app.get('/api/health', async (req, res) => {
  try {
    await pool.query('SELECT NOW()');
    res.json({ status: 'healthy', timestamp: new Date() });
  } catch (err) {
    res.status(503).json({ status: 'unhealthy', error: err.message });
  }
});

// ERROR HANDLER
app.use((err, req, res, next) => {
  console.error('Erreur non gérée:', err);
  res.status(500).json({ error: 'Erreur serveur interne', details: err.message });
});

// START SERVER
const PORT = process.env.PORT || 5000;

async function start() {
  await initDatabase();
  
  app.listen(PORT, () => {
    console.log(` DataPulse Backend running on port ${PORT}`);
    console.log(` API: http://localhost:${PORT}/api`);
  });
}

start().catch(err => {
  console.error('Erreur de démarrage:', err);
  process.exit(1);
});

export default app;
