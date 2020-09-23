# Stage 1 - Build Node Used Artifacts
FROM node:12-buster AS node-build

# caches restore result by copying package.json file separately
WORKDIR /source/ClientApp

COPY ./ClientApp/package.json .
COPY ./ClientApp/package-lock.json .

RUN npm install

COPY ./ClientApp .

RUN npm run build

# Stage 2 - Build .NET Project
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS dotnet-build
WORKDIR /source

# Copy the main source project files
COPY *.csproj ./

# Restore - creating a layer for caching
RUN dotnet restore

COPY . .
RUN dotnet build -c Release --no-restore ./Docker-DotNet-Tutorial.csproj

# Copy Generated JavaScript
COPY --from=node-build /source/ClientApp/build /source/ClientApp/build

# Publish 
RUN dotnet publish --output /app/ --configuration Release --no-restore ./Docker-DotNet-Tutorial.csproj

# Stage 3 - Create Slim Runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS runtime
WORKDIR /app
COPY --from=dotnet-build /app .
ENTRYPOINT ["dotnet", "Docker-DotNet-Tutorial.dll"]
