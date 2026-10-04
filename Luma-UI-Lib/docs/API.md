# API — 0.1.0-beta

This is a fresh API, not a compatibility shim. Methods below are public, stable names retained by the release build. One loaded instance creates one window. Keep your application's logic separate.

## Window

```luau
local W=Luma:CreateWindow({
    Title="My script",       -- application subtitle, library brand stays Luma
    Subtitle="UI Library",  -- game card subline
    Badge="Zero",           -- optional; omit for plain Luma UI Lib
    ConfigId="my-script",   -- safe local config namespace
    Theme="Dark", MenuKey="RightShift",
    Width=900, Height=660, OpenOnLoad=true,
})
```

Width 720..1400, height 460..1000; fit scale calculated at creation. The window can be dragged by sidebar header and resized from the lower-right grip. Fresh language is always English.

`Toggle(boolean?)`, `Minimize(boolean?)`, `SetMenuKey(keyName)`, `SetLanguage("English"|"Russian")`, `GetLanguage()`, `SetTheme(name)`, `SetAccent(Color3|hex)`, `SetCustomPalette({window="#...",panel="#...",card="#...",text="#...",muted="#...",accent="#..."})`, `SetFont(name)`.

Fonts: Gotham, SourceSans, Roboto, Ubuntu, Code. Gotham preserves each control's original weight. Custom palette only affects semantic theme targets, never player/game thumbnails. Nine themes: Dark, Light, Gray, Blue, Green, Purple, Orange, Pink, Custom. Custom inherits the last non-custom base.

`AddTranslations("Russian",{["My caption"]="Моя надпись"})`: register BEFORE adding controls where practical. Proper game/player names are not translated. Application strings not registered remain unchanged. Localization is not machine translation.

`GetGameContext()` → `{Name,Icon?,PlaceId,GameId}`. Metadata fetched asynchronously; `SetGameContext(context)` overrides the card. No immediate-name guarantee while Roblox metadata is loading.

## Tabs / sections

```luau
local group=W:Group("Demo")
local tab=group:Tab({Name="Components",Icon="folder"})
local left=tab:Section({Name="Controls",Side="Left"})
local right=tab:Section("Actions","Right")
local sectionWithPages=tab:Section("Pages","Left")
sectionWithPages:Page("First"):Label("First")
sectionWithPages:Page("Second"):Label("Second")
W:SelectTab(tab)
```

`W:AddTab(options)`, `W:SettingsTab(options)`, `tab:Select()`, `section:SetVisible(boolean)`.
Built-in Settings is already present. Do not create another application Settings group for the same controls.
Tab frames are built lazily and reused until their content is changed. Adding controls schedules one deferred rebuild rather than one synchronous full-window rebuild per addition.

Icons supported: home, user, eye, settings, folder, gamepad, search, bell, keyboard, palette, minus, x, check, chevron, maximize. Their embedded official artwork has a glyph fallback.

## Elements

Unique `Flag` strings are required for controls you want to access/configure; automatic flags otherwise. Reserve `__luma_` for library controls. Common: `Name`, `Flag`, `NoSave`, `Visible`, `Disabled`, `Tooltip`/`Description`, `Callback`.

| Method | Specific options |
|---|---|
| Toggle | Default=false, Keybind={Key="F2",Mode="Toggle" or "Hold"} |
| Slider | Min=0, Max=100, Step=1, Default=25; Step must be positive, Max greater than Min |
| Dropdown | Values={"First","Second"}, Default="First"; single-select only |
| Segmented | Values={"First","Second"}, Default="First"; keep choices short |
| Input | Default="", Placeholder="Enter text", Live=false |
| ColorPicker | Default=Color3 or six-digit hex; HSV drag + hex field |
| Keybind | Default="F1", Callback fires on press; Backspace clears, Escape cancels rebinding |
| Button | Callback; button press invokes callback, not OnChanged |
| Label | Text or string shorthand |
| Paragraph | Name, Content |
| Info | Name, Value |
| Progress | Value=50, Max=100 at construction; Set accepts ratio 0..1 |
| Console | Content, Name; bounded 50-line log |

