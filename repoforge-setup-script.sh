#!/bin/bash
# setup-repoforge.sh - Complete RepoForge Installation and Setup Script
# This script sets up RepoForge CLI, configures Claude integration, and prepares your environment

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Configuration variables
REPOFORGE_VERSION="latest"
REPOFORGE_HOME="$HOME/.repoforge"
STANDARDS_REPO="https://github.com/williamzujkowski/standards.git"
NODE_MIN_VERSION="18.0.0"

# ASCII Art Banner
print_banner() {
    echo -e "${CYAN}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║  ██████╗ ███████╗██████╗  ██████╗ ███████╗ ██████╗ ██████╗  ║
║  ██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔════╝██╔═══██╗██╔══██╗ ║
║  ██████╔╝█████╗  ██████╔╝██║   ██║█████╗  ██║   ██║██████╔╝ ║
║  ██╔══██╗██╔══╝  ██╔═══╝ ██║   ██║██╔══╝  ██║   ██║██╔══██╗ ║
║  ██║  ██║███████╗██║     ╚██████╔╝██║     ╚██████╔╝██║  ██║ ║
║  ╚═╝  ╚═╝╚══════╝╚═╝      ╚═════╝ ╚═╝      ╚═════╝ ╚═╝  ╚═╝ ║
║                                                               ║
║     AI-Powered Template Repository Generator Setup v1.0      ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Utility functions
log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

log_step() {
    echo -e "\n${BOLD}${MAGENTA}▶ $1${NC}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Compare semantic versions
version_compare() {
    if [[ $1 == $2 ]]; then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++)); do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++)); do
        if [[ -z ${ver2[i]} ]]; then
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]})); then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]})); then
            return 2
        fi
    done
    return 0
}

# Spinner function
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Check system requirements
check_requirements() {
    log_step "Checking system requirements"
    
    local all_good=true
    
    # Check OS
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        log_success "Linux detected"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        log_success "macOS detected"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        log_warning "Windows detected - some features may require WSL"
    else
        log_error "Unsupported OS: $OSTYPE"
        all_good=false
    fi
    
    # Check Node.js
    if command_exists node; then
        NODE_VERSION=$(node -v | sed 's/v//')
        version_compare $NODE_VERSION $NODE_MIN_VERSION
        if [[ $? -le 1 ]]; then
            log_success "Node.js $NODE_VERSION found"
        else
            log_error "Node.js version $NODE_VERSION is too old (minimum: $NODE_MIN_VERSION)"
            all_good=false
        fi
    else
        log_error "Node.js not found - please install Node.js $NODE_MIN_VERSION or later"
        all_good=false
    fi
    
    # Check npm
    if command_exists npm; then
        NPM_VERSION=$(npm -v)
        log_success "npm $NPM_VERSION found"
    else
        log_error "npm not found"
        all_good=false
    fi
    
    # Check Git
    if command_exists git; then
        GIT_VERSION=$(git --version | awk '{print $3}')
        log_success "Git $GIT_VERSION found"
    else
        log_error "Git not found - please install Git"
        all_good=false
    fi
    
    # Check Docker (optional)
    if command_exists docker; then
        DOCKER_VERSION=$(docker --version | awk '{print $3}' | sed 's/,//')
        log_success "Docker $DOCKER_VERSION found (optional)"
    else
        log_info "Docker not found (optional - needed for containerization)"
    fi
    
    # Check disk space
    AVAILABLE_SPACE=$(df -h . | awk 'NR==2 {print $4}' | sed 's/G//')
    if [[ ${AVAILABLE_SPACE%.*} -ge 2 ]]; then
        log_success "Sufficient disk space available"
    else
        log_warning "Low disk space - at least 2GB recommended"
    fi
    
    if [[ "$all_good" == false ]]; then
        log_error "System requirements not met. Please install missing components."
        exit 1
    fi
    
    log_success "All system requirements met"
}

