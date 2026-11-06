# Measuring AI-Driven Engineering Productivity: A Framework for COS

Nov 5, 2026 · Sunny Chowdhury

## Executive summary

AI's value to COS engineering should be measured as **the change in validated delivery per engineering hour, against a pre-AI baseline, with quality held flat or better** — not tokens, seats, lines of code or self-reported time saved. Every one of those inputs can rise while delivery stays flat.

The research gives us a defensible planning range. Controlled studies span from a 19% slowdown (METR, experienced engineers in mature codebases) to a 26% increase in completed tasks (Microsoft/Accenture field trials). Large observational data puts the net average at 15–20%, falling to 0–10% for complex work in existing codebases. Most COS work is brownfield, so **plan on 10–15% net capacity until our own data proves otherwise**.

The headcount rule this framework enables:

- **Hiring decisions use measured capacity, not projected capacity.** A team's AI gain is credited in the headcount model only after it shows up in team-level delivery metrics for two consecutive quarters with stable change failure rate.
- **Every headcount request carries an AI-capacity case** (the Shopify "prove AI can't do it" gate, made quantitative): current AI behavior score, measured throughput trend, and the work that remains human-bound.
- **Perception is never evidence.** Developers in METR's trial believed they were 20% faster while measured 19% slower; surveys inform, telemetry decides.

This protects against both failure modes: over-hiring because we under-credit AI, and laying off because we over-credited it.

## What the evidence says

The rigorous studies agree on three things: individual task speed rises modestly (roughly 20%), organizational delivery does not rise automatically, and self-reported gains are unreliable. Each row below is a citable position for leadership.

