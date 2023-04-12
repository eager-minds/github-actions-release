#!/bin/bash

if [ -z "$RELEASE_VERSION" ]; then
  echo "Please provide the version number as an argument."
  exit 1
fi

if [ ! -f "$CHANGELOG_PATH" ]; then
  echo "$CHANGELOG_PATH file not found in the current directory."
  exit 1
fi

START_LINE=$(grep -n "^## \[$RELEASE_VERSION\]" "$CHANGELOG_PATH" | cut -d : -f 1)

if [ -z "$START_LINE" ]; then
  echo "The provided version \"$RELEASE_VERSION\" is not found in the CHANGELOG file: $CHANGELOG_PATH"
  exit 1
fi

NEXT_VERSION_LINE=$(tail -n +$((START_LINE + 1)) "$CHANGELOG_PATH" | grep -n -m 1 "^## \[" | cut -d : -f 1)

if [ -z "$NEXT_VERSION_LINE" ]; then
  TAG_MESSAGE=$(tail -n +"$START_LINE" "$CHANGELOG_PATH")
else
  TAG_MESSAGE=$(tail -n +"$START_LINE" "$CHANGELOG_PATH" | head -n "$((NEXT_VERSION_LINE))")
fi

echo "$TAG_MESSAGE"
