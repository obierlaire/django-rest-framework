#!/bin/bash

set -e
set -o pipefail

echo "Starting script..."

if [ ! -d "venv" ]; then
    echo "Creating virtual environment..." >&2
    virtualenv venv
fi

if [ ! -f "venv/bin/activate" ]; then
    echo "Error: Virtual environment setup failed." >&2
    exit 1
fi

echo "Activating virtual environment..."
source venv/bin/activate

echo "Installing dependencies..."
pip install --timeout=30 --disable-pip-version-check -r requirements.txt --break-system-packages

# Run the test command
command_to_test="python runtests.py"
echo "Running tests..."
set +e  # Allow capturing errors without immediate exit
output=$($command_to_test 2>&1)
exitcode=$?
set -e

if [ $exitcode -eq 0 ]; then
    echo "$output"  # Write success output to stdout
else
    echo "$output" >&2  # Write error output to stderr
fi

echo "Deactivating virtual environment..."
deactivate

# Exit with 0 to ensure n8n captures the output
exit 0
