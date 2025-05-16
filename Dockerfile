# Use the official .NET SDK image (8.0) to build and publish the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
# Copy the project file and restore dependencies
COPY ["SpreadsheetService.csproj", "./"]
RUN dotnet restore "./SpreadsheetService.csproj"
# Copy the remaining source code and build the project
COPY . .
RUN dotnet publish "SpreadsheetService.csproj" -c Release -o /app/publish

# Use the official ASP.NET Core runtime image (8.0) to run the app
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 80
EXPOSE 443
ENTRYPOINT ["dotnet", "SpreadsheetService.dll"]
