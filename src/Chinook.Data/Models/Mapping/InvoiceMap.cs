using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace Chinook.Data.Models.Mapping
{
    public class InvoiceMap : EntityTypeConfiguration<Invoice>
    {
        public InvoiceMap()
        {
            // Primary Key
            this.HasKey(t => t.InvoiceId);

            // Properties
            this.Property(t => t.BillingAddress)
                .HasMaxLength(70);

            this.Property(t => t.BillingCity)
                .HasMaxLength(40);

            this.Property(t => t.BillingState)
                .HasMaxLength(40);

            this.Property(t => t.BillingCountry)
                .HasMaxLength(40);

            this.Property(t => t.BillingPostalCode)
                .HasMaxLength(10);

            // Table & Column Mappings
            this.ToTable("Invoice");
            this.Property(t => t.InvoiceId).HasColumnName("InvoiceId");
            this.Property(t => t.CustomerId).HasColumnName("CustomerId");
            this.Property(t => t.InvoiceDate).HasColumnName("InvoiceDate");
            this.Property(t => t.BillingAddress).HasColumnName("BillingAddress");
            this.Property(t => t.BillingCity).HasColumnName("BillingCity");
            this.Property(t => t.BillingState).HasColumnName("BillingState");
            this.Property(t => t.BillingCountry).HasColumnName("BillingCountry");
            this.Property(t => t.BillingPostalCode).HasColumnName("BillingPostalCode");
            this.Property(t => t.Total).HasColumnName("Total");

            // Relationships
            this.HasRequired(t => t.Customer)
                .WithMany(t => t.Invoices)
                .HasForeignKey(d => d.CustomerId);

        }
    }
}
