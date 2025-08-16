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
│       └── claude-review.yml   # AI code review workflow
├── scripts/
│   └── validate-template.sh
└── docs/
    └── SETUP.md
```

## 📝 License

MIT License - see [LICENSE](LICENSE) file for details.

---

**Built with ❤️ by developers, for developers**
