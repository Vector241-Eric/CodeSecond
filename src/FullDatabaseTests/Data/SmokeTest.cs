using System;
using Chinook.Data;
using NUnit.Framework;
using System.Linq;

namespace FullDatabaseTests.Data
{
    public class SmokeTest
    {
        [TestFixture]
        public class When_always
        {
            [Test]
            public void Should_query_stuff()
            {
                var context = new ChinookContext();
                var albumCount = context.Albums.Count();
                Console.WriteLine("Found {0} albums", albumCount);
            }
        }
    }
}