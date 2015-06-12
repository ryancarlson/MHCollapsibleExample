MHCollapsibleExample
==============
Collapsible View Manager example to eventually be used for MissionHub. The goal of these classes is to make a cocoapod and for subclassing these classes in MissionHub.

This is an example project showing the use of a collapsible view manager. 

Various classes make up this collapsible piece. Each one is described below.

FilterViewController
---
The FilterViewController has an array of managers with a manager corresponding to each TableView section.
It handles modals that will popup for certain types such as a survey question. The user would click a survey question and the modal (or "half modal") pops up depending on if it's a free form textfield or "checklist" (tableview) type. It also handles the button presses for Clear, Cancel and Save for the modals and itself. This class is meant to be subclassed to customize in the future and specifically for MissionHub to interact with the MH API.

The "half modal" is adding what would be a modal controller as a sub view controller and animating the view to appear with an overlay. This was done since a UIPicker and UITextField tend to be pretty small and don't need an entire full page modal. The modal cell types of "Checklist" meaning, more than one answer can be selected instead of a form free one, this type is a true modal since a full screen would be needed for so many potential options.

There are three buttons: Cancel, Clear and Save. Clear when just the filterviewcontroller is up will clear the data in all the managers. Clear when a modal is displayed will interact with the MHCollapsibleSection instead, the same with cancel and save.

MHCollapsibleViewManager
---
The MHCollapsibleViewManager keeps track of MHCollapsibleSections while also having the possibility to collapse it's corresponding "row" if it's a hierarchy.
A hierarchy would look like the following:
Surveys -> collapsible
Survey 1 -> collapsible
Survey Question 1 -> user interacts with modal by clicking the cell
...
A non hierarchy would look like:
Labels -> collapsible
Freshman -> just able to be "checked" or selected
Sophomore
...
Each of these produce MHCollapsibleSections, it's just the non hierarchy has one section while the hierarchy has one per collapsible piece (i.e. one per survey)

As far as passing data to the manager, the structure looks like:
Double array, with each array holding MHFilterLabels - There is a check if there is only one array as the first argument, if so it will treat it like the single array example below
If there is more than one array, then it is treated as a hierarchy like survey example above
Single array of filter labels - means non hierarchy like label example above

MHCollapsibleSection
---
Not a section like a table view section but more like a grouping of cells each with its own interaction. This class is the super delegate, it handles delegation and data source for tableview, picker delegation and textfield delegation. This is because the modal type can change depending on what interaction a selected cell should have and the section delegates what happens while the filterviewcontroller creates the "modal". The section contains an array of MHFilterLabels.

MHFilterLabel
---
The label entity corresponds to the row shown that can have modal interactions such as a survey question. The label has three important entities: array of results (static) array of mutable results (what user interacts with) array of keys. The user will interact with the modal and select results or clear them, etc. What they actually interact with is a mutable copy of the results. Only after they hit save will the mutable be copied over to the actual results so when they interact with that cell again they will see the results that were saved before. Clear simply clears out the mutable results on the modal.

MHTableViewCell
---
Four things can be customized for the look of this cell type:
AccessoryView
Text label color
Accessory Type
Selection Style

The cell keeps a default and clicked versions of each of the types and there is a method to toggle the look of the cell. The cell also has a enum for types to determine if the cell clicked should produce a specific modal (picker, tableview, textfield) or show collapse/expanding or produce a checkmark.

MHPackagedFilter
---
Whenever the filterviewcontroller is "Saved" with filter changes, all those changes get packaged into an array of MHPackagedFilters. This is a subclass (and extended root class) of MHKeyValuePair. MHPackagedFilter has it's own key value pair while having an array of key value pairs. These key value pairs can have the same keys, just different values.
For example (a non hierarchy filer)
Key: Label Value: Label
Array of key/value pairs:
Key: Label Value: Freshman
Key: Label Value: Sophomore
Key: Label Value: Junior

Hierarchy type:
Key: Survey Value: Question
Array of Key/values:
Key: How long have you been in America? Value: 6 months
Key: How long have you been in America? Value: 2 years

MHKeyValuePair
---
Since a NSDictionary with one key is kind of overkill for data purposes, this small class was made. It just has a key and value (both strings). There are methods to return the key or value and set the key or value.



