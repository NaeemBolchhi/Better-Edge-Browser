import argparse
import json
import plistlib
import sys
from pathlib import Path

from ruamel.yaml import YAML

yaml = YAML()

POLICY_CHROME = "chrome"
POLICY_BRAVE = "brave"
POLICY_EDGE = "edge"


METADATA = {
    POLICY_CHROME: {
        "mobileconfig": {
            "PayloadDisplayName": "Google Chrome Policies",
            "PayloadDescription": "Google Chrome Browser system-level policies",
            "PayloadIdentifier": "com.google.Chrome",
            "PayloadType": "com.google.Chrome",
            "PayloadUUID": "8568e67e-21ba-4bdc-a944-a30fb301ba02",
            "PayloadContentUUID": "3eb9eb1f-412c-4f8b-b425-f95f1a67072d",
        },
        "registry": {
            "key": r"HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome",
        },
    },
    POLICY_BRAVE: {
        "mobileconfig": {
            "PayloadDisplayName": "Brave Policies",
            "PayloadDescription": "Brave Browser system-level policies",
            "PayloadIdentifier": "com.brave.Browser",
            "PayloadType": "com.brave.Browser",
            "PayloadUUID": "e143b891-3398-48f9-bee1-54d3b6db44b3",
            "PayloadContentUUID": "88032831-5301-41ad-8231-10efa9d67ab3",
        },
        "registry": {
            "key": r"HKEY_LOCAL_MACHINE\SOFTWARE\Policies\BraveSoftware\Brave",
        },
    },
    POLICY_EDGE: {
        "mobileconfig": {
            "PayloadDisplayName": "Microsoft Edge Policies",
            "PayloadDescription": "Microsoft Edge Browser system-level policies",
            "PayloadIdentifier": "com.microsoft.Edge",
            "PayloadUUID": "778fb3c3-2e58-4337-86dc-1a8044793d2d",
            "PayloadContentUUID": "65ffbe44-b556-4c33-88ea-ab684dab69bc",
        },
        "registry": {
            "key": r"HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge",
        },
    },
}


def format_reg_value(value) -> str:
    if isinstance(value, bool):
        return f"dword:{'00000001' if value else '00000000'}"
    elif isinstance(value, int):
        return f"dword:{value:08x}"
    elif isinstance(value, list):
        return f'"{";".join(str(item) for item in value)}"'
    elif isinstance(value, str):
        return f'"{value}"'
    else:
        return f'"{str(value)}"'


def load_policies(path: str) -> dict:
    with open(path, "r") as fp:
        return yaml.load(fp.read())


def make_registry_config(policies: dict, metadata: dict) -> str:
    policies = policies.copy()
    content = ["Windows Registry Editor Version 5.00", ""]
    base_key = metadata["key"]
    extension_policies = {
        key: policies.pop(key)
        for key in [
            "ExtensionInstallForcelist",
            "ExtensionInstallAllowlist",
            "ExtensionInstallBlocklist",
        ]
        if key in policies
    }

    # Add the main key and regular policies
    content.append(f"[{base_key}]")
    for policy_name, policy_value in policies.items():
        if isinstance(policy_value, dict):
            # Handle nested policies by creating subkeys
            content.append("")
            content.append(f"[{base_key}\\{policy_name}]")
            for sub_name, sub_value in policy_value.items():
                content.append(f'"{sub_name}"={format_reg_value(sub_value)}')
        else:
            # Handle direct policy values
            content.append(f'"{policy_name}"={format_reg_value(policy_value)}')

    # Add extension policies at the end
    for policy_name, extensions in extension_policies.items():
        if extensions:  # Only create key if there are extensions
            content.append("")
            content.append(f"[{base_key}\\{policy_name}]")
            for i, ext in enumerate(extensions, 1):
                content.append(f'"{i}"="{ext}"')

    # Join all lines with Windows-style line endings
    return "\r\n".join(content)


def make_mobileconfig(policies: dict, metadata: dict) -> str:
    config = {
        "PayloadVersion": 1,
        "PayloadScope": "System",
        "PayloadType": "Configuration",
        "PayloadRemovalDisallowed": False,
        "PayloadUUID": metadata["PayloadUUID"],
        "PayloadDisplayName": metadata["PayloadDisplayName"],
        "PayloadDescription": metadata["PayloadDescription"],
        "PayloadIdentifier": metadata["PayloadIdentifier"],
        "PayloadContent": [
            {
                "PayloadIdentifier": metadata["PayloadIdentifier"],
                "PayloadType": metadata["PayloadIdentifier"],
                "PayloadUUID": metadata["PayloadContentUUID"],
                "PayloadVersion": 1,
                "PayloadEnabled": True,
                **policies,
            }
        ],
    }
    return plistlib.dumps(config, sort_keys=False)


def write_mobile_config(path: str, policy_content: dict, metadata: dict):
    try:
        mc_path = Path(path)
        mc_path.parent.mkdir(parents=True, exist_ok=True)
        conf = make_mobileconfig(policy_content, metadata)
        with mc_path.open("wb") as fp:
            fp.write(conf)
    except Exception as e:
        print(f"Error: {e}")


def write_reg_config(path: str, policy_content: dict, metadata: dict):
    try:
        reg_path = Path(path)
        reg_path.parent.mkdir(parents=True, exist_ok=True)
        conf = make_registry_config(policy_content, metadata)
        with reg_path.open("w") as fp:
            fp.write(conf)
    except Exception as e:
        print(f"Error: {e}")


def write_json_config(path: str, policy_content: dict, metadata: dict):
    try:
        json_path = Path(path)
        json_path.parent.mkdir(parents=True, exist_ok=True)
        with json_path.open("w") as fp:
            json.dump(policy_content, fp, indent=2)
    except Exception as e:
        print(f"Error: {e}")


def main():
    """Generate OS-specific browser policies from policy spec"""
    parser = argparse.ArgumentParser(
        description="Generate OS-specific browser policies from a YAML file."
    )
    parser.add_argument(
        "-f",
        "--policy-file",
        default="policies.yaml",
        help="Path to the YAML policy file (default: policies.yaml)",
    )
    args = parser.parse_args()

    print("Using policy file:", args.policy_file)

    try:
        policies = load_policies(args.policy_file)
        for pname in [POLICY_CHROME, POLICY_BRAVE, POLICY_EDGE]:
            print(f"Generating policies for '{pname}' ({len(policies[pname])} rules)")
            write_mobile_config(
                f"./generated/macos/{pname}.mobileconfig",
                policies[pname],
                METADATA[pname]["mobileconfig"],
            )
            write_reg_config(
                f"./generated/windows/{pname}.reg",
                policies[pname],
                METADATA[pname]["registry"],
            )
            write_json_config(
                f"./generated/linux/{pname}.json",
                policies[pname],
                {},
            )
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
