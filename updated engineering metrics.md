Measuring AI’s Impact on Engineering Capacity

A prescriptive measurement and capacity planning framework for Shopping

Discussion draft | November 2026

Executive summary

AI can reduce the effort required for some engineering work. The leadership question is whether those improvements are repeatable, measurable, and applicable to enough of Shopping’s future work to change our capacity and hiring decisions.

A successful demonstration does not answer that question. Nor do token consumption, licenses, lines of code, or the number of pull requests. We need evidence of how much human effort is required to complete comparable work, including review, testing, security, and subsequent rework.

This framework makes a distinction between three stages:

1. Experiment: An engineer demonstrates that AI can help with a task.
2. Repeatable workflow: Multiple engineers can use a documented, supported process on representative work and achieve acceptable outcomes.
3. Planning evidence: The workflow’s net effect has been measured, its future volume and adoption are credible, and its capacity can be applied to work the organization needs done.

The recommended approach is to measure net human hours per assigned work item, including failed and incomplete attempts for selected work categories, compare an AI-enabled workflow with an appropriate baseline, validate quality, and translate only the applicable, repeatable portion into capacity. The output is a range—not an automatic headcount reduction.

Leadership decisions requested:

• Sponsor a 90-day pilot across a small set of representative engineering workflows.
• Assign a joint owner from Engineering and Engineering Operations, with Finance and Risk as partners.
• Agree on a transparent measurement protocol and use of team-level results before collecting pilot data.
• Use evidence from pilots to inform capacity planning; do not require teams to assume a universal AI productivity gain.

> **Planning principle:** We should neither ignore AI when forecasting demand nor assume capacity gains that we have not demonstrated. Both can produce poor hiring decisions.

Research evidence and implications

External studies show a range of results because the tasks, codebases, developers, tools, and measures differ. Use the studies to guide the design of Shopping’s measurement, not as a productivity multiplier for Shopping.

|**Evidence**                      |**Finding**                                                                                                                                     |**Implication for Shopping**                                                                                         |
|----------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|
|METR 2025 randomized study        |16 experienced open source developers completed 246 tasks; tasks took 19% longer using the tested tools.                                        |Measure real work and compare actual outcomes with perceptions; do not generalize this estimate to all current tools.|
|METR 2026 update                  |Later results suggested speedup, but the researchers warned that selection and measurement issues made the magnitude unreliable.                |Include excluded tasks, nonparticipants, concurrent agent work, and uncertainty.                                     |
|Google enterprise randomized trial|96 engineers performed a defined task; the estimate was about 21% less time, with a wide confidence interval.                                   |Task improvements are possible, but one task result is not a team or staffing forecast.                              |
|Cui and Demirer field experiments |Across 4,867 developers, the preferred usage-based estimate was 26.08% more completed tasks; completed pull requests were the principal outcome.|Increased development activity is not automatically equivalent to customer value or available staffing capacity.     |
|DORA 2025                         |The report describes AI as amplifying existing organizational strengths and weaknesses.                                                         |Measure the delivery system, review capacity, reliability, and enabling conditions alongside tool use.               |

Source links and limitations are provided in the research appendix. Shopify’s engineering leader describes roughly 20% higher productivity as an estimate; it is not a validated Shopping capacity figure.

Planning scenarios, not forecasts: Until Shopping has its own evidence, leaders may model 0%, 10%, and 20% potential gains as sensitivity scenarios. These values are illustrative and do not establish expected or approved capacity.

1. The problem we are solving

Shopping needs to invest in engineering talent with a credible view of what work requires human time and how that requirement may change with AI.

Underestimating durable gains can lead us to hire against demand we could already meet. Overestimating them can leave teams understaffed, increase risk, create delivery misses, or lead to hiring and workforce decisions that later need to be reversed.

The challenge is that AI activity is not the same as engineering capacity. An engineer can generate code faster while another engineer spends longer reviewing it. A task can look complete while later testing or incident response reveals additional work. A successful prompt can depend on the expertise of one person and fail when applied elsewhere.

