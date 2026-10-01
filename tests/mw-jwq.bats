#!/usr/bin/env bats
load test_helper
fixtures mw-jwq

@test "invoking mw-jwq with no mandatory parameters shows Usage" {
  run ./mw-jwq </dev/null
  [ $status -eq 1 ]
  [ $(expr "${lines[1]}" : "Usage:") -ne 0 ]

  run ./mw-jwq -c </dev/null
  [ $status -eq 1 ]
  [ $(expr "${lines[1]}" : "Usage:") -ne 0 ]

  run ./mw-jwq -v </dev/null
  [ $status -eq 1 ]
  [ $(expr "${lines[1]}" : "Usage:") -ne 0 ]

  run ./mw-jwq -v -c </dev/null
  [ $status -eq 1 ]
  [ $(expr "${lines[1]}" : "Usage:") -ne 0 ]
}

@test "-V and --version print version number" {
  run ./mw-jwq -V
  [ $status -eq 0 ]
  [ $(expr "$output" : "mw-jwq v[0-9][0-9.]*") -ne 0 ]

  run ./mw-jwq --version
  [ $status -eq 0 ]
  [ $(expr "$output" : "mw-jwq v[0-9][0-9.]*") -ne 0 ]
}

@test "-h and --help print help" {
  run ./mw-jwq -h
  [ $status -eq 0 ]
  [ "${#lines[@]}" -gt 5 ]

  run ./mw-jwq --help
  [ $status -eq 0 ]
  [ "${#lines[@]}" -gt 5 ]
}

@test "invalid filename prints an error" {
  run ./mw-jwq -f nonexistent
  [ $status -eq 1 ]
  [ $(expr "$output" : ".*does not exist") -ne 0 ]
}

@test "invalid code fails" {
  run ./mw-jwq -f "$FIXTURE_ROOT/invalid.jwt"
  [ $status -eq 5 ]
}

@test "-f empty file runs w/o output" {
  run ./mw-jwq -f "$FIXTURE_ROOT/empty.jwt"
  [ $status -eq 0 ]
  [ "$output" = "" ]
}

@test "-c -f single line file ok" {
  run ./mw-jwq -c -f "$FIXTURE_ROOT/single_line.jwt"
  [ $status -eq 0 ]
  echo "${lines[2]}"
  [ "$output" = '{
  "alg": "HS256",
  "typ": "JWT"
}
{
  "sub": "1234567890",
  "name": "John Doe",
  "iat": 1516239022
}' ]
}

@test "-c -f file with trailing spaces" {
  run ./mw-jwq -c -f "$FIXTURE_ROOT/trailing_space.jwt"
  [ $status -eq 0 ]
  echo "${lines[2]}"
  [ "$output" = '{
  "alg": "HS256",
  "typ": "JWT"
}
{
  "sub": "1234567890",
  "name": "John Doe",
  "iat": 1516239022
}' ]
}

@test "-c -f file with preceding spaces" {
  run ./mw-jwq -c -f "$FIXTURE_ROOT/preceding_space.jwt"
  [ $status -eq 0 ]
  echo "${lines[2]}"
  [ "$output" = '{
  "alg": "HS256",
  "typ": "JWT"
}
{
  "sub": "1234567890",
  "name": "John Doe",
  "iat": 1516239022
}' ]
}

@test "-c -f file with spaces in between" {
  run ./mw-jwq -c -f "$FIXTURE_ROOT/in_between_space.jwt"
  [ $status -eq 0 ]
  echo "${lines[2]}"
  [ "$output" = '{
  "alg": "HS256",
  "typ": "JWT"
}
{
  "sub": "1234567890",
  "name": "John Doe",
  "iat": 1516239022
}' ]
}

@test "-c -f file with one trailing empty line" {
  run ./mw-jwq -c -f "$FIXTURE_ROOT/trailing_single_empty_line.jwt"
  [ $status -eq 0 ]
  echo "${lines[2]}"
  [ "$output" = '{
  "alg": "HS256",
  "typ": "JWT"
}
{
  "sub": "1234567890",
  "name": "John Doe",
  "iat": 1516239022
}' ]
}

@test "-c -f file with multiple trailing empty lines" {
  run ./mw-jwq -c -f "$FIXTURE_ROOT/tailing_empty_lines.jwt"
  [ $status -eq 0 ]
  echo "${lines[2]}"
  [ "$output" = '{
  "alg": "HS256",
  "typ": "JWT"
}
{
  "sub": "1234567890",
  "name": "John Doe",
  "iat": 1516239022
}' ]
}

