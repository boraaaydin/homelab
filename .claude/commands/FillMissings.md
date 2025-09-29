# Fill Missing Files Command

This command analyzes a Docker Compose application directory and generates missing essential files according to the homelab repository standards.

## Usage

```
/FillMissings <path-to-compose-directory>
```

**Arguments:**
- `path-to-compose-directory`: Path to the directory containing docker-compose.yml

## What it does

1. **Validates directory structure** - Ensures docker-compose.yml exists
2. **Creates .env.example** - Generates template environment file if missing
3. **Creates Makefile** - Generates standard Makefile with common targets if missing
4. **Creates docker-compose.ports.yml** - Generates localhost port configuration
5. **Creates README.md** - Generates basic documentation with usage and dependencies
6. **UPDATE ../README.md** - Add app information to main README.md

## Implementation

Analyze the provided docker-compose.yml file and:

- Extract service names, environment variables, and port configurations
- Generate .env.example with all required environment variables
- Create Makefile following repository standards (setup, up, down, restart, logs, clean targets)
    - Use `common.mk` file for common tasks. Don' t dublicate codes in makefile.
    - DNS files are as listed:
        - Mac: /private/etc/hosts
        - Linux : /etc/hosts
        - Windows: C:\Windows\System32\drivers\etc\hosts.
- If volume mapping is needed for users data, create a .gitignore file and add mapped folders
- Generate docker-compose.ports.yml for localhost access with HOST_PORT mappings
- Create concise README.md explaining how to use the application and its dependencies
- Ensure compliance with CLAUDE.md requirements (shared_network, Traefik integration, etc.)
- Add app information to README.md on root level.
- If a database is needed, use one of the databases hosted in this repo. See `README.md`
- If any other databases are needed. Stop and ask user to add it.
- Use DOCKER_TAG environment variable for placeholder of docker labels


All generated files should follow the patterns established in the homelab repository and be ready for immediate use.