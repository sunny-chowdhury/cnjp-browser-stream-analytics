# Measuring AI-Driven Engineering Productivity: A Framework for Shopping

Nov 5, 2026 · Sunny Chowdhury

## Executive summary

AI's value to Shopping engineering should be measured as **the change in validated delivery per engineering hour, against a pre-AI baseline, with quality held flat or better** — not tokens, seats, lines of code or self-reported time saved. Every one of those inputs can rise while delivery stays flat.

The research gives us a defensible planning range. The strongest current evidence is Microsoft's early-2026 field study of Claude Code and Copilot CLI across tens of thousands of engineers: adopters merged about 24% more pull requests, and the lift held for four months ([Murphy-Hill, Butler & Savelieva, 2026](https://arxiv.org/abs/2607.01418)). But agentic gains shrink on the way to shipped software: a 100,000-developer NBER study finds a 180% rise in commits becomes a 30% rise in releases, and DX's 40-company study puts organization-wide throughput gains near 10%. Most Shopping work is brownfield, so **plan on 10–15% net capacity until our own data proves otherwise**, with up to roughly 30% possible for teams using agents well.

The headcount rule this framework enables:

- **Hiring decisions use measured capacity, not projected capacity.** A team's AI gain is credited in the headcount model only after it shows up in team-level delivery metrics for two consecutive quarters with stable change failure rate.
- **Every headcount request carries an AI-capacity case** (the Shopify "prove AI can't do it" gate, made quantitative): current AI behavior score, measured throughput trend, and the work that remains human-bound.
- **Perception is never evidence.** Developers in METR's trial believed they were 20% faster while measured 19% slower; surveys inform, telemetry decides.

This protects against both failure modes: over-hiring because we under-credit AI, and laying off because we over-credited it.

## What the evidence says

The research falls into two generations: 2026 studies of agentic tools (Claude Code, Copilot CLI, Codex) and 2023–2025 trials of autocomplete-era assistants. Both agree that activity rises, shipped output rises much less, and self-reported gains are unreliable. Each row is a citable position for leadership.

### Agentic era (2026)

