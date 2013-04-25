using System.Data.Entity.ModelConfiguration;

namespace Chinook.Data.Models.Mapping
{
    public class EmployeeMap : EntityTypeConfiguration<Employee>
    {
        public EmployeeMap()
        {
            // Primary Key
            HasKey(t => t.EmployeeId);

            // Properties
            Property(t => t.LastName)
                .IsRequired()
                .HasMaxLength(20);

            Property(t => t.FirstName)
                .IsRequired()
                .HasMaxLength(20);

            Property(t => t.Title)
                .HasMaxLength(30);

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
                .HasMaxLength(60);

            // Table & Column Mappings
            ToTable("Employee");
            Property(t => t.EmployeeId).HasColumnName("EmployeeId");
            Property(t => t.LastName).HasColumnName("LastName");
            Property(t => t.FirstName).HasColumnName("FirstName");
            Property(t => t.Title).HasColumnName("Title");
            Property(t => t.ReportsTo).HasColumnName("ReportsTo");
            Property(t => t.BirthDate).HasColumnName("BirthDate");
            Property(t => t.HireDate).HasColumnName("HireDate");
            Property(t => t.Address).HasColumnName("Address");
            Property(t => t.City).HasColumnName("City");
            Property(t => t.State).HasColumnName("State");
            Property(t => t.Country).HasColumnName("Country");
            Property(t => t.PostalCode).HasColumnName("PostalCode");
            Property(t => t.Phone).HasColumnName("Phone");
            Property(t => t.Fax).HasColumnName("Fax");
            Property(t => t.Email).HasColumnName("Email");

            // Relationships
            HasOptional(t => t.Employee2)
                .WithMany(t => t.Employee1)
                .HasForeignKey(d => d.ReportsTo);
        }
    }
}