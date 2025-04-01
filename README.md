# Home Stack

A comprehensive solution for deploying and managing self-hosted applications with automated SSL certification and advanced reverse proxy capabilities.

## ✨ Key Features

- 🚀 One-click deployment of popular open-source applications
- 🔐 Automated SSL certificate management via Cloudflare & Let's Encrypt
- 🌐 Advanced Traefik reverse proxy integration
- 🌍 Access applications via both IP and domain names
- 🔒 Secure by default configuration

## 🚀 Getting Started

### Prerequisites
- Docker and Docker Compose installed
- A Cloudflare account
- Install [Make](https://gnuwin32.sourceforge.net/packages/make.htm) if your platform is windows

### Installation Steps

1. **Set up Docker Environment**
   ```bash
   # Verify Docker installation
   docker --version
   docker-compose --version
   ```

2. **Configure Traefik**
   - Set up Cloudflare credentials following our [detailed guide](/docs/Cloudflare.md)
   - Configure the environment:
     ```bash
     cp traefik/.env.example traefik/.env
     # Edit .env with your settings
     ```

3. **Run Installation**
   ```bash
   make install
   ```

4. **Deploy Applications**
   - Configure DNS records using our [DNS setup guide](/docs/DNS.md)
   - Navigate to your chosen application directory
   - Set up the application environment:
     ```bash
     cp .env.example .env
     # Configure application-specific settings
     make up
     ```

## 📦 Available Applications

### 🛠 Core Infrastructure
| Application | Description | Category |
|------------|-------------|----------|
| [**Traefik**](https://traefik.io/) | Modern reverse proxy and load balancer | Infrastructure |
| [**PostgreSQL**](https://www.postgresql.org/) | Enterprise-grade relational database | Database |

### 💬 Communication & Collaboration
| Application | Description | Category |
|------------|-------------|----------|
| [**Mattermost**](https://mattermost.com/) | Secure enterprise collaboration platform | Communication |
| [**Miniflux**](https://miniflux.app/) | RSS Reader | Content |
| [**FreshRSS**](https://freshrss.org/) | RSS Reader | Content |

### 🤖 AI & Automation
| Application | Description | Category |
|------------|-------------|----------|
| [**OpenWebUI**](https://openwebui.com/) | Advanced AI chat interface | AI |
| [**N8N**](https://n8n.io/) | Powerful workflow automation platform | Automation |

### 🖥 Development Tools
| Application | Description | Category |
|------------|-------------|----------|
| [**ShellNGN**](https://shellngn.com/) | Comprehensive web-based terminal suite | DevTools |

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
