# Luma UI Lib

**Luau UI library.** Version `0.1.0-beta`.

Luma is the library

## Included

- Familiar sidebar/card layout, optional theme-aware badge, search, draggable/resizable/minimizable window.
- Game title/icon card above player profile, game detection through Roblox metadata.
- English on every fresh launch; Russian switch and application translation registration.
- Nine theme choices including custom palette. Game/avatar images stay neutral and un-tinted.
- Toggles, sliders, inputs, single-select dropdowns, segmented selectors, HSV/hex color picker, keybinds, buttons, labels, paragraphs, info rows, progress, console, section pages.
- Dashboard, session FPS graph, watermark, keybind overlay, timed/persistent notifications, dialogs, prompts, tooltips, notification history.
- One built-in Settings group: General, Appearance, Overlays, Configs. Local JSON configs. Opt-in UI-only autosave, no automatic startup restoration of gameplay flags.
- Shared backdrop contract for registered visual modules. Dim covers registered GUI visuals; world blur is native. GUI blur mode can Hide/Keep registered visuals.
- Visible `Luma UI Lib · x089` attribution.

## Quick start

Replace OWNER, REPO and COMMIT_SHA with your published repository and **pinned commit**. The placeholders below are not working URLs. Never fetch untrusted moving code without reviewing it.

```luau
local base = "https://raw.githubusercontent.com/OWNER/REPO/COMMIT_SHA/"
local Luma = loadstring(game:HttpGet(base .. "dist/Luma.luau"))()
local Window = Luma:CreateWindow({Title = "My script", ConfigId = "my-script"})
local Tab = Window:Group("Demo"):Tab({Name = "Components", Icon = "folder"})
local Section = Tab:Section({Name = "Controls", Side = "Left"})
Section:Toggle({Name = "Test toggle", Flag = "demo_toggle", Default = false})
Window:Notify({Title = "Luma", Content = "has been loaded.", Duration = 3})
```

A configurable loader template is included at `examples/Loader.luau`; it deliberately refuses to run until your own repository values are filled.

For the full UI demo, run `examples/Demo.luau` as a factory with `Luma`:

```luau
loadstring(game:HttpGet(base .. "examples/Demo.luau"))()(Luma)
```

Use either the minimal example OR the full demo on a fresh library object; `CreateWindow` makes one window per loaded instance. `Luma.luau` alone returns API and intentionally does not make a menu.

## Requirements & limits

Native Roblox client GUI services. The HTTP/loadstring loader is for an executor environment. Filesystem / custom asset / clipboard / identifyexecutor capabilities are optional and degrade separately. Embedded icons use a local PNG + `getcustomasset`; without it, fallback glyphs appear.

This is a new API, **not a drop-in wrapper for earlier menus**. Multi-select dropdowns, arbitrary external fonts, old UI sound/particle/style systems and custom profile editor are not included. Mobile/touch is not qualified. Dashboard memory is unavailable and shows `--` rather than a fabricated number.

No private telemetry endpoints, IP/geolocation collection, HWID collection, webhook, key gate or third-party runtime code loader are implemented in the library. Roblox metadata/assets still use Roblox services. Local configs and embedded icon PNG are written only under `LumaUI/`.

Release uses basic identifier obfuscation/token compaction. Client code can be reverse engineered; this is **not** an anti-dump guarantee. Stronger optional external processing must be independently tested.

## Docs

- [API](docs/API.md)

## License

Luma Community Use License: free use in scripts, visible attribution and notices retained. Not an OSI-open-source license. Modified/deobfuscated library redistribution requires permission except where applicable law permits otherwise. Review [LICENSE](LICENSE). Third-party Lucide/Feather artwork remains separately licensed under ISC/MIT; see [notices](third-party/NOTICE.md).
