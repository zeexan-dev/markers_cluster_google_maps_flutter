#!/bin/bash

# Format the Dart code
dart format .

# Run the dry-run to check for issues
dart pub publish --dry-run

# Prompt the user for input
read -p "Do you want to continue with the publish? (y/n): " choice

# Check the user's input and decide what to do next
if [ "$choice" = "y" ]; then
  # Ask for the version number
  read -p "Enter the version number (e.g., 0.1.0+1): " version

  # Create a Git tag with the version number
  git tag v$version

  # Push the tag to the origin
  git push origin v$version

  # Proceed with the actual publish
  dart pub publish --force
else
  # Stop the script
  echo "Publishing aborted."
  exit 0
fi
