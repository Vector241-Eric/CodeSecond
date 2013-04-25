using System.Data.Entity.ModelConfiguration;

namespace Chinook.Data.Models.Mapping
{
    public class InvoiceLineMap : EntityTypeConfiguration<InvoiceLine>
    {
        public InvoiceLineMap()
        {
            // Primary Key
            HasKey(t => t.InvoiceLineId);

            // Properties
            // Table & Column Mappings
            ToTable("InvoiceLine");
            Property(t => t.InvoiceLineId).HasColumnName("InvoiceLineId");
            Property(t => t.InvoiceId).HasColumnName("InvoiceId");
            Property(t => t.TrackId).HasColumnName("TrackId");
            Property(t => t.UnitPrice).HasColumnName("UnitPrice");
            Property(t => t.Quantity).HasColumnName("Quantity");

            // Relationships
            HasRequired(t => t.Invoice)
                .WithMany(t => t.InvoiceLines)
                .HasForeignKey(d => d.InvoiceId)
                .WillCascadeOnDelete(false);
            HasRequired(t => t.Track)
                .WithMany(t => t.InvoiceLines)
                .HasForeignKey(d => d.TrackId)
                .WillCascadeOnDelete(false);
        }
    }
}