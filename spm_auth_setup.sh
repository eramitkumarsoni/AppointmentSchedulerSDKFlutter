#!/bin/bash

# ============================================================================
# SPM Authentication Setup Script
# ============================================================================
# This script configures authentication for the Appointment Scheduler SPM package
# from the private Cadmium Git repository.
#
# Usage:
#   ./spm_auth_setup.sh
#
# What it does:
#   1. Prompts for credentials (or uses team credentials if provided)
#   2. Creates/updates ~/.netrc file with Git authentication
#   3. Saves credentials locally for future updates
#   4. Validates the setup
# ============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
GIT_SERVER="git.gocadmium.dev"
GIT_REPO_PATH="mobile-app-group/appointmentschedulersdkflutter"
CONFIG_FILE=".spm_credentials"
NETRC_FILE="$HOME/.netrc"

# Function to print colored output
print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

# Clear screen for clean output
clear

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║     Appointment Scheduler SPM - Authentication Setup       ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Check if running in correct directory
if [ ! -f "Package.swift" ]; then
    print_warning "This script should be run from the SPM package directory"
    print_warning "It appears you're not in the package directory"
    echo ""
    read -p "Continue anyway? (y/n): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check if credentials already exist
if [ -f "$CONFIG_FILE" ]; then
    print_warning "Credentials already configured in $CONFIG_FILE"
    echo ""
    read -p "Do you want to reconfigure? (y/n): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_step "Using existing credentials..."
        source "$CONFIG_FILE"
        SKIP_INPUT=true
    fi
fi

if [ -z "$SKIP_INPUT" ]; then
    echo ""
    print_step "Authentication Setup Options:"
    echo ""
    echo "  1. Use team/shared credentials (recommended)"
    echo "  2. Use personal credentials"
    echo ""
    read -p "Select option (1 or 2): " -n 1 -r AUTH_OPTION
    echo ""
    echo ""

    if [ "$AUTH_OPTION" == "1" ]; then
        # Team credentials option
        print_step "Using team credentials..."
        echo ""
        echo "Please contact your team lead for the shared credentials."
        echo ""
        
        # Check if there's a team credentials file provided
        if [ -f "team_credentials.sh" ]; then
            print_success "Found team_credentials.sh - loading..."
            source team_credentials.sh
        else
            read -p "Enter Git username: " GIT_USERNAME
            read -sp "Enter Git access token: " GIT_TOKEN
            echo ""
        fi
    else
        # Personal credentials option
        print_step "Using personal credentials..."
        echo ""
        echo "You'll need a personal access token from ${GIT_SERVER}"
        echo ""
        echo "To create one:"
        echo "  1. Go to https://${GIT_SERVER}"
        echo "  2. Navigate to Settings → Access Tokens"
        echo "  3. Create a token with 'read_repository' permission"
        echo "  4. Copy the token"
        echo ""
        
        read -p "Enter your Git username: " GIT_USERNAME
        read -sp "Enter your Git access token: " GIT_TOKEN
        echo ""
    fi

    # Validate inputs
    if [ -z "$GIT_USERNAME" ] || [ -z "$GIT_TOKEN" ]; then
        print_error "Username and token are required!"
        exit 1
    fi

    # Save credentials to local config file
    print_step "Saving credentials to $CONFIG_FILE..."
    cat > "$CONFIG_FILE" <<EOF
# SPM Authentication Credentials
# This file is auto-generated and should not be committed to Git
GIT_USERNAME="$GIT_USERNAME"
GIT_TOKEN="$GIT_TOKEN"
GIT_SERVER="$GIT_SERVER"
EOF

    chmod 600 "$CONFIG_FILE"
    print_success "Credentials saved locally"
    echo ""
fi

# Load credentials if we skipped input
if [ -n "$SKIP_INPUT" ]; then
    source "$CONFIG_FILE"
fi

# Configure .netrc file
print_step "Configuring ~/.netrc for Git authentication..."

