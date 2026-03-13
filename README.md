# Apple Silicon LTX-Video Setup

This document captures both the lightweight `mlx-video` Python CLI and the packaged `ltx-video-mac` experience so you can compare Metal/MLX workflows on Apple Silicon.

## Prerequisites
- **Apple Silicon macOS 14 (Sonoma) or later**: LTX-2 via MLX is only distributed for Apple Silicon and requires the MLX frameworks that ship with macOS 14 and above; the app can still run on Sonoma but the latest Metal 4 features need macOS 26+.
  citeturn3search2turn4search0
- **Homebrew** (for tooling) and **Xcode Command Line Tools** (for dependencies like `git`, `make`, and packaging native apps).
- **Python 3.12+** (virtualenv or `pyenv`) to isolate `mlx-video` installs; the package explicitly supports 3.12+ on Apple Silicon.
  citeturn2search2
- **FFmpeg** for muxing video/audio output and the `mlx-video-with-audio` sample scripts; install it via `brew install ffmpeg` so the CLI can produce `.mp4` + `.wav` artifacts.
  citeturn2search2
- **Git** to clone repos (native app, CLI examples) and track updates.
- **Metal Family 4 support** is optional but recommended for the smoothest results; verify with `system_profiler SPDisplaysDataType` and look for “Metal Family 4” if you are targeting macOS 26.
  citeturn4search1
- **MLX cache customization**: set `MLX_CACHE_DIR` (for model/artifact downloads) and `HF_HOME` (for Hugging Face cache) if you want them outside `~/Library/Caches` or the default `~/.cache`.
  citeturn3search1

## CLI path (mlx-video)

### Install + model
1. Create/activate a virtualenv that targets move-to-latest Python (3.12+):
   ```bash
python3.12 -m venv .venv
source .venv/bin/activate
pip install mlx-video-with-audio
```
   citeturn2search2
3. The package defaults to the `notapalindrome/ltx2-mlx-av` (≈42 GB) LTX-2 model when you first run it; cache and downloads live under `MLX_CACHE_DIR` or `HF_HOME`.
   citeturn1search4

### Sample render (audio + video)
Run the provided helper script that handles environment variables and runs the generator:
```bash
./run_mlx_video.sh --prompt "Crisp sci-fi timelapse with calm narration" \
  --output-path ~/ltx-output.mp4
```
Alternatively, run the module directly:
```bash
source .venv/bin/activate
python -m mlx_video.generate_av --prompt "Crisp sci-fi timelapse"
```
The generator prints Metal diagnostics (e.g., `Metal Family 4 hardware`), confirming hardware acceleration.
 citeturn2search2

### Metal/MLX validation
- Run `system_profiler SPDisplaysDataType | grep -A2 "Metal"` to see the Metal Family and driver version; macOS 26 or later advertises Metal Family 4 for supported chips and ILs.
  citeturn4search1
- Inspect the CLI log for the `mlx-video` output that mentions “Metal” or “MLX”; the package prints the same Metal/Apple Silicon tokens that confirm the runtime picked up the hardware acceleration.
  citeturn2search2

### Environment tweaks
- Pin cache roots so you can keep the 42 GB model off a small boot drive: `export MLX_CACHE_DIR=~/Models/mlx-cache` and `export HF_HOME=~/Models/huggingface` before running `mlx-video` again.
  citeturn3search1
- If you hit dependency errors, reinstall the wheel via `pip install --force-reinstall mlx-video-with-audio` and rerun; the package bundles optimized kernels for MLX/Metal 4.
  citeturn2search2

## Native macOS app (ltx-video-mac)

### Get the app
- Visit the `ltx-video-mac` landing page and download the latest release ZIP or `.dmg`. It bundles the LTX-2 (≈42 GB) weights and MLX tooling so the first launch pulls in MLX, Metal, and audio frameworks automatically.
  citeturn2search0
- If you need to rebuild the app, clone `https://github.com/james-see/ltx-video-mac`, install the Xcode Command Line Tools, and run the included `build.sh` (the repo wraps the same Python+Metal stack as the CLI).
  citeturn2search0

### First launch & verification
- On first run, the app auto-detects the bundled LTX-2 runtime plus the MLX executables; allow it to download any missing caches (it stores them in `~/Library/Caches/ltx-video-mac` by default).
  citeturn2search0
- Check “Hardware > Metal” in the app’s status overlay to confirm Metal 4 is active; you can also open Console.app and filter for the `lxvideo` timeout logs if you need deeper traces.
  citeturn2search0
- Use the built-in audio preset (ElevenLabs/TTS voice, local audio, or `MLX Audio` fallback) to confirm the packaged audio pipeline runs alongside the video export; the UI indicates “MLX Audio ready” once it sees a Metal-ready GPU.
  citeturn2search0

## Testing & verification
- **mlx-video CLI**: run the sample prompt above, ensure `~/ltx-output/` contains `.mp4` and `.wav` files, and confirm the CLI log references Metal/MLX to prove the hardware path was used.
- **ltx-video-mac**: launch the app after the CLI run, load the same prompt or preset, click “Render,” and observe that it uploads to the same cache while the UI reports “Metal” and “Audio ready.”

## Notes
- Keep your Python virtualenv narrow and reinstall `mlx-video-with-audio` if macOS updates break the Metal kernels; the package maintains release notes on GitHub.
- If you want reproducible scripts, wrap the CLI call in a shell script (set `MLX_CACHE_DIR`, `HF_HOME`, and `PYTHONPATH` as needed) and pin `mlx-video-with-audio==0.5.0` (version number to copy from the package docs).

## References
- `mlx-video-with-audio` PyPI (install instructions, LTX-2 defaults, Metal diagnostics). citeturn2search2
- `ltx-video-mac` landing page (native app bundling LTX-2, MLX, audio). citeturn2search0
- `MLX` Build & Install docs (macOS 14, Apple Silicon requirement, cache env). citeturn3search2turn3search1
- System Metal support page + sample `system_profiler` command (Metal 4, Apple Silicon). citeturn4search0turn4search1
