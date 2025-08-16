#!/bin/bash
# Template Repository Setup Script
# Incorporates williamzujkowski/standards with Claude CLI optimization

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project configuration
PROJECT_NAME="${1:-my-project}"
PROJECT_TYPE="${2:-web}"  # web|api|cli|library|microservice|data-pipeline
LANGUAGE="${3:-typescript}"  # python|typescript|go|java
FRAMEWORK="${4:-}"  # react|fastapi|express|django|etc

echo -e "${BLUE}🚀 Setting up template repository: ${PROJECT_NAME}${NC}"

# Create directory structure
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Core directories
mkdir -p .claude/{context,prompts,workflows}
mkdir -p .github/workflows
mkdir -p .vscode
mkdir -p src/{core,utils,services,models}
mkdir -p tests/{unit,integration,e2e}
mkdir -p docs/{api,architecture,guides}
mkdir -p scripts/{setup,deploy,maintenance}
mkdir -p config/{development,staging,production}
mkdir -p infrastructure/{terraform,kubernetes,docker}

# Initialize git repository
git init

# Create CLAUDE.md (copy from artifact or download)
echo -e "${GREEN}📝 Creating CLAUDE.md...${NC}"
cat > CLAUDE.md << 'EOF'
# Copy the CLAUDE.md content from the artifact above
# This would be the full CLAUDE.md content
EOF

# Create .claude/config.yaml
echo -e "${GREEN}⚙️ Configuring Claude CLI...${NC}"
cat > .claude/config.yaml << EOF
version: "1.0"
model: claude-3-opus-20240229
temperature: 0.7
max_tokens: 4096

project:
  name: ${PROJECT_NAME}
  type: ${PROJECT_TYPE}
  language: ${LANGUAGE}
  framework: ${FRAMEWORK}

context:
  - CLAUDE.md
  - .claude/context.md
  - README.md
  - src/**/*.{ts,tsx,js,jsx,py,go,java}

standards:
  repository: https://github.com/williamzujkowski/standards
  autoload:
    - UNIFIED_STANDARDS.md
    - CODING_STANDARDS.md
    - TESTING_STANDARDS.md
    - MODERN_SECURITY_STANDARDS.md

workflows:
  code_review:
    trigger: [pre-commit, pull_request]
    standards: [CS, TS, SEC]
    
  generate_tests:
    coverage_target: 80
    mutation_testing: true
    
  security_audit:
    nist_controls: true
    vulnerability_scan: true
    schedule: weekly

features:
  auto_complete: true
  real_time_validation: true
  nist_suggestions: true
  performance_monitoring: true
  self_healing: true
EOF

# Create .claude/context.md
cat > .claude/context.md << EOF
# Project Context

## Overview
${PROJECT_NAME} - A ${PROJECT_TYPE} application built with ${LANGUAGE}

## Architecture Decisions
- **Pattern**: [Specify: MVC, Clean Architecture, Hexagonal, etc.]
- **State Management**: [Specify approach]
- **Data Layer**: [Database/storage approach]
- **Authentication**: JWT/OAuth2/Session-based
- **API Style**: REST/GraphQL/gRPC

## Key Requirements
- Performance: <100ms p95 latency
- Availability: 99.9% uptime
- Security: NIST 800-53r5 compliant
- Scalability: Support 10x growth

## Development Guidelines
1. Follow williamzujkowski/standards strictly
2. All security features require @nist annotations
3. Minimum 80% test coverage
4. Documentation for all public APIs
5. Performance budgets enforced

## Current Focus
- [ ] Initial setup and configuration
- [ ] Core feature implementation
- [ ] Testing infrastructure
- [ ] CI/CD pipeline
- [ ] Security hardening

## Technical Debt
- Track technical debt items here
- Prioritize based on impact/effort

## Notes
- Additional project-specific information
EOF

# Create GitHub Actions workflows
echo -e "${GREEN}🔧 Setting up GitHub Actions...${NC}"

