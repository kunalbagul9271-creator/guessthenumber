<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title>Crack the Code</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;700&family=JetBrains+Mono:wght@500;700&display=swap" rel="stylesheet">
<style>
  :root {
    --bg: #eef0f4;
    --surface: #ffffff;
    --text: #1b1d27;
    --text-dim: #5b5f70;
    --accent: #b8892b;
    --accent-strong: #96701f;
    --success: #1f9d55;
    --border: #dcdfe6;
    box-sizing: border-box;
    padding-top: env(safe-area-inset-top, 0px);
    padding-bottom: env(safe-area-inset-bottom, 0px);
  }
  @media (prefers-color-scheme: dark) {
    :root:not([data-theme="light"]) {
      --bg: #14161f;
      --surface: #1d2030;
      --text: #eceef2;
      --text-dim: #9296a8;
      --accent: #d9a94a;
      --accent-strong: #f0bd63;
      --success: #34d399;
      --border: #2c3044;
    }
  }
  :root[data-theme="dark"] {
    --bg: #14161f;
    --surface: #1d2030;
    --text: #eceef2;
    --text-dim: #9296a8;
    --accent: #d9a94a;
    --accent-strong: #f0bd63;
    --success: #34d399;
    --border: #2c3044;
  }
  * { box-sizing: border-box; }
  html { scroll-padding-top: env(safe-area-inset-top, 0px); }
  body {
    margin: 0;
    min-height: 100vh;
    background: var(--bg);
    color: var(--text);
    font-family: 'Space Grotesk', system-ui, -apple-system, sans-serif;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 24px;
  }
  .card {
    width: 100%;
    max-width: 420px;
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 20px;
    padding: 36px 32px 32px;
    box-shadow: 0 1px 2px rgba(0,0,0,0.04);
    transition: box-shadow 0.4s ease;
  }
  .card.won {
    box-shadow: 0 0 0 2px var(--success), 0 8px 30px rgba(31,157,85,0.15);
  }
  h1 {
    font-size: 1.6rem;
    font-weight: 700;
    margin: 0 0 8px;
    letter-spacing: -0.01em;
  }
  p.lede {
    color: var(--text-dim);
    font-size: 0.95rem;
    line-height: 1.5;
    margin: 0 0 28px;
    max-width: 34ch;
  }
  .bounds {
    display: flex;
    justify-content: space-between;
    align-items: baseline;
    font-family: 'JetBrains Mono', monospace;
    color: var(--text-dim);
    font-size: 0.8rem;
    margin-bottom: 6px;
  }
  .bounds span { color: var(--accent-strong); font-weight: 700; }
  .track {
    height: 6px;
    background: var(--border);
    border-radius: 3px;
    overflow: hidden;
    margin-bottom: 26px;
    position: relative;
  }
  .track-fill {
    position: absolute;
    top: 0; bottom: 0;
    background: var(--accent);
    border-radius: 3px;
    transition: left 0.35s ease, right 0.35s ease;
  }
  .row {
    display: flex;
    gap: 10px;
  }
  input[type="number"] {
    flex: 1;
    min-width: 0;
    font-family: 'JetBrains Mono', monospace;
    font-size: 1.4rem;
    font-weight: 700;
    text-align: center;
    padding: 12px 8px;
    border-radius: 12px;
    border: 1px solid var(--border);
    background: var(--bg);
    color: var(--text);
    outline: none;
  }
  input[type="number"]:focus {
    border-color: var(--accent);
  }
  input[type="number"]::-webkit-outer-spin-button,
  input[type="number"]::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
  }
  button {
    font-family: inherit;
    font-weight: 700;
    font-size: 1rem;
    border: none;
    border-radius: 12px;
    padding: 12px 20px;
    cursor: pointer;
    transition: transform 0.12s ease, background 0.2s ease;
  }
  button:active { transform: scale(0.96); }
  .try-btn {
    background: var(--accent);
    color: #1b1204;
  }
  .try-btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
  .feedback {
    min-height: 1.4em;
    margin: 18px 0 4px;
    font-size: 1.05rem;
    font-weight: 500;
  }
  .feedback.higher, .feedback.lower { color: var(--accent-strong); }
  .feedback.won { color: var(--success); font-weight: 700; }
  .stats {
    display: flex;
    justify-content: space-between;
    font-size: 0.85rem;
    color: var(--text-dim);
    margin-top: 18px;
    padding-top: 18px;
    border-top: 1px solid var(--border);
  }
  .stats strong { color: var(--text); }
  .reset-btn {
    display: none;
    width: 100%;
    margin-top: 16px;
    background: transparent;
    border: 1px solid var(--border);
    color: var(--text);
  }
  .reset-btn.show { display: block; }
