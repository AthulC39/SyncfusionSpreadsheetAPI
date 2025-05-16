# 1. Build stage: restore and publish your app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj and restore dependencies
COPY ["SpreadsheetService.csproj", "./"]
RUN dotnet restore "./SpreadsheetService.csproj"

# Copy everything else and publish
COPY . .
RUN dotnet publish "SpreadsheetService.csproj" -c Release -o /app/publish

# 2. Runtime stage: install native libs & deploy the published output
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

# Install SkiaSharp native dependencies
RUN apt-get update \
 && apt-get install -y \
      fontconfig \       # provides libfontconfig.so.1 \
      libice6 \          # X11 support for certain Skia backends \
      libsm6 \
 && rm -rf /var/lib/apt/lists/*

# Copy the published app from build stage
COPY --from=build /app/publish .

# Expose ports and start
EXPOSE 80
EXPOSE 443
ENTRYPOINT ["dotnet", "SpreadsheetService.dll"]
