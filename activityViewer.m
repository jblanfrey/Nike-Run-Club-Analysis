classdef activityViewer
  %ACTIVITYVIEWER Displays NRC activities such as runs on a map
    
  properties
    Activity
    ActivityMapView
  end
  
  methods
    function v = activityViewer(act)
      arguments
        act (1,1) activity = activity("data/activity-20200623-072233.mat");
      end
      v.Activity = act;
    end
    
    function v = plotActivityMap(v)
      ActivityMapView.Figure = figure;
      ActivityMapView.Figure.MenuBar = 'none';
      ActivityMapView.Figure.NumberTitle = 'off';
      
      act = v.Activity;
      geoplot(act.Latitude, act.Longitude);
      ActivityMapView.Figure.Name = act.NickName;
      
      s = act.Summary;
      t = milliseconds(act.DurationMS);
      t.Format="hh:mm:ss";
      
      title("Distance: " + s.value(s.metric=="distance") + " km - " + ...
        "Average pace: " + s.value(s.metric=="pace") + " min/km - " + ...
        "Time: " + string(t));
      
      v.ActivityMapView = ActivityMapView;
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

