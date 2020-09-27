using System;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using System.Management.Automation.Abstractions;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class Package : Directory
   {
      public string ProtocolType { get; set; }
      public string NormalizedName { get; set; }
      public Guid Id { get; set; }
      public string Url { get; set; }
      public object Versions { get; set; }
      public Link Links { get; }

      public string FeedId { get; }

      /// <summary>
      /// Used for testing
      /// </summary>
      public Package(PSObject obj, string feedId, IPowerShell powerShell) :
         base(obj, obj.GetValue("name"), "Version", powerShell, null)
      {
         this.FeedId = feedId;

         if (obj.HasValue("_links"))
         {
            this.Links = new Link(obj);
         }
      }

      /// <summary>
      /// Used by PowerShell
      /// </summary>
      [ExcludeFromCodeCoverage]
      public Package(PSObject obj, string feedId) :
         this(obj, feedId, new PowerShellWrapper(RunspaceMode.CurrentRunspace))
      {
      }
   }
}