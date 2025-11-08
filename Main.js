/*
Single-file self-hosted Discord-bot host (Node.js)

How it works:
- Run this server on a VPS/PC/old Android that can stay online 24/7.
- Open the UI in a browser (can be Safari on iOS) to upload a bot as a .zip file.
- The server extracts the zip into ./bots/<botId>, and can start/stop the bot with Python.

Security note: THIS IS A SIMPLE DEMO. Do NOT expose this to the public internet without
strong authentication and HTTPS. Keep bot tokens secret. Run behind a firewall.

Requirements on the host machine:
- node >= 16
- python3 (if your bot is Python)
- npm install express multer adm-zip uuid cors

Start:
  ADMIN_PASS=yourpassword node mini-bot-host.js

Upload a zip that contains your bot files (e.g., main.py, requirements.txt, config.json).

*/

const express = require('express');
const multer = require('multer');
const AdmZip = require('adm-zip');
const fs = require('fs');
const path = require('path');
const { v4: uuidv4 } = require('uuid');
const { spawn } = require('child_process');
const cors = require('cors');

const ADMIN_PASS = process.env.ADMIN_PASS || 'changeme';
const PORT = process.env.PORT || 3000;
const UPLOAD_DIR = path.join(__dirname, 'uploads');
const BOTS_DIR = path.join(__dirname, 'bots');

if (!fs.existsSync(UPLOAD_DIR)) fs.mkdirSync(UPLOAD_DIR);
if (!fs.existsSync(BOTS_DIR)) fs.mkdirSync(BOTS_DIR);

const app = express();
app.use(cors());
app.use(express.json());

// simple auth middleware
function auth(req, res, next) {
  const pass = req.headers['x-admin-pass'] || req.query.pass;
  if (pass === ADMIN_PASS) return next();
  return res.status(401).json({ ok: false, error: 'unauthorized' });
}

// serve UI
app.get('/', (req, res) => {
  res.type('html').send(`<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Mini Bot Host</title>
  <style>
    body{font-family:system-ui,Segoe UI,Roboto,Arial;margin:20px}
    input,button{padding:8px;margin:6px 0}
    .bot{border:1px solid #ddd;padding:10px;margin:10px 0;border-radius:6px}
    pre{background:#111;color:#eee;padding:10px;overflow:auto}
  </style>
</head>
<body>
  <h2>Mini Bot Host</h2>
  <p>Upload a ZIP containing your bot files (main.py, requirements.txt, etc.).
  Set header/query <code>pass</code> to your ADMIN_PASS.</p>

  <label>Admin password (for browser convenience) <input id="pass" type="password" placeholder="admin pass"></label>

  <h3>Upload</h3>
  <input id="file" type="file">
  <button onclick="upload()">Upload & Extract</button>
  <div id="result"></div>

  <h3>Existing bots</h3>
  <div id="bots"></div>

<script>
async function upload(){
  const f = document.getElementById('file').files[0];
  const pass = document.getElementById('pass').value;
  if(!f){alert('choose a zip file');return}
  const fd = new FormData();
  fd.append('zip', f);
  const res = await fetch('/upload?pass='+encodeURIComponent(pass),{
    method:'POST', body: fd
  });
  const j = await res.json();
  document.getElementById('result').innerText = JSON.stringify(j, null, 2);
  loadBots();
}

async function loadBots(){
  const pass = document.getElementById('pass').value;
  const res = await fetch('/bots?pass='+encodeURIComponent(pass));
  const j = await res.json();
  const el = document.getElementById('bots');
  el.innerHTML = '';
  if(!j.ok) { el.innerText = JSON.stringify(j); return }
  j.bots.forEach(b=>{
    const d = document.createElement('div'); d.className='bot';
    d.innerHTML = `<strong>${b.id}</strong> — <em>${b.name||'untitled'}</em><br>
      Status: ${b.running?'<b style="color:green">running</b>':'<b style="color:gray">stopped</b>'}<br>
      <button onclick="control('${b.id}','start')">Start</button>
      <button onclick="control('${b.id}','stop')">Stop</button>
      <button onclick="control('${b.id}','restart')">Restart</button>
      <button onclick="fetchLog('${b.id}')">View Log</button>
      <div id='log_${b.id}'></div>
    `;
    el.appendChild(d);
  })
}

async function control(id, action){
  const pass = document.getElementById('pass').value;
  const res = await fetch(`/bots/${id}/${action}?pass=${encodeURIComponent(pass)}`,{method:'POST'});
  const j = await res.json();
  alert(JSON.stringify(j));
  loadBots();
}

async function fetchLog(id){
  const pass = document.getElementById('pass').value;
  const res = await fetch(`/bots/${id}/log?pass=${encodeURIComponent(pass)}`);
  const txt = await res.text();
  document.getElementById('log_'+id).innerHTML = `<pre>${escapeHtml(txt)}</pre>`;
}

function escapeHtml(s){
  return s.replace(/[&<>\"']/g, c=>({ '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":"&#39;" }[c]));
}

loadBots();
</script>
</body>
</html>`);
});

