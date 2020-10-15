<!-- #include "./common/header.md" -->

# Get-VSTeamProcessBehavior

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamProcessBehavior.md" -->

## SYNTAX

## Description

In the user interface, WorkItems are shown on Boards. The API refers appearing on a board as a "Behavior".

In settings for a Project based on the "Scrum" process template, for example, under Team Configuration  "Epics", "Features" and/or "Backlog Items" can be selected as "Backlog Navigation Levels" to display, and a fourth board "Tasks" is always used for displaying Sprints.  Bugs can either be displayed either on the Tasks board (as part of the Iteration Backlog in a sprint) or on the Backlog-Items board (as part of the Requirement backlog). Iteration and Requirement are two categories of backlog which only have one board each. The third category of board, Portfolio backlogs, contains Epics, Features and user-defined boards/behaviors

As well as bugs, other built-in WorkItem types are tied to a particular Board, the Epic type is always on the Epics Board, the Feature type on Features, the Task type on Tasks and (in Scrum-based templates) the Product BackLog Item type on Backlog Items. (In Agile-based templates, the board for the requirement backlog is named "Stories" and the WorkItem type is "User Story", CMMI-Based ones call their requirements backlog "Requirements" and the WorkItem type a "Requirement" and templates based on Basic use a board named "Issues" and the "Issue" workItem type ).

Other workitem types -in particular custom-defined ones - are available to add to any of these boards. So a new WorkItem type named "Change" might appear with tasks, with requirements, with features, or on a Portfolio Backlog board of its own. When two or more WorkItem types are available on the same Board, one type is selected as the default for new items added to the Board.

Get-VSTeamProcessBehavior lists the boards available in a Process Template. And Get-VSTeamWorkItemBehavior shows the boards an items of a given WorkItem type can appear on and whether that type is the default for that board.

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

This shows the Backlogs for the the built-in Process Template, "Scrum"

## PARAMETERS

### -ProcessTemplate

The Process Template of interest; if no Template is specified the Template for the current Project will be used.

```yaml
Type: String
Parameter Sets: Process
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamProcessBehavior](Add-VSTeamProcessBehavior.md)

[Remove-VSTeamProcessBehavior](Remove-VSTeamProcessBehavior.md)

[Set-VSTeamProcessBehavior](Set-VSTeamProcessBehavior.md)