</style>
</head>
<body>
  <div class="card" id="card">
    <h1>Crack the code</h1>
    <p class="lede">I'm thinking of a number between 1 and 100. Find it in as few tries as possible.</p>

    <div class="bounds"><span id="lowLabel">1</span><span id="highLabel">100</span></div>
    <div class="track"><div class="track-fill" id="trackFill"></div></div>

    <div class="row">
      <input type="number" id="guessInput" min="1" max="100" placeholder="Your guess" autofocus>
      <button class="try-btn" id="tryBtn">Try</button>
    </div>

    <div class="feedback" id="feedback"></div>

    <div class="stats">
      <span>Attempts: <strong id="attempts">0</strong></span>
      <span>Best: <strong id="best">–</strong></span>
    </div>

    <button class="reset-btn" id="resetBtn">New code</button>
  </div>

<script>
  const LOW = 1, HIGH = 100;
  let target, attempts, low, high, won;
  const card = document.getElementById('card');
  const input = document.getElementById('guessInput');
  const tryBtn = document.getElementById('tryBtn');
  const feedback = document.getElementById('feedback');
  const attemptsEl = document.getElementById('attempts');
  const bestEl = document.getElementById('best');
  const resetBtn = document.getElementById('resetBtn');
  const lowLabel = document.getElementById('lowLabel');
  const highLabel = document.getElementById('highLabel');
  const trackFill = document.getElementById('trackFill');

  function loadBest() {
    try {
      const v = localStorage.getItem('guessTheNumberBest');
      if (v) bestEl.textContent = v;
    } catch (e) { /* storage unavailable */ }
  }

  function saveBest(n) {
    try {
      const cur = localStorage.getItem('guessTheNumberBest');
      if (!cur || n < parseInt(cur, 10)) {
        localStorage.setItem('guessTheNumberBest', String(n));
        bestEl.textContent = n;
      }
    } catch (e) { /* storage unavailable */ }
  }

  function updateTrack() {
    const leftPct = ((low - LOW) / (HIGH - LOW)) * 100;
    const rightPct = ((HIGH - high) / (HIGH - LOW)) * 100;
    trackFill.style.left = leftPct + '%';
    trackFill.style.right = rightPct + '%';
    lowLabel.textContent = low;
    highLabel.textContent = high;
  }

  function newGame() {
    target = Math.floor(Math.random() * (HIGH - LOW + 1)) + LOW;
    attempts = 0;
    low = LOW; high = HIGH;
    won = false;
    attemptsEl.textContent = '0';
    feedback.textContent = '';
    feedback.className = 'feedback';
    card.classList.remove('won');
    resetBtn.classList.remove('show');
    input.value = '';
    input.disabled = false;
    tryBtn.disabled = false;
    updateTrack();
    input.focus();
  }

  function submitGuess() {
    if (won) return;
    const val = parseInt(input.value, 10);
    if (isNaN(val) || val < LOW || val > HIGH) {
      feedback.textContent = `Enter a number between ${LOW} and ${HIGH}`;
      feedback.className = 'feedback';
      return;
    }
    attempts++;
    attemptsEl.textContent = attempts;

    if (val === target) {
      won = true;
      feedback.textContent = `Cracked it in ${attempts} ${attempts === 1 ? 'try' : 'tries'}!`;
      feedback.className = 'feedback won';
      card.classList.add('won');
      input.disabled = true;
      tryBtn.disabled = true;
      resetBtn.classList.add('show');
      saveBest(attempts);
    } else if (val < target) {
      low = Math.max(low, val + 1);
      feedback.textContent = 'Go higher';
      feedback.className = 'feedback higher';
      updateTrack();
    } else {
      high = Math.min(high, val - 1);
      feedback.textContent = 'Go lower';
      feedback.className = 'feedback lower';
      updateTrack();
    }
    input.value = '';
    input.focus();
  }

  tryBtn.addEventListener('click', submitGuess);
  input.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') submitGuess();
  });
  resetBtn.addEventListener('click', newGame);

  loadBest();
  newGame();
</script>
</body>
</html>
