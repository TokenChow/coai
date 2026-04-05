# TokenChow CoAI - Commercial Fork

## Project Overview

This is a commercial fork of [CoAI](https://github.com/coaidev/coai) (formerly ChatNio), an AI model aggregation platform. We maintain upstream sync while adding commercial features.

## Architecture

| Layer | Tech | Entry |
|-------|------|-------|
| Backend | Go 1.20 + Gin + Viper | `main.go` |
| Frontend | React 18 + TypeScript + Vite + shadcn/ui | `app/src/main.tsx` |
| Database | MySQL / SQLite + Redis | `connection/` |
| Auth | JWT middleware chain | `middleware/` + `auth/` |
| Desktop | Tauri | `app/src-tauri/` |

## Commercial Extension Architecture

All commercial code lives in isolated directories to minimize upstream merge conflicts.

### Backend: `commercial/`

```
commercial/
├── register.go        # Route registration entry point
├── config.go          # Commercial config loader (config/commercial.yaml)
├── billing/           # Billing & payment system
├── tenant/            # Multi-tenant management
└── analytics/         # Usage analytics & reporting
```

- Registered in `main.go` via `commercial.Register(app)` and `commercial.InitConfig()`
- All routes are under `/api/commercial/*`
- Config is in `config/commercial.yaml` (NOT in upstream's config.yaml)

### Frontend: `app/src/commercial/`

```
app/src/commercial/
├── routes/            # Commercial page components
├── components/        # Commercial UI components
├── store/             # Commercial Redux slices
└── api/               # Commercial API client
```

- Routes are defined in `commercial/routes/index.tsx` and spread into the main router
- Redux slices are imported in `app/src/store/index.ts`

## Upstream Sync Strategy

### Remotes

- `origin` — TokenChow fork (git@github.com:TokenChow/coai.git)
- `upstream` — Original repo (https://github.com/coaidev/coai.git)

### Sync Workflow

```bash
# Quick sync
./scripts/upstream-sync.sh

# Manual sync
git fetch upstream
git merge upstream/main
# Resolve conflicts (usually only in bridge points)
```

### Bridge Points (files modified from upstream)

These are the ONLY upstream files we modify. Each modification is marked with `// [COMMERCIAL]`:

| File | Change | Lines |
|------|--------|-------|
| `main.go` | Import + Register + InitConfig | 3 lines |
| `app/src/router.tsx` | Import commercial routes (when added) | ~2 lines |
| `app/src/store/index.ts` | Import commercial reducers (when added) | ~2 lines |

### Rules for Commercial Development

1. **Never modify upstream files** unless absolutely necessary
2. **All modifications to upstream files** must be marked with `// [COMMERCIAL]` comment
3. **New features** go in `commercial/` (backend) or `app/src/commercial/` (frontend)
4. **New config** goes in `config/commercial.yaml`, not `config/config.yaml`
5. **New migrations** use prefix `commercial_` in `migration/`
6. **New adapters** can go in `adapter/` (low conflict) or `commercial/` (zero conflict)

## Development Commands

```bash
# Backend
go run main.go

# Frontend
cd app && npm run dev

# Build frontend
cd app && npm run build
```

## Code Style

- Go: Standard Go conventions, comments in English
- TypeScript: Project uses path aliases (`@/` = `app/src/`)
- CSS: TailwindCSS utility classes
- Components: shadcn/ui + Radix UI primitives
- i18n: i18next (translations in `app/src/i18n/`)

## Key Directories

| Directory | Purpose |
|-----------|---------|
| `adapter/` | AI provider integrations (Claude, Azure, etc.) |
| `addition/` | Additional features (article, generation) |
| `admin/` | Admin backend system |
| `auth/` | Authentication logic |
| `channel/` | Channel/model provider manager |
| `commercial/` | **[COMMERCIAL]** All commercial extensions |
| `connection/` | Database & Redis connections |
| `globals/` | Global types, constants, SQL helpers |
| `manager/` | Chat/completion request management |
| `middleware/` | HTTP middleware (CORS, auth, throttle) |
| `migration/` | Database migrations |
| `utils/` | Config loading, utilities |
| `app/src/commercial/` | **[COMMERCIAL]** Frontend extensions |
