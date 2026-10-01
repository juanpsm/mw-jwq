
[![Build Status](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Factions-badge.atrox.dev%2Fjuanpsm%2Fmw-jwq%2Fbadge%3Fref%3Dmain&style=for-the-badge)](https://actions-badge.atrox.dev/juanpsm/mw-jwq/goto?ref=main)

# mw-jwq

Wrapper for decoding *JSON Web Tokens* using `jq`

## Requirements

Tested with [jq](https://stedolan.github.io/jq/) 1.6, 1.7 and 1.8, and bash from 3.2 (the one macOS ships) to 5.x, on Linux and macOS (see the CI matrix).

## Install

Download to some location in your `$PATH` and give it permissions:

```console
curl -L https://github.com/juanpsm/mw-jwq/releases/download/0.7.1/mw-jwq > $HOME/.local/bin/mw-jwq
chmod +x $HOME/.local/bin/mw-jwq

mw-jwq -h
```

## Scope

`mw-jwq` only decodes: it prints the header and the payload of a JWT. It does
not verify the signature, does not check `exp`, `nbf` or any other claim, and
does not decrypt encrypted tokens (JWE). Never trust a token just because it
decodes.

## Usage

The script has it own usage and help incorporated, check it out ✌️

The JWT can be given as an argument, from a file, or through stdin:

```console
mw-jwq eyJhbGciOi...
mw-jwq -f token.jwt
kubectl get secret my-secret -o jsonpath='{.data.token}' | base64 -d | mw-jwq
mw-jwq < token.jwt
mw-jwq -f - < token.jwt   # explicit stdin
mw-jwq -f <(pass show token)   # any readable file, such as a process substitution
```

Stdin is read when no STRING nor `-f` is given and stdin is not a terminal.

Options go before the STRING: anything after it is taken as part of the code
(`mw-jwq TOKEN -c` decodes the code `TOKEN-c`). Use `--` to end the options.

### Input

Spaces, tabs, CRLF line endings and empty lines are ignored, and a code can be
wrapped over several lines. A file, stdin or a multi-line STRING can hold
several codes, one after the other. When there is more than one, every code
must have its three parts, with an empty signature as `HEADER.PAYLOAD.` if it
has none; a single code with only two parts is decoded too.

Nothing is printed on stderr by default. With `-v` the code given as STRING and
the `jq` command are printed there, and `-vv` also traces the script.

### Output

For each code the header is printed first and then the payload, both as
pretty-printed JSON. Use `-p`/`--payload` or `-H`/`--header` to print only one
of them for every code:

```console
mw-jwq -p $TOKEN | jq -r .sub
mw-jwq -H -f tokens.jwt
```

With both options, or none, both parts are printed.

### Exit codes

| Code | Meaning |
|------|---------|
| 0 | Everything was decoded (or there was nothing to decode: an empty file or stdin given with `-f`) |
| 1 | Wrong usage: missing or unknown option, missing or unreadable file, `-f` together with a STRING, or no input |
| 5 | A code could not be decoded: invalid base64 or JSON, or more than three parts |

With several codes, every one is decoded and the exit status is the first
error.

### Color

The JSON is colored only when the output is a terminal, so piping into other
tools just works:

```console
mw-jwq $TOKEN | jq .sub          # no color codes in the pipe
mw-jwq --color=always $TOKEN | less -R
mw-jwq --color=never $TOKEN      # same as -c / --no-color
```

`--color[=WHEN]` takes `auto` (default), `always` or `never`; a bare `--color`
means `always`. The `NO_COLOR` environment variable and `TERM=dumb` disable
color in `auto` mode, and the last of `-c` and `--color` wins.

The script's own messages follow the same rules: errors are red and, with
`-v`, the `JWT: '...'` line is cyan on stderr, and the usage and help headings
are bold on stdout, each one only when that stream is a terminal.

## TDD

This script was tested with [bats-core](https://github.com/bats-core/bats-core). To run them, first install it
[following their instructions](https://bats-core.readthedocs.io/en/stable/installation.html),
then (`tests/docker/Dockerfile` builds an image to run them on an old bash):

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
 ✓ -c -f second token with whitespace in header json
 ✓ -c -f multi line code with signature line starting like a header
 ✓ -h lists every option
 ✓ -c base64url alphabet (- and _) is decoded
 ✓ -c unicode payload
 ✓ -c token without signature (trailing dot)
 ✓ -c -f CRLF line endings
 ✓ -c -f tabs around and inside the code
 ✓ -c -f three codes separated by empty lines
 ✓ -c -f file with only whitespace runs w/o output
 ✓ -c string with only whitespace shows Usage
 ✓ -c multi line string with several codes
 ✓ -c second code invalid: first is decoded and status is 5
 ✓ -c first code invalid: second is still decoded and status is 5
 ✓ -c -f second code with header wrapped and using - or _
 ✓ -c payload that is not JSON fails
 ✓ -c invalid base64 characters fail
 ✓ -c string without dots fails
 ✓ -c a single code with only two parts is decoded
 ✓ -c code with too many parts fails
 ✓ options after the string are part of the string, not options
 ✓ -- ends options
 ✓ -f after -c and before the file works in any order
 ✓ -f and STRING together are rejected
 ✓ -f directory is rejected
 ✓ -f without argument fails
 ✓ unknown option fails
 ✓ shell metacharacters in the string are not executed
 ✓ backslashes in the string are echoed literally
 ✓ the JWT echo goes to stderr, the decoded JSON to stdout
 ✓ -v prints the jq command
 ✓ without -v the jq command is not printed
 ✓ -vv traces the script
 ✓ --verbose and --hyper-verbose are aliases
 ✓ --no-color is an alias of -c
 ✓ color: auto (default) has no ANSI escapes when stdout is not a terminal
 ✓ color: piped output can be consumed by jq without -c
 ✓ color: --color=always has ANSI escapes even when piped
 ✓ color: --color without a value means always
 ✓ color: --color=auto behaves as the default
 ✓ color: --color=never has no ANSI escapes
 ✓ color: invalid --color value fails
 ✓ color: the last of -c and --color wins
 ✓ color: --color=always overrides NO_COLOR
 ✓ color: terminal gets color by default
 ✓ color: terminal with -c, --color=never, NO_COLOR or TERM=dumb has none
 ✓ color: verbose command line is colored on a terminal
 ✓ -c output has no ANSI escapes
 ✓ NO_COLOR is honored in auto mode without a terminal too
 ✓ stdin: piped code is decoded without arguments
 ✓ stdin: redirected file is decoded
 ✓ stdin: -f - reads stdin
 ✓ stdin: several codes, whitespace and wrapped lines
 ✓ stdin: --color=always colors the output
 ✓ stdin: invalid code fails with status 5
 ✓ stdin: empty input without -f shows Usage
 ✓ stdin: whitespace only input without -f shows Usage
 ✓ stdin: -f - with empty input runs w/o output
 ✓ stdin: a STRING argument wins over piped data and stdin is not read
 ✓ stdin: -f - and STRING together are rejected
 ✓ stdin: -h mentions stdin
 ✓ messages: errors are red, the JWT echo is cyan and usage is bold on a terminal
 ✓ messages: usage on a terminal with no arguments is bold
 ✓ messages: no color on a terminal with -c, NO_COLOR or TERM=dumb
 ✓ messages: help piped from a terminal has no bold, stderr still colored
 ✓ messages: plain without a terminal
 ✓ messages: --color=always colors errors, usage and the JWT echo
 ✓ messages: --color=never keeps messages plain
 ✓ messages: -V is never colored
 ✓ output: -H prints only the header
 ✓ output: -p prints only the payload
 ✓ output: --header and --payload are aliases
 ✓ output: -H and -p together print both, as without them
 ✓ output: -p with several codes prints one payload per code
 ✓ output: -H with several codes prints one header per code
 ✓ output: -p works with a file and with stdin
 ✓ output: -p output can be piped to jq
 ✓ output: -p still fails on an invalid code
 ✓ output: -v shows the selected part in the jq command
 ✓ output: -h lists -H and -p
 ✓ echo: the JWT is not echoed without -v
 ✓ echo: -v and -vv echo the JWT on stderr
 ✓ echo: the JWT echo is shown before the jq command with -v
 ✓ echo: files and stdin never echo the JWT, even with -v
 ✓ -f accepts process substitution
 ✓ -f accepts /dev/stdin and /dev/null
 ✓ -f directory says it is a directory
 ✓ -f unreadable file says it is not readable

111 tests, 0 failures
```

## TODO

Nothing pending.

Done:

* ~~Document the scope and the interface: it only decodes (no signature nor expiration checks, and the README says "decripting"), the exit codes (1 usage, 5 `jq` error) and that options must come before the STRING.~~ [#9](https://github.com/juanpsm/mw-jwq/pull/9)
* ~~Decide whether the `JWT: '...'` echo on stderr stays or only shows with `-v`.~~ It only shows with `-v`, so stderr is quiet by default. [#8](https://github.com/juanpsm/mw-jwq/pull/8)
* ~~Decide the output format before freezing it: today header and payload are printed one after the other, with nothing separating or labeling several tokens. Maybe an option to print only the payload.~~ The default stays as is (header, then payload, for each code) and `-H`/`--header` and `-p`/`--payload` select one part. [#7](https://github.com/juanpsm/mw-jwq/pull/7)
* ~~Check compatibility with older bash (macOS ships 3.2; an empty array with `set -u` fails before bash 4.4) and with several `jq` versions: add a CI matrix (Ubuntu and macOS, jq 1.6 and 1.8) or declare and verify the minimum versions.~~ [#6](https://github.com/juanpsm/mw-jwq/pull/6)
* ~~Fix skipped tests, either implement fixes or accept defeat.~~ [#1](https://github.com/juanpsm/mw-jwq/pull/1)
* ~~More tests: `-v` and other combinations, color output without `-c`.~~ [#1](https://github.com/juanpsm/mw-jwq/pull/1), [#4](https://github.com/juanpsm/mw-jwq/pull/4)
* ~~Multiple file support?~~ Not needed: a file (or stdin) can hold several codes, one per line. Stdin is supported instead. [#3](https://github.com/juanpsm/mw-jwq/pull/3)
* ~~Use more colorful help and messages. The colours are already defined! 🌈~~ [#4](https://github.com/juanpsm/mw-jwq/pull/4), [#5](https://github.com/juanpsm/mw-jwq/pull/5)
* ~~Add [Github Actions!!](https://docs.github.com/en/actions)~~ [e05c21e](https://github.com/juanpsm/mw-jwq/commit/e05c21e), [#1](https://github.com/juanpsm/mw-jwq/pull/1)
