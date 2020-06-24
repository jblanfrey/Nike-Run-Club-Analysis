classdef activityViewer
  %ACTIVITYVIEWER Displays NRC activities such as runs on a map
    
  properties
    Activity
    GeoplotAxis
  end
  
  methods
    function v = activityViewer(filename)
      arguments
        filename (1,1) string = "activity-20200623-072233.mat";
      end
      v.Activity = activity(filename);
    end
    
    function v = plotActivityMap(v, p)
      v.GeoplotAxis = geoplot(v.Activity.Latitude, v.Activity.Longitude, "Parent", p);
    end
    
%     function v = plotActivityMap3(v)
%       uif = uifigure;
%       g = geoglobe(uif);
%       p = geoplot3(g, act.Latitude, act.Longitude, act.Elevation+1);
%       p.Marker = 'o';
%       p.LineWidth = 5;
%     end
  end
end

