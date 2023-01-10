using SimpleApp.Common;
using SimpleApp.Entities;
using SimpleApp.Persistence;

namespace SimpleApp.Features.Products;


internal record UpdateProductPrice(UpdateProductPrice.UpdateProductPriceBody Body) : IHttpCommand
{
    internal record UpdateProductPriceBody(Guid Id, decimal Price);
}

public class UpdateProductPriceEndpoint : IEndpoint
{
    public void RegisterEndpoint(IEndpointRouteBuilder builder) =>
        builder.MapPost<UpdateProductPrice, UpdateProductPriceHandler>("brands")
            .Produces(201)
            .Produces(400);
}

internal class UpdateProductPriceHandler : IHttpCommandHandler<UpdateProductPrice>
{
    private readonly InMemoryDb _db;

    public UpdateProductPriceHandler(InMemoryDb db) => _db = db;

    public Task<IResult> HandleAsync(UpdateProductPrice command, CancellationToken cancellationToken = default)
    {
        if (!_db.Products.TryGetValue(command.Body.Id, out var oldProduct)) Task.FromResult(Results.NotFound());
        
        var product = oldProduct! with { Price = command.Body.Price };
        _db.Update(product);
        return Task.FromResult(Results.Ok());
    }
}