# Agenda
## **Phase 1: Foundations (Environment + Scaffolding)**

**Goal:** Have a minimal, working Elixir service skeleton.

* **✅ Day 1–2 (2–4 hrs total):**

  * Install and set up Elixir project (`mix new epsilon_server`).
  * Decide if you’ll use **Phoenix** (for a web server) or **Plug + Cowboy** (lighter).
  * Create a health-check endpoint (`/ping`) that just returns `"ok"`.

---

## **Phase 2: Data Model + Storage**

**Goal:** Store experiments and results somewhere.

* **✅ Day 3–4:**

  *  Define schema (e.g., `experiment_id`, `title`, `thumbnail`, `views`, `clicks`).
  *  Pick persistence option:

    * **Lightweight:** ETS/Mnesia (good for fast prototyping, in-memory).
    * **Persistent:** Postgres (via Ecto).
  * Implement functions to:

    * Add a new candidate (title + thumbnail).
    * Record impressions & clicks.

---

## **Phase 3: Core Algorithm (Epsilon-Greedy)**

**Goal:** Implement selection logic.

* **Day 5–6:**

  * Implement function:

    * With probability **ε** → pick random candidate.
    * With probability **1–ε** → pick candidate with best CTR so far.
  * Parameterize ε (configurable).
  * Unit test the selection logic.

---

## **Phase 4: API Endpoints**

**Goal:** Expose server functionality.

* **Day 7–8:**

  * `/serve/:experiment_id` → returns chosen title + thumbnail (uses epsilon-greedy).
  * `/track/:experiment_id/:candidate_id?event=view|click` → logs events.
  * Return JSON responses.

---

## **Phase 5: Metrics + Dashboard (Optional Polishing)**

**Goal:** Monitor experiment progress.

* **Day 9–10:**

  * Simple endpoint `/stats/:experiment_id` → return CTR per candidate.
  * If time: build a tiny HTML page or JSON output for visualization.

---

## **Phase 6: Deployment & Tuning**

**Goal:** Get it running in the wild.

* **Day 11–12:**

  * Dockerize the app.
  * Deploy to Fly.io, Gigalixir, or simple VPS.
  * Add basic logging.

---

## **Stretch Goals (after core is done)**

* Adaptive ε (decays over time).
* Multi-armed bandit alternatives (e.g., UCB, Thompson Sampling).
* UI for non-technical users.
* Experiment versioning.

---

### Daily Flow (2 hrs each)

1. **15 min**: Review what you did last time.
2. **90 min**: Focus on one small milestone (no distractions).
3. **15 min**: Commit + write tiny TODO for next session.

---

⚡ Key advice: Resist the urge to overbuild early — get the **MVP** (serve candidates + track CTR via epsilon-greedy) working before adding dashboards or polishing.

---

Do you want me to **draft a concrete 2-week schedule** (e.g., "Day 1 do X, Day 2 do Y") so you can just follow it step by step?

