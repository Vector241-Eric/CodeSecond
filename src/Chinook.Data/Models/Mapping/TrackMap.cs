using System.Data.Entity.ModelConfiguration;

namespace Chinook.Data.Models.Mapping
{
    public class TrackMap : EntityTypeConfiguration<Track>
    {
        public TrackMap()
        {
            // Primary Key
            HasKey(t => t.TrackId);

            // Properties
            Property(t => t.Name)
                .IsRequired()
                .HasMaxLength(200);

            Property(t => t.Composer)
                .HasMaxLength(220);

            // Table & Column Mappings
            ToTable("Track");
            Property(t => t.TrackId).HasColumnName("TrackId");
            Property(t => t.Name).HasColumnName("Name");
            Property(t => t.AlbumId).HasColumnName("AlbumId");
            Property(t => t.MediaTypeId).HasColumnName("MediaTypeId");
            Property(t => t.GenreId).HasColumnName("GenreId");
            Property(t => t.Composer).HasColumnName("Composer");
            Property(t => t.Milliseconds).HasColumnName("Milliseconds");
            Property(t => t.Bytes).HasColumnName("Bytes");
            Property(t => t.UnitPrice).HasColumnName("UnitPrice");

            // Relationships
            HasOptional(t => t.Album)
                .WithMany(t => t.Tracks)
                .HasForeignKey(d => d.AlbumId);
            HasOptional(t => t.Genre)
                .WithMany(t => t.Tracks)
                .HasForeignKey(d => d.GenreId);
            HasRequired(t => t.MediaType)
                .WithMany(t => t.Tracks)
                .HasForeignKey(d => d.MediaTypeId)
                .WillCascadeOnDelete(false);
        }
    }
}