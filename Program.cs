using Microsoft.AspNetCore.Http.Features;

var builder = WebApplication.CreateBuilder(args);

// Configure form options (if needed for large files)
builder.Services.Configure<FormOptions>(options =>
{
    options.MultipartBodyLengthLimit = int.MaxValue;
    options.ValueLengthLimit = int.MaxValue;
});

// Add CORS policy (configure before building the app)
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowReactApp", policy =>
    {
        policy.WithOrigins("https://elemment-mmp-frontend-demo.vercel.app", "http://localhost:3002","http://localhost:3000","http://localhost:3001","https://elemment-mmp-frontend-demo-v49e.vercel.app/","https://elemment-refac-frontend-b8zk.vercel.app/","https://elemment-refac-frontend-b8zk.vercel.app")
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});

// Add controller services
builder.Services.AddControllers();

var app = builder.Build();

// Configure the HTTP request pipeline
app.UseHttpsRedirection();

// Use the defined CORS policy
app.UseCors("AllowReactApp");

app.UseAuthorization();

app.MapControllers();

app.Run();
