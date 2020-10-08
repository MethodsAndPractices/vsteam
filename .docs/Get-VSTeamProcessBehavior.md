<!-- #include "./common/header.md" -->

# Get-VSTeamWorkItemType

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamProcessBehavior.md" -->

## SYNTAX

## Description

In the user interface work items may be shown on multiple boards. In the Scrum process template, for example, Sprints shows the iteration backlog, and backlogs can select either features or backlog items. In Project Settings, under team configuration there is a list of Backlogs which can appear for any given team; Scrum offers and "Backlog items" as a "Requirement backlog and "Epics" and "Features" as "Portfolio Backlogs", although Epics are not displayed by default.  Some built-in WorkItem types are tied to particular backlogs, so the "Epic" and "Feature"  WorkItem types are tied to the "Epics" and "Features" porfolio backlogs respectively. .  
The "Product Backlog Item" type is tied to the "Backlog items" requirement backlog  and the "Task" type is tied to the "iteration backlog". In team settings the bug type can be linked to the  requirement backlog or the iteration backlog. There is only one of each of these all they can be renamed. Other portfolio backlogs can be created and user-defined work item types can be added to any backlog. 
The API describes the backlogs workitems appear on as workitem behaviors, and each process as a set of system behaviors and potentially user defined ones.  Get-VSTeamProcessBehavior lists these. 

## EXAMPLES

### Example 1

```powershell
Get-VSTeamProcessBehavior -ProcessTemplate Scrum
Rank Name          Workitem types       Inherits                        color  Description
---- ----          --------------       --------                        -----  -----------
40   Epics         Epic                 System.PortfolioBacklogBehavior FF7B00 Epic level ...
30   Features      Feature              System.PortfolioBacklogBehavior 773B93 Feature level... 
20   Backlog items Product Backlog Item System.OrderedBehavior          009CCC Requirement level...
10   Tasks         Task                 System.OrderedBehavior          F2CB1D Task level ...
0    Portfolio                          System.OrderedBehavior                 Portfolio ...
0    Ordered                                                                   Enables work items...
```

This shows the Backlogs for the the built-in Process template, "Scrum"


## PARAMETERS


### -ProcessTemplate

The Process template of interest; if not template is specified the template for the current project will be used.

```yaml
Type: String
Parameter Sets: Process
```

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES
<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
[Add-VSTeamWorkItemType](Add-VSTeamProcessBehavior.md)

[Remove-VSTeamWorkItemType](Remove-VSTeamProcessBehavior.md)

[Set-VSTeamWorkItemType](Set-VSTeamProcessBehavior.md)