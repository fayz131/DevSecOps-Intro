# Lab 4 — SBOM Generation & Software Composition Analysis

## Target Application

OWASP Juice Shop  
Image: `bkimminich/juice-shop:v19.0.0`

---

# Task 1 — SBOM Generation

## Tools Used

- Syft (Anchore)
- Trivy (Aqua Security)

Both tools were executed via Docker containers to ensure reproducibility.

---

## Package Type Distribution

### Syft

Syft detected multiple package ecosystems including:

- Node.js packages
- Debian OS packages
- Application dependencies

Syft provided detailed artifact metadata and dependency relationships.

### Trivy

Trivy detected:

- OS packages (Debian 12)
- Node.js dependencies

Trivy grouped packages by scan target rather than artifact structure.

---

## Dependency Discovery Analysis

Syft provided more structured dependency metadata and artifact-level detail.

Trivy focused more on vulnerability context and runtime relevance.

Observation:

- Syft → better SBOM depth
- Trivy → better operational readability

---

## License Discovery Analysis

Syft extracted licenses directly from package metadata.

Trivy detected licenses during image scanning and categorized them by ecosystem.

Syft identified slightly more license entries due to deeper artifact parsing.

Conclusion:

Syft is stronger for compliance-focused SBOM generation.

---

# Task 2 — Software Composition Analysis (SCA)

## Tools Used

- Grype (SBOM-based scanning)
- Trivy (integrated scanner)

---

## Vulnerability Detection Comparison

### Grype

Grype analyzed the Syft SBOM and detected vulnerabilities based on package metadata.

Advantages:

- SBOM-driven analysis
- Accurate dependency matching

### Trivy

Trivy performed direct image scanning including:

- vulnerabilities
- secrets
- license issues

Advantages:

- all-in-one workflow
- faster operational usage

---

## Critical Vulnerabilities Analysis

Top risks identified:

1. Outdated Node.js dependencies
2. Known Debian package vulnerabilities
3. Transitive dependency exposure
4. Medium–High CVSS vulnerabilities affecting web components
5. Multiple dependency chains increasing attack surface

### Recommended Remediation

- Update base image regularly
- Upgrade vulnerable npm dependencies
- Introduce CI vulnerability gates
- Monitor CVE feeds continuously

---

## License Compliance Assessment

Detected licenses include:

- MIT
- Apache-2.0
- ISC
- BSD variants

No strongly restrictive licenses (e.g., GPL conflicts) were identified.

Risk level: **Low–Moderate**

Recommendation:

Introduce automated license policy checks in CI/CD.

---

## Secrets Scanning Results

Trivy secret scanning detected no exposed secrets inside the container image.

This indicates proper handling of credentials within the image build.

---

# Task 3 — Toolchain Comparison

## Accuracy Analysis

Comparison performed using package and CVE overlap analysis.

Findings:

- Majority of packages detected by both tools
- Some packages uniquely detected due to parsing differences
- High overlap in critical CVEs

---

## Tool Strengths and Weaknesses

### Syft + Grype

✅ Deep SBOM generation  
✅ Modular architecture  
✅ Better for compliance and auditing  

❌ Requires multiple tools

---

### Trivy

✅ All-in-one scanner  
✅ Faster setup  
✅ CI/CD friendly  

❌ Slightly less SBOM granularity

---

## Use Case Recommendations

| Use Case | Recommended Tool |
|----------|------------------|
| Compliance & SBOM export | Syft + Grype |
| CI/CD pipelines | Trivy |
| Fast security checks | Trivy |
| Deep supply-chain audits | Syft + Grype |

---

## Integration Considerations

Trivy integrates easily into pipelines with minimal configuration.

Syft + Grype provides more flexible but more complex workflows suitable for enterprise environments.

---

# Conclusion

Both approaches are effective but serve different operational goals:

- Syft + Grype → precision and transparency
- Trivy → automation and simplicity

A hybrid approach provides the strongest supply chain security posture.

## Limitations

Results depend on vulnerability databases and scan timing.
Different tools may report varying results due to metadata interpretation and database updates.
