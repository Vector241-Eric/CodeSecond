using System.Data.Entity.ModelConfiguration;

namespace Chinook.Data.Models.Mapping
{
    public class CustomerMap : EntityTypeConfiguration<Customer>
    {
        public CustomerMap()
        {
            // Primary Key
            HasKey(t => t.CustomerId);

            // Properties
            Property(t => t.FirstName)
                .IsRequired()
                .HasMaxLength(40);

            Property(t => t.LastName)
                .IsRequired()
                .HasMaxLength(20);

            Property(t => t.Company)
                .HasMaxLength(80);

            Property(t => t.Address)
                .HasMaxLength(70);

            Property(t => t.City)
                .HasMaxLength(40);

            Property(t => t.State)
                .HasMaxLength(40);

            Property(t => t.Country)
                .HasMaxLength(40);

            Property(t => t.PostalCode)
                .HasMaxLength(10);

            Property(t => t.Phone)
                .HasMaxLength(24);

            Property(t => t.Fax)
                .HasMaxLength(24);

            Property(t => t.Email)
                .IsRequired()
                .HasMaxLength(60);

            // Table & Column Mappings
            ToTable("Customer");
            Property(t => t.CustomerId).HasColumnName("CustomerId");
            Property(t => t.FirstName).HasColumnName("FirstName");
            Property(t => t.LastName).HasColumnName("LastName");
            Property(t => t.Company).HasColumnName("Company");
            Property(t => t.Address).HasColumnName("Address");
            Property(t => t.City).HasColumnName("City");
            Property(t => t.State).HasColumnName("State");
            Property(t => t.Country).HasColumnName("Country");
            Property(t => t.PostalCode).HasColumnName("PostalCode");
            Property(t => t.Phone).HasColumnName("Phone");
            Property(t => t.Fax).HasColumnName("Fax");
            Property(t => t.Email).HasColumnName("Email");
            Property(t => t.SupportRepId).HasColumnName("SupportRepId");

            // Relationships
            HasOptional(t => t.Employee)
                .WithMany(t => t.Customers)
                .HasForeignKey(d => d.SupportRepId);
        }
    }
}