We need a method that answers four questions:

1. Are engineers using AI thoughtfully and responsibly?
2. How much total human effort does a defined workflow require with and without a particular AI intervention?
3. Can the improvement be repeated across representative work and engineers while meeting quality and control requirements?
4. How much of the observed improvement is applicable to forecast work and usable by the people and teams doing it?

2. The core idea: repeatability creates capacity

A one-time gain is an experiment. A repeatable gain can become an engineering capability. A measured and applicable capability can inform a staffing decision.

Repeatability means that another qualified engineer can follow a known process on a similar task, using approved tools and access, and produce an acceptable result without relying on the original experimenter’s undocumented knowledge.

A repeatable workflow needs:

• A clearly defined work category and circumstances in which the workflow should—and should not—be used.
• A documented process, prompts or agent instructions, relevant context, tools, and required access.
• Named ownership for keeping the workflow and its dependencies current.
• Explicit human review, testing, security, and acceptance requirements.
• Observed results from more than one qualified engineer and across representative work items, including unsuccessful attempts.
• A way to detect when the workflow’s results change after a model, tool, process, or codebase change.

We do not assume every task must become automated. An AI-assisted investigation with an experienced engineer in control can be repeatable and valuable even if no code is generated.

Measurement of repeatability

For each pilot, maintain a workflow record and report:

|**Measure**                     |**Definition**                                                                              |**Why it matters**                                                                      |
|--------------------------------|--------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------|
|**Applicability**               |Eligible work items ÷ all work items in the defined category                                |Shows how much work can plausibly use the workflow.                                     |
|**Adoption among eligible work**|Eligible items where the workflow was attempted ÷ eligible items                            |Indicates actual use; track non-use and reasons rather than forcing adoption.           |
|**Completion and acceptance**   |Attempted items meeting predefined acceptance criteria ÷ attempted items                    |Includes failed attempts, escalation to a human, and abandoned runs in the denominator. |
|**Independent use**             |Number and range of qualified engineers who have attempted the process                      |Reduces reliance on a single expert; examine results by operator without ranking people.|
|**Net effort**                  |Average total human hours per assigned item, including failed attempts and subsequent rework|Determines whether the process saves effort overall.                                    |
|**Durability**                  |Results across time, releases, and representative task subtypes                             |Indicates whether an apparent gain persists.                                            |

Track exclusion reasons and failed cases. A workflow that succeeds on 90% of selected easy tasks is not necessarily effective on 90% of the full backlog. Small samples produce wide uncertainty; the pilot owner should show counts alongside percentages.

3. What good AI behavior looks like

Good AI behavior is a combination of judgment, verification, responsible tool use, and sharing. The expectation is to apply AI where it helps and retain engineering accountability.

|**Behavior**                          |**Observable evidence**                                                                                 |**How to measure it**                                                                    |
|--------------------------------------|--------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------|
|**Identify appropriate opportunities**|Engineer can explain why AI was useful—or unsuitable—for a task.                                        |Sample work discussions or retrospectives; track common use cases and blockers by team.  |
|**Provide useful context**            |The workflow uses relevant approved documentation, system context, constraints, and acceptance criteria.|Sample workflow documentation for required context and controls.                         |
|**Own the result**                    |Engineer can explain the change, alternatives, risk, and operational impact.                            |Sample design and code reviews; use normal peer feedback.                                |
|**Verify before delivery**            |Tests, security checks, human review, and other applicable controls are completed.                      |CI, review, and security-control completion for sampled work.                            |
|**Share what works and what fails**   |Engineers publish or improve reusable workflows, including limitations and failure cases.               |Track workflows with documented owners and demonstrated reuse; discuss actual usefulness.|
|**Improve the system**                |Team addresses recurring sources of friction such as access, test gaps, or unclear documentation.       |Track identified blockers, ownership, and resolution over time.                          |

Proposed operating standard: Each pilot workflow must have a named owner and be attempted by at least two qualified engineers other than the creator before repeatability can be assessed. This is a minimum management screen, not sufficient statistical evidence by itself.

