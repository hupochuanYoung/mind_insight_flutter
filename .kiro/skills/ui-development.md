# UI Development Skill — MindInsight Common Widgets Guide

When building new pages, components, or dialogs for the MindInsight Flutter app, **always use** the shared widgets and utilities from `mind_insight/lib/src/core/`. Do not reinvent existing components.

## Project Structure

```
mind_insight/lib/src/
├── core/
│   ├── component/       # Shared UI widgets (barrel: components.dart)
│   ├── constant/        # Colors, dimensions, text styles, images
│   └── helper/          # Date, toast, general utilities
└── features/
    └── <feature>/
        ├── business/       # BLoC / state logic
        ├── data/           # Models, repositories, data sources
        └── presentation/
            ├── provider/   # Riverpod providers (if applicable)
            ├── screen/     # Full-page screens
            └── widget/     # Feature-specific widgets
```

## Buttons

| Scenario | Widget | Notes |
|----------|--------|-------|
| Primary action (full-width) | `AppActionButton` | Default gold bg; pass `backgroundColor`/`foregroundColor` to customize |
| With icon | `AppActionButton(icon: Icons.xxx, ...)` | Icon variant via named param |

Import: `package:mind_insight/src/core/component/components.dart`

Do NOT use raw `ElevatedButton`, `TextButton`, or `OutlinedButton` for primary actions. Wrap your interactions through `AppActionButton` or create a named constructor variant if you need a secondary/danger style.

## Cards & Containers

| Scenario | Widget |
|----------|--------|
| Info card with icon + title + body | `AppInfoCard` |
| Clickable option tile (icon, title, subtitle) | `AppOptionTile` |
| Tarot reading list item | `AppReadingTile` |
| Icon badge (rounded square) | `AppIconBadge` |

## Layout

| Scenario | Widget |
|----------|--------|
| Main shell with bottom nav | `MasterLayout` (in `portal_master_layout.dart`) |
| Section header text | `AppSectionTitle` |

## Empty & Loading States

| Scenario | Widget |
|----------|--------|
| Full-page empty state | `AppEmptyState(icon, title, subtitle)` |
| Loading spinner | `const Center(child: CircularProgressIndicator())` |

## Tarot-Specific Widgets

| Scenario | Widget |
|----------|--------|
| Single tarot card image | `TarotCardView(assetPath: ...)` |
| Fan/stack of 3 cards | `TarotCardStack(assetPaths: [...])` |
| Asset path helper | `TarotAssets.card(number)` or `TarotAssets.sampleSpread` |

## Notifications & Feedback

| Scenario | Usage |
|----------|-------|
| Success toast | `ToastHelper.showSuccessToast('message')` |
| Error toast | `ToastHelper.showErrorToast('message')` |
| Info toast | `ToastHelper.showToast('message')` |
| Loading overlay | `ToastHelper.showLoading(context: context, msg: '...')` |
| Dismiss loading | `ToastHelper.closeLoading(context)` |

## Colors — `ColorResources`

Import: `package:mind_insight/src/core/constant/app_color_resources.dart`

**Never hardcode color values.** Use `ColorResources` constants:

| Token | Color | Hex |
|-------|-------|-----|
| `primary` | Purple | `#7C6FCB` |
| `primarySoft` | Light purple bg | `#F0ECFF` |
| `ink` | Dark text | `#211D33` |
| `muted` | Secondary text | `#7A748C` |
| `surface` | Page background | `#FFFBF4` |
| `card` | Card white | `#FFFFFF` |
| `border` | Light border | `#ECE7DF` |
| `gold` | Accent gold | `#FFC65A` |
| `teal` | Accent teal | `#2F9C95` |
| `pink` | Accent pink | `#E86F9D` |
| `amber` | Accent amber | `#FFB13B` |
| `success` | Green | `#2F9C95` |
| `warning` | Amber | `#FFB13B` |
| `error` | Red | `#E5484D` |
| `info` | Purple | `#7C6FCB` |

Context-aware helpers (adapt to dark/light mode):
- `ColorResources.getBackgroundColor(context)`
- `ColorResources.getHintColor(context)`
- `ColorResources.getDividerColor(context)`
- `ColorResources.getErrorColor(context)` → returns `[iconColor, bgColor, borderColor]`
- `ColorResources.getWarningColor(context)` → same pattern
- `ColorResources.getSuccessColor(context)` → same pattern
- `ColorResources.getColorFromInitial(name)` → avatar color from string

## Dimensions — `Dimensions`

Import: `package:mind_insight/src/core/constant/app_dimensions.dart`

