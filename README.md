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
3. **Set up DNS:**  
   - Add the necessary records using [this guide](/docs/DNS.md)  
4. **Deploy an Application:**  
   - Navigate to the application's directory  
   - Copy `.env.example` to `.env`  
   - Run:  
     ```sh
     sh deploy.sh
     ```  

## Included Applications  

| Application  | Description  |  
|-------------|-------------|  
| **Traefik**  | Reverse proxy for managing traffic |  
| **OpenWebUI**  | AI chat interface supporting multiple LLMs |  
| **FreshRSS**  | Self-hosted RSS reader |  
| **PostgreSQL**  | Powerful relational database |  
| **Mattermost**  | Open-source Slack alternative |  
