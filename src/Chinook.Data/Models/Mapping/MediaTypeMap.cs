using System.Data.Entity.ModelConfiguration;

namespace Chinook.Data.Models.Mapping
{
    public class MediaTypeMap : EntityTypeConfiguration<MediaType>
    {
        public MediaTypeMap()
        {
            // Primary Key
            HasKey(t => t.MediaTypeId);

            // Properties
            Property(t => t.Name)
                .HasMaxLength(120);

            // Table & Column Mappings
            ToTable("MediaType");
            Property(t => t.MediaTypeId).HasColumnName("MediaTypeId");
            Property(t => t.Name).HasColumnName("Name");
        }
    }
}