# Install Node.js if missing
install_nodejs() {
    log_step "Installing Node.js"
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
        sudo apt-get install -y nodejs
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if command_exists brew; then
            brew install node
        else
            log_error "Please install Homebrew first: https://brew.sh"
            exit 1
        fi
    else
        log_error "Please install Node.js manually from https://nodejs.org"
        exit 1
    fi
}

# Create directory structure
create_directories() {
    log_step "Creating RepoForge directory structure"
    
    mkdir -p "$REPOFORGE_HOME"/{config,templates,cache,logs,standards,plugins}
    
    log_success "Directory structure created at $REPOFORGE_HOME"
}

# Clone standards repository
clone_standards() {
    log_step "Cloning williamzujkowski/standards repository"
    
    if [[ -d "$REPOFORGE_HOME/standards/.git" ]]; then
        log_info "Standards repository already exists, updating..."
        (cd "$REPOFORGE_HOME/standards" && git pull origin master) &
        spinner $!
        log_success "Standards repository updated"
    else
        git clone "$STANDARDS_REPO" "$REPOFORGE_HOME/standards" &
        spinner $!
        log_success "Standards repository cloned"
    fi
}

# Install RepoForge CLI
install_repoforge() {
    log_step "Installing RepoForge CLI"
    
    # Check if already installed
    if command_exists repoforge; then
        log_info "RepoForge already installed, updating..."
        npm update -g repoforge-cli &
        spinner $!
    else
        log_info "Installing RepoForge globally..."
        npm install -g repoforge-cli@$REPOFORGE_VERSION &
        spinner $!
    fi
    
    # Verify installation
    if command_exists repoforge; then
        INSTALLED_VERSION=$(repoforge --version 2>/dev/null || echo "unknown")
        log_success "RepoForge $INSTALLED_VERSION installed successfully"
    else
        log_error "RepoForge installation failed"
        exit 1
    fi
}

# Install additional tools
install_additional_tools() {
    log_step "Installing additional tools"
    
    # Claude CLI
    if ! command_exists claude; then
        log_info "Installing Claude CLI..."
        npm install -g @anthropic-ai/claude-cli &
        spinner $!
        log_success "Claude CLI installed"
    else
        log_success "Claude CLI already installed"
    fi
    
    # GitHub CLI (optional)
    if ! command_exists gh; then
        log_info "GitHub CLI not found (optional - needed for GitHub integration)"
        echo "  Install with: https://cli.github.com/manual/installation"
    else
        log_success "GitHub CLI found"
    fi
    
    # Install useful global packages
    log_info "Installing useful development tools..."
    npm install -g \
        prettier \
        eslint \
        typescript \
        nodemon \
        concurrently \
        npm-check-updates &
    spinner $!
    log_success "Development tools installed"
}

# Configure API keys
configure_api_keys() {
    log_step "Configuring API keys"
    
    # Check if API key already exists
    if [[ -n "$ANTHROPIC_API_KEY" ]]; then
        log_success "Anthropic API key already configured"
    else
        echo ""
        echo "To use RepoForge, you need an Anthropic API key."
        echo "Get one at: https://console.anthropic.com/account/keys"
        echo ""
        read -p "Enter your Anthropic API key (or press Enter to skip): " api_key
        
        if [[ -n "$api_key" ]]; then
            # Add to shell profile
            SHELL_PROFILE=""
            if [[ -f "$HOME/.zshrc" ]]; then
                SHELL_PROFILE="$HOME/.zshrc"
            elif [[ -f "$HOME/.bashrc" ]]; then
                SHELL_PROFILE="$HOME/.bashrc"
            elif [[ -f "$HOME/.bash_profile" ]]; then
                SHELL_PROFILE="$HOME/.bash_profile"
            fi
            
            if [[ -n "$SHELL_PROFILE" ]]; then
                echo "" >> "$SHELL_PROFILE"
                echo "# RepoForge Configuration" >> "$SHELL_PROFILE"
                echo "export ANTHROPIC_API_KEY='$api_key'" >> "$SHELL_PROFILE"
                echo "export REPOFORGE_HOME='$REPOFORGE_HOME'" >> "$SHELL_PROFILE"
                log_success "API key saved to $SHELL_PROFILE"
                
                # Export for current session
                export ANTHROPIC_API_KEY="$api_key"
                export REPOFORGE_HOME="$REPOFORGE_HOME"
            fi
        else
            log_warning "API key skipped - you'll need to set ANTHROPIC_API_KEY later"
        fi
    fi
}

