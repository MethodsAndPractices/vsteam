using System.Collections;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using System.Management.Automation.Abstractions;
using System.Management.Automation.Language;
using System.Runtime.CompilerServices;

[assembly: InternalsVisibleTo("vsteam-lib.Test")]

namespace vsteam_lib
{
   /// <summary>
   /// This base class if for completers that could be passed a 
   /// projct name.
   /// </summary>
   public abstract class BaseProjectCompleter : BaseCompleter
   {
      /// <summary>
      /// This constructor is used during unit testings
      /// </summary>
      /// <param name="powerShell">fake instance of IPowerShell used for testing</param>
      protected BaseProjectCompleter(IPowerShell powerShell) : base(powerShell) { }

      /// <summary>
      /// This constructor is used when running in a PowerShell session. It cannot be
      /// loaded in a unit test.
      /// </summary>
      [ExcludeFromCodeCoverage]
      protected BaseProjectCompleter() : base() { }

      /// <summary>
      /// Completers that need the project name to call the correct function must
      /// implement this overload of GetValue
      /// </summary>
      /// <param name="projectName">Name of the project to use</param>
      /// <returns>A list of strings</returns>
      internal abstract IEnumerable<string> GetValues(string projectName);

      /// <summary>
      /// Completers that need the project name to call the correct function must
      /// implement this overload of GetValue
      /// </summary>
      /// <param name="projectName">Name of the project to use</param>
      /// <returns>A list of strings</returns>
      //internal abstract IEnumerable<string> GetValues(string projectName);

      public override IEnumerable<CompletionResult> CompleteArgument(string commandName,
                                                                     string parameterName,
                                                                     string wordToComplete,
                                                                     CommandAst commandAst,
                                                                     IDictionary fakeBoundParameters)
      {
         var values = new List<CompletionResult>();

         // If the user has explicitly added the -ProjectName parameter
         // to the command use that instead of the default project.
         var projectName = fakeBoundParameters["ProjectName"]?.ToString();

         // Only use the default project if the ProjectName parameter was
         // not used
         if (string.IsNullOrEmpty(projectName))
         {
            projectName = Common.GetDefaultProject(this._powerShell);
         }

         // If there is no projectName by this point just return a empty
         // list.
         if (!string.IsNullOrEmpty(projectName))
         {
            SelectValues(wordToComplete, this.GetValues(projectName), values);
         }

         return values;
      }
   }
}
