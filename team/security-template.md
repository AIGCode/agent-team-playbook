# Security rules for <project>

> **Disclaimer.** This is an illustrative template of security rules - not a reproduction of anyone's real configuration and not a ready-made "100%" solution. You alone are responsible for the security and data of your own applications: which set of rules is needed and sufficient is decided and assembled by you alone. A mistake leads to leaks and data loss - do not apply it blindly, check it against your own project.

**Read by the Developer before work and by the Reviewer during review. Mandatory to follow when writing any code.**

[1-2 sentences about the environment and the threat model: where the project runs, what in it is reachable from outside and what closes off everything else. Fill in for your own stack; a filled-in example is in `team/security-example.md`.]

The sections below are a list of areas the project must lock down. These are requirements ("what to protect"), not the implementation: no code, no ready-made `.htaccess`, regexes, or functions - exactly how it is locked down the project writes under each item itself. A filled-in sample for a specific stack is `team/security-example.md`.

The sections correspond to the Reviewer's security rules (`team/roles/reviewer.md`, `<rules>`): the number of their rule is in parentheses at the section heading. The requirements are written at the level of the threat and hold for any stack.

It is filled in for the project's stack. A rule is not relevant to the stack - remove the section; something of your own appeared - add it. A section grows too large - move it into a separate file and leave a link here (the extraction rule).

---

## 1. Only what is intended is reachable from outside (rule 1)

- From outside only the explicitly intended entry points are reachable. Configurations, secrets, logs, data, uploads, libraries and source code - everything that is not a public entry point - cannot be retrieved from outside.
- Service operations (scripts intended to be run only from the command line, background jobs) are not run from outside.

> How it is locked down in the project: [...]

## 2. Input is not trusted until checked (rule 2)

Each external input (a request, a webhook, a CLI argument, a file, an external API response) is checked at the system boundary against a whitelist of what is expected; whatever was not expected is rejected. Every entry point that accepts requests must cover all the checks:

- **HTTP method** - only the required one is allowed, the rest are rejected
- **Input validation** - whitelist, no raw request parameters without a check
- **File validation** (if files are accepted) - a size limit, a type check by content
- **Path traversal** - forbid escaping the directory and service characters in the data from which paths are built: a file path from the input does not go outside the allowed folder

> How it is locked down in the project: [...]

## 3. Access only by a verified right, and the check does not give away the secret (rule 3)

- **Authentication** - where access by a key or a right is needed, it is checked on every request; constant-time key comparison, resistant to timing attacks; not a naive string comparison

> How it is locked down in the project: [...]

## 4. Data does not become a command (rule 4)

Data from outside is not glued into a query, command, code, markup or path - only as parameters or via escaping for the context.

- **Injections into queries and commands** - database queries (SQL and other query languages) and shell commands are built only with parameters, without gluing strings with data
- **XSS** - data from outside is escaped for the output context when output into HTML and templates
- **Sanitizing file names** - data from external sources (API, user input) that ends up in file names must go through sanitization - even from "trusted" APIs
- **Code from data** (for the Reviewer - rule 13) - no code execution along paths assembled from external data
- **Log injection** - input data must not break the log line format
- Path traversal - section 2

> How it is locked down in the project: [...]

## 5. Secrets do not leave their place (rule 5)

- Secrets are not reachable from outside and are stored separately from regular settings
- Keys and files with secrets are not committed to git
- In config templates - a placeholder instead of the real value
- At startup it is checked that the credentials are filled in
- Tokens, keys, passwords, raw API responses do not end up in error texts, logs, responses and debug output
- Secrets are not logged
- In production the debug mode and debug output are turned off (for the Reviewer - also rule 15)

> How it is locked down in the project: [...]

## 6. CORS (rule 6)

- Whitelist of specific domains (not *)
- OPTIONS preflight is handled
- Access-Control-Allow-Methods is limited to the needed methods

> How it is locked down in the project: [...]

## 7. Rate limiting (rule 7)

For public entry points (available without an API key):
- Limit by IP
- Limit by email/identifier
- HTTP 429 when exceeded

> How it is locked down in the project: [...]

## 8. Resources do not grow without limit (rule 8)

- Logs: size limit / rotation
- Request rate - section 7, size of uploaded files - section 2

> How it is locked down in the project: [...]

## 9. An external dependency does not hang or deceive the system (rule 9)

- A mandatory timeout on every request
- Only a secure connection (HTTPS)
- Checking the response content before using it

> How it is locked down in the project: [...]

## 10. Concurrent writes do not corrupt data (rule 10)

If several processes write to one file or resource (including a log), the write is not interleaved and not lost: locking on write, an atomic replacement or a transaction.

> How it is locked down in the project: [...]

## 11. Least privilege (rule 11)

The process, files and folders get only the permissions that are needed for the work (not full access for everyone).

> How it is locked down in the project: [...]

---

## Checklist before deploy

One actionable item per each rule above. The checklist is a reminder before deploy, not the full scope of the check: the Reviewer builds its own table from the sections of this file as a whole and notes in it how each section was checked.

- [ ] Only the intended entry points are reachable from outside: configurations, secrets, logs, data are closed off, service scripts are not run from outside
- [ ] Entry points: method, input validation, file validation, path traversal
- [ ] Access by a key or a right is checked on every request, the key is compared in constant time
- [ ] Database queries and commands - only with parameters, output into HTML is escaped, code is not executed along paths from external data
- [ ] File names from external sources are sanitized
- [ ] Logs are protected from injections
- [ ] Credentials do not end up in error texts and logs, are not kept in git, at startup it is checked that they are filled in
- [ ] CORS: domain whitelist, preflight, limited methods
- [ ] Public entry points are rate-limited (429)
- [ ] Logs are rotated
- [ ] Every outbound request has a timeout
- [ ] File writes are protected from races (locking)
- [ ] Permissions of the process, files and folders - only the needed ones