# Configure RepoForge
configure_repoforge() {
    log_step "Configuring RepoForge"
    
    # Create default configuration
    cat > "$REPOFORGE_HOME/config/default.yaml" << EOF
# RepoForge Default Configuration
version: "1.0"

defaults:
  language: typescript
  type: api
  framework: express
  
standards:
  repository: $STANDARDS_REPO
  auto_update: true
  
security:
  nist_compliance: true
  scan_on_generate: true
  block_on_high_vulnerabilities: true
  
testing:
  coverage_threshold: 80
  generate_tests: true
  
ai:
  model: claude-3-opus-20240229
  temperature: 0.7
  max_tokens: 4096
  
features:
  auto_documentation: true
  git_hooks: true
  ci_cd: github-actions
  
paths:
  templates: $REPOFORGE_HOME/templates
  cache: $REPOFORGE_HOME/cache
  logs: $REPOFORGE_HOME/logs
EOF
    
    log_success "Default configuration created"
    
    # Initialize RepoForge
    if command_exists repoforge; then
        log_info "Initializing RepoForge..."
        repoforge setup --config "$REPOFORGE_HOME/config/default.yaml" &
        spinner $!
        log_success "RepoForge initialized"
    fi
}

# Create aliases and shortcuts
create_shortcuts() {
    log_step "Creating shortcuts and aliases"
    
    # Determine shell profile
    SHELL_PROFILE=""
    if [[ -f "$HOME/.zshrc" ]]; then
        SHELL_PROFILE="$HOME/.zshrc"
    elif [[ -f "$HOME/.bashrc" ]]; then
        SHELL_PROFILE="$HOME/.bashrc"
    elif [[ -f "$HOME/.bash_profile" ]]; then
        SHELL_PROFILE="$HOME/.bash_profile"
    fi
    
    if [[ -n "$SHELL_PROFILE" ]]; then
        cat >> "$SHELL_PROFILE" << 'EOF'

# RepoForge Aliases
alias rf='repoforge'
alias rfi='repoforge init'
alias rfv='repoforge validate'
alias rfs='repoforge secure'
alias rfd='repoforge deploy'
alias rfc='repoforge claude'

# Quick project creation
rfnew() {
    repoforge init --name "$1" --type "${2:-api}" --language "${3:-typescript}" --yes
}

# Project validation and fix
rfcheck() {
    repoforge validate "${1:-.}" && repoforge secure "${1:-.}" --auto-fix
}

# Update everything
rfupdate() {
    npm update -g repoforge-cli
    (cd "$REPOFORGE_HOME/standards" && git pull)
    repoforge standards sync
}
EOF
        log_success "Aliases and shortcuts created"
    fi
}

# Run diagnostics
run_diagnostics() {
    log_step "Running diagnostics"
    
    if command_exists repoforge; then
        repoforge doctor --quiet
        if [[ $? -eq 0 ]]; then
            log_success "All diagnostics passed"
        else
            log_warning "Some diagnostics failed - run 'repoforge doctor' for details"
        fi
    fi
}