@test "-c -f file with preceding empty line" {
  run ./mw-jwq -c -f "$FIXTURE_ROOT/preceding_single_empty_line.jwt"
  [ $status -eq 0 ]
  echo "${lines[2]}"
  [ "$output" = '{
  "alg": "HS256",
  "typ": "JWT"
}
{
  "sub": "1234567890",
  "name": "John Doe",
  "iat": 1516239022
}' ]
}

@test "-c -f file with multiple preceding empty lines" {
  run ./mw-jwq -c -f "$FIXTURE_ROOT/preceding_empty_lines.jwt"
  [ $status -eq 0 ]
  echo "${lines[2]}"
  [ "$output" = '{
  "alg": "HS256",
  "typ": "JWT"
}
{
  "sub": "1234567890",
  "name": "John Doe",
  "iat": 1516239022
}' ]
}

@test "-c -f file with multiple codes one per line" {
  run ./mw-jwq -c -f "$FIXTURE_ROOT/two.jwt"
  [ $status -eq 0 ]
  echo "${lines[2]}"
  [ "$output" = '{
  "alg": "HS256",
  "typ": "JWT"
}
{
  "sub": "1234567890",
  "name": "John Doe",
  "iat": 1516239022
}
{
  "alg": "HS256",
  "typ": "JWT"
}
{
  "sub": "1234567890",
  "name": "John Doe",
  "iat": 1516239022
}' ]
}

@test "-c -f multi line code" {
  run ./mw-jwq -c -f "$FIXTURE_ROOT/multi_line.jwt"
  [ $status -eq 0 ]
  echo "${lines[2]}"
  [ "$output" = '{
  "alg": "HS256",
  "typ": "JWT"
}
{
  "sub": "1234567890",
  "name": "John Doe",
  "iat": 1516239022
}' ]
}

@test "-c -f file name with space ok" {
  run ./mw-jwq -c -f "$FIXTURE_ROOT/name with space.jwt"
  [ $status -eq 0 ]
  echo -e "${lines[2]}"
  [ "$output" = '{
  "alg": "HS256",
  "typ": "JWT"
}
{
  "sub": "1234567890",
  "name": "John Doe",
  "iat": 1516239022
}' ]
}

@test "-c quoted string with \"" {
  run ./mw-jwq -c "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
  [ $status -eq 0 ]
  [ "${lines[0]}" = "{" ]
  [ "${lines[1]}" = "  \"alg\": \"HS256\"," ]
  [ "${lines[2]}" = "  \"typ\": \"JWT\"" ]
  [ "${lines[3]}" = "}" ]
  [ "${lines[4]}" = "{" ]
  [ "${lines[5]}" = "  \"sub\": \"1234567890\"," ]
  [ "${lines[6]}" = "  \"name\": \"John Doe\"," ]
  [ "${lines[7]}" = "  \"iat\": 1516239022" ]
  [ "${lines[8]}" = "}" ]
}

@test "-c quoted string with '" {
  run ./mw-jwq -c 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c'
  [ $status -eq 0 ]
  [ "${lines[0]}" = "{" ]
  [ "${lines[1]}" = "  \"alg\": \"HS256\"," ]
  [ "${lines[2]}" = "  \"typ\": \"JWT\"" ]
  [ "${lines[3]}" = "}" ]
  [ "${lines[4]}" = "{" ]
  [ "${lines[5]}" = "  \"sub\": \"1234567890\"," ]
  [ "${lines[6]}" = "  \"name\": \"John Doe\"," ]
  [ "${lines[7]}" = "  \"iat\": 1516239022" ]
  [ "${lines[8]}" = "}" ]
}

@test "-c unquoted string ok" {
  run ./mw-jwq -c eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
  [ $status -eq 0 ]
  [ "${lines[0]}" = "{" ]
  [ "${lines[1]}" = "  \"alg\": \"HS256\"," ]
  [ "${lines[2]}" = "  \"typ\": \"JWT\"" ]
  [ "${lines[3]}" = "}" ]
  [ "${lines[4]}" = "{" ]
  [ "${lines[5]}" = "  \"sub\": \"1234567890\"," ]
  [ "${lines[6]}" = "  \"name\": \"John Doe\"," ]
  [ "${lines[7]}" = "  \"iat\": 1516239022" ]
  [ "${lines[8]}" = "}" ]
}

