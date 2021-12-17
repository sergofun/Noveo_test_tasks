# job_finder
Exercise 03/03

Job finder provides API to get job offers around provided location and radius (km) 

## Usage
### Preconditions
Installed docker

### Starting
```bash
    docker-compose up
```
### Get job offers
To get a list or proper job offers you should perform HTTP GET request and specify latitude, longitude and desired 
radius as a query parameters

Example:

- request
```
    http://localhost:4000/api/jobs?latitude=48.71&longitude=3.66&radius=50
```
- response
```json
{"data":
  [
    {"distance":49.8371,"name":"[Moët Hennessy Champagne Services] ALTERNANT(E) CONTROLEUR DE GESTION INVESTISSEMENTS"},
    {"distance":49.8371,"name":"[Moët Hennessy Champagne Services] Alternant(e) chef de projets Sécurité des aliments"},
    {"distance":49.8371,"name":"[Moët Hennessy Champagne Services] Contrôleur Interne"},
    {"distance":49.8371,"name":"[Moët Hennessy Champagne Services] Responsable Ressources Humaines H/F"},
    {"distance":49.8371,"name":"[Moët Hennessy Champagne Services] alternant(e) chargé(e) de développement RH"},
    {"distance":49.8371,"name":"[Moët Hennessy Champagne Services] apprenti(e) contrôle de gestion sociale"},
    {"distance":49.8371,"name":"[Moët Hennessy Champagne Services] stagiaire contrôle de gestion coordination et support et prix de transfert"}
  ]
}
```

## Testing
```bash
    mix test
```
