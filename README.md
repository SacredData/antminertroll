# `antminertroll`
> A script that searches for Antminer devices on the local CIDR subnet,
> and tracks its temperature, performance, and power usage statistics.
> Exports to friendly CSV and JSON formats for analysis.

## Getting Started
This script requires a couple of software dependencies, usually already
found on your local Unix-flavored computer:

- `jq` (`brew install jq`)
- `nmap` (`brew install nmap`)
- `ip` (`brew install iproute2mac`)

To ensure that your macOS computer will be able to use `antminertroll`, be
sure that you have installed Homebrew. Then run the above commands in
parentheses to obtain the dependencies.

## Usage

```sh
./antminertroll.sh [-h] [-s] [-t=NUM_SEC]
```

All command line arguments are optional.

By default, nmap will scan local area network for all available antminer
devices.
