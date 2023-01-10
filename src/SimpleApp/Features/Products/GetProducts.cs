using SimpleApp.Common;
using SimpleApp.Persistence;

namespace SimpleApp.Features.Products;

public record GetProducts : IHttpQuery;


public class GetProductsEndpoint : IEndpoint
{
    public void RegisterEndpoint(IEndpointRouteBuilder builder) =>
        builder.MapGet<GetProducts, GetProductsHandler>("")
            .Produces(200);
}

internal class GetProductsHandler : IHttpQueryHandler<GetProducts>
{
    private readonly InMemoryDb _db;

    public GetProductsHandler(InMemoryDb db) => _db = db;

    public Task<IResult> HandleAsync(GetProducts query, CancellationToken cancellationToken) =>
        Task.FromResult(Results.Ok(_db.Products));
}