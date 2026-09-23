#!/bin/bash
# Helper script to run mlx-video with optimized cache paths

# Set default cache directories if not already set
export MLX_CACHE_DIR="${MLX_CACHE_DIR:-$HOME/Models/mlx-cache}"
export HF_HOME="${HF_HOME:-$HOME/Models/huggingface}"
export HF_TOKEN="${HF_TOKEN:-}" # Set this to your Hugging Face token

# Ensure directories exist
mkdir -p "$MLX_CACHE_DIR"
mkdir -p "$HF_HOME"

# Check if .venv exists
if [ ! -d ".venv" ]; then
    echo "Error: .venv not found. Please run 'python3.12 -m venv .venv && source .venv/bin/activate && pip install mlx-video-with-audio' first."
    exit 1
fi

# Run the command
source .venv/bin/activate
echo "Starting mlx-video.generate_av with MLX_CACHE_DIR=$MLX_CACHE_DIR"
python -m mlx_video.generate_av "$@"
