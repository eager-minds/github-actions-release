#!/bin/sh

echo "env.TAG_NAME: $TAG_NAME"
echo "env.CHANGELOG_PATH: $CHANGELOG_PATH"

if [ -z "$TAG_NAME" ]; then
echo "Please provide the version number as an argument."
exit 1
fi

if [ ! -f "$CHANGELOG_PATH" ]; then
echo "$CHANGELOG_PATH file not found in the current directory."
exit 1
fi

START_LINE=$(grep -n "^## \[$TAG_NAME\]" "$CHANGELOG_PATH" | cut -d : -f 1)

if [ -z "$START_LINE" ]; then
echo "The provided version \"$TAG_NAME\" is not found in the CHANGELOG file: $CHANGELOG_PATH"
exit 1
fi

NEXT_VERSION_LINE=$(tail -n +$((START_LINE + 1)) "$CHANGELOG_PATH" | grep -n -m 1 "^## \[" | cut -d : -f 1)

if [ -z "$NEXT_VERSION_LINE" ]; then
TAG_MESSAGE=$(tail -n +"$START_LINE" "$CHANGELOG_PATH")
else
TAG_MESSAGE=$(tail -n "$START_LINE" "$CHANGELOG_PATH" | head -n "$((NEXT_VERSION_LINE))")
fi

hub release create -m "${TAG_MESSAGE}" "$TAG_NAME"