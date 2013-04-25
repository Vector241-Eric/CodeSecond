using System.Data.Entity.ModelConfiguration;

namespace Chinook.Data.Models.Mapping
{
    public class InvoiceMap : EntityTypeConfiguration<Invoice>
    {
        public InvoiceMap()
        {
            // Primary Key
            HasKey(t => t.InvoiceId);

            // Properties
            Property(t => t.BillingAddress)
                .HasMaxLength(70);

            Property(t => t.BillingCity)
                .HasMaxLength(40);

            Property(t => t.BillingState)
                .HasMaxLength(40);

            Property(t => t.BillingCountry)
                .HasMaxLength(40);

            Property(t => t.BillingPostalCode)
                .HasMaxLength(10);

            // Table & Column Mappings
            ToTable("Invoice");
            Property(t => t.InvoiceId).HasColumnName("InvoiceId");
            Property(t => t.CustomerId).HasColumnName("CustomerId");
            Property(t => t.InvoiceDate).HasColumnName("InvoiceDate");
            Property(t => t.BillingAddress).HasColumnName("BillingAddress");
            Property(t => t.BillingCity).HasColumnName("BillingCity");
            Property(t => t.BillingState).HasColumnName("BillingState");
            Property(t => t.BillingCountry).HasColumnName("BillingCountry");
            Property(t => t.BillingPostalCode).HasColumnName("BillingPostalCode");
            Property(t => t.Total).HasColumnName("Total");

            // Relationships
            HasRequired(t => t.Customer)
                .WithMany(t => t.Invoices)
                .HasForeignKey(d => d.CustomerId)
                .WillCascadeOnDelete(false);
        }
    }
}