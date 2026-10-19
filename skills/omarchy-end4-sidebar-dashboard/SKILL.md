---
name: omarchy-end4-sidebar-dashboard
description: "Maintain detailed End-4 sidebar hardware, Tailscale, and AI allowance widgets, including Codex app-server refresh and QML sequence rendering pitfalls."
---

# End-4 sidebar status dashboard

Read `skill://omarchy` and `skill://omarchy-end4-hybrid-bar` before changes. Never edit packaged `/usr/share/omarchy` files. Inspect current sources; preserve unrelated user changes.

## Integration on this workstation

Under `~/.config/quickshell/ii/modules/ii/sidebarRight/`:
- `CenterWidgetGroup.qml`: vertically scrollable cards between existing quick controls and calendar; notification-history action retained.
- `DashboardCard.qml`, `DashboardRow.qml`: shared themed card and detail-row components.
- `HardwareCards.qml`: imports the existing `~/.config/omarchy/bar/modules/ResourceMetrics.qml` singleton, rather than duplicating sensor parsing.
- `AiUsageCard.qml`, `ai-usage-refresh.py`: cached token statistics plus independently refreshed subscription allowance.
- `TailscaleCard.qml`: local connection details and supported Omarchy controls.

Cards receive `active: GlobalStates.sidebarRightOpen`. AI and Tailscale timers run only while active. Refresh on opening. Hardware's shared source refreshes every 3 seconds; AI allowance every 60 seconds; Tailscale every 10 seconds. Existing outside-click dismissal stays in `SidebarRight.qml`.

## Codex allowance source and local reader repair

The installed Omarchy usage collector uses supported Codex app-server RPC. Its reader can time out when `select.select(proc.stdout)` is combined with buffered `TextIOWrapper.readline()`: asynchronous notifications and responses arriving together may leave a response in Python's buffer while the fd no longer looks readable.

The local helper uses `codex -s read-only -a on-request app-server`, sends `initialize`, `initialized`, `account/read`, then `account/rateLimits/read`. Read unbuffered fd bytes with `os.read`, frame complete newline-delimited JSON messages, retain unread bytes between requests, skip notifications, and match response IDs. Use bounded waits and terminate/wait/kill/wait cleanup. Never read or copy authentication credentials; Codex handles its own authenticated session.

The helper:
1. Serializes itself with `.sidebar-refresh.lock` in the usage directory.
2. Publishes fresh Codex allowance first, before waiting for the stock collector.
3. Atomically writes `.codex-sidebar-allowance.json` under `~/.local/state/omarchy/agents/usage/`.
4. Runs `omarchy-agent-usage-update --limits-only`, respecting disabled-provider arguments.

The sidecar avoids racing the packaged updater's `codex.json` writes. The widget overlays allowance metadata onto independently watched stock token records. It preserves last-success time and reports failures/staleness. Do not claim a last-attempt timestamp proves a successful quota refresh.

A newer failed stock probe must not discard an older successful Codex sidecar quota; a newer successful stock quota does supersede it. Keep stock transcript totals separate from quota freshness. Enabled providers with zero usage remain visible: Claude without authentication is sign-in-required, and Fireworks without credentials is not configured. Fireworks prepaid billing is not a subscription quota, and a failed balance read is distinct from a failed billing-usage read. Use official private login flows (`claude auth login`, `opencode auth login --provider fireworks-ai`); never transfer credentials between applications.

Subscription allowance percentages are not remaining-token counts. Render only reported windows; do not invent a session allowance when the API reports only weekly usage. Token totals include cache tokens and follow the stock transcript cache cadence, potentially lagging 15 minutes. Label them separately.

## Claude Code allowance and login keepalive

`AiUsageCard.qml` shows Claude Code (stock `claude.json`; last successful probe time from `~/.cache/omarchy/agent-usage/claude-limits.json` `fetchedAtMs`) above Codex. The always-on `omarchy-ai-usage-refresh.timer` (3 min) runs the helper, which collects `codex claude`.

The stock Claude collector only reads Claude Code's saved OAuth login; it reports "Sign-in expired" once `expiresAt` passes (~8 h after the CLI last ran). `claude auth status`, `claude doctor`, `claude mcp list`, and `claude -p /usage` do not renew it; a real print-mode request does. The helper reads only `expiresAt` and, within 4 min of expiry, runs one unsaved Haiku request (`--tools "" --setting-sources local --strict-mcp-config --disable-slash-commands --no-session-persistence`, empty temp cwd) so the CLI renews its own login. After expiry, retries are throttled to 10 min via `.claude-sign-in-refresh`. `--bare` cannot be used: it disables OAuth. Never refresh or copy the token yourself.

## QML pitfalls observed in runtime

- Nested arrays passed through `Repeater` model data can become QML sequences: `Array.isArray(record.limits)` incorrectly rejected valid allowance windows. `Array.from(record.limits || [])` rendered them correctly.
- In this integration, the literal `file:///home/extremis/.config/omarchy/bar/modules` import loaded live hardware data. A bare absolute path was rejected as an invalid import URL. A relative path appeared to load but yielded missing readings. Quickshell's scanner may warn about the file URL even though Qt loads it successfully; do not replace a working import just to silence that warning. Verify actual sensor values after any import change.
- Constrain header/button heights when using height-filling widgets in vertical layouts.
- Avoid detail-row preferred widths bound proportionally to their own current width, which can feed implicit-size loops; use fixed layout weights and minimum width zero.
- Check muted text visually against the current theme. Dashboard details use an alpha-adjusted `colOnLayer1` for readable contrast.
- Advance `nowMs` before assigning newly loaded allowance records. Otherwise a successful record can appear to come from the future until the next clock tick, producing a false clock-mismatch/stale label.
- A horizontal `Revealer` containing a vertically centered label must not derive its height from `childrenRect.height`: label position then depends on that same height. `FloatingActionButton.qml` gives its revealer `implicitHeight: buttonText.implicitHeight`, breaking the cycle without changing the shared revealer.

## Tailscale

Use `tailscale status --json` for actual state. Display not installed, disconnected, login-needed, unavailable, and connected states truthfully. The machine's installation/connection state can change during work; do not retain an old observation as a permanent fact.

Supported installed panel IPC: `omarchy-shell omarchy.tailscale status|open|up|down|refresh`. Delegate activation/login to that existing implementation. Installation can be offered through an interactive terminal running `omarchy install service tailscale`; do not install or disconnect the user's network merely to verify a widget.

## Verification

Restart only End-4 if newly added QML types are not discovered; retain its persistent desktop service. Open the actual sidebar, inspect fresh logs, and capture its real surface. Check quota meters/reset times, grouped token totals, numeric hardware readings, Tailscale details, scrolling, and preserved outside-click dismissal. Compare the sidecar's last-success timestamp before/after opening.

A valid periodic-refresh check must leave the same panel activation open for the full interval. If the user or smoke input closes/reopens it, advancing timestamps prove refresh-on-open, not the periodic timer. Keep pointer input and captures close together because concurrent physical input can dismiss the panel. Remove temporary drivers, screenshots, and smoke scripts; leave the desktop running. Do not retain screenshots containing private network details as documentation.

In the 2026-09-24 native-input smoke, continuous `axis` requests exercised wheel scrolling; `axis_discrete` alone did not. Separate virtual button press/release with a round trip and a short hold (80 ms worked). Back-to-back synthetic edges produced misleading inside-click dismissal; human-paced clicks passed internal-tab, same-monitor and cross-monitor dismissal checks. Do not modify panel behavior to compensate for an invalid smoke input sequence.
