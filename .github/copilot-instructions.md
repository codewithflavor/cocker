# Cocker - AI Coding Agent Instructions

## Project Overview
Cocker is a humorous Docker CLI wrapper that adds ASCII chicken art and random rooster-themed messages before executing Docker commands. It's a single-file bash script distributed as an RPM package.

## Architecture

### Core Components
- **`bin/cocker`** - Main bash wrapper script that displays chicken ASCII art, random messages, checks Docker permissions, and forwards all arguments to `docker`
- **`completions/cocker.bash`** - Bash completion script that dynamically fetches Docker commands/options using `docker --help` to provide tab completion
- **`cocker.spec`** - RPM spec file for packaging and distribution
- **`.github/workflows/rpm.yml`** - CI/CD pipeline for automated RPM building and GitHub releases

## Key Patterns & Conventions

### Message System
The main script uses bash arrays for humor messages:
- `messages[]` - Random chicken-themed Docker insults shown on every execution
- `permissionMessages[]` - Specific messages for permission/Docker group issues
- Selection uses `${messages[RANDOM % ${#messages[@]}]}` pattern

### Permission Checking
Cocker validates Docker access before forwarding commands:
```bash
if [ "$EUID" -ne 0 ] && ! groups "$USER" | grep -q '\bdocker\b'; then
    # Show permission message and exit 1
fi
```
This pattern checks both root access AND Docker group membership.

### Completion Strategy
The bash completion dynamically queries Docker's help output at runtime rather than maintaining static lists:
- `COMP_CWORD=1`: Parse top-level commands from `docker --help`
- `COMP_CWORD=2`: Parse subcommands from `docker $cmd --help`
- `COMP_CWORD>=3`: Extract `--options` using grep/awk

## Critical Workflows

### Building & Testing Locally
```bash
# Test the script directly
./bin/cocker ps

# Test completions (source first)
source completions/cocker.bash
cocker <TAB><TAB>
```

### Release Process
1. Tag with version: `git tag v1.0.0`
2. Push tag: `git push origin v1.0.0`
3. GitHub Actions automatically:
   - Extracts version from tag
   - Builds tarball from `bin/` and `completions/`
   - Updates version in spec file
   - Builds signed RPM (requires GPG secrets)
   - Creates GitHub release with RPM artifact

### RPM Packaging Details
- **BuildArch**: `noarch` - pure bash, no compilation needed
- **Install locations**: `/usr/bin/cocker` and `/usr/share/bash-completion/completions/cocker`
- **Source tarball**: Created from `temp-src/` containing only `bin/` and `completions/` dirs
- Version is injected into spec file using `sed` during CI build

## Modification Guidelines

### Adding New Messages
Add to the arrays in `bin/cocker` - maintain the chicken/rooster theme and emoji style.

### Changing Completion Behavior
Edit `completions/cocker.bash` - the dynamic help parsing means no hardcoded command lists to maintain.

### Version Updates
Update `Version:` field in `cocker.spec` - or let CI extract from git tags automatically.

### Testing RPM Build Locally
```bash
VERSION=1.0.0
mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
sed "s|^Version:.*|Version:        $VERSION|" cocker.spec > ~/rpmbuild/SPECS/cocker.spec
mkdir temp-src && cp -r bin completions temp-src/
tar czf ~/rpmbuild/SOURCES/cocker-${VERSION}.tar.gz -C temp-src .
rpmbuild -ba ~/rpmbuild/SPECS/cocker.spec
```

## External Dependencies
- **Docker CLI**: Required at runtime - cocker is a transparent wrapper
- **Bash**: Both the main script and completions require bash
- **RPM packaging**: `rpmbuild`, `rpm`, `gpg` for signing (CI only)
