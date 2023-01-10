FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["src/SimpleApp/SimpleApp.csproj", "src/SimpleApp/"]
RUN dotnet restore "src/SimpleApp/SimpleApp.csproj"
COPY . .
WORKDIR "/src/src/SimpleApp"
RUN dotnet build "SimpleApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "SimpleApp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SimpleApp.dll"]
