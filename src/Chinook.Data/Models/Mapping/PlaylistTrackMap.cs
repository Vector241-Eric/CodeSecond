using System.Data.Entity.ModelConfiguration;

namespace Chinook.Data.Models.Mapping
{
    public class PlaylistTrackMap : EntityTypeConfiguration<PlaylistTrack>
    {
        public PlaylistTrackMap()
        {
            ToTable("PlaylistTrack");

            HasKey(t => t.Id);

            HasRequired(t => t.Playlist)
                .WithMany(x => x.PlaylistTracks)
                .HasForeignKey(d => d.PlaylistId)
                .WillCascadeOnDelete(false);

            HasRequired(t => t.Track)
                .WithMany(x => x.PlaylistTracks)
                .HasForeignKey(d => d.TrackId)
                .WillCascadeOnDelete(false);
        }
    }
}