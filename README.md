# Better Edge Browser

Opinionated policy changes to Microsoft Edge Browser that debloat unnecessary 'features' and add essential add-ons.

This is a fork of [Chrome Debloat](https://github.com/yashgorana/chrome-debloat) integrated with some policies from [Just the Browser](https://github.com/corbindavenport/just-the-browser).

## Features

- Attempts to disable telemetry and usage reporting.
- Removes unnecessary AI features, Copilot integration, and pre-installed bloatware.
- Blocks promotional content, Bing ads, and unnecessary UI elements like the Hubs sidebar.
- Maintains browser functionality while reducing resource usage by disabling Startup Boost and background modes.
- Enforces privacy by defaulting the New Tab page to about:blank and blocking location/notification prompts.
- Pre-configures essential add-ons:
    - uBlock Origin (Forced)
    - DuckDuckGo Search & Tracker Protection (Forced)
    - Tabliss (Forced)
    - Violentmonkey
    - YouTube Video Speeds++
    - SponsorBlock for YouTube
    - Picture-in-Picture Everywhere
- \* Forced add-ons cannot be disabled or removed by the user.

### Supported Systems

| System | Support |
| --- | --- |
| Windows | ✅ |
| macOS | ✅ |
| Linux | ✅ |

## Quick Start for Windows

On Windows, you can use PowerShell to quickly apply `.reg` policies.

### Install with [Tabliss](https://microsoftedge.microsoft.com/addons/detail/lklaendlmlfkaabeleddanafeinnenih) (default)
1. Copy the following code and run it in PowerShell:
    ```bash
    & ([scriptblock]::Create((irm https://naeembolchhi.github.io/Better-Edge-Browser/win-auto/edge.ps1)))
    ```
2. Restart your browser or go to `edge://policy` and click "Reload policies".

### Install with [Bonjourr](https://microsoftedge.microsoft.com/addons/detail/dehmmlejmefjphdeoagelkpaoolicmid)
1. Copy the following code and run it in PowerShell:
    ```bash
    & ([scriptblock]::Create((irm https://naeembolchhi.github.io/Better-Edge-Browser/win-auto/edge.ps1))) "dehmmlejmefjphdeoagelkpaoolicmid"
    ```
2. Restart your browser or go to `edge://policy` and click "Reload policies".
3. *(Optional)* You can use any valid CRX ID (32-character add-on ID from Edge Add-on Store) in the code above to replace Tabliss with that add-on.

### Uninstall Edge Policies
1. Copy the following code and run it in PowerShell:
    ```bash
    & ([scriptblock]::Create((irm https://naeembolchhi.github.io/Better-Edge-Browser/win-auto/edge.ps1))) "remove"
    ```
2. Restart your browser or go to `edge://policy` and click "Reload policies".

## Installing Policies

If you're not on Windows or don't/can't use the one-liner above for some reason, you may follow the approaches below to apply the policies manually.

### Windows
1.  Download the [`edge-add.reg`](./edge-add.reg) file from this repository.
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
2. Modify `policies.yaml` (inside `debloat-source` folder) according to your needs.
3. Open a CMD terminal in the root folder.
4. Run `release.bat` to generate the policy files.

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
