using System.Data.Entity.ModelConfiguration;

namespace Chinook.Data.Models.Mapping
{
    public class PlaylistMap : EntityTypeConfiguration<Playlist>
    {
        public PlaylistMap()
        {
            // Primary Key
            HasKey(t => t.PlaylistId);

            // Properties
            Property(t => t.Name)
                .HasMaxLength(120);

            // Table & Column Mappings
            ToTable("Playlist");
            Property(t => t.PlaylistId).HasColumnName("PlaylistId");
            Property(t => t.Name).HasColumnName("Name");
        }
    }
}