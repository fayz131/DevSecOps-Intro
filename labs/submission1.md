# Lab 1 — OWASP Juice Shop & PR Workflow

## Task 1 — Triage Report — OWASP Juice Shop

# Triage Report — OWASP Juice Shop

## Scope & Asset
- Asset: OWASP Juice Shop (local lab instance)
- Image: bkimminich/juice-shop:v19.0.0
- Release link/date: https://github.com/juice-shop/juice-shop/releases/tag/v19.0.0 — September 2024
- Image digest (optional): *(not collected)*

---

## Environment
- Host OS: Ubuntu Linux (VirtualBox VM, user: vboxuser, host: amirLinux)
- Docker version: 28.2.2

---

## Deployment Details

Run command used:

```bash
docker run -d --name juice-shop \
  -p 127.0.0.1:3000:3000 \
  bkimminich/juice-shop:v19.0.0
```

Access URL: http://127.0.0.1:3000

Network exposure: 127.0.0.1 only — [x] Yes [ ] No

Because the container port is bound explicitly to localhost

## Health Check

1. UI Check

Navigated to http://127.0.0.1:3000

The OWASP Juice Shop UI loaded successfully

Screenshot: labs/img/juice-home.jpg

2. API Check

Command executed:  
```bash
curl -s http://127.0.0.1:3000/rest/products | head
```

Output:  
```html
<html>
  <head>
    <meta charset='utf-8'>
    <title>Error: Unexpected path: /rest/products</title>
  </head>
  <body>
    ...
  </body>
</html>
```

This confirms that:

the backend is reachable,

the request hits the application,

but this specific version/route returns a generic error handler page — acceptable for triage documentation


## Surface Snapshot (Triage)

Login/Registration visible:  Yes
Notes: Login and Register shown in the top menu.

Product listing/search present:  Yes
Notes: Main page includes product cards + search bar.

Admin/account area discoverable: Yes
Notes: Account menu and admin panel options visible in UI.

Client-side console errors: No
Notes: No JS errors in browser DevTools.

Security headers (quick look):  
```bash 
curl -I http://127.0.0.1:3000
```

Notes:
Headers are minimal and lack CSP/HSTS/X-Frame-Options.
Expected for a deliberately insecure training application, but would be a serious issue in production

## Risks Observed (Top 3)

1. Verbose stack traces exposed to users.
/rest/products returns HTML containing internal error messages and detailed stack traces — dangerous information disclosure in real environments.

2. Application could be accidentally exposed publicly.
If binded to 0.0.0.0 or deployed to a VPS, attackers could exploit Juice Shop’s intentional vulnerabilities.

3. Large attack surface (auth, search, basket, admin).
Many user input points → higher risk of XSS, SQLi, IDOR, and broken authentication if this were a real e-commerce system

## Task 2 - PR Template Setup & Verification

PR Template Creation

A pull request template was added at:  
```bash
.github/pull_request_template.md
```

Template includes:

Sections: Goal, Changes, Testing, Artifacts & Screenshots

Checklist:

 PR title is clear and descriptive

 Documentation updated if needed

 No secrets, temporary files, or large binaries included

This ensures consistent structure and quality across all lab submissions 

Template Application Verification

Steps performed:

1. Created a new branch:  
```bash
git checkout -b feature/lab1
```

2. Added the submission file and screenshot:  
```bash
git add labs/submission1.md labs/img/juice-home.png
git commit -m "docs(lab1): add submission1 report"
git push -u origin feature/lab1
```

3. Opened a pull request inside my fork (feature/lab1 → main)

4. GitHub automatically applied the PR template:

* Goal

* Changes

* Testing

* Artifacts & Screenshots

* 3-step Checklist

5. Filled in the template with deployment/testing details 

How Templates Improve Collaboration

Ensures every PR has a clear purpose and structure

Reduces review time for instructors

Prevents mistakes (missing docs, secrets, temp files)

Standardizes workflow for all future labs


## Challenges & Solutions

API endpoint returned HTML instead of JSON.
Resolved by analyzing server logs, confirming the backend is up,
and documenting the behaviour properly in the triage report.

PR template not loading at first.
Fixed by committing the template on the main branch of my fork — required by GitHub