@test "-c string with spaces" {
  run ./mw-jwq -c eyJhbGci OiJIUzI1NiIsInR 5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0N   TY3ODkwIiwibmFtZSI6IkpvaG4g  RG9lIiwiaWF0Ij  oxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
  [ $status -eq 0 ]
  [ "${lines[0]}" = "{" ]
  [ "${lines[1]}" = "  \"alg\": \"HS256\"," ]
  [ "${lines[2]}" = "  \"typ\": \"JWT\"" ]
  [ "${lines[3]}" = "}" ]
  [ "${lines[4]}" = "{" ]
  [ "${lines[5]}" = "  \"sub\": \"1234567890\"," ]
  [ "${lines[6]}" = "  \"name\": \"John Doe\"," ]
  [ "${lines[7]}" = "  \"iat\": 1516239022" ]
  [ "${lines[8]}" = "}" ]
}

@test "-c string with linebreak with ending in \\" {
  run ./mw-jwq -c eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9. \
  eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ. \
  SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
  [ $status -eq 0 ]
  [ "${lines[0]}" = "{" ]
  [ "${lines[1]}" = "  \"alg\": \"HS256\"," ]
  [ "${lines[2]}" = "  \"typ\": \"JWT\"" ]
  [ "${lines[3]}" = "}" ]
  [ "${lines[4]}" = "{" ]
  [ "${lines[5]}" = "  \"sub\": \"1234567890\"," ]
  [ "${lines[6]}" = "  \"name\": \"John Doe\"," ]
  [ "${lines[7]}" = "  \"iat\": 1516239022" ]
  [ "${lines[8]}" = "}" ]
}

@test "-c string with linebreak with NOT ending in \\" {
  run ./mw-jwq -c "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.
  eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.
  SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
  [ $status -eq 0 ]
  [ "${lines[0]}" = "{" ]
}

@test "-c -f second token with whitespace in header json" {
  printf 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0.abc\n%s.eyJzdWIiOiIxMjM0NTY3ODkwIn0.abc\n' \
    "$(b64url '{ "alg":"HS256"}')" > "$BATS_TEST_TMPDIR/spaced_header.jwt"
  run ./mw-jwq -c -f "$BATS_TEST_TMPDIR/spaced_header.jwt"
  [ $status -eq 0 ]
  [ "$(grep -c '"alg"' <<<"$output")" -eq 2 ]
}

@test "-c -f multi line code with signature line starting like a header" {
  H=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9
  P=eyJzdWIiOiIxMjM0NTY3ODkwIn0
  printf '%s.%s.abcdef\neyJzaWduYXR1cmU\n%s.%s.xyz\n' "$H" "$P" "$H" "$P" > "$BATS_TEST_TMPDIR/sig_like_header.jwt"
  run ./mw-jwq -c -f "$BATS_TEST_TMPDIR/sig_like_header.jwt"
  [ $status -eq 0 ]
  [ "$(grep -c '"alg"' <<<"$output")" -eq 2 ]
}

H=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9
P=eyJzdWIiOiIxMjM0NTY3ODkwIn0
B64URL_UNSAFE='{"a":"??>>~~"}'

b64url() {
  printf '%s' "$1" | base64 | tr -d '\n=' | tr '+/' '-_'
}

@test "-h lists every option" {
  run ./mw-jwq -h
  for opt in -h --help -V --version -f --file -c --no-color --color -v --verbose -vv --hyper-verbose; do
    [[ "$output" == *"$opt"* ]]
  done
}

@test "-c base64url alphabet (- and _) is decoded" {
  run ./mw-jwq -c "$(b64url "$B64URL_UNSAFE").$P.s"
  [ $status -eq 0 ]
  [[ "$output" == *'"a": "??>>~~"'* ]]
}

@test "-c unicode payload" {
  run ./mw-jwq -c "$H.$(b64url '{"n":"ñandú ✓"}').s"
  [ $status -eq 0 ]
  [[ "$output" == *'"n": "ñandú ✓"'* ]]
}

@test "-c token without signature (trailing dot)" {
  run ./mw-jwq -c "$H.$P."
  [ $status -eq 0 ]
  [[ "$output" == *'"sub": "1234567890"'* ]]
}

@test "-c -f CRLF line endings" {
  printf '%s.%s.s\r\n%s.%s.s\r\n' "$H" "$P" "$H" "$P" > "$BATS_TEST_TMPDIR/crlf.jwt"
  run ./mw-jwq -c -f "$BATS_TEST_TMPDIR/crlf.jwt"
  [ $status -eq 0 ]
  [ "$(grep -c '"alg"' <<<"$output")" -eq 2 ]
}

