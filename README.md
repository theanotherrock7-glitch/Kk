Coderweb - Discord Bot Host (Render-ready)

Setup:
1. Push this folder to GitHub.
2. Go to Render.com → New Web Service → Connect GitHub repo.
3. Render auto-detects `render.yaml` → Deploy.
4. Visit the web app URL to upload and start bots (Python or Node.js).

Features:
- Upload bot ZIPs and start/stop/restart them.
- Live logs for each bot.
- Web shell to run commands on server.
- No password required (public access).

Notes:
- Ensure your bot ZIP has a runnable entry: `main.py` or `index.js`/`main.js`.
- Python dependencies will be auto-installed if `requirements.txt` exists.
- Node dependencies will be auto-installed if `package.json` exists.
