#!/bin/bash

# Script to update all references after renaming repository

OLD_NAME="Image-Cropper"
NEW_NAME="DocumentScanner-SDK"

echo "🔄 Updating all references from $OLD_NAME to $NEW_NAME..."

# Function to replace in file
replace_in_file() {
    local file=$1
    if [ -f "$file" ]; then
        sed -i.bak "s/$OLD_NAME/$NEW_NAME/g" "$file" && rm "${file}.bak"
        echo "✅ Updated: $file"
    fi
}

# Update all markdown files
echo "📝 Updating markdown files..."
find . -type f -name "*.md" ! -path "*/node_modules/*" ! -path "*/.git/*" | while read file; do
    replace_in_file "$file"
done

# Update YAML files
echo "📝 Updating YAML files..."
find . -type f \( -name "*.yaml" -o -name "*.yml" \) ! -path "*/node_modules/*" ! -path "*/.git/*" | while read file; do
    replace_in_file "$file"
done

# Update package.json files
echo "📦 Updating package.json files..."
find . -type f -name "package.json" ! -path "*/node_modules/*" | while read file; do
    replace_in_file "$file"
done

# Update pubspec.yaml
echo "📦 Updating pubspec.yaml..."
find . -type f -name "pubspec.yaml" | while read file; do
    replace_in_file "$file"
done

# Update gradle files
echo "🐘 Updating gradle files..."
find . -type f -name "build.gradle" | while read file; do
    replace_in_file "$file"
done

echo ""
echo "✅ All references updated!"
echo ""
echo "Next steps:"
echo "1. Review the changes: git diff"
echo "2. Commit: git add -A && git commit -m 'chore: update references to new repo name'"
echo "3. Push: git push"