@test "-c -f tabs around and inside the code" {
  printf '\t%s.%s\t.s\t\n' "$H" "$P" > "$BATS_TEST_TMPDIR/tabs.jwt"
  run ./mw-jwq -c -f "$BATS_TEST_TMPDIR/tabs.jwt"
  [ $status -eq 0 ]
  [ "$(grep -c '"alg"' <<<"$output")" -eq 1 ]
}

@test "-c -f three codes separated by empty lines" {
  printf '%s.%s.s\n\n%s.%s.s\n\n\n%s.%s.s\n' "$H" "$P" "$H" "$P" "$H" "$P" > "$BATS_TEST_TMPDIR/three.jwt"
  run ./mw-jwq -c -f "$BATS_TEST_TMPDIR/three.jwt"
  [ $status -eq 0 ]
  [ "$(grep -c '"alg"' <<<"$output")" -eq 3 ]
}

@test "-c -f file with only whitespace runs w/o output" {
  printf ' \n\t\n  \n' > "$BATS_TEST_TMPDIR/blank.jwt"
  run ./mw-jwq -c -f "$BATS_TEST_TMPDIR/blank.jwt"
  [ $status -eq 0 ]
  [ "$output" = "" ]
}

@test "-c string with only whitespace shows Usage" {
  run ./mw-jwq -c "   "
  [ $status -eq 1 ]
  [[ "$output" == *"Missing argument"* ]]
}

@test "-c multi line string with several codes" {
  run ./mw-jwq -c "$H.$P.s
$H.$P.s"
  [ $status -eq 0 ]
  [ "$(grep -c '"alg"' <<<"$output")" -eq 2 ]
}

@test "-c second code invalid: first is decoded and status is 5" {
  run ./mw-jwq -c "$H.$P.s
zzz.zzz.zzz"
  [ $status -eq 5 ]
  [[ "$output" == *'"alg"'* ]]
}

@test "-c first code invalid: second is still decoded and status is 5" {
  run ./mw-jwq -c "$(b64url 'not json').$P.s
$H.$P.s"
  [ $status -eq 5 ]
  [[ "$output" == *'"alg"'* ]]
}

@test "-c -f second code with header wrapped and using - or _" {
  HDR=$(b64url "$B64URL_UNSAFE")
  printf '%s.%s.s\n%s\n%s.%s.s\n' "$H" "$P" "${HDR:0:5}" "${HDR:5}" "$P" > "$BATS_TEST_TMPDIR/wrapped.jwt"
  run ./mw-jwq -c -f "$BATS_TEST_TMPDIR/wrapped.jwt"
  [ $status -eq 0 ]
  [[ "$output" == *'"alg"'* ]]
  [[ "$output" == *'"a": "??>>~~"'* ]]
}

@test "-c payload that is not JSON fails" {
  run ./mw-jwq -c "$H.$(b64url 'notjson').s"
  [ $status -eq 5 ]
}

@test "-c invalid base64 characters fail" {
  run ./mw-jwq -c 'a!b.c@d.e'
  [ $status -eq 5 ]
}

@test "-c string without dots fails" {
  run ./mw-jwq -c abc
  [ $status -eq 5 ]
}

@test "-c a single code with only two parts is decoded" {
  run ./mw-jwq -c "$H.$P"
  [ $status -eq 0 ]
  [[ "$output" == *'"alg"'* ]]
  [[ "$output" == *'"sub"'* ]]
}

@test "-c code with too many parts fails" {
  run ./mw-jwq -c "a.b
c.d.e"
  [ $status -eq 5 ]
  [[ "$output" == *"too many parts"* ]]
}

@test "options after the string are part of the string, not options" {
  run ./mw-jwq -v --color=always "$H.$P.s" -c
  [[ "${lines[0]}" == *"JWT: '$H.$P.s-c'"* ]]
  [[ "$output" == *$'\e['* ]]
}

@test "-- ends options" {
  run ./mw-jwq -c -- "$H.$P.s"
  [ $status -eq 0 ]
  [[ "$output" == *'"alg"'* ]]
}

@test "-f after -c and before the file works in any order" {
  run ./mw-jwq -f "$FIXTURE_ROOT/single_line.jwt" -c
  [ $status -eq 0 ]
  [[ "$output" == *'"alg": "HS256"'* ]]
}

@test "-f and STRING together are rejected" {
  run ./mw-jwq -c -f "$FIXTURE_ROOT/single_line.jwt" "$H.$P.s"
  [ $status -eq 1 ]
  [[ "$output" == *"not both"* ]]
}

@test "-f directory is rejected" {
  run ./mw-jwq -f "$FIXTURE_ROOT"
  [ $status -eq 1 ]
}

