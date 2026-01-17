# Specification – Chinese Conversation Trainer

## 1. Scope

This document defines the functional and technical specification for a personal Chinese language‑learning web application.

Primary goals:

* Very fast time‑to‑usable
* Minimal infrastructure
* Low operating cost
* Optimized for a single primary user

---

## 2. User Model

### 2.1 Roles

* **Authenticated user**

  * Generate conversations
  * Generate and regenerate audio
  * Create conversation variants
  * Manage stored content

* **Unauthenticated visitor**

  * View and listen to conversations via unlisted URLs

---

## 3. Core Data Model

### 3.1 Conversation

| Field        | Type      | Notes                   |
| ------------ | --------- | ----------------------- |
| id           | UUID      | primary key             |
| title        | TEXT      | optional                |
| created_at   | TIMESTAMP |                         |
| source_words | JSON      | pasted vocabulary       |
| level        | TEXT      | beginner / intermediate |
| visibility   | TEXT      | private / unlisted      |
| version_of   | UUID      | nullable                |

### 3.2 ConversationLine

| Field           | Type    | Notes       |
| --------------- | ------- | ----------- |
| id              | UUID    |             |
| conversation_id | UUID    |             |
| idx             | INTEGER | ordering    |
| speaker         | TEXT    | A / B       |
| zh              | TEXT    | Chinese     |
| pinyin          | TEXT    | tone‑marked |
| en              | TEXT    | English     |

### 3.3 AudioClip

| Field      | Type | Notes                    |
| ---------- | ---- | ------------------------ |
| id         | UUID |                          |
| line_id    | UUID |                          |
| voice_id   | TEXT |                          |
| provider   | TEXT |                          |
| text_hash  | TEXT | dedupe key               |
| audio_path | TEXT | R2 object key            |
| status     | TEXT | pending / ready / failed |

---

## 4. Functional Requirements

### 4.1 Generate Conversation (auth)

Input:

* Free‑form word list
* Target difficulty
* Desired length

Output:

* Structured conversation with:

  * Natural Chinese
  * Pinyin
  * English translation

Constraints:

* Output must be strict JSON
* Majority of provided words must appear
* Vocabulary level must be respected

---

### 4.2 Generate Audio (auth)

* Generate Mandarin neural TTS per line
* Cache audio by `(text_hash, voice_id)`
* Store audio in R2
* Do not regenerate identical audio

Audio generation may be:

* synchronous for small sets
* asynchronous via cron + pending rows for larger sets

---

### 4.3 View Conversation (public)

Features:

* Toggle display of zh / pinyin / en
* Play entire conversation or line‑by‑line
* Optional explicit “next” prompt
* Optional language playback order (e.g. EN → ZH)

Preferences:

* Stored in `localStorage`
* Persist across conversations within session

---

### 4.4 Generate Similar Conversation (auth)

Purpose:

* Avoid over‑training on fixed phrasing

Behavior:

* Keep topic and difficulty
* Rephrase lines
* Swap limited vocabulary
* Preserve approximate length

Result:

* New conversation with `version_of` link

---

## 5. API Endpoints

### Authenticated

* `POST /api/conversations`
* `POST /api/conversations/{id}/audio`
* `POST /api/conversations/{id}/similar`

### Public

* `GET /api/conversations/{id}`
* `GET /api/audio/{clip_id}`

---

## 6. Cloudflare Architecture

* Workers handle API + external calls
* D1 stores structured data
* R2 stores binary audio
* Cron triggers handle background audio jobs

No long‑running servers.

---

## 7. LLM Output Contract

LLM responses **must** conform to:

```json
{
  "title": "string",
  "lines": [
    { "speaker": "A", "zh": "…", "pinyin": "…", "en": "…" }
  ]
}
```

Invalid output is retried once with a JSON‑repair prompt.

---

## 8. Error Handling

* Audio failures are per‑line, not global
* Failed clips can be retried manually
* Public users never trigger generation

---

## 9. Security

* All generation endpoints require auth
* Public conversations are unlisted by default
* API keys stored as Workers secrets

---

## 10. Out of Scope

* Multi‑user collaboration
* SRS / spaced repetition scheduling
* Mobile apps
* Pronunciation scoring

---

## 11. Success Criteria

The system is successful when:

* A new conversation can be generated and listened to in minutes
* Audio is reused across sessions
* Variants feel familiar but non‑identical
* Ongoing maintenance cost is negligible
