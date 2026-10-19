---
name: omarchy-end4-hybrid-bar
description: "Maintain an Omarchy top bar alongside End-4 Quickshell sidebars and cheat sheet; custom resource modules, outside-click dismissal, wheel scrolling, and runtime verification."
---

# Omarchy + End-4 hybrid desktop

Read `skill://omarchy` and its relevant topic guides first. Never edit `/usr/share/omarchy`; it is reference-only.

## Identify the two shells

- Omarchy: `/usr/share/omarchy/shell/shell.qml`, configured by `~/.config/omarchy/shell.json`.
- End-4: `~/.config/quickshell/ii/shell.qml`; resolve symlinks before editing.
- `qs list --all` lists both instances. Logs: `qs -c ii log -t 30` and `qs -p /usr/share/omarchy/shell/shell.qml log -t 30`.
- `hyprctl layers -j` distinguishes `omarchy-bar`, `quickshell:bar`, `quickshell:sidebarRight`, and `quickshell:cheatsheet`.

## Add End-4 access without replacing Omarchy's bar

Use Omarchy's supported custom QML modules under `~/.config/omarchy/bar/modules/` and entries in `bar.layout.right`: `{ "id": "end4-controls", "type": "qml" }`.

A `BarIconButton` imported from `qs.Ui` can launch `qs -c ii ipc call sidebarRight toggle` via `Quickshell.execDetached`. Place it last for a far-right control-center button. Reuse the existing sidebar instead of reimplementing its calendar, stay-awake, audio, network, or session controls.

For resource widgets, use a shared local QML singleton registered in `qmldir`, so both monitors use one collector. Poll `/proc/meminfo`, `/proc/stat`, and GPU sysfs using `FileView`; locate boot-dependent hwmon sensor paths once. CPU utilization must avoid double-counting guest time, treat iowait as idle, and determine GPU paths from the actual machine.

Read `/usr/share/omarchy/shell/plugins/bar/README.md` for the module contract. Custom tooltip targets must expose `tooltipHovered`; the host checks it before showing the tooltip. Use `bar.showTooltip(target, text)` / `bar.hideTooltip(target)`. A newly created external module can fail with misleading `File name case mismatch` because the running engine cached the directory; if paths and case are correct, `omarchy restart shell` refreshes discovery. Inspect fresh logs afterward.

## Right sidebar outside-click dismissal

`modules/ii/sidebarRight/SidebarRight.qml` may have visibility and Escape handling but no outside-click grab. On this workstation its existing `PanelWindow` now contains:

```qml
HyprlandFocusGrab {
    active: panelWindow.visible
    windows: [panelWindow]
    onCleared: panelWindow.hide()
}
```

`hide()` sets `GlobalStates.sidebarRightOpen = false`. This follows the repository's per-panel control-center grab pattern. Keep the allowed window set limited to the panel when clicks anywhere else must dismiss it; the shared `GlobalFocusGrab` also permits persistent surfaces such as the dock. Do not modify the shared service for this local requirement. Inspect current imports and window structure before applying.

Verify actual clicks, not only IPC: open from the Omarchy top-bar button; switch an internal tab and confirm the panel stays open; restore Calendar; click an application outside the panel on the same monitor, then repeat on the other monitor. Check `quickshell:sidebarRight` disappears from layers. Verify repeated top-bar toggling still opens/closes without immediately reopening due to dismissal. These scenarios passed for the above persistent-window binding. Avoid power/network controls in smoke tests.

## Fix End-4 cheat-sheet wheel navigation locally

`StyledFlickable.qml` may consume vertical wheel events exclusively into `contentY`. A cheat sheet laid out using `Flow.TopToBottom` extends in `contentX`, so scrolling appears inert.

In the cheat-sheet view only:
- Use a plain two-axis `Flickable` with a local wheel handler.
- Map ordinary vertical wheel to horizontal navigation; preserve native horizontal deltas.
- Use Shift+wheel for vertical overflow.
- Clamp both axes to content bounds and cancel kinetic flick before wheel changes.
- Include the tallest card in `contentHeight`, and provide horizontal/vertical `StyledScrollBar` controls.
- Preserve the global StyledFlickable behavior elsewhere.

For Lua-based Omarchy, `hyprctl binds -j` can omit original keys for `code:` bindings. `omarchy menu keybindings --print` recovers these keys and is the installed authoritative display source. Never discard shortcuts merely because their names contain numbers or directions.

## Verify the real surfaces

- Verify JSON with `jq empty`; after Hyprland config edits, run `hyprctl reload` and `hyprctl configerrors`.
- Open sidebars/cheat sheet through their IPC, inspect layers, and capture with `grim`.
- Determine which monitor actually contains the cheat sheet before testing or capturing it; it follows focus and need not open on the primary screen.
- Exercise real vertical wheel input in both directions, reach the final category, return to the first, and verify tall-card overflow on the smaller monitor.
- Verify real hover tooltips and the far-right click, not merely IPC calls.
- If needed, a throwaway Wayland virtual-pointer driver can emit motion/button/axis_discrete/frame via `wlr-virtual-pointer-unstable-v1`; capture evidence before destroying the virtual pointer. Keep opening, input, and capture close together: real user clicks can dismiss the panel between separate tool calls. Remove smoke drivers and captures afterward.
- Do not click reboot/shutdown during verification.

## Bar visibility caveat

Read the installed toggle scripts. In the observed installation, `omarchy toggle bar` wraps the **bar-off** flag: `off` removes that flag and shows the bar, while `on` sets it and hides the bar. Do not infer semantics from the command wording. Confirm the visible bar is at y=0 in layer output and avoid stacking both bars.
