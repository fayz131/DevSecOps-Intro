# Lab 5 — Security Analysis: SAST & DAST of OWASP Juice Shop

## Target
- Application: OWASP Juice Shop
- Image: `bkimminich/juice-shop:v19.0.0`
- Source analyzed for SAST: `v19.0.0`

---

## Task 1 — Static Application Security Testing with Semgrep

### SAST Tool Effectiveness

Semgrep was executed with the `p/security-audit` and `p/owasp-top-ten` rulesets against the OWASP Juice Shop source code.

Coverage summary:
- Files scanned: **1014**
- Rules run: **140**
- Findings detected: **25**
- Parsed lines: **~99.9%**

Semgrep effectively detected:
- SQL injection patterns
- hardcoded credentials
- path traversal risks
- XSS-prone HTML construction
- open redirect issues

Its main strength is source-level visibility before deployment, which makes it suitable for early CI/CD or pull request security checks.

### Critical Vulnerability Analysis

Top 5 most critical findings from Semgrep:

1. **SQL Injection** — `/src/data/static/codefixes/dbSchemaChallenge_1.ts` — line **5** — **ERROR**  
2. **SQL Injection** — `/src/data/static/codefixes/dbSchemaChallenge_3.ts` — line **11** — **ERROR**  
3. **SQL Injection** — `/src/data/static/codefixes/unionSqlInjectionChallenge_1.ts` — line **6** — **ERROR**  
4. **SQL Injection** — `/src/data/static/codefixes/unionSqlInjectionChallenge_3.ts` — line **10** — **ERROR**  
5. **SQL Injection** — `/src/routes/login.ts` — line **34** — **ERROR**

Additional notable findings:
- **Hardcoded credential** — `/src/lib/insecurity.ts` — line **56** — **WARNING**
- **Potential XSS / unsafe HTML construction** — `/src/routes/chatbot.ts` — line **197** — **WARNING**
- **Path traversal risk** — `/src/routes/fileServer.ts` — line **33** — **WARNING**
- **Path traversal risk** — `/src/routes/keyServer.ts` — line **14** — **WARNING**
- **Open redirect** — `/src/routes/redirect.ts` — line **19** — **WARNING**

### SAST Summary

Semgrep is best used early in the SDLC because it gives fast feedback directly to developers. It excels at identifying insecure implementation patterns before the application is deployed.

---

## Task 2 — Dynamic Application Security Testing with Multiple Tools

### Authenticated vs Unauthenticated Scanning

ZAP unauthenticated baseline scan discovered:

- **16 URLs**

ZAP authenticated scan discovered:

- **24 URLs**
- Standard spider: **112 URLs**
- AJAX spider: **516 URLs**

Example authenticated/admin endpoint discovered:
- `/rest/admin/application-configuration`

Authenticated scanning matters because many sensitive application areas are only visible after login. Anonymous scanning misses admin functionality, user-specific workflows, and privileged API endpoints.

### Tool Comparison Matrix

| Tool | Findings | Severity Breakdown | Best Use Case |
|------|----------|-------------------|---------------|
| ZAP | 8 alerts | Mostly medium-risk web/security-header and configuration findings | Full web app assessment, authenticated testing |
| Nuclei | 0 | No matches in this run | Fast CVE-oriented checks |
| Nikto | 82 issues | Mostly informational/server-side and configuration-style findings | Web server misconfiguration checks |
| SQLmap | 1 confirmed SQL injection (search endpoint) | Confirmed boolean-based blind SQL injection | Deep SQL injection validation |

### Tool-Specific Strengths

**ZAP**
- Best for broad application coverage
- Supports authentication, spidering, AJAX spider, passive and active scanning
- Excellent for discovering authenticated/admin attack surface

**Nuclei**
- Fast and template-driven
- Good for known CVEs and repeatable automated checks
- In this run, no nuclei templates matched Juice Shop meaningfully

**Nikto**
- Strong for server/header/configuration observations
- Good supplementary scanner for web exposure and backup-file style checks

**SQLmap**
- Specialized for SQL injection
- Confirmed boolean-based blind SQL injection on:
  - `GET /rest/products/search?q=*`
- Identified the backend DBMS as **SQLite**

### Example Findings by Tool

**ZAP**
- CSP header not set
- Cross-domain misconfiguration
- Dangerous JavaScript functions
- Cross-Origin-Embedder-Policy header missing

**Nuclei**
- No findings in this specific run

**Nikto**
- `X-XSS-Protection` header not defined
- `robots.txt` exposes `/ftp/`
- Multiple potentially interesting backup/cert-style file paths detected

**SQLmap**
- Confirmed boolean-based blind SQL injection on search endpoint
- Login endpoint test returned **401 Unauthorized**, so no injection was confirmed there

### Additional Security Findings

- ZAP demonstrated that authenticated scanning reveals more application surface than anonymous scanning.
- SQLmap provided the strongest validation for actual SQL injection exploitability.
- Nikto highlighted multiple server and HTTP response concerns.
- Nuclei did not contribute findings in this particular run.

---

## Task 3 — SAST/DAST Correlation and Security Assessment

### SAST vs DAST Comparison

SAST identified **25 code-level findings**.

DAST identified:
- **ZAP:** 8 authenticated web security alerts
- **Nuclei:** 0 template matches
- **Nikto:** 82 server issues
- **SQLmap:** confirmed SQL injection behavior on the search endpoint

Vulnerability types found only by SAST:
- insecure coding patterns
- hardcoded credentials in source
- path traversal-prone file handling logic

Vulnerability types found only by DAST:
- missing or weak security headers
- authenticated/admin endpoint exposure
- runtime SQL injection confirmation
- HTTP/server misconfiguration observations

### Why They Find Different Issues

SAST inspects the source code directly, which allows it to identify implementation-level flaws before deployment.

DAST interacts with the running application, which allows it to detect:
- real HTTP behavior
- runtime authentication and session issues
- exposed admin endpoints
- live exploitability of injection issues

Because of this, SAST and DAST are complementary rather than interchangeable.

### Final Recommendation

The best DevSecOps practice is to use:
- **Semgrep** in CI/CD and pull requests for shift-left detection
- **ZAP** for authenticated staging scans
- **Nuclei** for fast template/CVE-based checks
- **Nikto** for web server hygiene and exposure checks
- **SQLmap** for targeted SQL injection validation when suspicious input points exist

A combined SAST + DAST strategy provides the strongest overall security coverage.
