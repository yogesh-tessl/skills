---
name: clarify
description: "Improves unclear UX copy, error messages, microcopy, labels, and instructions to make interfaces easier to understand and use. Use when the user asks to improve button text, error messages, tooltips, placeholder text, form labels, empty states, loading messages, confirmation dialogs, toast messages, onboarding flows, or any user-facing interface copy."
metadata:
  user-invocable: true
  args:
    - name: target
      description: The feature or component with unclear copy (optional)
      required: false
---

Identify and improve unclear, confusing, or poorly written interface text to make the product easier to understand and use.

## Assess Current Copy

Find clarity problems in the codebase:

- **Jargon**: Technical terms users will not understand
- **Ambiguity**: Text with multiple interpretations
- **Passive voice**: "Your file has been uploaded" vs "We uploaded your file"
- **Missing context**: Users do not know what to do or why
- **Tone mismatch**: Too formal, too casual, or inappropriate for the situation

Understand the context: audience expertise level, user emotional state, desired action, and any space or character constraints.

## Plan Improvements

For each piece of copy, determine:
- **Primary message**: The ONE thing users need to know
- **Action needed**: What should users do next
- **Tone**: Helpful, apologetic, encouraging — match the moment
- **Constraints**: Character limits, brand voice, localization needs

## Improve Copy

Apply improvements using this before/after pattern for each copy type:

| Type | Before | After |
|------|--------|-------|
| Error | "Error 403: Forbidden" | "You don't have permission to view this page. Contact your admin for access." |
| Error | "Invalid input" | "Email addresses need an @ symbol. Try: name@example.com" |
| Form label | "DOB (MM/DD/YYYY)" | "Date of birth" (with format placeholder) |
| Form label | "Enter value here" | "Your email address" |
| Button | "Submit" / "OK" | "Create account" / "Save changes" |
| Help text | "This is the username field" | "Choose a username. You can change this later in Settings." |
| Empty state | "No items" | "No projects yet. Create your first project to get started." |
| Success | "Success" | "Settings saved! Your changes take effect immediately." |
| Loading | "Loading..." | "Analyzing your data — usually takes 30-60 seconds" |
| Confirmation | "Are you sure?" | "Delete 'Project Alpha'? This can't be undone." |
| Navigation | "Items" / "Things" | "Your projects" / "Team members" |

## Clarity Principles

1. **Be specific**: "Enter email" not "Enter value"
2. **Be concise**: Cut unnecessary words without sacrificing clarity
3. **Be active**: "Save changes" not "Changes will be saved"
4. **Be helpful**: Tell users what to do, not just what happened
5. **Be consistent**: Same terms throughout — do not vary for variety

**NEVER**: Use jargon without explanation, blame users, leave errors unexplained, use placeholders as the only labels, or repeat the same information in multiple places.

## Output Format

Present improvements as a structured table:

```markdown
| Location | Current Copy | Improved Copy | Rationale |
|----------|-------------|---------------|-----------|
| login error | "Invalid credentials" | "Wrong email or password. Try again or reset your password." | Explains cause + suggests fix |
```

## Verify

- **Comprehension**: Understandable without context?
- **Actionability**: Users know what to do next?
- **Brevity**: As short as possible while remaining clear?
- **Consistency**: Matches terminology elsewhere in the product?
- **Tone**: Appropriate for the emotional moment?
