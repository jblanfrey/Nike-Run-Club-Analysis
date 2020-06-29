classdef activityMapViewer < activityViewer
  %ACTIVITYMAPVIEWER Displays NRC activities such as runs on a map
  
  properties
    GeoplotAxis
    Line
  end
  
  properties (Access = private)
    
  end
  
  methods
    function view = activityMapViewer(parent, act)
      view = view@activityViewer(parent, act);

      % Graphics
      view.GeoplotAxis = geoaxes("Parent", parent);
      view.Line = geoplot(view.Activity.Latitude, view.Activity.Longitude, "Parent", view.GeoplotAxis);
    end
  end
  
  methods (Access = protected)
    function view = updateView(view, ~, ~)
      view.Line.LatitudeData = view.Activity.Latitude;
      view.Line.LongitudeData = view.Activity.Longitude;
    end
  end
end

