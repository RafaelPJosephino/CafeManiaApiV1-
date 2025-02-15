FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8000

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY ["CafeManiaApi.MVC/CafeManiaApi.MVC.csproj", "CafeManiaApi.MVC/"]
COPY ["CafeManiaApi.Infra.Ioc/CafeManiaApi.Infra.Ioc.csproj", "CafeManiaApi.Infra.Ioc/"]
COPY ["CafeManiaApi.Application/CafeManiaApi.Application.csproj", "CafeManiaApi.Application/"]
COPY ["CafeManiaApi.Domain/CafeManiaApi.Domain.csproj", "CafeManiaApi.Domain/"]

RUN dotnet restore "CafeManiaApi.MVC/CafeManiaApi.MVC.csproj"

COPY . .

WORKDIR "/src/CafeManiaApi.MVC"
RUN dotnet build "CafeManiaApi.MVC.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "CafeManiaApi.MVC.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CafeManiaApi.MVC.dll"]
