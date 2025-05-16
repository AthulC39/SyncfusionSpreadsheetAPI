# 1. Build stage: restore and publish the .NET app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy the project file and restore dependencies
COPY ["SpreadsheetService.csproj", "./"]
RUN dotnet restore "./SpreadsheetService.csproj"

# Copy the remaining source code and publish the app
COPY . .
RUN dotnet publish "SpreadsheetService.csproj" -c Release -o /app/publish

# 2. Runtime stage: install native libraries and deploy the published output
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

# Install SkiaSharp native dependencies
RUN apt-get update \
 && apt-get install -y \
      libfontconfig1 \    # provides libfontconfig.so.1 for font metrics \
      libice6 \           # X11 session support \
      libsm6              # X11 session support \
 && rm -rf /var/lib/apt/lists/*

# Copy the published app from the build stage
COPY --from=build /app/publish .

# Expose ports and define entrypoint
EXPOSE 80
EXPOSE 443
ENTRYPOINT ["dotnet", "SpreadsheetService.dll"]
