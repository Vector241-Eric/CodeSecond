using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace Chinook.Data.Models.Mapping
{
    public class PlaylistMap : EntityTypeConfiguration<Playlist>
    {
        public PlaylistMap()
        {
            // Primary Key
            this.HasKey(t => t.PlaylistId);

            // Properties
            this.Property(t => t.Name)
                .HasMaxLength(120);

            // Table & Column Mappings
            this.ToTable("Playlist");
            this.Property(t => t.PlaylistId).HasColumnName("PlaylistId");
            this.Property(t => t.Name).HasColumnName("Name");

            // Relationships
            this.HasMany(t => t.Tracks)
                .WithMany(t => t.Playlists)
                .Map(m =>
                    {
                        m.ToTable("PlaylistTrack");
                        m.MapLeftKey("PlaylistId");
                        m.MapRightKey("TrackId");
                    });


        }
    }
}