No individual productivity ranking based on AI telemetry. Token volume, session counts, AI-generated code share, and suggestion acceptance are useful for cost or tool diagnostics, not as measures of individual contribution or business value. Manager evaluation can consider examples of appropriate judgment and ownership within existing performance processes, not arbitrary usage quotas.

4. What we measure

Use a set of measures together. One number cannot capture productivity, quality, capacity, and business value.

|**Layer**              |**Primary measures**                                                                     |**Purpose**                                                                                 |
|-----------------------|-----------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------|
|**Access and adoption**|Approved access, active teams, attempted eligible work, reasons for non-use              |Find access and enablement gaps; not a productivity score.                                  |
|**Effort**             |Total human hours per assigned item, including failures, by workflow and comparison group|Estimate the change in effort attributable to the intervention where the design supports it.|
|**Flow**               |Elapsed lead time, review wait, blocked time, time to acceptance                         |Identify bottlenecks and customer-facing speed. Elapsed time is not labor time.             |
|**Quality and risk**   |Acceptance, escaped defects, incidents, security findings and severity, rework effort    |Determine whether the result meets required standards and whether costs shifted downstream. |
|**Repeatability**      |Success across representative items, engineers, and time; documented workflow and owner  |Determine whether the result can be relied on outside the initial demonstration.            |
|**Capacity and cost**  |Applicable net hours saved, achievable adoption, ongoing support, tool cost              |Inform staffing scenarios and investment decisions.                                         |
|**Experience**         |Engineer and reviewer feedback about friction, confidence, and maintainability           |Explain results and identify problems to investigate.                                       |

Define the unit of work once

A work item is a bounded task or outcome with predefined completion and acceptance criteria, counted once even if it produces multiple PRs or deployments. For example: remediate one eligible dependency vulnerability in one service and pass agreed validation.

Record the number of PRs as context, not as a multiplier. Group similar work by subtype and complexity. Do not add unlike tickets into one universal productivity score or compare teams solely by ticket count.

Operational investigation, documentation, architecture, and security work can be included when completion and acceptance can be defined. Work without a sensible comparable unit should remain visible in capacity plans and be evaluated using appropriate methods; it is not zero-value work.

5. How we estimate the impact on human hours

Step 1: Select a workflow and define the comparison

Choose a recurring work category that has a meaningful volume, an owner, and a clear definition of success. Record:

• The population of work and eligibility criteria, including excluded cases.
• The current process, including existing AI tools. This is the baseline.
• The specific intervention: for example, an approved agent workflow for dependency upgrades.
• Acceptance and quality criteria, agreed in advance.
• The effort categories and follow-up period.
• The assignment method, decision owner, and planned analysis.

Most Shopping engineers may already use AI. If the comparison is today’s AI-assisted workflow versus a new agent workflow, the result measures the incremental impact of the new workflow, not the total effect of all AI use.

Step 2: Compare representative work

Preferred: randomized assignment. When feasible, assign eligible incoming tasks or comparable teams to either the current workflow or the new workflow before work begins. Use the same acceptance standards. Randomize within relevant categories where practical, and analyze all assigned work—including failures, non-use, and escalations—in its assigned group. Record actual use separately to understand adoption.

Alternative: staged rollout. Where randomization is impractical, introduce a workflow to comparable teams in waves and compare changes over time. Examine prior trends, work mix, staffing, outages, seasonality, and other concurrent changes. Shared reviewers and knowledge can spill over between groups. A comparison helps but does not automatically prove cause and effect.

Last resort: before-and-after. If there is no credible comparison group, record the change as an observed trend and describe likely confounders. Do not label it a causal AI gain.

Do not withhold tools required for production safety or force an engineer to complete unsuitable work without support. Enlist a measurement partner to determine a feasible sample and uncertainty before the pilot; do not promise a precise result from a fixed number of tasks. If the pilot is too small, combine additional comparable cohorts over time or report that the effect is not yet reliably distinguishable.