```luau
local t=left:Toggle({Name="Test toggle",Flag="test",Default=false})
t:OnChanged(function(enabled)print(enabled)end)
t:AddKeybind({Key="F2",Mode="Hold"})
t:Set(false)
local connection=W:WatchFlag("test",function(value)print(value)end)
connection:Disconnect()
```

Element methods: `Get()`, `Set(value)` / `SetValue(value)`, `OnChanged(callback)`, `OnPressed(callback)` for Keybind, `AddKeybind(...)`, `SetVisible`, `SetDisabled`, `SetName`, `SetText`, `SetContent`, `SetValues` for dropdowns. Console: `Append(message)`, aliases Log/Warn/Error/Success (plain text, not semantic colored logging), `Clear()`.

Callback handlers run synchronously under pcall; do not put expensive/yielding operations directly in an input callback. Spawn application work and manage its lifetime yourself. Keybinds are keyboard KeyCode names, not mouse buttons in this beta. Typing in a focused TextBox suppresses feature binds. An opt-in Hold toggle releases on key-up.

`W:SetFlag(flag,value)`, `W:GetFlag(flag)`, `W:GetElement(flag)`, `W.Flags`. All ordinary toggles default OFF; `Default=true` is an explicit application opt-in. Library UI options such as dim/watermark may default ON. The library never auto-loads application configs or enables gameplay modules at startup.

## Dialogs / notifications

```luau
local toast=W:Notify({Title="Luma",Content="has been loaded.",Duration=3})
-- optional Persist=true; then caller must Dismiss()
toast:SetTitle("Luma");toast:SetBody("Ready");toast:Dismiss()
W:Dialog({Title="Luma",Content="Information",Buttons={{Name="Close"}}})
W:Prompt({Title="Name",Default="",Placeholder="Enter text",Callback=function(value)print(value)end})
```

Notify duration 0.1..60 seconds, default 4; maximum five visible, bounded history. Toast root and stroke are destroyed together. `GetNotificationCount()` counts live records. Kind currently does not choose an independent notification layout.
Dialog: optional `Dismissable=false`, `Width`, `Buttons={{Name,Callback}}`, `Validate(input) -> bool,message`. `Prompt` generates Cancel/Apply. Returns handle `Close()`.
`AttachTooltip(guiObject,caption)` needs the actual rendered object; an element's `.row` is available after its tab is selected. Tooltip uses 0.4s delay.

## Configs

`Snapshot()` → `luma-ui/1` document; `ApplyConfig(document)` → success,error. `ExportConfig()` / `ImportConfig(json)`, `SaveConfig(name)` / `LoadConfig(name)` / `ListConfigs()` use `LumaUI/configs/<ConfigId>_<name>.json`. Input validation rejects malformed known values before applying them; application callbacks can still fail independently. Unknown flags are ignored. Names cannot contain directory separators; maximum 64 safe ASCII name characters.

No language persistence by design: English always on fresh launch. `NoSave=true` excludes controls. Manual LoadConfig can turn application flags on; don't call it automatically if your script must start with every gameplay feature OFF.
`SaveUIPreferences()` / `LoadUIPreferences()` operate only on library-reserved flags. Opt-in “Autosave UI only” writes every 10 seconds and on unload; it does not save gameplay flags and is not enabled by default. Preferences are only restored explicitly.

## Backdrop / lifecycle

See VISUALS.md. `OnMenuOpen`, `OnMenuClose`, `WatchFlag` return disconnectable connections. `OnUnload(callback)` registers application cleanup. `Eject()` / `Unload()` / `Destroy()` disconnects library input handlers, restores registered visual states, removes owned GUI and owned BlurEffect. It does not destroy external visual modules; caller owns their roots.
