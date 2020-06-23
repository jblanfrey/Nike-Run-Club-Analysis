classdef activity
  properties (Access = private)
    Data
    Figure
  end
  
  properties
    Filename
  end
  
  properties (Dependent)
    Latitude
    Longitude
    Elevation
    Summary
    NickName
    DurationMS
  end
  
  methods
    function act = activity(filename)
      arguments
        filename (1,1) string = "data/activity-20200623-072233.mat"
      end
      act.Filename = filename;
      Data = load(filename);
      act.Data = Data.data;
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
    
    function value = get.NickName(act)
      value = act.Data.tags.com_nike_name;
    end
    
    function value = get.DurationMS(act)
      value = act.Data.active_duration_ms;
    end
  end
  
end