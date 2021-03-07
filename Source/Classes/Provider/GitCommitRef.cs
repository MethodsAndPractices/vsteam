using System.Management.Automation;
using System.Xml.Serialization;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class GitCommitRef : Leaf
   {
      public GitUserDate Author { get; }
      public GitUserDate Committer { get; }
      public string Comment { get; set; }
      public string CommitId { get; set; }
      public string RemoteUrl { get; set; }
      public string Url { get; set; }
      [XmlAttribute("changeCounts.Add")]
      public long Adds { get; set; }
      [XmlAttribute("changeCounts.Edit")]
      public long Edits { get; set; }
      [XmlAttribute("changeCounts.Delete")]
      public long Deletes { get; set; }

      public GitCommitRef(PSObject obj, string projectName) :
         base(obj, obj.GetValue("comment"), obj.GetValue("commitId"), projectName)
      {
         this.Author = new GitUserDate(obj.GetValue<PSObject>("author"), projectName);
         this.Committer = new GitUserDate(obj.GetValue<PSObject>("committer"), projectName);
      }
   }
}
