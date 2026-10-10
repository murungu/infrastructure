# Arity Shop — Store Content

This directory holds the canonical, reviewable copy for store information pages. Keep page text and SEO metadata here so changes can be reviewed in Git before they are entered into nopCommerce Admin.

## Page register

| Page | Source | Topic system name | Review status | Local publication status |
| --- | --- | --- | --- | --- |
| About Us | [about-us.md](about-us.md) | `AboutUs` | Approved for pre-launch | Published and verified at `http://localhost:8080/about-us` |
| Contact Us | Not drafted | `ContactUs` | Pending; public contact details undecided | Enquiry delivery is not configured |
| Shipping & Returns | [shipping-returns-draft.md](../legal/shipping-returns-draft.md) | `ShippingInfo` | Approved for local layout testing only; final policy pending | Published and verified at `http://localhost:8080/shipping-returns` |
| Homepage welcome | [homepage-welcome.md](homepage-welcome.md) | `HomepageText` | Approved for pre-launch | Published and verified at `http://localhost:8080/` |
| Privacy Notice | [privacy-policy-draft.md](../legal/privacy-policy-draft.md) | `PrivacyInfo` | Owner-approved working pre-launch draft; business inputs and legal review pending | Not published; existing Admin content unchanged |
| Cookie Policy | [cookie-policy-draft.md](../legal/cookie-policy-draft.md) | `CookiePolicy` (proposed) | Owner-approved working pre-launch draft; final inventory, controls, and legal review pending | Not published; topic and footer link not created |

Store-wide identity and SEO settings are recorded separately in [store-identity.md](store-identity.md); the approved changes are saved and verified locally.

Legal and policy drafts remain in [../legal/](../legal/README.md). Link them here as they are prepared rather than maintaining duplicate copies.

## Confirmed business context

- Public brand: **Arity Shop**.
- Stage: **pre-launch**.
- Planned base and initial service area: **Harare and surrounding areas, Zimbabwe**.
- Audience: households, including homeowners and renters, and small businesses.
- Direction: a general online store, with a broader selection and local business partnerships as it grows. Solar products are the initial setup/testing focus, not the permanent brand boundary.
- Goals: easier online shopping, doorstep delivery, good value, and online visibility for businesses without an online presence.
- Delivery arrangements and coverage are still being developed. Do not imply nationwide delivery or established logistics.
- Delivery direction: considering own deliveries with a few bikes initially, with partners as growth requires. Product size/weight and handling suitability still need assessment.
- Fulfilment direction: likely partner-sourced initially, then a mix of partner sourcing and own stock as demand grows.
- Delivery charges, timing, returns, and customer collection remain undecided/unconfirmed. The [Shipping & Returns draft](../legal/shipping-returns-draft.md) records the open decisions and publication gate.
- Do not promise lower prices, confirmed partners, installation services, or other unverified capabilities.
- Contact-form email delivery is not configured. Do not invite enquiries until it is configured and tested.

## Review and publication workflow

1. Update the page's Markdown copy and metadata; obtain approval before publishing material wording changes.
2. Open **Admin → Content management → Topics** and select the existing topic. Confirm its system name rather than relying only on the recorded numeric ID.
3. Preserve the established system name and URL slug.
4. Set the topic title from `page_title`. Paste only the page body into the editor, preserving paragraph and heading formatting. Do not paste YAML frontmatter or the editorial comment. The topic title supplies the H1; body section headings are H2.
5. Set the SEO meta title and description from the source file.
6. Save the approved topic and check the public page against the source, including heading hierarchy and desktop/mobile readability. Confirm the SEO fields were saved.
7. Update the source's publication status and this register only after verification. Record the target instance; publication to `http://localhost:8080` does **not** mean a production deployment.

Keep publication status separate from copy approval. Do not change store-wide settings or public-launch/indexing controls as a side effect of editing a page.

## Pre-launch follow-ups

