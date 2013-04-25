using System;
using System.Collections.Generic;

namespace Chinook.Data.Models
{
    public partial class Track
    {
        public Track()
        {
            this.InvoiceLines = new List<InvoiceLine>();
            this.Playlists = new List<Playlist>();
        }

        public int TrackId { get; set; }
        public string Name { get; set; }
        public Nullable<int> AlbumId { get; set; }
        public int MediaTypeId { get; set; }
        public Nullable<int> GenreId { get; set; }
        public string Composer { get; set; }
        public int Milliseconds { get; set; }
        public Nullable<int> Bytes { get; set; }
        public decimal UnitPrice { get; set; }
        public virtual Album Album { get; set; }
        public virtual Genre Genre { get; set; }
        public virtual ICollection<InvoiceLine> InvoiceLines { get; set; }
        public virtual MediaType MediaType { get; set; }
        public virtual ICollection<Playlist> Playlists { get; set; }
    }
}
