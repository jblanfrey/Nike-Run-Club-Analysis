classdef activityViewer < handle
  %ACTIVITYVIEWER Super Class - Viewer
  
  properties (Access = protected)
    Activity
    FileListener
    GridLayout
  end
  
  methods
    function view = activityViewer(parent, act)
      arguments
        parent = [];
        act (1,1) activity = activity("activity-20200623-072233.mat");
      end
      % Model
      view.Activity = act;
      
      % Graphics
      view.GridLayout = uigridlayout([2 1], "Parent", parent);
      
      % Listener
      view.FileListener = listener(act, "Filename", "PostSet", @view.updateView);
    end   
  end
  
  methods (Abstract, Access = protected)
    view = updateView(view);
  end
end