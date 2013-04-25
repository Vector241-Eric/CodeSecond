using System.Data.Entity.Migrations;

namespace Chinook.Data.Migrations
{
    public partial class Base : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Album",
                c => new
                         {
                             AlbumId = c.Int(nullable: false, identity: true),
                             Title = c.String(nullable: false, maxLength: 160),
                             ArtistId = c.Int(nullable: false),
                         })
                .PrimaryKey(t => t.AlbumId)
                .ForeignKey("dbo.Artist", t => t.ArtistId)
                .Index(t => t.ArtistId);

            CreateTable(
                "dbo.Artist",
                c => new
                         {
                             ArtistId = c.Int(nullable: false, identity: true),
                             Name = c.String(maxLength: 120),
                         })
                .PrimaryKey(t => t.ArtistId);

            CreateTable(
                "dbo.Track",
                c => new
                         {
                             TrackId = c.Int(nullable: false, identity: true),
                             Name = c.String(nullable: false, maxLength: 200),
                             AlbumId = c.Int(),
                             MediaTypeId = c.Int(nullable: false),
                             GenreId = c.Int(),
                             Composer = c.String(maxLength: 220),
                             Milliseconds = c.Int(nullable: false),
                             Bytes = c.Int(),
                             UnitPrice = c.Decimal(nullable: false, precision: 18, scale: 2),
                         })
                .PrimaryKey(t => t.TrackId)
                .ForeignKey("dbo.Album", t => t.AlbumId)
                .ForeignKey("dbo.Genre", t => t.GenreId)
                .ForeignKey("dbo.MediaType", t => t.MediaTypeId)
                .Index(t => t.AlbumId)
                .Index(t => t.GenreId)
                .Index(t => t.MediaTypeId);

            CreateTable(
                "dbo.Genre",
                c => new
                         {
                             GenreId = c.Int(nullable: false, identity: true),
                             Name = c.String(maxLength: 120),
                         })
                .PrimaryKey(t => t.GenreId);

            CreateTable(
                "dbo.InvoiceLine",
                c => new
                         {
                             InvoiceLineId = c.Int(nullable: false, identity: true),
                             InvoiceId = c.Int(nullable: false),
                             TrackId = c.Int(nullable: false),
                             UnitPrice = c.Decimal(nullable: false, precision: 18, scale: 2),
                             Quantity = c.Int(nullable: false),
                         })
                .PrimaryKey(t => t.InvoiceLineId)
                .ForeignKey("dbo.Invoice", t => t.InvoiceId)
                .ForeignKey("dbo.Track", t => t.TrackId)
                .Index(t => t.InvoiceId)
                .Index(t => t.TrackId);

            CreateTable(
                "dbo.Invoice",
                c => new
                         {
                             InvoiceId = c.Int(nullable: false, identity: true),
                             CustomerId = c.Int(nullable: false),
                             InvoiceDate = c.DateTime(nullable: false),
                             BillingAddress = c.String(maxLength: 70),
                             BillingCity = c.String(maxLength: 40),
                             BillingState = c.String(maxLength: 40),
                             BillingCountry = c.String(maxLength: 40),
                             BillingPostalCode = c.String(maxLength: 10),
                             Total = c.Decimal(nullable: false, precision: 18, scale: 2),
                         })
                .PrimaryKey(t => t.InvoiceId)
                .ForeignKey("dbo.Customer", t => t.CustomerId)
                .Index(t => t.CustomerId);

            CreateTable(
                "dbo.Customer",
                c => new
                         {
                             CustomerId = c.Int(nullable: false, identity: true),
                             FirstName = c.String(nullable: false, maxLength: 40),
                             LastName = c.String(nullable: false, maxLength: 20),
                             Company = c.String(maxLength: 80),
                             Address = c.String(maxLength: 70),
                             City = c.String(maxLength: 40),
                             State = c.String(maxLength: 40),
                             Country = c.String(maxLength: 40),
                             PostalCode = c.String(maxLength: 10),
                             Phone = c.String(maxLength: 24),
                             Fax = c.String(maxLength: 24),
                             Email = c.String(nullable: false, maxLength: 60),
                             SupportRepId = c.Int(),
                         })
                .PrimaryKey(t => t.CustomerId)
                .ForeignKey("dbo.Employee", t => t.SupportRepId)
                .Index(t => t.SupportRepId);

            CreateTable(
                "dbo.Employee",
                c => new
                         {
                             EmployeeId = c.Int(nullable: false, identity: true),
                             LastName = c.String(nullable: false, maxLength: 20),
                             FirstName = c.String(nullable: false, maxLength: 20),
                             Title = c.String(maxLength: 30),
                             ReportsTo = c.Int(),
                             BirthDate = c.DateTime(),
                             HireDate = c.DateTime(),
                             Address = c.String(maxLength: 70),
                             City = c.String(maxLength: 40),
                             State = c.String(maxLength: 40),
                             Country = c.String(maxLength: 40),
                             PostalCode = c.String(maxLength: 10),
                             Phone = c.String(maxLength: 24),
                             Fax = c.String(maxLength: 24),
                             Email = c.String(maxLength: 60),
                         })
                .PrimaryKey(t => t.EmployeeId)
                .ForeignKey("dbo.Employee", t => t.ReportsTo)
                .Index(t => t.ReportsTo);

            CreateTable(
                "dbo.MediaType",
                c => new
                         {
                             MediaTypeId = c.Int(nullable: false, identity: true),
                             Name = c.String(maxLength: 120),
                         })
                .PrimaryKey(t => t.MediaTypeId);

            CreateTable(
                "dbo.PlaylistTrack",
                c => new
                         {
                             Id = c.Int(nullable: false, identity: true),
                             PlaylistId = c.Int(nullable: false),
                             TrackId = c.Int(nullable: false),
                         })
                .PrimaryKey(t => t.Id)
                .ForeignKey("dbo.Playlist", t => t.PlaylistId)
                .ForeignKey("dbo.Track", t => t.TrackId)
                .Index(t => t.PlaylistId)
                .Index(t => t.TrackId);

            CreateTable(
                "dbo.Playlist",
                c => new
                         {
                             PlaylistId = c.Int(nullable: false, identity: true),
                             Name = c.String(maxLength: 120),
                         })
                .PrimaryKey(t => t.PlaylistId);
        }

        public override void Down()
        {
            DropIndex("dbo.PlaylistTrack", new[] {"TrackId"});
            DropIndex("dbo.PlaylistTrack", new[] {"PlaylistId"});
            DropIndex("dbo.Employee", new[] {"ReportsTo"});
            DropIndex("dbo.Customer", new[] {"SupportRepId"});
            DropIndex("dbo.Invoice", new[] {"CustomerId"});
            DropIndex("dbo.InvoiceLine", new[] {"TrackId"});
            DropIndex("dbo.InvoiceLine", new[] {"InvoiceId"});
            DropIndex("dbo.Track", new[] {"MediaTypeId"});
            DropIndex("dbo.Track", new[] {"GenreId"});
            DropIndex("dbo.Track", new[] {"AlbumId"});
            DropIndex("dbo.Album", new[] {"ArtistId"});
            DropForeignKey("dbo.PlaylistTrack", "TrackId", "dbo.Track");
            DropForeignKey("dbo.PlaylistTrack", "PlaylistId", "dbo.Playlist");
            DropForeignKey("dbo.Employee", "ReportsTo", "dbo.Employee");
            DropForeignKey("dbo.Customer", "SupportRepId", "dbo.Employee");
            DropForeignKey("dbo.Invoice", "CustomerId", "dbo.Customer");
            DropForeignKey("dbo.InvoiceLine", "TrackId", "dbo.Track");
            DropForeignKey("dbo.InvoiceLine", "InvoiceId", "dbo.Invoice");
            DropForeignKey("dbo.Track", "MediaTypeId", "dbo.MediaType");
            DropForeignKey("dbo.Track", "GenreId", "dbo.Genre");
            DropForeignKey("dbo.Track", "AlbumId", "dbo.Album");
            DropForeignKey("dbo.Album", "ArtistId", "dbo.Artist");
            DropTable("dbo.Playlist");
            DropTable("dbo.PlaylistTrack");
            DropTable("dbo.MediaType");
            DropTable("dbo.Employee");
            DropTable("dbo.Customer");
            DropTable("dbo.Invoice");
            DropTable("dbo.InvoiceLine");
            DropTable("dbo.Genre");
            DropTable("dbo.Track");
            DropTable("dbo.Artist");
            DropTable("dbo.Album");
        }
    }
}