# Backup existing .netrc if it exists
if [ -f "$NETRC_FILE" ]; then
    if ! grep -q "machine ${GIT_SERVER}" "$NETRC_FILE"; then
        print_warning "Backing up existing .netrc to .netrc.backup"
        cp "$NETRC_FILE" "${NETRC_FILE}.backup"
    fi
fi

# Remove existing entry for this server if it exists
if [ -f "$NETRC_FILE" ]; then
    # Create temp file without the git.gocadmium.dev entry
    grep -v "machine ${GIT_SERVER}" "$NETRC_FILE" > "${NETRC_FILE}.tmp" 2>/dev/null || true
    grep -v "login.*${GIT_USERNAME}" "${NETRC_FILE}.tmp" > "${NETRC_FILE}.tmp2" 2>/dev/null || true
    grep -v "password.*" "${NETRC_FILE}.tmp2" > "${NETRC_FILE}.tmp3" 2>/dev/null || true
    mv "${NETRC_FILE}.tmp3" "${NETRC_FILE}.tmp" 2>/dev/null || true
    rm -f "${NETRC_FILE}.tmp2" 2>/dev/null || true
fi

# Create or update .netrc
touch "$NETRC_FILE"
chmod 600 "$NETRC_FILE"

# Add our entry
cat >> "$NETRC_FILE" <<EOF

# Cadmium Git Server (AppointmentSchedulerSPM)
machine ${GIT_SERVER}
login ${GIT_USERNAME}
password ${GIT_TOKEN}
EOF

print_success ".netrc configured"
echo ""

# Verify .netrc permissions
NETRC_PERMS=$(stat -f "%OLp" "$NETRC_FILE" 2>/dev/null || stat -c "%a" "$NETRC_FILE" 2>/dev/null)
if [ "$NETRC_PERMS" != "600" ]; then
    chmod 600 "$NETRC_FILE"
    print_warning "Fixed .netrc permissions to 600"
fi

# Test the connection
print_step "Testing Git connection..."
echo ""

if git ls-remote "https://${GIT_SERVER}/${GIT_REPO_PATH}.git" &> /dev/null; then
    print_success "Authentication successful! ✨"
    echo ""
    print_success "Repository is accessible"
else
    print_error "Authentication failed!"
    echo ""
    echo "Possible issues:"
    echo "  - Invalid username or token"
    echo "  - Token doesn't have repository access"
    echo "  - Network connectivity issues"
    echo ""
    echo "Please verify your credentials and try again."
    exit 1
fi

# Add to .gitignore
print_step "Ensuring credentials are not tracked by Git..."

if [ -f ".gitignore" ]; then
    if ! grep -q "$CONFIG_FILE" ".gitignore"; then
        echo "$CONFIG_FILE" >> .gitignore
        print_success "Added $CONFIG_FILE to .gitignore"
    fi
else
    echo "$CONFIG_FILE" > .gitignore
    print_success "Created .gitignore with $CONFIG_FILE"
fi

if [ -f ".gitignore" ]; then
    if ! grep -q "team_credentials.sh" ".gitignore"; then
        echo "team_credentials.sh" >> .gitignore
    fi
fi

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                    Setup Complete! 🎉                       ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "✅ Git authentication configured"
echo "✅ Credentials saved to $CONFIG_FILE"
echo "✅ .netrc file updated"
echo "✅ Connection tested successfully"
echo ""
echo "You can now add this package in Xcode:"
echo "  File → Add Package Dependencies"
echo "  URL: https://${GIT_SERVER}/${GIT_REPO_PATH}"
echo ""
echo "The authentication will work automatically!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🔒 Security Notes:"
echo "  • $CONFIG_FILE is gitignored (won't be committed)"
echo "  • .netrc has 600 permissions (only you can read)"
echo "  • Never share your credentials or commit them to Git"
echo ""
echo "🔄 To update credentials later:"
echo "  Just run this script again: ./spm_auth_setup.sh"
echo ""
