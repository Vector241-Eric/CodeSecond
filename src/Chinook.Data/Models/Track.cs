using System.Collections.Generic;
using System.Linq;

namespace Chinook.Data.Models
{
    public class Track
    {
        public Track()
        {
            InvoiceLines = new List<InvoiceLine>();
            PlaylistTracks = new List<PlaylistTrack>();
        }

        public int TrackId { get; set; }
        public string Name { get; set; }
        public int? AlbumId { get; set; }
        public int MediaTypeId { get; set; }
        public int? GenreId { get; set; }
        public string Composer { get; set; }
        public int Milliseconds { get; set; }
        public int? Bytes { get; set; }
        public decimal UnitPrice { get; set; }
        public virtual Album Album { get; set; }
        public virtual Genre Genre { get; set; }
        public virtual ICollection<InvoiceLine> InvoiceLines { get; set; }
        public virtual MediaType MediaType { get; set; }
        public virtual ICollection<PlaylistTrack> PlaylistTracks { get; set; }

        public Playlist[] Playlists
        {
            get { return PlaylistTracks.Select(x => x.Playlist).ToArray(); }
        }
    }
}