### Padding constants
`paddingSizeExtraSmall (4)` · `paddingSizeSmall (8)` · `paddingSizeDefault (12)` · `paddingSizeMedium (16)` · `paddingSizeLarge (20)` · `paddingSizeExtraLarge (24)` · `paddingSizeOverLarge (32)`

### Border radius constants
`radiusSmall (4)` · `radiusDefault (8)` · `radiusMedium (12)` · `radiusLarge (16)` · `radiusExtraLarge (24)` · `radiusCircular (100)`

### Font sizes
`fontSizeExtraSmall (10)` · `fontSizeSmall (12)` · `fontSizeDefault (14)` · `fontSizeMedium (15)` · `fontSizeLarge (16)` · `fontSizeExtraLarge (18)` · `fontSizeOverLarge (24)` · `fontSizeHuge (32)`

### Gap shortcuts (from `gap` package)
Use `kGap2`, `kGap4`, `kGap6`, `kGap8`, `kGap10`, `kGap12`, `kGap16`, `kGap20`, `kGap24`, `kGap32`, `kGap40`, `kGap48` for vertical/horizontal spacing inside `Column` / `Row`.

## Text Styles — `app_text_styles.dart`

Import: `package:mind_insight/src/core/constant/app_text_styles.dart`

| Style | Size | Weight |
|-------|------|--------|
| `textSmall` | 12 | w400 |
| `textBoldSmall` | 12 | w700 |
| `textRegular` | 14 | w400 |
| `textMedium` | 14 | w500 |
| `textBold` | 14 | w700 |
| `textLarge` | 16 | w500 |
| `textBoldLarge` | 16 | w700 |
| `textExtraLarge` | 18 | w700 |
| `textOverLarge` | 24 | w700 |

Utilities:
- `textMuted` — regular style + muted color
- `sectionHeaderStyle(themeData)` — bold small + letter spacing

Adjust with `.copyWith(color: ..., fontSize: ...)`.

## Images — `Images`

Import: `package:mind_insight/src/core/constant/images.dart`

- `Images.tarotCard(cardName)` — tarot card asset path
- Add new asset path constants here, not scattered in feature code.

## Helpers

### DateConverter (`core/helper/date_converter.dart`)
| Method | Output |
|--------|--------|
| `DateConverter.timeAgo(dateTime)` | "2 minutes ago", "yesterday" |
| `DateConverter.formatDate(dt)` | "2026-08-13" |
| `DateConverter.formatTime(dt)` | "14:30" |
| `DateConverter.formatDateTime(dt)` | "2026-08-13 14:30" |
| `DateConverter.formatDateReadable(dt)` | "13 Aug 2026" |
| `DateConverter.isSameDay(a, b)` | bool |

### GeneralHelper (`core/helper/general_helper.dart`)
| Method | Purpose |
|--------|---------|
| `GeneralHelper.truncateName(name)` | Truncate with ellipsis |
| `GeneralHelper.isNumeric(value)` | Check parsable as double |
| `GeneralHelper.capitalize(text)` | Capitalize first letter |
| `GeneralHelper.greetingByTime()` | "Good morning" / "Good afternoon" / "Good evening" |

### ToastHelper (`core/helper/toast_helper.dart`)
See "Notifications & Feedback" section above.

## Routing

This project uses `go_router` with `StatefulShellRoute` for tab navigation. The `MasterLayout` wraps the `StatefulNavigationShell`.

## Rules Summary

1. **Check `core/component/` first** before creating a new widget. If an existing widget is close but not perfect, extend it via parameters rather than duplicating.
2. New **shared** widgets go in `core/component/`. Feature-specific widgets go in `features/<feature>/presentation/widget/`.
3. Spacing: use `kGap*` constants inside Flex widgets, and `Dimensions.paddingSize*` for `EdgeInsets`.
4. Colors: always use `ColorResources.*` — never hardcode hex values.
5. Text styles: use `textRegular`, `textBold`, etc. from `app_text_styles.dart` with `copyWith` for adjustments.
6. Radii: use `Dimensions.radius*` constants — never inline magic numbers.
7. Date/time formatting: use `DateConverter` — do not write custom formatters.
8. Toasts/snackbars: use `ToastHelper` — do not call `ScaffoldMessenger` directly.
9. Asset paths: register in `Images` or `TarotAssets` — do not scatter path strings in feature code.
10. All user-visible text should be prepared for i18n. When localization is added, no hardcoded strings should need refactoring.
11. New constants belong in the corresponding `core/constant/` file based on type.
12. When in doubt about which widget to use, import `components.dart` barrel and browse available exports.
