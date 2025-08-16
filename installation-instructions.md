# 📦 Installation & Setup Instructions

## Step 1: Download and Add Files to Your Repository

### Required Files to Create

Create these files in your template repository:

#### 1. **CLAUDE.md** (Root Directory)
- Copy the content from the `claude-md-template.md` file you have
- Place it in the root of your repository

#### 2. **claude-swarm.yaml** (Root Directory)
- Copy the content from the `claude-swarm-config.txt` file you have
- Save it as `claude-swarm.yaml` in the root

#### 3. **PROJECT_INIT.md** (Root Directory)
- Copy the content from the `project-init-prompt.md` file you have
- Place it in the root of your repository

#### 4. **setup.sh** (Root Directory)
- Copy the content from the "Main Setup Script" artifact above
- Save it as `setup.sh` in the root
- Make it executable: `chmod +x setup.sh`

#### 5. **init-project.sh** (Root Directory)
- Copy the content from the "Initialize New Project from Template" artifact
- Save it as `init-project.sh` in the root
- Make it executable: `chmod +x init-project.sh`

#### 6. **README.md** (Root Directory)
- Copy the content from the "Template Repository Documentation" artifact
- Replace the existing README.md

#### 7. **.claude/config.yaml**
- Create the `.claude` directory: `mkdir -p .claude`
- Copy the content from the "Claude Config Template" artifact
- Save it as `.claude/config.yaml`

#### 8. **.github/workflows/claude-review.yml**
- Create the directory: `mkdir -p .github/workflows`
- Copy the content from the "Claude Review Workflow" artifact
- Save it as `.github/workflows/claude-review.yml`

## Step 2: Create Directory Structure

Run these commands in your repository root:

```bash
# Create all necessary directories
mkdir -p .claude/{prompts,workflows,context}
mkdir -p .github/workflows
mkdir -p scripts
mkdir -p docs
mkdir -p examples
```

## Step 3: Add Support Scripts

Create these additional helper scripts:

### scripts/validate-template.sh
```bash
#!/bin/bash
# Validates that the template repository is properly set up

echo "Validating template repository setup..."

required_files=(
    "CLAUDE.md"
    "claude-swarm.yaml"
    "PROJECT_INIT.md"
    "setup.sh"
    "init-project.sh"
    "README.md"
    ".claude/config.yaml"
)

missing_files=()

for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        missing_files+=("$file")
    fi
done

if [ ${#missing_files[@]} -eq 0 ]; then
    echo "✅ All required files present!"
    exit 0
else
    echo "❌ Missing files:"
    printf '%s\n' "${missing_files[@]}"
    exit 1
fi
```

Make it executable:
```bash
chmod +x scripts/validate-template.sh
```

## Step 4: Set Up Environment

### Configure Git
```bash
# Initialize git if not already done
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial template repository setup with Claude integration"
```

### Set Environment Variables
Add to your shell profile (`~/.bashrc` or `~/.zshrc`):

```bash
# Claude API configuration
export ANTHROPIC_API_KEY="your-api-key-here"

# Optional: Standards repository location
export STANDARDS_REPO="https://github.com/williamzujkowski/standards"

# Optional: Default project settings
export DEFAULT_PROJECT_TYPE="api"
export DEFAULT_LANGUAGE="typescript"
```

## Step 5: Install Dependencies

### System Requirements
Ensure you have:
- Node.js 18+ installed
- Git installed
- Bash shell available

### Optional Tools
For full functionality, install:
```bash
# GitHub CLI (for GitHub integration)
brew install gh  # macOS
# or
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh  # Ubuntu/Debian

# Docker (for containerization)
# Follow instructions at https://docs.docker.com/get-docker/

# Make (for Makefile commands)
# Usually pre-installed on Linux/macOS
```

## Step 6: Validate Installation

Run the validation script:
```bash
./scripts/validate-template.sh
```

Test the setup script:
```bash
# Run in interactive mode (dry run)
./setup.sh --dry-run
```

## Step 7: First Project Generation

Test creating a project:

```bash
# Create a test project
./setup.sh test-project api typescript express

# Check the generated project
cd test-project
ls -la

# Verify all files were created
cat CLAUDE.md | head -20
cat .claude/config.yaml
```

## Step 8: GitHub Repository Setup

### Push to GitHub
```bash
# Create repository on GitHub (using gh CLI)
gh repo create template-generator --public --description "AI-powered template repository generator"

# Or manually create on GitHub, then:
git remote add origin https://github.com/yourusername/template-generator.git
git branch -M main
git push -u origin main
```

### Configure GitHub Secrets
Add these secrets to your GitHub repository:
1. Go to Settings → Secrets and variables → Actions
2. Add:
   - `ANTHROPIC_API_KEY`: Your Claude API key
   - `NPM_TOKEN`: (Optional) For publishing packages
   - `DOCKER_TOKEN`: (Optional) For Docker Hub

## Step 9: Optional Enhancements

### Add Makefile (Optional)
If you want Make commands, copy the Makefile from the previous artifacts.

### Add Docker Support (Optional)
Copy the docker-compose.yml from the previous artifacts.

### Add More Templates
Create additional templates in `.claude/templates/`:
```bash
mkdir -p .claude/templates/{web,api,cli,microservice}
# Add template-specific files to each directory
```

## 📋 Quick Checklist

- [ ] All required files created and in place
- [ ] Scripts are executable (`chmod +x`)
- [ ] Directory structure created
- [ ] Environment variables set
- [ ] Git repository initialized
- [ ] Validation script passes
- [ ] Test project generates successfully
- [ ] GitHub repository configured (if using)

## 🎯 Usage After Installation

Once everything is set up, users can:

```bash
# Clone your template repository
git clone https://github.com/yourusername/template-generator.git
cd template-generator

# Generate a new project
./setup.sh my-new-project api typescript express

# Or use interactive mode
./setup.sh
```

## 🆘 Troubleshooting

### Permission Denied
```bash
# Fix script permissions
chmod +x setup.sh init-project.sh scripts/*.sh
```

### Claude API Issues
```bash
# Verify API key is set
echo $ANTHROPIC_API_KEY

# Test API key (you'll need curl)
curl https://api.anthropic.com/v1/messages \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{"model":"claude-3-opus-20240229","messages":[{"role":"user","content":"Hello"}],"max_tokens":10}'
```

### Standards Repository Issues
```bash
# Manually clone standards
git clone https://github.com/williamzujkowski/standards.git .standards
```

## 📝 Final Notes

- Keep your template repository up to date
- Regularly sync with williamzujkowski/standards
- Test new project generation after major changes
- Document any customizations you make

---

**Support**: If you encounter issues, please open an issue on the GitHub repository.