# Claude Review Workflow
cat > .github/workflows/claude-review.yml << 'EOF'
name: Claude AI Code Review

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  claude-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Claude CLI
        run: |
          curl -sSL https://claude.ai/install.sh | bash
          claude auth ${{ secrets.CLAUDE_API_KEY }}
      
      - name: Run Claude Review
        run: |
          claude review \
            --standards="williamzujkowski/standards" \
            --check="security,performance,quality" \
            --suggest-improvements \
            --output=markdown > review.md
      
      - name: Post Review Comment
        uses: actions/github-script@v7
        with:
          script: |
            const fs = require('fs');
            const review = fs.readFileSync('review.md', 'utf8');
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: review
            });
EOF

# NIST Compliance Workflow
cat > .github/workflows/nist-compliance.yml << 'EOF'
name: NIST Compliance Check

on:
  push:
    branches: [main, develop]
  pull_request:

jobs:
  compliance:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Run NIST Compliance Scan
        run: |
          ./scripts/check-nist-compliance.sh
      
      - name: Generate SSP
        run: |
          claude generate-ssp \
            --format=oscal \
            --controls="AC,AU,IA,SC" \
            --output=compliance/ssp.json
      
      - name: Upload Compliance Report
        uses: actions/upload-artifact@v4
        with:
          name: compliance-report
          path: compliance/
EOF

# Create VS Code settings
echo -e "${GREEN}💻 Configuring VS Code...${NC}"
cat > .vscode/settings.json << 'EOF'
{
  "claude.enabled": true,
  "claude.autoComplete": true,
  "claude.realTimeStandardsCheck": true,
  "claude.nistControlSuggestions": true,
  "claude.contextFile": "CLAUDE.md",
  "claude.standards.repository": "williamzujkowski/standards",
  "claude.codeReview.onSave": true,
  "claude.testing.generateOnChange": true,
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true,
    "source.organizeImports": true
  },
  "files.exclude": {
    "**/__pycache__": true,
    "**/.pytest_cache": true,
    "**/node_modules": true,
    "**/.next": true,
    "**/dist": true
  }
}
EOF

# Create Docker configuration
echo -e "${GREEN}🐳 Creating Docker configuration...${NC}"
cat > Dockerfile << 'EOF'
# Multi-stage build optimized for security and size
FROM node:20-alpine AS builder

# Security: Run as non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

WORKDIR /app

# Install dependencies (cached layer)
COPY package*.json ./
RUN npm ci --only=production

# Copy application code
COPY --chown=nodejs:nodejs . .

# Build application
RUN npm run build

# Production stage
FROM node:20-alpine

# @nist: CM-7 (Least Functionality)
RUN apk add --no-cache dumb-init

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

WORKDIR /app

# Copy built application
COPY --from=builder --chown=nodejs:nodejs /app/dist ./dist
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nodejs:nodejs /app/package*.json ./

# @nist: AC-3 (Access Enforcement)
USER nodejs

# @nist: SC-5 (Denial of Service Protection)
ENV NODE_OPTIONS="--max-old-space-size=2048"

EXPOSE 3000

ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "dist/index.js"]
EOF

# Create docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - LOG_LEVEL=info
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
    restart: unless-stopped
    networks:
      - app-network
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M

  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./config/prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus-data:/prometheus
    ports:
      - "9090:9090"
    networks:
      - app-network

  grafana:
    image: grafana/grafana:latest
    volumes:
      - grafana-data:/var/lib/grafana
    ports:
      - "3001:3000"
    networks:
      - app-network

networks:
  app-network:
    driver: bridge

volumes:
  prometheus-data:
  grafana-data:
EOF

# Create .gitignore
echo -e "${GREEN}📄 Creating .gitignore...${NC}"
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
venv/
vendor/

# Build outputs
dist/
build/
*.egg-info/
__pycache__/
*.pyc

# Environment
.env
.env.local
.env.*.local

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# Testing
coverage/
.coverage
.pytest_cache/
*.cover
htmlcov/

# Logs
*.log
logs/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# OS
.DS_Store
Thumbs.db

