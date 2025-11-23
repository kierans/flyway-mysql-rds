#!/usr/bin/env bash

# Function to check if a command exists
checkDependency() {
  if ! command -v "$1" &> /dev/null; then
    echo "Error: $1 is not installed. Please install $1 and try again."
    exit 1
  fi
}

# Check for required dependencies
checkDependency curl
checkDependency jq
checkDependency sponge

# Initialize variables
url='https://hub.docker.com/v2/namespaces/flyway/repositories/flyway/tags?page_size=100&page=1'
counter=1
tagsFile="$(pwd)/tags.json"
expectedCount=0

set -e

# Initialize tags.json as an empty array
echo "[]" > "$tagsFile"

# Create temp directory for response files
tempDir=$(mktemp -d)
trap "rm -rf $tempDir" EXIT

echo "Starting to fetch tags..."

# Loop until next is null
while [ -n "$url" ] && [ "$url" != "null" ]; do
  echo "Fetching page $counter: $url"

  # Save response to temp file
  tempFile="$tempDir/response-page-${counter}.json"
  curl -s "$url" -o "$tempFile"

  # Check if curl was successful
  if [ $? -ne 0 ]; then
      echo "Error: Failed to fetch $url"
      exit 1
  fi

  # On first response, capture the expected count
  if [ $counter -eq 1 ] ; then
    expectedCount=$(jq -r '.count' "$tempFile")
  fi

  # Extract results and append to tags.json
  results=$(jq '.results' "$tempFile")

  # Merge results into tags.json
  jq --argjson new_results "$results" '. + $new_results' "$tagsFile" | sponge "$tagsFile"

  # Get next URL
  url=$(jq -r '.next' "$tempFile")

  # Increment counter
  counter=$((counter + 1))
done

echo "Done! Total pages fetched: $counter"

cat "$tagsFile" | jq | sponge "$tagsFile"
echo "Results saved to: $tagsFile"

totalTags=$(jq 'length' "$tagsFile")
echo "Total tags collected: $totalTags"

# Verify count matches expected
if [ "$totalTags" -eq "$expectedCount" ]; then
  echo "✓ Success: Collected tag count matches expected count ($expectedCount)"
else
  echo "✗ Warning: Collected $totalTags tags but expected $expectedCount"
  exit 1
fi
