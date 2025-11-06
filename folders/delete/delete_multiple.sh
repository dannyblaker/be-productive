find . \( -type d -name ".conda" -o -name ".venv" -o -name "node_modules" -o -name "__pycache__" -o -name ".pytest_cache" \) -exec rm -rf {} +
