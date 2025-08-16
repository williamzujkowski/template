# 🚀 Template Repository Generator

> AI-powered template repository generator with Claude CLI integration and williamzujkowski/standards compliance

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)]()
[![Standards](https://img.shields.io/badge/standards-williamzujkowski-green.svg)](https://github.com/williamzujkowski/standards)
[![NIST Compliant](https://img.shields.io/badge/NIST-800--53r5-purple.svg)]()
[![License](https://img.shields.io/badge/license-MIT-orange.svg)]()

## 📋 Overview

This template repository provides a complete, production-ready foundation for new projects with:
- 🤖 Claude AI integration for intelligent code generation
- 📚 Automatic compliance with williamzujkowski/standards
- 🛡️ NIST 800-53r5 security controls built-in
- 🧪 Comprehensive testing infrastructure
- 📊 Full observability and monitoring
- 🚀 CI/CD pipelines ready to go

## ⚡ Quick Start

### Option 1: Interactive Setup (Recommended)
```bash
# Clone this template repository
git clone https://github.com/yourusername/template-generator.git
cd template-generator

# Run the interactive setup
./setup.sh

# Follow the prompts to configure your project
```

### Option 2: One-Command Setup
```bash
# Create a new project with defaults
./setup.sh my-project api typescript express
```

### Option 3: Using Make
```bash
# If you have Make installed
make new PROJECT_NAME=my-api PROJECT_TYPE=api
```

## 📁 Repository Structure

```
template-generator/
├── CLAUDE.md                 # AI development interface template
├── PROJECT_INIT.md          # Universal project initialization prompt
├── claude-swarm.yaml        # Parallel AI processing configuration
├── setup.sh                 # Main setup script
├── init-project.sh          # Project initialization wrapper
├── Makefile                 # Convenient make commands
├── .claude/
│   ├── config.yaml         # Claude CLI configuration template
│   ├── prompts/            # Custom prompt templates
│   └── workflows/          # Claude workflow definitions
├── .github/
│   └── workflows/
│       ├── claude-review.yml   # AI code review workflow
│       ├── security.yml        # Security scanning workflow
│       └── ci.yml             # Continuous integration
├── scripts/
│   ├── check-nist-compliance.sh
│   └── validate-standards.sh
└── docs/
    ├── SETUP.md
    └── CUSTOMIZATION.md
```

## 🎯 Features

### AI-Powered Development
- **Claude CLI Integration**: Intelligent code generation and review
- **Claude Swarm**: Parallel processing with multiple AI agents
- **Smart Refactoring**: AI-driven code improvements
- **Automated Testing**: AI generates comprehensive test suites

### Standards & Compliance
- **williamzujkowski/standards**: Automatic integration and enforcement
- **NIST 800-53r5**: Security controls with @nist annotations
- **SOC2, GDPR, HIPAA**: Compliance templates included
- **Code Quality**: Enforced through pre-commit hooks

### Security First
- **Security Scanning**: Automated vulnerability detection
- **Secret Management**: Built-in secret scanning
- **Rate Limiting**: Default protection against abuse
- **Audit Logging**: Comprehensive security event tracking

### Complete DevOps
- **CI/CD Pipelines**: GitHub Actions workflows ready
- **Docker Support**: Multi-stage builds optimized for security
- **Kubernetes Ready**: Manifests and configurations included
- **Monitoring**: Prometheus + Grafana integration

## 🔧 Configuration

### Environment Variables
```bash
# Required
export ANTHROPIC_API_KEY="your-claude-api-key"

# Optional
export GITHUB_TOKEN="your-github-token"
export STANDARDS_REPO="https://github.com/williamzujkowski/standards"
```

### Customization

Edit `.claude/config.yaml` to customize:
- Model selection (Claude 3 Opus/Sonnet)
- Temperature and token limits
- Standards to auto-load
- Workflow triggers
- Quality gates

## 📊 Supported Project Types

| Type | Languages | Frameworks | Features |
|------|-----------|------------|----------|
| **Web** | TypeScript, JavaScript | React, Next.js, Vue, Angular | SSR, PWA, SEO |
| **API** | TypeScript, Python, Go | Express, FastAPI, Gin | REST, GraphQL, gRPC |
| **CLI** | TypeScript, Python, Go, Rust | Commander, Click, Cobra | Interactive, Plugins |
| **Microservice** | Go, Java, Python | Gin, Spring, FastAPI | Service Mesh, CQRS |
| **Library** | Any | - | NPM, PyPI, Crates |
| **Data Pipeline** | Python, Scala | Airflow, Spark | ETL, Streaming |

## 🚀 Usage Examples

### Create a TypeScript API
```bash
./setup.sh my-api api typescript express
```

### Create a Python Microservice
```bash
./setup.sh user-service microservice python fastapi
```

### Create a React Web App
```bash
./setup.sh my-app web typescript react
```

### Batch Project Creation
```bash
# Create multiple services
for service in auth user product order; do
  ./setup.sh "$service-service" microservice go gin
done
```

## 📝 Generated Project Structure

Every generated project includes:
```
my-project/
├── CLAUDE.md                # Customized AI interface
├── .claude/                 # Claude CLI configuration
├── .github/workflows/       # Complete CI/CD
├── src/                     # Source code with boilerplate
├── tests/                   # Test suite with examples
├── docs/                    # Auto-generated documentation
├── scripts/                 # Utility scripts
├── config/                  # Environment configurations
├── infrastructure/          # IaC (Terraform, K8s)
├── Dockerfile              # Multi-stage, secure build
├── docker-compose.yml      # Local development
└── README.md               # Complete documentation
```

## 🧪 Testing

The template includes:
- Unit test examples with 80%+ coverage target
- Integration test setup
- E2E test configuration
- Performance benchmarks
- Security test cases
- Mutation testing setup

## 🛡️ Security Features

- **NIST Control Annotations**: All security features tagged
- **Vulnerability Scanning**: Automated with every commit
- **Dependency Checking**: Regular updates and audits
- **Security Headers**: Pre-configured for web projects
- **Rate Limiting**: Built-in DDoS protection
- **Encryption**: At-rest and in-transit

## 📊 Monitoring & Observability

- **Metrics**: Prometheus integration
- **Logging**: Structured JSON logging
- **Tracing**: OpenTelemetry support
- **Dashboards**: Grafana templates included
- **Alerts**: Pre-configured alert rules
- **Health Checks**: Liveness and readiness probes

## 🔄 Continuous Improvement

The template automatically:
- Syncs with latest standards weekly
- Updates dependencies with security patches
- Suggests improvements based on usage patterns
- Generates compliance reports

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Development Setup
```bash
# Clone the repository
git clone https://github.com/yourusername/template-generator.git
cd template-generator

# Install dependencies
npm install

# Run tests
npm test

# Submit changes
git checkout -b feature/your-feature
git commit -m "Add your feature"
git push origin feature/your-feature
```

## 📚 Documentation

- [Setup Guide](docs/SETUP.md) - Detailed setup instructions
- [Customization Guide](docs/CUSTOMIZATION.md) - How to customize templates
- [Standards](https://github.com/williamzujkowski/standards) - Standards repository
- [Claude CLI Docs](https://docs.anthropic.com) - Claude documentation

## 🐛 Troubleshooting

### Common Issues

**Claude API Key not working**
```bash
# Verify your API key
export ANTHROPIC_API_KEY="sk-ant-..."
echo $ANTHROPIC_API_KEY
```

**Standards not loading**
```bash
# Manually clone standards
git clone https://github.com/williamzujkowski/standards.git ~/.standards
```

**Permission denied on scripts**
```bash
# Make scripts executable
chmod +x setup.sh init-project.sh scripts/*.sh
```

## 📈 Roadmap

- [ ] Web UI for project generation
- [ ] VSCode extension
- [ ] More language templates (C#, Kotlin, Swift)
- [ ] Cloud deployment wizards
- [ ] Template marketplace
- [ ] Team collaboration features

## 📝 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [williamzujkowski/standards](https://github.com/williamzujkowski/standards) for comprehensive development standards
- [Anthropic](https://anthropic.com) for Claude AI
- The open-source community

## 📞 Support

- 📧 Email: support@example.com
- 💬 Discord: [Join our server](https://discord.gg/example)
- 🐛 Issues: [GitHub Issues](https://github.com/yourusername/template-generator/issues)

---

**Built with ❤️ by developers, for developers**

*Making project initialization intelligent, secure, and standards-compliant*