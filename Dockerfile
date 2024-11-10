FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

COPY Source/REG2PS/*.csproj .
COPY Source/REG2PS/nuget.config .
RUN dotnet restore .

COPY Source/REG2PS .
RUN dotnet publish . -c Release -o out --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/out .
ENTRYPOINT ["dotnet", "REG2PS.dll"]
