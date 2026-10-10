# Privacy and Cookie Audit — Local Pre-launch Store

- **Observed:** 2026-10-10.
- **Target:** `http://localhost:8080`, DefaultClean storefront.
- **Status:** initial technical inventory plus owner-approved analytics/newsletter changes verified on 2026-10-10; not a privacy policy, legal opinion, or launch approval.
- **Scope:** the initial audit was read-only. In a subsequent approved step, Google Analytics was deactivated and the Newsletter subscription type's default selection was disabled. No other settings, including payment and checkout, were changed. The separately approved Shipping & Returns layout-test publication is recorded in the content register.

## Method and limits

Used a separate, fresh, unauthenticated browser session for `/`, `/register`, `/login`, `/contactus`, `/passwordrecovery`, and the empty `/cart`. Did not use the administrator's cookies to infer public visitor behavior. The isolated browser was closed after inspection.

No account, newsletter, contact, login, cart-add, checkout, or payment forms were submitted. Normal browsing can itself create cookies and guest records. No customer records, actual orders, passwords, card details, or cookie/token values were recorded in this report. Cookie metadata and storage key names were inspected, not their values.

Admin settings are evidence of configuration, not proof that every feature works or that data has already been collected. Full checkout, authenticated account behavior, third-party delivery, server logs, backups, retention jobs, and production hosting were not tested. Local source inspection does not establish that the running container uses the same revision.

## Priority findings and decisions

| Finding | Evidence | Current disposition / next step |
| --- | --- | --- |
| Placeholder analytics was active; now disabled | Initial audit found an active Google Analytics widget and `G-XXXXXXXXXX`. After owner-approved deactivation, no Google analytics script, inline `gtag` call, or external resource request was observed on six sampled routes | Completed locally. Plugin configuration retained, not uninstalled or replaced with a real ID. Reintroduce only after measurement, disclosure, and consent requirements are decided and tested. |
| No cookie-consent notice observed | No notice found in the initial fresh homepage check; `DisplayEuCookieLawWarning=false`; this setting was not changed | Decide the required consent design for the eventual technologies and applicable law. Enabling a warning alone is not proof that optional scripts are blocked. |
| Newsletter was selected by default; now unchecked | After owner-approved change to subscription type 1, registration checkbox `NewsLetterSubscriptions[0].IsActive` starts unchecked and can still be selected | Completed locally. Newsletter functionality remains enabled; agree wording and operational unsubscribe/consent records before launch. |
| Manual credit-card payment method active | Admin lists active `Payments.Manual` as Credit Card and active Check / Money Order | Do not use real card details in testing. Decide the real payment approach and review/disable unsuitable test methods with approval. Do not claim that the store never handles/stores card data. |
| Store is not in closed-store mode | `StoreInformationSettings.StoreClosed=false` | Treat pre-launch text as information only, not a technical checkout restriction. Confirm isolation from real customers and decide launch safeguards separately. Localhost access alone is not evidence that no other network path exists. |
| Business identity, support, recipients, and retention remain unresolved | Owner has deferred public contact details; hosting/mail/delivery/payment arrangements and retention were not established in this audit | Resolve the policy inputs below before approving a final Privacy Notice. |

The disabled consent-related settings do not, by themselves, establish a legal violation. Applicable obligations need Zimbabwe-specific review.

## Data collection surfaces

| Surface | Observed/configured data | Qualifications |
| --- | --- | --- |
| Registration | First name, last name, email, password/confirmation; gender and company fields; newsletter choice | First/last name and email show required validation. Gender/company are not marked required. No registration submitted. Password fields are present; no claim about password storage was verified here. |
| Login | Email, password, remember-me; phone/login-by-phone controls also exist in the page DOM | Visibility and functioning of every login mode were not tested. No credentials submitted. |
| Contact Us | Full name, email, enquiry | Form exists, but email routing remains unconfigured per the owner. No enquiry submitted; do not claim an operating support channel. |
| Password recovery | Email | No recovery request submitted. |
| Newsletter | Email in footer; subscription checkbox in registration | Registration choice now starts unchecked after the approved follow-up. No subscription created and no existing subscribers changed. |
| Billing/delivery addresses | Admin enables street address, second address line, city, postal code, country/state, phone, company, fax | Street address, city, postal code, and phone are configured required; company, second line, and fax optional. Actual checkout was not exercised. |
| Visitor identification | Persistent `.Nop.Customer` cookie; `CustomerSettings.StoreIpAddresses=true` | Indicates guest/customer identification and configured IP storage; retention and actual database/log contents were not inspected. |
| Orders/payments | Active manual-card and Check / Money Order plugins | No orders placed; full checkout field and storage behavior remain to be verified before production. |

Additional Admin observations:

- `CustomerSettings.AcceptPrivacyPolicyEnabled=false`.
- `GdprEnabled=false`; do not assume self-service export/deletion or consent logging is available.
- Avatar upload and public profile viewing settings are disabled.
- CAPTCHA is globally disabled; no CAPTCHA resource was observed on the sampled public routes.

## Cookie inventory — anonymous local browsing

All observed cookies use domain `localhost`, path `/`. Expiries below are approximate lifetimes measured when the fresh visit began, not promises about future versions or production settings.

| Cookie | Approximate expiry | HttpOnly | Secure on local HTTP | Purpose assessment |
| --- | --- | --- | --- | --- |
| `.Nop.Antiforgery` | Browser session | Yes | No | Consistent with anti-forgery form protection; SameSite `Strict` observed. |
| `.Nop.Customer` | 365 days | Yes | No | Consistent with guest/customer recognition. Cart association and lifecycle need further behavior/source verification before final policy wording. |
| `.Nop.Culture` | 365 days | No | No | Consistent with language/culture preference. |

