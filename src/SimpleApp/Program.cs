using SimpleApp;
using SimpleApp.Common;
using SimpleApp.Persistence;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddSingleton<InMemoryDb>();
builder.Services.RegisterHandlers<IApiMarker>();

var app = builder.Build();

app.RegisterEndpoints<IApiMarker>();

app.Run();