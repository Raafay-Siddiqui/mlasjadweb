#!/bin/bash
# Upload course files to VPS
# This script safely uploads course content without affecting existing courses or data

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}=== Upload Course Files to VPS ===${NC}\n"

# Configuration - UPDATE THESE VALUES
VPS_USER="your_username"
VPS_HOST="your_vps_ip"
VPS_PATH="/path/to/web1"

# Local courses directory
LOCAL_COURSES="./static/courses"

# Check if courses directory exists
if [ ! -d "$LOCAL_COURSES" ]; then
    echo -e "${YELLOW}No courses directory found at $LOCAL_COURSES${NC}"
    exit 1
fi

# Show available courses
echo -e "${BLUE}Local courses to upload:${NC}"
course_count=0
for dir in $LOCAL_COURSES/*/; do
    if [ -d "$dir" ]; then
        course_name=$(basename "$dir")
        size=$(du -sh "$dir" 2>/dev/null | cut -f1)
        echo "  → $course_name ($size)"
        ((course_count++))
    fi
done

if [ $course_count -eq 0 ]; then
    echo "  (no courses found)"
    exit 0
fi

# Calculate total size
total_size=$(du -sh "$LOCAL_COURSES" 2>/dev/null | cut -f1)
echo -e "\n${BLUE}Total size: $total_size${NC}"

echo ""
echo -e "${YELLOW}⚠️  This will:${NC}"
echo "   ✓ Upload all courses to VPS"
echo "   ✓ Preserve existing courses on VPS"
echo "   ✓ Skip unchanged files (faster)"
echo "   ✓ Not affect database or user data"
echo ""

# Dry run option
read -p "Do dry-run first to see what will be uploaded? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "\n${BLUE}Dry run (no files will be transferred):${NC}"
    rsync -avzn --progress \
        --exclude=".DS_Store" \
        --exclude="*.tmp" \
        --exclude=".gitkeep" \
        $LOCAL_COURSES/ \
        $VPS_USER@$VPS_HOST:$VPS_PATH/static/courses/
    echo ""
fi

read -p "Proceed with actual upload? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Upload cancelled."
    exit 1
fi

echo -e "\n${GREEN}Uploading course files...${NC}"

# Upload with rsync (preserves existing files, only adds new/changed ones)
rsync -avz --progress \
    --exclude=".DS_Store" \
    --exclude="*.tmp" \
    --exclude=".gitkeep" \
    $LOCAL_COURSES/ \
    $VPS_USER@$VPS_HOST:$VPS_PATH/static/courses/

echo -e "\n${GREEN}✓ Upload complete!${NC}"
echo -e "${YELLOW}Summary:${NC}"
echo "   • Courses uploaded: $course_count"
echo "   • Total size: $total_size"
echo "   • Existing courses: preserved"
echo "   • User data: unaffected"
