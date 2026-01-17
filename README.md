# Chinese Conversation Trainer

A lightweight, personal web application for learning Mandarin Chinese through short, natural conversations with neural audio playback.

The project is optimized for **speed of development**, **low operational overhead**, and **low cost**, with the assumption of very low traffic (initially a single user).

---

## Purpose

* Generate simple, natural Chinese conversations from a pasted vocabulary list
* Listen to conversations line‑by‑line or as a whole
* Toggle display of Chinese / pinyin / English
* Cache generated neural audio to avoid regeneration costs
* Create near‑variants of conversations to avoid rote memorization

This is a **language‑learning tool**, not a showcase engineering project. Pragmatism and iteration speed take precedence over architectural purity.

---

## Technology Stack (v1)

This project uses **Cloudflare as much as possible** to minimize infrastructure complexity.

### Frontend

* **Cloudflare Pages**
* Static + minimal client‑side JS (React optional but not required)
* Preferences stored in `localStorage`

### Backend / API

* **Cloudflare Workers** (HTTP API)
* **Durable Objects** (optional, for background coordination)
* **Cloudflare Cron Triggers** (for audio generation jobs)

### Database

* **Cloudflare D1 (SQLite)**

  * Conversations
  * Lines
  * Audio clip metadata

### Storage

* **Cloudflare R2**

  * Cached neural audio clips (MP3)

### Authentication

* Cloudflare Access
* Single‑user support is sufficient for v1

### External Services

* LLM provider (conversation generation + mutation)
* Neural TTS provider (Mandarin voices)

All API keys are kept server‑side in Workers secrets.

---

## Repository Structure (suggested)

```
/
├── README.md
├── SPEC.md
├── frontend/
│   ├── index.html
│   ├── app.js
│   └── styles.css
├── worker/
│   ├── index.ts   # or index.js / index.py
│   ├── db.ts
│   ├── llm.ts
│   ├── tts.ts
│   └── routes/
│       ├── conversations.ts
│       ├── audio.ts
│       └── auth.ts
├── migrations/
│   └── 001_init.sql
└── wrangler.toml
```

---

## Development Philosophy

* Prefer **one working path** over configurability
* Strongly constrain LLM outputs (strict JSON)
* Cache aggressively
* Avoid background infrastructure unless clearly necessary
* Accept manual cleanup for early iterations

---

## Running Locally

```bash
npm install
wrangler dev
```

D1 and R2 can be run locally via Wrangler.

---

## Deployment

```bash
wrangler deploy
```

Cloudflare Pages deploys the frontend automatically from the repo.

---

## Status

* v0: static UI + mocked data
* v1: single‑user, fully functional learning loop
* v1.1: conversation mutation + light editing

---

## License

GPL v3.  See [LICENSE](LICENSE).
