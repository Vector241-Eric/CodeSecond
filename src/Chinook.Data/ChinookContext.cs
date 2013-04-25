using System.Data.Entity;
using Chinook.Data.Models;
using Chinook.Data.Models.Mapping;

namespace Chinook.Data
{
    public class ChinookContext : DbContext
    {
        static ChinookContext()
        {
            Database.SetInitializer<ChinookContext>(null);
        }

        public ChinookContext()
            : base("Name=ChinookContext")
        {
        }

        public ChinookContext(string nameOrConnectionString) : base(nameOrConnectionString)
        {
        }

        public DbSet<Album> Albums { get; set; }
        public DbSet<Artist> Artists { get; set; }
        public DbSet<Customer> Customers { get; set; }
        public DbSet<Employee> Employees { get; set; }
        public DbSet<Genre> Genres { get; set; }
        public DbSet<Invoice> Invoices { get; set; }
        public DbSet<InvoiceLine> InvoiceLines { get; set; }
        public DbSet<MediaType> MediaTypes { get; set; }
        public DbSet<Playlist> Playlists { get; set; }
        public DbSet<Track> Tracks { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Configurations.Add(new AlbumMap());
            modelBuilder.Configurations.Add(new ArtistMap());
            modelBuilder.Configurations.Add(new CustomerMap());
            modelBuilder.Configurations.Add(new EmployeeMap());
            modelBuilder.Configurations.Add(new GenreMap());
            modelBuilder.Configurations.Add(new InvoiceMap());
            modelBuilder.Configurations.Add(new InvoiceLineMap());
            modelBuilder.Configurations.Add(new MediaTypeMap());
            modelBuilder.Configurations.Add(new PlaylistMap());
            modelBuilder.Configurations.Add(new TrackMap());
        }
    }
}