@test "-f without argument fails" {
  run ./mw-jwq -f
  [ $status -eq 1 ]
  [[ "$output" == *"Missing argument for option '-f'"* ]]
}

@test "unknown option fails" {
  run ./mw-jwq -x
  [ $status -eq 1 ]
  [[ "$output" == *"Unknown option: -x"* ]]
}

@test "shell metacharacters in the string are not executed" {
  run ./mw-jwq -c "$H.$P.s';touch $BATS_TEST_TMPDIR/pwned;'"
  [ $status -eq 0 ]
  [ ! -e "$BATS_TEST_TMPDIR/pwned" ]
}

@test "backslashes in the string are echoed literally" {
  run ./mw-jwq -v -c "$H.$P.s\\n"
  [ "${lines[0]}" = "JWT: '$H.$P.s\\n'" ]
}

@test "the JWT echo goes to stderr, the decoded JSON to stdout" {
  run bash -c "./mw-jwq -c '$H.$P.s' 2>/dev/null"
  [ $status -eq 0 ]
  [ "${lines[0]}" = "{" ]
}

@test "-v prints the jq command" {
  run ./mw-jwq -v -c "$H.$P.s"
  [ $status -eq 0 ]
  [[ "$output" == *">>  jq -R"* ]]
}

@test "without -v the jq command is not printed" {
  run ./mw-jwq -c "$H.$P.s"
  [[ "$output" != *">>"* ]]
}

@test "-vv traces the script" {
  run ./mw-jwq -vv -c "$H.$P.s"
  [ $status -eq 0 ]
  [[ "$output" == *"+ "* ]]
  [[ "$output" == *">>  jq -R"* ]]
}

@test "--verbose and --hyper-verbose are aliases" {
  run ./mw-jwq --verbose -c "$H.$P.s"
  [[ "$output" == *">>  jq -R"* ]]
  run ./mw-jwq --hyper-verbose -c "$H.$P.s"
  [[ "$output" == *"+ "* ]]
}

@test "--no-color is an alias of -c" {
  run ./mw-jwq --no-color -f "$FIXTURE_ROOT/single_line.jwt"
  [ $status -eq 0 ]
  [[ "$output" != *$'\e['* ]]
}

@test "color: auto (default) has no ANSI escapes when stdout is not a terminal" {
  run ./mw-jwq -f "$FIXTURE_ROOT/single_line.jwt"
  [ $status -eq 0 ]
  [[ "$output" != *$'\e['* ]]
}

@test "color: piped output can be consumed by jq without -c" {
  run bash -c "./mw-jwq -f '$FIXTURE_ROOT/single_line.jwt' 2>/dev/null | jq -c ."
  [ $status -eq 0 ]
  [ "${lines[0]}" = '{"alg":"HS256","typ":"JWT"}' ]
}

@test "color: --color=always has ANSI escapes even when piped" {
  run ./mw-jwq --color=always -f "$FIXTURE_ROOT/single_line.jwt"
  [ $status -eq 0 ]
  [[ "$output" == *$'\e['* ]]
}

@test "color: --color without a value means always" {
  run ./mw-jwq --color -f "$FIXTURE_ROOT/single_line.jwt"
  [[ "$output" == *$'\e['* ]]
}

@test "color: --color=auto behaves as the default" {
  run ./mw-jwq --color=auto -f "$FIXTURE_ROOT/single_line.jwt"
  [[ "$output" != *$'\e['* ]]
}

@test "color: --color=never has no ANSI escapes" {
  run ./mw-jwq --color=never -f "$FIXTURE_ROOT/single_line.jwt"
  [[ "$output" != *$'\e['* ]]
}

@test "color: invalid --color value fails" {
  run ./mw-jwq --color=sometimes -f "$FIXTURE_ROOT/single_line.jwt"
  [ $status -eq 1 ]
  [[ "$output" == *"Invalid value for --color: 'sometimes'"* ]]
}

@test "color: the last of -c and --color wins" {
  run ./mw-jwq --color=always -c -f "$FIXTURE_ROOT/single_line.jwt"
  [[ "$output" != *$'\e['* ]]
  run ./mw-jwq -c --color=always -f "$FIXTURE_ROOT/single_line.jwt"
  [[ "$output" == *$'\e['* ]]
}

@test "color: --color=always overrides NO_COLOR" {
  NO_COLOR=1 run ./mw-jwq --color=always -f "$FIXTURE_ROOT/single_line.jwt"
  [[ "$output" == *$'\e['* ]]
}

@test "color: terminal gets color by default" {
  require_pty
  TERM=xterm run_pty "./mw-jwq -f '$FIXTURE_ROOT/single_line.jwt'"
  [ $status -eq 0 ]
  [[ "$output" == *$'\e['* ]]
}

