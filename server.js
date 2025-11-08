const express = require('express');
const multer = require('multer');
const fs = require('fs');
const path = require('path');
const { v4: uuidv4 } = require('uuid');
const { spawn } = require('child_process');
const cors = require('cors');

const PORT = process.env.PORT || 3000;
const UPLOAD_DIR = path.join(__dirname, 'uploads');
const BOTS_DIR = path.join(__dirname, 'bots');

if (!fs.existsSync(UPLOAD_DIR)) fs.mkdirSync(UPLOAD_DIR);
if (!fs.existsSync(BOTS_DIR)) fs.mkdirSync(BOTS_DIR);

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const storage = multer.diskStorage({
  destination: function (req, file, cb) { cb(null, UPLOAD_DIR); },
  filename: function (req, file, cb) { cb(null, Date.now() + '-' + file.originalname); }
});
const upload = multer({ storage: storage });

// in-memory map of running processes
const bots = {}; // botId -> { dir, proc, logPath }

// serve web UI (build HTML without template literals to avoid syntax issues)
app.get('/', (req, res) => {
  const htmlLines = [];
  htmlLines.push('<!doctype html>');
  htmlLines.push('<html>');
  htmlLines.push('<head>');
  htmlLines.push('<meta charset="utf-8">');
  htmlLines.push('<meta name="viewport" content="width=device-width,initial-scale=1">');
  htmlLines.push('<title>Coderweb</title>');
  htmlLines.push('<style>');
  htmlLines.push('body{background:#1e1e2f;color:#eee;font-family:sans-serif;margin:20px}');
  htmlLines.push('h1,h2,h3{color:#fff}');
  htmlLines.push('input,button,textarea{padding:6px;margin:4px;border-radius:4px;border:none}');
  htmlLines.push('button{cursor:pointer;background:#4caf50;color:white}');
  htmlLines.push('button.stop{background:#f44336}');
  htmlLines.push('button.restart{background:#ff9800}');
  htmlLines.push('.bot{border:1px solid #555;padding:10px;margin:10px 0;border-radius:6px}');
  htmlLines.push('pre{background:#111;color:#0f0;padding:10px;overflow:auto;max-height:200px}');
  htmlLines.push('textarea{width:100%;height:200px;background:#111;color:#0f0;resize:none}');
  htmlLines.push('</style>');
  htmlLines.push('</head>');
  htmlLines.push('<body>');
  htmlLines.push('<h1>Coderweb - Discord Bot Host</h1>');
  htmlLines.push('<p>Upload a bot ZIP (Python or Node.js)</p>');
  htmlLines.push('<input type="file" id="file"><button onclick="upload()">Upload</button>');
  htmlLines.push('<div id="result"></div>');
  htmlLines.push('<h2>Running Bots</h2>');
  htmlLines.push('<div id="bots"></div>');
  htmlLines.push('<h2>Shell</h2>');
  htmlLines.push('<textarea id="shell" placeholder="Enter commands here"></textarea>');
  htmlLines.push('<button onclick="runShell()">Run</button>');
  htmlLines.push('<pre id="shellOutput"></pre>');
  htmlLines.push('<script>');
  htmlLines.push('async function upload(){');
  htmlLines.push('  const f = document.getElementById("file").files[0];');
  htmlLines.push('  if(!f){alert("Select a file");return}');
  htmlLines.push('  const fd = new FormData();');
  htmlLines.push('  fd.append("zip", f);');
  htmlLines.push('  const res = await fetch("/upload",{method:"POST",body:fd});');
  htmlLines.push('  const j = await res.json();');
  htmlLines.push('  document.getElementById("result").innerText = JSON.stringify(j,null,2);');
  htmlLines.push('  loadBots();');
  htmlLines.push('}');
  htmlLines.push('async function loadBots(){');
  htmlLines.push('  const res = await fetch("/bots");');
  htmlLines.push('  const j = await res.json();');
  htmlLines.push('  const el = document.getElementById("bots"); el.innerHTML="";');
  htmlLines.push('  j.bots.forEach(function(b){');
  htmlLines.push('    const d = document.createElement("div"); d.className="bot";');
  htmlLines.push('    const idEl = document.createElement("div");');
  htmlLines.push('    idEl.innerHTML = "<strong>" + b.id + "</strong> — " + (b.name||"untitled");');
  htmlLines.push('    const statusEl = document.createElement("div");');
  htmlLines.push('    statusEl.innerHTML = "Status: " + (b.running?\'<b style="color:green">running</b>\':\'<b style="color:gray">stopped</b>\');');
  htmlLines.push('    const btnStart = document.createElement("button"); btnStart.textContent = "Start"; btnStart.onclick = function(){ control(b.id,"start"); };');
  htmlLines.push('    const btnStop = document.createElement("button"); btnStop.textContent = "Stop"; btnStop.className = "stop"; btnStop.onclick = function(){ control(b.id,"stop"); };');
  htmlLines.push('    const btnRestart = document.createElement("button"); btnRestart.textContent = "Restart"; btnRestart.className = "restart"; btnRestart.onclick = function(){ control(b.id,"restart"); };');
  htmlLines.push('    const btnLogs = document.createElement("button"); btnLogs.textContent = "Logs"; btnLogs.onclick = function(){ viewLog(b.id); };');
  htmlLines.push('    const pre = document.createElement("pre"); pre.id = "log_" + b.id;');
  htmlLines.push('    d.appendChild(idEl); d.appendChild(statusEl); d.appendChild(btnStart); d.appendChild(btnStop); d.appendChild(btnRestart); d.appendChild(btnLogs); d.appendChild(pre);');
  htmlLines.push('    el.appendChild(d);');
  htmlLines.push('  });');
  htmlLines.push('}');
  htmlLines.push('async function control(id,action){');
  htmlLines.push('  const res = await fetch("/bots/"+id+"/"+action,{method:"POST"});');
  htmlLines.push('  const j = await res.json();');
  htmlLines.push('  alert(JSON.stringify(j));');
  htmlLines.push('  loadBots();');
  htmlLines.push('}');
  htmlLines.push('async function viewLog(id){');
  htmlLines.push('  const res = await fetch("/bots/"+id+"/log");');
  htmlLines.push('  const txt = await res.text();');
  htmlLines.push('  document.getElementById("log_"+id).innerText = txt;');
  htmlLines.push('}');
  htmlLines.push('async function runShell(){');
  htmlLines.push('  const cmd = document.getElementById("shell").value;');
  htmlLines.push('  const res = await fetch("/shell",{method:"POST",headers:{"Content-Type":"application/json"},body:JSON.stringify({cmd})});');
  htmlLines.push('  const txt = await res.text();');
  htmlLines.push('  document.getElementById("shellOutput").innerText = txt;');
  htmlLines.push('}');
  htmlLines.push('loadBots();');
  htmlLines.push('</script>');
  htmlLines.push('</body>');
  htmlLines.push('</html>');
  res.send(htmlLines.join('\n'));
});

