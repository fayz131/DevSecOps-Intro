# Lab 3 — Secure Git

## Task 1 — SSH Commit Signing

### Benefits of Commit Signing

- Ensures each commit can be traced back to a verified developer identity.
- Protects against tampering and spoofed commits in shared repositories.
- Enables CI/CD and code review systems to enforce policies on trusted changes only.

### Setup Steps Performed

1. Generated / reused SSH key:

```bash
ssh-keygen -t ed25519 -C "a.fayzullin@innopolis.university"
```

2. Added the public key as an SSH signing key in GitHub (Settings → SSH and GPG keys → New SSH key → Type: Signing key).

3. Configured Git to use SSH for signing:

```bash
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519
git config --global commit.gpgSign true
git config --global gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers
```

4. Added my signing key to ~/.ssh/allowed_signers:

```bash 
echo "$(git config user.email) $(cat ~/.ssh/id_ed25519.pub)" > ~/.ssh/allowed_signers
```

5. Used ssh-agent to load the key:

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

6. Created signed commits, for example:

```bash
git commit -S -m "docs(lab3): add submission3 draft"
```

### Evidence

Local verification:

```bash
git log --show-signature -1
```

commit 73c2142f65d4a6ebfb7bed847bc80a51b0225483 (HEAD -> feature/lab3)
Good "git" signature for a.fayzullin@innopolis.university

### Why Commit Signing Is Critical in DevSecOps

Commit signing is crucial in DevSecOps because it binds changes in the repository to a verified identity. This prevents attackers or compromised accounts from silently introducing malicious code, backdoors, or configuration changes. Signed commits enable automated pipelines and reviewers to trust the provenance of changes and to enforce policies such as “only signed commits from trusted keys are allowed into protected branches”


## Task 2 — Pre-commit Secret Scanning

### Hook Setup

A local Git pre-commit hook was created at:

.git/hooks/pre-commit

The hook:

* Collects staged files.

* Runs TruffleHog (Docker) on non-lectures/ files.

* Runs Gitleaks (Docker) on all staged files.

* Blocks commits if secrets are detected in non-excluded files.

The hook was made executable:

```bash
chmod +x .git/hooks/pre-commit
```

### Blocked Commit (Secrets Detected)

A test AWS secret was added to:

labs/lab3/fake-secret.txt

When attempting to commit:

```bash
git commit -S -m "test: add fake secret"
```

The hook detected a secret and blocked the commit.

Example output:

[pre-commit] scanning staged files for secrets…
[pre-commit] TruffleHog scan on non-lectures files…
✖ TruffleHog detected potential secrets in non-lectures files
✖ COMMIT BLOCKED: Secrets detected in non-excluded files.
Fix or unstage the offending files and try again.

This demonstrates that the hook prevents sensitive data from entering the repository history.

(Optional screenshot path: labs/img/lab3-secret-blocked.png)

### Successful Commit (No Secrets)

After removing the test secret file:

```bash
git reset HEAD labs/lab3/fake-secret.txt
rm labs/lab3/fake-secret.txt
```

A new commit was attempted:

```bash
git add labs/submission3.md
git commit -S -m "docs(lab3): finalize secret scanning task"
```

The hook scanned the files and allowed the commit:

✓ No secrets detected in non-excluded files; proceeding with commit.

### Why Automated Secret Scanning Matters

Automated pre-commit scanning shifts security left into the developer workflow.
It prevents accidental leaks of:

* API keys

* Cloud credentials

* JWT secrets

Database passwords

By blocking commits locally, secrets never reach remote repositories or commit history, significantly reducing the risk of credential exposure and incident response costs.

This aligns with DevSecOps principles by integrating security controls directly into the development lifecycle.
