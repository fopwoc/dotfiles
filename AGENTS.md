# General

- Always respond in English unless I explicitly request another language. Never infer the response language from the language of my messages or referenced content.
- Do not spawn or delegate work to subagents unless I explicitly ask for it.

## Agents

Do not spawn or delegate work to subagents unless I explicitly ask for it.

# Instructions for code

## Things I believe in

- I love monorepositories.
- Unix is cool. Do not support Windows unless I explicitly ask for it.
- Docker is a good way to provide reproducible build/run options for others. Exception: platform/vendor-specific projects such as Xcode or Android apps, where the native toolchain is the natural environment.

## Skills

- Kotlin: use `kotlin` as the base skill and combine it with specialized skills such as `kotlin-backend` or `jetpack-compose` when applicable.
- Use other specialized skills when their description matches the task.
- Respect skills marked as explicit-only; do not apply them unless explicitly requested.

## General code conventions

These conventions apply to every stack.

- Follow a `layer-first` code hierarchy. Organize code by responsibility and usage instead of accumulating unrelated files in one directory or unrelated declarations in one file.
- **Single file, single responsibility.** Treat a file as one cohesive unit of code with one clear owner and purpose. Keep one primary class, interface, model, component, or substantial function per file. Code that exists only to support, test, or demonstrate that unit may stay with it; independent responsibilities belong in separate files.
- Decompose code by responsibility and ownership, not merely by size. A large cohesive function is preferable to several trivial functions that only fragment its logic.
- Put genuinely general-purpose helpers in a project-wide or module-wide `utils` directory.
- Embrace expressive and advanced language features when they enable more elegant, concise, or type-safe solutions, even when simpler syntax could do the job.
- Prefer developer convenience and simple solutions over architectural ceremony. Accept complexity when necessary or when it provides significant optimization.
- Prefer self-explanatory code over comments. Comment non-obvious reasoning or genuinely complex behavior.
- Prefer the latest stable releases of toolchains, languages, libraries, and dependencies unless compatibility or project constraints require otherwise.

## Developer experience

Treat internal components as small libraries. Design foolproof APIs where the language does as much correctness work as practical:

- Prefer correctness by construction.
- Encode invariants in the type system when practical.
- Prefer misuse-resistant, type-safe APIs with compile-time guarantees.

## Architecture

Identify meaningful architectural boundaries and keep them explicit.

For major subsystems, prefer narrow high-level APIs that hide implementation details. When experimentation, replacement, or substantial rework is realistic, keep implementations replaceable without affecting consumers.

Do not introduce interfaces, facades, or abstraction layers solely for theoretical replaceability.

Within cohesive implementations, prefer direct and simple integration.

## Existing code

Sanity-check these instructions against the current codebase. Follow existing conventions and patterns unless I explicitly ask otherwise.

## Logs

Cover applications with useful logs. Use standard `debug`, `info`, `warn`, and `error` levels.

- Default log level is `error`. Make the log level configurable through environment/config. Exception: Android `logcat`; let it work as is.
- Log the application startup sequence at `info`: application entry, each meaningful initialization step, and final readiness. Keep trivial initialization silent.
- Use log tags/categories for major application layers and boundaries to make logs easy to filter.
- Log unhandled and unexpected exceptions at `error` at the layer where they are handled. Do not log the same exception repeatedly across layers.
- Add `debug` logs around complex behavior where they help trace execution and state.
- When supported, derive logger names/tags automatically from the declaring or runtime class. Prefer class-based logger identity over manual tags so log output maps directly back to the code.

## Tests

Test behavior that can plausibly regress without an obvious compile-time failure.

- Test complex logic.
- Do not test trivial mappings or similar code where incorrect structural changes would normally fail compilation.
- Test formatting and similar helpers through representative inputs and outputs rather than implementation details.

## Git

By default, treat Git as read-only. Use Git freely for inspection, but do not modify repository state unless explicitly requested or working in a dedicated worktree.

When working in a dedicated worktree:

- Use a temporary `worktree/<task-name>` branch, where `<task-name>` is short descriptive `kebab-case`, e.g. `new-card-style`, `fix-client-list`.
- Do not use prefixes such as `feat/`, `fix/`, `chore/`, or usernames unless explicitly requested.
- Treat the corresponding `<task-name>` branch as the final task branch.
- Commit completed work to the worktree branch.
- After verification, create or fast-forward the final task branch to the completed worktree branch without checking it out or modifying the primary working tree.
- Never overwrite or rewrite divergent history on the final task branch.
- Keep commits local; do not push to remotes.
- Leave the worktree clean before finishing.
- Use very short, plain commit messages, e.g. `new card style in settings`, `fix client form list`, `locale typo`.
- If commit does multiple major things at once you can combine 2 short messages with `+`, e.g. `fix conditional navigation in adaptive + redesign TopAppBar` 
- Do not use Conventional Commits or prefixes such as `feat:`, `fix:`, or `chore:`.

Outside a dedicated worktree, do not perform Git operations that modify repository state unless explicitly requested.

# Conversation and planning

Be concise by default. I will ask when I want more detail.

Ask when important requirements are unclear. Do not guess when the answer could materially affect the design or implementation.

@/Users/aspirin/.codex/RTK.md
