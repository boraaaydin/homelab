# DNS Configuration

## Domain Configuration Options

### 1. For Domain Owners
- You can access your applications in the following format:
  - Pattern: `domainprefix.basedomain`
  - Example: `n8n.apps.example.com`
- For better security, avoid exposing your application ports directly to the internet. Don't set HOST_PORT variables. 

### 2. For Local Development (Without Domain)

#### For macOS Users
```bash
# Add domain to local hosts file:
echo "127.0.0.1       domainprefix.basedomain" | sudo tee -a /private/etc/hosts

# Verify hosts file content:
cat /private/etc/hosts
```

#### For Linux Users
```bash
# Add domain to local hosts file:
sudo echo "127.0.0.1       domainprefix.basedomain" >> /etc/hosts

# Verify hosts file content:
cat /etc/hosts
```

#### For Windows Users
```bash
# Add this line to C:\Windows\System32\drivers\etc\hosts:
127.0.0.1       domainprefix.basedomain
```

### 3. Using Localhost
If you don't have a domain, you can access applications via localhost by:
- Setting the `HOST_PORT` in your .env file
- Access via: `localhost:HOST_PORT`

## Notes
- Replace `domainprefix` and `basedomain` with your actual values
- Make sure to restart your browser after making hosts file changes
- For production use, proper DNS records should be configured with your domain registrar 