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
   - Navigate to your chosen application directory
   - Make a copy of .env.example with name .env:
     ```bash
     cp .env.example .env
     # Configure application-specific settings
     ```
   - Configure DNS records using our [DNS setup guide](/docs/DNS.md)
   - Run app
      ```bash
      make up
      ```
   - For available commmands:
      ```bash
      make 
      ```


## 📦 Available Applications

### 🛠 Core Infrastructure
| Application | Description | Category |
|------------|-------------|----------|
| [**Authentic**](https://goauthentik.io/) | Open source Identity and Access Management platform | Security |
| [**Traefik**](https://traefik.io/) | Modern reverse proxy and load balancer | Infrastructure |
| [**Minio**](https://min.io/) | S3 Compatible Object Storage | Object Storage |
| [**SeaweedFS**](https://github.com/seaweedfs/seaweedfs) | Fast distributed storage system with S3 API | Object Storage |
| [**Ceph**](https://ceph.io/) | Unified distributed storage with S3-compatible object storage | Distributed Storage |
| [**Ory/Hydra**](https://www.ory.sh/hydra) | Oauth2 Provider | Authentication |

### 🗄️ Database Systems
| Application | Description | Category |
|------------|-------------|----------|
| [**PostgreSQL**](https://www.postgresql.org/) | Enterprise-grade relational database | SQL |
| [**MongoDB**](https://www.mongodb.com//) | Document-oriented NoSQL database | NoSQL |
| [**Couchbase**](https://www.couchbase.com/) | NoSQL document database with SQL-like query language | NoSQL |
| [**Valkey**](https://valkey.io/) | Fork of Redis. In memory data store | In-Memory |

### 💬 Communication & Collaboration
| Application | Description | Category |
|------------|-------------|----------|
| [**Mattermost**](https://mattermost.com/) | Secure enterprise collaboration platform | Collaboration |
| [**Miniflux**](https://miniflux.app/) | RSS Reader | Content |
| [**FreshRSS**](https://freshrss.org/) | RSS Reader | Content |
| [**Ntyf**](https://ntfy.sh/) | Http based pub-sub notification service | Notification |

### 🤖 AI & Automation
| Application | Description | Category |
|------------|-------------|----------|
| [**OpenWebUI**](https://openwebui.com/) | Advanced AI chat interface | AI |
| [**Agent Zero**](https://www.agent-zero.ai/) | Personal organic agentic framework with Speech-to-Text/Text-to-Speech | AI |
| [**N8N**](https://n8n.io/) | Powerful workflow automation platform | Automation |

### 🖥 Development Tools
| Application | Description | Category |
|------------|-------------|----------|
| [**ShellNGN**](https://shellngn.com/) | Comprehensive web-based terminal suite | DevTools |
| [**Bugsink**](https://bugsink.com/) | Python error tracking and monitoring tool similar to Sentry | Monitoring |
| [**Glitchtip**](https://glitchtip.com/) | Error tracking, Application performance, uptime monitoring tool | Monitoring |
| [**MongoExpress**](https://github.com/mongo-express/mongo-express) | Mongodb admin interface | Database Management |
| [**Seq**](https://datalust.co/seq) | Centralized structured logging platform | Logging |

### 📄 Document Management
| Application | Description | Category |
|------------|-------------|----------|
| [**Stirling-PDF**](https://stirlingpdf.com/) | Locally hosted PDF manipulation tool | PDF Tools |

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
