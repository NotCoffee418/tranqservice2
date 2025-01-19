#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Function to build for a specific platform
build_platform() {
  platform=$1
  mode=$2

  echo "Building for $platform in $mode mode..."

  if [[ "$platform" == "windows" ]]; then
    flutter build windows --dart-define=MODE=$mode
    output_dir="build/windows/runner/Release"
    exe_file="$output_dir/app.exe"

    # Check if the output file exists
    if [[ ! -f "$exe_file" ]]; then
      echo "Error: Build failed. $exe_file not found."
      exit 1
    fi

    # Rename the output executable
    mv "$exe_file" "$output_dir/app_${mode}.exe"
    echo "Built $output_dir/app_${mode}.exe"
  elif [[ "$platform" == "linux" ]]; then
    flutter build linux --dart-define=MODE=$mode
    output_dir="build/linux/x64/release/bundle"
    binary_file="$output_dir/app"

    # Check if the output file exists
    if [[ ! -f "$binary_file" ]]; then
      echo "Error: Build failed. $binary_file not found."
      exit 1
    fi

    # Rename the output binary
    mv "$binary_file" "$output_dir/app_${mode}"
    echo "Built $output_dir/app_${mode}"
  else
    echo "Unsupported platform: $platform"
    exit 1
  fi
}

# Clean previous builds
echo "Cleaning previous builds..."
if [ -d "build" ]; then
  echo "Deleting build directory..."
  rm -rf build || {
    echo "Failed to delete build directory. Please check permissions or close any programs using it."
    exit 1
  }
fi

# Build for both platforms and modes
build_platform windows ui
build_platform windows service
build_platform linux ui
build_platform linux service

echo "All builds completed successfully!"
