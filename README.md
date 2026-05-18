# Better Edge Browser

Opinionated policy changes to Microsoft Edge Browser that debloats unnecessary 'features' and adds essential add-ons.

This is a fork of [Chrome Debloat](https://github.com/yashgorana/chrome-debloat) integrated with some policies from [Just the Browser](https://github.com/corbindavenport/just-the-browser).

## Features

- Attempts to disable telemetry and usage reporting.
- Removes unnecessary AI features, Copilot integration, and pre-installed bloatware.
- Blocks promotional content, Bing ads, and unnecessary UI elements like the Hubs sidebar.
- Maintains browser functionality while reducing resource usage by disabling Startup Boost and background modes.
- Enforces privacy by defaulting the New Tab page to about:blank and blocking location/notification prompts.
- Pre-configures essential add-ons:
    - uBlock Origin
    - DuckDuckGo Search & Tracker Protection
    - Tabliss
    - Violentmonkey
    - YouTube Video Speeds++

### Supported Systems

| Windows | macOS | Linux |
|---------|-------|-------|
| ✅ | ✅ | ✅ |
| ✅ | ✅ | ✅ |
| ✅ | ✅ | ✅ |

## Quick Start

### Windows
1.  Download the [`edge.reg`](./edge.reg) file from this repository.
2.  Open the downloaded `.reg` file to add the settings to the Windows Registry.
3.  Restart your browser or go to `edge://policy` and click "Reload policies".

### macOS
1.  Download the [`edge.mobileconfig`](./edge.mobileconfig) file from this repository.
2.  Open the downloaded `.mobileconfig` file to start the profile installation.
3.  Go to `System Settings` > `Privacy & Security` > `Profiles` and approve the new profile.
4.  Restart your browser or go to `edge://policy` and click "Reload policies".

### Linux
1.  Download the [`edge.json`](.edge.json) file from this repository.
2.  Move the downloaded file to the correct policy directory (create it if needed):
    *   **Edge:** `/etc/opt/edge/policies/managed/edge.json`
    *   *Note: You might need `sudo` rights to do this.*
3.  Restart your browser or go to `edge://policy` and click "Reload policies".

## Custom Configuration

If you want to customize the policies:

1. Clone this repository.
2. Open Terminal (CMD) inside the `debloat-source` folder. Or simply do `cd debloat-source`.
3. Install dependencies:
   ```bash
   uv sync
   ```
4. Modify `policies.yaml` according to your needs.
5. Generate new configuration files:
   ```bash
   uv run main.py
   ```
6. Execute `release.bat` to move the generated files, or check the `generated` folder inside `debloat-source`.


### Uninstalling Policies

**Windows:**
1.  Download the [`edge-remove.reg`](./edge-remove.reg) file from this repository.
2.  Run the file you downloaded. This will remove the registry keys added during installation.
3.  Restart your browser or go to `edge://policy` and click "Reload policies".

**macOS:**
1.  Go to `System Settings` > `Privacy & Security` > `Profiles`.
2.  Select the profile associated with Microsoft Edge.
3.  Click the '-' (minus) button to remove the profile.
3.  Restart your browser or go to `edge://policy` and click "Reload policies".

**Linux:**
1.  Remove the policy JSON file from the browser-specific directory:
    *   **Edge:** `sudo rm /etc/opt/edge/policies/managed/edge.json`
    *   *Note: You might need `sudo` rights to do this.*
3.  Restart your browser or go to `edge://policy` and click "Reload policies".

## Policy Documentation

- [Microsoft Edge Policies](https://learn.microsoft.com/en-us/deployedge/microsoft-edge-policies)

## License

[MIT](./LICENSE)
