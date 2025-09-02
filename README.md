# Wagtail.org Performance & Power Profiling

This repo contains one or more **scraped copies of wagtail.org** (each in its own folder). The goal is to run repeatable performance and power profiling with **[Sitespeed.io](https://www.sitespeed.io/)** and Firefox’s Gecko Profiler.


## 1) Prerequisites

- **Node.js & npm** (LTS recommended). Verify with:
  ```bash
  node -v
  npm -v
  ```
- **Firefox** installed (Sitespeed/Browsertime can profile with Firefox).  
- **Bash** shell to run `clean.sh` (Linux/macOS have it by default; on Windows use *Git Bash* or *WSL* - see below).


---

## 2) Install Sitespeed.io

Install globally with npm (works on Linux, macOS, Windows/WSL, and Windows Git Bash):

```bash
npm install -g sitespeed.io
```

Verify:

```bash
sitespeed.io --version
```

---

## 3) Make a best‑case copy with `clean.sh`

From the repository root (the folder that contains `clean.sh`), run:

**Linux/macOS:**
```bash
chmod +x clean.sh   # one-time
./clean.sh          # or: bash ./clean.sh
```

**Windows:**
- **Git Bash:**
  ```bash
  bash ./clean.sh
  ```
- **WSL (Ubuntu, etc.):** open WSL, `cd` to the repo, then:
  ```bash
  bash ./clean.sh
  ```

> If you see `permission denied` or `command not found` with `sudo`, use:  
> `sudo bash ./clean.sh` (Linux/macOS) or run from Git Bash/WSL without `sudo` on Windows.

This script produces a minimal, "best‑case" version of the site(s) by stripping heavy elements. See the script comments for exactly what it removes.

---

## 4) Choose a site copy & edit `urls.txt`

Each site copy has its own folder and includes a `urls.txt` file.

1. `cd` into the **specific folder** you want to test (e.g., `wagtail_org_bestcase/`).
2. Open `urls.txt` and add one URL per line, for the pages you want to measure. Example:
   ```
   https://example.com/
   https://example.com/blog/
   https://example.com/docs/
   ```

> Tip: Keep URLs consistent (same origin, protocol, and trailing slash style) to reduce noise between runs.

---

## 5) Run Sitespeed tests

From **inside the chosen site folder** (where `power.json` and `urls.txt` live), run:

```bash
sitespeed.io --config power.json -n 1 urls.txt
```

- `--config power.json` tells Sitespeed to use your profiling/power settings.  
- `-n 1` is the **number of runs** (analyses) per URL. Use a higher number (e.g., `-n 3` or `-n 5`) for more stable median results.

> You can run different folders independently (each site copy has its own `urls.txt`).

---

## 6) View the results

After a run completes, Sitespeed creates a `./sitespeed-result/` directory in the current folder. Inside you’ll find a timestamped subfolder with:

- `index.html` – the main interactive report (open this in your browser)
- `data/` – raw data, including Browsertime artifacts

Open the report by double‑clicking `index.html` .

---

## 7) CPU/Energy analysis via Gecko Profiler

If your `power.json` enables Firefox’s Gecko Profiler, each run includes a `geckoProfile.json` file (one per URL/run). To analyze:

1. Locate `geckoProfile.json` in the results (under `sitespeed-result/<timestamp>/data/...`).
2. Go to **https://profiler.firefox.com/**.
3. Drag‑and‑drop `geckoProfile.json` to load it.
4. Inspect threads, CPU usage, power metrics (if captured), and call stacks.

> If you don’t see a `geckoProfile.json`, confirm that Firefox was used and that Gecko profiling is enabled in `power.json`.

---

## 8) Example workflow (copy/paste)

```bash
# 1) from repo root
bash ./clean.sh

# 2) pick a site copy to test
cd ./wagtail_org_bestcase   # example folder name

# 3) edit the list of pages
nano urls.txt                # or use any editor

# 4) run profiling (3 runs per URL for stability)
sitespeed.io --config power.json -n 3 urls.txt

# 5) open the report
cd sitespeed-result/*
open index.html              # macOS
# or: xdg-open index.html    # Linux
# or double-click index.html in Explorer/Finder
```

---

## 9) What’s next?
- Compare different site copies by running the same `urls.txt` in each folder.
- Increase `-n` for more stable metrics.
- Explore the `index.html` waterfalls and CPU timelines; dig deeper with `geckoProfile.json` in Firefox Profiler.