Step 3: Capture total human effort

For sampled tasks in both groups, capture the same components:

1. Investigation and planning.
2. Prompting, supervision, implementation, and documentation.
3. Human review, testing, security validation, and required approvals.
4. Failed attempts, escalation, and corrections before acceptance.
5. Attributable follow-up and rework during a defined observation period, such as 30 days after acceptance.

Use existing workflow data where it is reliable, supplemented by lightweight time diaries or structured estimates completed near the work. These are measurements with error—not perfect time records. Sample the same way in both groups, distinguish recorded from estimated time, check completion and missingness, and do not infer hours from idle time, calendar duration, tool use, or ticket status alone. Account for shared reviewers and avoid charging the same time to multiple tasks.

Use acceptance checks independent of the author where practical and blind reviewers to assignment where feasible. Report incomplete items, abandoned attempts, and work beyond the observation window. Do not count only quickly completed successes.

Step 4: Calculate a result and show its uncertainty

For a sufficiently comparable group of assigned items:

Average human effort per item = total human hours / number of assigned items

Net hours saved per item = average baseline hours − average intervention hours

Percentage effort change = net hours saved per item / average baseline hours

For a simple calculation, use groups with comparable task mixes; otherwise predefine stratified or adjusted estimates and have the measurement partner check them. Include incomplete items and explain how their costs and outcomes are handled. Keep quality outcomes separate. If the new workflow does not meet acceptance standards, do not treat the apparent time difference as usable capacity.

Report the estimate with a confidence or uncertainty interval appropriate to the design and clustering, sample sizes, work mix, missing data, and known limitations. Report negative effects and an inconclusive result when supported. Quality and security may need longer follow-up and larger samples than the effort estimate.

6. Worked example: from effort to a hiring decision

All numbers in this example are illustrative. They are not Shopping measurements or targets.

A. Observe the workflow

A team tests an agent-assisted dependency upgrade process. The study compares representative eligible upgrade items assigned to the current process and the new process. Both groups include engineering, review, testing, failed attempts, and 30-day attributable rework.

|**Measurement**                       |**Current process**  |**New workflow**                            |
|--------------------------------------|---------------------|--------------------------------------------|
|Average human effort per assigned item|8.0 hours            |6.0 hours                                   |
|Measured difference                   |—                    |**2.0 hours less per item**                 |
|Acceptance and quality                |Meets agreed criteria|Meets agreed criteria in the observed sample|

The point estimate is a 25% reduction in effort for this defined category, not a 25% increase in productivity across all engineers.

Suppose the estimated range for the net effect is 0.5 to 3.0 hours saved per item. This is an illustrative interval, not one calculated from actual pilot data. The range shows why planning should not automatically use the 2.0-hour midpoint.

B. Translate the result into applicable capacity

Suppose the next year’s forecast includes 600 upgrades already included in the baseline demand estimate, and leaders judge—based on eligibility, rollout, access, and observed use—that 50% can realistically use the new workflow. Assume, for illustration, that Finance and Engineering select 2.0 hours per applicable item for a planning scenario and that workflow maintenance and training require 400 additional human hours, not already captured in the per-item measurement.

Applicable items = 600 × 50% = 300

Gross potential hours saved = 300 × 2.0 = 600

Less incremental support effort = 600 − 400 = 200 net hours

At 1,600 available engineering hours per FTE per year, that is 0.125 FTE-equivalent of annual capacity, not a staff position. The 1,600 hours is an illustrative capacity assumption that must reflect the organization’s actual available time and exclude leave and recurring non-project obligations consistently.

What this example reveals: even a substantial per-task gain may be small after limited applicable volume and support costs. A leader who sees “25% less effort” should not assume a 25% reduction in staffing needs.

C. Show a scaled scenario separately

If the same validated workflow instead applies to 6,000 forecast items under the same 50% achievable adoption assumption:

Applicable items = 6,000 × 50% = 3,000

Gross potential hours saved = 3,000 × 2.0 = 6,000

