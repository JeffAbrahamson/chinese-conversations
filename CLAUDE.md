# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Chinese Conversation Trainer - a personal Mandarin learning tool that generates conversations from vocabulary lists with neural audio playback. Currently at v0 (static UI with mocked data).

**Target Platform:** Cloudflare (Pages, Workers, D1, R2)

## Commands

```bash
# Development
npm run dev              # Start wrangler dev server (port 8787)
npm test                 # Run tests once
npm run test:watch       # Run tests in watch mode

# Database
npm run db:migrate       # Apply migrations locally
npm run db:migrate:prod  # Apply migrations to production

# Deployment
npm run deploy           # Deploy worker to Cloudflare

# Docker (run from repo root)
(cd docker && ./docker-manage.sh run)     # Dev server in container
(cd docker && ./docker-manage.sh test)    # Run tests in container
(cd docker && ./docker-manage.sh sh)      # Interactive shell
(cd docker && ./docker-manage.sh claude)  # Run Claude Code
(cd docker && ./docker-manage.sh down)    # Stop containers
```

## Architecture

```
frontend/          Static HTML/JS/CSS served by Cloudflare Pages
  └── app.js       Vanilla JS, localStorage for preferences

worker/            Cloudflare Worker (Hono framework)
  └── index.ts     API routes, D1/R2 bindings

migrations/        D1 (SQLite) schema
  └── 001_init.sql Tables: conversations, conversation_lines, audio_clips
```

**Bindings (wrangler.toml):**
- `DB` → D1 database `chinese-conversations-db`
- `AUDIO_BUCKET` → R2 bucket `chinese-conversations-audio`

**API Routes (v0 - most return 501):**
- `GET /api/health` - Health check
- `GET /api/conversations/:id` - Returns mocked conversation
- `POST /api/conversations` - Create (stub)
- `POST /api/conversations/:id/audio` - Generate audio (stub)
- `GET /api/audio/:clipId` - Get audio (stub)

## Key Files

- `SPEC.md` - Functional and technical requirements
- `AGENTS.md` - Agent development guidelines
- `TODO-human.md` - Actions requiring human intervention (API keys, services)

## Development Guidelines

From AGENTS.md:
- Keep SPEC.md in sync with implementation - update spec if you deviate
- Code must have tests
- Update TODO-human.md when external service setup is needed
- When running in Docker, changes outside the filesystem won't persist
- If you need new packages that should persist, add them to the Dockerfile
- If you need persistant environment changes to continue, write notes to yourself in TODO-claude.md so that the instruction TODO-claude.md is enough to get you going again once the container is restarted.

## Database Schema

Three tables with audio deduplication via `text_hash + voice_id`:
- `conversations` - Metadata, level (beginner/intermediate), visibility
- `conversation_lines` - Speaker A/B, zh/pinyin/en text, ordering via idx
- `audio_clips` - TTS cache with status (pending/ready/failed)
