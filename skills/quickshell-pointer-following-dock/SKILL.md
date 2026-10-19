---
name: quickshell-pointer-following-dock
description: "Implement or troubleshoot an End-4 Quickshell dock that follows the pointer across Hyprland monitors without resizing windows, including auto-hide, its searchable app drawer, and runtime verification."
---

# Seamless pointer-following End-4 dock

Read the `omarchy` skill before desktop configuration changes. Preserve pins and appearance; back up touched files.

## Relevant components

On the configured workstation:
- `~/.config/quickshell/ii/modules/ii/dock/Dock.qml`: dock window, reveal logic, and pointer tracking.
- Adjacent `AppDrawer.qml`: installed-app grid opened by the dock's nine-dot button.
- `~/.config/illogical-impulse/config.json`: dock options; `dock.screenList: []` permits all monitors.

Confirm current files before editing; these paths describe the verified integration, not upstream guarantees.

## Prevent cross-monitor refresh/retiling

A pinned dock with a nonzero exclusive zone changes the usable desktop area when it moves. Hyprland consequently resizes tiled windows on both monitors. For seamless movement:

1. Keep one persistent `PanelWindow` and bind its `screen` to the selected monitor. Do not recreate a `Variants` instance whenever the pointer changes screens.
2. Set `exclusiveZone: 0`. Application windows may extend behind the dock; use auto-hide when this obstructs typing.
3. Determine the pointer's monitor from `hyprctl cursorpos -j` and monitor bounds. Account for scale and quarter-turn transforms: odd transforms swap width and height before dividing by scale. Use half-open coordinate bounds.
4. Do not substitute the focused monitor for pointer location; movement over wallpaper or layer surfaces need not focus an application.
5. The verified implementation polls every 150 ms only when enabled, unlocked, and multiple eligible monitors exist. Prevent overlapping cursor processes. Pause movement while the app drawer or dock preview/menu is being used.
6. Respect configured screen allowlists and provide a valid fallback when monitors disappear.

## Auto-hide without obstructing typing

The existing dock already animates its hover region downward and updates its input mask; reuse this rather than inventing another animation or hiding the entire PanelWindow.

- Set `dock.hoverToReveal: true` and `dock.pinnedOnStartup: false` in the JSON config. The verified `hoverRegionHeight: 2` leaves a bottom-edge trigger only across the centered dock width.
- The reveal expression should allow manual pinning, the open app drawer, the configured hover region, and `dockApps.requestDockShow` (preview/menu interaction).
- Remove the unconditional `!ToplevelManager.activeToplevel?.activated` reveal fallback for hover-only behavior: losing app focus must not spontaneously expose the dock over text.
- Keep `exclusiveZone: 0`; auto-hide must not resize application windows.
- The pin button is a temporary override; the unpinned startup preference persists across launches.
- Verify hover at the bottom-center edge reveals the dock, moving away fully hides it, and both monitors work. Merely inspecting layer dimensions is insufficient: the PanelWindow remains present while its contents slide out of view.
- During synthetic input, landing exactly on the edge while the dock transfers monitors may need one additional small pointer motion after transfer to generate a hover event. Normal mouse movement generates multiple events.

## Installed-app drawer integration

- Use the existing `AppSearch.list`/desktop-entry APIs rather than window-manager toplevels. The latter lists open windows, not installed applications.
- Open the drawer on the dock's current screen; support search, scrolling, keyboard launch, Escape, and outside-click dismissal.
- Register only the drawer with `GlobalFocusGrab.addDismissable`; remove that same registration on close. Do not globally dismiss unrelated UI.
- Close on screen lock or removal of its target monitor.
- Existing `IconToolbarButton`/toolbar widgets can inherit height-filling behavior. In a vertical layout, explicitly constrain the header row and search row and allocate remaining height to the grid. Otherwise the header can absorb nearly the entire panel with no QML warning.
- A newly added sibling QML component may produce `AppDrawer is not a type` during hot reload. Restart only the End-4 Quickshell instance to refresh component discovery; keep the desktop process persistent afterward.

## Runtime proof

1. Save each existing client's address, position, and size from `hyprctl clients -j`.
2. Move the pointer to each monitor. After the polling interval and surface transfer settle, inspect `hyprctl layers -j`: exactly one dock, on the intended monitor.
3. Assert existing client positions/sizes remain identical in both directions. Check monitor reserved areas: moving the dock must not add/remove a bottom reservation.
4. Click nine-dot on each screen and inspect actual screenshots. Verify installed-app grid, search with zero results, one real launch, wheel scrolling, and Escape dismissal. A successful QML load does not establish correct layout.
5. Native virtual-pointer smoke input needs a settling interval before clicking a newly transferred dock; moving and clicking immediately can hit the application beneath it. A roughly one-second settle was sufficient in verification. Keep the input client alive during the scenario and capture evidence immediately because physical user input can move the pointer between tool calls.
6. For auto-hide, capture the bottom strip after hovering and after leaving. Crop the actual screenshot when the full dual-monitor image is too reduced to distinguish dock contents from images displayed inside terminals.
7. Check fresh Quickshell logs. Close only applications created by the smoke scenario, stop temporary input services, and remove temporary drivers/screenshots. Leave the desktop shell running.

Hyprland on this workstation uses Lua dispatch syntax; legacy `hyprctl dispatch movecursor ...` is not supported. Use a supported native input mechanism rather than repeatedly retrying the old syntax.
