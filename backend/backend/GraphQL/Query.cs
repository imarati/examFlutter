using backend.Data;
using backend.Models;
using Microsoft.EntityFrameworkCore;

namespace backend.GraphQL;

public class Query
{
    [UseFiltering]
    [UseSorting]
    public async Task<List<Item>> GetItems([Service] IDbContextFactory<AppDbContext> dbContextFactory)
    {
        await using var context = await dbContextFactory.CreateDbContextAsync();
        return await context.Items.ToListAsync();
    }
}