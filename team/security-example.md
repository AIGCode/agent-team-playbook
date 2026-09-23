# Security rules for <project>

> **Disclaimer.** This is an illustrative example of possible security settings for a PHP application on shared hosting - not a reproduction of anyone's real configuration and not a ready-made "100%" template. You alone are responsible for the security of your own applications: which set of rules is needed and sufficient is decided and assembled by you alone. A mistake in this area leads to leaks and data loss - do not copy the example blindly, check it against your own project.

**Read by the Developer before work and by the Reviewer during review. Mandatory to follow when writing any code.**

> A filled-in example for a set of PHP applications on shared hosting (Apache). The data is fictitious (`apps.example.com`). It shows how the areas from `team/security-template.md` are locked down on a specific stack. Your own project fills it in for its own stack and environment.

The `apps.example.com` server is shared hosting (Apache). All applications are accessible over the web. The only defense against external access is `.htaccess` and validation in PHP. Forgot the `.htaccess` - the files are open to the whole internet.

---

## 1. Controlling web access to data folders

Any folder with configurations, logs, data, uploads, or libraries must have a `.htaccess`:

```
# Block all web access
Require all denied
```

Applies to: `config/`, `logs/`, `data/`, `downloads/`, `lib/`, `failed/` and any other folders without public endpoints.

## 2. Running scripts from the CLI only

Any PHP script that is run only from the CLI must begin with:

```php
if (php_sapi_name() !== 'cli') {
    http_response_code(403);
    exit('Access denied');
}
```

A second line of defense if the `.htaccess` does not work.

## 3. Validating HTTP endpoints

Every PHP file that accepts HTTP requests must include all the checks:

1. **HTTP method** - only the required one (POST/GET), the rest 405
2. **Authentication** - the API key via `hash_equals()` (constant-time, protection against timing attacks). Never via `==`
3. **Input validation** - a whitelist regex, no `$_GET`/`$_POST` without a check
4. **File validation** (if files are accepted): a size limit, magic bytes, MIME type via `finfo`
5. **Path traversal** - forbid `../`, `/`, `\`, null bytes in path data

```php
// API key: always hash_equals, never ==
$apiKey = $_SERVER['HTTP_X_API_KEY'] ?? '';
if (!hash_equals($config['api_key'], $apiKey)) {
    http_response_code(401);
    exit(json_encode(['error' => 'Unauthorized']));
}
```

## 4. Sanitizing file names

Any data from external sources (API, user input) in file names must go through sanitization:

```php
function sanitizeForFilename(string $input): string {
    $input = str_replace(["\0", '/', '\\', '..'], '', $input);
    return preg_replace('/[^A-Za-z0-9\-_]/', '', $input);
}
```

Even from "trusted" APIs - sanitize it.

## 5. Credentials and secrets

- Store them in `config/` folders protected by `.htaccess`
- JSON keys, .env - forbidden to commit to git
- The placeholder `'CHANGE_ME'` in config templates
- At startup, check that the credentials are filled in
- In errors, never output tokens, keys, passwords, raw API responses
- `var_export()` for a PHP config - ok; eval/include with dynamic paths - forbidden

## 6. Logging

Before writing to the log, strip line breaks:

```php
$message = str_replace(["\r", "\n"], ' ', $message);
```

Plus: `LOCK_EX` on write, rotation by size, do not log secrets.

## 7. Outbound requests

- Always `CURLOPT_TIMEOUT` (not without a timeout)
- Always HTTPS
- Check the response content (magic bytes, JSON parse)
- `CURLOPT_RETURNTRANSFER => true`

## 8. File operations

- `file_put_contents()` with `LOCK_EX`
- Before `mkdir()` check `!is_dir()`
- Folder permissions: `0755` (not 0777)

---

## Checklist before deploy

- [ ] `.htaccess` with `Require all denied` in every data folder
- [ ] `php_sapi_name()` check in every CLI script
- [ ] API key via `hash_equals()` in every HTTP endpoint
- [ ] Input validation (whitelist regex) on all input data
- [ ] Sanitization of file names from external sources
- [ ] Timeout on all curl requests
- [ ] Credentials not in error messages
- [ ] `LOCK_EX` on file_put_contents
- [ ] Log injection prevention (strip newlines)
