#!/usr/bin/env bats
load test_helper
fixtures mw-jwq

@test "invoking mw-jwq with no parameters shows Usage" {
  run ./mw-jwq
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

@test "-f empty file runs w/o output" {
  run ./mw-jwq -f "$FIXTURE_ROOT/empty.bats"
  [ $status -eq 0 ]
  [ "$output" = "" ]
}

@test "-c -f single line file ok" {
  run ./mw-jwq -c -f "$FIXTURE_ROOT/single_line.bats"
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


@test "-f multi line file ok" {
  skip "not yet implemented"
  run ./mw-jwq -c -f "$FIXTURE_ROOT/multi_line.bats"
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

@test "-f file name with space ok" {
  skip "not yet implemented"
  run ./mw-jwq -c -f "$FIXTURE_ROOT/name with space.bats"
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

@test "test color" {
  skip "Cant test color"
  run ./mw-jwq -f "$FIXTURE_ROOT/single_line.bats"
  [ $status -eq 0 ]
  [ $(expr "${lines[1]}" : "\\033\[1;39m\{") ]

}

@test "-c quoted string ok" {
  run ./mw-jwq -c "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
  [ $status -eq 0 ]
  [ "${lines[0]}" = "JWT: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c'" ]
  [ "${lines[1]}" = "{" ]
  [ "${lines[2]}" = "  \"alg\": \"HS256\"," ]
  [ "${lines[3]}" = "  \"typ\": \"JWT\"" ]
  [ "${lines[4]}" = "}" ]
  [ "${lines[5]}" = "{" ]
  [ "${lines[6]}" = "  \"sub\": \"1234567890\"," ]
  [ "${lines[7]}" = "  \"name\": \"John Doe\"," ]
  [ "${lines[8]}" = "  \"iat\": 1516239022" ]
  [ "${lines[9]}" = "}" ]
}

@test "-c unquoted string ok" {
  run ./mw-jwq -c eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
  [ $status -eq 0 ]
  [ $status -eq 0 ]
  [ "${lines[0]}" = "JWT: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c'" ]
  [ "${lines[1]}" = "{" ]
  [ "${lines[2]}" = "  \"alg\": \"HS256\"," ]
  [ "${lines[3]}" = "  \"typ\": \"JWT\"" ]
  [ "${lines[4]}" = "}" ]
  [ "${lines[5]}" = "{" ]
  [ "${lines[6]}" = "  \"sub\": \"1234567890\"," ]
  [ "${lines[7]}" = "  \"name\": \"John Doe\"," ]
  [ "${lines[8]}" = "  \"iat\": 1516239022" ]
  [ "${lines[9]}" = "}" ]
}


@test "-c string with spaces string ok" {
  run ./mw-jwq -c eyJhbGci OiJIUzI1NiIsInR 5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0N   TY3ODkwIiwibmFtZSI6IkpvaG4g  RG9lIiwiaWF0Ij  oxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
  [ $status -eq 0 ]
  [ $status -eq 0 ]
  [ "${lines[0]}" = "JWT: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c'" ]
  [ "${lines[1]}" = "{" ]
  [ "${lines[2]}" = "  \"alg\": \"HS256\"," ]
  [ "${lines[3]}" = "  \"typ\": \"JWT\"" ]
  [ "${lines[4]}" = "}" ]
  [ "${lines[5]}" = "{" ]
  [ "${lines[6]}" = "  \"sub\": \"1234567890\"," ]
  [ "${lines[7]}" = "  \"name\": \"John Doe\"," ]
  [ "${lines[8]}" = "  \"iat\": 1516239022" ]
  [ "${lines[9]}" = "}" ]
}


@test "-c string with linebreak string ok" {
  run ./mw-jwq -c eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9. \
  eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ. \
  SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
  [ $status -eq 0 ]
  [ $status -eq 0 ]
  [ "${lines[0]}" = "JWT: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c'" ]
  [ "${lines[1]}" = "{" ]
  [ "${lines[2]}" = "  \"alg\": \"HS256\"," ]
  [ "${lines[3]}" = "  \"typ\": \"JWT\"" ]
  [ "${lines[4]}" = "}" ]
  [ "${lines[5]}" = "{" ]
  [ "${lines[6]}" = "  \"sub\": \"1234567890\"," ]
  [ "${lines[7]}" = "  \"name\": \"John Doe\"," ]
  [ "${lines[8]}" = "  \"iat\": 1516239022" ]
  [ "${lines[9]}" = "}" ]
}