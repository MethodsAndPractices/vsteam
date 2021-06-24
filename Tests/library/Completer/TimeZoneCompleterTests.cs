using Microsoft.VisualStudio.TestTools.UnitTesting;
using NSubstitute;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics.CodeAnalysis;
using System.Linq;

namespace vsteam_lib.Test
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class TimeZoneCompleterTests
   {
        private readonly Dictionary<string, string> _timeZones = new Dictionary<string, string>() {
            {"'W. Europe Standard Time'","(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna"},
            {"'Central Europe Standard Time'","(UTC+01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague"},
            {"'Middle East Standard Time'","(UTC+02:00) Beirut"},
            {"'Belarus Standard Time'","(UTC+03:00) Minsk"},
            {"'China Standard Time'","(UTC+08:00) Beijing, Chongqing, Hong Kong, Urumqi"},
            {"'AUS Eastern Standard Time'","(UTC+10:00) Canberra, Melbourne, Sydney"}
        };

        [TestMethod]
        public void TimeZoneCompleter_Exercise()
        {
            // Arrange
            var ps = BaseTests.PrepPowerShell();

            var target = new TimeZoneCompleter(ps);
            var fakeBoundParameters = new Dictionary<string, string>();

            // Act
            var actual = target.CompleteArgument(string.Empty, string.Empty, "be", null, fakeBoundParameters);

            // Assert
            Assert.AreEqual(_timeZones.Count, actual.Count());
            var e = actual.GetEnumerator();
            foreach (var timeZone in _timeZones)
            {
                e.MoveNext();
                Assert.AreEqual(timeZone.Key, e.Current.CompletionText, timeZone.Key);
                Assert.AreEqual(timeZone.Value, e.Current.ListItemText, timeZone.Value);
            }
        }
   }
}
