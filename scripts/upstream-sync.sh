#!/usr/bin/env bash
# TokenChow CoAI - Upstream Sync Script
# Syncs the fork with the upstream repository
#
# Usage:
#   ./scripts/upstream-sync.sh          # merge mode (default)
#   ./scripts/upstream-sync.sh --rebase  # rebase mode
#   ./scripts/upstream-sync.sh --check   # check only, no merge

set -euo pipefail

UPSTREAM_REMOTE="upstream"
UPSTREAM_BRANCH="main"
LOCAL_BRANCH="main"
UPSTREAM_URL="https://github.com/coaidev/coai.git"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

# Ensure upstream remote exists
ensure_upstream() {
    if ! git remote get-url "$UPSTREAM_REMOTE" &>/dev/null; then
        info "Adding upstream remote: $UPSTREAM_URL"
        git remote add "$UPSTREAM_REMOTE" "$UPSTREAM_URL"
    fi
}

# Check for uncommitted changes
check_clean() {
    if ! git diff-index --quiet HEAD -- 2>/dev/null; then
        error "Working tree has uncommitted changes. Commit or stash first."
    fi
}

# Fetch upstream
fetch_upstream() {
    info "Fetching upstream/$UPSTREAM_BRANCH..."
    git fetch "$UPSTREAM_REMOTE" "$UPSTREAM_BRANCH"
}

# Show what's new
show_diff() {
    local behind
    behind=$(git rev-list --count "HEAD..${UPSTREAM_REMOTE}/${UPSTREAM_BRANCH}" 2>/dev/null || echo "0")
    local ahead
    ahead=$(git rev-list --count "${UPSTREAM_REMOTE}/${UPSTREAM_BRANCH}..HEAD" 2>/dev/null || echo "0")

    if [ "$behind" -eq 0 ]; then
        info "Already up to date with upstream."
        return 1
    fi

    info "Upstream is $behind commit(s) ahead, you are $ahead commit(s) ahead."
    echo ""
    info "New upstream commits:"
    git log --oneline "HEAD..${UPSTREAM_REMOTE}/${UPSTREAM_BRANCH}" | head -20
    echo ""

    # Show potential conflicts in bridge files
    local bridge_files=("main.go" "app/src/router.tsx" "app/src/store/index.ts")
    local conflict_risk=false
    for f in "${bridge_files[@]}"; do
        if git diff "HEAD...${UPSTREAM_REMOTE}/${UPSTREAM_BRANCH}" --name-only | grep -q "^${f}$"; then
            warn "Bridge file modified upstream: $f (potential conflict)"
            conflict_risk=true
        fi
    done

    if [ "$conflict_risk" = true ]; then
        warn "Bridge files were modified upstream. Manual conflict resolution may be needed."
    fi

    return 0
}

# Merge upstream
do_merge() {
    info "Merging upstream/$UPSTREAM_BRANCH into $LOCAL_BRANCH..."
    if git merge "${UPSTREAM_REMOTE}/${UPSTREAM_BRANCH}" --no-edit; then
        info "Merge completed successfully!"
    else
        warn "Merge conflicts detected. Resolve conflicts, then run:"
        echo "  git add -A && git commit"
        echo ""
        warn "Conflict files:"
        git diff --name-only --diff-filter=U
        exit 1
    fi
}

# Rebase onto upstream
do_rebase() {
    info "Rebasing onto upstream/$UPSTREAM_BRANCH..."
    if git rebase "${UPSTREAM_REMOTE}/${UPSTREAM_BRANCH}"; then
        info "Rebase completed successfully!"
    else
        warn "Rebase conflicts detected. Resolve conflicts, then run:"
        echo "  git rebase --continue"
        exit 1
    fi
}

# Main
main() {
    local mode="${1:-merge}"

    ensure_upstream
    check_clean
    fetch_upstream

    if ! show_diff; then
        exit 0
    fi

    case "$mode" in
        --check)
            info "Check-only mode. No changes made."
            ;;
        --rebase)
            do_rebase
            ;;
        *)
            do_merge
            ;;
    esac
}

main "$@"