Less incremental support effort = 6,000 − 400 = 5,600 net hours

FTE-equivalent capacity = 5,600 / 1,600 = 3.5 FTE-equivalents

This scenario assumes that the larger population has the same task mix and effect, and that 400 support hours are sufficient at scale. Those assumptions need evidence. Calculate low, central, and high cases using the uncertainty around effort, volume, uptake, and support cost. For example, holding the other assumptions fixed and using the illustrative 0.5-hour lower bound, net annual capacity would be 1,100 hours, or 0.69 FTE-equivalents. A lower bound is not a guaranteed outcome.

D. Connect the scenario to hiring

Assume a team has 40 engineers with 1,600 available hours each, and reserves 5% of that available capacity for forecast uncertainty:

Available capacity for planned demand = 40 × 1,600 × 95% = 60,800 hours

Forecast baseline demand = 68,000 hours

The 68,000 hours includes the forecast upgrade work before the new workflow and includes all other planned work; it excludes obligations already removed in the 1,600-hour availability assumption.

|**Planning case**                     |**Net new-workflow capacity**|**Remaining gap**|**Illustrative hires***|
|--------------------------------------|-----------------------------|-----------------|-----------------------|
|No credit yet                         |0 hours                      |7,200 hours      |5                      |
|Scaled scenario, central estimate     |5,600 hours                  |1,600 hours      |2                      |
|Scaled scenario, lower effect estimate|1,100 hours                  |6,100 hours      |5                      |

*Illustrative hires are rounded up using 1,520 planned hours per new hire (1,600 × 95%), assuming a full year and matching skills. The central case needs 2 rather than 1 because 1,600 exceeds one hire’s 1,520 planned hours. Real plans must reflect start dates, ramp-up, skills, turnover, demand timing, and dependencies.*

The table illustrates a range of hiring outcomes, not a recommendation to hire two people. If confidence is insufficient, leaders may approve an initial need, stage later hiring decisions, adjust scope or timing, and revisit the forecast. They should also distinguish capacity that is genuinely interchangeable across teams from specialized capacity that cannot be redeployed.

7. When does a gain qualify for planning?

A workflow can inform planning when the evidence supports these checks:

|**Check**              |**Evidence required**                                                                                                                                                                                                                         |
|-----------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|**Defined**            |A specified population, baseline, intervention, and acceptance standard.                                                                                                                                                                      |
|**Measured**           |Comparable total human effort, including failures, review, and follow-up, with sample sizes and an uncertainty range.                                                                                                                         |
|**Repeatable**         |At least two qualified engineers other than the creator have attempted the workflow; representative work across a meaningful period; workflow documented and owned. This minimum is an operating screen, not proof of statistical reliability.|
|**Safe and acceptable**|Required controls pass, and quality, security, and operational results show no material deterioration within the evidence available.                                                                                                          |
|**Applicable**         |Future work volume, eligibility, expected uptake, skills, and timing are supported by the demand forecast.                                                                                                                                    |
|**Net**                |Incremental human support and review are included once; tool and platform costs are separately visible.                                                                                                                                       |

These are decision criteria, not claims of perfect proof. The evidence standard should rise with the size and reversibility of the decision. A small tooling investment can proceed on limited evidence; a large staffing change needs stronger evidence, an uncertainty analysis, and review by Engineering and Finance with appropriate HR and Risk partners.

Planning statuses:

• Exploratory: Promising, insufficient evidence. No quantified capacity credit.
• Measured, conditional: A range is available, but scale, durability, or quality is uncertain. Use scenarios; document assumptions.
• Eligible for planning: Required checks are met for a defined population. Use a justified conservative value or range, reviewed each planning cycle.
• Paused or deteriorating: Workflow changes, quality issues, or new evidence invalidate prior assumptions. Preserve the original estimate and explain the change; suspend the planning credit.

An inconclusive measurement is unknown, not a measured zero. Likewise, a negative effect should be reported, not hidden. If quality is unacceptable, report the effort result and the quality issue separately; do not represent the gain as bankable capacity.