Purpose assessments are provisional, based on the framework cookie names and observed context, rather than a completed end-to-end functional test. SameSite was not supplied in the tool result for Customer/Culture, so no effective behavior is asserted for those cookies.

No `_ga` cookie was observed during these checks. No localStorage or sessionStorage keys were present at the initial homepage or final registration check. These observations do not rule out cookies/storage introduced by login, a populated cart, checkout, later script execution, or future integrations. Authentication-cookie lifetime was not audited.

The `Secure=false` observations apply to this HTTP localhost instance. Verify HTTPS, cookie flags, proxy behavior, and actual lifetimes on the deployment target before launch.

## Third-party integrations

### Google Analytics

Current state: widget disabled after owner approval; its configuration remains in place. Fresh-browser verification is recorded below.

Initial observations before that change:

- Widget active; placeholder measurement ID configured.
- API secret empty; ecommerce and customer-ID inclusion options disabled.
- Public script reference and attempted resource load observed on the sampled routes.
- Resource timing reported status `0` and transfer size `0`; this is not evidence of successful analytics collection or proof that no external communication occurred. No successful analytics event delivery was established.
- At initial audit, neither “we do not use analytics” nor “Google Analytics collects our visitors' activity” was established as a verified operational fact. Subsequent checks support the narrower statement that the disabled widget did not load analytics on the six sampled anonymous routes; they do not establish production or authenticated/checkout behavior.

### Other widgets

- Facebook Pixel: inactive in widget list; no Facebook resource observed on sampled routes.
- Jotform: active in widget list, but its own `Enabled` setting is false and embed code empty; no Jotform request observed on sampled routes. Do not list it as an operating data recipient without further evidence.
- Swiper: active; no external recipient established by this audit.

### Payment caution — supporting source evidence

Local read-only source at `nopcommerce-src/src/Plugins/Nop.Plugin.Payments.Manual/ManualPaymentProcessor.cs` sets `AllowStoringCreditCardNumber = true` in payment processing and reads cardholder name, number, expiry, and card code from the payment form. This is an additional reason not to make a “we never store card details” promise or test with real cards. It is not proof of the running container's exact implementation or of any card data already stored.

## Inputs needed before final policy drafts

1. Legal operator name and address; a monitored privacy/support contact. The public brand `Arity Shop` is confirmed, but is not itself a verified legal entity identity.
2. Production hosting provider/location, database/backups, email service, and who can access customer information.
3. Payment provider and actual card-data flow; delivery partners and which customer details they receive; supplier access to fulfilment information.
4. Whether analytics, advertising, chat, and newsletters will be used; opt-in/opt-out controls and evidence of choices.
5. Retention rules for accounts, guest records, orders, enquiries, logs, backups, and consent records, taking applicable recordkeeping obligations into account.
6. Practical procedures for access/correction/deletion requests, complaints, account closure, and incidents.
7. Qualified review of applicable Zimbabwean privacy, consumer, electronic-commerce, and any cross-border processing requirements. Historical South Africa notes in this repository are not a substitute.

## Approved changes and verification — 2026-10-10

The owner approved only these two changes:

1. **Configuration → Widgets** (`/Admin/Widget/List`): changed `Widgets.GoogleAnalytics` from active to inactive. Reloaded the list to verify persistence. Display order stayed `1`; Facebook Pixel, Jotform, and Swiper activation flags were unchanged. No analytics credentials or configuration were altered.
2. **Promotions → Subscription types → Newsletter** (`/Admin/NewsLetterSubscriptionType/Edit/1`): changed `TickedByDefault` from true to false. Admin reported a successful update; reloaded to confirm persistence. Name, store scope, and display order were unchanged. Global newsletter functionality and existing subscriber records were not changed.

Used another fresh anonymous browser session, separate from the administrator, and checked `/`, `/register`, `/login`, `/contactus`, `/passwordrecovery`, and empty `/cart` after loading each page and allowing 1.2 seconds for immediate scripts:

- No Google Analytics/Tag Manager script references or inline `gtag` calls detected on any sampled page.
- No external resource requests appeared in the sampled pages' resource-timing entries. This bounded observation does not cover delayed interactions, authenticated pages, or checkout.
- Registration newsletter checkbox starts unchecked, remains enabled, can be selected, and can be deselected. No registration or newsletter form was submitted.
- Cookie inventory remained `.Nop.Culture`, `.Nop.Antiforgery`, and `.Nop.Customer`, with the same observed lifetimes/flags. No `_ga` cookie observed.
- No localStorage or sessionStorage keys on the sampled routes.
- Closed only the isolated verification browser; preserved the operator's Chrome session.

Payment methods, store-closed mode, consent banner/GDPR controls, email, delivery, and launch settings were not changed. No Privacy Notice or Cookie Policy has been published by this step.

## Next bounded step

The owner approved the [Cookie Policy draft](cookie-policy-draft.md) and [Privacy Notice draft](privacy-policy-draft.md) wording as working pre-launch drafts and authorized committing the content package, explicitly acknowledging it is not production-ready. Both remain unpublished; unresolved operator/contact, recipients, retention, controls, and rights-handling inputs are explicitly marked. This approval does not authorize further publication or launch. Obtain a separate decision on the active manual-card payment method before real-user/payment testing. Repeat the inventory on the actual deployment target and after integration changes before approving final policies.
