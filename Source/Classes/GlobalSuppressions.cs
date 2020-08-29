// This file is used by Code Analysis to maintain SuppressMessage
// attributes that are applied to this project.
// Project-level suppressions either have no target or are given
// a specific target and scoped to a namespace, type, member, etc.

using System.Diagnostics.CodeAnalysis;

[assembly: SuppressMessage("Performance", "CA1813:Avoid unsealed attributes", Justification = "I need this file unsealed so my test project can derive from it to gain access to the protected method.", Scope = "type", Target = "~T:vsteam_lib.ProcessTemplateValidateAttribute")]
[assembly: SuppressMessage("Performance", "CA1813:Avoid unsealed attributes", Justification = "I need this file unsealed so my test project can derive from it to gain access to the protected method.", Scope = "type", Target = "~T:vsteam_lib.ProjectValidateAttribute")]
[assembly: SuppressMessage("Performance", "CA1813:Avoid unsealed attributes", Justification = "I need this file unsealed so my test project can derive from it to gain access to the protected method.", Scope = "type", Target = "~T:vsteam_lib.WorkItemTypeValidateAttribute")]
