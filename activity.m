classdef activity
  properties (Access = private)
    Data
    Figure
  end
  
  properties (Dependent)
    Latitude
    Longitude
    Elevation
    Summary
  end
  
  methods
    function act = activity(filename)
      Data = load(filename);
      act.Data = Data.data;
    end
    
    function act = plotActivityMap(act)
      act.Figure = figure;
      act.Figure.MenuBar = 'none';
      act.Figure.NumberTitle = 'off';
      geoplot(act.Latitude, act.Longitude);
      act.Figure.Name = act.Data.tags.com_nike_name;
      
      s = act.Summary;
      t = milliseconds(act.Data.active_duration_ms);
      t.Format="hh:mm:ss";
      
      title("Distance: " + s.value(s.metric=="distance") + " km - " + ...
        "Average pace: " + s.value(s.metric=="pace") + " min/km - " + ...
        "Time: " + string(t));
    end
    
    function act = plotActivityMap3(act)
      uif = uifigure;
      g = geoglobe(uif);
      p = geoplot3(g, act.Latitude, act.Longitude, act.Elevation+1);
      p.Marker = 'o';
      p.LineWidth = 5;
    end
    
    function value = get.Latitude(act)
      value = [act.Data.metrics(10).values(:).value];
    end
    
    function value = get.Longitude(act)
      value = [act.Data.metrics(11).values(:).value];
    end
    
    function value = get.Elevation(act)
      value = [act.Data.metrics(7).values(:).value];
    end
    
    function value = get.Summary(act)
      value = struct2table(act.Data.summaries);
      value.metric = categorical(value.metric);
      value.summary = categorical(value.summary);
      value.source = [];
      value.app_id = [];
    end
  end
  
end