@test "color: terminal with -c, --color=never, NO_COLOR or TERM=dumb has none" {
  require_pty
  TERM=xterm run_pty "./mw-jwq -c -f '$FIXTURE_ROOT/single_line.jwt'"
  [[ "$output" != *$'\e['* ]]
  TERM=xterm run_pty "./mw-jwq --color=never -f '$FIXTURE_ROOT/single_line.jwt'"
  [[ "$output" != *$'\e['* ]]
  NO_COLOR=1 TERM=xterm run_pty "./mw-jwq -f '$FIXTURE_ROOT/single_line.jwt'"
  [[ "$output" != *$'\e['* ]]
  TERM=dumb run_pty "./mw-jwq -f '$FIXTURE_ROOT/single_line.jwt'"
  [[ "$output" != *$'\e['* ]]
}

@test "color: verbose command line is colored on a terminal" {
  require_pty
  TERM=xterm run_pty "./mw-jwq -v -c -f '$FIXTURE_ROOT/single_line.jwt'"
  [[ "$output" != *$'\e['* ]]
  TERM=xterm run_pty "./mw-jwq -v -f '$FIXTURE_ROOT/single_line.jwt'"
  [[ "$output" == *$'\e[0;32m>>'* ]]
}

@test "-c output has no ANSI escapes" {
  run ./mw-jwq -c -f "$FIXTURE_ROOT/single_line.jwt"
  [[ "$output" != *$'\e['* ]]
}

@test "NO_COLOR is honored in auto mode without a terminal too" {
  NO_COLOR=1 run ./mw-jwq -f "$FIXTURE_ROOT/single_line.jwt"
  [ $status -eq 0 ]
  [[ "$output" != *$'\e['* ]]
}

@test "stdin: piped code is decoded without arguments" {
  run bash -c "printf '%s.%s.s\n' '$H' '$P' | ./mw-jwq -c"
  [ $status -eq 0 ]
  [ "${lines[0]}" = "{" ]
  [[ "$output" == *'"alg": "HS256"'* ]]
}

@test "stdin: redirected file is decoded" {
  run ./mw-jwq -c < "$FIXTURE_ROOT/single_line.jwt"
  [ $status -eq 0 ]
  [[ "$output" == *'"sub": "1234567890"'* ]]
}

@test "stdin: -f - reads stdin" {
  run bash -c "printf '%s.%s.s\n' '$H' '$P' | ./mw-jwq -c -f -"
  [ $status -eq 0 ]
  [[ "$output" == *'"alg": "HS256"'* ]]
}

@test "stdin: several codes, whitespace and wrapped lines" {
  run bash -c "printf ' %s.%s.s \r\n\n%s.\n%s.s\n' '$H' '$P' '$H' '$P' | ./mw-jwq -c"
  [ $status -eq 0 ]
  [ "$(grep -c '"alg"' <<<"$output")" -eq 2 ]
}

@test "stdin: --color=always colors the output" {
  run bash -c "printf '%s.%s.s\n' '$H' '$P' | ./mw-jwq --color=always"
  [ $status -eq 0 ]
  [[ "$output" == *$'\e['* ]]
}

@test "stdin: invalid code fails with status 5" {
  run bash -c "echo 'a!b.c@d.e' | ./mw-jwq -c"
  [ $status -eq 5 ]
}

@test "stdin: empty input without -f shows Usage" {
  run ./mw-jwq -c < /dev/null
  [ $status -eq 1 ]
  [[ "$output" == *"Usage:"* ]]
  [[ "$output" == *"Missing argument"* ]]
}

@test "stdin: whitespace only input without -f shows Usage" {
  run bash -c "printf ' \n\t\n' | ./mw-jwq -c"
  [ $status -eq 1 ]
  [[ "$output" == *"Missing argument"* ]]
}

@test "stdin: -f - with empty input runs w/o output" {
  run ./mw-jwq -c -f - < /dev/null
  [ $status -eq 0 ]
  [ "$output" = "" ]
}

@test "stdin: a STRING argument wins over piped data and stdin is not read" {
  run bash -c "echo 'a!b.c@d.e' | ./mw-jwq -c '$H.$P.s'"
  [ $status -eq 0 ]
  [[ "$output" == *'"alg": "HS256"'* ]]
}

@test "stdin: -f - and STRING together are rejected" {
  run bash -c "echo x | ./mw-jwq -c -f - '$H.$P.s'"
  [ $status -eq 1 ]
  [[ "$output" == *"not both"* ]]
}

