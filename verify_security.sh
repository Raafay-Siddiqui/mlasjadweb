#!/bin/bash

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  🔒 Security Verification - Al-Baqi Academy                  ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

PASS=0
FAIL=0

# Check 1: .env in .gitignore
echo "📋 Check 1: Verifying .env is in .gitignore..."
if grep -q "^\.env$" .gitignore 2>/dev/null; then
    echo "   ✅ PASS: .env is in .gitignore"
    ((PASS++))
else
    echo "   ❌ FAIL: .env NOT in .gitignore - ADD IT NOW!"
    ((FAIL++))
fi
echo ""

# Check 2: .env not tracked by git
echo "📋 Check 2: Verifying .env is not tracked by git..."
if git ls-files 2>/dev/null | grep -q "^\.env$"; then
    echo "   ❌ FAIL: .env is tracked by git - REMOVE IT!"
    echo "   Run: git rm --cached .env"
    ((FAIL++))
else
    echo "   ✅ PASS: .env is not tracked by git"
    ((PASS++))
fi
echo ""

# Check 3: .env file exists
echo "📋 Check 3: Checking if .env file exists..."
if [ -f .env ]; then
    echo "   ✅ PASS: .env file exists"
    ((PASS++))

    # Check 3a: .env permissions
    echo ""
    echo "📋 Check 3a: Checking .env file permissions..."
    if [ "$(uname)" = "Darwin" ]; then
        PERMS=$(stat -f "%A" .env 2>/dev/null)
    else
        PERMS=$(stat -c "%a" .env 2>/dev/null)
    fi

    if [ "$PERMS" = "600" ] || [ "$PERMS" = "400" ]; then
        echo "   ✅ PASS: .env has secure permissions ($PERMS)"
        ((PASS++))
    else
        echo "   ⚠️  WARNING: .env permissions: $PERMS (recommended: 600)"
        echo "   Run: chmod 600 .env"
        ((FAIL++))
    fi
else
    echo "   ⚠️  WARNING: .env file does not exist yet"
    echo "   Create it from .env.example"
fi
echo ""

# Check 4: .env.example exists (safe to commit)
echo "📋 Check 4: Verifying .env.example exists..."
if [ -f .env.example ]; then
    echo "   ✅ PASS: .env.example exists (safe to commit)"
    ((PASS++))
else
    echo "   ⚠️  WARNING: .env.example not found"
fi
echo ""

# Check 5: No hardcoded passwords in code
echo "📋 Check 5: Scanning for hardcoded passwords in code..."
if grep -r "password.*=.*['\"]" . --exclude-dir=.git --exclude-dir=venv --exclude="*.md" --exclude=".env*" --exclude="*.sh" -q 2>/dev/null; then
    echo "   ⚠️  WARNING: Potential hardcoded passwords found"
    echo "   Files:"
    grep -r "password.*=.*['\"]" . --exclude-dir=.git --exclude-dir=venv --exclude="*.md" --exclude=".env*" --exclude="*.sh" -l 2>/dev/null | head -5
else
    echo "   ✅ PASS: No hardcoded passwords found"
    ((PASS++))
fi
echo ""

# Check 6: .env in git history
echo "📋 Check 6: Checking .env was never committed to git..."
if git log --all --full-history -- .env 2>/dev/null | grep -q "commit"; then
    echo "   ❌ FAIL: .env found in git history!"
    echo "   You need to remove it from history"
    ((FAIL++))
else
    echo "   ✅ PASS: .env never committed to git"
    ((PASS++))
fi
echo ""

# Check 7: Email configuration
echo "📋 Check 7: Checking email configuration..."
if [ -f .env ]; then
    if grep -q "MAIL_SERVER=" .env && grep -q "MAIL_USERNAME=" .env && grep -q "MAIL_PASSWORD=" .env; then
        echo "   ✅ PASS: Email configuration present in .env"
        ((PASS++))
    else
        echo "   ⚠️  WARNING: Email configuration incomplete in .env"
    fi
fi
echo ""

# Summary
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  📊 SECURITY VERIFICATION SUMMARY                            ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "   ✅ Passed: $PASS checks"
echo "   ❌ Failed: $FAIL checks"
echo ""

if [ $FAIL -eq 0 ]; then
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║  🎉 ALL SECURITY CHECKS PASSED!                             ║"
    echo "║  Your credentials are SECURE and ready for deployment!      ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    exit 0
else
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║  ⚠️  SECURITY ISSUES FOUND                                   ║"
    echo "║  Please fix the issues above before deploying!              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    exit 1
fi
