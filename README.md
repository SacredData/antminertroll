# `antminertroll`
> A script that searches for Antminer devices on the local CIDR subnet,
> and tracks its temperature, performance, and power usage statistics.
> Exports to friendly CSV and JSON formats for analysis.

## Getting Started
Start off by cloning this repo and entering into the directory.

```sh
git clone https://github.com/SacredData/antminertroll
cd antminertroll
```

This script requires a couple of software dependencies, usually already
found on your local Unix-flavored computer:

- `jq` (`brew install jq`)
- `nmap` (`brew install nmap`)
- `ip` (`brew install iproute2mac`)

To ensure that your macOS computer will be able to use `antminertroll`, be
sure that you have installed Homebrew. Then run the above commands in
parentheses to obtain the dependencies. Or, in one fell swoop:

```sh
brew install jq nmap iproute2mac
```

Now you should be good to go. To ensure the script does something when you
run it, fire up your Antminer devices and make sure they are operating on
the same local area network as the computer running this software.

## Usage

```sh
./antminertroll.sh [-h] [-s] [-t=NUM_SEC]
```

All command line arguments are optional.

By default, nmap will scan local area network for all available antminer
devices. Use `-s` to skip the scan if you already have an `antminer_ips`
file from a previous scan.

`-t=60` is the default query interval.

If you simply run `./antminertroll.sh` you will undergo a network scan,
then if ant devices are found the query will be executed every 60 seconds.

Run the help output by issuing `./antminertroll.sh -h`:


```sh

./antminertroll.sh [-h] [-s] [-t=NUMBER_OF_SECONDS]
 All arguments are optional:

 -h = SHOW THE HELP

 -s = SKIP network scan and just use current antminer_ips file for servers list

 -t=NUMBER_OF_SECONDS = amount of seconds to wait between querying the antminers

 EXAMPLES:

 # Find all antminers on the local CIDR subnet, then probe them for data every 45 seconds
 ./antminertroll.sh -t=45

 # Skip searching for antminers and use already-present antminer_ips file. Scan once per hour.
 ./antminertroll.sh -s -t=3600 
```