@test "stdin: -h mentions stdin" {
  run ./mw-jwq -h
  [[ "$output" == *"stdin"* ]]
}

@test "messages: errors are red, the JWT echo is cyan and usage is bold on a terminal" {
  require_pty
  TERM=xterm run_pty "./mw-jwq -x"
  [[ "$output" == *$'\e[0;31mUnknown option: -x\e[0m'* ]]
  TERM=xterm run_pty "./mw-jwq -v '$H.$P.s'"
  [[ "$output" == *$'\e[0;36mJWT: '* ]]
  TERM=xterm run_pty "./mw-jwq -h"
  [[ "$output" == *$'\e[1mUsage:\e[0m'* ]]
  [[ "$output" == *$'\e[1mAvailable options:\e[0m'* ]]
}

@test "messages: usage on a terminal with no arguments is bold" {
  require_pty
  TERM=xterm run_pty "./mw-jwq"
  [[ "$output" == *$'\e[1mUsage:\e[0m'* ]]
}

@test "messages: no color on a terminal with -c, NO_COLOR or TERM=dumb" {
  require_pty
  TERM=xterm run_pty "./mw-jwq -c -x"
  [[ "$output" != *$'\e['* ]]
  NO_COLOR=1 TERM=xterm run_pty "./mw-jwq -h"
  [[ "$output" != *$'\e['* ]]
  TERM=dumb run_pty "./mw-jwq '$H.$P.s'"
  [[ "$output" != *$'\e['* ]]
}

@test "messages: help piped from a terminal has no bold, stderr still colored" {
  require_pty
  TERM=xterm run_pty "./mw-jwq -h | cat"
  [[ "$output" != *$'\e['* ]]
  TERM=xterm run_pty "./mw-jwq -x 2>&1 >/dev/null | cat"
  [[ "$output" != *$'\e['* ]]
  TERM=xterm run_pty "./mw-jwq -v '$H.$P.s' | cat >/dev/null"
  [[ "$output" == *$'\e[0;36mJWT: '* ]]
}

@test "messages: plain without a terminal" {
  run ./mw-jwq -x
  [[ "$output" != *$'\e['* ]]
  run ./mw-jwq -h
  [[ "$output" != *$'\e['* ]]
  run ./mw-jwq -v "$H.$P.s"
  [[ "${lines[0]}" == "JWT: '$H.$P.s'" ]]
}

@test "messages: --color=always colors errors, usage and the JWT echo" {
  run ./mw-jwq --color=always -x
  [[ "$output" == *$'\e[0;31mUnknown option: -x\e[0m'* ]]
  run ./mw-jwq --color=always -h
  [[ "$output" == *$'\e[1mUsage:\e[0m'* ]]
  run ./mw-jwq -v --color=always "$H.$P.s"
  [[ "${lines[0]}" == $'\e[0;36mJWT: '* ]]
}

@test "messages: --color=never keeps messages plain" {
  run ./mw-jwq --color=never -x
  [ "$output" = "Unknown option: -x" ]
}

@test "messages: -V is never colored" {
  run ./mw-jwq --color=always -V
  [[ "$output" =~ ^mw-jwq\ v[0-9.]+$ ]]
}

@test "output: -H prints only the header" {
  run ./mw-jwq -c -H "$H.$P.s"
  [ $status -eq 0 ]
  [[ "$output" == *'"alg": "HS256"'* ]]
  [[ "$output" != *'"sub"'* ]]
}

@test "output: -p prints only the payload" {
  run ./mw-jwq -c -p "$H.$P.s"
  [ $status -eq 0 ]
  [[ "$output" == *'"sub": "1234567890"'* ]]
  [[ "$output" != *'"alg"'* ]]
}

@test "output: --header and --payload are aliases" {
  run ./mw-jwq -c --header "$H.$P.s"
  [[ "$output" == *'"alg"'* && "$output" != *'"sub"'* ]]
  run ./mw-jwq -c --payload "$H.$P.s"
  [[ "$output" == *'"sub"'* && "$output" != *'"alg"'* ]]
}

@test "output: -H and -p together print both, as without them" {
  run ./mw-jwq -c -H -p "$H.$P.s"
  [ $status -eq 0 ]
  [[ "$output" == *'"alg"'* && "$output" == *'"sub"'* ]]
  run bash -c "./mw-jwq -c -H -p '$H.$P.s' 2>/dev/null"
  both="$output"
  run bash -c "./mw-jwq -c '$H.$P.s' 2>/dev/null"
  [ "$output" = "$both" ]
}

