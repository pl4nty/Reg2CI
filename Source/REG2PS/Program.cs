using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.FileProviders;
using Microsoft.Extensions.Hosting;
using System.IO;
using System.Web.Routing;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddSystemWebAdapters()
    .AddPreApplicationStartMethod(false) // Used if you want to run any pre application start methods
    .AddJsonSessionSerializer()
    .AddWrappedAspNetCoreSession()
    .AddRouting()
    .AddWebForms()
    .AddScriptManager() // Remove if you don't use ScriptManager/AJAX
    .AddOptimization() // Remove if you don't use System.Web.Optimization
    .AddDynamicPages() // Used if you have dynamic pages
    .AddCompiledPages(); // Used if compiled pages are used

builder.Services.AddSession();
builder.Services.AddDistributedMemoryCache();

var app = builder.Build();

foreach (var staticPath in new[] { "Content", "Scripts" })
{
    app.UseStaticFiles(new StaticFileOptions()
    {
        FileProvider = new PhysicalFileProvider(Path.Combine(builder.Environment.ContentRootPath, staticPath)),
        RequestPath = "/" + staticPath,
    });
}

app.UseStaticFiles(new StaticFileOptions()
{
    FileProvider = new PhysicalFileProvider(Path.Combine(builder.Environment.ContentRootPath, "Content")),
    RequestPath = "",
});

app.UseHttpsRedirection();
app.UseRouting();

app.UseSession();
app.UseSystemWebAdapters();

app.Services.GetRequiredService<IHostApplicationLifetime>().ApplicationStarted.Register(() =>
{
    RouteTable.Routes.MapPageRoute("MainPage", "/", "~/Default.aspx");
});

app.MapHttpHandlers();
app.MapScriptManager();
app.MapBundleTable();

app.Run();
