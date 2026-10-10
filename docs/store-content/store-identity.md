# Arity Shop — Store Identity Settings

Status: approved, saved through Admin, and verified on the local store at `http://localhost:8080`. This is not a production deployment or public launch.

## Approved settings

Under **Configuration → Stores → Edit** (`/Admin/Store/Edit/1`):

| Admin field | Previous value | Approved saved value |
| --- | --- | --- |
| Store name (`Name`) | Your store name | Arity Shop |
| Default title (`DefaultTitle`) | Your store | Arity Shop |
| Homepage title (`HomepageTitle`) | Home page title | Online Shopping in Zimbabwe |
| Homepage description (`HomepageDescription`) | Home page description | Arity Shop is preparing to launch in Harare, with plans to make online shopping simpler for households and small businesses across Zimbabwe. |

Under **Configuration → Settings → General settings → Social media** (`/Admin/Setting/GeneralCommon`):

| Field | Previous value | Saved value |
| --- | --- | --- |
| Facebook | `https://www.facebook.com/nopCommerce` | Empty |
| X | `https://x.com/nopCommerce` | Empty |
| YouTube | `https://www.youtube.com/user/nopCommerce` | Empty |
| Instagram | `https://www.instagram.com/nopcommerce_official` | Empty |

TikTok, Snapchat, Pinterest, and Tumblr were already empty and remain unchanged. Add only confirmed Arity Shop accounts in a later approved change.

## Verification

- Both Admin forms returned successful-update confirmations; saved values were checked after navigation.
- Homepage document title: `Arity Shop. Online Shopping in Zimbabwe`.
- Homepage meta description matches the approved value above.
- Logo alternative text: `Arity Shop`.
- Footer copyright names `Arity Shop`.
- The public social-links block contains no links.
- About Us document title: `Arity Shop. About Arity Shop | Online Shopping in Zimbabwe`. Its approved page-specific title and description remain unchanged.
- Only the four store fields and four populated social fields were changed. Store URL, theme, title separator/order, payment, shipping, email, and launch/indexing controls were not intentionally changed.

## Deferred work

- The existing `. ` title separator remains unchanged. About Us now repeats the brand because its page-specific meta title also contains `Arity Shop`; any title cleanup needs a separately reviewed copy change.
- The store record still contains sample company name, address, phone, and host-name values. Replace these only once the correct business and deployment details are confirmed; do not invent contact details or treat the public brand as a verified legal entity name.
- Completed separately after approval: the [homepage welcome copy](homepage-welcome.md) replaced the nopCommerce placeholder and was verified on the local homepage. See the [publication record](README.md#homepage-welcome-publication-verification).
- Contact Us details and email delivery remain undecided/deferred; see the [content register](README.md).
