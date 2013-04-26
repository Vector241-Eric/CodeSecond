using System.Data.Entity.ModelConfiguration;

namespace Chinook.Data.Models.Mapping
{
    public class AlbumMap : EntityTypeConfiguration<Album>
    {
        public AlbumMap()
        {
            // Primary Key
            HasKey(t => t.AlbumId);

            // Properties
            Property(t => t.Title)
                .IsRequired()
                .HasMaxLength(160);

            // Table & Column Mappings
            ToTable("Album");
            Property(t => t.AlbumId).HasColumnName("AlbumId");
            Property(t => t.Title).HasColumnName("Title");
            Property(t => t.ArtistId).HasColumnName("ArtistId");

            // Relationships
            HasRequired(t => t.Artist)
                .WithMany(t => t.Albums)
                .HasForeignKey(d => d.ArtistId)
                .WillCascadeOnDelete(false);
        }
    }
}