- Configure Contact Us email routing and verify end-to-end delivery to a monitored inbox before adding a contact invitation to About Us.
- Confirm delivery areas, charges, timeframes, and returns handling before writing customer-facing delivery promises. Shipping & Returns now contains explicitly provisional layout-test text, not a launch-ready policy.
- Completed: disabled the placeholder Google Analytics widget and made Newsletter subscription unselected by default with owner approval; verified fresh visitor behavior on six routes. See the [privacy/cookie audit and verification record](../legal/privacy-cookie-audit.md).
- Still pending from that audit: manual-card payment remains active and `StoreClosed=false`; obtain separate approval for payment/launch changes and do not use real customer/card data in testing.
- Completed: the owner approved the [Privacy Notice draft](../legal/privacy-policy-draft.md) and [Cookie Policy draft](../legal/cookie-policy-draft.md) wording for version control as working pre-launch drafts, explicitly acknowledging they are not production-ready. Both remain unpublished and contain unresolved markers.
- Resolve privacy policy inputs: legal operator/contact, hosting/email/payment/delivery recipients, retention, customer-rights procedures, and qualified Zimbabwe-specific review.
- The owner authorized committing the reviewed content package. A Git commit records these files, not the Admin database; deployment, further publication, and launch require separate approval.
- Prepare the remaining information and policy pages. Confirm the applicable Zimbabwean legal requirements; older repository notes about South Africa are not a substitute for that review.
- Revisit the About Us pre-launch wording when real ordering and fulfilment are ready.
- Completed: published the approved [homepage welcome copy](homepage-welcome.md), replacing the generic nopCommerce introduction and documentation/forum links.
- Confirm company/legal identity, address, phone, deployment host names, and official social accounts before replacing the remaining sample values. See [store identity follow-ups](store-identity.md#deferred-work).
- Completed: replaced the default store name and title prefix with `Arity Shop`, set approved homepage SEO metadata, and removed nopCommerce social links through a separately approved local settings update.

## Analytics and newsletter verification

- On 2026-10-10, deactivated only `Widgets.GoogleAnalytics` and set Newsletter subscription type 1 (`TickedByDefault`) to false through Admin. Reloaded the relevant Admin pages to verify persistence.
- A fresh anonymous browser showed no Google analytics script or inline `gtag` call and no external resource requests on `/`, `/register`, `/login`, `/contactus`, `/passwordrecovery`, and empty `/cart` during the checks.
- Registration newsletter selection starts unchecked and can still be opted into. No forms were submitted; existing subscribers were not changed.
- Other settings, including payment, checkout, cookie warning, GDPR, and newsletter enablement, were unchanged. These local checks are not production or legal-compliance certification.

## Shipping & Returns publication verification

- On 2026-10-10, published only the owner-approved provisional body and title to topic 9 (`ShippingInfo`), retaining the prominent pre-launch notice. Internal planning notes were not published.
- Confirmed server-side successful update and exact whitespace-normalized public body match; four H2 sections and no horizontal page overflow at 375px, 768px, and 1280px. Restored the previous viewport dimensions.
- Preserved the existing slug, SEO, and other topic settings. No production deployment or launch/checkout setting changes.
- The subsequent [privacy/cookie audit](../legal/privacy-cookie-audit.md) was initially read-only; its separately approved analytics/newsletter changes are recorded above. No Privacy Notice or Cookie Policy has yet been published.

## Homepage welcome publication verification

- Saved topic 5 (`HomepageText`) through Admin and received the successful-update confirmation.
- Changed only the topic title and body; preserved the system name, existing slug (`welcome-to-our-store`), published state, and other topic settings. Homepage SEO settings were unchanged.
- Verified `Welcome to Arity Shop` and an exact whitespace-normalized match between the rendered body and the approved source copy.
- Verified the only body link is `Learn more about Arity Shop` pointing to `/about-us`; the destination returns HTTP 200.
- Checked 375px, 768px, and 1280px viewports: all three body paragraphs present and no horizontal page overflow. Restored the previous viewport dimensions.
- Local publication only; no production deployment or launch-setting changes.

## About Us publication verification

- Connected to the operator's existing authenticated Chrome session after allowing time for the browser-control approval. Initial CDP timeouts did not mean approval was unavailable; use bounded retries when the operator is approving access.
- Saved topic 1 (`AboutUs`) through Admin; received the successful-update confirmation.
- Updated only the title, body, meta title, and meta description. Preserved the `about-us` slug, existing published state, and disabled sitemap inclusion. No store-wide settings changed.
- Verified the rendered public body matches the canonical Markdown text after whitespace normalization, with one H1 and four H2 section headings and no contact invitation.
- Verified the SEO description and topic meta title. The initial publication retained the `Your store.` prefix; the subsequent approved [store identity update](store-identity.md) replaced it with `Arity Shop.`.
- Checked 375px, 768px, and 1280px viewports: all four sections present and no horizontal page overflow. Restored the previous viewport dimensions.
- Publication is local only; no production deployment or public launch was performed. Contact email setup remains deferred.
