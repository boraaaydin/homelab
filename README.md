# Home Stack  

Easily deploy open-source applications locally or on a server with automated SSL management and a powerful reverse proxy.  

## Features  
✅ Deploy open-source apps effortlessly  
✅ Automatic SSL via Cloudflare & Let's Encrypt  
✅ Traefik-based reverse proxy  

## Prerequisites  
🔹 You must own and manage a domain on Cloudflare  

## Installation  

1. **Install Docker**  
2. **Configure Traefik:**  
   - Follow [this guide](/docs/Cloudflare.md) to create a Cloudflare token  
   - Copy `.env.example` to `.env` in the `traefik` folder  
3. Run Install script
   ```sh
   sh install.sh
   ```  
4. **Deploy any Application:**  
   - Add the necessary DNS record for application using [this guide](/docs/DNS.md)  
   - Navigate to the application's directory  
   - Copy `.env.example` to `.env` and fill missing fields
   - Run:  
     ```sh
     sh deploy.sh
     ```  

## Included Applications  

| Application  | Description  |  
|-------------|-------------|  
| [**Traefik**](https://traefik.io/) | Reverse proxy for managing traffic |  
| [**OpenWebUI**](https://openwebui.com/) | AI chat interface supporting multiple LLMs |  
| [**FreshRSS**](https://freshrss.org/)  | Self-hosted RSS reader |  
| [**Postgresql**](https://www.postgresql.org/)  | Powerful relational database |  
| [**Mattermost**](https://mattermost.com/) | Open-source Slack alternative |  
| [**ShellNGN**](https://shellngn.com/)  | Web Based SSH Client with SFTP, VNC, RDP and more |  
| [**N8N**](https://n8n.io/)  | AI workflow automation |  
