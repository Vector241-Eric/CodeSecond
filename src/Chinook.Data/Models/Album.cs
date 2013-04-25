using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Chinook.Data.Models
{
    public partial class Album
    {
        public Album()
        {
            this.Tracks = new List<Track>();
        }

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int AlbumId { get; set; }
        
        public string Title { get; set; }
        public int ArtistId { get; set; }
        public virtual Artist Artist { get; set; }
        public virtual ICollection<Track> Tracks { get; set; }
    }
}
