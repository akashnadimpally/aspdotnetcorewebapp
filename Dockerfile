FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER app
WORKDIR /app
EXPOSE 8080
# EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:8.0 as build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["aspdotnetcorewebapp.csproj","."]
RUN dotnet restore "./././aspdotnetcorewebapp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "./aspdotnetcorewebapp.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build as publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./aspdotnetcorewebapp.csproj" -c $BUILD_CONFIGURATION -o /app/publish

FROM base as final 
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "aspdotnetcorewebapp.dll"]