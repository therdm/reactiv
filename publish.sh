#!/bin/bash

# Reactiv v1.1.2 Publication Script
# This script helps automate the publication process

set -e  # Exit on error

echo "=========================================="
echo "   Reactiv v1.1.2 Publication Script"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if we're in the correct directory
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}Error: pubspec.yaml not found. Are you in the project root?${NC}"
    exit 1
fi

# Verify version in pubspec.yaml
VERSION=$(grep "^version:" pubspec.yaml | awk '{print $2}')
if [ "$VERSION" != "1.1.2" ]; then
    echo -e "${RED}Error: Version in pubspec.yaml is $VERSION, expected 1.1.2${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Version check passed: $VERSION${NC}"
echo ""

# Step 1: Run tests
echo "Step 1: Running tests..."
echo "========================"
flutter test
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed${NC}"
else
    echo -e "${RED}✗ Tests failed. Please fix before publishing.${NC}"
    exit 1
fi
echo ""

# Step 2: Format code
echo "Step 2: Formatting code..."
echo "=========================="
dart format lib/ test/ example/lib/
echo -e "${GREEN}✓ Code formatted${NC}"
echo ""

# Step 3: Analyze code
echo "Step 3: Analyzing code..."
echo "========================="
flutter analyze
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ No analysis issues${NC}"
else
    echo -e "${YELLOW}⚠ Analysis warnings found. Review before publishing.${NC}"
fi
echo ""

# Step 4: Dry run
echo "Step 4: Running dry run..."
echo "=========================="
flutter pub publish --dry-run
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Dry run successful${NC}"
else
    echo -e "${RED}✗ Dry run failed. Please fix issues.${NC}"
    exit 1
fi
echo ""

# Step 5: Confirm publication
echo "=========================================="
echo "   Ready to Publish v1.1.2"
echo "=========================================="
echo ""
echo "Pre-publication checklist:"
echo "  ✓ Tests passed"
echo "  ✓ Code formatted"
echo "  ✓ Code analyzed"
echo "  ✓ Dry run successful"
echo ""
echo -e "${YELLOW}Are you ready to publish to pub.dev? (yes/no)${NC}"
read -r response

if [ "$response" != "yes" ]; then
    echo "Publication cancelled."
    exit 0
fi

# Step 6: Publish
echo ""
echo "Step 6: Publishing to pub.dev..."
echo "================================="
flutter pub publish

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo -e "${GREEN}   Publication Successful! 🎉${NC}"
    echo "=========================================="
    echo ""
    echo "Next steps:"
    echo "1. Tag the release:"
    echo "   git tag -a v1.1.2 -m 'Release version 1.1.2'"
    echo "   git push origin v1.1.2"
    echo ""
    echo "2. Create GitHub release:"
    echo "   https://github.com/therdm/reactiv/releases/new"
    echo ""
    echo "3. Verify on pub.dev:"
    echo "   https://pub.dev/packages/reactiv"
    echo ""
else
    echo -e "${RED}✗ Publication failed. Check errors above.${NC}"
    exit 1
fi
