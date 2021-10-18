FROM mcr.microsoft.com/dotnet/aspnet:5.0
EXPOSE 80
EXPOSE 443
WORKDIR /app
COPY bin/Release/net5.0/publish/ .
ENTRYPOINT ["dotnet", "ToppingsApi.dll"]