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
      - shared_network

networks:
  shared_network:
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
      - shared_network
      - mainapp_network

networks:
  shared_network:
    external: true
  mainapp_network:
    driver: overlay
```