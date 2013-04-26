using System.Data.Entity.ModelConfiguration;

namespace Chinook.Data.Models.Mapping
{
    public class ArtistMap : EntityTypeConfiguration<Artist>
    {
        public ArtistMap()
        {
            // Primary Key
            HasKey(t => t.ArtistId);

            // Properties
            Property(t => t.Name)
                .HasMaxLength(120);

            // Table & Column Mappings
            ToTable("Artist");
            Property(t => t.ArtistId).HasColumnName("ArtistId");
            Property(t => t.Name).HasColumnName("Name");
        }
    }
}