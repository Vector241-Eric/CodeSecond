using System.Collections.Generic;
using System.Linq;

namespace Chinook.Data.Models
{
    public class Playlist
    {
        public Playlist()
        {
            PlaylistTracks = new List<PlaylistTrack>();
        }

        public int PlaylistId { get; set; }
        public string Name { get; set; }
        public virtual ICollection<PlaylistTrack> PlaylistTracks { get; set; }

        public Track[] Tracks
        {
            get { return PlaylistTracks.Select(x => x.Track).ToArray(); }
        }
    }
}