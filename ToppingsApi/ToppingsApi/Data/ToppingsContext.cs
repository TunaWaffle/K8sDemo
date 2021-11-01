using Microsoft.EntityFrameworkCore;

namespace ToppingsApi.Data
{

    public class ToppingsContext : DbContext
    {
        public DbSet<Topping> Toppings => Set<Topping>();
        
        public ToppingsContext(DbContextOptions<ToppingsContext> options)
            : base(options)
        { }
    }
}