# Claude
.claude-flow/
.claude/cache/

# Temporary
*.tmp
*.bak
*.orig

# Security
*.key
*.pem
*.crt
secrets/
EOF

# Create README.md
echo -e "${GREEN}📖 Creating README.md...${NC}"
cat > README.md << EOF
# ${PROJECT_NAME}

> AI-Powered ${PROJECT_TYPE} built with ${LANGUAGE} and Claude CLI

[![Claude Standards](https://img.shields.io/badge/Standards-williamzujkowski-blue)](https://github.com/williamzujkowski/standards)
[![NIST Compliant](https://img.shields.io/badge/NIST-800--53r5-green)]()
[![Coverage](https://img.shields.io/badge/Coverage-80%25+-brightgreen)]()

## 🚀 Quick Start

\`\`\`bash
# Clone and setup
git clone <repository>
cd ${PROJECT_NAME}
./scripts/setup.sh

# Start with Claude CLI
claude init
claude generate boilerplate

# Run development
npm run dev  # or appropriate command
\`\`\`

## 🤖 AI-Powered Development

This project uses Claude CLI for intelligent development assistance:

\`\`\`bash
# Generate code
claude generate component --name=UserAuth --standards=SEC:auth

# Run tests
claude test --coverage=90

# Code review
claude review --suggest-improvements

# Deploy
claude deploy --environment=staging --validate
\`\`\`

## 📚 Documentation

- [CLAUDE.md](./CLAUDE.md) - AI development interface
- [Architecture](./docs/architecture/) - System design
- [API Documentation](./docs/api/) - API reference
- [Standards](https://github.com/williamzujkowski/standards) - Development standards

## 🧪 Testing

\`\`\`bash
# Run all tests
npm test

# With coverage
npm run test:coverage

# Watch mode
npm run test:watch
\`\`\`

## 🛡️ Security

This project implements NIST 800-53r5 controls:
- **AC-2**: Account Management
- **AC-3**: Access Enforcement  
- **AU-2**: Audit Events
- **IA-2**: Identification and Authentication
- **SC-13**: Cryptographic Protection

## 📊 Monitoring

- Prometheus metrics at \`/metrics\`
- Health check at \`/health\`
- Grafana dashboards included

## 🚢 Deployment

\`\`\`bash
# Docker
docker build -t ${PROJECT_NAME} .
docker run -p 3000:3000 ${PROJECT_NAME}

# Docker Compose
docker-compose up -d

# Kubernetes
kubectl apply -f infrastructure/kubernetes/
\`\`\`

## 📝 License

[Choose License]

## 🤝 Contributing

Please read [CONTRIBUTING.md](./CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

---

Built with ❤️ using [Claude CLI](https://claude.ai) and [williamzujkowski/standards](https://github.com/williamzujkowski/standards)
EOF

# Create setup script
echo -e "${GREEN}🔨 Creating setup scripts...${NC}"
mkdir -p scripts
cat > scripts/setup.sh << 'EOF'
#!/bin/bash
set -e

echo "🚀 Setting up development environment..."

# Check for required tools
command -v claude >/dev/null 2>&1 || { 
    echo "Installing Claude CLI..."
    curl -sSL https://claude.ai/install.sh | bash
}

# Install dependencies based on project type
if [ -f "package.json" ]; then
    echo "📦 Installing Node.js dependencies..."
    npm install
fi

if [ -f "requirements.txt" ]; then
    echo "🐍 Setting up Python environment..."
    python -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
fi

if [ -f "go.mod" ]; then
    echo "🐹 Installing Go dependencies..."
    go mod download
fi

# Set up git hooks
echo "🪝 Installing git hooks..."
cat > .git/hooks/pre-commit << 'HOOK'
#!/bin/bash
claude validate --standards --tests --security
HOOK
chmod +x .git/hooks/pre-commit

# Download standards
echo "📚 Fetching standards..."
git submodule add https://github.com/williamzujkowski/standards.git .standards || true

# Initialize Claude
echo "🤖 Initializing Claude..."
claude init

echo "✅ Setup complete! Run 'claude help' to get started."
EOF
chmod +x scripts/setup.sh

# Create check-nist-compliance script
cat > scripts/check-nist-compliance.sh << 'EOF'
#!/bin/bash
set -e

echo "🛡️ Checking NIST compliance..."

# Find all @nist annotations
echo "Finding NIST control annotations..."
grep -r "@nist:" --include="*.js" --include="*.ts" --include="*.py" --include="*.go" . | wc -l

# Generate compliance report
claude analyze \
  --compliance=nist \
  --output=compliance-report.json \
  --format=json

# Check coverage
COVERAGE=$(jq '.coverage_percentage' compliance-report.json)
if (( $(echo "$COVERAGE < 80" | bc -l) )); then
    echo "⚠️ NIST compliance below 80%: ${COVERAGE}%"
    exit 1
fi

echo "✅ NIST compliance check passed: ${COVERAGE}%"
EOF
chmod +x scripts/check-nist-compliance.sh

# Create example workflows
echo -e "${GREEN}📋 Creating Claude workflows...${NC}"

# Test generation workflow
cat > .claude/workflows/generate-tests.yaml << 'EOF'
name: generate-comprehensive-tests
description: Generate complete test suite with high coverage

triggers:
  - on_demand
  - file_change: src/**/*

parameters:
  coverage_target: 90
  test_types:
    - unit
    - integration
    - property_based
    - mutation

steps:
  - analyze:
      action: identify_test_gaps
      standards: TS:*
      
  - generate:
      action: create_test_files
      template: best_practices
      
  - validate:
      action: run_tests
      ensure_coverage: true
      
  - optimize:
      action: remove_redundant_tests
      maintain_coverage: true
EOF

# Security audit workflow  
cat > .claude/workflows/security-audit.yaml << 'EOF'
name: security-audit
description: Comprehensive security analysis

schedule: weekly

steps:
  - scan:
      dependencies: true
      code: true
      secrets: true
      
  - analyze:
      nist_controls: true
      owasp_top_10: true
      cwe_sans_25: true
      
  - report:
      format: [json, markdown, pdf]
      severity_threshold: medium
      
  - remediate:
      auto_fix: low_severity
      create_tickets: medium_high_severity
EOF

# Create example prompts
echo -e "${GREEN}💬 Creating prompt templates...${NC}"

cat > .claude/prompts/refactor.md << 'EOF'
# Refactoring Prompt

Refactor this code following:
1. williamzujkowski/standards CODING_STANDARDS
2. SOLID principles
3. DRY principle
4. Performance optimization
5. Security best practices

Provide:
- Refactored code with comments
- Explanation of changes
- Performance impact assessment
- Test cases for new structure
EOF

cat > .claude/prompts/architecture.md << 'EOF'
# Architecture Review Prompt

Review this architecture considering:
1. Scalability (10x growth)
2. Security (NIST compliance)
3. Performance (sub-100ms p95)
4. Maintainability
5. Cost optimization

Provide:
- Strengths and weaknesses
- Specific improvement recommendations
- Alternative approaches
- Migration path if needed
EOF

# Final setup
echo -e "${BLUE}🎯 Initializing git repository...${NC}"
git add .
git commit -m "Initial template repository setup with Claude CLI and williamzujkowski/standards"

echo -e "${GREEN}✨ Template repository created successfully!${NC}"
echo ""
echo "Next steps:"
echo "1. cd ${PROJECT_NAME}"
echo "2. ./scripts/setup.sh"
echo "3. claude init"
echo "4. Update project-specific sections in CLAUDE.md"
echo "5. Start developing with 'claude generate boilerplate'"
echo ""
echo -e "${YELLOW}📚 Resources:${NC}"
echo "- Standards: https://github.com/williamzujkowski/standards"
echo "- Claude CLI: https://docs.anthropic.com/claude-cli"
echo "- NIST Framework: https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-53r5.pdf"