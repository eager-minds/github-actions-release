#!/bin/bash

inputs_release_version_format="[0-9]+\\.[0-9]+\\.[0-9]+"
inputs_changelog_path="CHANGELOG.md"
env_CHANGELOG_RELEASE_VERSION_FORMAT="^## \\[${inputs_release_version_format}\\]"

echo "${env_CHANGELOG_RELEASE_VERSION_FORMAT}"

changelogSubtitles=$(grep -Eo "$env_CHANGELOG_RELEASE_VERSION_FORMAT" "$inputs_changelog_path")
mapfile -t versions < <(echo "$changelogSubtitles" | grep -Eo "$inputs_release_version_format")
versions=()
while IFS='' read -r line; do versions+=("$line"); done < <(echo "$changelogSubtitles" | grep -Eo "$inputs_release_version_format")
echo "${versions[68]}"