| Study | Design and sample | Result | Position it supports |
| --- | --- | --- | --- |
| [Faros AI, AI Engineering Report 2026](https://faros.ai/research/ai-acceleration-whiplash) | Telemetry, 22,000 devs, 4,000 teams, 2 years | PR size +51%, median review time 5x, incidents per PR 3x, code churn 10x | Volume metrics rise while quality and flow degrade; measure the system, not output |
| [Faros AI, AI Productivity Paradox 2025](https://faros.ai/research) | Telemetry, 10,000 devs, 1,255 teams | Tasks +21%, PRs merged +98%, review time +91%, PR size +154%, bugs/dev +9%; no measurable change in team DORA metrics | The bottleneck moves to review; individual gains don't reach the org by default |
| [METR uplift update (Feb 2026)](https://metr.org/blog/2026-02-24-uplift-update/) | RCT, 57 devs, 143 repos, 800+ tasks | Returning devs −18% time (CI −38% to +9%); new devs −4% (CI −15% to +9%); METR calls its own estimate unreliable and a likely lower bound | Gains are probably real now but hard to prove; you need your own controlled comparison |
| [METR (Jul 2025)](https://arxiv.org/abs/2507.09089) | RCT, 16 experienced OSS devs, 246 tasks in mature repos | Tasks took 19% longer with AI; devs predicted −24% and afterwards believed −20% | Self-report overstates impact by ~40 points; never use surveys as the productivity number |
| [DORA 2025 State of AI-assisted Software Development](https://dora.dev/dora-report-2025/) | Survey, ~5,000 professionals | 90% adoption; AI now linked to higher throughput, but also to instability; AI is an "amplifier" of existing strengths and weaknesses | Platform and process maturity determine the payoff; publishes a 7-capability AI model |
| [Stanford, Denisov-Blanch (2025)](https://ai.engineer/talks/ai-developer-productivity) | Observational, ~100,000 devs, 600+ companies | Net 15–20% average after rework; greenfield-simple 30–40%, brownfield-complex 0–10%, sometimes negative | Segment by work type; brownfield legacy work earns the least |
| [Cui et al., Management Science](https://demirermert.github.io/Papers/Demirer_AI_productivity.pdf) | 3 field RCTs at Microsoft, Accenture, Fortune 100; 4,867 devs | +26.08% completed tasks (SE 10.3%); larger gains for less-experienced devs | The best causal estimate in enterprise settings; gains vary by seniority |
| [Google enterprise RCT, Paradis et al. (ICSE 2025)](https://arxiv.org/abs/2410.12944) | RCT, 96 Google engineers, one enterprise task | ~21% less time on task, wide confidence interval | Realistic single-task speedup in a large codebase |
| [DX AI Measurement Framework](https://getdx.com/research/measuring-ai-code-assistants-and-agents/) | Practitioner framework; Booking.com, Block, Intercom | Utilization → Impact → Cost; Booking.com +16% throughput across 3,500 engineers | Measurement model to adopt; warns against using AI metrics for individual evaluation |

**Planning implication:** the defensible central estimate for a brownfield fintech stack is 10–15% net capacity, with an honest range of 0–25% depending on work mix and review capacity. Anything above that needs COS's own data.

## How Shopify does it

Shopify's model is **behavior expectations + headcount gating + a small set of guardrail metrics**, not a single productivity number. Farhan Thawar (VP & Head of Engineering) calls his ~20% gain a "humble estimate" and refuses to measure it with lines of code or PR counts. ([BVP, Apr 2026](https://www.bvp.com/atlas/inside-shopifys-ai-first-engineering-playbook))

| Mechanism | What Shopify does | What COS should copy |
| --- | --- | --- |
| Behavior baseline | [Tobi Lütke's April 2025 memo](https://www.cnbc.com/2025/04/07/shopify-ceo-prove-ai-cant-do-jobs-before-asking-for-more-headcount.html) made reflexive AI use a baseline expectation; it is assessed in biannual performance and peer reviews | Assess *behaviors*, never usage volume, in reviews |
| Headcount gate | Teams must show why AI can't do the work before requesting headcount or resources | Same gate, but with a quantified capacity case (Part B) |
| Central LLM proxy | All tools route through one gateway; usage visible by team, project and person; alert at $250/day spend, which triggers curiosity, not punishment | Our AI gateway gives the same cost and adoption telemetry |
| Token spend | Unlimited; spend leaderboard used as a "cool proxy for value", explicitly not a quota ([First Round](https://www.firstround.com/ai/shopify)) | Treat spend as a cost and a discovery signal, never a productivity metric |
| Primary productivity signal | Weekly demos of shipped work; Thawar says the best signal "is still very human" | Pair telemetry with demo-based outcome review |
| Quality guardrail | Reversion (rollback) rate per PR; PR volume rose slightly while reversion stayed flat | Change failure rate and rework rate as hard gates |
| Review policy | No AI auto-merge; senior human review required, now acknowledged as the main bottleneck | Measure review latency as a first-class metric |
| Comprehension debt | Engineers must understand systems 2–3 layers below their work; "abdicate the toil, not the thinking" | Code ownership and incident-response checks |
| Enablement | Six-person ML infra team, MCP servers to internal systems, prompt library, leaders publicly demo their own AI use | Fund enablement before measuring impact |

**What Shopify does not have:** a causal, audited productivity number. Thawar's 20% is judgment informed by demos and guardrails. For a headcount decision at Capital One scale, we need to go further and measure against a baseline.

## Part A: What good AI behavior looks like

Good behavior means AI is used to **remove toil and widen exploration while the engineer keeps ownership of correctness**. Each behavior below has a telemetry signal so it can be tracked at team level; targets are set relative to each team's own pre-AI baseline.

| # | Behavior | What good looks like | Signal and source | Team target |
| --- | --- | --- | --- | --- |
| 1 | Reflexive first reach | AI used across design, debugging, tests and review, not only autocomplete | Weekly active users on the AI gateway; share of sessions by task type (gateway tags) | ≥80% WAU; ≥3 task types per active user |
| 2 | Small, reviewable changes | AI output is broken into PRs a human can actually review | Median lines changed per PR, AI-assisted vs. not (Git) | AI-assisted median ≤ team baseline |
| 3 | Ownership of correctness | Author understands and stands behind every line | Rework rate (code rewritten within 21 days); reverts per 100 PRs (Git) | At or below baseline |
| 4 | Tests ship with code | AI writes the tests too, and they run in CI | Share of PRs with test changes; diff coverage (CI) | ≥ baseline; diff coverage ≥80% |
| 5 | AI in verification | AI does a first-pass review and security scan before a human sees the PR | Share of PRs with AI review pass; SAST findings per PR (CI) | ≥90% of PRs; findings ≤ baseline |
| 6 | Toil delegated to agents | Dependency upgrades, vulnerability fixes, migrations and test backfill run agent-first | Share of toil-labeled tickets closed by agent-authored PRs (Jira + Git) | Rising quarter over quarter |
| 7 | Context engineering | Repos give agents what they need: instructions files, runbooks, MCP access | Share of active repos with agent context files and passing agent CI checks | ≥75% of active repos |
| 8 | Shared leverage | Working prompts, skills and agent workflows are published for reuse | Contributions to the shared prompt/skill library; reuse counts | ≥1 reusable asset per team per quarter |

**Anti-behaviors to flag:** large unreviewed AI diffs, merging code the author cannot explain in review, AI use that raises rework or review time, and gaming usage counters.

**How this enters performance reviews:** follow Shopify's lead on assessing AI fluency, but use the DX caution. Reviews assess behaviors through examples and peer input. Telemetry thresholds are for teams and enablement, never individual ratings — otherwise the numbers get gamed and stop being useful for headcount decisions.

## Part B: How we measure whether AI saves engineering capacity

One number drives decisions: **Effective Capacity Gain (ECG)** — the change in validated throughput per engineer versus baseline, net of a control trend, counted only when quality holds. Everything else is either a leading indicator or a guardrail.

### The unit of work

A **validated delivery unit (VDU)** is a merged change linked to an accepted work item that reached production and was not reverted or substantially reworked within 30 days. Work items are sized S/M/L (weights 1/3/8) and calibrated quarterly by sampling. This is deliberately not PR count or lines of code, both of which AI inflates.

### Metric stack

| Layer | Metric | Definition | Source | Role |
| --- | --- | --- | --- | --- |
| 1. Adoption | Weekly active AI users | Engineers with ≥1 gateway session in the week ÷ engineers | AI gateway | Leading indicator only |
| 1. Adoption | AI-assisted and agent-authored PR share | PRs with gateway session or agent author ÷ all PRs | Gateway + Git | Leading indicator only |
| 2. Flow | Validated throughput | Weighted VDUs per engineer-week | Jira + Git + deploy logs | **Decision metric** |
| 2. Flow | Lead time for changes | First commit to production, median | Git + CD | Decision metric |
| 2. Flow | Review latency | PR open to first review; open to merge | Git | Bottleneck detector |
| 3. Quality | Change failure rate | Deploys causing incident or rollback ÷ deploys | CD + incident tool | **Hard gate** |
| 3. Quality | Rework rate | Lines rewritten within 21 days ÷ lines added | Git | **Hard gate** |
| 3. Quality | Vulnerability introduction rate | New SAST/SCA high+critical findings per 100 PRs | Security scanners | Hard gate |
| 4. Capacity | Effective Capacity Gain | Formula below | Derived | **Headcount input** |
| 4. Capacity | KTLO share | Engineer-hours on toil and maintenance ÷ total | Jira allocation | Shows where capacity was freed |
| 5. Outcome | Roadmap delivery | Committed roadmap items shipped per quarter | Portfolio tool | Business confirmation |
| Cost | Cost per VDU | (AI spend + tooling) ÷ VDUs | Gateway billing | ROI, not productivity |
| Experience | Developer experience survey | Quarterly, DX-style, includes perceived time saved | Survey | Context only; never the number |

### Core formulas

Effective Capacity Gain uses a difference-in-differences against teams not yet on the new workflow (or the org's pre-rollout trend if every team adopts at once):

```
ECG = (T_team,now / T_team,base) / (T_ctrl,now / T_ctrl,base) − 1
```

where T is validated throughput per engineer-week. ECG is **reported as zero** for any quarter in which change failure rate or rework rate exceeds baseline by more than 10% relative.

Capacity reclaimed, in full-time equivalents, for a team of N engineers:

```
FTE_reclaimed = N × ECG / (1 + ECG)
```

Net annual value:

```
V = FTE_reclaimed × C_loaded − S_AI
```

where C_loaded is fully loaded cost per engineer and S_AI is annual AI spend (licenses + tokens + enablement).

**Worked example:** a 40-engineer brownfield team measures ECG = 12% with quality flat. Reclaimed capacity is 40 × 0.12 ÷ 1.12 ≈ 4.3 FTE. At $250K loaded cost and $240K annual AI spend, net value is ≈ $830K per year.

### Making it causal, not anecdotal

- **Staggered rollout:** introduce new AI workflows (e.g., agentic toil automation) to matched teams in waves, so later waves act as controls.
- **Segment the work:** report ECG separately for greenfield vs. brownfield and low vs. high complexity, per the Stanford finding that gains differ fourfold.
- **Sample-based calibration:** each quarter, two engineers re-size 50 random work items blind to AI status, to keep VDU weights honest.
- **Watch the constraint:** if review latency rises faster than throughput, the gain is being absorbed by reviewers (the Faros pattern) and is not yet bankable.

## Translating to capacity and headcount

Headcount is planned on **banked** capacity gain only — measured, quality-gated and sustained — never on projected or self-reported gain.

```
FTE_required = D / (t_base × (1 + ECG_banked))
```

where D is forecast demand in validated delivery units and t_base is baseline throughput per FTE.

### Rules for banking a gain

1. ECG has been measured for **two consecutive quarters** on the team, segmented by work type.
2. Change failure rate, rework rate and vulnerability introduction rate are at or below baseline in both quarters.
3. Review latency is flat or improving (the gain isn't being absorbed by reviewers).
4. The banked figure is the **lower** of the two quarters, capped at 25% unless an executive review approves more.
5. Banked gain is re-measured every quarter and can be withdrawn, which then re-opens hiring.

### Why this prevents over-hiring and layoffs

A 40-engineer team expecting 20% more demand next year (D = 48 FTE-equivalents of baseline work):

| Planning assumption | ECG used | FTE required | Hiring action | Risk |
| --- | --- | --- | --- | --- |
| Ignore AI | 0% | 48.0 | +8 | Over-hire; likely future layoff once gains show up |
| Banked, measured gain | 10% | 43.6 | +4 | Right-sized; re-check quarterly |
| Vendor or self-reported claim | 30% | 36.9 | −3 | Under-staffed; delivery misses, then panic hiring |

### The quantified "prove AI can't do it" gate

Every headcount request includes:

- [ ] Demand forecast in validated delivery units, by work type
- [ ] Team's banked ECG and current behavior scores (Part A)
- [ ] What was attempted with AI or agents for the requested work, with results
- [ ] The work that remains human-bound and why (e.g., high-complexity brownfield, regulatory judgment)
- [ ] Review capacity check: who reviews the added output

Where demand exceeds banked capacity but unbanked gains look promising, bridge with flexible capacity (contractors, internal mobility, deferred scope) for one or two quarters rather than permanent hires.

## Metrics to avoid as productivity measures

These can be tracked for cost or adoption, but none may appear as evidence of productivity in a headcount case.

| Metric | Why it fails | Evidence |
| --- | --- | --- |
| Token spend or AI cost | Measures input, not output; Shopify uses it to discover experiments, not rate people | [BVP](https://www.bvp.com/atlas/inside-shopifys-ai-first-engineering-playbook) |
| Lines of code, % code AI-generated | AI inflates volume; Thawar wants "solutions, not code" | [Faros 2026](https://faros.ai/research/ai-acceleration-whiplash): PR size +51%, churn 10x |
| Raw PR count | Rose 98% in Faros data with no team-level DORA improvement | [Faros 2025](https://faros.ai/research) |
| Self-reported time saved | ~40-point gap between perceived and measured speed | [METR 2025](https://arxiv.org/abs/2507.09089) |
| Suggestion acceptance rate | Measures tool UX, not delivered value | [DX](https://getdx.com/research/measuring-ai-code-assistants-and-agents/) |
| Any AI metric used for individual ratings | Invites gaming and makes team data unusable | [DX](https://getdx.com/research/measuring-ai-code-assistants-and-agents/) |

## Rollout plan

First banked ECG can inform Q3 2027 headcount planning if instrumentation starts this quarter.

1. **Instrument (Nov–Dec 2026).** Tag AI gateway sessions by team and task type; enforce PR-to-ticket linking; define VDU sizing; wire change failure, rework and SAST data into one dashboard.
2. **Baseline (Q1 2027).** Pull trailing four quarters of throughput and quality per team. Where possible, use pre-2025 history as the no-AI reference; otherwise ECG measures gain from *new* practices on top of current usage — state which in every report.
3. **Communicate.** Publish the metric definitions and the commitment that telemetry is team-level and not used for individual ratings.
4. **Staggered waves (Q1–Q2 2027).** Introduce specific workflows (agentic toil automation, AI first-pass review, context files) to matched teams in waves; later waves serve as controls.
5. **First readings (end Q2 2027).** Two quarters of ECG per team, segmented by work type; quality gates applied.
6. **Feed planning (Q3 2027).** Banked ECG enters the headcount model; every request uses the quantified gate.

**Cadence:** behavior and flow dashboard monthly; ECG review quarterly with Engineering, Finance and Enterprise Architecture; headcount calibration twice a year.

**Open questions for leadership:**

- Does COS have reliable pre-2025 throughput history, or do we accept an incremental baseline?
- Who owns VDU sizing calibration — engineering ops or Enterprise Architecture?
- What loaded cost per engineer should Finance use in the value formula?

## Sources

- [Inside Shopify's AI-first engineering playbook — Bessemer Venture Partners, Apr 2026](https://www.bvp.com/atlas/inside-shopifys-ai-first-engineering-playbook)
- [From Memo to Movement: Shopify's Cultural Adoption of AI — First Round Review](https://www.firstround.com/ai/shopify)
- [Shopify CEO: prove AI can't do jobs before asking for headcount — CNBC, Apr 2025](https://www.cnbc.com/2025/04/07/shopify-ceo-prove-ai-cant-do-jobs-before-asking-for-more-headcount.html)
- [We are Changing our Developer Productivity Experiment Design — METR, Feb 2026](https://metr.org/blog/2026-02-24-uplift-update/)
- [Measuring the Impact of Early-2025 AI on Experienced Open-Source Developer Productivity — METR, Jul 2025](https://arxiv.org/abs/2507.09089)
- [The Effects of Generative AI on High-Skilled Work — Cui, Demirer et al., Management Science](https://demirermert.github.io/Papers/Demirer_AI_productivity.pdf)
- [How much does AI impact development speed? An enterprise RCT — Paradis et al., Google, ICSE 2025](https://arxiv.org/abs/2410.12944)
- [2025 DORA State of AI-assisted Software Development — Google Cloud](https://dora.dev/dora-report-2025/)
- [AI Engineering Report 2026: The Acceleration Whiplash — Faros AI](https://faros.ai/research/ai-acceleration-whiplash)
- [AI Productivity Paradox 2025 — Faros AI](https://faros.ai/research)
- [Does AI Actually Boost Developer Productivity? (100k devs) — Denisov-Blanch, Stanford](https://ai.engineer/talks/ai-developer-productivity)
- [Measuring AI code assistants and agents (AI Measurement Framework) — DX](https://getdx.com/research/measuring-ai-code-assistants-and-agents/)