// file upload
const storage = multer.diskStorage({
  destination: function (req, file, cb) { cb(null, UPLOAD_DIR); },
  filename: function (req, file, cb) { cb(null, Date.now() + '-' + file.originalname); }
});
const upload = multer({ storage: storage });

// in-memory map of running processes and logs
const bots = {}; // botId -> { dir, proc, logPath }

// upload and extract
app.post('/upload', auth, upload.single('zip'), async (req, res) => {
  if (!req.file) return res.status(400).json({ ok: false, error: 'no file' });
  const zipPath = req.file.path;
  const id = uuidv4();
  const dest = path.join(BOTS_DIR, id);
  fs.mkdirSync(dest);

  try {
    const zip = new AdmZip(zipPath);
    zip.extractAllTo(dest, true);
    // try to read package info
    let name = null;
    try {
      const meta = fs.readFileSync(path.join(dest, 'bot.json'), 'utf8');
      const j = JSON.parse(meta); name = j.name;
    } catch(e){}

    bots[id] = { dir: dest, running: false, logPath: path.join(dest, 'bot.log') };

    return res.json({ ok: true, id, name });
  } catch (e) {
    console.error(e);
    return res.status(500).json({ ok: false, error: String(e) });
  }
});

// list bots
app.get('/bots', auth, (req, res) => {
  const list = Object.entries(bots).map(([id, b]) => ({ id, name: path.basename(b.dir), running: !!b.proc }));
  res.json({ ok: true, bots: list });
});

// start bot (assumes Python: run `python3 main.py` in folder)
app.post('/bots/:id/start', auth, (req, res) => {
  const id = req.params.id; const b = bots[id];
  if (!b) return res.status(404).json({ ok:false, error:'not found' });
  if (b.proc) return res.json({ ok:true, message:'already running' });

  const logStream = fs.createWriteStream(b.logPath, { flags: 'a' });
  // if requirements.txt exists, install first (non-blocking)
  const reqs = path.join(b.dir, 'requirements.txt');
  if (fs.existsSync(reqs)) {
    console.log('installing requirements for', id);
    const pip = spawn('pip', ['install', '-r', reqs]);
    pip.stdout.pipe(logStream);
    pip.stderr.pipe(logStream);
    pip.on('close', (code) => console.log('pip exit', code));
  }

  const proc = spawn('python3', ['main.py'], { cwd: b.dir });
  b.proc = proc;
  b.running = true;

  proc.stdout.on('data', d=> fs.appendFileSync(b.logPath, d));
  proc.stderr.on('data', d=> fs.appendFileSync(b.logPath, d));
  proc.on('close', code=> { fs.appendFileSync(b.logPath, `\nPROCESS EXIT ${code}\n`); b.proc = null; b.running = false; });

  return res.json({ ok:true, message:'started' });
});

// stop
app.post('/bots/:id/stop', auth, (req, res) => {
  const id = req.params.id; const b = bots[id];
  if (!b) return res.status(404).json({ ok:false, error:'not found' });
  if (!b.proc) return res.json({ ok:true, message:'not running' });
  try { b.proc.kill(); } catch(e){}
  b.proc = null; b.running = false;
  return res.json({ ok:true, message:'stopped' });
});

// restart
app.post('/bots/:id/restart', auth, async (req, res) => {
  const id = req.params.id; const b = bots[id];
  if (!b) return res.status(404).json({ ok:false, error:'not found' });
  if (b.proc) try { b.proc.kill(); } catch(e){}
  b.proc = null; b.running = false;
  setTimeout(()=>{
    const proc = spawn('python3', ['main.py'], { cwd: b.dir });
    b.proc = proc; b.running = true; const logStream = fs.createWriteStream(b.logPath, { flags: 'a' });
    proc.stdout.on('data', d=> fs.appendFileSync(b.logPath, d));
    proc.stderr.on('data', d=> fs.appendFileSync(b.logPath, d));
    proc.on('close', c=>{ fs.appendFileSync(b.logPath, `\nPROCESS EXIT ${c}\n`); b.proc=null; b.running=false; });
  }, 800);
  return res.json({ ok:true, message:'restarted (async)' });
});

// get logs (tail)
app.get('/bots/:id/log', auth, (req, res) => {
  const id = req.params.id; const b = bots[id];
  if (!b) return res.status(404).send('not found');
  if (!fs.existsSync(b.logPath)) return res.send('');
  const txt = fs.readFileSync(b.logPath, 'utf8');
  res.type('text/plain').send(txt.slice(-50_000));
});

app.listen(PORT, ()=> console.log(`Mini Bot Host running on port ${PORT}. ADMIN_PASS=${ADMIN_PASS}`));
