using System;
using System.Collections.Generic;

namespace Chinook.Data.Models
{
    public partial class MediaType
    {
        public MediaType()
        {
            this.Tracks = new List<Track>();
        }

        public int MediaTypeId { get; set; }
        public string Name { get; set; }
        public virtual ICollection<Track> Tracks { get; set; }
    }
}
