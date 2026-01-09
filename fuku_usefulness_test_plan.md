# Fuku Plugin Usefulness Test Plan

## Objective
Test if the Fuku plugin (with MiniMax integration) is useful for Circe's Garden development and testing.

## Test Approach

### Phase 1: Plugin Activation
1. Enable Fuku plugin in Godot
2. Verify panel appears
3. Configure MiniMax API key
4. Test connection and model fetching

### Phase 2: Practical Questions
Ask Fuku real questions about the game code:

**GDScript Questions:**
- "How do I fix quest flag flow in npc_base.gd?"
- "Explain the difference between _ready() and _init() in Godot"
- "Help me optimize this minigame code"

**Game-Specific Debugging:**
- Show actual error messages from tests
- Ask about quest flow issues
- Get help with UI problems

**Testing Help:**
- "How do I write a better test for dialogue flow?"
- "Best practices for Godot testing"
- "Explain the testing framework in this project"

### Phase 3: Compare to Alternatives
- MCP testing tools
- Claude Code (current conversation)
- Manual debugging

## Success Criteria
✅ Provides accurate GDScript help
✅ Understands game-specific context
✅ Faster than manual research
✅ Integrates well with Godot workflow
✅ Worth the API cost

## Questions to Ask Fuku

### Question 1: Game Logic
"Explain how quest flags work in Circe's Garden. I see `quest_1_active`, `quest_1_complete` patterns. Is this the best approach?"

### Question 2: Code Optimization
"Look at this code from npc_base.gd. How can I improve the dialogue routing logic?"

### Question 3: Testing
"How should I structure tests for Godot games? What's the difference between headless and headed testing?"

### Question 4: Godot Best Practices
"What are the most important Godot 4.5 patterns I should follow for game development?"

### Question 5: Specific Error
"I'm getting this error: [actual error]. Help me debug it."

## Timeline
- Setup: 5 minutes
- Testing: 30 minutes
- Evaluation: 15 minutes

## Deliverable
Report on whether Fuku is useful for this project's development workflow.