// file upload
storage2 = multer.diskStorage({
  destination: function (req, file, cb) { cb(null, UPLOAD_DIR); },
  filename: function (req, file, cb) { cb(null, Date.now() + '-' + file.originalname); }
});
upload2 = multer({ storage: storage2 });

app.post('/upload', upload2.single('zip'), async (req,res)=>{
  if(!req.file) return res.status(400).json({ok:false,error:'no file'});
  const zipPath = req.file.path;
  const id = uuidv4();
  const dest = path.join(BOTS_DIR,id);
  fs.mkdirSync(dest);
  try{
    const AdmZip = require('adm-zip');
    const zip = new AdmZip(zipPath);
    zip.extractAllTo(dest,true);
    bots[id] = {dir:dest,running:false,logPath:path.join(dest,'bot.log')};
    return res.json({ok:true,id});
  }catch(e){return res.status(500).json({ok:false,error:String(e)})}
});

app.get('/bots',(req,res)=>{
  const list = Object.entries(bots).map(([id,b])=>({id,name:path.basename(b.dir),running:!!b.proc}));
  res.json({ok:true,bots:list});
});

app.post('/bots/:id/start',(req,res)=>{
  const b=bots[req.params.id];if(!b) return res.status(404).json({ok:false,error:'not found'});
  if(b.proc) return res.json({ok:true,message:'already running'});
  const logStream=fs.createWriteStream(b.logPath,{flags:'a'});
  const reqs=path.join(b.dir,'requirements.txt');
  if(fs.existsSync(reqs)){spawn('pip',['install','-r',reqs]).stdout.pipe(logStream);}
  const pkg=path.join(b.dir,'package.json');
  if(fs.existsSync(pkg)){spawn('npm',['install'],{cwd:b.dir}).stdout.pipe(logStream);}
  let proc;
  if(fs.existsSync(path.join(b.dir,'main.py'))){proc=spawn('python3',['main.py'],{cwd:b.dir});}
  else if(fs.existsSync(path.join(b.dir,'index.js'))||fs.existsSync(path.join(b.dir,'main.js'))||fs.existsSync(pkg)){
    const entry=fs.existsSync(path.join(b.dir,'index.js'))?'index.js':'main.js';
    proc=spawn('node',[entry],{cwd:b.dir,env:process.env});
  }else{const f=fs.readdirSync(b.dir).find(x=>x.endsWith('.py')||x.endsWith('.js'));if(f){proc=f.endsWith('.py')?spawn('python3',[f],{cwd:b.dir}):spawn('node',[f],{cwd:b.dir,env:process.env});}else{return res.status(400).json({ok:false,error:'no runnable file'});}}
  b.proc=proc;b.running=true;
  proc.stdout.on('data',d=>fs.appendFileSync(b.logPath,d));
  proc.stderr.on('data',d=>fs.appendFileSync(b.logPath,d));
  proc.on('close',c=>{fs.appendFileSync(b.logPath,`\\nPROCESS EXIT ${c}\\n`);b.proc=null;b.running=false;});
  res.json({ok:true,message:'started'});
});

