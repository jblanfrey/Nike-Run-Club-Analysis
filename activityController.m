classdef activityController < handle
  %ACTIVITYCONTROLLER Controller to chose between activities
  
  properties (Access = private)
    Activity
  end
  
  properties
    GridLayout
    Listbox
  end
  
  methods
    function controller = activityController(parent,act)
      ds = fileDatastore("data", "ReadFcn",@load);
      listOfFiles = ds.Files;
      listOfFiles = extractBetween(listOfFiles, "activity-", ".mat");
      listOfFiles = listOfFiles(end:-1:1); %reverse order
      
      controller.GridLayout = uigridlayout([1 1], "Parent", parent, "Padding", 0);
      controller.Listbox = uilistbox(controller.GridLayout, 'Items', listOfFiles, 'ValueChangedFcn', @controller.updateController);
      
      % Load selected activity
      act.Filename = "activity-" + controller.Listbox.Value + ".mat";
      controller.Activity = act;      
    end
    
    function updateController(controller, src, ~)
      controller.Activity.Filename = "activity-" + src.Value + ".mat";
    end
  end
end

