using backend.Data;
using backend.Models;
using Microsoft.EntityFrameworkCore;

namespace backend.GraphQL;

public class Mutation
{
    public async Task<Item> AddItemAsync(string name, [Service] IDbContextFactory<AppDbContext> dbContextFactory)
    {
        await using var context = await dbContextFactory.CreateDbContextAsync();
        var item = new Item { Name = name };
        context.Items.Add(item);
        await context.SaveChangesAsync();
        return item;
    }

    public async Task<Item?> UpdateItemAsync(int id, string name, [Service] IDbContextFactory<AppDbContext> dbContextFactory)
    {
        await using var context = await dbContextFactory.CreateDbContextAsync();
        var item = await context.Items.FindAsync(id);
        if (item == null) return null;
        item.Name = name;
        await context.SaveChangesAsync();
        return item;
    }

    public async Task<Item?> DeleteItemAsync(int id, [Service] IDbContextFactory<AppDbContext> dbContextFactory)
    {
        await using var context = await dbContextFactory.CreateDbContextAsync();
        var item = await context.Items.FindAsync(id);
        if (item == null) return null;
        context.Items.Remove(item);
        await context.SaveChangesAsync();
        return item;
    }
}