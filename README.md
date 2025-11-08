Coderweb - Discord Bot Host (Render-ready, fixed)

This build fixes a syntax error caused by template literals in server.js and avoids using backticks for the HTML generation.

Setup:
1. Push this folder to GitHub.
2. Go to Render.com → New Web Service → Connect GitHub repo.
3. Render will run `npm install` and start `node server.js`.
4. Open the web app URL to upload and start bots (Python or Node.js).

Notes:
- Public access (no password). Be careful exposing this to the public internet.
- Shell executes server-side commands — do not allow untrusted users access.
