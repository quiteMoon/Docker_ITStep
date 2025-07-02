# Learn about building .NET container images:
# https://github.com/dotnet/dotnet-docker/blob/main/samples/README.md
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY ["SimpleWebSite/SimpleWebSite.csproj", "SimpleWebSite/"]
RUN dotnet restore "SimpleWebSite/SimpleWebSite.csproj"

# copy everything else and build app
COPY . .
WORKDIR /source/SimpleWebSite
RUN dotnet publish -o /app


# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app

COPY --from=build /app .
ENTRYPOINT ["dotnet", "SimpleWebSite.dll"]
