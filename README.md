# About

This project will show off how to take an ASP.NET Core ReactJS Client application and split the ClientApp from the ASP.NET Core application.

## Branches

The application is broken up into branches that show the process of moving the application from one build/publish process to one that can work with Docker and separate developments.

### main/001_initial

This branch is from the default template from VS2019, with the csproj still containing the details to install/build/publish the ClientApp.

``` bash
# Create the Database for usage
dotnet ef database update

# Startup the application on the machine
dotnet run
```

### main/002_initial_docker_setup

This branch shows what the repository should look like after Docker is enabled for the repository.

``` bash
# Create MSSQL Server
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=yourStrong(!)Password" -p 1433:1433 -d mcr.microsoft.com/mssql/server:2017-CU8-ubuntu

# Create the Database for usage
dotnet ef database update

# Build ClientApp
cd ClientApp 
npm run build

# Startup the application on the machine
dotnet run
```

### main/003_initial_docker_compose_setup

This branch shows what the repository should look like after Docker is enabled for the repository.

``` bash
# Docker Deploy the Database, uses default MSSql port
docker-compose up database

# Still needs to be done on the machine to create the Database
dotnet ef database update

# Startup the application with Docker
docker-compose up --build web
```
