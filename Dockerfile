#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 8080
#EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["Client/BlazorApplication.Client.csproj", "Client/"]
COPY ["Server/BlazorApplication.Server.csproj", "Server/"]
COPY ["Shared/BlazorApplication.Shared.csproj", "Shared/"]

RUN dotnet restore "Server/BlazorApplication.Server.csproj"
COPY . .
WORKDIR "/src/Server"
RUN dotnet build "BlazorApplication.Server.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "BlazorApplication.Server.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BlazorApplication.Server.dll"]

#ENV ASPNETCORE_URLS=http://*:80
CMD ASPNETCORE_URLS=http://*:80 dotnet BlazorApplication.Server.dll