| Study | Design and sample | Result | Position it supports |
| --- | --- | --- | --- |
| [Microsoft: Adoption and Impact of Command-Line AI Coding Agents (Murphy-Hill, Butler & Savelieva, Jul 2026)](https://arxiv.org/abs/2607.01418) | Field study, tens of thousands of Microsoft engineers, Claude Code and Copilot CLI rollout Jan–Apr 2026; synthetic control plus within-person analysis | Adopters merged +24.0% more PRs (95% CI +14.5% to +33.7%); no fade over four months; placebo test passed. Within-person: Claude Code +11.4%, Copilot CLI +24.9% | Strongest current evidence that agentic gains are real, persistent and measurable from existing telemetry. Authors caution that PRs aren't value and quality was not measured |
| [Demirer, Musolff & Yang, NBER (May 2026)](https://demirermert.github.io/Papers/Demirer_Writing_vs_shipping_code.pdf) | Matched event study, 100,000+ GitHub developers with AI usage telemetry | Commits +40% (autocomplete), +140% (interactive agents), +180% (autonomous agents); the 180% falls to +50% in projects and +30% in releases | Gains shrink at each step toward shipped software; count shipped work, not activity |
| [DX longitudinal study (Mar 2026)](https://newsletter.getdx.com/p/ai-productivity-gains-are-10-not) | 40 companies, Nov 2024–Feb 2026 | AI usage +65%; PR throughput +9.97%, excluding teams with individual PR targets | Organization-wide gains are about 10%, not multiples |
| [Faros AI, AI Engineering Report 2026](https://faros.ai/research/ai-acceleration-whiplash) | Telemetry, 22,000 devs, 4,000 teams, 2 years | PR size +51%, median review time 5x, incidents per PR 3x, code churn 10x | Volume rises while quality and flow degrade; quality gates are mandatory |
| [DORA, ROI of AI-assisted Software Development (Jan 2026)](https://dora.dev/ai/roi/report) | Financial model and research synthesis | J-curve: sample model assumes a 15% dip for three months from learning and verification overhead | Expect a dip before gains; don't judge in the first quarter |
| [Anthropic skill-formation RCT, Shen & Tamkin (Jan 2026)](https://arxiv.org/abs/2601.20245) | RCT, 52 mostly junior engineers learning a new library | No significant speedup; 17% lower comprehension; engineers using AI for conceptual questions scored well, those delegating code scored below 40% | How engineers use AI matters; supports the Part A ownership behaviors |
| [METR uplift update (Feb 2026)](https://metr.org/blog/2026-02-24-uplift-update/) | RCT, 57 devs, 143 repos, 800+ tasks | Returning devs −18% time (CI −38% to +9%); new devs −4% (CI −15% to +9%); METR calls its own estimate unreliable and a likely lower bound | Clean trials are now hard to run because developers won't work without AI; rely on telemetry |

### Earlier generation (2023–2025)

| Study | Design and sample | Result | Position it supports |
| --- | --- | --- | --- |
| [Faros AI, AI Productivity Paradox 2025](https://faros.ai/research) | Telemetry, 10,000 devs, 1,255 teams | Tasks +21%, PRs merged +98%, review time +91%, PR size +154%, bugs/dev +9%; no measurable change in team DORA metrics | The bottleneck moves to review; individual gains don't reach the org by default |
| [METR (Jul 2025)](https://arxiv.org/abs/2507.09089) | RCT, 16 experienced OSS devs, 246 tasks in mature repos | Tasks took 19% longer with AI; devs predicted −24% and afterwards believed −20% | Self-report overstates impact by ~40 points; never use surveys as the productivity number |
| [DORA 2025 State of AI-assisted Software Development](https://dora.dev/dora-report-2025/) | Survey, ~5,000 professionals | 90% adoption; AI now linked to higher throughput, but also to instability; AI is an "amplifier" of existing strengths and weaknesses | Platform and process maturity determine the payoff; publishes a 7-capability AI model |
| [Stanford, Denisov-Blanch (2025)](https://ai.engineer/talks/ai-developer-productivity) | Observational, ~100,000 devs, 600+ companies | Net 15–20% average after rework; greenfield-simple 30–40%, brownfield-complex 0–10%, sometimes negative | Segment by work type; brownfield legacy work earns the least |
| [Cui et al., Management Science](https://demirermert.github.io/Papers/Demirer_AI_productivity.pdf) | 3 field RCTs at Microsoft, Accenture, Fortune 100; 4,867 devs | +26.08% completed tasks (SE 10.3%); larger gains for less-experienced devs | The best causal estimate in enterprise settings; gains vary by seniority |
| [Google enterprise RCT, Paradis et al. (ICSE 2025)](https://arxiv.org/abs/2410.12944) | RCT, 96 Google engineers, one enterprise task | ~21% less time on task, wide confidence interval | Realistic single-task speedup in a large codebase |
| [DX AI Measurement Framework](https://getdx.com/research/measuring-ai-code-assistants-and-agents/) | Practitioner framework; Booking.com, Block, Intercom | Utilization → Impact → Cost; Booking.com +16% throughput across 3,500 engineers | Measurement model to adopt; warns against using AI metrics for individual evaluation |

**Planning implication:** for teams using agents well, the 2026 evidence supports roughly 10–30% more shipped output; organization-wide averages sit nearer 10%. Shopping plans on 10–15% until its own data shows more, and any banked gain above 25% needs executive sign-off (see the headcount rules).

## How Shopify does it

Shopify's model is **behavior expectations + headcount gating + a small set of guardrail metrics**, not a single productivity number. Farhan Thawar (VP & Head of Engineering) calls his ~20% gain a "humble estimate" and refuses to measure it with lines of code or PR counts. ([BVP, Apr 2026](https://www.bvp.com/atlas/inside-shopifys-ai-first-engineering-playbook))

| Mechanism | What Shopify does | What Shopping should copy |
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

**What Shopify does not have:** a causal, audited productivity number. Thawar's 20% is judgment informed by demos and guardrails. For a headcount decision at Capital One scale, we go further and measure each team against its own baseline.

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

One number drives the headcount conversation: **capacity gain**, how much more finished work each engineer ships per quarter than before, counted only if quality hasn't slipped. Everything else is context.

### What counts as finished work

Tickets that reached production and weren't rolled back or rewritten within 30 days, using each team's existing sizing. Not PR counts or lines of code; AI inflates both.

### Six metrics, three jobs

| Metric | What it tells us | Job |
| --- | --- | --- |
| Shipped work per engineer per quarter | Are we delivering more? | Decides the gain |
| Lead time (commit to production) | Are we delivering faster? | Decides the gain |
| Change failure rate | Is more work breaking production? | Quality gate |
| Rework rate (code rewritten within 21 days) | Is AI code being thrown away? | Quality gate |
| Review wait time | Are reviewers absorbing the gain? | Early warning |
| AI adoption and spend | Are people using it, and at what cost? | Context only |

All six come from systems Shopping already runs: Jira, Git, the deploy pipeline, incident tooling and the AI gateway.

### The calculation

```
Capacity gain = (shipped work per engineer this quarter ÷ team's baseline) − 1
Freed capacity (engineers) = team size × gain ÷ (1 + gain)
```

The baseline is the team's average over the four quarters before measurement starts. If change failure rate or rework rate is more than 10% worse than baseline, the gain counts as zero that quarter.

**Worked example:** a 40-engineer team ships 12% more with quality flat. That frees 40 × 0.12 ÷ 1.12 ≈ 4.3 engineers' worth of capacity, roughly $1.07M at a $250K loaded cost, or about $830K net of $240K AI spend. (Illustrative figures; Finance supplies the real ones.)

### Limits to state upfront

- A before/after comparison can't fully separate AI from other changes such as reorgs, roadmap mix or attrition. Note those beside each team's number, and require two consecutive quarters, not one.
- If AI was already in heavy use during the baseline, the number shows the gain from *better* AI use, not AI's total effect. Say which in every report.

## Translating to headcount

Headcount is planned on **banked** capacity gain only: measured, quality-checked and sustained. Never on projected or self-reported gain.

```
Engineers needed = forecast work ÷ (baseline output per engineer × (1 + banked gain))
```

### When a gain counts as banked

1. Measured for **two consecutive quarters**.
2. Change failure rate and rework rate at or below baseline in both.
3. Review wait time not rising, so reviewers aren't silently absorbing the gain.
4. Use the **lower** of the two quarters, capped at 25% without executive sign-off.
5. Re-checked every quarter; if it drops, hiring reopens.

### Why this prevents over-hiring and layoffs

A 40-engineer team expecting 20% more work next year (48 engineers' worth at today's output):

| Planning assumption | Gain used | Engineers needed | Hiring action | Risk |
| --- | --- | --- | --- | --- |
| Ignore AI | 0% | 48.0 | +8 | Over-hire; likely layoff once gains show up |
| Banked, measured gain | 10% | 43.6 | +4 | Right-sized; re-checked quarterly |
| Vendor or self-reported claim | 30% | 36.9 | −3 | Under-staffed; missed delivery, then panic hiring |

### The quantified "prove AI can't do it" gate

Every headcount request includes:

- [ ] Forecast work for the period
- [ ] Team's banked capacity gain and Part A behavior scores
- [ ] What was tried with AI or agents for this work, and what happened
- [ ] The work that remains human-bound, and why
- [ ] Who reviews the extra output

Where demand exceeds banked capacity but gains look promising, bridge with flexible capacity (contractors, internal mobility, deferred scope) for a quarter or two rather than permanent hires.

## Metrics to avoid as productivity measures

These can be tracked for cost or adoption, but none may appear as evidence of productivity in a headcount case.

| Metric | Why it fails | Evidence |
| --- | --- | --- |
| Token spend or AI cost | Measures input, not output; Shopify uses it to discover experiments, not rate people, and DORA (Jun 2026) warns token leaderboards are easy to game | [BVP](https://www.bvp.com/atlas/inside-shopifys-ai-first-engineering-playbook) |
| Lines of code, % code AI-generated | AI inflates volume; Thawar wants "solutions, not code" | [Faros 2026](https://faros.ai/research/ai-acceleration-whiplash): PR size +51%, churn 10x |
| Raw PR count | Rose 98% in Faros data with no team-level DORA improvement | [Faros 2025](https://faros.ai/research) |
| Self-reported time saved | ~40-point gap between perceived and measured speed | [METR 2025](https://arxiv.org/abs/2507.09089) |
| Suggestion acceptance rate | Measures tool UX, not delivered value | [DX](https://getdx.com/research/measuring-ai-code-assistants-and-agents/) |
| Any AI metric used for individual ratings | Invites gaming and makes team data unusable | [DX](https://getdx.com/research/measuring-ai-code-assistants-and-agents/) |

## Rollout plan

First banked gains can inform Q3 2027 headcount planning if tracking starts this quarter.

1. **Instrument (Nov–Dec 2026).** Link PRs to tickets, tag AI gateway usage by team, and put the six metrics on one dashboard.
2. **Baseline (Q1 2027).** Pull each team's previous four quarters, and note whether AI was already in heavy use then.
3. **Communicate.** Publish the definitions and commit that metrics are team-level, never individual ratings.
4. **Measure (Q1–Q2 2027).** Two quarters of capacity gain per team, with quality gates and notes on other changes.
5. **Feed planning (Q3 2027).** Banked gains enter the headcount model; every request uses the gate.

**Cadence:** dashboard monthly; capacity review quarterly with Engineering, Finance and Enterprise Architecture; headcount calibration twice a year.

**Open questions for leadership:**

- How far back is Shopping's ticket and deploy history reliable?
- Do teams size tickets consistently enough to compare quarter to quarter?
- What loaded cost per engineer should Finance use?

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

**Added November 2026 (agentic-era studies):**

- [Adoption and Impact of Command-Line AI Coding Agents: A Study of Microsoft's Early 2026 Rollout of Claude Code and GitHub Copilot CLI — Murphy-Hill, Butler & Savelieva, Microsoft, arXiv 2607.01418, Jul 2026](https://arxiv.org/abs/2607.01418)
- [Writing Code vs. Shipping Code: Productivity Effects Across Generations of AI Coding Tools — Demirer, Musolff & Yang, NBER Working Paper 35275, May 2026](https://demirermert.github.io/Papers/Demirer_Writing_vs_shipping_code.pdf)
- [AI productivity gains are 10%, not 10x — DX, Mar 2026](https://newsletter.getdx.com/p/ai-productivity-gains-are-10-not)
- [The ROI of AI-assisted Software Development — Google Cloud DORA, Jan 2026](https://dora.dev/ai/roi/report)
- [Finding balance in the era of tokenmaxxing — DORA, Jun 2026](https://dora.dev/insights/)
- [How AI Impacts Skill Formation — Shen & Tamkin, Anthropic, arXiv 2601.20245, Jan 2026](https://arxiv.org/abs/2601.20245)
