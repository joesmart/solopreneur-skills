# Quality Gates (10 Acceptance Criteria)

Every design decision or fix plan MUST pass ALL 10 gates. Failing any one → reject and redesign.

| # | Gate | Question to Ask |
|---|------|----------------|
| 1 | **Minimal change** | Are there unnecessary files/classes/methods? Can anything be removed? |
| 2 | **No over-engineering** | Does complexity match the problem scale? |
| 3 | **Root cause fix** | Does it fix the root cause, not just symptoms? |
| 4 | **No band-aid** | Is the logic placed in the architecturally correct location? |
| 5 | **Extensible** | Clear responsibilities, loose coupling, no tech debt creation? |
| 6 | **Performant & stable** | Indexed SQL? No N+1? No large loops? No instability? |
| 7 | **Minimal blast radius** | Does it affect other features? Modified shared methods? |
| 8 | **Best practices** | Using proven frameworks/tools/patterns? Not reinventing the wheel? |
| 9 | **Architectural consistency** | Matches existing project style and patterns? |
| 10 | **Data integrity** | Transactions? Concurrency safety? Idempotency? Cascading effects? |

## Usage

When evaluating multiple candidate solutions, check each candidate against all 10 gates.
For each failing gate, clearly state: "Fails gate #X because [reason]".
Select the solution that passes all 10 gates with minimal complexity.
