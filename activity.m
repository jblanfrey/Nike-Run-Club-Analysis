classdef activity
  properties %(Access = private)
    Data
    Metrics
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
    Date
  end
  
  methods
    function act = activity(filename)
      arguments
        filename (1,1) string = "activity-20200623-072233.mat"
      end
      act.Filename = filename;
      Data = load("data/" + filename);
      act.Data = Data.data;
      Metrics = struct2table(act.Data.metrics);
      Metrics.type = categorical(Metrics.type);
      Metrics.unit = categorical(Metrics.unit);
      Metrics.source = [];
      Metrics.appId = [];
      act.Metrics = Metrics;
    end
    
    function value = get.Latitude(act)
      LatStruct = act.Metrics.values{act.Metrics.type=="latitude"};
      value = [LatStruct(:).value];
    end
    
    function value = get.Longitude(act)
      LonStruct = act.Metrics.values{act.Metrics.type=="longitude"};
      value = [LonStruct(:).value];
    end
    
    function value = get.Elevation(act)
      ElevStruct = act.Metrics.values{act.Metrics.type=="elevation"};
      value = [ElevStruct(:).value];
    end
    
    function value = get.Summary(act)
      value = struct2table(act.Data.summaries);
      value.metric = categorical(value.metric);
      value.summary = categorical(value.summary);
      value.source = [];
      value.app_id = [];
    end
    
    function value = get.NickName(act)
      try
        value = act.Data.tags.com_nike_name;
      catch
        value = act.Data.tags.com_nike_running_goaltype;
      end
    end
    
    function value = get.Date(act)
      Date = char(extractAfter(act.Filename, "activity-"));
      value = datetime(...
        str2num(Date(1:4)),...
        str2num(Date(5:6)),...
        str2num(Date(7:8)),...
        str2num(Date(10:11)),...
        str2num(Date(12:13)),...
        str2num(Date(14:15)));
    end
    
    function value = get.DurationMS(act)
      value = act.Data.active_duration_ms;
    end
  end
  
end