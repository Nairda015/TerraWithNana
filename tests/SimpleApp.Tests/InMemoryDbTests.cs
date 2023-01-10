using FluentAssertions;
using SimpleApp.Entities;
using SimpleApp.Persistence;
using Xunit;

namespace SimpleApp.Tests;

public class InMemoryDbTests
{
    private readonly InMemoryDb _sut = new();
    private readonly Product _product = new(Guid.NewGuid(), "Name", 1.50m);

    public InMemoryDbTests()
    {
        _sut.Clear();
        _sut.Add(_product);
    }
    
    [Fact]
    public void UpdateProductName_ShouldReturnTrue_WhenProductExist()
    {
        // Arrange
        var newProduct = _product with { Name = "NewName" };
        
        // Act
        var result = _sut.Update(newProduct);

        // Assert
        result.Should().BeTrue();
        _sut.Products[_product.Id].Name.Should().Be(newProduct.Name);
    }
    
    [Fact]
    public void UpdateProductPrice_ShouldReturnTrue_WhenProductExist()
    {
        // Arrange
        var newProduct = _product with { Price = 2.4m };
        
        // Act
        var result = _sut.Update(newProduct);

        // Assert
        result.Should().BeTrue();
        _sut.Products[_product.Id].Price.Should().Be(newProduct.Price);
    }
}