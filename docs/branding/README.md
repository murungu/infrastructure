# Storefront Themes — Start Here

## Current direction

The owner selected **Meridian as the active theme** on 2026-10-16.
**ArityTheme is paused**, not deleted. DefaultClean remains the upstream reference theme.
This decision changes development priorities, not the active theme in any running store.

Both custom themes remain in `nopcommerce-src/src/Presentation/Nop.Web/Themes/`.
The application uses nopCommerce 5.00. Use its `global.json` for the SDK requirement.

## Start the next session

1. Read the application [scope and safety rules](../../nopcommerce-src/AGENTS.md).
2. Read the [current plan](../../nopcommerce-src/.agent/plan.md).
3. Review the [known issues](../../nopcommerce-src/docs/theme/known-issues.md).
4. Agree on one Meridian requirement and its acceptance criteria before implementation.

No implementation task is selected. Previous backlogs do not define the next task.

## Maintained documentation

| Need | Reference |
| --- | --- |
| Application documentation | [Index](../../nopcommerce-src/docs/README.md) |
| Theme structure | [Architecture](../../nopcommerce-src/docs/theme/architecture.md) |
| Existing overrides | [Override register](../../nopcommerce-src/docs/theme/override-register.md) |
| Checks and approved runtime procedures | [Development reference](../../nopcommerce-src/HARNESS-REFERENCE.md) |
| Infrastructure and backups | [Infrastructure README](../../README.md) |

These application links require the separate private `nopcommerce-src` checkout.
This public repository does not contain the application source.

## Retained references, not a backlog

- [ArityTheme wireframes](../wireframes/README.md) remain historical design references for the paused theme.
- The design rules, viewport plan, worksheet, social notes, and dated audits in this directory are historical ArityTheme references.
- Their state tables, estimates, priorities, and runtime commands are not current instructions or Meridian requirements.
- Meridian uses its own Figtree/red-commerce design. ArityTheme's Inter/black-action rules do not replace that design.
- Screenshots, diagnostic evidence, and milestone records remain intact. Retirement does not mean that their findings are resolved.

The companion Meridian design records remain on the local infrastructure branch `feat/meridian-stage0` at `0fdf477c13ed1d768891fca57a0098012d998f4b`.
They are absent from infrastructure `main`. Publication to this public repository still needs explicit owner approval.

## Removed duplicate instructions

The duplicate theme guide, theme playbook, contribution guide, and old deployment guide are removed.
The application guides above replace them. Their previous contents remain in infrastructure Git history at `d1a2b71ff839e2fec1f029e3d94b67536d38d119`.

No theme code, runtime, database, or stored evidence changed during this cleanup.