@test "output: -p with several codes prints one payload per code" {
  run ./mw-jwq -c -p "$H.$P.s
$H.$P.s
$H.$P.s"
  [ $status -eq 0 ]
  [ "$(grep -c '"sub"' <<<"$output")" -eq 3 ]
  [ "$(grep -c '"alg"' <<<"$output")" -eq 0 ]
}

@test "output: -H with several codes prints one header per code" {
  run ./mw-jwq -c -H -f "$FIXTURE_ROOT/two.jwt"
  [ $status -eq 0 ]
  [ "$(grep -c '"alg"' <<<"$output")" -eq 2 ]
  [ "$(grep -c '"sub"' <<<"$output")" -eq 0 ]
}

@test "output: -p works with a file and with stdin" {
  run ./mw-jwq -c -p -f "$FIXTURE_ROOT/single_line.jwt"
  [[ "$output" == *'"sub"'* && "$output" != *'"alg"'* ]]
  run bash -c "./mw-jwq -c -p < '$FIXTURE_ROOT/single_line.jwt'"
  [[ "$output" == *'"sub"'* && "$output" != *'"alg"'* ]]
}

@test "output: -p output can be piped to jq" {
  run bash -c "./mw-jwq -p '$H.$P.s' 2>/dev/null | jq -r .sub"
  [ $status -eq 0 ]
  [ "$output" = "1234567890" ]
}

@test "output: -p still fails on an invalid code" {
  run ./mw-jwq -c -p 'a!b.c@d.e'
  [ $status -eq 5 ]
}

@test "output: -v shows the selected part in the jq command" {
  run ./mw-jwq -v -c -p "$H.$P.s"
  [[ "$output" == *"| .[1] |"* ]]
  run ./mw-jwq -v -c -H "$H.$P.s"
  [[ "$output" == *"| .[0] |"* ]]
}

@test "output: -h lists -H and -p" {
  run ./mw-jwq -h
  [[ "$output" == *"--header"* && "$output" == *"--payload"* ]]
}

@test "echo: the JWT is not echoed without -v" {
  run bash -c "./mw-jwq -c '$H.$P.s' 2>&1 >/dev/null"
  [ $status -eq 0 ]
  [ "$output" = "" ]
}

@test "echo: -v and -vv echo the JWT on stderr" {
  run bash -c "./mw-jwq -v -c '$H.$P.s' 2>&1 >/dev/null"
  [[ "$output" == *"JWT: '$H.$P.s'"* ]]
  run bash -c "./mw-jwq -vv -c '$H.$P.s' 2>&1 >/dev/null"
  [[ "$output" == *"JWT: '$H.$P.s'"* ]]
}

@test "echo: the JWT echo is shown before the jq command with -v" {
  run ./mw-jwq -v -c "$H.$P.s"
  [[ "${lines[0]}" == "JWT: '"* ]]
  [[ "${lines[1]}" == ">>  jq"* ]]
}

@test "echo: files and stdin never echo the JWT, even with -v" {
  run ./mw-jwq -v -c -f "$FIXTURE_ROOT/single_line.jwt"
  [[ "$output" != *"JWT: '"* ]]
  run bash -c "./mw-jwq -v -c < '$FIXTURE_ROOT/single_line.jwt'"
  [[ "$output" != *"JWT: '"* ]]
}

@test "-f accepts process substitution" {
  run ./mw-jwq -c -f <(printf '%s.%s.s\n' "$H" "$P")
  [ $status -eq 0 ]
  [[ "$output" == *'"alg"'* ]]
}

@test "-f accepts /dev/stdin and /dev/null" {
  run bash -c "printf '%s.%s.s\n' '$H' '$P' | ./mw-jwq -c -f /dev/stdin"
  [ $status -eq 0 ]
  [[ "$output" == *'"alg"'* ]]
  run ./mw-jwq -c -f /dev/null
  [ $status -eq 0 ]
  [ "$output" = "" ]
}

@test "-f directory says it is a directory" {
  run ./mw-jwq -f "$FIXTURE_ROOT"
  [ $status -eq 1 ]
  [[ "$output" == *"is a directory"* ]]
}

@test "-f unreadable file says it is not readable" {
  [ "$(id -u)" -ne 0 ] || skip "root can read any file"
  : > "$BATS_TEST_TMPDIR/secret.jwt"
  chmod 000 "$BATS_TEST_TMPDIR/secret.jwt"
  run ./mw-jwq -f "$BATS_TEST_TMPDIR/secret.jwt"
  [ $status -eq 1 ]
  [[ "$output" == *"is not readable"* ]]
}
