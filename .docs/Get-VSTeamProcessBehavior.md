<!-- #include "./common/header.md" -->

# Get-VSTeamProcessBehavior

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamProcessBehavior.md" -->

## SYNTAX

## Description

In the user interface, WorkItems are shown on boards. The API refers to them as WorkItem and Process Behaviours.

In settings for a project based on the  "Scrum" process template, for example, under team configuration  "Epics", "Features" and/or "Backlog items" can be selected as "Backlog Navigation Levels" to display, and a fourth board "Tasks" is always used for displaying Sprints.  Bugs can either be displayed either on the Tasks board (as part of the "Iteration backlog" in a sprint) or on the Backlog Items board (as part of the "requirement backlog"). Iteration and Requirement are two categories of backlog which only have one board. The third category, Portfolio backlogs contains Epics, Features and user-defined boards/behaviors

As well as bugs, other built-in WorkItem types are tied to a particular board, the Epic type is always on the Epics board, the Feature type on Features, the Task type on Tasks and the Product BackLog item Type on Backlog items. (In Agile-based templates, the board for the requirement backlog is named "Stories" and the WorkItems type is User Story, CMMI-Based ones call their requirements backlog "Requirements" and the workitem type a Requirement and templates based on Basic use a board named "Issues" and the Issue workItem type ). 

Other workitem types -in particular custom-defined ones are available to add to any of these boards. So a new workitem type named "Change" might appear with tasks, with requirements, with features, or on a portfolio board of its own. When two or more work item types are available on the same board, one type is selected as the default for new items added to the board. 

Get-VSTeamProcessBehavior lists the boards available in the process template. And Get-VSTeamWorkItemBehavior shows the boards an Item can appear on and whether it is the default for that board. 

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