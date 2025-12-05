# Cocker 🐔

Cocker is a humorous Docker CLI wrapper that adds ASCII chicken art and random rooster-themed messages before executing Docker commands. It's a single-file bash script distributed as an RPM package.

## Features
- Chicken ASCII art and random rooster messages on every run
- Permission checks for Docker access (root or docker group)
- Transparent argument forwarding to Docker
- Dynamic bash completion for Docker commands and options
- Packaged as an RPM for easy installation

## Usage
```bash
cocker ps
cocker run -it ubuntu
```

## Installation
### RPM Package
Download the latest RPM from [GitHub Releases](https://github.com/codewithflavor/cocker/releases) and install:
```bash
sudo rpm -i cocker-<version>.noarch.rpm
```

### Manual
Copy `bin/cocker` to your `$PATH` and (optionally) source `completions/cocker.bash` for tab completion.

## Development
- Main script: `bin/cocker`
- Bash completion: `completions/cocker.bash`
- RPM spec: `cocker.spec`

Test locally:
```bash
./bin/cocker ps
source completions/cocker.bash
cocker <TAB><TAB>
```

## License
MIT
