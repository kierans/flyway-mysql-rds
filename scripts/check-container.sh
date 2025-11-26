#! /usr/bin/env bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 <container_name_or_id>"
  exit 1
fi

CONTAINER=$1
MAX_TRIES=5
RETRY_LIMIT=8
CHECK_INTERVAL=10

echo "Monitoring container: $CONTAINER"
echo "Max tries: $MAX_TRIES, Check interval: ${CHECK_INTERVAL}s"
echo "----------------------------------------"

for ((i=1; i<=MAX_TRIES; i++)); do
  echo "Attempt $i of $MAX_TRIES"

  # Check if container exists
  if ! docker inspect "$CONTAINER" &>/dev/null; then
    echo "Error: Container '$CONTAINER' not found"
    exit 1
  fi

  # Get container status
  STATUS=$(docker inspect --format='{{.State.Status}}' "$CONTAINER")
  EXIT_CODE=$(docker inspect --format='{{.State.ExitCode}}' "$CONTAINER")
  RESTART_COUNT=$(docker inspect --format='{{.RestartCount}}' "$CONTAINER")

  echo "Status: $STATUS | Exit Code: $EXIT_CODE | Restart Count: $RESTART_COUNT"

  # Check if container exited with status 0
  if [ "$STATUS" = "exited" ] && [ "$EXIT_CODE" -eq 0 ]; then
    echo "Success: Container exited with status code 0"
    exit 0
  fi

  # Check if container exited with non-zero status and retry count is 8
  if [ "$STATUS" = "exited" ] && [ "$EXIT_CODE" -ne 0 ] && [ "$RESTART_COUNT" -eq "$RETRY_LIMIT" ]; then
    echo "Error: Container exited with status code $EXIT_CODE and retry count is $RETRY_LIMIT"
    exit 1
  fi

  # Wait before next check (skip on last iteration)
  if [ $i -lt $MAX_TRIES ]; then
    echo "Waiting ${CHECK_INTERVAL} seconds..."
    sleep $CHECK_INTERVAL
    echo ""
  fi
done

echo "Max tries reached without meeting exit conditions"
exit 1
