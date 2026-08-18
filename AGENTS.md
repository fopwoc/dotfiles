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
- **Single file, single responsibility.** Usually keep one primary class, model, or substantial function per file and name the file after it. Small cohesive top-level functions may share a file named after their group or main concept.
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

# Conversation and planning

Be concise by default. I will ask when I want more detail.

Ask when important requirements are unclear. Do not guess when the answer could materially affect the design or implementation.
