---
page_title: Cookie Policy
system_name: CookiePolicy
public_path: /cookie-policy
topic_creation_required: true
meta_title: Cookie Policy | Arity Shop
meta_description: Review the cookies observed in Arity Shop's pre-launch test store, how to manage them in your browser, and the checks required before launch.
content_status: approved_prelaunch_draft
approval_scope: wording_and_version_control_only
publication_status: not_published
business_stage: pre-launch
launch_ready: false
evidence: privacy-cookie-audit.md
---

# Cookie Policy — Review Draft

**Owner-approved working pre-launch draft; not published.** The owner approved this wording for version control, acknowledging it is not production-ready. The topic and proposed `/cookie-policy` route have not been created. This draft describes the audited local test store, not the eventual production service. The audit took place on 2026-10-10. Cookie purposes below are provisional assessments; authenticated and checkout behavior still need verification. Approval of this draft for version control is not approval for publication or launch.

## Proposed page body

> **Pre-launch draft.** Arity Shop is preparing to launch. This page describes cookies observed during checks of our local test store. The cookie inventory and controls must be checked again on the final service before launch.

### What are cookies?

Cookies are small pieces of information that a website asks your browser to store. The browser can send them back on later requests, helping a website recognise a visitor or remember information between pages.

A session cookie is associated with a browser session. A persistent cookie has an expiry date and may remain until it expires or you delete it. Some browsers can restore session cookies when restoring a previous browsing session.

### Cookies observed in our test store

The following cookies were found during fresh, signed-out visits to the homepage, registration, login, contact, password-recovery, and empty-cart pages. All were set for the local store's `localhost` domain.

| Cookie | Provisional purpose | Observed expiry |
| --- | --- | --- |
| `.Nop.Antiforgery` | Consistent with protecting forms against forged requests. | Browser session. |
| `.Nop.Customer` | Consistent with recognising a guest or customer between requests. Its relationship to basket and account activity still needs verification. | Approximately one year from the observed visit. |
| `.Nop.Culture` | Consistent with remembering the language or culture used by the site. | Approximately one year from the observed visit. |

These purpose descriptions are based on the cookie names and technical context. Their precise behavior and classification must be confirmed before the final policy is approved. Cookie expiry does not establish how long related information is kept on the server.

[TO CONFIRM: the deployment domain, exact purposes and lifetimes, which cookies are strictly necessary for requested functions, and any additional cookies set by signing in, a populated basket, checkout, or integrations.]

### Analytics, advertising, and chat

Google Analytics and Facebook Pixel are disabled in the audited local configuration. The Jotform chat integration is not configured to run.

After Google Analytics was disabled, the sampled signed-out pages showed no Google analytics script or inline `gtag` call, and no external resource requests appeared during the checks. No Google Analytics `_ga` cookie was observed. These are limited test observations, not a guarantee about untested features or future changes.

If optional analytics, advertising, or chat tools are introduced, the cookie inventory, disclosures, and any required consent controls need to be reviewed and tested before those tools are enabled.

### Other browser storage

Websites can also use browser storage called localStorage and sessionStorage. Neither contained stored entries during the follow-up checks of the sampled pages. This does not establish that other features, signed-in sessions, or future integrations never use that storage.

### Managing cookies

Your browser settings usually let you inspect stored cookies, delete them, and control whether websites can store cookies. The available controls depend on your browser.

Blocking or deleting cookies may affect form submission, recognition between visits, or other site features. Deleting a browser cookie does not by itself delete an account, order, or related information stored on the server.

The local test store does not currently show a cookie-preference panel. This draft does not offer a “manage preferences” control that has not been implemented.

[TO CONFIRM: the controls needed for the final cookie inventory and applicable law, how optional tools are blocked until any required choice, and how that choice can be changed later.]

### Questions and updates

Our privacy contact details are still being finalised. A monitored contact channel will need to be confirmed before this policy is ready for launch.

[TO CONFIRM: privacy contact and a link to the approved Privacy Notice.]

This draft must be updated if the site's cookies or integrations change. An effective date will be added when the completed policy is approved and published.

---

## Internal review and publication checklist — do not publish

- [ ] Verify cookie purposes from implementation and behavior, rather than treating the provisional classifications as established facts.
- [ ] Repeat the inventory on the actual HTTPS deployment domain and with account login, populated cart, checkout, and intended integrations. Verify authentication-cookie lifetime, expiry renewal, relevant flags, and other browser storage.
- [ ] Review strictly necessary versus optional classification and any consent requirements with a qualified adviser familiar with applicable Zimbabwean law. Do not claim either that a banner is always required or that the three observed cookies are automatically exempt.
- [ ] Implement and test any required choice/withdrawal controls. A warning alone is not proof that optional scripts are blocked. Do not interpret continued browsing as consent by default.
- [ ] Confirm privacy contact and final notice; remove or complete every `[TO CONFIRM: ...]` item and replace local-test wording before approving a production policy.
- [ ] Obtain separate approval before creating the `CookiePolicy` topic, publishing it, adding a footer menu item, or changing sitemap/indexing settings. Preserve existing routes and recheck that a duplicate topic has not been created in the meantime.
- [ ] Set the effective date only when appropriate. Publish only approved page copy and metadata—not frontmatter, this checklist, or unresolved editorial instructions.

Related records: [Privacy Notice draft](privacy-policy-draft.md), [technical audit](privacy-cookie-audit.md), and [content register](../store-content/README.md).

No Admin topic, menu item, cookie banner, or production change was made as part of drafting this file.
