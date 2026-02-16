### Risk Category Delta Table (Baseline vs Secure)

| Category | Baseline | Secure | Δ |
|---|---:|---:|---:|
| container-baseimage-backdooring | 1 | 1 | 0 |
| cross-site-request-forgery | 2 | 2 | 0 |
| cross-site-scripting | 1 | 1 | 0 |
| missing-authentication | 1 | 1 | 0 |
| missing-authentication-second-factor | 2 | 2 | 0 |
| missing-build-infrastructure | 1 | 1 | 0 |
| missing-hardening | 2 | 2 | 0 |
| missing-identity-store | 1 | 1 | 0 |
| missing-vault | 1 | 1 | 0 |
| missing-waf | 1 | 1 | 0 |
| server-side-request-forgery | 2 | 2 | 0 |
| unencrypted-asset | 2 | 1 | -1 |
| unencrypted-communication | 2 | 0 | -2 |
| unnecessary-data-transfer | 2 | 2 | 0 |
| unnecessary-technical-asset | 2 | 2 | 0 |

### Delta Run Explanation

The secure model introduced HTTPS for all user-facing and proxy communication links and enabled transparent encryption for persistent storage.

As a result:

- **Unencrypted Communication risks decreased from 2 to 0 (Δ = -2)**  
  Switching from HTTP to HTTPS removed risks related to plaintext credential/session transmission.

- **Unencrypted Asset risks decreased from 2 to 1 (Δ = -1)**  
  Enabling transparent encryption for persistent storage reduced exposure of data-at-rest.

All other categories remained unchanged because no changes were made to authentication logic, application hardening, WAF, identity store, or infrastructure design.

This demonstrates how targeted architectural security controls (transport encryption and storage encryption) directly impact the threat landscape.