Financial treatment

Distinguish capacity, avoided expenditure, and business value:

• Net capacity hours indicate potential time available for other work.
• Avoided cost is recognized only when a specific expense or planned hire is demonstrably avoided under Finance’s rules.
• Incremental business value requires evidence tied to the additional work or outcome delivered.

Do not multiply all FTE-equivalent capacity by salary and call it savings. Token, license, infrastructure, and enablement spending must be included when evaluating the business case; human effort already deducted in the hour calculation should not be deducted a second time.

Headcount decision policy

Proposed Shopping policy: Every material engineering headcount request includes an AI and capacity assessment. This is a management standard for approval, not a result established by the external studies.

1. Demand: State the work, timing, skills, forecast volume, and the assumptions behind it.
2. Existing capacity: Identify available people and skills, operational obligations, dependencies, and capacity already committed.
3. AI assessment: Identify repeatable workflows applicable to the demand and summarize attempts that failed or remain inconclusive.
4. Measured effect: Show total effort per item for the comparison groups, quality outcomes, sample size, uncertainty, and the portion applicable to the forecast.
5. Net gap: Show low, central, and high capacity scenarios, including adoption, support effort, timing, and skills. Avoid double counting improvements already embedded in the baseline.
6. Recommendation: Describe the remaining need and the proposed hire, staged hire, alternative investment, scope, or timing decision.

Proposed two-quarter rule: For a material ongoing staffing adjustment, a workflow should show sustained evidence in two reporting quarters, pass the repeatability and quality checks, and apply to forecast demand. Two quarters alone do not establish statistical reliability. Engineering and Finance may approve a documented exception with the evidence, risks, and decision owner recorded; HR and Risk participate as appropriate. A lack of evidence should not automatically block a justified hiring request.

Proposed review cadence: Review adoption, flow, quality, and workflow blockers monthly; review pilot results and capacity scenarios quarterly; reassess staffing during each planning cycle and when material assumptions change.

8. What we can learn from Shopify

Shopify provides an operating model for expectations, enablement, experimentation, and leadership engagement. It does not provide a published, audited causal staffing formula for Shopping to copy.

|**Shopify practice**                                                                                                              |**Shopping application**                                                                                                             |
|----------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|
|Leadership made effective AI use an expectation and asked teams to consider AI before requesting resources.                       |Expect a thoughtful AI and capacity case in major requests, with room for inconclusive evidence and legitimate human expertise needs.|
|Leaders demonstrate use and share practical examples.                                                                             |Have engineering leaders share working examples, limitations, and lessons—not just targets.                                          |
|Shopify uses common infrastructure and offers access to multiple tools.                                                           |Provide approved, observable infrastructure and tool choice within enterprise controls.                                              |
|Engineers share workflows and enable one another.                                                                                 |Treat reusable workflows, documentation, support, and ownership as platform investments.                                             |
|Shopify discusses shipped work and uses human judgment; its engineering leader’s roughly 20% estimate is described as an estimate.|Review demonstrations and outcomes alongside measured effort and quality; do not treat Shopify’s estimate as Shopping’s gain.        |

Shopify sources: Bessemer’s interview with Farhan Thawar and First Round’s reporting on adoption.

9. Pilot plan and ownership

First 30 days: establish the measurement

• Select two or three representative use cases and their engineering owners.
• Agree on population, eligibility, acceptance criteria, existing AI baseline, and comparison design.
• Identify data sources and a lightweight effort-capture method.
• Record privacy boundaries, team-level reporting, and use of results; communicate them to participants.
• Review expected sample size and statistical limits with an analyst. Do not imply 90 days guarantees a staffing-quality estimate.

Days 31–90: run and review the pilots

• Assign representative work, collect the same effort categories in both groups, and capture failures and exclusions.
• Review access barriers, workflow quality, and operational issues with engineers.
• Report early effort and acceptance results with uncertainty. Continue the follow-up window for work accepted near the end of the pilot.
• Document reusable workflows and assign a maintainer where results warrant it.

