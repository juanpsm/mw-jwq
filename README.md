
[![Build Status](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Factions-badge.atrox.dev%2Fjuanpsm%2Fmw-jwq%2Fbadge%3Fref%3Dmain&style=for-the-badge)](https://actions-badge.atrox.dev/juanpsm/mw-jwq/goto?ref=main)

# mw-jwq

Wrapper for decripting *JSON Web Tokens* using `jq`

## Requirements

Tested only with [jq-1.6](https://stedolan.github.io/jq/), Zsh 5.8, and bash 5.1.8

## Install

Download to some location in your `$PATH` and give it permissions:

```console
curl -L https://github.com/juanpsm/mw-jwq/releases/download/0.1.0/mw-jwq > $HOME/.local/bin/mw-jwq
chmod +x $HOME/.local/bin/mw-jwq

mw-jwq -h
```

## Usage

The script has it own usage and help incorporated, check it out ✌️

## TDD

This script was tested with [bats](https://github.com/sstephenson/bats). To run them, first install it
[following their instructions](https://github.com/sstephenson/bats#installing-bats-from-source),
then:

```console
git clone https://github.com/juanpsm/mw-jwq.git
cd mw-jwq
bats tests

# Output:

 ✓ invoking mw-jwq with no mandatory parameters shows Usage
 ✓ -V and --version print version number
 ✓ -h and --help print help
 ✓ invalid filename prints an error
 ✓ invalid code fails
 ✓ -f empty file runs w/o output
 ✓ -c -f single line file ok
 ✓ -c -f file with trailing spaces
 ✓ -c -f file with preceding spaces
 ✓ -c -f file with spaces in between
 ✓ -c -f file with one trailing empty line
 ✓ -c -f file with multiple trailing empty lines
 ✓ -c -f file with preceding empty line
 ✓ -c -f file with multiple preceding empty lines
 ✓ -c -f file with multiple codes one per line
 ✓ -c -f multi line code
 ✓ -c -f file name with space ok
 ✓ -c quoted string with "
 ✓ -c quoted string with '
 ✓ -c unquoted string ok
 ✓ -c string with spaces
 ✓ -c string with linebreak with ending in \
 ✓ -c string with linebreak with NOT ending in \
 - Test color (skipped: TODO: Cant test color, dont know the codification)

24 tests, 0 failures, 1 skipped
```

## TODO

* ~~Fix skipped tests, either implement fixes or accept defeat.~~ (only the color test remains skipped)
* More tests:
  * Test `-v` parameter and other combinations.
  * Investigate about the color code to test without `-c` parameter
* Multiple file support?
* Use more colorful help and messages. The colours are already defined! 🌈
* ~~Add [Github Actions!!](https://docs.github.com/en/actions)~~