app.post('/bots/:id/stop',(req,res)=>{
  const b=bots[req.params.id];if(!b) return res.status(404).json({ok:false,error:'not found'});
  if(b.proc) try{b.proc.kill();}catch(e){}
  b.proc=null;b.running=false;res.json({ok:true,message:'stopped'});
});

app.post('/bots/:id/restart',(req,res)=>{
  const b=bots[req.params.id];if(!b) return res.status(404).json({ok:false,error:'not found'});
  if(b.proc) try{b.proc.kill();}catch(e){}
  b.proc=null;b.running=false;
  setTimeout(()=>{ // attempt restart by running same startup logic
    const reqs=path.join(b.dir,'requirements.txt');
    if(fs.existsSync(reqs)){spawn('pip',['install','-r',reqs]);}
    const pkg=path.join(b.dir,'package.json');
    if(fs.existsSync(pkg)){spawn('npm',['install'],{cwd:b.dir});}
    let proc;
    if(fs.existsSync(path.join(b.dir,'main.py'))){proc=spawn('python3',['main.py'],{cwd:b.dir});}
    else if(fs.existsSync(path.join(b.dir,'index.js'))||fs.existsSync(path.join(b.dir,'main.js'))||fs.existsSync(pkg)){
      const entry=fs.existsSync(path.join(b.dir,'index.js'))?'index.js':'main.js';
      proc=spawn('node',[entry],{cwd:b.dir,env:process.env});
    }else{const f=fs.readdirSync(b.dir).find(x=>x.endsWith('.py')||x.endsWith('.js'));if(f){proc=f.endsWith('.py')?spawn('python3',[f],{cwd:b.dir}):spawn('node',[f],{cwd:b.dir,env:process.env});}else{fs.appendFileSync(b.logPath,'\\nRESTART FAILED: no runnable file\\n');return;}}
    b.proc=proc;b.running=true;proc.stdout.on('data',d=>fs.appendFileSync(b.logPath,d));proc.stderr.on('data',d=>fs.appendFileSync(b.logPath,d));proc.on('close',c=>{fs.appendFileSync(b.logPath,`\\nPROCESS EXIT ${c}\\n`);b.proc=null;b.running=false;});
  },500);
  res.json({ok:true,message:'restarted (async)'});
});

app.get('/bots/:id/log',(req,res)=>{
  const b=bots[req.params.id];if(!b) return res.status(404).send('not found');
  if(!fs.existsSync(b.logPath)) return res.send('');
  res.type('text/plain').send(fs.readFileSync(b.logPath,'utf8').slice(-50000));
});

app.post('/shell',(req,res)=>{
  const cmd=req.body.cmd;
  if(!cmd) return res.status(400).send('no cmd');
  const sh=spawn(cmd,{shell:true});
  let out='';
  sh.stdout.on('data',d=>out+=d);
  sh.stderr.on('data',d=>out+=d);
  sh.on('close',c=>res.send(out));
});

app.listen(PORT,()=>console.log(`Coderweb running on port ${PORT}`));
