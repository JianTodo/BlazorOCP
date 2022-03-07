#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

#ENV ASPNETCORE_ENVIRONMENT=Development

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["Server/BlazorApplication.Server.csproj", "BlazorApplication/Server/"]
COPY ["Shared/BlazorApplication.Shared.csproj", "BlazorApplication/Shared/"]
COPY ["Client/BlazorApplication.Client.csproj", "BlazorApplication/Client/"]
RUN dotnet restore "BlazorApplication/Server/BlazorApplication.Server.csproj"
COPY . .
WORKDIR "/src/BlazorApplication/Server"
RUN dotnet build "BlazorApplication.Server.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "BlazorApplication.Server.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BlazorApplicationlication.Server.dll"]
