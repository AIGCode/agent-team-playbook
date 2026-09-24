# Security rules for <project>

> **Disclaimer.** This is an illustrative example of possible security settings for a PHP application on shared hosting - not a reproduction of anyone's real configuration and not a ready-made "100%" template. You alone are responsible for the security of your own applications: which set of rules is needed and sufficient is decided and assembled by you alone. A mistake in this area leads to leaks and data loss - do not copy the example blindly, check it against your own project.

**Read by the Developer before work and by the Reviewer during review. Mandatory to follow when writing any code.**

> A filled-in example for a set of PHP applications on shared hosting (Apache). The data is fictitious (`apps.example.com`). It shows how the areas from `team/security-template.md` are locked down on a specific stack. Your own project fills it in for its own stack and environment.

The `apps.example.com` server is shared hosting (Apache). All applications are accessible over the web. The only defense against external access is `.htaccess` and validation in PHP. Forgot the `.htaccess` - the files are open to the whole internet.

---

## 1. Only what is intended is reachable from outside (rule 1)

### Controlling web access to data folders

Any folder with configurations, logs, data, uploads, or libraries must have a `.htaccess`:

```
# Block all web access
Require all denied
```

Applies to: `config/`, `logs/`, `data/`, `downloads/`, `lib/`, `failed/` and any other folders without public endpoints.

### Running scripts from the CLI only

Any PHP script that is run only from the CLI must begin with:

```php
if (php_sapi_name() !== 'cli') {
    http_response_code(403);
    exit('Access denied');
}
```

A second line of defense if the `.htaccess` does not work.

## 2. Input is not trusted until checked (rule 2)

Every PHP file that accepts HTTP requests must include all the checks:

- **HTTP method** - only the required one (POST/GET), the rest 405
- **Input validation** - a whitelist regex, no `$_GET`/`$_POST` without a check
- **File validation** (if files are accepted): a size limit, magic bytes, MIME type via `finfo`
- **Path traversal** - forbid `../`, `/`, `\`, null bytes in path data

## 3. Access only by a verified right, and the check does not give away the secret (rule 3)

- **Authentication** - the API key via `hash_equals()` (constant-time, protection against timing attacks). Never via `==`

```php
// API key: always hash_equals, never ==
$apiKey = $_SERVER['HTTP_X_API_KEY'] ?? '';
if (!hash_equals($config['api_key'], $apiKey)) {
    http_response_code(401);
    exit(json_encode(['error' => 'Unauthorized']));
}
```

## 4. Data does not become a command (rule 4)

### Injections into queries and commands

All SQL queries via PDO prepared statements with parameters. No string concatenation in SQL.

**How to check:** grep for `->query(`, `->exec(` - if there are variables inside, it is a violation. It must be `->prepare()` + `->execute()`.

### XSS

- htmlspecialchars() for output of user data (protection against XSS)

### Sanitizing file names

Any data from external sources (API, user input) in file names must go through sanitization:

```php
function sanitizeForFilename(string $input): string {
    $input = str_replace(["\0", '/', '\\', '..'], '', $input);
    return preg_replace('/[^A-Za-z0-9\-_]/', '', $input);
}
```

Even from "trusted" APIs - sanitize it.

### Code from data

- `var_export()` for a PHP config - ok; eval/include with dynamic paths - forbidden

### Log injection

Before writing to the log, strip line breaks:

```php
$message = str_replace(["\r", "\n"], ' ', $message);
```

Plus: `LOCK_EX` on write, rotation by size, do not log secrets.

## 5. Secrets do not leave their place (rule 5)

- Store them in `config/` folders protected by `.htaccess`
- JSON keys, .env - forbidden to commit to git
- The placeholder `'CHANGE_ME'` in config templates
- At startup, check that the credentials are filled in
- In errors, never output tokens, keys, passwords, raw API responses
- Do not log secrets
- No var_dump/print_r in production code

## 6. CORS (rule 6)

- Whitelist of specific domains (not *)
- OPTIONS preflight is handled
- Access-Control-Allow-Methods is limited to the needed methods

## 7. Rate limiting (rule 7)

For public endpoints (available without an API key):
- Limit by IP
- Limit by email/identifier
- HTTP 429 when exceeded

## 8. Resources do not grow without limit (rule 8)

- Rotation by size (does not grow indefinitely)

## 9. An external dependency does not hang or deceive the system (rule 9)

- Always `CURLOPT_TIMEOUT` (not without a timeout)
- Always HTTPS
- Check the response content (magic bytes, JSON parse)
- `CURLOPT_RETURNTRANSFER => true`

## 10. Concurrent writes do not corrupt data (rule 10)

- `file_put_contents()` with `LOCK_EX`
- Before `mkdir()` check `!is_dir()`

## 11. Least privilege (rule 11)

- Folder permissions: `0755` (not 0777)

---

## Checklist before deploy

- [ ] `.htaccess` with `Require all denied` in every data folder
- [ ] `php_sapi_name()` check in every CLI script
- [ ] API key via `hash_equals()` in every HTTP endpoint
- [ ] Input validation (whitelist regex) on all input data
- [ ] All SQL queries via PDO prepared statements with parameters
- [ ] htmlspecialchars() for output of user data
- [ ] Sanitization of file names from external sources
- [ ] Log injection prevention (strip newlines)
- [ ] Credentials not in error messages
- [ ] CORS: whitelist of specific domains (not *)
- [ ] Rate limiting for public endpoints (HTTP 429 when exceeded)
- [ ] Timeout on all curl requests
- [ ] `LOCK_EX` on file_put_contents