# Create example project
create_example() {
    log_step "Creating example project (optional)"
    
    read -p "Would you like to create an example project? (y/N): " create_example
    
    if [[ "$create_example" =~ ^[Yy]$ ]]; then
        log_info "Creating example API project..."
        
        # Create temporary directory
        EXAMPLE_DIR="$HOME/repoforge-example"
        mkdir -p "$EXAMPLE_DIR"
        cd "$EXAMPLE_DIR"
        
        # Generate example project
        repoforge init \
            --name example-api \
            --type api \
            --language typescript \
            --framework express \
            --features "auth,database,api" \
            --yes
        
        if [[ -d "$EXAMPLE_DIR/example-api" ]]; then
            log_success "Example project created at $EXAMPLE_DIR/example-api"
            echo ""
            echo "To explore the example:"
            echo "  cd $EXAMPLE_DIR/example-api"
            echo "  npm install"
            echo "  npm run dev"
        fi
    fi
}

# Print summary
print_summary() {
    echo ""
    echo -e "${GREEN}${BOLD}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}${BOLD}           🎉 RepoForge Installation Complete! 🎉${NC}"
    echo -e "${GREEN}${BOLD}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${CYAN}${BOLD}Installation Summary:${NC}"
    echo -e "  ${GREEN}✓${NC} RepoForge CLI installed"
    echo -e "  ${GREEN}✓${NC} Standards repository cloned"
    echo -e "  ${GREEN}✓${NC} Configuration files created"
    echo -e "  ${GREEN}✓${NC} Shortcuts and aliases configured"
    
    if [[ -n "$ANTHROPIC_API_KEY" ]]; then
        echo -e "  ${GREEN}✓${NC} Anthropic API key configured"
    else
        echo -e "  ${YELLOW}⚠${NC} Anthropic API key not configured"
    fi
    
    echo ""
    echo -e "${CYAN}${BOLD}Quick Start Commands:${NC}"
    echo -e "  ${BOLD}rf init${NC}          - Create a new project interactively"
    echo -e "  ${BOLD}rfnew my-api${NC}    - Quick create with defaults"
    echo -e "  ${BOLD}rf help${NC}         - Show all available commands"
    echo -e "  ${BOLD}rf doctor${NC}       - Run diagnostics"
    
    echo ""
    echo -e "${CYAN}${BOLD}Next Steps:${NC}"
    echo "  1. Restart your terminal or run: source ~/.bashrc"
    
    if [[ -z "$ANTHROPIC_API_KEY" ]]; then
        echo "  2. Set your Anthropic API key:"
        echo "     export ANTHROPIC_API_KEY='your-key-here'"
    fi
    
    echo "  3. Create your first project:"
    echo "     rf init"
    
    echo ""
    echo -e "${CYAN}${BOLD}Resources:${NC}"
    echo "  📚 Documentation: https://docs.repoforge.dev"
    echo "  💬 Discord: https://discord.gg/repoforge"
    echo "  🐛 Issues: https://github.com/repoforge/cli/issues"
    echo "  📦 Standards: https://github.com/williamzujkowski/standards"
    
    echo ""
    echo -e "${MAGENTA}${BOLD}Thank you for installing RepoForge!${NC}"
    echo -e "${MAGENTA}Happy coding! 🚀${NC}"
    echo ""
}

# Error handler
handle_error() {
    log_error "An error occurred during installation"
    echo "Please check the logs at: $REPOFORGE_HOME/logs/install.log"
    exit 1
}

# Main installation flow
main() {
    # Set up error handling
    trap handle_error ERR
    
    # Clear screen and show banner
    clear
    print_banner
    
    # Start installation
    echo -e "${BOLD}Starting RepoForge installation...${NC}"
    echo ""
    
    # Run installation steps
    check_requirements
    create_directories
    clone_standards
    install_repoforge
    install_additional_tools
    configure_api_keys
    configure_repoforge
    create_shortcuts
    run_diagnostics
    create_example
    
    # Show summary
    print_summary
    
    # Save installation log
    {
        echo "RepoForge Installation Log"
        echo "Date: $(date)"
        echo "Version: $REPOFORGE_VERSION"
        echo "Home: $REPOFORGE_HOME"
        echo "Node: $NODE_VERSION"
        echo "npm: $NPM_VERSION"
        echo "Git: $GIT_VERSION"
    } > "$REPOFORGE_HOME/logs/install.log"
}

# Run main function
main "$@"