After day 90: decide what to expand or measure further

• Classify each workflow’s evidence status and publish the result, including null and negative findings.
• Expand, revise, or stop the workflow based on usefulness, risk, and cost.
• Continue measuring where samples, follow-up, or repeatability are insufficient.
• Bring eligible scenarios into the next capacity and hiring review, with Finance, Engineering, and the relevant people and risk partners.

|**Role**                                        |**Responsibility**                                                             |
|------------------------------------------------|-------------------------------------------------------------------------------|
|**Engineering leader**                          |Select priorities and own application of results to delivery and staffing.     |
|**Workflow owner**                              |Define eligibility, maintain the process, and record failures and changes.     |
|**Engineering Operations / measurement partner**|Maintain the protocol, data definitions, analysis, uncertainty, and reporting. |
|**Finance**                                     |Review demand assumptions, capacity conversion, costs, and financial treatment.|
|**Risk / Security / HR partners**               |Advise on applicable controls, data use, and workforce decision processes.     |

Appendix A: Leadership scorecard template

|**Field**                                                |**Pilot result**|
|---------------------------------------------------------|----------------|
|Workflow and owner                                       |                |
|Work population and forecast volume                      |                |
|Current baseline and tested intervention                 |                |
|Comparison design and assignment dates                   |                |
|Items assigned / completed / not completed, by group     |                |
|Engineers and teams participating                        |                |
|Average human hours per assigned item, by group          |                |
|Net hours saved per item and uncertainty interval        |                |
|Acceptance, security, incidents, and follow-up window    |                |
|Eligibility and realistic adoption assumptions           |                |
|Incremental support hours and tooling cost               |                |
|Low / central / high annual net capacity scenarios       |                |
|Evidence status and constraints on transfer to other work|                |
|Decision, owner, and next review date                    |                |

Appendix B: Research and supporting sources

These sources support the method and the need for local measurement. They do not establish a universal expected Shopping gain.

1. METR, 2025 — experienced developers on mature open-source projects. A randomized study found tasks took 19% longer with the AI tools studied, despite participants’ expectations of a speedup. Relevant for measuring real work, not treating perception as an objective time estimate, and studying work in context. Small sample and tools from a particular period limit generalization. Paper.
2. METR, 2026 — experiment-design update. Researchers reported later estimates but warned that selection effects and time-measurement challenges made the magnitude unreliable. Relevant to pilot participation, excluded work, and concurrent agent use. Research update.
3. Cui, Demirer et al. — three field experiments. The authors estimate a 26.08% increase in their preferred usage-based estimate for completed tasks, with substantial uncertainty; their principal outcome was completed pull requests. Relevant as evidence that access to an AI assistant can change development activity, not as a direct measure of business value or an FTE conversion. Paper.
4. Paradis et al. — Google enterprise task experiment. The authors estimated approximately 21% less time on a defined task with AI assistance, with a wide confidence interval, and cautioned against assuming the result generalizes. Relevant to experimental design and measurement of task time. Paper.
5. DORA, 2025 — AI-assisted software development. Describes AI as an amplifier of organizational strengths and weaknesses, emphasizing the surrounding delivery system. Useful for defining system-level guardrails; survey associations do not establish a Shopping-specific causal effect. Report.
6. DORA — software delivery performance metrics. Defines measures of delivery throughput and instability. Useful as supporting flow and quality signals, not a substitute for measuring labor effort. Guide.
7. Peng et al. — GitHub Copilot controlled experiment. An early study estimated faster completion of a specific HTTP-server task. Useful for showing the potential of task-level controlled studies; the exercise should not be translated directly to complex Shopping workloads. Paper.
8. Denisov-Blanch, Stanford — developer productivity research presentation. Describes observed variation by project complexity and maturity and the importance of accounting for rework. Treat the presented categories as directional, not forecasts for Shopping. Research presentation.
9. Shopify leadership interviews. Useful descriptions of operating practices and leadership judgment, not independently established causal evidence of staffing impact. Bessemer | First Round.