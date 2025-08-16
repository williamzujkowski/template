# 🚀 RepoForge Quick Reference Card

## 📦 Installation

```bash
# One-line install
curl -sSL https://get.repoforge.dev | bash

# Or manual install
npm install -g repoforge-cli
export ANTHROPIC_API_KEY="your-key"
```

## ⚡ Essential Commands

### Project Creation
```bash
rf init                           # Interactive mode
rf init --name my-app            # With name
rfnew my-api                     # Quick create (alias)
rf init --preset fullstack       # Use preset
```

### Project Types
```bash
# Web Application
rf init --type web --framework react

# API Service  
rf init --type api --framework fastapi

# Microservice
rf init --type microservice --language go

# CLI Tool
rf init --type cli --framework commander

# Mobile App
rf init --type mobile --framework react-native
```

### Validation & Security
```bash
rf validate .                     # Validate project
rf secure .                       # Security audit
rf secure . --fix                # Auto-fix issues
rf compliance --nist             # Check compliance
```

### Testing
```bash
rf test                          # Run all tests
rf test --coverage              # With coverage
rf test --watch                 # Watch mode
rf generate tests               # Generate tests
```

### Documentation
```bash
rf docs generate                 # Generate docs
rf docs validate                # Check docs
rf docs serve                   # Preview docs
```

### Deployment
```bash
rf deploy                        # Deploy to default
rf deploy --env production      # Deploy to prod
rf deploy --preview             # Preview deployment
```

## 🎨 Common Workflows

### Create Full-Stack App
```bash
rf init \
  --name my-app \
  --type web \
  --framework nextjs \
  --database postgres \
  --auth clerk \
  --features "api,admin,analytics"
```

### Create Microservices
```bash
# Create multiple services
for service in auth user product order; do
  rf init --name $service-service \
    --type microservice \
    --language go
done
```

### Add Features to Existing Project
```bash
rf enhance . --add authentication
rf enhance . --add database
rf enhance . --add monitoring
rf enhance . --add payments
```

## 🛠️ Configuration

### Global Settings
```bash
rf config set default.language typescript
rf config set testing.coverage 90
rf config set security.scan true
rf config list                   # Show all settings
```

### Project Settings (.repoforge.yaml)
```yaml
version: "1.0"
project:
  type: api
  language: typescript
features:
  - authentication
  - database
testing:
  coverage: 90
```

## 🔧 Advanced Features

### Claude Integration
```bash
rf claude generate component UserAuth
rf claude review .
rf claude refactor ./src --optimize
rf claude audit --security
```

### Standards Management
```bash
rf standards sync                # Update standards
rf standards apply .            # Apply to project
rf standards check              # Check compliance
rf standards report             # Generate report
```

### Monitoring & Observability
```bash
rf monitor setup --prometheus
rf monitor dashboard --grafana
rf monitor alerts --critical
```

## 🐛 Troubleshooting

### Diagnostics
```bash
rf doctor                        # Run diagnostics
rf doctor --fix                 # Auto-fix issues
rf cache clear                  # Clear cache
rf update                       # Update CLI
```

### Debug Mode
```bash
rf init --debug                 # Debug output
rf init --verbose              # Verbose logging
rf init --dry-run              # Preview only
```

## ⌨️ Aliases & Shortcuts

```bash
# Bash/Zsh aliases (add to .bashrc/.zshrc)
alias rf='repoforge'
alias rfi='repoforge init'
alias rfv='repoforge validate'
alias rfs='repoforge secure'
alias rfd='repoforge deploy'

# Quick functions
rfnew() {
  repoforge init --name "$1" --yes
}

rfcheck() {
  repoforge validate . && repoforge secure .
}
```

## 📊 Flags & Options

### Common Flags
```bash
--yes, -y              # Skip prompts
--quiet, -q           # Minimal output
--verbose, -v         # Detailed output
--debug               # Debug mode
--dry-run            # Preview only
--force, -f          # Force action
--help, -h           # Show help
```

### Feature Flags
```bash
--features all                  # All features
--features "auth,db,api"       # Specific features
--no-tests                      # Skip tests
--no-git                       # Skip git init
--no-install                   # Skip npm install
```

## 🎯 Presets

```bash
rf init --preset api            # REST API
rf init --preset fullstack      # Full-stack web
rf init --preset microservice   # Microservice
rf init --preset serverless     # Serverless function
rf init --preset static         # Static site
rf init --preset mobile         # Mobile app
rf init --preset cli            # CLI tool
rf init --preset library        # NPM package
```

## 📦 Project Structure

```
generated-project/
├── .claude/              # Claude CLI config
├── .github/workflows/    # CI/CD workflows
├── src/                  # Source code
├── tests/                # Test files
├── docs/                 # Documentation
├── scripts/              # Utility scripts
├── config/               # Configurations
├── infrastructure/       # IaC files
├── CLAUDE.md            # AI interface
├── README.md            # Documentation
└── .repoforge.yaml      # Project config
```

## 🔑 Environment Variables

```bash
ANTHROPIC_API_KEY         # Claude API key
REPOFORGE_HOME           # Config directory
REPOFORGE_CONFIG         # Config file path
REPOFORGE_CACHE          # Cache directory
REPOFORGE_DEBUG          # Enable debug mode
REPOFORGE_STANDARDS      # Standards repo path
```

## 📈 Metrics & Reports

```bash
rf metrics show                 # Show metrics
rf report generate             # Generate report
rf report compliance           # Compliance report
rf report security            # Security report
rf benchmark run              # Run benchmarks
```

## 🔄 Update & Maintenance

```bash
rf update                      # Update CLI
rf update --check             # Check for updates
rf standards update           # Update standards
rf clean                      # Clean temp files
rf repair                     # Repair installation
```

## 💡 Pro Tips

1. **Use presets for speed**: `rf init --preset api`
2. **Chain commands**: `rf init && rf test && rf deploy`
3. **Save configs**: `rf config export > my-config.yaml`
4. **Batch operations**: `find . -type d -name "src" | xargs -I {} rf validate {}`
5. **Custom templates**: Save in `~/.repoforge/templates/`

## 🆘 Help & Support

```bash
rf help                        # General help
rf help init                  # Command help
rf docs                       # Open documentation
rf support                    # Contact support
```

## 🔗 Useful Links

- 📚 [Documentation](https://docs.repoforge.dev)
- 💬 [Discord](https://discord.gg/repoforge)
- 🐛 [Issues](https://github.com/repoforge/cli/issues)
- 📦 [Standards](https://github.com/williamzujkowski/standards)
- 🤖 [Claude Docs](https://docs.anthropic.com)

---

**Version**: 1.0.0 | **Updated**: 2024 | **License**: MIT

*Print this card: `rf docs print-card`*