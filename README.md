# Home Stack

Installation

```
cp .env.example .env
sh install.sh
```

* Change Hostname in .env file
* Go to App Directory  
```
sh deploy.sh
```

## Reaching shared network from another network 

Shared App :
```
services:
  sharedApp:
    image: ...
    restart: always
    environment:
      ...
    ports:
      - ...
    networks:
      - shared-network

networks:
  shared-network:
    external: true
```

Main App : 
```
  mainApp:
    image: ....
    ports:
      - ...
    ...
    depends_on:
      - sharedApp:
    networks:
      - shared-network
      - mainapp-network

networks:
  shared-network:
    external: true
  mainapp-network:
    driver: overlay
```