# Security rules for <project>

> **Disclaimer.** This is an illustrative template of security rules - not a reproduction of anyone's real configuration and not a ready-made "100%" solution. You alone are responsible for the security and data of your own applications: which set of rules is needed and sufficient is decided and assembled by you alone. A mistake leads to leaks and data loss - do not apply it blindly, check it against your own project.

**Mandatory reading at the start of a session. Mandatory to follow when writing any code.**

[1-2 sentences about the environment and the threat model: where the project is hosted, how access is exposed, what is the only defense against external access. Fill in for your own stack; a filled-in example is in `team/security-example.md`.]

The sections below are a list of areas the project must lock down. These are requirements ("what to protect"), not the implementation: no code, no ready-made `.htaccess`, regexes, or functions - exactly how it is locked down the project writes under each item itself. A filled-in sample for a specific stack is `team/security-example.md`.

It is filled in for the project's stack. A rule is not relevant to the stack - remove the section; something of your own appeared - add it. A section grows too large - move it into a separate file and leave a link here (the extraction rule).

---

## 1. Controlling web access to data folders

All folders with configurations, logs, data, uploads, and libraries - the ones that have no public endpoints - must be closed off from direct access over the web.

> How it is locked down in the project: [...]

## 2. Running scripts from the CLI only

Scripts intended to be run only from the CLI must block being run over the web.

> How it is locked down in the project: [...]

## 3. Validating HTTP endpoints

Every file that accepts HTTP requests must cover all the checks:

- **HTTP method** - only the required one is allowed, the rest are rejected
- **Authentication** - constant-time key comparison, resistant to timing attacks; not a naive string comparison
- **Input validation** - whitelist, no raw request parameters without a check
- **File validation** (if files are accepted) - a size limit, a type check by content
- **Path traversal** - forbid escaping the directory and service characters in the data from which paths are built

> How it is locked down in the project: [...]

## 4. Sanitizing file names

Data from external sources (API, user input) that ends up in file names must go through sanitization - even from "trusted" APIs.

> How it is locked down in the project: [...]

## 5. Credentials and secrets

- Secrets are stored in folders closed off from web access
- Keys and files with secrets are not committed to git
- In config templates - a placeholder instead of the real value
- At startup it is checked that the credentials are filled in
- Tokens, keys, passwords, raw API responses do not end up in error texts and logs
- No code execution along paths assembled from external data

> How it is locked down in the project: [...]

## 6. Logging

- Protection against log injection: input data must not break the log line format
- Locking on concurrent writes
- Size limit / rotation
- Secrets are not logged

> How it is locked down in the project: [...]

## 7. Outbound requests

- A mandatory timeout on every request
- Only a secure connection (HTTPS)
- Checking the response content before using it

> How it is locked down in the project: [...]

## 8. File operations

- Locking on write
- Checking that a folder exists before creating it
- Safe folder permissions (not full access for everyone)

> How it is locked down in the project: [...]

---

## Checklist before deploy

One actionable item per each rule above. The Reviewer checks the code against this checklist.

- [ ] Data folders are closed off from web access
- [ ] CLI scripts block being run over the web
- [ ] HTTP endpoints: method, authentication, input validation, file validation, path traversal
- [ ] File names from external sources are sanitized
- [ ] Every outbound request has a timeout
- [ ] Credentials do not end up in error texts and logs
- [ ] File writes are protected from races (locking)
- [ ] Logs are protected from injections
