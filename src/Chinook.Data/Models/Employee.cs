using System;
using System.Collections.Generic;

namespace Chinook.Data.Models
{
    public partial class Employee
    {
        public Employee()
        {
            this.Customers = new List<Customer>();
            this.Employee1 = new List<Employee>();
        }

        public int EmployeeId { get; set; }
        public string LastName { get; set; }
        public string FirstName { get; set; }
        public string Title { get; set; }
        public Nullable<int> ReportsTo { get; set; }
        public Nullable<System.DateTime> BirthDate { get; set; }
        public Nullable<System.DateTime> HireDate { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string Country { get; set; }
        public string PostalCode { get; set; }
        public string Phone { get; set; }
        public string Fax { get; set; }
        public string Email { get; set; }
        public virtual ICollection<Customer> Customers { get; set; }
        public virtual ICollection<Employee> Employee1 { get; set; }
        public virtual Employee Employee2 { get; set; }
    }
}
