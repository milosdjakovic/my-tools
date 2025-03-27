#!/bin/bash

# Script to annotate PNG images with text below the image
# Uses ImageMagick v7 API

# Check if ImageMagick v7 is installed
if ! command -v magick &>/dev/null; then
  echo "Error: ImageMagick v7 is not installed."
  echo "Please install it with your package manager."
  exit 1
fi

# Check if required arguments are provided
if [ $# -lt 2 ]; then
  echo "Usage: $0 <path-to-png> \"<text>\""
  echo "Example: $0 image.png \"This is a caption\""
  exit 1
fi

# Get arguments
IMAGE_PATH="$1"
TEXT="$2"

# Check if the file exists and is a PNG
if [ ! -f "$IMAGE_PATH" ]; then
  echo "Error: File does not exist."
  exit 1
fi

if [[ "$IMAGE_PATH" != *.png ]]; then
  echo "Error: File is not a PNG."
  exit 1
fi

# Get the filename and directory
FILENAME=$(basename -- "$IMAGE_PATH")
DIRECTORY=$(dirname -- "$IMAGE_PATH")
FILENAME_NO_EXT="${FILENAME%.*}"

# Create output filename in the same directory as original
OUTPUT_FILE="${DIRECTORY}/${FILENAME_NO_EXT}_annotated.png"

# Get image dimensions
DIMENSIONS=$(magick identify -format "%w %h" "$IMAGE_PATH")
WIDTH=$(echo "$DIMENSIONS" | cut -d' ' -f1)
HEIGHT=$(echo "$DIMENSIONS" | cut -d' ' -f2)

# Define text parameters
FONT_SIZE=40
TEXT_PADDING=20
TEXT_HEIGHT=$((FONT_SIZE + 2 * TEXT_PADDING))

# Create new image with text below
magick \
  "$IMAGE_PATH" \
  -background black \
  -gravity south \
  -splice 0x${TEXT_HEIGHT} \
  -fill white \
  -font "Arial" \
  -weight bold \
  -pointsize ${FONT_SIZE} \
  -annotate +0+${TEXT_PADDING} "${TEXT}" \
  "$OUTPUT_FILE"

echo "Annotated image saved as $OUTPUT_FILE"

# Make the script executable
chmod +x "$0"
